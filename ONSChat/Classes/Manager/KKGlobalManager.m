//
//  KKGlobalManager.m
//  KuaiKuai
//
//  Created by liujichang on 16/1/12.
//  Copyright © 2016年 liujichang. All rights reserved.
//

#import "KKGlobalManager.h"
#import "ChatViewController.h"
#import "RecommendUserInfoViewController.h"


@interface KKGlobalManager()

@property (strong, nonatomic) AMapLocationManager *aMapManager;


@end

@implementation KKGlobalManager


static dispatch_once_t once;
static KKGlobalManager *instance;

+ (instancetype)sharedGlobalManager {
    
    dispatch_once(&once, ^{
        instance = [[self alloc] init];

    });
    
    return instance;
}

+ (void)releaseSingleton {
    
    once = 0;
    instance = nil;
    
}

-(instancetype)init
{
    if(self=[super init])
    {
        _GPSProvince=@"北京";
        _GPSCity=@"北京";
        
        _jobArr=@[@"在校学生",@"军人",@"私营业主",@"企业职工",@"农业劳动者",@"事业单位工作者",@"自由职业"];
        NSMutableArray *heightArray = [NSMutableArray array];
        for (int i = 120; i <= 220; ++i) {
            NSString *heightStr = [NSString stringWithFormat:@"%d",i];
            [heightArray addObject:heightStr];
        }
        _heightArr = [NSArray arrayWithArray:heightArray];
        _incomeArr = @[@"小于2000元",@"2000-5000元",@"5000-10000元",@"10000-20000元",@"20000元以上"];
        _interestArr = @[@"上网",@"研究汽车",@"养小动物",@"摄影",@"看电影",@"听音乐",@"写作",@"购物",@"做手工艺"];
        _personalityArr =@[@"孝顺",@"小资",@"贤惠",@"理智",@"多愁善感",@"善良",@"好强",@"冷静",@"温柔"];
        NSMutableArray *weightArray = [NSMutableArray array];
        for (int i = 35; i <= 120; ++i) {
            NSString *weightStr = [NSString stringWithFormat:@"%d",i];
            [weightArray addObject:weightStr];
        }
        _weightArr = [NSArray arrayWithArray:weightArray];
        _bloodArr = @[@"O",@"A",@"B",@"AB"];
        //加载表情数组
        [KKThredUtils runInGlobalQueue:^{
            NSString *path = KKPathOfMainBundle(@"emoticons", @"plist");
            self.emoticons=[NSArray arrayWithContentsOfFile:path];
            
        }];
    }
    
    return self;
}

#pragma mark - GPS
-(void)locationGPS
{
    //定位
    _aMapManager = [[AMapLocationManager alloc] init];
    
    //定位
    [_aMapManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if(error)
        {
            NSLog(@"location error:%@",error);
            //根据ip获取城市
            AFHTTPSessionManager *sessionManager=[AFHTTPSessionManager manager];
            sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];//不直接序列化为json
            [sessionManager GET:ServiceInterfaceGetCityByIp parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSData *data=(NSData*)responseObject;
                NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
                NSString *str=[[NSString alloc] initWithData:data encoding:gbkEncoding];
                NSRange startRange = [str rangeOfString:@"IPCallBack("];
                if(startRange.location!=NSNotFound)
                {
                    NSString *substr=[str substringFromIndex:startRange.location+startRange.length];
                    NSRange endRange=[substr rangeOfString:@")"];
                    if(endRange.location!=NSNotFound)
                    {
                        NSRange rang=NSMakeRange(0, endRange.location);
                        NSString *jsonstr=[substr substringWithRange:rang];
                        NSLog(@"jsonstr:%@",jsonstr);
                        NSDictionary *dic = (NSDictionary*)[jsonstr objectFromJSONString];
                        if(dic&&[dic isKindOfClass:[NSDictionary class]])
                        {
                            NSString *province = [dic stringForKey:@"pro" defaultValue:@""];
                            if(KKStringIsNotBlank(province))
                            {
                                province = [province stringByReplacingOccurrencesOfString:@"省" withString:@""];
                                province = [province stringByReplacingOccurrencesOfString:@"市" withString:@""];
                                KKSharedGlobalManager.GPSProvince=province;
                            }
                            
                            NSString *city=[dic stringForKey:@"city" defaultValue:@""];
                            if(KKStringIsNotBlank(city))
                            {
                                city = [city stringByReplacingOccurrencesOfString:@"市" withString:@""];
                                city = [city stringByReplacingOccurrencesOfString:@"区" withString:@""];
                                KKSharedGlobalManager.GPSCity=city;
                            }
                        }
                    }
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
        }
        else
        {
            NSLog(@"location:%@,regeode:%@",location,regeocode);
            NSString *province = regeocode.province;
            if(KKStringIsNotBlank(province))
            {
                province = [province stringByReplacingOccurrencesOfString:@"省" withString:@""];
                province = [province stringByReplacingOccurrencesOfString:@"市" withString:@""];
                KKSharedGlobalManager.GPSProvince=province;
            }
            
            NSString *city=regeocode.city;
            if(KKStringIsNotBlank(city))
            {
                city = [city stringByReplacingOccurrencesOfString:@"市" withString:@""];
                city = [city stringByReplacingOccurrencesOfString:@"区" withString:@""];
                KKSharedGlobalManager.GPSCity=city;
            }
            
        }
    }];

}

-(void)getSPhone
{
    [FSSharedNetWorkingManager GET:ServiceInterfaceSPhone parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic=(NSDictionary*)responseObject;
        self.SPhone=[dic stringForKey:@"sphone" defaultValue:@""];
        
    } failure:nil];
}

-(void)getIAP
{
    
    //如果是用iap的方式
    self.isIAP=NO;
    
    NSInteger beannum = [KKSharedLocalPlistManager kkIntergerForKey:Plist_Key_BeanNum];
    KKSharedCurrentUser.beannum=beannum;
    //vip
    long long viptime=[KKSharedLocalPlistManager kkLongForKey:Plist_Key_VIPEndTime];
    KKSharedCurrentUser.vipEndTime=[[NSDate dateWithTimeIntervalSince1970:viptime] stringYearMonthDay];
    if(viptime>[[NSDate date] timeIntervalSince1970])
    {
        KKSharedCurrentUser.isVIP=YES;
    }
    else KKSharedCurrentUser.isVIP=NO;
    //baoyue
    long long baoyuetime=[KKSharedLocalPlistManager kkLongForKey:Plist_Key_BaoYueEndTime];
    KKSharedCurrentUser.baoyueEndTime=[[NSDate dateWithTimeIntervalSince1970:baoyuetime] stringYearMonthDay];
    if(baoyuetime>[[NSDate date] timeIntervalSince1970])
    {
        KKSharedCurrentUser.isBaoYue=YES;
    }
    else KKSharedCurrentUser.isBaoYue=NO;
    
}

-(void)payBackCheck:(UINavigationController *)navController
{
    for (UIViewController *viewController in navController.viewControllers) {
        if([viewController isKindOfClass:[ChatViewController class]] || [viewController isKindOfClass:[RecommendUserInfoViewController class]])
        {
            [navController popToViewController:viewController animated:YES];
            return;
        }
    }
    [navController popToRootViewControllerAnimated:YES];
}

@end
