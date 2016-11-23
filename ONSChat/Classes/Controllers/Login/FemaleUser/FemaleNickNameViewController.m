//
//  FemaleNickNameViewController.m
//  ONSChat
//
//  Created by 王磊 on 2016/11/23.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "FemaleNickNameViewController.h"
#import "TopPageView.h"

@interface FemaleNickNameViewController ()

@end

@implementation FemaleNickNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    TopPageView *pageView = [TopPageView showPageViewWith:6 andFrame:CGRectMake(0, 64, KKScreenWidth, 60)];
    [self.view addSubview:pageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
