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
    instance.isLogined=NO;
    
    once = 0;
    instance = nil;
    KKSharedCurrentUser=nil;
    KKApplication.applicationIconBadgeNumber = 0;
    
    
}



/** 设置当前登陆用户的实例 */
- (void)setCurrentUser:(KKUser *)currentUser {
    
    // 此处保存到本地
    [KKUserDefaults setValue:currentUser.userName forKey:@"userName"];
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
    
    NSString *username = [KKUserDefaults stringForKey:@"userName"];
    NSString *password = [KKUserDefaults stringForKey:@"password"];
    
    KKUser *lastLoginUser=[[KKUser alloc] init];
    lastLoginUser.userName=username;
    lastLoginUser.password=password;
    
    return lastLoginUser;
}

-(void)dictBaseCurUserInfo:(NSDictionary *)dict
{
    KKSharedCurrentUser.headImgUrl=[dict stringForKey:@"headimgurl" defaultValue:@""];
    KKSharedCurrentUser.nickName=[dict stringForKey:@"name" defaultValue:@""];
    KKSharedCurrentUser.userUUID = [dict stringForKey:@"uuid" defaultValue:@""];
    KKSharedCurrentUser.userUUIDNoLine = [KKSharedCurrentUser.userUUID stringByReplacingOccurrencesOfString:@"-" withString:@""];
    KKSharedCurrentUser.sex=[dict integerForKey:@"sex" defaultValue:0];
    
    //移除所有本地通知
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    NSDictionary *profile = [dict objectForKey:@"profile"];
    if(profile)
    {
        [self dictFullCurUserInfo:profile];
    }
    
    [KKThredUtils runInGlobalQueue:^{
        
        if(!KKSharedCurrentUser.headImage)
        {
            NSString *imageKey=[[SDWebImageManager sharedManager] cacheKeyForURL:KKURLWithString(KKSharedCurrentUser.headImgUrl)];
            UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imageKey];
            if(image == nil) {
                NSURL *url = [NSURL URLWithString:KKSharedCurrentUser.headImgUrl];
                NSData *imageData = [NSData dataWithContentsOfURL:url];
                image = [UIImage imageWithData:imageData];
            }
            if(image) KKSharedCurrentUser.headImage=image;
        }
    }];
}

-(void)dictFullCurUserInfo:(NSDictionary *)dict
{
    //[self dictBaseCurUserInfo:dict];
    
    KKSharedCurrentUser.userCode=[dict stringForKey:@"user_code" defaultValue:@""];//邀请人ID
    KKSharedCurrentUser.sex=[dict integerForKey:@"sex" defaultValue:0];
    KKSharedCurrentUser.birthday=[dict stringForKey:@"birthday" defaultValue:@""];
    KKSharedCurrentUser.province=[dict stringForKey:@"province" defaultValue:@""];
    KKSharedCurrentUser.city=[dict stringForKey:@"city" defaultValue:@""];
    KKSharedCurrentUser.weight=[dict floatForKey:@"weight" defaultValue:0];
    
    KKSharedCurrentUser.height=[dict floatForKey:@"height" defaultValue:0];
    KKSharedCurrentUser.targetWeight = [dict floatForKey:@"target_weight" defaultValue:0];
    //兼容老版本，如果目标体重小于19，说明为老版本减重目标的值，这时修改为新版本目标体重
    if(KKSharedCurrentUser.targetWeight > 0 && KKSharedCurrentUser.targetWeight<19.0)KKSharedCurrentUser.targetWeight=KKSharedCurrentUser.weight-KKSharedCurrentUser.targetWeight;
    
    KKSharedCurrentUser.points =[dict integerForKey:@"points" defaultValue:0];
    KKSharedCurrentUser.pulse = [dict integerForKey:@"pulse" defaultValue:0];
    KKSharedCurrentUser.checkPrivacy = [dict integerForKey:@"is_topic_history_open" defaultValue:1];
    KKSharedCurrentUser.subscribe = [dict integerForKey:@"is_coachstar_popup" defaultValue:1];
    KKSharedCurrentUser.real_name = [dict stringForKey:@"real_name" defaultValue:@""];
    KKSharedCurrentUser.tele = [dict stringForKey:@"tele" defaultValue:@""];
    KKSharedCurrentUser.mail_name = [dict stringForKey:@"mail_name" defaultValue:@""];
    KKSharedCurrentUser.mail_city = [dict stringForKey:@"mail_city" defaultValue:@""];
    KKSharedCurrentUser.mail_province = [dict stringForKey:@"mail_province" defaultValue:@""];
    KKSharedCurrentUser.mail_tele = [dict stringForKey:@"mail_tele" defaultValue:@""];
    KKSharedCurrentUser.mail_address = [dict stringForKey:@"address" defaultValue:@""];
    //KKSharedCurrentUser.insurance_name = [dict stringForKey:@"insurance_name" defaultValue:@""];
    //KKSharedCurrentUser.insurance_tele = [dict stringForKey:@"insurance_tele" defaultValue:@""];
    KKSharedCurrentUser.insurance_id = [dict stringForKey:@"insurance_id" defaultValue:@""];
    KKSharedCurrentUser.type=[dict integerForKey:@"type" defaultValue:0];
    KKSharedCurrentUser.userUpdateProfile=[dict boolForKey:@"user_update_profile" defaultValue:NO];
    KKSharedCurrentUser.targetType=[dict integerForKey:@"target_type" defaultValue:KKTargetTypeNone];
    KKSharedCurrentUser.circleUserType=[dict integerForKey:@"circle_user_type" defaultValue:KKUserIdentifierTypeNormal];
    KKSharedCurrentUser.phase_init_weight = [dict floatForKey:@"phase_init_weight" defaultValue:0];
    KKSharedCurrentUser.courseVoiceType=[dict integerForKey:@"video_voice" defaultValue:0];
    
}

//判断用户基本信息是否齐全
- (BOOL)testUserInformationIsComplete
{
    if (KKSharedUserManager.isLogined) {
        if (KKStringIsBlank(KKSharedCurrentUser.birthday) || (KKSharedCurrentUser.weight <= 0) || (KKSharedCurrentUser.height <= 0) || (KKSharedCurrentUser.targetWeight <= 0)) {
            return NO;
        }else{
            return YES;
        }
    }else{
        if (KKStringIsBlank(KKSharedUserManager.tempUser.birthday) || (KKSharedUserManager.tempUser.weight <= 0) || (KKSharedUserManager.tempUser.height <= 0) || (KKSharedUserManager.tempUser.targetWeight <= 0)) {
            return NO;
        }else{
            return YES;
        }
    }
}

@end
