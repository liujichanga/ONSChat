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



+(instancetype)sharedLocalPlistManager;
+(void)releaseSingleton;



//增加或者更新数据，自动保存
-(void)setKKValue:(id)value forKey:(NSString*)key;

//删除数据,自动保存
-(void)removeKKValueForKey:(NSString*)key;

//读取数据
-(id)kkValueForKey:(NSString*)key;

@end
