//
//  MyHobbyCell.h
//  ONSChat
//
//  Created by 王磊 on 2016/12/7.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyHobbyCell : UITableViewCell
//兴趣文案数组
@property (nonatomic, strong) NSArray *dataArr;
//返回cell高度
@property (nonatomic, copy) void(^cellHeight)(CGFloat height);
//用户已选兴趣
@property (nonatomic, strong) NSString *selectedHobbyStr;
@end
