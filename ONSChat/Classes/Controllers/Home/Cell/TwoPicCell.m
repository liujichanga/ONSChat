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


@end

@implementation TwoPicCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_leftView.layer setMasksToBounds:YES];
    [_leftView.layer setCornerRadius:3.0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)leftLikeClick:(id)sender {
}

@end
