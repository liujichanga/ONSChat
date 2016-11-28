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
@end

@implementation VideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, KKScreenWidth-20, 10)];
    [self.contentView addSubview:lab];
    self.videoStrLab = lab;
    
    self.videoController = [[KRVideoPlayerController alloc] initWithFrame:CGRectMake(10, 0, KKScreenWidth-20, (KKScreenWidth-20)*(9.0/16.0)) andtype:2];
    self.videoController.repeatMode = MPMovieRepeatModeNone;
    [self.videoController showInWindow];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setVideoStr:(NSString *)videoStr{
    _videoStr = videoStr;
    CGSize strSize = [videoStr sizeWithFont:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(KKScreenWidth-20, 500)];
    self.videoStrLab.frame = CGRectMake(10, 40, KKScreenWidth-20, strSize.height);
    self.videoController.frame = CGRectMake(10, self.videoStrLab.frame.origin.y+self.videoStrLab.frame.size.height+10,KKScreenWidth-20, (KKScreenWidth-20)*(9.0/16.0));
    if (self.heightBlock) {
        self.heightBlock(self.videoController.frame.origin.y+self.videoController.frame.size.height+10);
    }
}
-(void)setVideoURL:(NSString *)videoURL{
    _videoURL = videoURL;
    self.videoController.contentURL = [NSURL URLWithString:self.videoURL];

}

@end
