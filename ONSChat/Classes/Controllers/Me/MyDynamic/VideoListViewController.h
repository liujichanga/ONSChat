//
//  VideoListViewController.h
//  ONSChat
//
//  Created by 王磊 on 2016/12/6.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "KKBaseViewController.h"
#import <Photos/Photos.h>

@interface VideoListViewController : KKBaseViewController
@property (nonatomic, copy) void(^selectBlock)(PHAsset *asset);
@end
