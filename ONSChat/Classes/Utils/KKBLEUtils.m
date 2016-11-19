//
//  KKBLEUtils.m
//  KKAppBLEDemo
//
//  Created by liujichang on 16/3/22.
//  Copyright © 2016年 liujichang. All rights reserved.
//

#import "KKBLEUtils.h"

@implementation KKBLEUtils

//data转换为十六进制的字符串。
+(NSString *)hexStringFromData:(NSData *)data{
    
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    //NSLog(@"hexStringFromData:%@",string);
    return string;
}
//十六进制字符串转NSData
+(NSData *)dataFromHexString:(NSString *)str {
    if (!str || [str length] == 0) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    
    NSLog(@"dataFromHexString: %@", hexData);
    return hexData;
}

//十六进制字符串转成10进制字符串
+(NSString*)stringFromHexString:(NSString*)str{
  
    NSString * str10 = [NSString stringWithFormat:@"%lu",strtoul([str UTF8String],0,16)];
    //NSLog(@"10进制 %@",str10);
   
    return str10;
}

//10进制int转16进制字符串
+(NSString *)hexStringFromInt:(NSInteger)tmpid
{
    NSString *nLetterValue;
    NSString *str =@"";
    long long int ttmpig;
    for (int i = 0; i<9; i++) {
        ttmpig=tmpid%16;
        tmpid=tmpid/16;
        switch (ttmpig)
        {
            case 10:
                nLetterValue =@"A";break;
            case 11:
                nLetterValue =@"B";break;
            case 12:
                nLetterValue =@"C";break;
            case 13:
                nLetterValue =@"D";break;
            case 14:
                nLetterValue =@"E";break;
            case 15:
                nLetterValue =@"F";break;
            default:nLetterValue=[[NSString alloc]initWithFormat:@"%lli",ttmpig];
                
        }
        str = [nLetterValue stringByAppendingString:str];
        if (tmpid == 0) {
            break;  
        }  
        
    }  
    return str;  
}

//从2000 01 01 00：00：00开始计算
+(NSString*)utcTimeIntervalFromNow
{
    //NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    //[outputFormatter setLocale:[NSLocale currentLocale]];
    //[outputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //NSDate *startDate = [outputFormatter dateFromString:@"2000-01-01 00:00:00"];
    
    NSDate *nowDate=[NSDate date];//[outputFormatter dateFromString:@"2016-03-20 00:00:00"];
    
    NSTimeInterval timeinterval = [nowDate timeIntervalSince1970];// timeIntervalSinceDate:startDate
    
    NSString *timestmap=[NSString stringWithFormat:@"%08llx",(long long)timeinterval];
    
    return timestmap;
}

+(NSString *)utcTimeIntervalFromDate:(NSDate *)date
{
    NSTimeInterval timeinterval = [date timeIntervalSince1970];// timeIntervalSinceDate:startDate
    
    NSString *timestmap=[NSString stringWithFormat:@"%08llx",(long long)timeinterval];
    
    return timestmap;
}

//10进制字符串时间戳转换成时间
+(NSDate*)utcTimeFromString:(NSString*)str
{
    //腕表给的就是本地时间了
    NSTimeInterval timeinterval = str.doubleValue;
    NSDate *date =[NSDate dateWithTimeIntervalSince1970:timeinterval];// [NSDate dateWithTimeInterval:timeinterval sinceDate:startDate];
    
//    NSTimeZone *zone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
//    NSInteger interval = [zone secondsFromGMTForDate: date];
//    NSDate *localeDate = [date dateByAddingTimeInterval: interval];
    
    return date;
}

+(NSString*)format20Bytes:(NSString*)str
{
    str = [str stringByPaddingToLength:40 withString:@"0" startingAtIndex:0];
    
    return str;
}


@end
