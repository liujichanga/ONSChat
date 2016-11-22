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
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
