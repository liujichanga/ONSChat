//
//  MyBaseInfo2Cell.h
//  ONSChat
//
//  Created by 王磊 on 2016/12/8.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyBaseInfo2Cell : UITableViewCell
//弹出所有选项
@property (nonatomic, copy) void(^infoTypeBlock)(MyInfoType type);
@property (nonatomic, strong) KKUser *user;
@end
