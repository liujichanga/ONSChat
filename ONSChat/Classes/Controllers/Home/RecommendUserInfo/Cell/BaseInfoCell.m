//
//  BaseInfoCell.m
//  ONSChat
//
//  Created by 王磊 on 2016/11/26.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "BaseInfoCell.h"

#define TextFont 16

@interface BaseInfoCell()
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *descLab;

@end

@implementation BaseInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 10, self.contentView.frame.size.height)];
    title.textAlignment = NSTextAlignmentLeft;
    title.numberOfLines = 1;
    title.textColor = [UIColor lightGrayColor];
    title.font = [UIFont systemFontOfSize:TextFont];
    
    UILabel *desc = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 10, self.contentView.frame.size.height)];
    desc.textAlignment = NSTextAlignmentRight;
    desc.numberOfLines = 1;
    desc.textColor = [UIColor lightGrayColor];
    desc.font = [UIFont systemFontOfSize:TextFont];


    [self.contentView addSubview:title];
    [self.contentView addSubview:desc];
    self.titleLab = title;
    self.descLab = desc;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setTextArr:(NSArray *)textArr{
    _textArr = textArr;
    self.titleLab.text = [textArr firstObject];
    [self.titleLab sizeToFit];
    self.titleLab.frame = CGRectMake(10, 0, self.titleLab.frame.size.width, self.contentView.frame.size.height);
    
    self.descLab.frame = CGRectMake(self.titleLab.frame.origin.x+self.titleLab.frame.size.width+20, 0, self.contentView.frame.size.width-self.titleLab.frame.origin.x-self.titleLab.frame.size.width-30, self.contentView.frame.size.height);
    NSString *descStr = [textArr lastObject];
    CGSize textSize = [descStr sizeWithFont:[UIFont systemFontOfSize:TextFont]];
    self.descLab.textAlignment = NSTextAlignmentRight;
    self.descLab.numberOfLines = 1;
    if (textSize.width>self.descLab.frame.size.width) {
        self.descLab.numberOfLines =2;
        self.descLab.textAlignment = NSTextAlignmentLeft;
    }
    self.descLab.text = descStr;
    
}

@end
