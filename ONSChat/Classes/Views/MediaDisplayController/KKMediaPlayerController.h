//
//  KKMediaPlayerController.h
//  KuaiKuai
//
//  Created by liujichang on 15/7/2.
//  Copyright (c) 2015年 liujichang. All rights reserved.
//
//展示大图时使用的单个图片展示

#import <UIKit/UIKit.h>
#import "KKMedia.h"

@class KKMediaPlayerController;

@protocol KKMediaPlayerControllerDelegate <NSObject>

- (void)didMedicalDisplayController:(KKMediaPlayerController *)medicalImageDisplayController;

@end

@interface KKMediaPlayerController : KKBaseViewController

@property (strong, nonatomic) KKMedia *media;
@property (assign, nonatomic) NSUInteger pageIndex;

@property(weak,nonatomic) id<KKMediaPlayerControllerDelegate> delegate;

@end
