//
//  MySignCell.m
//  ONSChat
//
//  Created by 王磊 on 2016/12/7.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "MySignCell.h"

@interface MySignCell()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *signText;

@end

@implementation MySignCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _signText.delegate = self;
    _signText.layer.borderWidth = 0.5;
    _signText.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
