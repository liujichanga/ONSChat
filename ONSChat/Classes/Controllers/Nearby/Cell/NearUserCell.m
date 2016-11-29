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

@property(strong,nonatomic) KKUser *user;

@end

@implementation NearUserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)displayInfo:(KKUser *)user
{
    _user=user;
    
    
}

@end
