//
//  ONSWaitReply.m
//  ONSChat
//
//  Created by liujichang on 2016/12/7.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "ONSWaitReplyView.h"

@implementation ONSWaitReplyView

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self=[super initWithFrame:frame])
    {
        self.backgroundColor=[UIColor darkGrayColor];
        
        UILabel *textContentLabel = [[UILabel alloc] init];
        textContentLabel.numberOfLines = 1;
        textContentLabel.textColor = [UIColor darkTextColor];
        textContentLabel.textAlignment=NSTextAlignmentCenter;
        textContentLabel.text=@"<<请耐心等待TA的回答>>";
        [self addSubview:textContentLabel];
    }
    
    return self;
}

@end
