//
//  OptionsView.m
//  ONSChat
//
//  Created by 王磊 on 2016/12/7.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "OptionsView.h"
//间隔
#define Interval KKScreenWidth*(5/320.0)
//高度
#define BtnH 30
@interface OptionsView()

@property (nonatomic, strong) NSMutableArray *optionBtnArr;

@end

@implementation OptionsView

-(instancetype)initWithFrame:(CGRect)frame andData:(NSArray*)optionArray{
    if (self = [super initWithFrame:frame]) {
        
        //第一个选项的Y值
        CGFloat startY = 0;
        CGFloat btnW = (KKScreenWidth-4*Interval)/3.0;
        CGFloat btnY = 0.0;
        for (int i = 0; i<optionArray.count; i++) {
            NSString *optionStr = [optionArray objectAtIndex:i];
            
            int v = i/3;//行
            int h = i%3;//列
            CGFloat btnX = Interval+((btnW+Interval)*h);
            btnY = startY+(BtnH*v);
            
            CGRect btnFrame = CGRectMake(btnX, btnY, btnW, BtnH);
            UIButton *optionBtn = [[UIButton alloc]initWithFrame:btnFrame];
            [optionBtn setTitle:optionStr forState:UIControlStateNormal];
            [optionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            optionBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            [optionBtn setImage:[UIImage imageNamed:@"abc_btn_check_to_on_mtrl_000"] forState:UIControlStateNormal];
            [optionBtn setImage:[UIImage imageNamed:@"abc_btn_check_to_on_mtrl_015"] forState:UIControlStateSelected];
            optionBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [optionBtn setBackgroundColor:[UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0) green:((float)arc4random_uniform(256) / 255.0) blue:((float)arc4random_uniform(256) / 255.0) alpha:1.0]];
            [optionBtn addTarget:self action:@selector(optionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:optionBtn];
        }
    }
    return self;
}

-(void)optionBtnClick:(UIButton*)btn{
    
    btn.selected = !btn.selected;

}
@end
