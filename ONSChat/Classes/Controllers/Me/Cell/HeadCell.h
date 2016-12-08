//
//  HeadCell.h
//  ONSChat
//
//  Created by liujichang on 2016/11/22.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeadCell : UITableViewCell

@property (nonatomic, copy) void(^changeHeadImage)();
@property (nonatomic, copy) void(^getBeanBlock)();
@property (nonatomic, copy) void(^vipBlock)();
@property (nonatomic, copy) void(^baoyueBlock)();
@property (nonatomic, copy) void(^likemeBlock)();
@property (nonatomic, copy) void(^melikeBlock)();
@property (nonatomic, copy) void(^visitBlock)();


-(void)displayInfo;


@end
