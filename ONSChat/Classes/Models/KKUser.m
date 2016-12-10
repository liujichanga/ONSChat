//
//  KKUser.m
//  KuaiKuai
//
//  Created by jichang.liu on 15/6/26.
//  Copyright (c) 2015年 liujichang. All rights reserved.
//

#import "KKUser.h"

@implementation KKUser



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
        _height=[dic integerForKey:@"height" defaultValue:0];
        
        _dynamicsId=[dic stringForKey:@"dynamicsId" defaultValue:@""];

    }
    
    return self;
    
}

-(instancetype)initWithDicFull:(NSDictionary *)dic
{
    if (self = [super init])
    {
        
        NSDictionary *userDic = [dic objectForKey:@"user"];
        self.avatarUrlList = [dic objectForKey:@"avatarlist"];

        _userId=[userDic stringForKey:@"id" defaultValue:@""];
        _avatarUrl=[userDic stringForKey:@"avatar" defaultValue:@""];

        self.job = [userDic stringForKey:@"job" defaultValue:@""];
        self.income = [userDic stringForKey:@"income" defaultValue:@""];
        self.blood = [userDic stringForKey:@"blood" defaultValue:@""];
        self.weight = [userDic integerForKey:@"weight" defaultValue:0];
        self.astro = [userDic stringForKey:@"astro" defaultValue:@""];
        self.marry = [userDic stringForKey:@"marry" defaultValue:@""];
        self.hasHouse = [userDic stringForKey:@"house" defaultValue:@""];
        self.hasCar = [userDic boolForKey:@"car" defaultValue:NO];
        
        self.pos = [userDic stringForKey:@"pos" defaultValue:@""];
        self.lovetype = [userDic stringForKey:@"lovetype" defaultValue:@""];
        self.distanceLove = [userDic stringForKey:@"distance" defaultValue:@""];
        self.child = [userDic stringForKey:@"child" defaultValue:@""];
        self.livetog = [userDic stringForKey:@"livetog" defaultValue:@""];
        self.withparent = [userDic stringForKey:@"withparent" defaultValue:@""];
        self.hobby = [userDic stringForKey:@"hobby" defaultValue:@""];
        self.personality = [userDic stringForKey:@"personality" defaultValue:@""];
        
        self.ta_address = [userDic stringForKey:@"taAddress" defaultValue:@""];
        self.ta_age = [userDic stringForKey:@"taAge" defaultValue:@""];
        self.ta_income = [userDic stringForKey:@"taIncome" defaultValue:@""];
        self.ta_height = [userDic stringForKey:@"taHeight" defaultValue:@""];
        self.ta_graduate = [userDic stringForKey:@"taGraduate" defaultValue:@""];
        
        self.sign = [userDic stringForKey:@"sign" defaultValue:@""];
        self.age = [userDic integerForKey:@"age" defaultValue:0];
        self.nickName = [userDic stringForKey:@"nickname" defaultValue:@""];
        self.noticedToday = [userDic boolForKey:@"noticed" defaultValue:NO];
    }
    
    return self;
}

-(void)dealloc
{
    KKLog(@"user dealloc");
}


@end
