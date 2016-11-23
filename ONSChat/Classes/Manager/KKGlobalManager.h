//
//  KKGlobalManager.h
//  KuaiKuai
//
//  Created by liujichang on 16/1/12.
//  Copyright © 2016年 liujichang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMapLocationKit/AMapLocationKit.h>

@class KKResourceManager;

@interface KKGlobalManager : NSObject

#define KKSharedGlobalManager [KKGlobalManager sharedGlobalManager]


+(instancetype)sharedGlobalManager;
+(void)releaseSingleton;



//启动定位
-(void)locationGPS;

//职业范围
@property(strong,nonatomic) NSArray *jobArr;


@end
