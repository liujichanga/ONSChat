//
//  NSString+Valid.m
//  GlassesIntroduce
//
//  Created by 王志明 on 14/12/15.
//  Copyright (c) 2014年 王志明. All rights reserved.
//

#import "NSString+Valid.h"

@implementation NSString (Valid)

-(BOOL)isChinese{
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
}

-(BOOL)isNumber
{
    NSString *match=@"^[0-9]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
}

-(BOOL)isChar
{
    NSString *match=@"^[A-Za-z]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
}

-(BOOL)isBottomLine
{
    return [self isEqualToString:@"_"];
}

- (BOOL)isMatchsRegex:(NSString *)regex {
    return [self rangeOfString:regex options:NSRegularExpressionSearch].location != NSNotFound;
}

- (BOOL)isBlank {
    return ![self isNotBlank];
}

- (BOOL)isNotBlank {
    return [self isMatchsRegex:KKRegexNotBlack];
}

+ (BOOL)isBlank:(NSString *)string {
    return !string || [string isKindOfClass:[NSNull class]] || string.length==0 || string==nil; //[string isBlank];
}

+ (BOOL)isNotBlank:(NSString *)string {
    return ![self isBlank:string];//![NSString isBlank:string]; //
}

//自定义
+(BOOL)kkIsBlank:(NSString*)string{
    return string.length==0||string==nil||[string isKindOfClass:[NSNull class]]||!string;
}

-(NSMutableAttributedString*)splitByPercent:(NSValue**)rangeValue
{
    NSRange startRange = [self rangeOfString:@"%"];
    if(startRange.location!=NSNotFound)
    {
        NSString *substr=[self substringFromIndex:startRange.location+1];
        NSRange endRange=[substr rangeOfString:@"%"];
        if(endRange.location!=NSNotFound)
        {
            NSRange rang=NSMakeRange(startRange.location, endRange.location);
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[self stringByReplacingOccurrencesOfString:@"%" withString:@""]];
            [attributedString addAttribute:NSForegroundColorAttributeName value:KKColorPurple range:rang];
            
            if(rangeValue!=nil) *rangeValue=[NSValue valueWithRange:rang];
            
            return attributedString;
        }
    }
    
    return nil;
}

//判断url是否完整 并补全
-(NSString*)checkURL{
    NSString *newURL;
    if ([self hasPrefix:@"http"]||[self hasPrefix:@"https"]) {
        newURL = self;
    }else{
        newURL = [NSString stringWithFormat:@"%@/%@/%@", KKServerDomain,App,self];
    }
    return newURL;
}

//判断昵称是否合法
-(BOOL)nickNameIsMatch{
    
    NSString *temp = nil;
    for(int i =0; i < [self length]; i++)
    {
        temp = [self substringWithRange:NSMakeRange(i, 1)];
        
        if (![temp isChinese]&&![temp isChar]&&![temp isNumber]&&![temp isBottomLine]) {
            KKLog(@"昵称不合法");
            return NO;
        }
    }
    return YES;
}

-(NSString *)splitWhiteSpaceChar
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

//判断内容是否全部为空格  yes 全部为空格  no 不是
+ (BOOL)isNotEmpty:(NSString *)str {
    
    if (!str) {
        return NO;
    } else {
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        
        if ([trimedString length] == 0) {
            return NO;
        } else {
            return YES;
        }
    }
}

//显示表情,用属性字符串显示表情
+(NSMutableAttributedString *)showFace:(NSString *)str
{
    if (str != nil) {
        //获取plist中的数据
        NSArray *face =KKSharedGlobalManager.emoticons;
        
        //创建一个可变的属性字符串
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:str];
        
        UIFont *baseFont = [UIFont systemFontOfSize:16];
        [attributeString addAttribute:NSFontAttributeName value:baseFont range:NSMakeRange(0, str.length)];
        
        //正则匹配要替换的文字的范围
        //正则表达式
        NSString * pattern = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
        NSError *error = nil;
        NSRegularExpression * re = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
        
        if (!re) {
            NSLog(@"err %@", [error localizedDescription]);
        }
        
        //通过正则表达式来匹配字符串
        NSArray *resultArray = [re matchesInString:str options:0 range:NSMakeRange(0, str.length)];
        
        //用来存放字典，字典中存储的是图片和图片对应的位置
        NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:resultArray.count];
        
        //根据匹配范围来用图片进行相应的替换
        for(NSTextCheckingResult *match in resultArray) {
            //获取数组元素中得到range
            NSRange range = [match range];
            
            //获取原字符串中对应的值
            NSString *subStr = [str substringWithRange:range];
            
            for (int i = 0; i < face.count; i ++)
            {
                if ([face[i][@"chs"] isEqualToString:subStr])
                {
                    //新建文字附件来存放我们的图片
                    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
                    
                    //给附件添加图片
                    textAttachment.image = [UIImage imageNamed:face[i][@"png"]];
                    textAttachment.bounds=CGRectMake(0, 0, 16, 16);
                    
                    //把附件转换成可变字符串，用于替换掉源字符串中的表情文字
                    NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
                    
                    //把图片和图片对应的位置存入字典中
                    NSMutableDictionary *imageDic = [NSMutableDictionary dictionaryWithCapacity:2];
                    [imageDic setObject:imageStr forKey:@"image"];
                    [imageDic setObject:[NSValue valueWithRange:range] forKey:@"range"];
                    
                    //把字典存入数组中
                    [imageArray addObject:imageDic];
                    
                }
            }
        }
        
        if (imageArray.count > 0) {
            //从后往前替换
            for (int i = (int)imageArray.count -1; i >= 0; i--)
            {
                NSRange range;
                [imageArray[i][@"range"] getValue:&range];
                //进行替换
                [attributeString replaceCharactersInRange:range withAttributedString:imageArray[i][@"image"]];
                
            }
            
        }
        NSLog(@"face attr:%@",attributeString);
        return  attributeString;
        
    }
    
    return nil;
    
}

@end
