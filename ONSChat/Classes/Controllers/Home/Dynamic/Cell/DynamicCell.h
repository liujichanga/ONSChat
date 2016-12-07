//
//  DynamicCell.h
//  ONSChat
//
//  Created by 王磊 on 2016/11/30.
//  Copyright © 2016年 LiuJichang. All rights reserved.
// 动态列表使用（不点赞  不删除）  动态详情使用（点赞 不删除） 我的动态使用（不点赞 删除）我的动态详情使用（不点赞 不删除）

#import <UIKit/UIKit.h>

@interface DynamicCell : UITableViewCell
@property (nonatomic, copy) void(^cellHeightBlock)(CGFloat cellH);
@property (nonatomic, strong) KKDynamic *dynamic;
@property (nonatomic, copy) void(^conmentBlock)();
@property (nonatomic, copy) void(^praiseBlock)();
@property (nonatomic, copy) void(^deleteBlock)(NSString*dynamicID);

//是否允许点赞（列表页面使用） 列表=NO 详情可以点赞=yes
@property (nonatomic, assign) BOOL allowLike;
//是否是本地数据（我的动态列表使用）
@property (nonatomic, assign) BOOL local;

@end
