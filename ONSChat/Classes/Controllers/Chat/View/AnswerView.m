//
//  AnswerView.m
//  ONSChat
//
//  Created by liujichang on 2016/12/7.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "AnswerView.h"

@implementation AnswerView


-(instancetype)initWithAnswer:(NSDictionary*)dic
{
    if(self=[super init])
    {
        self.backgroundColor=KKColorGray;
        
        CGFloat orginY=10;
        
        NSString *answerA=[dic stringForKey:@"answerA" defaultValue:@""];
        if(KKStringIsNotBlank(answerA))
        {
            NSArray *arr=[answerA componentsSeparatedByString:@"&-&"];
            if(arr.count>1)
            {
                ONSButtonPurple *btnA=[ONSButtonPurple ONSButtonWithTitle:arr[0] frame:CGRectMake(20, orginY, KKScreenWidth-40, 35)];
                [btnA addTarget:self action:@selector(answerClick:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:btnA];
                [btnA setTitle:arr[1] forState:UIControlStateDisabled];
                orginY+=35+20;
            }
        }
        
        NSString *answerB=[dic stringForKey:@"answerB" defaultValue:@""];
        if(KKStringIsNotBlank(answerB))
        {
            NSArray *arr=[answerB componentsSeparatedByString:@"&-&"];
            if(arr.count>1)
            {
                ONSButtonPurple *btnB=[ONSButtonPurple ONSButtonWithTitle:arr[0] frame:CGRectMake(20, orginY, KKScreenWidth-40, 35)];
                [btnB addTarget:self action:@selector(answerClick:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:btnB];
                [btnB setTitle:arr[1] forState:UIControlStateDisabled];
                orginY+=35+20;
            }
        }
        
        NSString *answerC=[dic stringForKey:@"answerC" defaultValue:@""];
        if(KKStringIsNotBlank(answerC))
        {
            NSArray *arr=[answerC componentsSeparatedByString:@"&-&"];
            if(arr.count>1)
            {
                ONSButtonPurple *btnC=[ONSButtonPurple ONSButtonWithTitle:arr[0] frame:CGRectMake(20, orginY, KKScreenWidth-40, 35)];
                [btnC addTarget:self action:@selector(answerClick:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:btnC];
                [btnC setTitle:arr[1] forState:UIControlStateDisabled];
                orginY+=35+20;
            }
        }
        
        NSString *answerD=[dic stringForKey:@"answerD" defaultValue:@""];
        if(KKStringIsNotBlank(answerD))
        {
            NSArray *arr=[answerD componentsSeparatedByString:@"&-&"];
            if(arr.count>1)
            {
                ONSButtonPurple *btnD=[ONSButtonPurple ONSButtonWithTitle:arr[0] frame:CGRectMake(20, orginY, KKScreenWidth-40, 35)];
                [btnD addTarget:self action:@selector(answerClick:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:btnD];
                [btnD setTitle:arr[1] forState:UIControlStateDisabled];
                orginY+=35+20;
            }
        }
        
        self.frame=CGRectMake(0, KKScreenHeight-orginY+10, KKScreenWidth, orginY+10);
        
    }
    
    return self;
}

-(void)answerClick:(UIButton*)sender{
    
    NSString *str=[sender titleForState:UIControlStateDisabled];
    
    if(_delegate) [_delegate answerViewTap:str];
    
    [self removeFromSuperview];
    
}



@end
