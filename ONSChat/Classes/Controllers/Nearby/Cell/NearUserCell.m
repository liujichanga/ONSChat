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


@property(strong,nonatomic) KKUser *user;

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
    
    
}
- (IBAction)praiseClick:(id)sender {
    
    
}

-(void)headTap:(id)sender{
    if(self.clickAvatarBlock) self.clickAvatarBlock(_user);
}

-(void)imageTap:(id)sender{
    if(self.clickImageBlock) self.clickImageBlock(_user);
}


-(void)displayInfo:(KKUser *)user
{
    _user=user;
    
    self.dynamicImageView.hidden=YES;
    
    if(KKStringIsNotBlank(user.avatarUrl))
    {
        KKImageViewWithUrlstring(_headImageView, user.avatarUrl, @"def_head");
    }
    _nickNameLabel.text=user.nickName;
    _descLabel.text=KKStringWithFormat(@"%zd岁 %zdcm %@市",user.age,user.height,KKSharedGlobalManager.GPSCity);
    _distanceLabel.text=KKStringWithFormat(@"%@km",user.distanceKm);
    _dynamicText.text=user.dynamicText;
    _dateLabel.text=@"11月28日";
    [_commentButton setTitle:KKStringWithFormat(@"%zd",user.commentNum) forState:UIControlStateNormal];
    [_praiseButton setTitle:KKStringWithFormat(@"%zd",user.praiseNum) forState:UIControlStateNormal];
    
    CGSize size=[user.dynamicText sizeWithFont:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(KKScreenWidth-NearUserLeftInterval*2, 1000)];
    
    CGFloat locationY=NearUserTopHeight+size.height;
    if(user.dynamicsType==KKDynamicsTypeVideo)
    {
        
    }
    else
    {
        self.dynamicImageView.hidden=NO;
        self.dynamicImageView.frame=KKFrameOfOriginY(self.dynamicImageView.frame, locationY);
        self.dynamicImageView.image=[UIImage imageNamed:@"def_head"];
        if(KKStringIsNotBlank(user.dynamicsUrl))
        {
            KKImageViewWithUrlstring(self.dynamicImageView, user.dynamicsUrl, @"def_head");
        }
    }
    
}

@end
