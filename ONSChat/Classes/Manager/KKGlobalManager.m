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
        
        //征友条件相关数据
        _ageArr = @[@"不限",@"18-20岁",@"21-25岁",@"26-30岁",@"31-35岁",@"36-40岁",@"41-45岁",@"46-50岁",@"51-55岁",@"56-60岁",@"61-65岁"];
        _friendHeightArr = @[@"不限",@"160cm以下",@"161-165cm",@"166-170cm",@"171-175cm",@"176-180cm",@"180cm以上"];
        _graduateArr = @[@"不限",@"初中及以下",@"高中及中专",@"大专",@"本科",@"硕士及以上 "];
        _addressArr = @[@"不限",@"北京",@"上海",@"天津",@"重庆",@"安徽",@"湖南",@"湖北",@"江苏",@"浙江",@"四川",@"贵州",@"青海",@"山西",@"山东",@"陕西",@"河南",@"黑龙江",@"河北",@"福建",@"云南",@"江西",@"广东",@"辽宁",@"吉林",@"内蒙古",@"广西",@"新疆",@"西藏",@"宁夏",@"海南",@"台湾",@"甘肃",@"澳门",@"香港"];
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
    self.isIAP=YES;
    
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

-(NSInteger)getPhotosCount
{
    NSString *photo1=[KKSharedLocalPlistManager kkValueForKey:Plist_Key_Photo1];
    NSString *photo2=[KKSharedLocalPlistManager kkValueForKey:Plist_Key_Photo2];
    NSString *photo3=[KKSharedLocalPlistManager kkValueForKey:Plist_Key_Photo3];
    
    NSInteger count=0;
    if(KKStringIsNotBlank(photo1)) count+=1;
    if(KKStringIsNotBlank(photo2)) count+=1;
    if(KKStringIsNotBlank(photo3)) count+=1;
    
    return count;
}

-(NSInteger)infoCompletedPercent:(KKUser *)user
{
    NSInteger count = 0;
    if(KKStringIsNotBlank(user.birthday)) count+=1;
    if(KKStringIsNotBlank(user.address)) count+=1;
    if(user.height!=0) count+=1;
    if(user.weight!=0) count+=1;
    if(KKStringIsNotBlank(user.blood)) count+=1;
    if(KKStringIsNotBlank(user.graduate)) count+=1;
    if(KKStringIsNotBlank(user.job)) count+=1;
    if(KKStringIsNotBlank(user.income)) count+=1;
    if(KKStringIsNotBlank(user.hasHouse)) count+=1;
    if(user.hasCar) count+=1;
    if(KKStringIsNotBlank(user.marry)) count+=1;
    if(KKStringIsNotBlank(user.child)) count+=1;
    if(KKStringIsNotBlank(user.distanceLove)) count+=1;
    if(KKStringIsNotBlank(user.lovetype)) count+=1;
    if(KKStringIsNotBlank(user.livetog)) count+=1;
    if(KKStringIsNotBlank(user.withparent)) count+=1;
    if(KKStringIsNotBlank(user.pos)) count+=1;
    if(KKStringIsNotBlank(user.hobby)) count+=1;
    if(KKStringIsNotBlank(user.personality)) count+=1;
    if(KKStringIsNotBlank(user.phone)) count+=1;
    if(KKStringIsNotBlank(user.qq)) count+=1;

    return (count/21.0)*100;
}

@end
