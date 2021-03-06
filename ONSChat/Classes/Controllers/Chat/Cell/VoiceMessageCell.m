//
//  VoiceMessageCell.m
//  ONSChat
//
//  Created by liujichang on 2016/12/6.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "VoiceMessageCell.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface VoiceMessageCell()

/** 小喇叭 */
@property (weak, nonatomic) UIImageView *animationImageview;

@property(strong,nonatomic) AVAudioPlayer *player;

@property(strong,nonatomic) NSTimer *timer;

@property(weak,nonatomic) UIActivityIndicatorView *activityIndicatorView;

@end

@implementation VoiceMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        // 小喇叭
        UIImageView *animationImageview = [[UIImageView alloc] init];
        _animationImageview = animationImageview;
        [self.backgroundButton addSubview:_animationImageview];
        
    
        UIActivityIndicatorView *activityView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityView.frame=CGRectMake(20, 2, 30, 30);
        self.activityIndicatorView=activityView;
        self.activityIndicatorView.hidesWhenStopped=YES;
        [self.backgroundButton addSubview:self.activityIndicatorView];
        
        [self.backgroundButton addTarget:self action:@selector(voiceClicked:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

- (void)setMessage:(ONSMessage *)message {
    [super setMessage:message];
    
    
    if(message.messageDirection==ONSMessageDirection_RECEIVE)
    {
        _animationImageview.image=[UIImage imageNamed:@"chatfrom_voice_playing"];
        _animationImageview.frame=CGRectMake(20, 10, 14, 17);
        
        self.activityIndicatorView.frame=CGRectMake(message.voiceSize.width+20, 8, 30, 30);
    }
    else
    {
        _animationImageview.image=[UIImage imageNamed:@"chatto_voice_playing"];
        _animationImageview.frame=CGRectMake(message.sendBackGroundButtonFrame.size.width-30, 10, 14, 17);
        
        self.activityIndicatorView.frame=CGRectMake(-60, 8, 30, 30);
    }
    
}

- (void)voiceClicked:(id)sender {
    
    BOOL isPlay=NO;
    //如果在播放中，停止先
    if (self.player.isPlaying)
    {
        isPlay=YES;
        [self.player stop];
        [self stopAnimation];
        [self.timer invalidate];
        self.timer = nil;
    }
    
    //如果点击的时候没有播放，现在开始播放.如果播放中，前面已经停止，这里不再执行了
    if(!isPlay) [self playAudioAndAnimation];
    
}

/** 开始播放动画跟声音 */
- (void)playAudioAndAnimation {
    
    NSString *url=[self.message.contentJson stringForKey:@"content" defaultValue:@""];
    if(KKStringIsNotBlank(url))
    {
        if(self.player)
        {
            if(self.player.isPlaying) [self.player stop];
            [self stopAnimation];
            [self.timer invalidate];
            self.timer =nil;
            self.player =nil;
        }
        
        //扬声器播放
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        

        if(![url hasPrefix:@"http"])
        {
            //本地音频
            NSError *err;
            self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:url] error:&err];
            KKLog(@"player error:%@",[err description]);
            
            [self.player play];
            [self playAnimation];
            
            self.timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(timerForPlay) userInfo:nil repeats:YES];
            return;
        }
        
        [self.activityIndicatorView startAnimating];

        
        NSString *voiceUrlMd5 = KKStringWithFormat(@"%@.%@",[url md5],[url pathExtension]);
        NSString *savepath=[CacheUserPath stringByAppendingPathComponent:voiceUrlMd5];
        NSLog(@"voicepath:%@",savepath);
        
        [FSSharedNetWorkingManager downloadFileURL:url savePath:savepath tag:0 success:^(NSInteger tag) {
            //设置下载完成操作
            // filePath就是你下载文件的位置，你可以解压，也可以直接拿来使用
            NSError *err;
            self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:savepath] error:&err];
            KKLog(@"player error:%@",[err description]);
            
            [self.player play];
            [self playAnimation];
            
            [self.activityIndicatorView stopAnimating];
            
            self.timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(timerForPlay) userInfo:nil repeats:YES];

        } failure:^(NSInteger tag, NSError * _Nonnull error) {
            
        }];
    }
    
    
}

-(void)timerForPlay
{
    if(!self.player.isPlaying)
    {
        
        [self stopAnimation];
        [self.timer invalidate];
        self.timer = nil;
    }
}

-(void)stopAudioPlay
{
    if(_player.isPlaying)
    {
        [_player stop];
        _player=nil;
        [self stopAnimation];
        [_timer invalidate];
        _timer = nil;
    }
}

/** 播放动画 */
- (void)playAnimation {
    
    // 图片
    NSString *prefix = @"chatfrom_voice_playing_f";
    if(self.message.messageDirection==ONSMessageDirection_SEND)
    {
        prefix=@"chatto_voice_playing_f";
    }
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:3];
    for (int i = 1; i < 4; i++) {
        NSString *imageName = [NSString stringWithFormat:@"%@%zd.png", prefix, i];
        UIImage *image = [UIImage imageNamed:imageName];
        [images addObject:image];
    }
    
    // 播放图片
    _animationImageview.animationImages = images;
    _animationImageview.animationRepeatCount = 0;
    _animationImageview.animationDuration = 1;
    [_animationImageview startAnimating];
}

/** 停止动画 */
- (void)stopAnimation {
    [_animationImageview stopAnimating];
}


@end
