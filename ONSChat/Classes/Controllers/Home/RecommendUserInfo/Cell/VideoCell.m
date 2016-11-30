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

@property (nonatomic, strong) UILabel *videoStrLab;
@property (nonatomic, assign) CGFloat height;
@end

@implementation VideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, KKScreenWidth-20, 10)];
    lab.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:lab];
    self.videoStrLab = lab;
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    
    NSString *videoStr = [dataDic stringForKey:@"textcontent" defaultValue:@""];
    NSString *videoURL = [dataDic stringForKey:@"mediaaddress" defaultValue:@""];
    NSString *imgURL = [dataDic stringForKey:@"imageaddress" defaultValue:@""];
    
    
    CGSize strSize = [videoStr sizeWithFont:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(KKScreenWidth-20, 500)];
    self.videoStrLab.text = videoStr;
    self.videoStrLab.frame = CGRectMake(10, 50, KKScreenWidth-20, strSize.height);
   
    //1图片 2视频
    NSInteger type = [dataDic integerForKey:@"statetype" defaultValue:0];
    if (type==1) {
        //图片frame可根据需要修改
        UIImageView *dynamicsImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, self.videoStrLab.frame.origin.y+self.videoStrLab.frame.size.height+10, KKScreenWidth-20, (KKScreenWidth-20)*(9.0/16.0))];
        dynamicsImgView.userInteractionEnabled = YES;
        KKImageViewWithUrlstring(dynamicsImgView, imgURL, @"");
        dynamicsImgView.backgroundColor = [UIColor blackColor];
        dynamicsImgView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:dynamicsImgView];
        self.height = dynamicsImgView.frame.origin.y+dynamicsImgView.frame.size.height+10;

    }else{

        KRVideoPlayerController *videoController = [[KRVideoPlayerController alloc] initWithFrame:CGRectMake(10, self.videoStrLab.frame.origin.y+self.videoStrLab.frame.size.height+10, KKScreenWidth-20, (KKScreenWidth-20)*(9.0/16.0)) andImageURL:imgURL andVideoURL:videoURL];
        videoController.repeatMode = MPMovieRepeatModeNone;
        [videoController showInView:self.contentView];
        self.height =self.videoStrLab.frame.origin.y+self.videoStrLab.frame.size.height+10+(KKScreenWidth-20)*(9.0/16.0)+10;
    }
    if (self.heightBlock) {
        self.heightBlock(self.height);
    }
}
- (IBAction)lookDynsmiscClick:(id)sender {
    if (self.lookDynamicsBlock) {
        self.lookDynamicsBlock();
    }
}

@end
