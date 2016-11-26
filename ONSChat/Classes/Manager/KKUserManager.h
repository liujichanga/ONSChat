//
//  KKUserManager.h
//  KuaiKuai
//
//  Created by liujichang on 15/7/4.
//  Copyright (c) 2015年 liujichang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKUser.h"
#import "KKTypeDefine.h"




#define KKSharedUserManager [KKUserManager sharedUserManager]
#define KKSharedCurrentUser KKSharedUserManager.currentUser
#define KKSharedLoginActionManager KKSharedUserManager.loginActionManager
#define KKSharedDeviceWatch KKSharedUserManager.deviceWatch


@interface KKUserManager : NSObject



+(instancetype)sharedUserManager;
+(void)releaseSingleton;

//当前登录的用户
@property(strong,nonatomic) KKUser *currentUser;

//临时用户，未登录使用
@property(strong,nonatomic) KKUser *tempUser;

//自动登陆
@property(assign,nonatomic,getter=isAutoLoginEnabled) BOOL autoLoginEnabled;

//是否为新注册用户
@property(assign,nonatomic) BOOL isNewReisterUser;



//未读消息数量
@property(assign,nonatomic) NSInteger messageNumber;

//最后一次绑定的channelId
@property(strong,nonatomic) NSString *lastChannelId;

//客户端当前新消息最大ID
@property (assign, nonatomic) long long currentMaxMessageID;
//上次新消息最大ID
@property (nonatomic, assign) long long lastMaxMessageID;





//最后一个登录用户
-(KKUser*)lastLoginUser;

//给当前用户解析昵称、头像、性别基础信息
-(void)dictBaseCurUserInfo:(NSDictionary*)dict;

//给当前用户解析全部用户信息
-(void)dictFullCurUserInfo:(NSDictionary*)dict;

//判断用户基本信息是否齐全
- (BOOL)testUserInformationIsComplete;

@end
