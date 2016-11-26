//
//  BindingPhoneNumberViewController.m
//  ONSChat
//
//  Created by 王磊 on 2016/11/26.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "BindingPhoneNumberViewController.h"
#import "UploadHeadImageViewController.h"
#import "DailyRecommandViewController.h"

// 重新获取验证码的等待时间
#define WaitSecond 60

@interface BindingPhoneNumberViewController ()<UITextFieldDelegate>
//手机号输入
@property (weak, nonatomic) IBOutlet UITextField *phoneNubText;
//验证码输入
@property (weak, nonatomic) IBOutlet UITextField *codeText;
//获取验证码按钮
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
//定时器
@property (strong, nonatomic) NSTimer *timer;
//倒计时秒数
@property (assign, nonatomic) int second;

@end

@implementation BindingPhoneNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.phoneNubText.delegate = self;
    self.phoneNubText.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    self.phoneNubText.leftViewMode =  UITextFieldViewModeAlways;
    
    self.codeText.delegate = self;
    self.codeText.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    self.codeText.leftViewMode =  UITextFieldViewModeAlways;
    
    [self.getCodeBtn.layer setMasksToBounds:YES];
    [self.getCodeBtn.layer setCornerRadius:3.0];
    [self.getCodeBtn.layer setBorderWidth:1.0];
    [self.getCodeBtn.layer setBorderColor:KKColorPurple.CGColor];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//获取验证码 验证手机格式
- (IBAction)getCodeBtnClick:(UIButton*)sender {
    if(![self.phoneNubText.text isMatchsRegex:KKRegexPhone])
    {
        [MBProgressHUD showMessag:@"请输入正确的手机号" toView:nil];
        return;
    }

    
    [self startCountdown];
}

//绑定手机 验证验证码格式
- (IBAction)bindingPhoneBtnClick:(id)sender {
    if (self.codeText.text.length==0||![self.codeText.text isMatchsRegex:KKRegexNub]) {
        [MBProgressHUD showMessag:@"请填写正确的验证码" toView:nil];
        return;
    }
    NSDictionary *param = @{@"mobile":self.phoneNubText.text,@"code":self.codeText.text,@"type":@(0)};
    [SVProgressHUD show];
    [FSSharedNetWorkingManager GET:ServiceInterfaceUserSendSmsCode parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *respDic = (NSDictionary*)responseObject;
        if (respDic&&respDic.count>0) {
            NSInteger status = [respDic integerForKey:@"status" defaultValue:0];
            if (status==1) {
               //下一步处理
                if(KKSharedCurrentUser.sex==KKFemale)
                {
                    //女性用户绑定完就消失了
                    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                }
                else
                {
                    //男性用户，可能是应用内付费的，需要pop，
                    //或者登陆验证的，需要继续后面流程，或者dismiss
                    if(self.isDismiss)
                    {
                        //如果头像没有上传
                        if(KKStringIsBlank(KKSharedCurrentUser.avatarUrl))
                        {
                            UploadHeadImageViewController *uploadVC = KKViewControllerOfMainSB(@"UploadHeadImageViewController");
                            [self.navigationController pushViewController:uploadVC animated:YES];
                        }
                        else if(KKSharedCurrentUser.dayFirst)
                        {
                            //需要显示每日推荐
                            DailyRecommandViewController *dailyVC = KKViewControllerOfMainSB(@"DailyRecommandViewController");
                            [self.navigationController pushViewController:dailyVC animated:YES];
                        }
                        else
                        {
                            //都不需要，消失
                            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                        }
                    }
                    else
                    {
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }
                }

            }else{
                //失败
                [SVProgressHUD dismissWithError:@"绑定失败，请重试" afterDelay:1.2];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismissWithError:KKErrorInfo(error) afterDelay:1.2];
    }];
}

#pragma mark - Timer selector
/** 开始倒计时 */
- (void)startCountdown {
    
    _getCodeBtn.enabled = NO;
    [self.getCodeBtn.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    _second = WaitSecond-1;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countdown:) userInfo:nil repeats:YES];
    
    NSString *title = KKStringWithFormat(@"%ds后重新发送", _second);
    [_getCodeBtn setTitle:title forState:UIControlStateDisabled];
}

/** 显示倒计时 */
- (void)countdown:(NSTimer *)timer {
    
    _second--;
    if (_second == 0) {
        [self stopCountdown];
    } else {
        NSString *title = KKStringWithFormat(@"%ds后重新发送", _second);
        [_getCodeBtn setTitle:title forState:UIControlStateDisabled];
    }
}

/** 停止倒计时 */
- (void)stopCountdown {
    [self.getCodeBtn.layer setBorderColor:KKColorPurple.CGColor];
    [_timer invalidate];
    _timer = nil;
    _getCodeBtn.enabled = YES;
}
@end
