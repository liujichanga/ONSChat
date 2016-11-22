//
//  VIPCell.m
//  ONSChat
//
//  Created by liujichang on 2016/11/22.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "VIPCell.h"

@interface VIPCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *vipTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *saleImageView;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;


@end

@implementation VIPCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
