//
//  FemaleNickNameViewController.m
//  ONSChat
//
//  Created by 王磊 on 2016/11/23.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "FemaleNickNameViewController.h"
#import "FemaleJobViewController.h"

#define MinLen 2
#define MaxLen 7

@interface FemaleNickNameViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nickNameTextField;
@property (weak, nonatomic) IBOutlet ONSButton *nextStepBtn;

@end

@implementation FemaleNickNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    TopPageView *pageView = [TopPageView showPageViewWith:1];
    [self.view addSubview:pageView];
    
    self.nickNameTextField.delegate = self;
    [self.nickNameTextField addTarget:self action:@selector(changeNickNameTextFiledValue:) forControlEvents:UIControlEventEditingChanged];
    self.nickNameTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    self.nickNameTextField.leftViewMode =  UITextFieldViewModeAlways;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)nextStepBtnClick:(id)sender {
  
    if (self.nickNameTextField.text.length < MinLen){
        [MBProgressHUD showMessag:@"昵称最少2个字" toView:nil];
    }else{
        [self.nickNameTextField resignFirstResponder];
        KKLog(@"nick %@",self.nickNameTextField.text);
        KKSharedUserManager.tempUser.nickName = self.nickNameTextField.text;
        FemaleJobViewController *job = KKViewControllerOfMainSB(@"FemaleJobViewController");
        [self.navigationController pushViewController:job animated:YES];
    }
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.nickNameTextField.text.length < MinLen){
        [MBProgressHUD showMessag:@"昵称最少2个字" toView:nil];
    }else{
        [textField resignFirstResponder];        
    }
    return YES;
}

//限制最大长度
-(void)changeNickNameTextFiledValue:(UITextField*)textField
{
    NSString* text = [textField text];
    if (textField.text.length > MaxLen)
    {
        textField.text = [text substringToIndex:MaxLen];
    }
}
@end
