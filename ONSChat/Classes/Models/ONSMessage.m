//
//  ONSChat.m
//  ONSChat
//
//  Created by liujichang on 2016/12/1.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "ONSMessage.h"

@implementation ONSMessage

-(instancetype)initWithDic:(NSDictionary *)dic
{
     if (self = [super init])
     {
         _targetId=[dic stringForKey:@"fromid" defaultValue:@""];
         _messageType=[dic integerForKey:@"msgtype" defaultValue:1];
         _replyType=[dic integerForKey:@"replytype" defaultValue:1];
         NSDictionary *contentDic=[dic objectForKey:@"medirlist"];
         if(contentDic&&[contentDic isKindOfClass:[NSDictionary class]])
         {
             _content=[contentDic JSONString];
         }
         //_content=[dic stringForKey:@"medirlist" defaultValue:@""];

     }
    
    return self;
}

-(void)calLayout
{
    _backGroundButtonFrame=CGRectMake(60, 10, KKScreenWidth-120, 80);
    _headButtonFrame=CGRectMake(MessageInterval, 40, 40, 40);
}


@end
