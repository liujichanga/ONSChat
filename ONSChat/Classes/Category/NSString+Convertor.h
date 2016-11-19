//
//  NSString+Convertor.h
//  KuaiKuai
//
//  Created by Sra Liu on 15/12/7.
//  Copyright © 2015年 liujichang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Convertor)

//将远程URL转换成本地缓存KKCourse MD加密
- (NSString*)convertUrlToCachesKKCourse;

//扩展名修补 make by sra
-(NSString*)fileExtNameFillWithExtName:(NSString*)extName;

//获取文件扩展名
-(NSString*)getExtName;

@end
