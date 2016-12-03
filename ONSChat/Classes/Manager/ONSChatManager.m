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
        
        
    }
    
    return self;
}

-(void)receiveMessage:(NSString *)textMessage
{
    textMessage=@"{\"a\":\"dddwef\nabc\"}";
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
            
            [ONSSharedConversationDao getConversationByTargetId:conversation.targetId completion:^(id result) {
                
                if(result)
                {
                    //存在，添加message，更新conversation
                    NSLog(@"存在，先添加message，再更新conversation");
                    
                    ONSConversation *existConversation=(ONSConversation*)result;
                    
                    [ONSSharedMessageDao addMessage:message completion:^(BOOL success) {
                        
                        if(success)
                        {
                            //添加message成功
                            NSLog(@"add message succeed");
                            
                            existConversation.unReadCount+=1;
                            existConversation.avatar=conversation.avatar;
                            existConversation.address=conversation.address;
                            existConversation.nickName=conversation.nickName;
                            existConversation.age=conversation.age;
                            
                            [ONSSharedConversationDao updateConversation:existConversation completion:^(BOOL success) {
                                
                                if(success)
                                {
                                    //更新conversation成功
                                    NSLog(@"update conversation succeed");
                                    
                                }
                                else
                                {
                                    NSLog(@"update conversation faild");
                                }
                                
                            } inBackground:YES];
                        }
                        else
                        {
                            NSLog(@"add message failed");
                        }
                        
                    } inBackground:YES];
                }
                else
                {
                    //不存在，先添加message，再添加conversation
                    NSLog(@"不存在，先添加message，再添加conversation");
                    
                    [ONSSharedMessageDao addMessage:message completion:^(BOOL success) {
                        if(success)
                        {
                            //添加message成功
                            NSLog(@"add message succeed");
                            conversation.lastMessageId=message.messageId;
                            conversation.unReadCount=1;
                            
                            [ONSSharedConversationDao addConversation:conversation completion:^(BOOL success) {
                                
                                if(success)
                                {
                                    //添加conversation成功
                                    NSLog(@"add conversation succeed");
                                    
                                }
                                else
                                {
                                    NSLog(@"add conversation failed");
                                }
                                
                            } inBackground:YES];
                        }
                        else
                        {
                            NSLog(@"add message failed");
                        }
                    } inBackground:YES];
                    
                }
                
            } inBackground:YES];
        }
    }
    
   
}

-(BOOL)sendMessage:(NSDictionary *)dic
{
    
    
    
    return NO;
}


@end
