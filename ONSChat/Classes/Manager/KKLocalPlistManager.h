//
//  KKLocalPlistManager.h
//  KuaiKuai
//
//  Created by liujichang on 16/3/1.
//  Copyright © 2016年 liujichang. All rights reserved.
//  持久化到本地的plist文件 按照用户区分的，未登录用户有一份公用的

#import <Foundation/Foundation.h>

@interface KKLocalPlistManager : NSObject


#define KKSharedLocalPlistManager [KKLocalPlistManager sharedLocalPlistManager]


//在这里定义会用到的key
#define Plist_Key_Avatar @"Plist_Key_Avatar" //头像名称
#define Plist_Key_Photo1 @"Plist_Key_Photo1" //相册1
#define Plist_Key_Photo2 @"Plist_Key_Photo2" //相册1
#define Plist_Key_Photo3 @"Plist_Key_Photo3" //相册1
#define Plist_Key_IdentifierName @"Plist_Key_IdentifierName" //身份信息
#define Plist_Key_IdentifierID @"Plist_Key_IdentifierID" //身份信息
#define Plist_Key_CustomHi @"Plist_Key_CustomHi" //自定义打招呼


//iap相关的
#define Plist_Key_BeanNum @"Plist_Key_BeanNum" //红豆数量
#define Plist_Key_VIPEndTime @"Plist_Key_VIPEndTime" //红豆数量
#define Plist_Key_BaoYueEndTime @"Plist_Key_BaoYueEndTime" //红豆数量




+(instancetype)sharedLocalPlistManager;
+(void)releaseSingleton;



//增加或者更新数据，自动保存
-(void)setKKValue:(id)value forKey:(NSString*)key;

//删除数据,自动保存
-(void)removeKKValueForKey:(NSString*)key;

//读取数据
-(id)kkValueForKey:(NSString*)key;

-(NSString*)kkStringForKey:(NSString*)key;

-(NSInteger)kkIntergerForKey:(NSString*)key;

-(long long)kkLongForKey:(NSString*)key;

-(BOOL)kkBoolForKey:(NSString*)key;


@end
