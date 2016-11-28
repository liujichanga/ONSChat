//
//  KKMediaPreviewController.h
//  KuaiKuai
//
//  Created by liujichang on 15/7/2.
//  Copyright (c) 2015年 liujichang. All rights reserved.
//
//多媒体大图预览

#import <UIKit/UIKit.h>

@class KKMediaPreviewController;

@protocol KKMediaPreviewControllerDelegate <NSObject>

//删除图片
- (void)deleteImageIndex:(NSInteger)imageIndex;


@end

@interface KKMediaPreviewController : UIPageViewController

/** 是否可以显示媒体封面 */
@property (assign, nonatomic) BOOL thumbnailModeEnabled;
/** 要展示的所有多媒体（KKMedia） */
@property (strong, nonatomic) NSMutableArray *medias;
/** 起始位置 */
@property (assign, nonatomic) NSUInteger startIndex;

//是否显示删除按钮
@property(assign,nonatomic) BOOL showDeleteButton;

@property(weak,nonatomic) id<KKMediaPreviewControllerDelegate> preDelegate;

@end
