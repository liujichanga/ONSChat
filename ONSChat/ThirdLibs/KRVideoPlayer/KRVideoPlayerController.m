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
@property (nonatomic, strong) UIView *videoSuperView;

@end

@implementation KRVideoPlayerController

- (void)dealloc
{
    [self cancelObserver];
}

- (instancetype)initWithFrame:(CGRect)frame andImageURL:(NSString*)imgURL andVideoURL:(NSString*)videoURL
{
    self = [super init];
    if (self) {
        self.view.frame = frame;
        self.view.backgroundColor = [UIColor blackColor];
        self.controlStyle = MPMovieControlStyleNone;
        [self.view addSubview:self.videoControl];
        self.videoControl.frame = self.view.bounds;

        self.contentURL = [NSURL URLWithString:videoURL];
        KKImageViewWithUrlstring(self.videoControl.firstFrameImage, imgURL, @"");
        [self configObserver];
        [self configControlAction];
        
    }
    return self;
}

#pragma mark - Override Method

- (void)setContentURL:(NSURL *)contentURL
{
    [super setContentURL:contentURL];
    [self.videoControl animateHide];
    [self stop];
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

- (void)showInView:(UIView*)view
{
    self.videoSuperView = view;
    [view addSubview:self.view];
    self.view.alpha = 0.0;
    [UIView animateWithDuration:kVideoPlayerControllerAnimationTimeinterval animations:^{
        self.view.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismiss
{
    [KKThredUtils runInMainQueue:^{
        [self stopDurationTimer];
        [self stop];
    } delay:0.1];

    if (self.dimissCompleteBlock) {
        self.dimissCompleteBlock();
    }
}

#pragma mark - Private Method

- (void)configObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMPMoviePlayerPlaybackStateDidChangeNotification) name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMPMoviePlayerLoadStateDidChangeNotification) name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMPMoviePlayerReadyForDisplayDidChangeNotification) name:MPMoviePlayerReadyForDisplayDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMPMovieDurationAvailableNotification) name:MPMovieDurationAvailableNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMPMoviePlayerPlaybackDidFinishNotification) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
}

- (void)cancelObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)configControlAction
{
    [self.videoControl.playButton addTarget:self action:@selector(playButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.videoControl.fullScreenButton addTarget:self action:@selector(fullScreenButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.videoControl.shrinkScreenButton addTarget:self action:@selector(shrinkScreenButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.videoControl.progressSlider addTarget:self action:@selector(progressSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.videoControl.progressSlider addTarget:self action:@selector(progressSliderTouchBegan:) forControlEvents:UIControlEventTouchDown];
    [self.videoControl.progressSlider addTarget:self action:@selector(progressSliderTouchEnded:) forControlEvents:UIControlEventTouchUpInside];
    [self.videoControl.progressSlider addTarget:self action:@selector(progressSliderTouchEnded:) forControlEvents:UIControlEventTouchUpOutside];
    [self.videoControl.firstPlayBtn addTarget:self action:@selector(firstPlayBtnClick) forControlEvents:UIControlEventTouchUpInside];

    [self setProgressSliderMaxMinValues];
    [self monitorVideoPlayback];
}

- (void)onMPMoviePlayerPlaybackStateDidChangeNotification
{
    if (self.playbackState == MPMoviePlaybackStatePlaying) {
        [self startDurationTimer];
        self.videoControl.playButton.selected = YES;
        [self.videoControl.indicatorView stopAnimating];
        [self.videoControl autoFadeOutControlBar];
    } else {
        [self stopDurationTimer];
        if (self.playbackState == MPMoviePlaybackStateStopped) {
            [self.videoControl animateHide];
        }
    }
}

- (void)onMPMoviePlayerLoadStateDidChangeNotification
{
    if (self.loadState & MPMovieLoadStateStalled) {
        [self.videoControl.indicatorView startAnimating];
    }
}

- (void)onMPMoviePlayerReadyForDisplayDidChangeNotification
{
    
}

- (void)onMPMovieDurationAvailableNotification
{
    [self setProgressSliderMaxMinValues];
}

-(void)onMPMoviePlayerPlaybackDidFinishNotification{
    self.videoControl.firstFrameImage.hidden = NO;
    self.videoControl.firstPlayBtn.hidden = NO;
    [self dismiss];
}

-(void)firstPlayBtnClick{

    [self.videoControl.indicatorView startAnimating];
    self.videoControl.firstFrameImage.hidden = YES;
    [self play];

}

- (void)playButtonClick
{
    self.videoControl.firstFrameImage.hidden = YES;
    if (self.videoControl.playButton.selected == YES) {
        [self pause];
        self.videoControl.playButton.selected = NO;
    }else{
        [self play];
        self.videoControl.playButton.selected = YES;
    }
}

//- (void)fullScreenButtonClick
//{
//    if (self.isFullscreenMode) {
//        return;
//    }
//    [KKNotificationCenter postNotificationName:@"fullScreen" object:nil];
//    [self showInWindow];
//    self.originFrame = self.view.frame;
//    [UIView animateWithDuration:0.3f animations:^{
//        self.frame = [UIScreen mainScreen].bounds;
//    } completion:^(BOOL finished) {
//        self.isFullscreenMode = YES;
//        self.videoControl.fullScreenButton.hidden = YES;
//        self.videoControl.shrinkScreenButton.hidden = NO;
//    }];
//}
//
//- (void)shrinkScreenButtonClick
//{
//    if (!self.isFullscreenMode) {
//        return;
//    }
//    [KKNotificationCenter postNotificationName:@"shrinkScreen" object:nil];
//    [self showInView:self.videoSuperView];
//    [UIView animateWithDuration:0.3f animations:^{
//        self.frame = self.originFrame;
//        
//    } completion:^(BOOL finished) {
//        self.isFullscreenMode = NO;
//        self.videoControl.fullScreenButton.hidden = NO;
//        self.videoControl.shrinkScreenButton.hidden = YES;
//    }];
//}

- (void)setProgressSliderMaxMinValues {
    CGFloat duration = self.duration;
    self.videoControl.progressSlider.minimumValue = 0.f;
    self.videoControl.progressSlider.maximumValue = duration-1;
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
    
    self.videoControl.endTimeLabel.text = [NSString stringWithFormat:@"%@",timeRmainingString];
    self.videoControl.startTimeLabel.text = [NSString stringWithFormat:@"%@",timeElapsedString];
}

- (void)startDurationTimer
{
    self.durationTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(monitorVideoPlayback) userInfo:nil repeats:YES];
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
@end
