//
//  TwoPicCell.h
//  ONSChat
//
//  Created by liujichang on 2016/11/23.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TwoPicCell : UITableViewCell

@property (nonatomic, copy) void(^clickBlock)(NSString *userid);

-(void)displayLeftDic:(KKUser*)leftUser rightDic:(KKUser*)rightUser;




@end
