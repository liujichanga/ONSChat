//
//  RootTabBarController.m
//  KuaiKuai
//
//  Created by jichang.liu on 15/7/5.
//  Copyright (c) 2015年 liujichang. All rights reserved.
//

#import "RootTabBarController.h"



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
    NSArray *normalImages = @[@"tabbar_kk",@"tabbar_found",@"tabbar_gift",@"tabbar_me"];
    NSArray *selectedImages = @[@"tabbar_kk_s",@"tabbar_found_s",@"tabbar_gift_s",@"tabbar_me_s"];
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
