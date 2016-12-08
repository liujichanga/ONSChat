//
//  ONSChatManager.m
//  ONSChat
//
//  Created by liujichang on 2016/12/1.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "ONSChatManager.h"

@implementation ONSChatManager


static dispatch_once_t once;
static ONSChatManager *instance;

+ (instancetype)sharedChatManager {
    
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
        
    });
    
    return instance;
}

+ (void)releaseSingleton {
    
    once = 0;
    instance = nil;
    
}

-(instancetype)init
{
    if(self=[super init])
    {
        _unReadCount=0;
        
    }
    
    return self;
}

-(void)receiveMessage:(NSString *)textMessage
{
    if([[NSDate date] timeIntervalSince1970] - self.lastTimeInterval < 0.5)
    {
        //NSLog(@"time:%f",[[NSDate date] timeIntervalSince1970]);
        [NSThread sleepForTimeInterval:0.5];
        //NSLog(@"time:%f",[[NSDate date] timeIntervalSince1970]);
    }
    self.lastTimeInterval=[[NSDate date] timeIntervalSince1970];
    
    //替换消息里面的换行符
    textMessage = [textMessage stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
    NSDictionary *dic=[textMessage objectFromJSONString];
    if(dic&&[dic isKindOfClass:[NSDictionary class]])
    {
        NSArray *dataArr=[dic objectForKey:@"aaData"];
        if(dataArr&&[dataArr isKindOfClass:[NSArray class]]&&dataArr.count>0)
        {
            NSDictionary *dataDic=dataArr[0];
            
            NSLog(@"new message");
            
            ONSConversation *conversation=[[ONSConversation alloc] initWithDic:dataDic];
            
            ONSMessage *message=[[ONSMessage alloc] initWithDic:dataDic];
            message.messageDirection=ONSMessageDirection_RECEIVE;
            
            //接收到消息callback
            NSDictionary *callDic=@{@"fromId":message.targetId,@"toId":KKSharedCurrentUser.userId,@"taskid":[dic stringForKey:@"taskid" defaultValue:@""],@"indexid":[dic stringForKey:@"indexid" defaultValue:@""],@"content":message.content,@"type":@(message.messageType)};
            [FSSharedNetWorkingManager POST:ServiceInterfaceMessageSendback parameters:callDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSDictionary *respDic=(NSDictionary*)responseObject;
                KKLog(@"sendback:%@",respDic);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
            
            //添加消息
            [ONSSharedMessageDao addMessage:message completion:^(BOOL success) {
                
                if(success)
                {
                    //添加message成功
                    NSLog(@"add message succeed");
                    [KKNotificationCenter postNotificationName:ONSChatManagerNotification_AddMessage object:nil];
                    
                    [ONSSharedConversationDao getConversationByTargetId:conversation.targetId completion:^(id result) {
                        
                       if(result)
                       {
                           //存在此会话，更新会话
                           NSLog(@"存在此会话,更新conversation");
                           ONSConversation *existConversation=(ONSConversation*)result;
                           
                           existConversation.unReadCount+=1;
                           existConversation.avatar=conversation.avatar;
                           existConversation.address=conversation.address;
                           existConversation.nickName=conversation.nickName;
                           existConversation.age=conversation.age;
                           existConversation.lastMessageId=message.messageId;
                           
                           [ONSSharedConversationDao updateConversation:existConversation completion:^(BOOL success) {
                               
                               if(success)
                               {
                                   //更新conversation成功
                                   NSLog(@"update conversation succeed");
                                   [KKNotificationCenter postNotificationName:ONSChatManagerNotification_UpdateConversation object:nil];
                                   
                                   //更新未读数量
                                   [self getUnReadCount];
                               }
                               else
                               {
                                   NSLog(@"update conversation faild");
                               }
                               
                           } inBackground:YES];
                       }
                        else
                        {
                            //不存在此会话，添加会话
                            NSLog(@"不存在此会话，添加conversation");
                            
                            conversation.lastMessageId=message.messageId;
                            conversation.unReadCount=1;
                            
                            [ONSSharedConversationDao addConversation:conversation completion:^(BOOL success) {
                                
                                if(success)
                                {
                                    //添加conversation成功
                                    NSLog(@"add conversation succeed");
                                    [KKNotificationCenter postNotificationName:ONSChatManagerNotification_AddConversation object:nil];
                                    
                                    //更新未读数量
                                    [self getUnReadCount];
                                }
                                else
                                {
                                    NSLog(@"add conversation failed");
                                }
                                
                            } inBackground:YES];
                        }
                        
                        
                    } inBackground:NO];
                }
                else
                {
                    NSLog(@"add message failed");
                }
                
            } inBackground:YES];
            
        }
    }
   
}

-(void)sendMessage:(NSDictionary *)dic
{
    ONSConversation *conversation=[[ONSConversation alloc] initWithDic:dic];
    ONSMessage *message=[[ONSMessage alloc] initWithDic:dic];
    message.messageDirection=ONSMessageDirection_SEND;
    
    //添加消息
    [ONSSharedMessageDao addMessage:message completion:^(BOOL success) {
        
        if(success)
        {
            //添加message成功
            NSLog(@"add message succeed");
            [KKNotificationCenter postNotificationName:ONSChatManagerNotification_AddMessage object:nil];

            [ONSSharedConversationDao getConversationByTargetId:conversation.targetId completion:^(id result) {
                
                if(result)
                {
                    //存在此会话，更新会话
                    NSLog(@"存在此会话,更新conversation");
                    ONSConversation *existConversation=(ONSConversation*)result;
                    
                    existConversation.avatar=conversation.avatar;
                    existConversation.address=conversation.address;
                    existConversation.nickName=conversation.nickName;
                    existConversation.age=conversation.age;
                    existConversation.lastMessageId=message.messageId;
                    
                    [ONSSharedConversationDao updateConversation:existConversation completion:^(BOOL success) {
                        
                        if(success)
                        {
                            //更新conversation成功
                            NSLog(@"update conversation succeed");
                            [KKNotificationCenter postNotificationName:ONSChatManagerNotification_UpdateConversation object:nil];
                            
                            //更新未读数量
                            [self getUnReadCount];
                        }
                        else
                        {
                            NSLog(@"update conversation faild");
                        }
                        
                    } inBackground:YES];
                }
                else
                {
                    //不存在此会话，添加会话
                    NSLog(@"不存在此会话，添加conversation");
                    
                    conversation.lastMessageId=message.messageId;
                    conversation.unReadCount=0;
                    
                    [ONSSharedConversationDao addConversation:conversation completion:^(BOOL success) {
                        
                        if(success)
                        {
                            //添加conversation成功
                            NSLog(@"add conversation succeed");
                            [KKNotificationCenter postNotificationName:ONSChatManagerNotification_AddConversation object:nil];
                            
                            //更新未读数量
                            [self getUnReadCount];
                        }
                        else
                        {
                            NSLog(@"add conversation failed");
                        }
                        
                    } inBackground:YES];
                }
                
                
            } inBackground:NO];
        }
        else
        {
            NSLog(@"add message failed");
        }
        
    } inBackground:YES];

}

-(void)getUnReadCount
{
    KKWEAKSELF;
    [ONSSharedConversationDao getConversationUnReadCountCompletion:^(id result) {
        if(result)
        {
            NSNumber *num=(NSNumber*)result;
            [KKNotificationCenter postNotificationName:ONSChatManagerNotification_UnReadCount object:num];
            
            weakself.unReadCount=[num integerValue];
        }
    } inBackground:YES];
}


@end
