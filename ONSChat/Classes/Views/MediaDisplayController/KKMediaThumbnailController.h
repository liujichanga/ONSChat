//
//  KKMediaThumbnailController.h
//  KuaiKuai
//
//  Created by liujichang on 15/7/2.
//  Copyright (c) 2015年 liujichang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KKMedia;
@class KKMediaThumbnailController;

@protocol KKMediaThumbnailControllerDelegate <NSObject>

- (void)mediaThumbnailController:(KKMediaThumbnailController *)mediaThumbnailController
                  didSelectMedia:(KKMedia *)media;

@end

@interface KKMediaThumbnailController : KKBaseViewController

/** 是否可以预览 */
@property (assign, nonatomic) BOOL previewModeEnabled;
/** 要展示的所有多媒体（KKMedia） */
@property (strong, nonatomic) NSArray *medias;

@property (assign, nonatomic) UIPageViewControllerNavigationOrientation orientation;
@property (assign, nonatomic) CGFloat spacing;

@property (weak, nonatomic) id<KKMediaThumbnailControllerDelegate> delegate;

@end
