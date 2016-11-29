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
#define NearUserVideoHeight KKScreenWidth*170/320.0
#define NearUserVideoWidth NearUserVideoHeight*16.0/9.0

@interface NearUserCell : UITableViewCell

@property (nonatomic, copy) void(^clickCommentBlock)(KKUser *user);
@property (nonatomic, copy) void(^clickAvatarBlock)(KKUser *user);
@property (nonatomic, copy) void(^clickImageBlock)(KKUser *user);



-(void)displayInfo:(KKUser*)user;



@end


