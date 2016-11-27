//
//  ContactWayCell.m
//  ONSChat
//
//  Created by mac on 2016/11/27.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "ContactWayCell.h"
@interface ContactWayCell()

@property (weak, nonatomic) IBOutlet UILabel *contactWayLab;
@property (weak, nonatomic) IBOutlet UIButton *lookBtn;

@end

@implementation ContactWayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setContactStr:(NSString *)contactStr{
    _contactStr = contactStr;
    self.contactWayLab.text = contactStr;
}

- (IBAction)lookBtnClick:(id)sender {
    if (self.lookBlock) {
        self.lookBlock();
    }
}

@end
