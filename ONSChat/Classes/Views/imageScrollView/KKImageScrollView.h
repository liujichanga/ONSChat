//
//  KKImageScrollView.h
//  KuaiKuai
//
//  Created by liujichang on 15/7/2.
//  Copyright (c) 2015年 liujichang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@class KKImageScrollView;

@protocol KKImageScrollViewDelegate <NSObject>

-(void)tapInImageScrollView:(KKImageScrollView*)kkImageScrollView;

@end


@interface KKImageScrollView : UIScrollView

@property(strong,nonatomic) UIImage *image;
@property(strong,nonatomic) ALAsset *asset;
@property(strong,nonatomic) NSURL *imageUrl;

@property(weak,nonatomic) id<KKImageScrollViewDelegate> tapDelegate;

@end
