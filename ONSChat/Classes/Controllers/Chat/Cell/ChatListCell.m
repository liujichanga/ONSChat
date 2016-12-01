//
//  ChatListCell.m
//  ONSChat
//
//  Created by liujichang on 2016/11/30.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "ChatListCell.h"

@interface ChatListCell()

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *datetimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *chatInfoLabel;


@end

@implementation ChatListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)displayInfo
{
    _nickNameLabel.text=@"我的你跟";
    _ageLabel.text=@"24岁.北京市";
    _datetimeLabel.text=@"11-28";
    _chatInfoLabel.text=@"hi，你好，可以认识你妈";
}

@end
