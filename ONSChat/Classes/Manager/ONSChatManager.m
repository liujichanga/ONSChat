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

-(void)receiveMessage:(NSDictionary *)dic
{
    
}

-(BOOL)sendMessage:(NSDictionary *)dic
{
    return NO;
}


@end
