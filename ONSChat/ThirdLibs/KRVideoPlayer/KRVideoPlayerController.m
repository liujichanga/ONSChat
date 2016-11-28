//
//  KRVideoPlayerController.m
//  KRKit
//
//  Created by aidenluo on 5/23/15.
//  Copyright (c) 2015 36kr. All rights reserved.
//

#import "KRVideoPlayerController.h"
#import "KRVideoPlayerControlView.h"

static const CGFloat kVideoPlayerControllerAnimationTimeinterval = 0.3f;

@interface KRVideoPlayerController ()

@property (nonatomic, strong) KRVideoPlayerControlView *videoControl;
@property (nonatomic, strong) UIView *movieBackgroundView;
@property (nonatomic, assign) BOOL isFullscreenMode;
@property (nonatomic, assign) CGRect originFrame;
@property (nonatomic, strong) NSTimer *durationTimer;
//@property (nonatomic, assign) BOOL showShare;
//使用场景 1MV(分享，不全屏) 2动作介绍（不分享，全屏） 3自选课（不分享，不全屏）
@property (nonatomic, assign) NSInteger typeNub;
@end

@implementation KRVideoPlayerController

- (void)dealloc
{
    [self cancelObserver];
}

//- (instancetype)initWithFrame:(CGRect)frame andShowShare:(BOOL)showShare
//{
//    self = [super init];
//    KKLog(@"%zd",showShare);
//    if (self) {
//        self.showShare = showShare;
//        self.view.frame = frame;
//        self.view.backgroundColor = [UIColor blackColor];
//        self.controlStyle = MPMovieControlStyleNone;
//        [self.view addSubview:self.videoControl];
//        self.videoControl.frame = self.view.bounds;
//        self.videoControl.leftBtn.hidden = YES;
//        self.videoControl.rightBtn.hidden = YES;
//        [self configObserver];
//        [self configControlAction];
//        if (showShare==YES) {
//            self.videoControl.shareBtn.hidden = NO;
//            self.videoControl.fullScreenButton.hidden = YES;
//        }else{
//            self.videoControl.shareBtn.hidden = YES;
//            self.videoControl.fullScreenButton.hidden = NO;
//        }
//
//    }
//    return self;
//}

- (instancetype)initWithFrame:(CGRect)frame andtype:(NSInteger)typeNub
{
    self = [super init];
    if (self) {
        self.typeNub = typeNub;
        self.view.frame = frame;
        self.view.backgroundColor = [UIColor blackColor];
        self.controlStyle = MPMovieControlStyleNone;
        [self.view addSubview:self.videoControl];
        self.videoControl.frame = self.view.bounds;
        self.videoControl.leftBtn.hidden = YES;
        self.videoControl.rightBtn.hidden = YES;
        [self configObserver];
        [self configControlAction];
        if (typeNub==1) {
            self.videoControl.shareBtn.hidden = NO;
            self.videoControl.fullScreenButton.hidden = YES;
        }else if (typeNub==2){
            self.videoControl.shareBtn.hidden = YES;
            self.videoControl.fullScreenButton.hidden = NO;
        }else{
            self.videoControl.shareBtn.hidden = YES;
            self.videoControl.fullScreenButton.hidden = YES;
        }
        
    }
    return self;
}

#pragma mark - Override Method

- (void)setContentURL:(NSURL *)contentURL
{

    [self.videoControl.indicatorView startAnimating];
    self.videoControl.hitLabel.hidden = NO;
    [self stop];
    [super setContentURL:contentURL];
    [self play];
}

#pragma mark - Publick Method

- (void)showInWindow
{
    UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
    if (!keyWindow) {
        keyWindow = [[[UIApplication sharedApplication] windows] firstObject];
    }
    [keyWindow addSubview:self.view];
    self.view.alpha = 0.0;
    [UIView animateWithDuration:kVideoPlayerControllerAnimationTimeinterval animations:^{
        self.view.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}

- (void)dismiss
{
    
    [KKThredUtils runInMainQueue:^{
        [self stopDurationTimer];
        [self stop];
        [self.view removeFromSuperview];
    } delay:0.1];

    if (self.dimissCompleteBlock) {
        self.dimissCompleteBlock();
    }
//    [UIView animateWithDuration:kVideoPlayerControllerAnimationTimeinterval animations:^{
////        self.view.alpha = 0.0;
//    } completion:^(BOOL finished) {
//        [self.view removeFromSuperview];
//        if (self.dimissCompleteBlock) {
//            self.dimissCompleteBlock();
//        }
//    }];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

#pragma mark - Private Method

- (void)configObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMPMoviePlayerPlaybackStateDidChangeNotification) name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMPMoviePlayerLoadStateDidChangeNotification) name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMPMoviePlayerReadyForDisplayDidChangeNotification) name:MPMoviePlayerReadyForDisplayDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMPMovieDurationAvailableNotification) name:MPMovieDurationAvailableNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fullScreen) name:@"fullScreen" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shrinkScreen) name:@"shrinkScreen" object:nil];
}

- (void)cancelObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)configControlAction
{
    
    [self.videoControl.leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.videoControl.rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.videoControl.shareBtn addTarget:self action:@selector(shareMV) forControlEvents:UIControlEventTouchUpInside];
    
    [self.videoControl.playButton addTarget:self action:@selector(playButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.videoControl.pauseButton addTarget:self action:@selector(pauseButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.videoControl.closeButton addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.videoControl.fullScreenButton addTarget:self action:@selector(fullScreenButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.videoControl.shrinkScreenButton addTarget:self action:@selector(shrinkScreenButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.videoControl.progressSlider addTarget:self action:@selector(progressSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.videoControl.progressSlider addTarget:self action:@selector(progressSliderTouchBegan:) forControlEvents:UIControlEventTouchDown];
    [self.videoControl.progressSlider addTarget:self action:@selector(progressSliderTouchEnded:) forControlEvents:UIControlEventTouchUpInside];
    [self.videoControl.progressSlider addTarget:self action:@selector(progressSliderTouchEnded:) forControlEvents:UIControlEventTouchUpOutside];
    [self setProgressSliderMaxMinValues];
    [self monitorVideoPlayback];
}

- (void)onMPMoviePlayerPlaybackStateDidChangeNotification
{
    if (self.playbackState == MPMoviePlaybackStatePlaying) {
        self.videoControl.pauseButton.hidden = NO;
        self.videoControl.playButton.hidden = YES;
        [self startDurationTimer];
        [self.videoControl.indicatorView stopAnimating];
         self.videoControl.hitLabel.hidden = YES;
        [self.videoControl autoFadeOutControlBar];
    } else {
        self.videoControl.pauseButton.hidden = YES;
        self.videoControl.playButton.hidden = NO;
        [self stopDurationTimer];
        if (self.playbackState == MPMoviePlaybackStateStopped) {
            [self.videoControl animateShow];
        }
    }
}

- (void)onMPMoviePlayerLoadStateDidChangeNotification
{
    if (self.loadState & MPMovieLoadStateStalled) {
        [self.videoControl.indicatorView startAnimating];
         self.videoControl.hitLabel.hidden = NO;
    }
}

- (void)onMPMoviePlayerReadyForDisplayDidChangeNotification
{
    
}

- (void)onMPMovieDurationAvailableNotification
{
    [self setProgressSliderMaxMinValues];
}

-(void)fullScreen{
    
    if (self.isFullscreenMode==YES) {
        return;
    }
    
    self.originFrame = self.view.frame;
    [UIView animateWithDuration:0.3f animations:^{
        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
        if(UIInterfaceOrientationIsPortrait(orientation)) {
            [self forceOrientation:UIInterfaceOrientationLandscapeRight];
        }
        else if(UIInterfaceOrientationIsLandscape(orientation))
        {
            [self forceOrientation:orientation];
        }
        self.frame = [UIScreen mainScreen].bounds;
    } completion:^(BOOL finished) {
        self.isFullscreenMode = YES;
        if (self.typeNub==2) {
            self.videoControl.fullScreenButton.hidden = YES;
            self.videoControl.shrinkScreenButton.hidden = NO;
            self.videoControl.leftBtn.hidden = NO;
            self.videoControl.rightBtn.hidden = NO;
            //判断视频序号 第一个隐藏left按钮 最后一个隐藏right按钮
            if (self.indexNub==0) {
                self.videoControl.leftBtn.hidden = YES;
                self.videoControl.rightBtn.hidden = NO;
            }else if (self.indexNub == self.videoURLs.count-1) {
                self.videoControl.rightBtn.hidden = YES;
                self.videoControl.leftBtn.hidden = NO;
            }
        }
    }];
}

-(void)shrinkScreen{
    if (self.isFullscreenMode==NO) {
        return;
    }
    NSDictionary *dic = @{@"nub":@(self.indexNub)};
    [KKNotificationCenter postNotificationName:@"UPDATA_ACTION_DESCRIPTION" object:nil userInfo:dic];

    [UIView animateWithDuration:0.3f animations:^{
        [self forceOrientation:UIInterfaceOrientationPortrait];
        self.frame = self.originFrame;
    } completion:^(BOOL finished) {
        self.isFullscreenMode = NO;
        if (self.typeNub==2) {
            self.videoControl.fullScreenButton.hidden = NO;
            self.videoControl.shrinkScreenButton.hidden = YES;
            self.videoControl.leftBtn.hidden = YES;
            self.videoControl.rightBtn.hidden = YES;
        }
    }];
}

- (void)forceOrientation: (UIInterfaceOrientation)orientation {
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget: [UIDevice currentDevice]];
        int val = orientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}
//上一个视频
-(void)leftBtnClick{

    if (self.videoURLs.count>0&&self.indexNub>0) {
        self.indexNub = self.indexNub-1;
        //全屏状态 如果上一个视频是第一个 隐藏left按钮
        if (self.isFullscreenMode==YES) {
            if (self.indexNub==0) {
                self.videoControl.leftBtn.hidden = YES;
                self.videoControl.rightBtn.hidden = NO;
            }else{
                self.videoControl.leftBtn.hidden = NO;
                self.videoControl.rightBtn.hidden = NO;
            }
        }
        NSString *urlStr = [self.videoURLs objectAtIndex:self.indexNub];
        NSURL *contentURL = [NSURL URLWithString:urlStr];
        [self setContentURL:contentURL];
    }
}

//下一个视频
-(void)rightBtnClick{

    if (self.videoURLs.count>0&&self.videoURLs.count>self.indexNub+1) {
        self.indexNub = self.indexNub+1;
        //全屏状态下 如果下一个视频是最后一个 隐藏right按钮
        if (self.isFullscreenMode==YES) {
            if (self.indexNub == self.videoURLs.count-1) {
                self.videoControl.rightBtn.hidden = YES;
                self.videoControl.leftBtn.hidden = NO;
            }else{
                self.videoControl.leftBtn.hidden = NO;
                self.videoControl.rightBtn.hidden = NO;
            }
        }

        NSString *urlStr = [self.videoURLs objectAtIndex:self.indexNub];
        NSURL *contentURL = [NSURL URLWithString:urlStr];
        [self setContentURL:contentURL];
    }
}

- (void)playButtonClick
{
    [self play];
    self.videoControl.playButton.hidden = YES;
    self.videoControl.pauseButton.hidden = NO;
}

- (void)pauseButtonClick
{
    [self pause];
    self.videoControl.playButton.hidden = NO;
    self.videoControl.pauseButton.hidden = YES; 
}

- (void)closeButtonClick
{
    [self dismiss];
}

- (void)fullScreenButtonClick
{
    if (self.isFullscreenMode) {
        return;
    }
    self.originFrame = self.view.frame;
    [UIView animateWithDuration:0.3f animations:^{
        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
        if(UIInterfaceOrientationIsPortrait(orientation)) {
            [self forceOrientation:UIInterfaceOrientationLandscapeRight];
        }
        else if(UIInterfaceOrientationIsLandscape(orientation))
        {
            [self forceOrientation:orientation];
        }
        self.frame = [UIScreen mainScreen].bounds;
    } completion:^(BOOL finished) {
        self.isFullscreenMode = YES;
        self.videoControl.fullScreenButton.hidden = YES;
        self.videoControl.shrinkScreenButton.hidden = NO;
        self.videoControl.leftBtn.hidden = NO;
        self.videoControl.rightBtn.hidden = NO;
        //判断视频序号 第一个隐藏left按钮 最后一个隐藏right按钮
        if (self.indexNub==0) {
            self.videoControl.leftBtn.hidden = YES;
            self.videoControl.rightBtn.hidden = NO;
        }else if (self.indexNub == self.videoURLs.count-1) {
            self.videoControl.rightBtn.hidden = YES;
            self.videoControl.leftBtn.hidden = NO;
        }

    }];
}

- (void)shrinkScreenButtonClick
{
    if (!self.isFullscreenMode) {
        return;
    }
    NSDictionary *dic = @{@"nub":@(self.indexNub)};
    [KKNotificationCenter postNotificationName:@"UPDATA_ACTION_DESCRIPTION" object:nil userInfo:dic];

    [UIView animateWithDuration:0.3f animations:^{
        self.frame = self.originFrame;
        [self forceOrientation:UIInterfaceOrientationPortrait];
        
    } completion:^(BOOL finished) {
        self.isFullscreenMode = NO;
        self.videoControl.fullScreenButton.hidden = NO;
        self.videoControl.shrinkScreenButton.hidden = YES;
        self.videoControl.leftBtn.hidden = YES;
        self.videoControl.rightBtn.hidden = YES;
    }];
}

-(void)shareMV{
    if (self.shareBlock) {
        self.shareBlock();
    }
}

- (void)setProgressSliderMaxMinValues {
    CGFloat duration = self.duration;
    self.videoControl.progressSlider.minimumValue = 0.f;
    self.videoControl.progressSlider.maximumValue = duration;
}

- (void)progressSliderTouchBegan:(UISlider *)slider {
    [self pause];
    [self.videoControl cancelAutoFadeOutControlBar];
}

- (void)progressSliderTouchEnded:(UISlider *)slider {
    [self setCurrentPlaybackTime:floor(slider.value)];
    [self play];
    [self.videoControl autoFadeOutControlBar];
}

- (void)progressSliderValueChanged:(UISlider *)slider {
    double currentTime = floor(slider.value);
    double totalTime = floor(self.duration);
    [self setTimeLabelValues:currentTime totalTime:totalTime];
}

- (void)monitorVideoPlayback
{
    double currentTime = floor(self.currentPlaybackTime);
    double totalTime = floor(self.duration);
    [self setTimeLabelValues:currentTime totalTime:totalTime];
    self.videoControl.progressSlider.value = ceil(currentTime);
}

- (void)setTimeLabelValues:(double)currentTime totalTime:(double)totalTime {
    double minutesElapsed = floor(currentTime / 60.0);
    double secondsElapsed = fmod(currentTime, 60.0);
    NSString *timeElapsedString = [NSString stringWithFormat:@"%02.0f:%02.0f", minutesElapsed, secondsElapsed];
    
    double minutesRemaining = floor(totalTime / 60.0);;
    double secondsRemaining = floor(fmod(totalTime, 60.0));;
    NSString *timeRmainingString = [NSString stringWithFormat:@"%02.0f:%02.0f", minutesRemaining, secondsRemaining];
    
    self.videoControl.timeLabel.text = [NSString stringWithFormat:@"%@/%@",timeElapsedString,timeRmainingString];
}

- (void)startDurationTimer
{
    self.durationTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(monitorVideoPlayback) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.durationTimer forMode:NSDefaultRunLoopMode];
}

- (void)stopDurationTimer
{
    [self.durationTimer invalidate];
}

- (void)fadeDismissControl
{
    [self.videoControl animateHide];
}

#pragma mark - Property

- (KRVideoPlayerControlView *)videoControl
{
    if (!_videoControl) {
        _videoControl = [[KRVideoPlayerControlView alloc] init];
    }
    return _videoControl;
}

- (UIView *)movieBackgroundView
{
    if (!_movieBackgroundView) {
        _movieBackgroundView = [UIView new];
        _movieBackgroundView.alpha = 0.0;
        _movieBackgroundView.backgroundColor = [UIColor blackColor];
    }
    return _movieBackgroundView;
}

- (void)setFrame:(CGRect)frame
{
    [self.view setFrame:frame];
    [self.videoControl setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [self.videoControl setNeedsLayout];
    [self.videoControl layoutIfNeeded];
}


/*
 - (void)fullScreenButtonClick
 {
 if (self.isFullscreenMode) {
 return;
 }
 
 self.originFrame = self.view.frame;
 CGFloat height = [[UIScreen mainScreen] bounds].size.width;
 CGFloat width = [[UIScreen mainScreen] bounds].size.height;
 CGRect frame = CGRectMake((height - width) / 2, (width - height) / 2, width, height);;
 [UIView animateWithDuration:0.3f animations:^{
 self.frame = frame;
 [self.view setTransform:CGAffineTransformMakeRotation(M_PI_2)];
 } completion:^(BOOL finished) {
 self.isFullscreenMode = YES;
 self.videoControl.fullScreenButton.hidden = YES;
 self.videoControl.shrinkScreenButton.hidden = NO;
 self.videoControl.leftBtn.hidden = NO;
 self.videoControl.rightBtn.hidden = NO;
 //判断视频序号 第一个隐藏left按钮 最后一个隐藏right按钮
 if (self.indexNub==0) {
 self.videoControl.leftBtn.hidden = YES;
 self.videoControl.rightBtn.hidden = NO;
 }else if (self.indexNub == self.videoURLs.count-1) {
 self.videoControl.rightBtn.hidden = YES;
 self.videoControl.leftBtn.hidden = NO;
 }
 }];
 }
 
 - (void)shrinkScreenButtonClick
 {
 NSDictionary *dic = @{@"nub":@(self.indexNub)};
 [KKNotificationCenter postNotificationName:@"UPDATA_ACTION_DESCRIPTION" object:nil userInfo:dic];
 if (!self.isFullscreenMode) {
 return;
 }
 [UIView animateWithDuration:0.3f animations:^{
 [self.view setTransform:CGAffineTransformIdentity];
 self.frame = self.originFrame;
 } completion:^(BOOL finished) {
 self.isFullscreenMode = NO;
 self.videoControl.fullScreenButton.hidden = NO;
 self.videoControl.shrinkScreenButton.hidden = YES;
 self.videoControl.leftBtn.hidden = YES;
 self.videoControl.rightBtn.hidden = YES;
 }];
 }
 */
@end
