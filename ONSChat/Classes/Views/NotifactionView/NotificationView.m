//
//  NotificationView.m
//  ONSChat
//
//  Created by liujichang on 2016/11/22.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "NotificationView.h"

@interface NotificationView()

@property(strong,nonatomic) UILabel *textLabel;

@end

@implementation NotificationView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self.layer setMasksToBounds:YES];
        [self.layer setCornerRadius:3.0];
        
        self.backgroundColor=[UIColor colorWithRed:31.0/255.0 green:190.0/255.0 blue:203.0/255.0 alpha:1.0];
        
        UIImageView *notiImageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_msg"]];
        notiImageView.frame=CGRectMake(10, (frame.size.height-22)*0.5, 30, 22);
        notiImageView.contentMode=UIViewContentModeScaleAspectFill;
        notiImageView.clipsToBounds=YES;
        [self addSubview:notiImageView];
        
        UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, (frame.size.height-21)*0.5, frame.size.width-100, 21)];
        descLabel.text=@"";
        descLabel.textColor=[UIColor whiteColor];
        descLabel.font=[UIFont systemFontOfSize:15];
        self.textLabel=descLabel;
        [self addSubview:descLabel];
        
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"ic_msg_del"] forState:UIControlStateNormal];
        [btn setFrame:CGRectMake(frame.size.width-40, (frame.size.height-35)*0.5, 35, 35)];
        [btn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:gestureRecognizer];
    }
    return self;
}

-(void)setNotificationNum:(NSInteger)num
{
    self.textLabel.text=KKStringWithFormat(@"您有%ld条新消息，立即查看",num);
}

-(void)close
{
    [self removeFromSuperview];
}

-(void)tap:(id)sender
{
    
}


@end
