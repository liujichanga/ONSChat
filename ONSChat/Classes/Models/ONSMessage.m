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
         _content=[dic stringForKey:@"medirlist" defaultValue:@""];

     }
    
    return self;
}

@end
