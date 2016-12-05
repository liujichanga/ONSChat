//
//  ONSChat.h
//  ONSChat
//
//  Created by liujichang on 2016/12/1.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKTypeDefine.h"


@interface ONSMessage : NSObject

@property(assign,nonatomic) long long messageId;

@property(strong,nonatomic) NSString *targetId;
@property(assign,nonatomic) ONSMessageType messageType;
@property(assign,nonatomic) ONSReplyType replyType;
@property(assign,nonatomic) ONSMessageDirection messageDirection;
@property(strong,nonatomic) NSString *content;
@property(assign,nonatomic) long long time;//时间戳


-(instancetype)initWithDic:(NSDictionary*)dic;

@end
