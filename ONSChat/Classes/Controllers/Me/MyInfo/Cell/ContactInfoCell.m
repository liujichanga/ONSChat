//
//  ContactInfoCell.m
//  ONSChat
//
//  Created by 王磊 on 2016/12/7.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "ContactInfoCell.h"
@interface ContactInfoCell()

@property (weak, nonatomic) IBOutlet UITextField *weChatText;
@property (weak, nonatomic) IBOutlet UITextField *qqText;
@property (weak, nonatomic) IBOutlet UIButton *publicBtn;

@end

@implementation ContactInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)publicBtnClick:(id)sender {
    
}

@end
