//
//  KRVideoPlayerControlView.m
//  KRKit
//
//  Created by aidenluo on 5/23/15.
//  Copyright (c) 2015 36kr. All rights reserved.
//

#import "KRVideoPlayerControlView.h"

static const CGFloat kVideoControlBarHeight = 40.0;
static const CGFloat kVideoControlAnimationTimeinterval = 0.3;
static const CGFloat kVideoControlTimeLabelFontSize = 15.0;
static const CGFloat kVideoControlBarAutoFadeOutTimeinterval = 5.0;

@interface KRVideoPlayerControlView ()

@property (nonatomic, strong) UIView *bottomBar;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIButton *fullScreenButton;
@property (nonatomic, strong) UIButton *shrinkScreenButton;
@property (nonatomic, strong) UISlider *progressSlider;
@property (nonatomic, strong) UILabel *endTimeLabel;
@property (nonatomic, strong) UILabel *startTimeLabel;
@property (nonatomic, assign) BOOL isBarShowing;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;



@end

@implementation KRVideoPlayerControlView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.bottomBar];
       
        [self addSubview:self.playButton];
        [self.bottomBar addSubview:self.fullScreenButton];
        [self.bottomBar addSubview:self.shrinkScreenButton];
        self.shrinkScreenButton.hidden = YES;
        [self.bottomBar addSubview:self.progressSlider];
        [self.bottomBar addSubview:self.endTimeLabel];
        [self.bottomBar addSubview:self.startTimeLabel];

        [self addSubview:self.indicatorView];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
        [self addGestureRecognizer:tapGesture];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.bottomBar.frame = CGRectMake(CGRectGetMinX(self.bounds), CGRectGetHeight(self.bounds) - kVideoControlBarHeight, CGRectGetWidth(self.bounds), kVideoControlBarHeight);
    self.playButton.center = CGPointMake(self.center.x, self.center.y);
   
    self.fullScreenButton.frame = CGRectMake(CGRectGetWidth(self.bottomBar.bounds) - CGRectGetWidth(self.fullScreenButton.bounds),0, CGRectGetWidth(self.fullScreenButton.bounds), CGRectGetHeight(self.fullScreenButton.bounds));
    self.shrinkScreenButton.frame = self.fullScreenButton.frame;
   
    self.startTimeLabel.frame = CGRectMake(30, 0, 50, CGRectGetHeight(self.startTimeLabel.bounds));

    self.endTimeLabel.frame = CGRectMake(CGRectGetMinX(self.fullScreenButton.frame)-60, 0, 50, CGRectGetHeight(self.endTimeLabel.bounds));
    
    self.progressSlider.frame = CGRectMake(CGRectGetMaxX(self.startTimeLabel.frame)+10, CGRectGetHeight(self.bottomBar.bounds)/2 - CGRectGetHeight(self.progressSlider.bounds)/2, CGRectGetMinX(self.endTimeLabel.frame) - CGRectGetMaxX(self.startTimeLabel.frame)-20, CGRectGetHeight(self.progressSlider.bounds));

    self.indicatorView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    self.isBarShowing = YES;
}

- (void)animateHide
{
    if (!self.isBarShowing) {
        return;
    }
    [UIView animateWithDuration:kVideoControlAnimationTimeinterval animations:^{
        self.bottomBar.alpha = 0.0;
        self.playButton.hidden = YES;
    } completion:^(BOOL finished) {
        self.isBarShowing = NO;
    }];
}

- (void)animateShow
{
    if (self.isBarShowing) {
        return;
    }
    [UIView animateWithDuration:kVideoControlAnimationTimeinterval animations:^{
        self.bottomBar.alpha = 1.0;
        self.playButton.hidden = NO;
    } completion:^(BOOL finished) {
        self.isBarShowing = YES;
        [self autoFadeOutControlBar];
    }];
}

- (void)autoFadeOutControlBar
{
    if (!self.isBarShowing) {
        return;
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateHide) object:nil];
    [self performSelector:@selector(animateHide) withObject:nil afterDelay:kVideoControlBarAutoFadeOutTimeinterval];
}

- (void)cancelAutoFadeOutControlBar
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateHide) object:nil];
}

- (void)onTap:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateRecognized) {
        if (self.isBarShowing) {
            [self animateHide];
        } else {
            [self animateShow];
        }
    }
}

#pragma mark - Property
- (UIView *)bottomBar
{
    if (!_bottomBar) {
        _bottomBar = [UIView new];
        _bottomBar.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    }
    return _bottomBar;
}

- (UIButton *)playButton
{
    if (!_playButton) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playButton setImage:[UIImage imageNamed:@"jc_play_normal"] forState:UIControlStateNormal];
        [_playButton setImage:[UIImage imageNamed:@"jc_pause_normal"] forState:UIControlStateSelected];

        _playButton.bounds = CGRectMake(0, 0, 50, 50);

    }
    return _playButton;
}

- (UIButton *)fullScreenButton
{
    if (!_fullScreenButton) {
        _fullScreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullScreenButton setImage:[UIImage imageNamed:@"jc_enlarge"] forState:UIControlStateNormal];
        _fullScreenButton.bounds = CGRectMake(0, 0, kVideoControlBarHeight, kVideoControlBarHeight);
    }
    return _fullScreenButton;
}

- (UIButton *)shrinkScreenButton
{
    if (!_shrinkScreenButton) {
        _shrinkScreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shrinkScreenButton setImage:[UIImage imageNamed:@"jc_shrink"] forState:UIControlStateNormal];
        _shrinkScreenButton.bounds = CGRectMake(0, 0, kVideoControlBarHeight, kVideoControlBarHeight);
    }
    return _shrinkScreenButton;
}

- (UISlider *)progressSlider
{
    if (!_progressSlider) {
        _progressSlider = [[UISlider alloc] init];
        [_progressSlider setThumbImage:[UIImage imageNamed:@"kr-video-player-point"] forState:UIControlStateNormal];
        [_progressSlider setMinimumTrackTintColor:KKColorPurple];
        [_progressSlider setMaximumTrackTintColor:[UIColor lightGrayColor]];
        _progressSlider.bounds = CGRectMake(0, 0, 10, 20);
        _progressSlider.value = 0.f;
        _progressSlider.continuous = YES;
    }
    return _progressSlider;
}

- (UILabel *)endTimeLabel
{
    if (!_endTimeLabel) {
        _endTimeLabel = [UILabel new];
        _endTimeLabel.font = [UIFont systemFontOfSize:kVideoControlTimeLabelFontSize];
        _endTimeLabel.textColor = [UIColor whiteColor];
        _endTimeLabel.textAlignment = NSTextAlignmentRight;
        _endTimeLabel.bounds = CGRectMake(0, 0, kVideoControlTimeLabelFontSize, kVideoControlBarHeight);
    }
    return _endTimeLabel;
}

- (UILabel *)startTimeLabel
{
    if (!_startTimeLabel) {
        _startTimeLabel = [UILabel new];
        _startTimeLabel.font = [UIFont systemFontOfSize:kVideoControlTimeLabelFontSize];
        _startTimeLabel.textColor = [UIColor whiteColor];
        _startTimeLabel.textAlignment = NSTextAlignmentLeft;
        _startTimeLabel.bounds = CGRectMake(0, 0, kVideoControlTimeLabelFontSize, kVideoControlBarHeight);
    }
    return _startTimeLabel;
}

- (UIActivityIndicatorView *)indicatorView
{
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [_indicatorView stopAnimating];
    }
    return _indicatorView;
}

@end
