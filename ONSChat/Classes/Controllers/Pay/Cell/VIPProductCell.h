//
//  VIPProductCell.h
//  ONSChat
//
//  Created by liujichang on 2016/12/8.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VIPProductCell : UITableViewCell

@property (nonatomic, copy) void(^buyProduct)(NSInteger index);

-(void)showInfo:(NSArray*)arr;

@end
