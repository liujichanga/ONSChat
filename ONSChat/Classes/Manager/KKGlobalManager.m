//
//  KKGlobalManager.m
//  KuaiKuai
//
//  Created by liujichang on 16/1/12.
//  Copyright © 2016年 liujichang. All rights reserved.
//

#import "KKGlobalManager.h"

@interface KKGlobalManager()

@property (strong, nonatomic) CLLocationManager *locationManager;


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
        
    }
    
    return self;
}

#pragma mark - GPS
-(void)locationGPS
{
    //定位
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;

}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    NSLog(@"%d",status);
    switch (status)
    {
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        {
            NSLog(@"已经授权");
            [self.locationManager startUpdatingLocation];
        }
            break;
        case kCLAuthorizationStatusNotDetermined:
        {
            NSLog(@"等待授权");
            [self.locationManager requestWhenInUseAuthorization];
        }
            break;
        default:
        {
            NSLog(@"授权被拒绝");
        
        }
            break;
    }
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    if(locations.count > 0 && self.userLocation == nil)
    {
        NSLog(@"定位成功");
        //停止定位
        [self stopLoaction];
        
        self.userLocation = [locations firstObject];
        
        //定位成功，根据经纬度返回数据
        //[self loadClassData:nil];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"定位失败");
    //停止定位
    [self stopLoaction];
    
    self.userLocation=nil;
    
    //定位失败，根据IP地址返回城市
    //[self loadClassData:nil];
}

- (void)stopLoaction
{
    if(self.locationManager)
    {
        [self.locationManager stopUpdatingLocation];
        self.locationManager.delegate = nil;
        self.locationManager = nil;
    }
}

@end
