//
//  FemaleHeightViewController.m
//  ONSChat
//
//  Created by 王磊 on 2016/11/24.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "FemaleHeightViewController.h"
#import "FemaleIncomeViewController.h"

@interface FemaleHeightViewController ()
@property (weak, nonatomic) IBOutlet UIPickerView *heightPicker;

@end

@implementation FemaleHeightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    TopPageView *pageView = [TopPageView showPageViewWith:3];
    [self.view addSubview:pageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)nextStepBtnClick:(id)sender {
    NSInteger row = [self.heightPicker selectedRowInComponent:0];
    NSString *heightStr = [KKSharedGlobalManager.heightArr objectAtIndex:row];
    KKLog(@"height %@",heightStr);
    KKSharedUserManager.tempUser.height = [heightStr integerValue];
    
    FemaleIncomeViewController *income = KKViewControllerOfMainSB(@"FemaleIncomeViewController");
    [self.navigationController pushViewController:income animated:YES];
}

#pragma mark - UIPickerViewDataSource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return KKSharedGlobalManager.heightArr.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(KKSharedGlobalManager.heightArr.count>row)
    {
        return [KKSharedGlobalManager.heightArr objectAtIndex:row];
    }
    else return @"";
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{

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
@end
