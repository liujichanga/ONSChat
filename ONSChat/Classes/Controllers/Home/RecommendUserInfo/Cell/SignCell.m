//
//  SignCell.m
//  ONSChat
//
//  Created by mac on 2016/11/27.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "SignCell.h"

#define TextFont 16

@interface SignCell()
@property (nonatomic, strong) UILabel *signLab;

@end

@implementation SignCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UILabel *signLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, KKScreenWidth-20, 10)];
    signLab.numberOfLines = 0;
    signLab.font = [UIFont systemFontOfSize:TextFont];
    signLab.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:signLab];
    self.signLab = signLab;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setSignStr:(NSString *)signStr{
    _signStr =signStr;
   
    self.signLab.text = signStr;
    
    CGSize size = [signStr sizeWithFont:[UIFont systemFontOfSize:TextFont] maxSize:CGSizeMake(KKScreenWidth-20, 500)];
    self.signLab.frame = CGRectMake(10, 20, KKScreenWidth-20, size.height);
    if (self.signHeightBlock) {
        self.signHeightBlock(size.height+40);
    }
}
@end
