//
//  RegisterViewController.m
//  ONSChat
//
//  Created by liujichang on 2016/11/21.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "RegisterViewController.h"
#import "UserInfoViewController.h"
#import "FemaleNickNameViewController.h"

#define MaleColor [UIColor colorWithHexString:@"60D1DA"]

@interface RegisterViewController ()
//男性按钮
@property (weak, nonatomic) IBOutlet UIButton *maleBtn;
//女性按钮
@property (weak, nonatomic) IBOutlet UIButton *femaleBtn;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
    [self subviewsUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //隐藏导航栏
    if (self.navigationController.navigationBarHidden==NO) {
        [self.navigationController setNavigationBarHidden:YES];
    }
}

//子控件处理
-(void)subviewsUI{
    
    CGFloat radius = 40.0;
    
    [self.maleBtn.layer setCornerRadius:radius];
    [self.maleBtn.layer setBorderWidth:1.0];
    [self.maleBtn.layer setBorderColor:MaleColor.CGColor];
    [self.maleBtn.layer setMasksToBounds:YES];
    [self.maleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.maleBtn setBackgroundImage:[UIImage imageWithColor:MaleColor forSize:self.maleBtn.frame.size radius:radius borderWidth:0 borderColor:nil] forState:UIControlStateSelected];
    
    [self.femaleBtn.layer setCornerRadius:radius];
    [self.femaleBtn.layer setBorderWidth:1.0];
    [self.femaleBtn.layer setBorderColor:KKColorPurple.CGColor];
    [self.femaleBtn.layer setMasksToBounds:YES];
    [self.femaleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.femaleBtn setBackgroundImage:[UIImage imageWithColor:KKColorPurple forSize:self.maleBtn.frame.size radius:radius borderWidth:0 borderColor:nil] forState:UIControlStateSelected];
    
}
//男性按钮点击事件
- (IBAction)maleBtnClick:(UIButton*)sender {
    sender.selected = YES;
    self.femaleBtn.selected = NO;
}
//女性按钮点击事件
- (IBAction)femaleBtnClick:(UIButton*)sender {
    sender.selected = YES;
    self.maleBtn.selected = NO;
}
//马上进入
- (IBAction)rightNowEnterClick:(id)sender {
     KKLog(@"进入");
}
//使用协议
- (IBAction)useAgreementClick:(id)sender {
    KKLog(@"协议");
}
//下一步点击事件 男女跳转不同
- (IBAction)nextStepBtnClick:(id)sender {
    KKLog(@"下一步");
    if (self.maleBtn.selected ==YES) {
        KKUser *user=[[KKUser alloc] init];
        KKSharedUserManager.tempUser=user;
        KKSharedUserManager.tempUser.sex = KKMale;
        UserInfoViewController *userInfo = KKViewControllerOfMainSB(@"UserInfoViewController");
        [self.navigationController pushViewController:userInfo animated:YES];
        
    }else if (self.femaleBtn.selected ==YES){
        KKUser *user=[[KKUser alloc] init];
        KKSharedUserManager.tempUser=user;
        KKSharedUserManager.tempUser.sex = KKFemale;
        [self.navigationController setNavigationBarHidden:NO];
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        FemaleNickNameViewController *femaleNick = KKViewControllerOfMainSB(@"FemaleNickNameViewController");
        [self.navigationController pushViewController:femaleNick animated:YES];
        
    }else{
        [MBProgressHUD showMessag:@"请选择性别" toView:nil];
    }
}

@end
