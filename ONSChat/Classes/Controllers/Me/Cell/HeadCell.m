//
//  HeadCell.m
//  ONSChat
//
//  Created by liujichang on 2016/11/22.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "HeadCell.h"

@interface HeadCell()

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *noHeadLabel;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *myRedLabel;
@property (weak, nonatomic) IBOutlet UIButton *getRedButton;
@property (weak, nonatomic) IBOutlet UIButton *VIPButton;
@property (weak, nonatomic) IBOutlet UIButton *MonthButton;
@property (weak, nonatomic) IBOutlet UIButton *PhoneAuthButton;
@property (weak, nonatomic) IBOutlet UIButton *idAuthButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftLineLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightLineRightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *likeMeLabel;
@property (weak, nonatomic) IBOutlet UILabel *meLikeLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastVisterLabel;


@end

@implementation HeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _leftLineLeftConstraint.constant=KKScreenWidth/3.0;
    _rightLineRightConstraint.constant=KKScreenWidth/3.0;
    
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    
    CGFloat radius=3.0;
    
    [_getRedButton.layer setCornerRadius:radius];
    [_VIPButton.layer setCornerRadius:radius];
    [_MonthButton.layer setCornerRadius:radius];
    [_PhoneAuthButton.layer setCornerRadius:radius];
    [_idAuthButton.layer setCornerRadius:radius];
    
    UIView *redview=[[UIView alloc] initWithFrame:CGRectMake(_getRedButton.frame.size.width-4, -2, 7, 7)];
    redview.backgroundColor=[UIColor redColor];
    [redview.layer setCornerRadius:3.0];
    [_getRedButton addSubview:redview];
    
    UITapGestureRecognizer *headGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headTap:)];
    [self.headImageView addGestureRecognizer:headGestureRecognizer];

    UITapGestureRecognizer *likemeGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likemeTap:)];
    [self.likeMeLabel addGestureRecognizer:likemeGestureRecognizer];
    
    UITapGestureRecognizer *melikeGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(melikeTap:)];
    [self.meLikeLabel addGestureRecognizer:melikeGestureRecognizer];
    
    UITapGestureRecognizer *visitGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(visitTap:)];
    [self.lastVisterLabel addGestureRecognizer:visitGestureRecognizer];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)displayInfo
{
    _nickNameLabel.text=KKSharedCurrentUser.nickName;
    _myRedLabel.text=KKStringWithFormat(@"我的红豆：%ld颗",(long)KKSharedCurrentUser.beannum);
    if(KKSharedCurrentUser.beannum>0)
    {
        _getRedButton.hidden=YES;
    }
    if(KKStringIsNotBlank(KKSharedCurrentUser.avatarUrl))
    {
        UIImage *image=[[UIImage alloc] initWithContentsOfFile:KKSharedCurrentUser.avatarUrl];
        _headImageView.image=image;
        _noHeadLabel.hidden=YES;
    }
    
    _likeMeLabel.text=KKStringWithFormat(@"喜欢我的人%ld",KKSharedCurrentUser.likedmeNum);
    _meLikeLabel.text=KKStringWithFormat(@"我喜欢的人%ld",KKSharedCurrentUser.melikeNum);
    _lastVisterLabel.text=KKStringWithFormat(@"最近访客%ld",KKSharedCurrentUser.visitNum);
    
    if(KKSharedCurrentUser.isVIP)
    {
        [_VIPButton setBackgroundColor:[UIColor colorWithHexString:@"56D658"]];
    }
    if(KKSharedCurrentUser.isBaoYue)
    {
        [_MonthButton setBackgroundColor:[UIColor colorWithHexString:@"56D658"]];
    }
    if(KKSharedCurrentUser.isPhone)
    {
        [_PhoneAuthButton setBackgroundColor:[UIColor colorWithHexString:@"56D658"]];
    }
    if(KKSharedCurrentUser.isIdentity)
    {
        [_idAuthButton setBackgroundColor:[UIColor colorWithHexString:@"56D658"]];
    }
    
}

-(void)headTap:(id)sender
{
    if(self.changeHeadImage) self.changeHeadImage();
}
-(void)likemeTap:(id)sender{
    if(self.likemeBlock) self.likemeBlock();
}
-(void)melikeTap:(id)sender{
    if(self.melikeBlock) self.melikeBlock();
}
-(void)visitTap:(id)sender{
    if(self.visitBlock) self.visitBlock();
}

- (IBAction)getBeanClick:(id)sender {
    if(self.getBeanBlock) self.getBeanBlock();
}
- (IBAction)VIPClick:(id)sender {
    if(self.vipBlock) self.vipBlock();
}
- (IBAction)BaoYueClick:(id)sender {
    if(self.baoyueBlock) self.baoyueBlock();
}

@end
