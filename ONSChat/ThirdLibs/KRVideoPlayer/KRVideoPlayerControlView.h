//
//  KRVideoPlayerControlView.h
//  KRKit
//
//  Created by aidenluo on 5/23/15.
//  Copyright (c) 2015 36kr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KRVideoPlayerControlView : UIView

@property (nonatomic, strong, readonly) UIView *bottomBar;
@property (nonatomic, strong, readonly) UIButton *playButton;
//@property (nonatomic, strong, readonly) UIButton *fullScreenButton;
//@property (nonatomic, strong, readonly) UIButton *shrinkScreenButton;
@property (nonatomic, strong, readonly) UISlider *progressSlider;
@property (nonatomic, strong, readonly) UILabel *endTimeLabel;
@property (nonatomic, strong, readonly) UILabel *startTimeLabel;
@property (nonatomic, strong, readonly) UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong, readonly) UIImageView *firstFrameImage;
@property (nonatomic, strong,readonly) UIButton *firstPlayBtn;

- (void)animateHide;
- (void)animateShow;
- (void)autoFadeOutControlBar;
- (void)cancelAutoFadeOutControlBar;

@end
