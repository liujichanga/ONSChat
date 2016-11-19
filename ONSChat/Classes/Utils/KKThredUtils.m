//
//  KKThredUtils.h
//
//  Created by liujichang on 15/2/6.
//  Copyright (c) 2015年 jichang.liu. All rights reserved.
//

#import "KKThredUtils.h"

@implementation KKThredUtils

+ (void)runInMainQueue:(void (^)())queue {
    dispatch_async(dispatch_get_main_queue(), queue);
}

+ (void)runInGlobalQueue:(void (^)())queue {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), queue);
}

+ (void)runInMainQueue:(void (^)())queue delay:(double)delay {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), queue);
}

@end
