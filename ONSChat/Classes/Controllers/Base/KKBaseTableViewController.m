//
//  KKBaseTableViewController.m
//  KuaiKuai
//
//  Created by liujichang on 16/3/24.
//  Copyright © 2016年 liujichang. All rights reserved.
//

#import "KKBaseTableViewController.h"

@interface KKBaseTableViewController ()

@end

@implementation KKBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    KKLog(@"title:%@",self.navigationItem.title);

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //[MobClick beginLogPageView:self.navigationItem.title];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //[MobClick endLogPageView:self.navigationItem.title];
}


-(void)dealloc
{
    [SVProgressHUD dismiss];
    KKLog(@"%@ dealloc",[self class]);
}

@end
