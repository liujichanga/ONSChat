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
#define Plist_Key_SquareGymId @"Plist_Key_SquareGymId" //选中的广场id
#define Plist_Key_SquareGymName @"Plist_Key_SquareGymName" //选中的广场名称
#define Plist_key_FirstWeighting @"Plist_key_FirstWeighting" //判断第一次称重
#define Plist_Key_RemindCurTimeStamp @"Plist_Key_RemindCurTimeStamp" //当前提醒的最大时间戳
#define Plist_Key_FirstLookReport @"Plist_Key_FirstLookReport" //判断第一次查看运动评估报告demo
#define Plist_key_CourseBackgroundMusic @"Plist_key_Background_Music" //课程的背景音乐默认选择
#define Plist_key_ConnectedWatchUUID @"Plist_key_ConnectedWatchUUID" //已连接的腕表uuid
#define Plist_Key_WatchM4Version @"Plist_Key_WatchM4Version" //腕表的M4版本号
#define Plist_Key_WatchNordicVersion @"Plist_Key_WatchNordicVersion" //腕表的nordic版本号


+(instancetype)sharedLocalPlistManager;
+(void)releaseSingleton;



//增加或者更新数据，自动保存
-(void)setKKValue:(id)value forKey:(NSString*)key;

//删除数据,自动保存
-(void)removeKKValueForKey:(NSString*)key;

//读取数据
-(id)kkValueForKey:(NSString*)key;

@end
