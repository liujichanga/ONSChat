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

//读取客服电话
-(void)getSPhone;
//客服电话
@property(strong,nonatomic) NSString *SPhone;

//读取支付方式，是否使用IAP
-(void)getIAP;
//iap
@property(assign,nonatomic) BOOL isIAP;

//当前用户相册图片的数量
-(NSInteger)getPhotosCount;
//资料完善程度
-(NSInteger)infoCompletedPercent:(KKUser *)user;


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
//体重范围
@property (nonatomic, strong) NSArray *weightArr;
//血型
@property (nonatomic, strong) NSArray *bloodArr;

//征友条件相关
//年龄范围
@property (nonatomic, strong) NSArray *ageArr;
//身高范围
@property (nonatomic, strong) NSArray *friendHeightArr;
//居住地
@property (nonatomic, strong) NSArray *addressArr;
//学历
@property (nonatomic, strong) NSArray *graduateArr;
@end
