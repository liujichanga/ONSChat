//
//  BaoYueBottomCell.m
//  ONSChat
//
//  Created by liujichang on 2016/12/10.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "BaoYueBottomCell.h"

@interface BaoYueBottomCell()

@property (weak, nonatomic) IBOutlet UILabel *sphoneLabel;


@end

@implementation BaoYueBottomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle=UITableViewCellSelectionStyleNone;

    NSString *str=KKStringWithFormat(@"客服热线：%@",KKSharedGlobalManager.SPhone);
    NSRange rang=NSMakeRange(5, KKSharedGlobalManager.SPhone.length);
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:rang];
    [attributedString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, str.length)];
    [attributedString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleNone] range:NSMakeRange(0, 5)];
    
    _sphoneLabel.attributedText=attributedString;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
