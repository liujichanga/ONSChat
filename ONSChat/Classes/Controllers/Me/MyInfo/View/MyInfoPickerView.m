//
//  MyInfoPickerView.m
//  ONSChat
//
//  Created by 王磊 on 2016/12/9.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "MyInfoPickerView.h"

@interface MyInfoPickerView ()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIDatePicker *birthDayPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *infoPicker;
//所选信息类型
@property (nonatomic, assign) MyInfoType infoType;
//省份数组
@property(strong,nonatomic) NSArray *provinceArray;
//城市数组
@property(strong,nonatomic) NSArray *cityArray;
//其他信息数据
@property (nonatomic, strong) NSArray *infoDataArray;
//选中信息数据 用于cell显示
@property (nonatomic, strong) NSString *infoStr;
@end

@implementation MyInfoPickerView

+(instancetype)createMyInfoPickerViewFrame:(CGRect)frame inView:(UIView*)view{
    
    MyInfoPickerView *infoPicker = KKViewOfMainBundle(@"MyInfoPickerView");

    infoPicker.frame = frame;
    [view addSubview:infoPicker];
    infoPicker.hidden =YES;
    return infoPicker;
}

-(void)awakeFromNib{
    [super awakeFromNib];

    //防止重复创建
    if (self.gestureRecognizers.count==0) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(close:)];
        [self addGestureRecognizer:tap];
    }
    self.infoPicker.delegate = self;

}

-(void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    
}

-(void)showInfoPickerViewWithType:(MyInfoType)type{
    self.hidden = NO;
    self.infoType = type;
    self.infoPicker.hidden = NO;
    self.birthDayPicker.hidden = YES;
    self.infoStr = nil;
    self.provinceArray = nil;
    self.cityArray = nil;
    self.infoDataArray = nil;
    [self.infoPicker selectRow:0 inComponent:0 animated:YES];
    
    switch (type) {
        case MyInfoType_Birthday:{
            self.infoPicker.hidden = YES;
            self.birthDayPicker.hidden = NO;
            break;
        }
        case MyInfoType_Address:{
            
            NSString *path = KKPathOfMainBundle(@"city",@"plist");
            self.provinceArray = [NSArray arrayWithContentsOfFile:path];
            NSDictionary *dic = [self.provinceArray objectAtIndex:0];
            self.cityArray = [dic objectForKey:@"city"];
            break;
        }
        case MyInfoType_Height:
            self.infoDataArray = [NSArray arrayWithArray:KKSharedGlobalManager.heightArr];
            break;
        case MyInfoType_Weight:
            self.infoDataArray = [NSArray arrayWithArray:KKSharedGlobalManager.weightArr];
            break;
        case MyInfoType_Blood:
            self.infoDataArray = [NSArray arrayWithArray:KKSharedGlobalManager.bloodArr];
            break;
        case MyInfoType_Graduate:{
            NSString *graduateStr = [self.dataDic stringForKey:@"graduate" defaultValue:@""];
            self.infoDataArray = [graduateStr componentsSeparatedByString:@","];
        }
            break;
        case MyInfoType_Job:{
            NSString *jobStr = [self.dataDic stringForKey:@"job" defaultValue:@""];
            self.infoDataArray = [jobStr componentsSeparatedByString:@","];
        }
            break;
        case MyInfoType_Income:{
            NSString *incomeStr = [self.dataDic stringForKey:@"income" defaultValue:@""];
            self.infoDataArray = [incomeStr componentsSeparatedByString:@","];
        }
            break;
        case MyInfoType_HasCar:{
            NSString *carStr = [self.dataDic stringForKey:@"car" defaultValue:@""];
            self.infoDataArray = [carStr componentsSeparatedByString:@","];

        }
            break;
        case MyInfoType_HasHouse:{
            NSString *houseStr = [self.dataDic stringForKey:@"house" defaultValue:@""];
            self.infoDataArray = [houseStr componentsSeparatedByString:@","];

        }
            break;
        default:
            break;
    }
    [self awakeFromNib];

}

-(void)close:(UITapGestureRecognizer*)tap{
//    [self removeFromSuperview];
    self.hidden = YES;
}

- (IBAction)OKBtnClick:(id)sender {
    
    if (self.infoType==MyInfoType_Birthday) {
        self.infoStr = [self.birthDayPicker.date stringYearMonthDay];
    }
    else if (self.infoType==MyInfoType_Address){
        NSInteger proviceRow = [self.infoPicker selectedRowInComponent:0];
        NSInteger cityRow = [self.infoPicker selectedRowInComponent:1];
        
        NSDictionary *proDic = [self.provinceArray objectAtIndex:proviceRow];
        NSString *provice = [proDic stringForKey:@"name" defaultValue:@""];
        
        NSDictionary *cityDic = [self.cityArray objectAtIndex:cityRow];
        NSString *city = [cityDic stringForKey:@"name" defaultValue:@""];
        
        self.infoStr = [NSString stringWithFormat:@"%@-%@",provice,city];

    }else if(self.infoType ==MyInfoType_Height) {
        NSInteger row = [self.infoPicker selectedRowInComponent:0];
        self.infoStr = [NSString stringWithFormat:@"%@cm",[self.infoDataArray objectAtIndex:row]];
    }else if(self.infoType ==MyInfoType_Weight) {
        NSInteger row = [self.infoPicker selectedRowInComponent:0];
        self.infoStr = [NSString stringWithFormat:@"%@kg",[self.infoDataArray objectAtIndex:row]];
    }else{
        NSInteger row = [self.infoPicker selectedRowInComponent:0];
        self.infoStr = [self.infoDataArray objectAtIndex:row];
    }
    self.hidden = YES;
    NSDictionary *notDic = @{@"infoStr":self.infoStr};
    [KKNotificationCenter postNotificationName:@"showSelcetedInfo" object:nil userInfo:notDic];
}

#pragma mark - UIPickerViewDataSource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (self.infoType==MyInfoType_Birthday) {
        return 3;
    }else if (self.infoType==MyInfoType_Address){
        return 2;
    }else{
        return 1;
    }
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{

    if (self.infoType==MyInfoType_Address){
        if (component==0) {
            return self.provinceArray.count;
        }else{
            return self.cityArray.count;
        }
    }else{
        return self.infoDataArray.count;
    }
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{

    if (self.infoType==MyInfoType_Address){
        if(component == 0)
        {
            if(self.provinceArray.count>row)
            {
                NSDictionary *dic = [self.provinceArray objectAtIndex:row];
                
                return [dic stringForKey:@"name" defaultValue:@""];
            }
            return @"";
        }
        else
        {
            if(self.cityArray.count>row)
            {
                NSDictionary *dic = [self.cityArray objectAtIndex:row];
                
                return [dic stringForKey:@"name" defaultValue:@""];
            }
            return @"";
        }
    }else if (self.infoType == MyInfoType_Height){
        if (self.infoDataArray.count>row) {
            NSString *infoStr = [NSString stringWithFormat:@"%@cm",[self.infoDataArray objectAtIndex:row]];
            
            return infoStr;
        }
        return @"";
    }else if (self.infoType == MyInfoType_Weight){
        if (self.infoDataArray.count>row) {
            NSString *infoStr = [NSString stringWithFormat:@"%@kg",[self.infoDataArray objectAtIndex:row]];
            
            return infoStr;
        }
        return @"";
    }else{
        if (self.infoDataArray.count>row) {
            NSString *infoStr = [self.infoDataArray objectAtIndex:row];
            
            return infoStr;
        }
        return @"";
    }

}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if (self.infoType==MyInfoType_Address){
        if (component == 0) {
            NSDictionary *dic = [self.provinceArray objectAtIndex:row];
            self.cityArray = [dic objectForKey:@"city"];
            //重点！更新第二个轮子的数据
            [self.infoPicker reloadComponent:1];
        }
    }
}

-(void)dealloc{
    KKNotificationCenterRemoveObserverOfSelf
    KKLog(@"info picker view dealloc");
}

@end
