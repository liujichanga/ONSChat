//
//  NSString+Convertor.m
//  KuaiKuai
//
//  Created by Sra Liu on 15/12/7.
//  Copyright © 2015年 liujichang. All rights reserved.
//

#import "NSString+Convertor.h"

@implementation NSString (Convertor)


//将远程URL转换成本地缓存文件 MD加密 make by sra
- (NSString*)convertUrlToCachesKKCourse
{
    NSString *extName=@"";
    
    NSRange forwardSlashRange=[self rangeOfString:@"/" options:NSBackwardsSearch];
    if (forwardSlashRange.length==1)
    {
        NSString *forwardSlashString=[self substringFromIndex:forwardSlashRange.location];
        NSRange pointRange=[forwardSlashString rangeOfString:@"." options:NSBackwardsSearch];
        
        if (pointRange.length==1)
        {
            extName=[forwardSlashString substringFromIndex:pointRange.location];
        }
    }
    
    NSString *localName=KKStringWithFormat(@"%@%@",[self md5],extName);
    
    NSString *KKCoursePath=KKStringWithFormat(@"%@/KKCourse/",KKPathOfCache);
    if (![[NSFileManager defaultManager] fileExistsAtPath:KKCoursePath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:KKCoursePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *localPath=KKStringWithFormat(@"%@%@",KKCoursePath,localName);
    return localPath;
}

//扩展名修补 make by sra
-(NSString*)fileExtNameFillWithExtName:(NSString*)extName
{
    NSString *returnUrl=self;
    NSRange forwardSlashRange=[self rangeOfString:@"/" options:NSBackwardsSearch];
    if (forwardSlashRange.length==1)
    {
        NSString *forwardSlashString=[self substringFromIndex:forwardSlashRange.location];
        NSRange pointRange=[forwardSlashString rangeOfString:@"." options:NSBackwardsSearch];
        if (pointRange.length==0)
        {
            returnUrl=KKStringWithFormat(@"%@.%@",self,extName);
        }
    }
    return returnUrl;
}

//获取文件扩展名
-(NSString*)getExtName
{
    NSString *extName=@"";
    
    NSRange forwardSlashRange=[self rangeOfString:@"/" options:NSBackwardsSearch];
    if (forwardSlashRange.length==1)
    {
        NSString *forwardSlashString=[self substringFromIndex:forwardSlashRange.location];
        NSRange pointRange=[forwardSlashString rangeOfString:@"." options:NSBackwardsSearch];
        
        if (pointRange.length==1)
        {
            extName=[forwardSlashString substringFromIndex:pointRange.location];
        }
    }
    
    return extName;
}


@end
