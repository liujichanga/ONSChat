//
//  DynamicDetailViewController.h
//  ONSChat
//
//  Created by 王磊 on 2016/12/1.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "KKBaseViewController.h"

@interface DynamicDetailViewController : KKBaseViewController
@property (nonatomic, strong) KKDynamic *dynamicData;
@property (nonatomic, assign) BOOL localData;
@end
