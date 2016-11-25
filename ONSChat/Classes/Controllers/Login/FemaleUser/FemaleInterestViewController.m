//
//  FemaleInterestViewController.m
//  ONSChat
//
//  Created by 王磊 on 2016/11/24.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "FemaleInterestViewController.h"
#import "FemalePersonalityViewController.h"

//间隔
#define Interval KKScreenWidth*(8/320.0)
//高度
#define BtnH KKScreenWidth*(50/320.0)

@interface FemaleInterestViewController ()
//选项数组
@property (nonatomic, strong) NSMutableArray *interestArray;

@end

@implementation FemaleInterestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.interestArray = [NSMutableArray array];
    
    TopPageView *pageView = [TopPageView showPageViewWith:5];
    [self.view addSubview:pageView];
    
    ONSButtonPurple *nextStepBtn = [ONSButtonPurple ONSButtonWithTitle:@"下一步" frame:CGRectMake(20, KKScreenHeight-80, KKScreenWidth-40, 40)];
    [nextStepBtn addTarget:self action:@selector(nextStepBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextStepBtn];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(10, pageView.frame.origin.y+pageView.frame.size.height+20, KKScreenWidth-20, 30)];
    titleLab.numberOfLines = 1;
    titleLab.textColor = KKColorPurple;
    titleLab.font = [UIFont systemFontOfSize:19];
    titleLab.text = @"美女的兴趣爱好是什么呢？";
    [self.view addSubview:titleLab];
    
    //第一个选项的Y值
    CGFloat startY = titleLab.frame.origin.y+titleLab.frame.size.height+20;
    CGFloat btnW = (KKScreenWidth-4*Interval)/3.0;
   
    for (int i = 0; i<KKSharedGlobalManager.interestArr.count; i++) {
        NSString *interestStr = [KKSharedGlobalManager.interestArr objectAtIndex:i];
        
        int v = i/3;//行
        int h = i%3;//列
        CGFloat btnX = Interval+((btnW+Interval)*h);
        CGFloat btnY = startY+((BtnH+Interval)*v);
        
        CGRect btnFrame = CGRectMake(btnX, btnY, btnW, BtnH);
        ONSButton *interestBtn = [ONSButton ONSButtonWithTitle:interestStr frame:btnFrame];
        [interestBtn addTarget:self action:@selector(interestBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:interestBtn];
        [self.interestArray addObject:interestBtn];
    }
        
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)interestBtnClick:(ONSButton*)btn{
    
    btn.selected = !btn.selected;
}

-(void)nextStepBtnClick{
    NSString *hobbyStr;
    for (ONSButton* btn in self.interestArray) {
        if (btn.selected==YES) {
            if (hobbyStr.length==0) {
                hobbyStr =btn.titleLabel.text;
            }else{
                hobbyStr = [hobbyStr stringByAppendingString:[NSString stringWithFormat:@",%@",btn.titleLabel.text]];
            }
        }
    }
    if (hobbyStr.length==0) {
        [MBProgressHUD showMessag:@"请选择兴趣爱好" toView:nil];
        return;
    }else{

        KKLog(@"hobby %@",hobbyStr);        
        KKSharedUserManager.tempUser.hobby = hobbyStr;
        FemalePersonalityViewController *personality = KKViewControllerOfMainSB(@"FemalePersonalityViewController");
        [self.navigationController pushViewController:personality animated:YES];
    }
}


@end
