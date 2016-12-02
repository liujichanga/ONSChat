//
//  DynamicCommentCell.h
//  ONSChat
//
//  Created by 王磊 on 2016/11/30.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DynamicCommentCell : UITableViewCell
@property (nonatomic, strong) KKComment *comment;
@property (nonatomic, copy) void(^cellHeightBlock)(CGFloat cellH);

@end
