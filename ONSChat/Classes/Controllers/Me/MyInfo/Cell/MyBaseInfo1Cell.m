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

-(void)setUser:(KKUser *)user{
    _user = user;
    
    //显示用户已有信息
    _userIDLab.text = user.userId;
    _userNickName.text = user.nickName;
    _userNickName.delegate = self;
    _userBirthLab.text = user.birthday;
    _cityLab.text = user.address;
    _userHeightLab.text = [NSString stringWithFormat:@"%zdcm",user.height];
    _userWeightLab.text = [NSString stringWithFormat:@"%zdkg",user.weight];
    _bloodLab.text = user.blood;
    _educationLab.text = user.graduate;
    _jbLab.text = user.job;
    _incomeLab.text = user.income;
    if (user.hasCar==YES) {
        _carLab.text =@"是";
    }else{
        _carLab.text =@"否";
    }
    _houseLab.text = user.hasHouse;
}


- (IBAction)btnClick:(UIButton*)sender {
   
    if (self.infoTypeBlock) {
        self.infoTypeBlock(sender.tag);
    }
    //保存选中信息的tag 用于赋值
    self.selectTag = sender.tag;
}
//根据通知传递的信息 赋值
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
    KKSharedCurrentUser.nickName=_userNickName.text;
    KKSharedCurrentUser.birthday=_userBirthLab.text;
    KKSharedCurrentUser.address=_cityLab.text;
    KKSharedCurrentUser.height = [_userHeightLab.text integerValue];
    KKSharedCurrentUser.weight = [_userWeightLab.text integerValue];
    KKSharedCurrentUser.blood=_bloodLab.text;
    KKSharedCurrentUser.graduate=_educationLab.text;
    KKSharedCurrentUser.job=_jbLab.text;
    KKSharedCurrentUser.income=_incomeLab.text;
    KKSharedCurrentUser.hasHouse=_houseLab.text;
    if ([_carLab.text isEqualToString:@"是"]) {
        KKSharedCurrentUser.hasCar=YES;
    }else{
        KKSharedCurrentUser.hasCar=NO;
    }

}

-(void)dealloc{
    KKNotificationCenterRemoveObserverOfSelf
}
@end
