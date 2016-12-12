//
//  HonestBottomCell.m
//  ONSChat
//
//  Created by liujichang on 2016/12/12.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "HonestBottomCell.h"

@interface HonestBottomCell()

@property (weak, nonatomic) IBOutlet UIView *bgView;


@end

@implementation HonestBottomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [_bgView.layer setMasksToBounds:YES];
    [_bgView.layer setCornerRadius:3.0];
    [_bgView.layer setBorderWidth:1.0];
    [_bgView.layer setBorderColor:KKColorPurple.CGColor];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
