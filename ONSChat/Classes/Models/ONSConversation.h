//
//  ONSConversation.h
//  ONSChat
//
//  Created by liujichang on 2016/12/1.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ONSMessage.h"

@interface ONSConversation : NSObject

@property(assign,nonatomic) long long conversationId;

//目标id
@property(strong,nonatomic) NSString *targetId;
@property(strong,nonatomic) NSString *avatar;
@property(strong,nonatomic) NSString *nickName;
@property(strong,nonatomic) NSString *address;
@property(assign,nonatomic) NSInteger age;

//最后一条信息id
@property(assign,nonatomic) long long lastMessageId;
//未读数量
@property(assign,nonatomic) NSInteger unReadCount;
//时间戳
@property(assign,nonatomic) long long time;


//最后一条消息
//-(ONSMessage*)lastMessage;

@property(strong,nonatomic) ONSMessage *lastMessage;


-(instancetype)initWithDic:(NSDictionary*)dic;


@end
