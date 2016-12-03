//
//  KKComment.m
//  ONSChat
//
//  Created by 王磊 on 2016/12/2.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "KKComment.h"

@implementation KKComment

-(instancetype)initWithDic:(NSDictionary*)dic{
    
    if (self = [super init]) {
        self.userId = [dic stringForKey:@"id" defaultValue:@""];
        self.dynamicsId = [dic stringForKey:@"dynamicsId" defaultValue:@""];
        self.address = [dic stringForKey:@"address" defaultValue:@""];
        self.avatarUrl = [dic stringForKey:@"avatar" defaultValue:@""];
        self.distanceKm = [dic stringForKey:@"distanceKm" defaultValue:@""];
        self.name = [dic stringForKey:@"nickname" defaultValue:@""];
        self.age = [dic integerForKey:@"age" defaultValue:0];
        self.height = [dic integerForKey:@"height" defaultValue:0];
        NSArray *textList = [dic objectForKey:@"textlist"];
        if (textList.count>0) {
            self.commentText = textList.firstObject;
        }
    }
    return self;
}

@end
