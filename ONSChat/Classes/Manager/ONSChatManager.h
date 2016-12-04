//
//  ONSChatManager.h
//  ONSChat
//
//  Created by liujichang on 2016/12/1.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KKSharedONSChatManager [ONSChatManager sharedChatManager]

/**----------------chat相关的通知------------------*/
#define ONSChatManagerNotification_AddConversation @"ONSChatManagerNotification_AddConversation"
#define ONSChatManagerNotification_UpdateConversation @"ONSChatManagerNotification_UpdateConversation"
#define ONSChatManagerNotification_UnReadCount @"ONSChatManagerNotification_UnReadCount"





@interface ONSChatManager : NSObject

+(instancetype)sharedChatManager;
+(void)releaseSingleton;

@property(assign,nonatomic) NSTimeInterval lastTimeInterval;

//未读数量总数
@property(assign,nonatomic) NSInteger unReadCount;

//接收到融云发来的信息
-(void)receiveMessage:(NSString *)textMessage;

//发送信息
-(BOOL)sendMessage:(NSDictionary*)dic;

//读取未读总数
-(void)getUnReadCount;

@end
