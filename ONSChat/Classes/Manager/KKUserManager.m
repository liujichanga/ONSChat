//
//  KKUserManager.m
//  KuaiKuai
//
//  Created by liujichang on 15/7/4.
//  Copyright (c) 2015年 liujichang. All rights reserved.
//

#import "KKUserManager.h"

@implementation KKUserManager

@synthesize autoLoginEnabled=_autoLoginEnabled;
@synthesize lastChannelId=_lastChannelId;
@synthesize currentMaxMessageID = _currentMaxMessageID;


static dispatch_once_t once;
static KKUserManager *instance;

+ (instancetype)sharedUserManager {
    
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

-(instancetype)init
{
    if(self=[super init])
    {
        KKLog(@"UserManager init");
    }
    
    return self;
}

+ (void)releaseSingleton {
    
    
    instance.autoLoginEnabled = NO;
    instance.lastChannelId=@"";
    instance.isNewReisterUser=NO;
    
    once = 0;
    instance = nil;
    KKSharedCurrentUser=nil;
    KKApplication.applicationIconBadgeNumber = 0;
    
    
}



/** 设置当前登陆用户的实例 */
- (void)setCurrentUser:(KKUser *)currentUser {
    
    // 此处保存到本地
    [KKUserDefaults setValue:@(currentUser.userId) forKey:@"userid"];
    [KKUserDefaults setValue:currentUser.password forKey:@"password"];
    
    
    [KKUserDefaults synchronize];
    
    _currentUser = currentUser;
}



//最后一次绑定的channelid
-(void)setLastChannelId:(NSString *)lastChannelId
{
    _lastChannelId=lastChannelId;
    [KKUserDefaults setValue:lastChannelId forKey:@"lastChannelId"];
    [KKUserDefaults synchronize];
}

-(NSString *)lastChannelId
{
    _lastChannelId=[KKUserDefaults stringForKey:@"lastChannelId"];
    
    if(!_lastChannelId) _lastChannelId=@"";
    
    return _lastChannelId;
}


/** 是否开启了自动登录 */
- (BOOL)isAutoLoginEnabled {
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _autoLoginEnabled = [KKUserDefaults boolForKey:@"autoLoginEnabled"];
    });
    return _autoLoginEnabled;
}

/** 设置自动登录状态 */
- (void)setAutoLoginEnabled:(BOOL)autoLoginEnabled {
    
    if (_autoLoginEnabled != autoLoginEnabled) {
        [KKUserDefaults setBool:autoLoginEnabled forKey:@"autoLoginEnabled"];
        [KKUserDefaults synchronize];
    }
    
    _autoLoginEnabled = autoLoginEnabled;
}

//客户端新消息ID
- (void)setCurrentMaxMessageID:(long long)currentMaxMessageID{
   
    _currentMaxMessageID=currentMaxMessageID;
    
    [KKUserDefaults setValue:[NSNumber numberWithLongLong:currentMaxMessageID] forKey:@"currentMaxMessageID"];
    
    [KKUserDefaults synchronize];

}

-(long long)currentMaxMessageID{
    
    _currentMaxMessageID = [KKUserDefaults integerForKey:@"currentMaxMessageID"];

    return _currentMaxMessageID ;
}



/** 最后一个登录的用户 */
- (KKUser *)lastLoginUser {
    
    NSString *userid = [KKUserDefaults stringForKey:@"userid"];
    NSString *password = [KKUserDefaults stringForKey:@"password"];
    
    KKUser *lastLoginUser=[[KKUser alloc] init];
    lastLoginUser.userId=[userid longLongValue];
    lastLoginUser.password=password;
    
    return lastLoginUser;
}

-(void)dictBaseCurUserInfo:(NSDictionary *)dict
{
//    KKSharedCurrentUser.headImgUrl=[dict stringForKey:@"headimgurl" defaultValue:@""];
//    KKSharedCurrentUser.nickName=[dict stringForKey:@"name" defaultValue:@""];
//    KKSharedCurrentUser.userUUID = [dict stringForKey:@"uuid" defaultValue:@""];
//    KKSharedCurrentUser.userUUIDNoLine = [KKSharedCurrentUser.userUUID stringByReplacingOccurrencesOfString:@"-" withString:@""];
//    KKSharedCurrentUser.sex=[dict integerForKey:@"sex" defaultValue:0];
//    
//
//    NSDictionary *profile = [dict objectForKey:@"profile"];
//    if(profile)
//    {
//        [self dictFullCurUserInfo:profile];
//    }
//    
//    [KKThredUtils runInGlobalQueue:^{
//        
//        if(!KKSharedCurrentUser.headImage)
//        {
//            NSString *imageKey=[[SDWebImageManager sharedManager] cacheKeyForURL:KKURLWithString(KKSharedCurrentUser.headImgUrl)];
//            UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imageKey];
//            if(image == nil) {
//                NSURL *url = [NSURL URLWithString:KKSharedCurrentUser.headImgUrl];
//                NSData *imageData = [NSData dataWithContentsOfURL:url];
//                image = [UIImage imageWithData:imageData];
//            }
//            if(image) KKSharedCurrentUser.headImage=image;
//        }
//    }];
}

-(void)dictFullCurUserInfo:(NSDictionary *)dict
{
    //[self dictBaseCurUserInfo:dict];
    
    
}

//判断用户基本信息是否齐全
- (BOOL)testUserInformationIsComplete
{
    return NO;
}

@end
