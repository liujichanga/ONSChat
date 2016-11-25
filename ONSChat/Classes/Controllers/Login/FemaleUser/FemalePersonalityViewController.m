//
//  FemalePersonalityViewController.m
//  ONSChat
//
//  Created by 王磊 on 2016/11/24.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "FemalePersonalityViewController.h"

//间隔
#define Interval KKScreenWidth*(8/320.0)
//高度
#define BtnH KKScreenWidth*(50/320.0)

@interface FemalePersonalityViewController ()

@property (nonatomic, strong) NSMutableArray *personalityArray;
@end

@implementation FemalePersonalityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.personalityArray = [NSMutableArray array];
    
    // Do any additional setup after loading the view.
    TopPageView *pageView = [TopPageView showPageViewWith:6];
    [self.view addSubview:pageView];
    
    ONSButton *finishBtn = [ONSButton ONSButtonWithTitle:@"提交" frame:CGRectMake(20, KKScreenHeight-80, KKScreenWidth-40, 40)];
    finishBtn.selected = YES;
    [finishBtn addTarget:self action:@selector(finishBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:finishBtn];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(10, pageView.frame.origin.y+pageView.frame.size.height+20, KKScreenWidth-20, 30)];
    titleLab.numberOfLines = 1;
    titleLab.textColor = KKColorPurple;
    titleLab.font = [UIFont systemFontOfSize:19];
    titleLab.text = @"美女的特点是什么呢？";
    [self.view addSubview:titleLab];
    
    //第一个选项的Y值
    CGFloat startY = titleLab.frame.origin.y+titleLab.frame.size.height+20;
    CGFloat btnW = (KKScreenWidth-4*Interval)/3.0;
    
    for (int i = 0; i<KKSharedGlobalManager.personalityArr.count; i++) {
        NSString *personalityStr = [KKSharedGlobalManager.personalityArr objectAtIndex:i];
        
        int v = i/3;//行
        int h = i%3;//列
        CGFloat btnX = Interval+((btnW+Interval)*h);
        CGFloat btnY = startY+((BtnH+Interval)*v);
        
        CGRect btnFrame = CGRectMake(btnX, btnY, btnW, BtnH);
        ONSButton *personalityBtn = [ONSButton ONSButtonWithTitle:personalityStr frame:btnFrame];
        [personalityBtn addTarget:self action:@selector(personalityBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:personalityBtn];
        [self.personalityArray addObject:personalityBtn];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)personalityBtnClick:(ONSButton*)btn{
    btn.selected = !btn.selected;
}

-(void)finishBtnClick{
    NSString *personalityStr;
    for (ONSButton* btn in self.personalityArray) {
        if (btn.selected==YES) {
            if (personalityStr.length==0) {
                personalityStr =btn.titleLabel.text;
            }else{
                personalityStr = [personalityStr stringByAppendingString:[NSString stringWithFormat:@",%@",btn.titleLabel.text]];
            }
        }
    }
    if (personalityStr.length==0) {
        [MBProgressHUD showMessag:@"请选择你的特点" toView:nil];
        return;
    }else{

        KKLog(@"personality %@",personalityStr);
        KKSharedUserManager.tempUser.personality = personalityStr;

    }
}

@end
