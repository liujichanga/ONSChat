//
//  SignCell.h
//  ONSChat
//
//  Created by mac on 2016/11/27.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignCell : UITableViewCell
@property (nonatomic, strong) NSString *signStr;
@property (nonatomic, copy) void(^signHeightBlock)(CGFloat height);
@end
