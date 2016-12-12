//
//  BaoYueHeadCell.h
//  ONSChat
//
//  Created by liujichang on 2016/12/10.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaoYueHeadCell : UITableViewCell

@property (nonatomic, copy) void(^baoyueClickBlock)();
@property (nonatomic, copy) void(^beanClickBlock)();

-(void)showDisplay:(NSInteger)type;


@end
