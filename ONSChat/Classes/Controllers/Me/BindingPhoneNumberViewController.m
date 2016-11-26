//
//  BindingPhoneNumberViewController.m
//  ONSChat
//
//  Created by 王磊 on 2016/11/26.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "BindingPhoneNumberViewController.h"

// 重新获取验证码的等待时间
#define WaitSecond 5

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
    
    KKLog(@"绑定");
    
}

#pragma mark - Timer selector
/** 开始倒计时 */
- (void)startCountdown {
    
    _getCodeBtn.enabled = NO;
    [self.getCodeBtn.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    _second = WaitSecond;
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
