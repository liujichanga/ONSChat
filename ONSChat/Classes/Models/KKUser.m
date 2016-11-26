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
    if(KKSharedCurrentUser.isMsg||KKSharedCurrentUser.isVIP||KKSharedCurrentUser.beannum>0)
        return YES;
    else return NO;
}


@end
