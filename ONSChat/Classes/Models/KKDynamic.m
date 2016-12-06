//
//  KKDynamic.m
//  ONSChat
//
//  Created by liujichang on 2016/11/30.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "KKDynamic.h"

@implementation KKDynamic


-(instancetype)initWithDic:(NSDictionary *)dic
{
    if (self = [super init])
    {
        _userId=[dic stringForKey:@"id" defaultValue:@""];
        _avatarUrl=[dic stringForKey:@"avatar" defaultValue:@""];
        _age=[dic integerForKey:@"age" defaultValue:0];
        _nickName=[dic stringForKey:@"nickname" defaultValue:@""];
        _height=[dic integerForKey:@"height" defaultValue:0];
        _distanceKm=[dic stringForKey:@"distanceKm" defaultValue:@""];
        _isliked=[dic boolForKey:@"liked" defaultValue:NO];
        _dynamiVideoThumbnail = [dic stringForKey:@"dynamiVideoThumbnail" defaultValue:@""];
        
        _dynamicsId=[dic stringForKey:@"dynamicsId" defaultValue:@""];
        _dynamicsType=[dic integerForKey:@"dynamicsType" defaultValue:KKDynamicsTypeImage];
        _commentNum=[dic integerForKey:@"comment" defaultValue:0];
        _praiseNum=[dic integerForKey:@"praiseNum" defaultValue:0];
        
        NSArray *arr=[dic objectForKey:@"medialist"];
        if(arr&&[arr isKindOfClass:[NSArray class]]&&arr.count>0)
        {
            _dynamicUrl=arr[0];
        }
        
        NSArray *arrText=[dic objectForKey:@"textlist"];
        if(arrText&&[arrText isKindOfClass:[NSArray class]]&&arrText.count>0)
        {
            _dynamicText=arrText[0];
        }
        
        NSString *dateee=[dic stringForKey:@"date" defaultValue:@""];
        if(KKStringIsBlank(dateee))
        {
            //随机一个最近两天的日期
            int value = arc4random() % (2);
            if(value==0)
            {
                _date=[[[NSDate date] dateBySubtractingDays:1] stringWithFormat:@"MM月dd日"];
            }
            else
            {
                _date=[[[NSDate date] dateBySubtractingDays:2] stringWithFormat:@"MM月dd日"];
            }
        }
        else _date=dateee;
        
    }
    
    return self;
    
}


@end
