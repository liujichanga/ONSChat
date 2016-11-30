//
//  DynamicCell.m
//  ONSChat
//
//  Created by 王磊 on 2016/11/30.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "DynamicCell.h"

@interface DynamicCell()

@property (nonatomic, strong) KRVideoPlayerController *videoController;
@property (nonatomic, strong) UILabel *videoStrLab;
@property (nonatomic, assign) CGFloat height;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *infoLab;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UIButton *conmentBtn;

@end

@implementation DynamicCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 70, KKScreenWidth-20, 10)];
    lab.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:lab];
    self.videoStrLab = lab;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDynamic:(KKDynamic *)dynamic{
    _dynamic = dynamic;
    
    KKImageViewWithUrlstring(self.headImageView, dynamic.avatarUrl, @"def_head");
    self.nameLab.text = dynamic.nickName;
    self.infoLab.text = [NSString stringWithFormat:@"%zd岁  %zdcm",dynamic.age,dynamic.height];
    [self.likeBtn setTitle:[NSString stringWithFormat:@"%zd",dynamic.praiseNum] forState:UIControlStateNormal];
    [self.conmentBtn setTitle:[NSString stringWithFormat:@"%zd",dynamic.commentNum] forState:UIControlStateNormal];
    
    NSString *videoStr = dynamic.dynamicText;
    NSString *dynamicUrl = dynamic.dynamicUrl;
    NSString *imgURL = dynamic.dynamiVideoThumbnail;
    
    CGSize strSize = [videoStr sizeWithFont:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(KKScreenWidth-20, 500)];
    self.videoStrLab.text = videoStr;
    self.videoStrLab.frame = CGRectMake(10, 70, KKScreenWidth-20, strSize.height);
    
    if (dynamic.dynamicsType ==KKDynamicsTypeImage) {
        //图片frame可根据需要修改
        UIImageView *dynamicsImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, self.videoStrLab.frame.origin.y+self.videoStrLab.frame.size.height+10, KKScreenWidth-20, (KKScreenWidth-20)*(9.0/16.0))];
        dynamicsImgView.userInteractionEnabled = YES;
        KKImageViewWithUrlstring(dynamicsImgView, dynamicUrl, @"");
        dynamicsImgView.backgroundColor = [UIColor blackColor];
        dynamicsImgView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:dynamicsImgView];
        self.height = dynamicsImgView.frame.origin.y+dynamicsImgView.frame.size.height+45;
        
    }else{
        
        self.videoController = [[KRVideoPlayerController alloc] initWithFrame:CGRectMake(10, self.videoStrLab.frame.origin.y+self.videoStrLab.frame.size.height+10, KKScreenWidth-20, (KKScreenWidth-20)*(9.0/16.0)) andImageURL:imgURL andVideoURL:dynamicUrl];
        self.videoController.repeatMode = MPMovieRepeatModeNone;
        [self.videoController showInView:self.contentView];
        self.height =self.videoStrLab.frame.origin.y+self.videoStrLab.frame.size.height+10+(KKScreenWidth-20)*(9.0/16.0)+45;
    }
    if (self.cellHeightBlock) {
        self.cellHeightBlock(self.height);
    }
}
- (IBAction)likeBtnClick:(UIButton*)sender {
    sender.selected = !sender.selected;
    if (sender.selected==YES) {
        [sender setTitle:[NSString stringWithFormat:@"%zd",_dynamic.praiseNum+1] forState:UIControlStateSelected];
    }else{
        [sender setTitle:[NSString stringWithFormat:@"%zd",_dynamic.praiseNum] forState:UIControlStateNormal];
    }
}

- (IBAction)conmentBtnClick:(id)sender {
    if (self.conmentBlock) {
        self.conmentBlock();
    }
}

@end
