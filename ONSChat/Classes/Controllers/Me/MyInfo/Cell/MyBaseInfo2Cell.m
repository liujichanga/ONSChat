//
//  MyBaseInfo2Cell.m
//  ONSChat
//
//  Created by 王磊 on 2016/12/8.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "MyBaseInfo2Cell.h"

@interface MyBaseInfo2Cell()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *bgBtns2;
//婚姻状况
@property (weak, nonatomic) IBOutlet UILabel *marryLabel;
//是否要小孩
@property (weak, nonatomic) IBOutlet UILabel *childLabel;
//异地恋
@property (weak, nonatomic) IBOutlet UILabel *distanceLoveLabel;
//喜欢异性类型
@property (weak, nonatomic) IBOutlet UILabel *loveTypeLabel;
//婚前性行为
@property (weak, nonatomic) IBOutlet UILabel *liveTogLabel;
//与父母同住
@property (weak, nonatomic) IBOutlet UILabel *withParentLabel;
//魅力部位
@property (weak, nonatomic) IBOutlet UILabel *posLabel;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labs2;
//选中选项序号
@property (nonatomic, assign) NSInteger selectTag;
@end

@implementation MyBaseInfo2Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    KKNotificationCenterAddObserverOfSelf(showSelcetedInfo:, @"showSelcetedInfo2", nil);
    KKNotificationCenterAddObserverOfSelf(saveInfo, @"saveInfo", nil);
    for (UIButton*btn in _bgBtns2) {
        btn.layer.cornerRadius=8.0;
        btn.layer.masksToBounds = YES;
    }
    _marryLabel.text = KKSharedCurrentUser.marry;
    _childLabel.text = KKSharedCurrentUser.child;
    _distanceLoveLabel.text = KKSharedCurrentUser.distanceLove;
    _loveTypeLabel.text = KKSharedCurrentUser.lovetype;
    _liveTogLabel.text = KKSharedCurrentUser.livetog;
    _withParentLabel.text = KKSharedCurrentUser.withparent;
    _posLabel.text = KKSharedCurrentUser.pos;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)showSelcetedInfo:(NSNotification*)dic{
    NSDictionary *dataDic = dic.userInfo;
    NSString *infoStr = [dataDic stringForKey:@"infoStr" defaultValue:@""];
    UILabel *lab = [self.labs2 objectAtIndex:self.selectTag-1];
    lab.text = infoStr;
}

-(void)saveInfo{
    
    KKLog(@"基本信息2");
}

- (IBAction)bgBtnClick:(UIButton *)sender {
    if (self.infoTypeBlock) {
        self.infoTypeBlock(sender.tag+10);
    }
    self.selectTag = sender.tag;
}

-(void)dealloc{
    KKNotificationCenterRemoveObserverOfSelf
}
@end
