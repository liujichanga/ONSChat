//
//  IdentifierViewController.m
//  ONSChat
//
//  Created by liujichang on 2016/12/12.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "IdentifierViewController.h"
#import "BaoYuePayViewController.h"


@interface IdentifierViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *cardidTextField;

@end

@implementation IdentifierViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)valide:(id)sender {
    
    if(KKStringIsNotBlank(_nameTextField.text)&&KKStringIsNotBlank(_cardidTextField.text))
    {
        if(KKSharedCurrentUser.beannum>=60)
        {
            [SVProgressHUD show];
            //减去60
            [FSSharedNetWorkingManager GET:ServiceInterfaceReduceBeanNum parameters:@{@"beannum":@(60)} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSDictionary *dic=(NSDictionary*)responseObject;
                KKLog(@"reduce:%@",dic);
                NSInteger status=[dic integerForKey:@"status" defaultValue:0];
                if(status==1)
                {
                    [SVProgressHUD dismiss];
                    
                    [KKSharedLocalPlistManager setKKValue:_nameTextField.text forKey:Plist_Key_IdentifierName];
                    [KKSharedLocalPlistManager setKKValue:_cardidTextField.text forKey:Plist_Key_IdentifierID];
                    
                    KKSharedCurrentUser.beannum-=60;
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else
                {
                    [SVProgressHUD dismissWithError:[dic stringForKey:@"statusDes" defaultValue:@"验证失败"] afterDelay:2.0];
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [SVProgressHUD dismissWithError:KKErrorInfo(error) afterDelay:2.0];
            }];
        }
        else
        {
            //去购买
            BaoYuePayViewController *baoyueVC=KKViewControllerOfMainSB(@"BaoYuePayViewController");
            baoyueVC.showBean=YES;
            [self.navigationController pushViewController:baoyueVC animated:YES];
        }
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"请填写完整信息" duration:2.0];
    }
    
}

@end
