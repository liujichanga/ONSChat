//
//  PayViewController.m
//  ONSChat
//
//  Created by liujichang on 2016/12/9.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "PayViewController.h"
#import "PayCell.h"
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
#import "ChatViewController.h"
#import "RecommendUserInfoViewController.h"
#import "BindingPhoneNumberViewController.h"



#define WX_APP_ID @"wx86ad26d7a2f37c7d"
#define WX_PARTNER_ID @"1267310001"


#define cellPayIdentifier @"PayCell"

@interface PayViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(strong,nonatomic) NSString *orderUUID;

@end

@implementation PayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.tableView registerNib:[UINib nibWithNibName:cellPayIdentifier bundle:nil] forCellReuseIdentifier:cellPayIdentifier];

    KKNotificationCenterAddObserverOfSelf(buySucceed, @"buySucceed", nil);
    KKNotificationCenterAddObserverOfSelf(buyFail, @"buyFail", nil);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    KKNotificationCenterRemoveObserverOfSelf;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PayCell *cell=[tableView dequeueReusableCellWithIdentifier:cellPayIdentifier forIndexPath:indexPath];
    [cell showDisplay:indexPath.row];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row==1)
    {
        //微信
        [self pay:1];
    }
    else
    {
        //支付宝
        [self pay:2];
    }
}

-(void)pay:(NSInteger)paytype{
    
    [SVProgressHUD show];
    NSDictionary *dic=@{@"paytype":@(paytype),@"pid":[self.payDic stringForKey:@"id" defaultValue:@""]};
    [FSSharedNetWorkingManager POST:ServiceInterfacePay parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *respDic=(NSDictionary*)responseObject;
        KKLog(@"pay :%@",respDic);
        NSInteger status=[respDic integerForKey:@"status" defaultValue:0];
        if(status==1)
        {
            if(paytype==1)
            {
                NSDictionary *mapDic=[respDic objectForKey:@"map"];
                [self WXPay:mapDic];
            }
            else
            {
                [self AiliPay:respDic];
            }
        }
        else
        {
            [SVProgressHUD dismissWithError:[respDic stringForKey:@"statusMsg" defaultValue:@"发起支付失败"] afterDelay:2.0];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismissWithError:KKErrorInfo(error) afterDelay:2.0];
    }];

}


#pragma mark - 微信支付
-(void)WXPay:(NSDictionary*)respDic
{
    //得到订单ID
    self.orderUUID = [respDic stringForKey:@"order_uuid" defaultValue:@""];
    
    PayReq *request = [[PayReq alloc] init];
    request.partnerId = [respDic stringForKey:@"partnerid" defaultValue:@""];
    request.prepayId= [respDic stringForKey:@"prepayid" defaultValue:@""];
    request.package = [respDic stringForKey:@"package" defaultValue:@""];
    request.nonceStr= [respDic stringForKey:@"noncestr" defaultValue:@""];
    request.timeStamp= [respDic unsignedIntegerForKey:@"timestamp" defaultValue:0];
    request.sign=[respDic stringForKey:@"sign" defaultValue:@""];
    
    
    if(![WXApi isWXAppInstalled])
    {
        [SVProgressHUD dismissWithError:@"您未安装微信，请使用其它支付方式" afterDelay:1.2];
        return;
    }
    
    if(![WXApi sendReq:request])
    {
        [SVProgressHUD dismissWithError:@"无法打开微信支付" afterDelay:1.2];
        return;
    }
    
    [SVProgressHUD dismiss];
    
}

#pragma mark - 支付宝支付
-(void)AiliPay:(NSDictionary*)respDic
{
    //得到订单ID
    self.orderUUID = [respDic stringForKey:@"order_uuid" defaultValue:@""];
    
    NSString *orderString = [respDic stringForKey:@"signStr" defaultValue:@""];
    
    if(KKStringIsBlank(orderString))
    {
        [SVProgressHUD dismissWithError:@"支付异常" afterDelay:1.2];
        return;
    }
    [SVProgressHUD dismiss];
    
    [KKThredUtils runInMainQueue:^{
        
        //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
        NSString *appScheme = @"alisdkonschat";
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"ailipay h5 order reslut = %@,memo=%@",resultDic,[resultDic stringForKey:@"memo" defaultValue:@""]);
            if([[resultDic stringForKey:@"resultStatus" defaultValue:@""] isEqualToString:@"9000"])
            {
                [self buySucceed];
            }
            else
            {
                [self buyFail];
            }
        }];
        
    } delay:0.25];
    
}

#pragma mark - 购买成功通知
-(void)buySucceed
{
    [MobClick event:@"032" label:[self.payDic stringForKey:@"name" defaultValue:@""]];
    
    //检查一下支付信息
    [KKThredUtils runInMainQueue:^{
        
        [FSSharedNetWorkingManager GET:ServiceInterfaceUserCenter parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *dic = (NSDictionary*)responseObject;
            KKLog(@"paycheck:%@",dic);
            BOOL status=[dic boolForKey:@"status" defaultValue:NO];
            if(status)
            {
                NSTimeInterval baoyue=[dic longlongForKey:@"baoyueendtime" defaultValue:0]/1000.0;
                KKSharedCurrentUser.baoyueEndTime=[[NSDate dateWithTimeIntervalSince1970:baoyue] stringYearMonthDay];
                NSTimeInterval vip=[dic longlongForKey:@"vipendtime" defaultValue:0]/1000.0;
                KKSharedCurrentUser.vipEndTime=[[NSDate dateWithTimeIntervalSince1970:vip] stringYearMonthDay];
                
                KKSharedCurrentUser.beannum=[dic integerForKey:@"beannum" defaultValue:0];
                KKSharedCurrentUser.isVIP=[dic boolForKey:@"vip" defaultValue:NO];
                KKSharedCurrentUser.isBaoYue=[dic boolForKey:@"msg" defaultValue:NO];
                
                KKSharedCurrentUser.isPhone=[dic boolForKey:@"hasPhone" defaultValue:NO];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        
    } delay:2.0];
    
    //检测手机号，如果没有绑定，进到绑定手机号
    if(!KKSharedCurrentUser.isPhone)
    {
        BindingPhoneNumberViewController *bindVC = KKViewControllerOfMainSB(@"BindingPhoneNumberViewController");
        bindVC.showText=YES;
        [self.navigationController pushViewController:bindVC animated:YES];
    }
    else
    {
        //回退到的界面
        for (UIViewController *viewController in self.navigationController.viewControllers) {
            if([viewController isKindOfClass:[ChatViewController class]] || [viewController isKindOfClass:[RecommendUserInfoViewController class]])
            {
                [self.navigationController popToViewController:viewController animated:YES];
                return;
            }
        }
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }
    
}

-(void)buyFail
{
    [SVProgressHUD showErrorWithStatus:@"未完成支付" duration:1.5];

    [MobClick event:@"040" label:[self.payDic stringForKey:@"name" defaultValue:@""]];

}



@end
