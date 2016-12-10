//
//  MyBaseInfo1Cell.m
//  ONSChat
//
//  Created by 王磊 on 2016/12/8.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "MyBaseInfo1Cell.h"
@interface MyBaseInfo1Cell()<UITextFieldDelegate>
//ID
@property (weak, nonatomic) IBOutlet UILabel *userIDLab;
//昵称
@property (weak, nonatomic) IBOutlet UITextField *userNickName;
//生日
@property (weak, nonatomic) IBOutlet UILabel *userBirthLab;
//居住地
@property (weak, nonatomic) IBOutlet UILabel *cityLab;
//身高
@property (weak, nonatomic) IBOutlet UILabel *userHeightLab;
//体重
@property (weak, nonatomic) IBOutlet UILabel *userWeightLab;
//血型
@property (weak, nonatomic) IBOutlet UILabel *bloodLab;
//学历
@property (weak, nonatomic) IBOutlet UILabel *educationLab;
//职业
@property (weak, nonatomic) IBOutlet UILabel *jbLab;
//收入
@property (weak, nonatomic) IBOutlet UILabel *incomeLab;
//是否有车
@property (weak, nonatomic) IBOutlet UILabel *carLab;
//是否有房
@property (weak, nonatomic) IBOutlet UILabel *houseLab;
//选项按钮集合
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *bgBtns;
//选项label集合
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labs;
//选中选项序号
@property (nonatomic, assign) NSInteger selectTag;
@end

@implementation MyBaseInfo1Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _userIDLab.text = KKSharedCurrentUser.userId;
    _userNickName.text = KKSharedCurrentUser.nickName;
    _userNickName.delegate = self;
    _userBirthLab.text = KKSharedCurrentUser.birthday;
    _cityLab.text = KKSharedCurrentUser.address;
    _userHeightLab.text = [NSString stringWithFormat:@"%zdcm",KKSharedCurrentUser.height];
    _userWeightLab.text = [NSString stringWithFormat:@"%zdkg",KKSharedCurrentUser.weight];
    _bloodLab.text = KKSharedCurrentUser.blood;
    _educationLab.text = KKSharedCurrentUser.graduate;
    _jbLab.text = KKSharedCurrentUser.job;
    _incomeLab.text = KKSharedCurrentUser.income;
    if (KKSharedCurrentUser.hasCar==YES) {
        _carLab.text =@"是";
    }else{
         _carLab.text =@"否";
    }
    _houseLab.text = KKSharedCurrentUser.hasHouse;
   
    for (UIButton*btn in _bgBtns) {
        btn.layer.cornerRadius=8.0;
        btn.layer.masksToBounds = YES;
    }
    KKNotificationCenterAddObserverOfSelf(showSelcetedInfo:, @"showSelcetedInfo1", nil);
    KKNotificationCenterAddObserverOfSelf(saveInfo, @"saveInfo", nil);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)btnClick:(UIButton*)sender {
   
    if (self.infoTypeBlock) {
        self.infoTypeBlock(sender.tag);
    }
    self.selectTag = sender.tag;
}

-(void)showSelcetedInfo:(NSNotification*)dic{
    NSDictionary *dataDic = dic.userInfo;
    NSString *infoStr = [dataDic stringForKey:@"infoStr" defaultValue:@""];
    UILabel *lab = [self.labs objectAtIndex:self.selectTag-1];
    lab.text = infoStr;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


-(void)saveInfo{
    
    KKLog(@"基本信息1");
}

-(void)dealloc{
    KKNotificationCenterRemoveObserverOfSelf
}
@end
