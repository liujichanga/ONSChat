//
//  OneVideoCell.h
//  ONSChat
//
//  Created by liujichang on 2016/11/23.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OneVideoCell : UITableViewCell

@property (nonatomic, copy) void(^clickBlock)(KKUser *user);

-(void)displayDic:(KKUser*)user;

@end
