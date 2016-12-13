//
//  AppDelegate.m
//  ONSChat
//
//  Created by liujichang on 2016/11/19.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "AppDelegate.h"
#import <RongIMLib/RongIMLib.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
#import "IQKeyboardManager.h"


@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window=[[UIWindow alloc] initWithFrame:KKScreenBounds];
    self.window.backgroundColor=[UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [UINavigationBar appearance].barStyle=UIBarStyleBlack;
    if(KKOSVersion>=8.0) [UINavigationBar appearance].translucent=YES;
    //[UINavigationBar appearance].barTintColor=KKColorNav;
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];

    //高德
    //[[AMapServices sharedServices] setEnableHTTPS:YES];
    [AMapServices sharedServices].apiKey =@"ed83d4ee46c20bb50b74a741449c8c6b";
    
    //开始定位
    [KKSharedGlobalManager locationGPS];

    //network init
    FSSharedNetWorkingManager;
    
    //微信appid
    [WXApi registerApp:@"wx18755d15c1b89107"];
    
    //友盟
    UMConfigInstance.appKey = @"57bc000ce0f55a347e000f3d";
    UMConfigInstance.channelId = @"AppStore";
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    [MobClick setAppVersion:KKAppVersion];

    
    //最后一个登录用户
    KKUser *lastLoginUser = [KKSharedUserManager lastLoginUser];

    if (KKSharedUserManager.isAutoLoginEnabled) {
        
        // 最后一个登录的用户
        KKSharedUserManager.currentUser = lastLoginUser;
        
        // 开启comback界面
        self.window.rootViewController = KKViewControllerOfMainSB(@"ComeBackViewController");
    } else {
        
        if(KKStringIsBlank(lastLoginUser.userId) ||KKStringIsBlank(lastLoginUser.password))
        {
            //注册界面
            self.window.rootViewController=KKViewControllerOfMainSB(@"RegisterNavigationController");
        }
        else
        {
            //登录界面
            self.window.rootViewController=KKViewControllerOfMainSB(@"LoginNavigationController");
        }
        
        
    }
    
    [IQKeyboardManager sharedManager].shouldShowTextFieldPlaceholder = NO;
    [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 4.0;
    [IQKeyboardManager sharedManager].canAdjustTextView = NO;
    [IQKeyboardManager sharedManager].shouldAdoptDefaultKeyboardAnimation = YES;
    [IQKeyboardManager sharedManager].shouldRestoreScrollViewContentOffset = YES;
    
    return YES;
}

//挂起 当有电话进来或者锁屏,或者进入后台，这时你的应用程会挂起
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    
    //添加一个通知
    [self addNotification];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}

//程序已经被激活 lanuch或者后台激活都会调用
- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    //取消所有通知
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    KKLog(@"sourcebundleid:%@,url:%@,annotaion:%@",sourceApplication,url,annotation);
    
    if([sourceApplication hasPrefix:@"com.alipay"])
    {
        if ([url.host isEqualToString:@"safepay"]) {
            //跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"alipayresult = %@，%@",resultDic,[resultDic stringForKey:@"memo" defaultValue:@""]);
                if([[resultDic stringForKey:@"resultStatus" defaultValue:@""] isEqualToString:@"9000"])
                {
                    [KKNotificationCenter postNotificationName:@"buySucceed" object:nil];
                }
                else
                {
                    [KKNotificationCenter postNotificationName:@"buyFail" object:nil];
                }
            }];
        }
    }
    else if([sourceApplication hasPrefix:@"com.tencent"])
    {
        //com.tencent.wx.xxxxx
        return [WXApi handleOpenURL:url delegate:self];
    }
    
    return YES;
}

#pragma mark - AddNotification
-(void)addNotification{
    
    NSArray *arr=@[@"你附近的妹子看上你啦，快去瞅瞅~",@"你附近刚刚注册了3位美女，快去打个招呼~",@"附近有妹子喜欢你啦，快去勾搭她一下哦~",@"一大波妹子更新了动态，快去看看都是啥？",@"不要帅不要钱，身体好的就放马过来吧！"];
    int value = arc4random() % arr.count;
    NSString *title=arr[value];
    
    //注册本地通知
    UILocalNotification *notification=[[UILocalNotification alloc] init];
    notification.repeatInterval=0;
    
    NSDate *date = [[NSDate date] dateByAddingTimeInterval:5];
    notification.fireDate=date;
    
    //设置通知属性
    notification.alertBody=title;
    
    notification.soundName=UILocalNotificationDefaultSoundName;
    
    //登记通知
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    
}

#pragma mark -Weixin Delegate
//微信返回的调用
-(void)onResp:(BaseResp *)resp
{
    KKLog(@"onresp:%@",resp);
    
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        PayResp *response=(PayResp*)resp;
        KKLog(@"payresp:%@",response.returnKey);
        switch (resp.errCode) {
            case WXSuccess:
                [KKNotificationCenter postNotificationName:@"buySucceed" object:nil];
                break;
                
            default:
                [KKNotificationCenter postNotificationName:@"buyFail" object:nil];
                break;
        }
    }
   
}

-(void)loginSucceed:(NSDictionary *)dic
{
    NSTimeInterval baoyue=[dic longlongForKey:@"baoyueendtime" defaultValue:0]/1000.0;
    KKSharedCurrentUser.baoyueEndTime=[[NSDate dateWithTimeIntervalSince1970:baoyue] stringYearMonthDay];
    NSTimeInterval vip=[dic longlongForKey:@"vipendtime" defaultValue:0]/1000.0;
    KKSharedCurrentUser.vipEndTime=[[NSDate dateWithTimeIntervalSince1970:vip] stringYearMonthDay];

    KKSharedCurrentUser.beannum=[dic integerForKey:@"beanCount" defaultValue:0];
    KKSharedCurrentUser.sex=[dic integerForKey:@"gender" defaultValue:0];
    KKSharedCurrentUser.isVIP=[dic boolForKey:@"isVIP" defaultValue:NO];
    KKSharedCurrentUser.isBaoYue=[dic boolForKey:@"isMonth" defaultValue:NO];
    KKSharedCurrentUser.phone=@"dd";//[dic stringForKey:@"phone" defaultValue:@""];
    KKSharedCurrentUser.dayFirst=[dic boolForKey:@"dayfirst" defaultValue:NO];
    NSLog(@"user:%@,phone:%@,vip:%zd,baoyue:%zd,benum:%ld,endtime:%@",KKSharedCurrentUser,KKSharedCurrentUser.phone,KKSharedCurrentUser.isVIP,KKSharedCurrentUser.isBaoYue,KKSharedCurrentUser.beannum,KKSharedCurrentUser.vipEndTime);
    
    //获取头像
    NSString *avater = [KKSharedLocalPlistManager kkValueForKey:Plist_Key_Avatar];
    if(KKStringIsNotBlank(avater))
    {
        KKSharedCurrentUser.avatarUrl=[CacheUserPath stringByAppendingPathComponent:avater];
    }
    
    KKSharedUserManager.autoLoginEnabled=YES;
    
    //初始化融云 kk tdrvipkstmvn5 LDpIUJgUlRtOp67IiaTnRb0/q7qZMBWE3fN7edgYT61aHERUomyfJPgvOB84LbqNpd7G4pmzkjwMtb7ko7j2Y0AJpwass/7g
    [[RCIMClient sharedRCIMClient] initWithAppKey:@"8w7jv4qb7vsoy"];//8w7jv4qb7vsoy [dic stringForKey:@"token" defaultValue:@""]
    
    NSString *tokent=[dic stringForKey:@"token" defaultValue:@""];
    [[RCIMClient sharedRCIMClient] connectWithToken:tokent success:^(NSString *userId) {
        NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
    } error:^(RCConnectErrorCode status) {
        NSLog(@"登陆的错误码为:%zd", status);
    } tokenIncorrect:^{
        //token过期或者不正确。
        //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
        //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
        NSLog(@"token错误");
    }];
    
    //初始化数据库
    ONSSharedConversationDao;
    ONSSharedMessageDao;
    
    self.window.rootViewController=KKInitViewControllerOfMainSB;
}


@end
