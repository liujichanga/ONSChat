//
//  CommentPopView.h
//  ONSChat
//
//  Created by 王磊 on 2016/12/1.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentPopView : UIView

@property (nonatomic, copy) void(^sendComment)(NSString*commentText);
+(instancetype)showCommentPopViewInView:(UIView*)view AndFrame:(CGRect)frame;
@end
