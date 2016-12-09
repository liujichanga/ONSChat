//
//  MyBaseInfo2Cell.m
//  ONSChat
//
//  Created by 王磊 on 2016/12/8.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "MyBaseInfo2Cell.h"

@interface MyBaseInfo2Cell()
@property (weak, nonatomic) IBOutlet UILabel *infoTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *infoTextLab;

@end

@implementation MyBaseInfo2Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
