//
//  NearUserCell.h
//  ONSChat
//
//  Created by liujichang on 2016/11/24.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define NearUserTopHeight 68
#define NearUserLeftInterval 15
#define NearUserBottomHeight 30
#define NearUserImageHeight KKScreenWidth*120/320.0
#define NearUserImageWidth NearUserImageHeight*2/3.0
#define NearUserVideoWidth KKScreenWidth*180.0/320.0
#define NearUserVideoHeight NearUserVideoWidth

@interface NearUserCell : UITableViewCell

@property (nonatomic, copy) void(^clickCommentBlock)(KKDynamic *dynamic);
@property (nonatomic, copy) void(^clickAvatarBlock)(KKDynamic *dynamic);
@property (nonatomic, copy) void(^clickImageBlock)(KKDynamic *dynamic);



-(void)displayInfo:(KKDynamic*)dynamic;



@end


