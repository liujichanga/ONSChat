//
//  DynamicListViewController.h
//  ONSChat
//
//  Created by 王磊 on 2016/11/30.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "KKBaseViewController.h"

@interface DynamicListViewController : KKBaseViewController
@property (nonatomic, strong) NSString *uidStr;
//显示发布按钮 我的动态使用
@property (nonatomic, assign) BOOL showRightItem;
@end
