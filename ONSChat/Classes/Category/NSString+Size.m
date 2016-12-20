//
//  NSString+Size.m
//
//  Created by wangzhiming on 14-11-26.
//  Copyright (c) 2014年 wangzhiming. All rights reserved.
//

#import "NSString+Size.h"

@implementation NSString (Size)

- (CGSize)sizeWithFont:(UIFont *)font {
    return [self sizeWithAttributes:@{NSFontAttributeName : font}];
}

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)size {
    return [self sizeWithAttributes:@{NSFontAttributeName : font} maxSize:size];
}

- (CGSize)sizeWithAttributes:(NSDictionary *)attrs maxSize:(CGSize)size {
    
    NSStringDrawingOptions option = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    
    CGRect rect = [self boundingRectWithSize:size
                                     options:option
                                  attributes:attrs
                                     context:nil];
    return rect.size;
}

+ (CGSize)getStringSize:(NSAttributedString *)aString width:(CGFloat)width height:(CGFloat)height
{
    //CGSize size = CGSizeZero;
    NSMutableAttributedString *atrString = [[NSMutableAttributedString alloc] initWithAttributedString:aString];
    NSRange range = NSMakeRange(0, atrString.length);
    
    //获取指定位置上的属性信息，并返回与指定位置属性相同并且连续的字符串的范围信息。
    NSDictionary* dic = [atrString attributesAtIndex:0 effectiveRange:&range];
    //不存在段落属性，则存入默认值
    NSMutableParagraphStyle *paragraphStyle = dic[NSParagraphStyleAttributeName];
    if (!paragraphStyle || nil == paragraphStyle) {
        paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyle.lineSpacing = 0.0;//增加行高
        paragraphStyle.headIndent = 0;//头部缩进，相当于左padding
        paragraphStyle.tailIndent = 0;//相当于右padding
        paragraphStyle.lineHeightMultiple = 0;//行间距是多少倍
        paragraphStyle.alignment = NSTextAlignmentLeft;//对齐方式
        paragraphStyle.firstLineHeadIndent = 0;//首行头缩进
        paragraphStyle.paragraphSpacing = 0;//段落后面的间距
        paragraphStyle.paragraphSpacingBefore = 0;//段落之前的间距
        [atrString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    }
    
    
    NSMutableDictionary *attDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [attDic setObject:[UIFont systemFontOfSize:16] forKey:NSFontAttributeName];
    [attDic setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    
    CGSize strSize = [[aString string] boundingRectWithSize:CGSizeMake(width, height)
                                                    options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                 attributes:attDic
                                                    context:nil].size;
    
    //size = CGSizeMake(CGFloat_ceil(strSize.width), CGFloat_ceil(strSize.height));
    return strSize;
}

@end
