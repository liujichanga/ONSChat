//
//  BaoYueProductCell.h
//  ONSChat
//
//  Created by liujichang on 2016/12/10.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaoYueProductCell : UITableViewCell

@property (nonatomic, copy) void(^buyProductClickBlock)(NSDictionary *dic);

-(void)showDisplay:(NSArray*)arr;

@end
