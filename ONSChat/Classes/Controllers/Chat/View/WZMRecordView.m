//
//  WZMRecordView.m
//
//  Created by 王志明 on 14/12/26.
//  Copyright (c) 2014年 王志明. All rights reserved.
//

#import "WZMRecordView.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

/** 录音按钮 */
@interface WZMRecordButton : UIButton

@end

@implementation WZMRecordButton

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.nextResponder.nextResponder touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    [self.nextResponder.nextResponder touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    [self.nextResponder.nextResponder touchesCancelled:touches withEvent:event];
}

@end


/** 播放按钮的子图层，画圈 */
@class WZMPlayLayer;
@protocol WZMPlayLayerDelegate <NSObject>

- (void)playCompleteInPlayerLayer:(WZMPlayLayer *)playerLayer;

@end

@interface WZMPlayLayer : CALayer

/** 每秒绘制多少度 */
@property (assign, nonatomic) CGFloat drawSpeed;
/** 当前进度 */
@property (assign, nonatomic) CGFloat progress;
/** 动画时钟 */
@property (strong, nonatomic) CADisplayLink *displayLink;

@property (assign, nonatomic) id<WZMPlayLayerDelegate> playDelegate;

@end

@implementation WZMPlayLayer {
    BOOL _playing;
}

- (void)start {
    _playing = YES;
    _progress = 0.0;
    // 创建时钟
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(refreshView:)];
    // 添加到主循环队列
    [_displayLink addToRunLoop:[NSRunLoop mainRunLoop]  forMode:NSRunLoopCommonModes];
}

- (void)refreshView:(CADisplayLink *)displayLink {
    [self setNeedsDisplay];
}

- (void)stop {
    [_displayLink invalidate];
    _displayLink = nil;
    
    _progress = 0.0;
    _playing = NO;
    [self setNeedsDisplay];
}

- (void)drawInContext:(CGContextRef)ctx {
    
    if (_playing) {
        if (_progress < 360.0) {
            _progress += _drawSpeed / 60.0;
        } else {
            [self stop];
            if ([_playDelegate respondsToSelector:@selector(playCompleteInPlayerLayer:)])
                [_playDelegate playCompleteInPlayerLayer:self];
        }
    } else {
        _progress = 0.0;
    }
    
    NSInteger angle = !_playing ? 0 : _progress;
    CGFloat lineWidth = !_playing ? 0.0 : 2.0;
    CGFloat r = self.bounds.size.width * 0.5 - lineWidth;
    CGFloat x = self.bounds.size.width * 0.5, y = x;
    CGContextAddArc(ctx, x, y, r, M_PI_2, KKANGLE(angle) + M_PI_2, 0);
    
    CGContextSetLineWidth(ctx, lineWidth);
    CGContextSetRGBStrokeColor(ctx, 0.09, 0.71, 0.93, 1.0);
    CGContextSetAllowsAntialiasing(ctx, true);
    
    CGContextDrawPath(ctx, kCGPathStroke);
    CGContextSetBlendMode(ctx, kCGBlendModeColor);
    
//    kLog(@"画圈进度。。。%lu", _progress);
}

@end


/** 播放按钮 */
@interface WZMPlayButton : UIButton <WZMPlayLayerDelegate>

- (void)play:(CGFloat)duration;
- (void)stop;

@end

@implementation WZMPlayButton {
    /** 子图层 */
    WZMPlayLayer *_sublayer;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _sublayer = [WZMPlayLayer layer];
    _sublayer.contentsScale = [UIScreen mainScreen].scale;
    _sublayer.bounds = self.bounds;
    _sublayer.anchorPoint = CGPointMake(0.5, 0.5);
    CGFloat center = self.bounds.size.width * 0.5;
    _sublayer.position = CGPointMake(center, center);
    _sublayer.playDelegate = self;
    [self.layer addSublayer:_sublayer];
}

/** 播放 */
- (void)play:(CGFloat)duration {
    // 如果时长1秒，每次绘制1度，需要刷新360次／每秒
    // 计算每秒绘制多少度
    _sublayer.drawSpeed = 360.0 / duration;
    KKLog(@"每秒需要绘制%f度", _sublayer.drawSpeed);
    
    [_sublayer start];
    [self setPlayButtonState:YES];
}

/** 停止播放 */
- (void)stop {
    [_sublayer stop];
    [self setPlayButtonState:NO];
}

/** 播放完成 */
- (void)playCompleteInPlayerLayer:(WZMPlayLayer *)playerLayer {
    [self setPlayButtonState:NO];
}

/** 设置按钮状态 */
- (void)setPlayButtonState:(BOOL)playing {
    if (playing) {
        [self setImage:[UIImage imageNamed:@"aio_record_stop_nor"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"aio_record_stop_press"] forState:UIControlStateHighlighted];
    } else {
        [self setImage:[UIImage imageNamed:@"aio_record_play_nor"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"aio_record_play_press"] forState:UIControlStateHighlighted];
    }
}

@end

#pragma mark - Main

@interface WZMRecordView ()<AVAudioRecorderDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

/** 长按录音 */
@property (weak, nonatomic) IBOutlet WZMRecordButton *recordButton;
/** 试听 */
@property (weak, nonatomic) IBOutlet UIButton *listenButton;
/** 取消录音 */
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

/** 时间、音量view的容器 */
@property (weak, nonatomic) IBOutlet UIView *statusView;
/** 音量 */
@property (weak, nonatomic) IBOutlet UIImageView *volumeImageView;
/** 装饰线 */
@property (weak, nonatomic) IBOutlet UIImageView *line;
/** 显示时间 */
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;

/** 操作提醒 */
@property (weak, nonatomic) IBOutlet UILabel *remindLabel;

/**播放按钮*/
@property (weak, nonatomic) IBOutlet WZMPlayButton *playButton;
/** 取消按钮 */
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
/** 发送按钮 */
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

/** 计时器 */
@property (strong, nonatomic) NSTimer *durationTimer;
@property (strong, nonatomic) NSTimer *volumeTimer;
/** 录音时间 */
@property (assign, nonatomic) double duration;

/** 声音文件路径 */
@property (copy, nonatomic) NSString *voiceFilePath;
//声音文件对应的url
@property(strong,nonatomic) NSURL *voiceURL;


//录音
@property(strong,nonatomic)  AVAudioRecorder *recorder;

//播放
@property(strong,nonatomic) AVAudioPlayer *player;


@end

@implementation WZMRecordView

+ (instancetype)recordView {
    return KKViewOfMainBundle(@"WZMRecordView");
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    _line.alpha = 0.0;
    _listenButton.alpha = 0.0;
    _deleteButton.alpha = 0.0;
    _statusView.alpha = 0.0;
//    _scrollView.contentSize = CGSizeMake(self.bounds.size.width * 2.0, self.bounds.size.height);
    
    CGRect frame = CGRectMake(0.0, 0.0, self.bounds.size.width, 0.5);
    UIView *separatorView = [[UIView alloc] initWithFrame:frame];
    separatorView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    separatorView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:separatorView];
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [session setActive:YES error:nil];
    
    [self listenMode:NO];
}

/** 开始录音 */
- (IBAction)touchDown:(UIButton *)sender {
    
    _durationLabel.text = @"0:00";
    _duration = 0.0;
    
    // 录音按钮动画
    [UIView animateWithDuration:0.15 animations:^{
        _line.alpha = 1.0;
        _listenButton.alpha = 1.0;
        _deleteButton.alpha = 1.0;
        _statusView.alpha = 1.0;
        _remindLabel.alpha = 0.0;
        
        _line.transform = CGAffineTransformMakeScale(1.5, 1.5);
        _listenButton.transform = CGAffineTransformMakeTranslation(-20.0, 0.0);
        _deleteButton.transform = CGAffineTransformMakeTranslation(20.0, 0.0);
        _statusView.transform = CGAffineTransformMakeTranslation(0.0, -10.0);
        sender.transform = CGAffineTransformMakeScale(1.3, 1.3);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            sender.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
        }];
    }];
    
    // 开始录音
    _recording = YES;
    
    //录音设置
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    //设置录音格式  AVFormatIDKey==kAudioFormatLinearPCM
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEGLayer3] forKey:AVFormatIDKey];
    //设置录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量）
    [recordSetting setValue:[NSNumber numberWithFloat:44100] forKey:AVSampleRateKey];
    //录音通道数  1 或 2
    [recordSetting setValue:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
    //线性采样位数  8、16、24、32
    [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    //录音的质量
    [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityMedium] forKey:AVEncoderAudioQualityKey];
    
    long long int timestamp = [NSDate date].timeIntervalSince1970 * 1000 + arc4random()%1000;
    NSString *voicename=KKStringWithFormat(@"%lld.mp3",timestamp);
    _voiceFilePath = [CacheUserPath stringByAppendingPathComponent:voicename];
    NSLog(@"voicepath:%@",_voiceFilePath);
    
    _voiceURL=[NSURL fileURLWithPath:_voiceFilePath];
    
    NSError *err;
    //初始化
    self.recorder = [[AVAudioRecorder alloc] initWithURL:_voiceURL settings:recordSetting error:&err];
    if(err) NSLog(@"recordererr:%@",err);

    //开启音量检测
    self.recorder.meteringEnabled = YES;
    //[recorder recordForDuration:AudioMaxTime];
    self.recorder.delegate = self;
    
    [self.recorder record];

    //播放
//    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:_voiceURL error:&err];
//    if(err) NSLog(@"player err:%@",err);

    
    // 开始计时
    _durationTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateDuration:) userInfo:nil repeats:YES];
    _volumeTimer = [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(updateVolume:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_durationTimer forMode:NSRunLoopCommonModes];
    [[NSRunLoop mainRunLoop] addTimer:_volumeTimer forMode:NSRunLoopCommonModes];
}

/** 开始录音后监听手指移动 */
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = touches.anyObject;
    UIView *view = touch.view;
    if (view != _recordButton) return;
    
    CGPoint location = [touch locationInView:self];
    if (location.x < view.center.x) {  // 试听
        CGFloat distance = view.center.x - _listenButton.center.x;
        CGFloat delta = fabs(location.x - _listenButton.center.x);
        CGFloat percentage = (1.0 - (delta / distance)) * 0.5;

        CGFloat scale = 1.0 + percentage;
        CGAffineTransform translation = CGAffineTransformMakeTranslation(_listenButton.transform.tx, _deleteButton.transform.ty);
         _listenButton.transform = CGAffineTransformScale(translation, scale, scale);
    } else { // 取消发送
        CGFloat distance = _deleteButton.center.x - view.center.x;
        CGFloat delta = fabs(_deleteButton.center.x - location.x);
        CGFloat percentage = (1.0 - (delta / distance)) * 0.5;
        
        CGFloat scale = 1.0 + percentage;
        CGAffineTransform translation = CGAffineTransformMakeTranslation(_deleteButton.transform.tx, _deleteButton.transform.ty);
        _deleteButton.transform = CGAffineTransformScale(translation, scale, scale);
    }
    
    if (CGRectContainsPoint(_listenButton.frame, location)) {
        _remindLabel.text = @"松手试听";
        _listenButton.highlighted = YES;
    } else{
        _listenButton.highlighted = NO;
    }
    
    if (CGRectContainsPoint(_deleteButton.frame, location)) {
        _remindLabel.text = @"松手取消发送";
        _deleteButton.highlighted = YES;
    } else {
        _deleteButton.highlighted = NO;
    }
    
    if (_listenButton.isHighlighted || _deleteButton.isHighlighted) {
        _remindLabel.alpha = 1.0;
        _statusView.alpha = 0.0;
    } else {
        _remindLabel.alpha = 0.0;
        _statusView.alpha = 1.0;
    }
}

/** 试听／删除／发送 */
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

    UITouch *touch = touches.anyObject;
    CGPoint location = [touch locationInView:self];
    
    BOOL listen = NO;
    if (CGRectContainsPoint(_deleteButton.frame, location)) { // 取消发送
        [self cancelRecordingWithCompletion:nil];
    } else if (_duration < 0.5) {
        [MBProgressHUD showMessag:@"录音时间太短" toView:self.superview];
        [self cancelRecordingWithCompletion:nil];
    } else if (CGRectContainsPoint(_listenButton.frame, location)) { // 试听
        
        [self stopRecordingWithCompletion:^() {
            //_chatVoice = aChatVoice;
            
        }];
        listen = YES;
    } else { // 发送
        NSLog(@"send");
        [self stopRecordingWithCompletion:^() {
            //_chatVoice = aChatVoice;
            [self send:nil];
            
        }];
    }
    
    [self recoveryButtonsState:listen];
}

/** 删除 */
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    KKLog(@"删除-touchesCancelled");
    [self cancelRecordingWithCompletion:nil];
    [self recoveryButtonsState:NO];
}

/** 更新时间 */
- (void)updateDuration:(NSTimer *)timer {
    _duration += 0.1;
    if (_listenButton.isHighlighted || _deleteButton.isHighlighted) {
       return;
    }
    
    int minute = _duration / 60;
    int second = ((int)_duration) % 60;
    _durationLabel.text = [NSString stringWithFormat:@"%d:%02d", minute, second];
}

/** 显示音量 */
- (void)updateVolume:(NSTimer *)timer {
    
    [self.recorder updateMeters];
    
    double volume = pow(10, (0.05 * [self.recorder peakPowerForChannel:0]));
    //double volume =[self.recorder peakPowerForChannel:0]; //DeviceManager.peekRecorderVoiceMeter;
    volume = fabs(volume) ;
    //NSLog(@"volume:%f",volume);
    
    CGRect frame = CGRectZero;
    CGFloat width = 150.0 * volume;
    frame = CGRectMake(0.0, 0.0, width, 30.0);
    
    [UIView animateWithDuration:0.15 animations:^{
        _volumeImageView.frame = frame;
        _volumeImageView.center = CGPointMake(_statusView.bounds.size.width * 0.5, _statusView.bounds.size.height * 0.5);
    }];
}

/** 播放／停止 */
- (IBAction)playOrStop:(UIButton *)sender {
    if (self.player.isPlaying) {
        //[ChatManager stopPlayingAudio];
        [self.player stop];
        [_playButton stop];
    } else {
        [_playButton play:_duration];
        //[ChatManager asyncPlayAudio:_chatVoice completion:nil onQueue:nil];
        self.player.currentTime = 0;
        [self.player play];
    }
}

/** 取消发送 */
- (IBAction)cancelSend:(id)sender {
    if (self.player.isPlaying) {
        [self playOrStop:nil];
    }
    [self listenMode:NO];
}

/** 发送 */
- (IBAction)send:(id)sender {
    if (self.player.isPlaying) {
        [self playOrStop:nil];
    }
    [self listenMode:NO];
    
    [_delegate recordView:self sendVoiceMessage:_voiceFilePath];
}

/** 切换试听和录音场景 */
- (void)listenMode:(BOOL)listen {
    _playButton.hidden = !listen;
    _cancelButton.hidden = !listen;
    _sendButton.hidden = !listen;
    _remindLabel.alpha = listen ? 0.0 : 1.0;
}

/** 结束录音后恢复view的状态 */
- (void)recoveryButtonsState:(BOOL)listen {
    _playButton.hidden = !listen;
    _cancelButton.hidden = !listen;
    _sendButton.hidden = !listen;

    [UIView animateWithDuration:0.25 animations:^{
        _line.alpha = 0.0;
        _listenButton.alpha = 0.0;
        _deleteButton.alpha = 0.0;
        _statusView.alpha = 0.0;
        
        [self listenMode:listen];
        
        _line.transform = CGAffineTransformIdentity;
        _listenButton.transform = CGAffineTransformIdentity;
        _deleteButton.transform = CGAffineTransformIdentity;
        _statusView.transform = CGAffineTransformIdentity;
        
        _remindLabel.text = @"按住录音";
    } completion:^(BOOL finished) {
        _listenButton.highlighted = NO;
        _deleteButton.highlighted = NO;
    }];
}

/** 停止录音 */
- (void)stopRecordingWithCompletion:(void(^)())completion {
    //[ChatManager asyncStopRecordingAudioWithCompletion:completion onQueue:nil];
    NSLog(@"stopRecordingWithCompletion");
    [self.recorder stop];
    
    NSError *err;
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:_voiceURL error:&err];
    if(err) NSLog(@"player err:%@",err);
    
    
    [self invalidateTimer];
    
    completion();
}

/** 取消录音-private */
- (void)cancelRecordingWithCompletion:(void (^)())completion {
    
    [self.recorder stop];
    [self.recorder deleteRecording];
    
    [self invalidateTimer];
}

/** 取消录音-public */
- (void)cancelRecording {
    [self cancelRecordingWithCompletion:nil];
}

/** 停止计时 */
- (void)invalidateTimer {
    [_durationTimer invalidate];
    _durationTimer = nil;
    [_volumeTimer invalidate];
    _volumeTimer = nil;
    
    _recording = NO;
}

/** 离开聊天界面时如果正在录音，就取消 */
- (void)removeFromSuperview {
    [super removeFromSuperview];
    
    if (_recording) {
        [self cancelRecordingWithCompletion:nil];
    }
}


//音频录制结束
-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)record successfully:(BOOL)flag
{
    KKLog(@"录音结束:%d",flag);

    
}

@end
