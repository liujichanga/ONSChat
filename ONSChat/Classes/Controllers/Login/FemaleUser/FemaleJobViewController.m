//
//  FemaleJobViewController.m
//  ONSChat
//
//  Created by 王磊 on 2016/11/24.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "FemaleJobViewController.h"
#import "FemaleHeightViewController.h"

//间隔
#define Interval KKScreenWidth*(8/320.0)


@interface FemaleJobViewController ()


@end

@implementation FemaleJobViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    TopPageView *pageView = [TopPageView showPageViewWith:2];
    [self.view addSubview:pageView];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(10, pageView.frame.origin.y+pageView.frame.size.height+20, KKScreenWidth-20, 30)];
    titleLab.numberOfLines = 1;
    titleLab.textColor = KKColorPurple;
    titleLab.font = [UIFont systemFontOfSize:19];
    titleLab.text = @"美女是做什么的呢？";
    [self.view addSubview:titleLab];
    
    //第一个选项的Y值
    CGFloat startY = titleLab.frame.origin.y+titleLab.frame.size.height+20;
    //根据屏幕高度计算选项高度
    CGFloat btnH = (KKScreenHeight - startY-20-KKSharedGlobalManager.jobArr.count*Interval)/(float)KKSharedGlobalManager.jobArr.count;
    
    for (int i = 0; i < KKSharedGlobalManager.jobArr.count; ++i) {
        NSString *jobStr = [KKSharedGlobalManager.jobArr objectAtIndex:i];
        CGRect jobBtnFrame = CGRectMake(10, startY+(i*(btnH+Interval)), KKScreenWidth-20, btnH);
        
        ONSButton *jobBtn = [ONSButton ONSButtonWithTitle:jobStr frame:jobBtnFrame];
        [jobBtn addTarget:self action:@selector(jobBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:jobBtn];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)jobBtnClick:(ONSButton*)jobBtn{
    
    KKLog(@"job %@",jobBtn.titleLabel.text);
    KKSharedUserManager.tempUser.job =jobBtn.titleLabel.text;
    FemaleHeightViewController *height = KKViewControllerOfMainSB(@"FemaleHeightViewController");
    [self.navigationController pushViewController:height animated:YES];
}

@end
