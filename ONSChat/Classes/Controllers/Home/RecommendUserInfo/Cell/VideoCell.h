//
//  VideoCell.h
//  ONSChat
//
//  Created by 王磊 on 2016/11/28.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoCell : UITableViewCell
@property (nonatomic, strong) NSString *videoStr;
@property (nonatomic, copy) void(^heightBlock)(CGFloat height);
@property (nonatomic, strong) NSString *videoURL;
@end
