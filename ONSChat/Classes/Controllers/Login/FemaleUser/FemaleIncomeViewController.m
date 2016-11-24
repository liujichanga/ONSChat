//
//  FemaleIncomeViewController.m
//  ONSChat
//
//  Created by 王磊 on 2016/11/24.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "FemaleIncomeViewController.h"
#import "FemaleInterestViewController.h"

//间隔
#define Interval KKScreenWidth*(15/320.0)

@interface FemaleIncomeViewController ()

@end

@implementation FemaleIncomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    TopPageView *pageView = [TopPageView showPageViewWith:4];
    [self.view addSubview:pageView];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(10, pageView.frame.origin.y+pageView.frame.size.height+20, KKScreenWidth-20, 30)];
    titleLab.numberOfLines = 1;
    titleLab.textColor = KKColorPurple;
    titleLab.font = [UIFont systemFontOfSize:19];
    titleLab.text = @"美女，你的收入如何呢？";
    [self.view addSubview:titleLab];
    
    //第一个选项的Y值
    CGFloat startY = titleLab.frame.origin.y+titleLab.frame.size.height+20;
    //根据屏幕高度计算选项高度
    CGFloat btnH = (KKScreenHeight - startY-100-KKSharedGlobalManager.incomeArr.count*Interval)/(float)KKSharedGlobalManager.incomeArr.count;
    
    for (int i = 0; i < KKSharedGlobalManager.incomeArr.count; ++i) {
        NSString *incomeStr = [KKSharedGlobalManager.incomeArr objectAtIndex:i];
        CGRect incomeBtnFrame = CGRectMake(10, startY+(i*(btnH+Interval)), KKScreenWidth-20, btnH);
        
        ONSButton *incomeBtn = [ONSButton ONSButtonWithTitle:incomeStr frame:incomeBtnFrame];
        [incomeBtn addTarget:self action:@selector(jobBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:incomeBtn];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)jobBtnClick:(ONSButton*)incomeBtn{
    
    KKLog(@"income %@",incomeBtn.titleLabel.text);
    KKSharedUserManager.tempUser.income =incomeBtn.titleLabel.text;
    FemaleInterestViewController *interest = KKViewControllerOfMainSB(@"FemaleInterestViewController");
    [self.navigationController pushViewController:interest animated:YES];
}

@end
