//
//  KKUser.m
//  KuaiKuai
//
//  Created by jichang.liu on 15/6/26.
//  Copyright (c) 2015年 liujichang. All rights reserved.
//

#import "KKUser.h"

@implementation KKUser


-(BOOL)isPayUser
{
    if(KKSharedCurrentUser.isBaoYue||KKSharedCurrentUser.isVIP||KKSharedCurrentUser.beannum>0)
        return YES;
    else return NO;
}

-(instancetype)initWithDicSimple:(NSDictionary *)dic
{
    if (self = [super init])
    {
        _userId=[dic stringForKey:@"id" defaultValue:@""];
        _avatarUrl=[dic stringForKey:@"avatar" defaultValue:@""];
        _isliked=[dic boolForKey:@"liked" defaultValue:NO];
        _address=[dic stringForKey:@"address" defaultValue:@""];
        _age=[dic integerForKey:@"age" defaultValue:0];
        _nickName=[dic stringForKey:@"nickname" defaultValue:@""];
        
       
    }
    
    return self;
    
}

-(instancetype)initWithDicFull:(NSDictionary *)dic
{
    if (self = [super init])
    {
        
        
    }
    
    return self;
}



@end
