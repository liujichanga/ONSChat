//
//  DynamicCell.h
//  ONSChat
//
//  Created by 王磊 on 2016/11/30.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DynamicCell : UITableViewCell
@property (nonatomic, copy) void(^cellHeightBlock)(CGFloat cellH);
@property (nonatomic, strong) KKDynamic *dynamic;
@property (nonatomic, copy) void(^conmentBlock)();
@property (nonatomic, copy) void(^praiseBlock)();

@property (nonatomic, assign) BOOL allowLike;

@end
