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

//程序定位到的省
@property(strong,nonatomic) NSString *GPSProvince;
//程序定位的城市
@property(strong,nonatomic) NSString *GPSCity;

//表情数组
@property(strong,nonatomic) NSArray *emoticons;

//职业范围
@property(strong,nonatomic) NSArray *jobArr;
//身高范围
@property (nonatomic, strong) NSArray *heightArr;
//收入范围
@property (nonatomic, strong) NSArray *incomeArr;
//兴趣爱好
@property (nonatomic, strong) NSArray *interestArr;
//个人特点
@property (nonatomic, strong) NSArray *personalityArr;




@end
