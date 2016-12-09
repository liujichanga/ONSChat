//
//  MyBaseInfo1Cell.h
//  ONSChat
//
//  Created by 王磊 on 2016/12/8.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyBaseInfo1Cell : UITableViewCell
@property (nonatomic, copy) void(^infoTypeBlock)(MyInfoType type);
@end
