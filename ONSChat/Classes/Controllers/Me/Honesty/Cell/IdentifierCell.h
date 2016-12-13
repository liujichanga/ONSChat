//
//  IdentifierCell.h
//  ONSChat
//
//  Created by liujichang on 2016/12/12.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IdentifierCell : UITableViewCell

@property (nonatomic, copy) void(^identifierClickBlock)(NSInteger index);


-(void)showDisplayInfo:(NSInteger)index completedInfo:(NSInteger)completed;

@end
