//
//  ForgetPasswordViewController.m
//  ONSChat
//
//  Created by 王磊 on 2016/12/14.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "SetNewPasswordViewController.h"

// 重新获取验证码的等待时间
#define WaitSecond 60

@interface ForgetPasswordViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UITextField *codeText;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
//定时器
@property (strong, nonatomic) NSTimer *timer;
//倒计时秒数
@property (assign, nonatomic) int second;
//验证码
@property (nonatomic, strong) NSString *smsCodeStr;
@end

@implementation ForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.phoneText.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    self.phoneText.leftViewMode =  UITextFieldViewModeAlways;
    
    self.codeText.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    self.codeText.leftViewMode =  UITextFieldViewModeAlways;
    
    [self.codeBtn.layer setMasksToBounds:YES];
    [self.codeBtn.layer setCornerRadius:3.0];
    [self.codeBtn.layer setBorderWidth:1.0];
    [self.codeBtn.layer setBorderColor:KKColorPurple.CGColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)codeBtnClick:(id)sender {
    [self.phoneText resignFirstResponder];
    if(![self.phoneText.text isMatchsRegex:KKRegexPhone])
    {
        [MBProgressHUD showMessag:@"请输入正确的手机号" toView:nil];
        return;
    }
    //获取1到x之间的整数的代码如下:
    int value = (arc4random() % 899999) + 100000;
    self.smsCodeStr = [NSString stringWithFormat:@"%zd",value];
    NSDictionary *param = @{@"mobile":self.phoneText.text,@"content":self.smsCodeStr};
    [FSSharedNetWorkingManager GET:ServiceInterfaceUserSendSmsCode parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSInteger status = [respDic integerForKey:@"status" defaultValue:0];
        if (status==1) {
            [SVProgressHUD showSuccessWithStatus:@"发送成功" duration:1.2];
            [self startCountdown];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"发送失败" duration:1.2];
    }];
}
- (IBAction)nextStepBtnClcik:(id)sender {
    [self.codeText resignFirstResponder];
//    if (self.codeText.text.length==0||![self.codeText.text isEqualToString:self.smsCodeStr]) {
//        [MBProgressHUD showMessag:@"请填写正确的验证码" toView:nil];
//        return;
//    }
    SetNewPasswordViewController *newPassword = KKViewControllerOfMainSB(@"SetNewPasswordViewController");
    [self.navigationController pushViewController:newPassword animated:YES];

}

#pragma mark - Timer selector
/** 开始倒计时 */
- (void)startCountdown {
    
    _codeBtn.enabled = NO;
    [self.codeBtn.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    _second = WaitSecond-1;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countdown:) userInfo:nil repeats:YES];
    
    NSString *title = KKStringWithFormat(@"%ds后重新发送", _second);
    [_codeBtn setTitle:title forState:UIControlStateDisabled];
}

/** 显示倒计时 */
- (void)countdown:(NSTimer *)timer {
    
    _second--;
    if (_second == 0) {
        [self stopCountdown];
    } else {
        NSString *title = KKStringWithFormat(@"%ds后重新发送", _second);
        [_codeBtn setTitle:title forState:UIControlStateDisabled];
    }
}

/** 停止倒计时 */
- (void)stopCountdown {
    [self.codeBtn.layer setBorderColor:KKColorPurple.CGColor];
    [_timer invalidate];
    _timer = nil;
    _codeBtn.enabled = YES;
}
@end
