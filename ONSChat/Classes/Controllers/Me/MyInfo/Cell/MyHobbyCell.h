//
//  MyHobbyCell.h
//  ONSChat
//
//  Created by 王磊 on 2016/12/7.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyHobbyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, copy) void(^cellHeight)(CGFloat height);
@end
