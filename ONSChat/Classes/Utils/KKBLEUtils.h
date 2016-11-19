//
//  KKBLEUtils.h
//  KKAppBLEDemo
//
//  Created by liujichang on 16/3/22.
//  Copyright © 2016年 liujichang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KKBLEUtils : NSObject

//data转换为十六进制的字符串。
+(NSString *)hexStringFromData:(NSData *)data;

//十六进制字符串转NSData
+(NSData *)dataFromHexString:(NSString *)str;

//十六进制字符串转成10进制字符串
+(NSString*)stringFromHexString:(NSString*)str;

//10进制int转16进制字符串
+(NSString *)hexStringFromInt:(NSInteger)tmpid;

//从现在开始计算的时间戳
+(NSString*)utcTimeIntervalFromNow;

//从date开始计算的时间戳
+(NSString*)utcTimeIntervalFromDate:(NSDate *)date;

//10进制字符串时间戳转换成时间
+(NSDate*)utcTimeFromString:(NSString*)str;

//将字符串补齐20字节长度
+(NSString*)format20Bytes:(NSString*)str;

@end
