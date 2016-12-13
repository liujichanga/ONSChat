//
//  VIPPayViewController.m
//  ONSChat
//
//  Created by liujichang on 2016/11/26.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "VIPPayViewController.h"
#import "VIPHeadCell.h"
#import "VIPProductCell.h"
#import "VIPBottomCell.h"
#import "PayViewController.h"
#import "ChatViewController.h"
#import "RecommendUserInfoViewController.h"


#define cellVIPHeadIdentifier @"VIPHeadCell"
#define cellVIPProductIdentifier @"VIPProductCell"
#define cellVIPBottomIdentifier @"VIPBottomCell"

#define VIPID_30Day @"VIP001"
#define VIPID_90Day @"VIP002"
#define VIPID_365Day @"VIP003"


@interface VIPPayViewController ()<UITableViewDelegate,UITableViewDataSource,FSStoreDelegate>

@property(strong,nonatomic) NSMutableArray *arrDatas;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(strong,nonatomic) FSStore *store;

@end

@implementation VIPPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [MobClick event:@"030"];
    
    //使用registerNib 方法可以从XIB加载控件
    [self.tableView registerNib:[UINib nibWithNibName:cellVIPHeadIdentifier bundle:nil] forCellReuseIdentifier:cellVIPHeadIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:cellVIPProductIdentifier bundle:nil] forCellReuseIdentifier:cellVIPProductIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:cellVIPBottomIdentifier bundle:nil] forCellReuseIdentifier:cellVIPBottomIdentifier];

    self.arrDatas=[NSMutableArray array];
    self.store=[[FSStore alloc] init];
    self.store.delegate=self;
    
    if(KKSharedGlobalManager.isIAP)
    {
        [self.arrDatas addObjectsFromArray:@[@{@"name":@"318元，立即享受1年帝王待遇",@"id":VIPID_365Day},@{@"name":@"108元，立即享受90天帝王待遇",@"id":VIPID_90Day},@{@"name":@"50元，立即享受30天帝王待遇",@"id":VIPID_30Day}]];
        
        [self.tableView reloadData];
        return;
    }
    
    NSDictionary *dic=@{@"type":@(3),@"gender":@(KKSharedCurrentUser.sex)};
    [FSSharedNetWorkingManager GET:ServiceInterfaceGoodList parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       
        NSDictionary *respDic=(NSDictionary*)responseObject;
        NSLog(@"goodlist:%@",respDic);
        NSArray *arr=[respDic objectForKey:@"aaData"];
        if(arr)
        {
            [self.arrDatas addObjectsFromArray:arr];
            [self.tableView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    NSLog(@"controllers:%@,%@",self.navigationController.viewControllers,self.navigationController.viewControllers.firstObject);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0) return KKScreenWidth/320.0*110.0;
    else if(indexPath.row==1) return 80+self.arrDatas.count*60;
    else return 260;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row==0)
    {
        VIPHeadCell *cell=[tableView dequeueReusableCellWithIdentifier:cellVIPHeadIdentifier forIndexPath:indexPath];
        
        return cell;

    }
    else if(indexPath.row==1)
    {
        VIPProductCell *cell=[tableView dequeueReusableCellWithIdentifier:cellVIPProductIdentifier forIndexPath:indexPath];
        [cell showInfo:self.arrDatas];
        KKWEAKSELF;
        cell.buyProduct=^(NSInteger index){
          
            if(KKSharedGlobalManager.isIAP)
            {
                if([weakself.store canPayment])
                {
                    NSDictionary *dic=weakself.arrDatas[index];
                    [weakself.store buyProduct:[dic stringForKey:@"id" defaultValue:@""]];
                }
            }
            else
            {
                NSDictionary *dic=weakself.arrDatas[index];
                PayViewController *payVC=KKViewControllerOfMainSB(@"PayViewController");
                payVC.payDic=dic;
                [weakself.navigationController pushViewController:payVC animated:YES];
                
                [MobClick event:@"012" label:[dic stringForKey:@"name" defaultValue:@""]];
            }
            
        };
        return cell;
    }
    else
    {
        VIPBottomCell *cell=[tableView dequeueReusableCellWithIdentifier:cellVIPBottomIdentifier forIndexPath:indexPath];
        return cell;
    }
    
}


#pragma mark - FSStoreDelegate
-(void)buySucceed:(NSString *)productId
{
    long long currentViptime=[KKSharedLocalPlistManager kkLongForKey:Plist_Key_VIPEndTime];
    if(currentViptime==0) currentViptime=[[NSDate date] timeIntervalSince1970];
    
    if([productId isEqualToString:VIPID_30Day])
    {
        currentViptime+=30*24*3600;
    }
    else if([productId isEqualToString:VIPID_90Day])
    {
        currentViptime+=90*24*3600;
    }
    else if([productId isEqualToString:VIPID_365Day])
    {
        currentViptime+=365*24*3600;
    }
    [KKSharedLocalPlistManager setKKValue:@(currentViptime) forKey:Plist_Key_VIPEndTime];
    
    KKSharedCurrentUser.vipEndTime=[[NSDate dateWithTimeIntervalSince1970:currentViptime] stringYearMonthDay];
    KKSharedCurrentUser.isVIP=YES;
    
    //回退
    for (UIViewController *viewController in self.navigationController.viewControllers) {
        if([viewController isKindOfClass:[ChatViewController class]] || [viewController isKindOfClass:[RecommendUserInfoViewController class]])
        {
            [self.navigationController popToViewController:viewController animated:YES];
            return;
        }
    }
    [self.navigationController popToRootViewControllerAnimated:YES];

}

@end
