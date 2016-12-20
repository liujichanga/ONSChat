//
//  ONSConversation.m
//  ONSChat
//
//  Created by liujichang on 2016/12/1.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "ONSConversation.h"

@implementation ONSConversation

-(instancetype)initWithDic:(NSDictionary *)dic
{
    if (self = [super init])
    {
        _targetId=[dic stringForKey:@"fromid" defaultValue:@""];
        _avatar=[dic stringForKey:@"avatar" defaultValue:@""];
        _nickName=[dic stringForKey:@"nickname" defaultValue:@""];
        _address=[dic stringForKey:@"address" defaultValue:@""];
        _age=[dic integerForKey:@"age" defaultValue:24];
       
        _eddevent=[dic stringForKey:@"eddevent" defaultValue:@""];
        _esendtxtevent=[dic stringForKey:@"esendtxtevent" defaultValue:@""];
        _ebillevent=[dic stringForKey:@"ebillevent" defaultValue:@""];
    }
    
    return self;
}

-(void)dealloc
{
    NSLog(@"%@ dealloc",[self class]);
}

-(void)setLastMessageId:(long long)lastMessageId
{
    _lastMessageId=lastMessageId;
    
//    KKWEAKSELF;
//    [ONSSharedMessageDao getMessageByMessageId:lastMessageId completion:^(id result) {
//
//        if(result)
//        {
//            ONSMessage *message=(ONSMessage*)result;
//            weakself.lastMessage=message;
//        }
//        else
//        {
//            weakself.lastMessage=nil;
//        }
//        
//    } inBackground:YES];
    
}




@end
