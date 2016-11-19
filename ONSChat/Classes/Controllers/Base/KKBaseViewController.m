//
//  KKBaseViewController.m
//  KuaiKuai
//
//  Created by liujichang on 16/3/24.
//  Copyright © 2016年 liujichang. All rights reserved.
//

#import "KKBaseViewController.h"

@interface KKBaseViewController ()

//@property(strong,nonatomic) AFHTTPRequestOperation *requestOperation;

@end

@implementation KKBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    KKLog(@"title:%@",self.navigationItem.title);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
   // [MobClick beginLogPageView:self.navigationItem.title];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //[MobClick endLogPageView:self.navigationItem.title];
}

-(void)dealloc
{
    //如果当前有网络请求，取消掉
   // [self.requestOperation cancel];
    [SVProgressHUD dismiss];
    KKLog(@"%@ dealloc",[self class]);
}

@end
