//
//  KKGlobalManager.m
//  KuaiKuai
//
//  Created by liujichang on 16/1/12.
//  Copyright © 2016年 liujichang. All rights reserved.
//

#import "KKGlobalManager.h"

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
        _jobArr=@[@"",@"",@"",@""];
        
        
    }
    
    return self;
}

#pragma mark - GPS
-(void)locationGPS
{
    //定位
    _aMapManager = [[AMapLocationManager alloc] init];
    
    KKSharedCurrentUser.GPSCity=@"北京市";

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
                            NSString *city=[dic stringForKey:@"city" defaultValue:@""];
                            if(KKStringIsNotBlank(city))
                                KKSharedCurrentUser.GPSCity=city;
                        }
                    }
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
        }
        else
        {
            NSLog(@"location:%@,regeode:%@",location,regeocode);
            KKSharedCurrentUser.GPSCity=regeocode.city;
        }
    }];

}

@end
