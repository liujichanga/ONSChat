//
//  UserInfoViewController.m
//  ONSChat
//
//  Created by 王磊 on 2016/11/23.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "UserInfoViewController.h"
#import "UserHobbyViewController.h"

//最小年龄
#define minAge 18
//最大年龄
#define maxAge 50


@interface UserInfoViewController ()<UITextFieldDelegate>
//昵称输入
@property (weak, nonatomic) IBOutlet UITextField *nickNameText;
//年龄选择
@property (weak, nonatomic) IBOutlet UIPickerView *agePicker;
//年龄数组 18-50
@property (nonatomic, strong) NSMutableArray *ageArray;
//居住地
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
//下一步
@property (weak, nonatomic) IBOutlet ONSButtonPurple *nextStepBtn;

@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.ageArray = [NSMutableArray array];
    
    for (int i = minAge; i <= maxAge; ++i) {
        NSString *ageStr = [NSString stringWithFormat:@"%d",i];
        [self.ageArray addObject:ageStr];
    }
//    self.nickNameText.placeholder = @"占位昵称";
    self.nickNameText.delegate = self;
    self.cityLabel.text = KKSharedGlobalManager.GPSCity;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//随机昵称
- (IBAction)randomNameClick:(id)sender {
    [self.nickNameText resignFirstResponder];

    self.nickNameText.text = @"随机昵称";
    
}
//下一步
- (IBAction)nextStepBtnClick:(id)sender {
    NSString *nickName = self.nickNameText.text;
    if (nickName.length==0) {
        [MBProgressHUD showMessag:@"请输入昵称" toView:nil];
    }else{
        NSInteger row = [self.agePicker selectedRowInComponent:0];
        NSString *ageStr = [self.ageArray objectAtIndex:row];
        
        KKLog(@"nickName %@--age %@",nickName,ageStr);
        KKSharedUserManager.tempUser.nickName = nickName;
        KKSharedUserManager.tempUser.age = [ageStr integerValue];
        UserHobbyViewController *hobby = KKViewControllerOfMainSB(@"UserHobbyViewController");
        [self.navigationController pushViewController:hobby animated:YES];
    }
}

#pragma mark - UIPickerViewDataSource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.ageArray.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(self.ageArray.count>row)
    {
        return [self.ageArray objectAtIndex:row];
    }
    else return @"";
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    //去掉中央两条横线
    ((UIView *)[pickerView.subviews objectAtIndex:1]).backgroundColor = [UIColor clearColor];
    
    ((UIView *)[pickerView.subviews objectAtIndex:2]).backgroundColor = [UIColor clearColor];
    //自定义字体颜色
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:20]];
        [pickerLabel setTextColor:KKColorPurple];
    }

    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    pickerLabel.textAlignment = NSTextAlignmentCenter;
    return pickerLabel;
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
