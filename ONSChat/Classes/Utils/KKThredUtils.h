//
//  KKThredUtils.h
//
//  Created by liujichang on 15/2/6.
//  Copyright (c) 2015年 jichang.liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KKThredUtils : NSObject

+ (void)runInGlobalQueue:(void (^)())queue;
+ (void)runInMainQueue:(void (^)())queue;
+ (void)runInMainQueue:(void (^)())queue delay:(double)delay;

@end
