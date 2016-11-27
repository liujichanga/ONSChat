//
//  ContactWayCell.h
//  ONSChat
//
//  Created by mac on 2016/11/27.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactWayCell : UITableViewCell
@property (nonatomic, strong) NSString *contactStr;
@property (nonatomic, copy) void(^lookBlock)();
@end
