//
//  VideoThumbnailCell.h
//  ONSChat
//
//  Created by 王磊 on 2016/12/6.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface VideoThumbnailCell : UITableViewCell
//视频对象
@property (nonatomic, strong) PHAsset *asset;
@end
