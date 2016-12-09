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
#import <RongIMLib/RongIMLib.h>

@interface RootTabBarController ()<UITabBarControllerDelegate,RCIMClientReceiveMessageDelegate>
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
    
    //tabbar badge
    [self initTabBarBadge];

    
    //未读数量
    KKNotificationCenterAddObserverOfSelf(unReadCount:, ONSChatManagerNotification_UnReadCount, nil);
    
    
    KKWEAKSELF
    [KKThredUtils runInMainQueue:^{
        [weakself loginCheck];
    } delay:0.2];
    
 
    // 设置消息接收监听
    [[RCIMClient sharedRCIMClient] setReceiveMessageDelegate:self object:nil];
    
    //读取客服电话
    [KKSharedGlobalManager getSPhone];
    
    //读取是否IAP
    [KKSharedGlobalManager getIAP];
}

#pragma mark - Tabbar Dadge
-(void)initTabBarBadge
{
    UIView *badgeView=[[UIView alloc] initWithFrame:CGRectMake(0.66*KKScreenWidth, 0.05 * self.tabBar.frame.size.height, 18, 18)];
    badgeView.backgroundColor=KKColorPurple;
    [badgeView.layer setMasksToBounds:YES];
    [badgeView.layer setCornerRadius:9.0];
    badgeView.tag=100;
    
    UILabel *badgeLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 17, 17)];
    badgeLabel.text=@"0";
    badgeLabel.tag=101;
    badgeLabel.font=[UIFont systemFontOfSize:13];
    badgeLabel.adjustsFontSizeToFitWidth=YES;
    badgeLabel.textAlignment=NSTextAlignmentCenter;
    badgeLabel.textColor=[UIColor whiteColor];
    badgeLabel.minimumScaleFactor=0.5;
    badgeLabel.center=CGPointMake(badgeView.frame.size.width*0.5, badgeView.frame.size.height*0.5);
    
    [badgeView addSubview:badgeLabel];
    
    [self.tabBar addSubview:badgeView];
    
    badgeView.hidden=YES;
}


#pragma mark - UnReadCount
-(void)unReadCount:(NSNotification*)notification
{
    if(notification.object)
    {
        NSNumber *num=(NSNumber*)notification.object;
        NSInteger count = [num integerValue];
       
        UIView *badgeview=[self.tabBar viewWithTag:100];
        if(badgeview)
        {
            if(count<=0)
            {
                badgeview.hidden=YES;
                return;
            }
            
            badgeview.hidden=NO;
            UIView *labelview=[badgeview viewWithTag:101];
            if(labelview)
            {
                UILabel *label=(UILabel*)labelview;
                label.text=KKStringWithFormat(@"%ld",count);
            }
        }
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    KKLog(@"root tabbar view did appear");

}

-(void)dealloc
{
    [[RCIMClient sharedRCIMClient] setReceiveMessageDelegate:nil object:nil];
    
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
            return;
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

#pragma mark - RC
- (void)onReceived:(RCMessage *)message left:(int)nLeft object:(id)object {
    if ([message.content isMemberOfClass:[RCTextMessage class]]) {
        RCTextMessage *textMessage = (RCTextMessage *)message.content;
        NSLog(@"消息内容：%@", textMessage.content);
        [KKSharedONSChatManager receiveMessage:textMessage.content];
    }
    
}


#pragma mark - TabBarControllerDelegate
-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
   
}



@end
