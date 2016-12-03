//
//  ONSChatManager.h
//  ONSChat
//
//  Created by liujichang on 2016/12/1.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KKSharedONSChatManager [ONSChatManager sharedChatManager]


@interface ONSChatManager : NSObject

+(instancetype)sharedChatManager;
+(void)releaseSingleton;

//接收到融云发来的信息
-(void)receiveMessage:(NSString *)textMessage;

//发送信息
-(BOOL)sendMessage:(NSDictionary*)dic;

@end
