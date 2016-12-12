//
//  VIPHeadCell.m
//  ONSChat
//
//  Created by liujichang on 2016/12/8.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "VIPHeadCell.h"

@interface VIPHeadCell()

@property (weak, nonatomic) IBOutlet UILabel *vipTitleLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line1LeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line2LeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneImageViewLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *qqImageViewLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wxImageViewLeftConstraint;

@end

@implementation VIPHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle=UITableViewCellSelectionStyleNone;

    NSRange rang=NSMakeRange(0, 5);
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"VIP会员功能特权"];
    [attributedString addAttribute:NSForegroundColorAttributeName value:KKColorPurple range:rang];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:rang];
    _vipTitleLabel.attributedText=attributedString;
    
    CGFloat width=KKScreenWidth*1.0/3.0;
    _line1LeftConstraint.constant=width;
    _line2LeftConstraint.constant=width;
    
    CGFloat imageleft=width*0.5-18.5;
    _phoneImageViewLeftConstraint.constant=imageleft;
    _qqImageViewLeftConstraint.constant=imageleft;
    _wxImageViewLeftConstraint.constant=imageleft;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
