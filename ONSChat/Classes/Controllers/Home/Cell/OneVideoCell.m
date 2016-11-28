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


@end

@implementation OneVideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle=UITableViewCellSelectionStyleNone;

    [_bgView.layer setMasksToBounds:YES];
    [_bgView.layer setCornerRadius:5.0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)displayDic:(KKUser*)user{
    
}

@end
