//
//  NearUserCell.m
//  ONSChat
//
//  Created by liujichang on 2016/11/24.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "NearUserCell.h"

@interface NearUserCell()

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *vipImageView;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *dynamicText;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *praiseButton;

@property(weak,nonatomic) UIImageView *dynamicImageView;


@property(strong,nonatomic) KKDynamic *dynamic;

@property (nonatomic, strong) KRVideoPlayerController *videoController;


@end

@implementation NearUserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    
    UITapGestureRecognizer *headGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headTap:)];
    [self.headImageView addGestureRecognizer:headGestureRecognizer];
    
    UIImageView *imageview=[[UIImageView alloc] initWithFrame:CGRectMake(NearUserLeftInterval, NearUserTopHeight, NearUserImageWidth, NearUserImageHeight)];
    self.dynamicImageView=imageview;
    self.dynamicImageView.contentMode=UIViewContentModeScaleAspectFit;
    self.dynamicImageView.clipsToBounds=YES;
    self.dynamicImageView.hidden=YES;
    self.dynamicImageView.userInteractionEnabled=YES;
    [self.contentView addSubview:self.dynamicImageView];
    
    UITapGestureRecognizer *imageGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTap:)];
    [self.dynamicImageView addGestureRecognizer:imageGestureRecognizer];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)commentClick:(id)sender {
    
    if(self.clickCommentBlock) self.clickCommentBlock(_dynamic);
}
- (IBAction)praiseClick:(id)sender {
    
    if(!_praiseButton.selected)
    {
        //提交接口
        NSDictionary *params=@{@"userid":self.dynamic.userId,@"dynamicsid":self.dynamic.dynamicsId};
        [FSSharedNetWorkingManager POST:ServiceInterfaceLike parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        
        _dynamic.isliked=YES;
        _praiseButton.selected=YES;
    }
    
}

-(void)headTap:(id)sender{
    if(self.clickAvatarBlock) self.clickAvatarBlock(_dynamic);
}

-(void)imageTap:(id)sender{
    if(self.clickImageBlock) self.clickImageBlock(_dynamic);
}


-(void)displayInfo:(KKDynamic *)dynamic
{
    _dynamic=dynamic;
    
    self.dynamicImageView.hidden=YES;
    
    [self.videoController.view removeFromSuperview];
    
    if(KKStringIsNotBlank(dynamic.avatarUrl))
    {
        KKImageViewWithUrlstring(_headImageView, dynamic.avatarUrl, @"def_head");
    }
    _nickNameLabel.text=dynamic.nickName;
    _descLabel.text=KKStringWithFormat(@"%zd岁 %zdcm %@市",dynamic.age,dynamic.height,KKSharedGlobalManager.GPSCity);
    _distanceLabel.text=KKStringWithFormat(@"%@km",dynamic.distanceKm);
    _dynamicText.text=dynamic.dynamicText;
    _dateLabel.text=dynamic.date;
    [_commentButton setTitle:KKStringWithFormat(@"%zd",dynamic.commentNum) forState:UIControlStateNormal];
    [_praiseButton setTitle:KKStringWithFormat(@"%zd",dynamic.praiseNum) forState:UIControlStateNormal];
    _praiseButton.selected=dynamic.isliked;

    
    CGSize size=[dynamic.dynamicText sizeWithFont:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(KKScreenWidth-NearUserLeftInterval*2, 1000)];
    
    CGFloat locationY=NearUserTopHeight+size.height;
    if(dynamic.dynamicsType==KKDynamicsTypeVideo)
    {
        self.videoController = [[KRVideoPlayerController alloc] initWithFrame:CGRectMake(NearUserLeftInterval,locationY,NearUserVideoWidth,NearUserVideoHeight) andImageURL:dynamic.avatarUrl andVideoURL:dynamic.dynamicUrl];
        self.videoController.repeatMode = MPMovieRepeatModeNone;
        [self.videoController showInView:self.contentView];
    }
    else
    {
        self.dynamicImageView.hidden=NO;
        self.dynamicImageView.frame=KKFrameOfOriginY(self.dynamicImageView.frame, locationY);
        self.dynamicImageView.image=[UIImage imageNamed:@"def_head"];
        if(KKStringIsNotBlank(dynamic.dynamicUrl))
        {
            KKImageViewWithUrlstring(self.dynamicImageView, dynamic.dynamicUrl, @"def_head");
        }
    }
    
}

@end
