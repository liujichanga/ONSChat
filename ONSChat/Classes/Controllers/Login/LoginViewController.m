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
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (IBAction)registerClick:(id)sender {
}
- (IBAction)loginClick:(id)sender {
    if(KKStringIsBlank(_userCodeTextField.text)||KKStringIsBlank(_passwordTextField.text))
    {
        [SVProgressHUD showErrorWithStatus:@"账号密码不能为空"];
        return;
    }
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
