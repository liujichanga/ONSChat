//
//  OneVideoCell.m
//  ONSChat
//
//  Created by liujichang on 2016/11/23.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "OneVideoCell.h"

@interface OneVideoCell()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;

@property(strong,nonatomic) KKUser *user;

@end

@implementation OneVideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle=UITableViewCellSelectionStyleNone;

    [_bgView.layer setMasksToBounds:YES];
    [_bgView.layer setCornerRadius:5.0];
    
    UITapGestureRecognizer *headGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headTap:)];
    [self.bgView addGestureRecognizer:headGestureRecognizer];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)headTap:(id)sender{
    if(self.clickBlock) self.clickBlock(self.user.userId);
}

-(void)displayDic:(KKUser*)user{
    
    _user=user;
    
    _headImageView.image=[UIImage imageNamed:@"def_head"];
    if(KKStringIsNotBlank(user.avatarUrl))
    {
        KKImageViewWithUrlstring(_headImageView, user.avatarUrl, @"def_head");
    }
    _nameLabel.text=user.nickName;
    _ageLabel.text=KKStringWithFormat(@"%ld岁 %@",user.age,user.address);

}

@end
