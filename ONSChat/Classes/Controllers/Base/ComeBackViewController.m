//
//  ComeBackViewController.m
//  KuaiKuai
//
//  Created by liujichang on 15/9/12.
//  Copyright (c) 2015年 liujichang. All rights reserved.
//

#import "ComeBackViewController.h"

@interface ComeBackViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@end

@implementation ComeBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    KKNotificationCenterAddObserverOfSelf(netWorkChanged, FSNetWorkingManagerNotification_NetWorkStatusChanged, nil);
    
    if(KKScreenHeight==KKScreenHeightIphone5) {
        self.bgImageView.image = [UIImage imageNamed:@"LaunchImage-700-568h"];
    }else if (KKScreenHeight==KKScreenHeightIphone6) {
        self.bgImageView.image = [UIImage imageNamed:@"LaunchImage-800-667h"];
    }else if (KKScreenHeight==KKScreenHeightIphone6p) {
        self.bgImageView.image = [UIImage imageNamed:@"LaunchImage-800-Portrait-736h"];
    }else {
        self.bgImageView.image = [UIImage imageNamed:@"LaunchImage-700"];
    }
    
    
}

-(void)netWorkChanged
{
    KKWEAKSELF
    AFNetworkReachabilityStatus status = FSSharedNetWorkingManager.currentNetWorkReachabilityStatus;
    switch (status)
    {
        case AFNetworkReachabilityStatusUnknown:
        case AFNetworkReachabilityStatusNotReachable:
        {
            [weakself enterLogin];
        }
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN:
        case AFNetworkReachabilityStatusReachableViaWiFi:
        {
            //执行静默登录
            NSDictionary *para=@{@"loginname":KKSharedCurrentUser.userId,@"password":KKSharedCurrentUser.password,@"channel":ChannelId};
            [FSSharedNetWorkingManager GET:ServiceInterfaceLogin parameters:para progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSDictionary *loginDic = (NSDictionary*)responseObject;
                KKLog(@"login:%@",loginDic);
                BOOL status1=[loginDic boolForKey:@"status" defaultValue:NO];
                if(status1)
                {
                    [KKAppDelegate loginSucceed:loginDic];
                }
                else
                {
                    [weakself loginFaild:@"您的账号密码不匹配，登录失败"];
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [weakself loginFaild:KKErrorInfo(error)];
            }];
            
        }
            break;
            
        default:
            break;
    }
}

-(void)loginFaild:(NSString*)errorMsg
{
    KKWEAKSELF
    [WCAlertView  showAlertWithTitle:@"温馨提示" message:errorMsg customizationBlock:nil completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
        
        [weakself enterLogin];
        
    } cancelButtonTitle:@"知道了" otherButtonTitles: nil];

}


-(void)enterLogin
{
    //清除用户信息
    [KKUserManager releaseSingleton];
    
    //登录界面
    self.view.window.rootViewController=KKViewControllerOfMainSB(@"LoginNavigationController");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)dealloc
{
    KKNotificationCenterRemoveObserverOfSelf;
}


@end
