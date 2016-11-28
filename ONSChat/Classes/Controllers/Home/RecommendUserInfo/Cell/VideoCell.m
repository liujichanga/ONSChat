//
//  VideoCell.m
//  ONSChat
//
//  Created by 王磊 on 2016/11/28.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "VideoCell.h"
#import "KRVideoPlayerController.h"


@interface VideoCell()

@property (nonatomic, strong) KRVideoPlayerController *videoController;
@property (nonatomic, strong) UILabel *videoStrLab;
@property (nonatomic, strong) UIImageView *dynamicsImgView;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) NSString *videoURL;
@end

@implementation VideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    KKWEAKSELF
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, KKScreenWidth-20, 10)];
    lab.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:lab];
    lab.backgroundColor = [UIColor redColor];
    self.videoStrLab = lab;
    
    self.videoController = [[KRVideoPlayerController alloc] initWithFrame:CGRectMake(10, self.videoStrLab.frame.origin.y+self.videoStrLab.frame.size.height+10, KKScreenWidth-20, (KKScreenWidth-20)*(9.0/16.0))];
    self.videoController.dimissCompleteBlock = ^(){
        weakself.playBtn.hidden = NO;
        weakself.dynamicsImgView.hidden = NO;
    };
    self.videoController.repeatMode = MPMovieRepeatModeNone;
    [self.videoController showInView:self.contentView];
   
    UIImageView *dynamicsImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, self.videoStrLab.frame.origin.y+self.videoStrLab.frame.size.height+10, KKScreenWidth-20, (KKScreenWidth-20)*(9.0/16.0))];
    dynamicsImgView.userInteractionEnabled = YES;
    dynamicsImgView.backgroundColor = [UIColor blackColor];
    dynamicsImgView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:dynamicsImgView];
    self.dynamicsImgView = dynamicsImgView;
    
    UIButton *btn = [[UIButton alloc]initWithFrame:dynamicsImgView.bounds];
    btn.backgroundColor = [UIColor clearColor];
    [btn addTarget:self action:@selector(playBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"ic_video_play"] forState:UIControlStateNormal];
    [dynamicsImgView addSubview:btn];
    self.playBtn = btn;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    
    NSString *videoStr = [dataDic stringForKey:@"textcontent" defaultValue:@""];
    self.videoURL = [dataDic stringForKey:@"mediaaddress" defaultValue:@""];
    NSString *imgURL = [dataDic stringForKey:@"imageaddress" defaultValue:@""];
    
    KKImageViewWithUrlstring(self.dynamicsImgView, imgURL, @"");
    
    CGSize strSize = [videoStr sizeWithFont:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(KKScreenWidth-20, 500)];
    self.videoStrLab.text = videoStr;
    self.videoStrLab.frame = CGRectMake(10, 40, KKScreenWidth-20, strSize.height);
    self.videoController.frame = CGRectMake(10, self.videoStrLab.frame.origin.y+self.videoStrLab.frame.size.height+10,KKScreenWidth-20, (KKScreenWidth-20)*(9.0/16.0));
    self.dynamicsImgView.frame = CGRectMake(10, self.videoStrLab.frame.origin.y+self.videoStrLab.frame.size.height+10,KKScreenWidth-20, (KKScreenWidth-20)*(9.0/16.0));
    if (self.heightBlock) {
        self.heightBlock(self.dynamicsImgView.frame.origin.y+self.dynamicsImgView.frame.size.height+10);
    }
}

-(void)playBtnClick{
    KKLog(@"播放");
    self.playBtn.hidden = YES;
    self.dynamicsImgView.hidden = YES;
    self.videoController.contentURL = [NSURL URLWithString:_videoURL];
}
@end
