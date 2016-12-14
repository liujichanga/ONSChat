//
//  SetNewPasswordViewController.m
//  ONSChat
//
//  Created by 王磊 on 2016/12/14.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "SetNewPasswordViewController.h"

@interface SetNewPasswordViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordText;

@end

@implementation SetNewPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.passwordText.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
    self.passwordText.leftViewMode = UITextFieldViewModeAlways;
    self.confirmPasswordText.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
    self.confirmPasswordText.leftViewMode = UITextFieldViewModeAlways;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)OKBtnClick:(id)sender {
    [self.passwordText resignFirstResponder];
    [self.confirmPasswordText resignFirstResponder];
    
    if (self.passwordText.text.length==0) {
        [MBProgressHUD showMessag:@"请输入新密码" toView:nil];
    }else if (self.confirmPasswordText.text.length==0){
        [MBProgressHUD showMessag:@"请再次输入新密码" toView:nil];
    }else if (![self.passwordText.text isEqualToString:self.confirmPasswordText.text]){
         [MBProgressHUD showMessag:@"输入密码不一致" toView:nil];
    }else{
        NSString *uidStr;
        if (KKStringIsNotBlank(KKSharedCurrentUser.userId)) {
            uidStr = KKSharedCurrentUser.userId;
        }else if (KKStringIsNotBlank([KKSharedUserManager lastLoginUser].userId)){
            uidStr = [KKSharedUserManager lastLoginUser].userId;
        }else{
            [SVProgressHUD showErrorWithStatus:@"未注册账号" duration:1.2];
            return;
        }
        NSDictionary *param = @{@"loginname":uidStr,@"password":self.passwordText.text};
        [SVProgressHUD show];
        [FSSharedNetWorkingManager GET:ServiceInterfaceModifypassword parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *resp = (NSDictionary*)responseObject;
            KKLog(@"%@",resp);
            NSInteger status = [resp integerForKey:@"status"  defaultValue:0];
            if (status==1) {
                //更改用户密码
                if (KKStringIsNotBlank(KKSharedCurrentUser.userId)) {
                   KKSharedCurrentUser.password = self.passwordText.text;
                }else if (KKStringIsNotBlank([KKSharedUserManager lastLoginUser].userId)){
                   [KKSharedUserManager lastLoginUser].password = self.passwordText.text;
                }
                [SVProgressHUD dismissWithSuccess:@"修改成功" afterDelay:1.2];
            }else if (status==-1){
                [SVProgressHUD dismissWithError:@"未注册用户" afterDelay:1.2];
            }else{
                [SVProgressHUD dismissWithError:@"修改失败" afterDelay:1.2];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [SVProgressHUD dismissWithError:KKErrorInfo(error) afterDelay:1.2];
        }];
    }
}


@end
