//
//  KKMediaNavigationController.h
//  KuaiKuai
//
//  Created by liujichang on 15/7/2.
//  Copyright (c) 2015年 liujichang. All rights reserved.
// 调用多媒体展示的入口controller

#import <UIKit/UIKit.h>
#import "KKMedia.h"

extern NSString *const KKMediaNavigationControllerStartIndexKey;
extern NSString *const KKMediaPageControllerOrientationKey;
extern NSString *const KKMediaPageControllerSpacingKey;

typedef NS_ENUM(NSUInteger, KKMediaDisplayMode) {
    KKMediaDisplayModeThumbnail, // 缩略图
    KKMediaDisplayModeThumbnailAndPreview,//缩略图 带大图预览
    KKMediaDisplayModePreview, // 大图预览
    KKMediaDisplayModePreviewAndThumbnail //大图预览 带缩略图
};


@interface KKMediaNavigationController : UINavigationController

/** 要展示的所有多媒体（KKMedia） */
@property (strong, nonatomic) NSArray *medias;
/** 如果直接预览，可以指定开始位置 */
@property (assign, nonatomic) NSUInteger startIndex;

+ (instancetype)mediaNavigationControllerWithMedias:(NSMutableArray *)medias
                                     displayMode:(KKMediaDisplayMode)displayMode
                                         options:(NSDictionary *)options;

- (instancetype)initWithMedias:(NSMutableArray *)medias
                   displayMode:(KKMediaDisplayMode)displayMode
                       options:(NSDictionary *)options;

@end
