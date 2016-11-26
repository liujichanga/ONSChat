//
//  LoginViewController.m
//  ONSChat
//
//  Created by liujichang on 2016/11/21.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *registerBtnLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginBtnRightConstraint;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _registerBtnLeftConstraint.constant=(KKScreenWidth-2*120)/3;
    _loginBtnRightConstraint.constant=(KKScreenWidth-2*120)/3;
    
    if(KKStringIsNotBlank([KKSharedUserManager lastLoginUser].userId))
    {
        _userCodeTextField.text=[KKSharedUserManager lastLoginUser].userId;
    }
    
    if(KKStringIsNotBlank([KKSharedUserManager lastLoginUser].password))
    {
        _passwordTextField.text=[KKSharedUserManager lastLoginUser].password;
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (IBAction)registerClick:(id)sender {
    
    self.view.window.rootViewController=KKViewControllerOfMainSB(@"RegisterNavigationController");
    
}
- (IBAction)loginClick:(id)sender {
    if(KKStringIsBlank(_userCodeTextField.text)||KKStringIsBlank(_passwordTextField.text))
    {
        [SVProgressHUD showErrorWithStatus:@"账号密码不能为空" duration:2.0];
        return;
    }
    
    [SVProgressHUD show];
    
    //执行登录
    NSDictionary *para=@{@"loginname":_userCodeTextField.text,@"password":_passwordTextField.text,@"channel":ChannelId};
    [FSSharedNetWorkingManager GET:ServiceInterfaceLogin parameters:para progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *loginDic = (NSDictionary*)responseObject;
        KKLog(@"login:%@",loginDic);
        BOOL status1=[loginDic boolForKey:@"status" defaultValue:NO];
        if(status1)
        {
            [SVProgressHUD dismiss];
            
            KKUser *user=[[KKUser alloc] init];
            user.userId=_userCodeTextField.text;
            user.password=_passwordTextField.text;
            
            KKSharedUserManager.currentUser=user;
            
            [KKAppDelegate loginSucceed:loginDic];
        }
        else
        {
            [SVProgressHUD dismissWithError:[loginDic stringForKey:@"statusMsg" defaultValue:@"登录失败"] afterDelay:2.0];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismissWithError:KKErrorInfo(error) afterDelay:2.0];
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
