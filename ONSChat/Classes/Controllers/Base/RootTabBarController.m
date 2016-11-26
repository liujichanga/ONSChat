//
//  RootTabBarController.m
//  KuaiKuai
//
//  Created by jichang.liu on 15/7/5.
//  Copyright (c) 2015年 liujichang. All rights reserved.
//

#import "RootTabBarController.h"
#import "UploadHeadImageViewController.h"
#import "DailyRecommandViewController.h"
#import "BindingPhoneNumberViewController.h"
#import "VIPPayViewController.h"


@interface RootTabBarController ()<UITabBarControllerDelegate>
{
    
}


@end

@implementation RootTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    KKLog(@"root viewdidload");
    
    // Item选中图片
    NSArray *normalImages = @[@"ic_fate_press",@"ic_nearby_press",@"ic_letter_press",@"ic_me_press"];
    NSArray *selectedImages = @[@"ic_fate",@"ic_nearby",@"ic_letter",@"ic_me"];
    // 设置选中图片
    NSArray *viewControllers = self.viewControllers;
    NSUInteger count = viewControllers.count;
    for (NSUInteger i = 0; i < count; i++) {
        UIViewController *vc = viewControllers[i];
        UIImage *normalImage = [[UIImage imageNamed:normalImages[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *selectImage = [[UIImage imageNamed:selectedImages[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

        vc.tabBarItem.image=normalImage;
        vc.tabBarItem.selectedImage = selectImage;
    }
    
    self.delegate = self;
    self.tabBar.tintColor = KKColorPurple;
    self.tabBar.translucent=NO;
    
    KKWEAKSELF
    [KKThredUtils runInMainQueue:^{
        [weakself loginCheck];
    } delay:0.2];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    KKLog(@"root tabbar view did appear");

}

-(void)dealloc
{
    KKNotificationCenterRemoveObserverOfSelf;
    self.viewControllers = nil;
    KKLog(@"tabbar dealloc");
}

-(void)loginCheck
{
    if(KKSharedCurrentUser.sex==KKFemale)
    {
        //女性用户
        if(![KKSharedCurrentUser isPayUser])
        {
            //没有付费，先付费
            VIPPayViewController *vipVC=KKViewControllerOfMainSB(@"VIPPayViewController");
            vipVC.isDismiss=YES;
            UINavigationController *navController=[[UINavigationController alloc] initWithRootViewController:vipVC];
            [self presentViewController:navController animated:YES completion:nil];
        }
        else
        {
            //是否验证过手机号
            if(KKStringIsBlank(KKSharedCurrentUser.phone))
            {
                //验证手机号
                BindingPhoneNumberViewController *bindVC = KKViewControllerOfMainSB(@"BindingPhoneNumberViewController");
                bindVC.isDismiss=YES;
                UINavigationController *navController=[[UINavigationController alloc] initWithRootViewController:bindVC];
                [self presentViewController:navController animated:YES completion:nil];
            }
        }
    }
    else
    {
        //男性用户
        //付费过,没有验证过手机号，先验证手机号
        if([KKSharedCurrentUser isPayUser]&&KKStringIsBlank(KKSharedCurrentUser.phone))
        {
            BindingPhoneNumberViewController *bindVC = KKViewControllerOfMainSB(@"BindingPhoneNumberViewController");
            bindVC.isDismiss=YES;
            UINavigationController *navController=[[UINavigationController alloc] initWithRootViewController:bindVC];
            [self presentViewController:navController animated:YES completion:nil];
        }
        else if(!KKSharedUserManager.isNewReisterUser && KKStringIsBlank(KKSharedCurrentUser.avatarUrl))
        {
            //如果不是新注册用户，并且没有上传头像,需要上传头像
            UploadHeadImageViewController *uploadVC = KKViewControllerOfMainSB(@"UploadHeadImageViewController");
            //uploadVC.showCancelButton=YES;
            UINavigationController *navController=[[UINavigationController alloc] initWithRootViewController:uploadVC];
            [self presentViewController:navController animated:YES completion:nil];
            
        }
        else if(KKSharedUserManager.isNewReisterUser || KKSharedCurrentUser.dayFirst)
        {
            // 如果是今天第一次登陆，需要弹出每日推荐
            DailyRecommandViewController *dailyVC = KKViewControllerOfMainSB(@"DailyRecommandViewController");
            //uploadVC.showCancelButton=YES;
            UINavigationController *navController=[[UINavigationController alloc] initWithRootViewController:dailyVC];
            [self presentViewController:navController animated:YES completion:nil];
        }
    }
    
}




#pragma mark - TabBarControllerDelegate
-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{

    return YES;

}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
   
}

#pragma mark - 屏幕方向
-(BOOL)shouldAutorotate
{
    return NO;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}




@end
