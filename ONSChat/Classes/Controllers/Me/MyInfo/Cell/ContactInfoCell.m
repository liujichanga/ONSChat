//
//  ContactInfoCell.m
//  ONSChat
//
//  Created by 王磊 on 2016/12/7.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "ContactInfoCell.h"
@interface ContactInfoCell()
//手机号
@property (weak, nonatomic) IBOutlet UITextField *weChatText;
@property (weak, nonatomic) IBOutlet UITextField *qqText;
@property (weak, nonatomic) IBOutlet UIButton *publicBtn;

@end

@implementation ContactInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    KKNotificationCenterAddObserverOfSelf(saveInfo, @"saveInfo", nil);

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setUser:(KKUser *)user{
    _user = user;
    self.weChatText.text = user.phone;
    self.qqText.text = user.qq;
}

- (IBAction)publicBtnClick:(UIButton*)sender {
    sender.selected = !sender.selected;
}

-(void)saveInfo{
    KKLog(@"联系方式");
    KKSharedCurrentUser.qq = self.qqText.text;
    KKSharedCurrentUser.phone = self.weChatText.text;
    
}

-(void)dealloc{
    KKNotificationCenterRemoveObserverOfSelf
}
@end
