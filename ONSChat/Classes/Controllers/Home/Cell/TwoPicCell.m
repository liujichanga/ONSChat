//
//  TwoPicCell.m
//  ONSChat
//
//  Created by liujichang on 2016/11/23.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "TwoPicCell.h"

@interface TwoPicCell()

@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UILabel *leftNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftAgeLabel;
@property (weak, nonatomic) IBOutlet UIButton *leftLikeButton;

@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;
@property (weak, nonatomic) IBOutlet UILabel *rightNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightAgeLabel;
@property (weak, nonatomic) IBOutlet UIButton *rightLikeButton;


@property(assign,nonatomic) long long leftUserid;
@property(assign,nonatomic) long long rightUserid;

@end

@implementation TwoPicCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    
    [_leftView.layer setMasksToBounds:YES];
    [_leftView.layer setCornerRadius:5.0];
    [_rightView.layer setMasksToBounds:YES];
    [_rightView.layer setCornerRadius:5.0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)leftLikeClick:(id)sender {
    
    if(self.clickBlock) self.clickBlock(self.leftUserid);
}
- (IBAction)rightLickClick:(id)sender {
  
    if(self.clickBlock) self.clickBlock(self.rightUserid);

}

@end
