//
//  BaoYuePayViewController.m
//  ONSChat
//
//  Created by liujichang on 2016/11/26.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "BaoYuePayViewController.h"
#import "BaoYueHeadCell.h"
#import "BaoYueProductCell.h"
#import "BaoYueNamesCell.h"
#import "BaoYueBottomCell.h"
#import "BeanBottomCell.h"
#import "PayViewController.h"
#import "ChatViewController.h"
#import "RecommendUserInfoViewController.h"



#define cellBaoYueHeadIdentifier @"BaoYueHeadCell"
#define cellBaoYueProductIdentifier @"BaoYueProductCell"
#define cellBaoYueNamesIdentifier @"BaoYueNamesCell"
#define cellBaoYueBottomIdentifier @"BaoYueBottomCell"
#define cellBeanBottomIdentifier @"BeanBottomCell"


#define BaoYueSelected 1
#define BeanSelected 2

#define BaoYueID_7Day @"Month001"
#define BaoYueID_30Day @"Month002"
#define BaoYueID_90Day @"Month003"

#define BeanID_300 @"Bean001"
#define BeanID_600 @"Bean002"
#define BeanID_900 @"Bean003"


@interface BaoYuePayViewController ()<UITableViewDelegate,UITableViewDataSource,FSStoreDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(assign,nonatomic) NSInteger selectedModel;

@property(strong,nonatomic) NSMutableArray *boysRandArr;

@property(strong,nonatomic) NSMutableArray *productArr;

@property(strong,nonatomic) FSStore *store;

@end

@implementation BaoYuePayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title=@"包月短信";
    self.selectedModel=BaoYueSelected;
    
    if(self.showBean)
    {
        self.selectedModel=BeanSelected;
        self.navigationItem.title=@"红豆服务";
    }
    
    _boysRandArr=[NSMutableArray array];
    _productArr=[NSMutableArray array];
    
    self.store=[[FSStore alloc] init];
    self.store.delegate=self;
    
    //使用registerNib 方法可以从XIB加载控件
    [self.tableView registerNib:[UINib nibWithNibName:cellBaoYueHeadIdentifier bundle:nil] forCellReuseIdentifier:cellBaoYueHeadIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:cellBaoYueProductIdentifier bundle:nil] forCellReuseIdentifier:cellBaoYueProductIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:cellBaoYueNamesIdentifier bundle:nil] forCellReuseIdentifier:cellBaoYueNamesIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:cellBaoYueBottomIdentifier bundle:nil] forCellReuseIdentifier:cellBaoYueBottomIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:cellBeanBottomIdentifier bundle:nil] forCellReuseIdentifier:cellBeanBottomIdentifier];

    
    [self loadProduct:self.selectedModel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadProduct:(NSInteger)type{
    
    [self.productArr removeAllObjects];
    [self.boysRandArr removeAllObjects];
    
    if(self.selectedModel==BaoYueSelected) self.navigationItem.title=@"包月短信";
    else self.navigationItem.title=@"红豆服务";
    
    //加载话费名单
    [FSSharedNetWorkingManager GET:ServiceInterfaceBoysRand parameters:@{@"limit":@(50)} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *respDic=(NSDictionary*)responseObject;
        KKLog(@"rand:%@",respDic);
        NSInteger status=[respDic integerForKey:@"status" defaultValue:0];
        if(status)
        {
            NSArray *names=[respDic objectForKey:@"name"];
            [_boysRandArr addObjectsFromArray:names];
            [self.tableView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
    //判断使用iap商品还是服务器商品
    if(KKSharedGlobalManager.isIAP)
    {
        if(self.selectedModel==BaoYueSelected)
        {
            [self.productArr addObjectsFromArray:@[@{@"name":@"90天无限畅聊",@"id":BaoYueID_90Day,@"price":@(9800)},@{@"name":@"30天无限畅聊",@"id":BaoYueID_30Day,@"price":@(6800)},@{@"name":@"7天无限畅聊",@"id":BaoYueID_7Day,@"price":@(4500)}]];
        }
        else
        {
            [self.productArr addObjectsFromArray:@[@{@"name":@"900红豆",@"id":BeanID_900,@"price":@(9800)},@{@"name":@"600红豆",@"id":BeanID_600,@"price":@(6800)},@{@"name":@"300红豆",@"id":BeanID_300,@"price":@(4500)}]];
        }
        
        [self.tableView reloadData];
        return;
    }
    
    //读取商品信息
    NSDictionary *dic=@{@"type":@(type),@"gender":@(KKSharedCurrentUser.sex)};
    [FSSharedNetWorkingManager GET:ServiceInterfaceGoodList parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *respDic=(NSDictionary*)responseObject;
        NSLog(@"goodlist:%@",respDic);
        NSArray *arr=[respDic objectForKey:@"aaData"];
        if(arr)
        {
            [self.productArr addObjectsFromArray:arr];
            [self.tableView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
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
    if(indexPath.row==0)
    {
        return 180;
    }
    else if(indexPath.row==1) return self.productArr.count*(75+10)+5;
    else if(indexPath.row==2) return 50+10*21;
    else{
        if(self.selectedModel==BaoYueSelected) return 305;
        else return 255;
    }
        
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row==0)
    {
        BaoYueHeadCell *cell=[tableView dequeueReusableCellWithIdentifier:cellBaoYueHeadIdentifier forIndexPath:indexPath];
        
        [cell showDisplay:self.selectedModel];
        
        KKWEAKSELF;
        cell.baoyueClickBlock=^{
            
            weakself.selectedModel=BaoYueSelected;
            [weakself loadProduct:weakself.selectedModel];
        };
        
        cell.beanClickBlock=^{
            
            weakself.selectedModel=BeanSelected;
            [weakself loadProduct:weakself.selectedModel];
        };
        
        return cell;
    }
    else if(indexPath.row==1)
    {
        BaoYueProductCell *cell=[tableView dequeueReusableCellWithIdentifier:cellBaoYueProductIdentifier forIndexPath:indexPath];
        
        [cell showDisplay:self.productArr];
        
        KKWEAKSELF;
        cell.buyProductClickBlock=^(NSDictionary *dic){
          
            if(KKSharedGlobalManager.isIAP)
            {
                if([weakself.store canPayment])
                {
                    [weakself.store buyProduct:[dic stringForKey:@"id" defaultValue:@""]];
                }
            }
            else
            {
                PayViewController *payVC=KKViewControllerOfMainSB(@"PayViewController");
                payVC.payDic=dic;
                [weakself.navigationController pushViewController:payVC animated:YES];
            }
            
        };
        
        return cell;
    }
    else if(indexPath.row==2)
    {
        BaoYueNamesCell *cell=[tableView dequeueReusableCellWithIdentifier:cellBaoYueNamesIdentifier forIndexPath:indexPath];
        cell.namesArr=self.boysRandArr;
        
        return cell;
    }
    else
    {
        if(self.selectedModel==BaoYueSelected)
        {
            BaoYueBottomCell *cell=[tableView dequeueReusableCellWithIdentifier:cellBaoYueBottomIdentifier forIndexPath:indexPath];
            
            return cell;

        }
        else
        {
            BeanBottomCell *cell=[tableView dequeueReusableCellWithIdentifier:cellBeanBottomIdentifier forIndexPath:indexPath];
            return cell;
        }
        
    }
   
}

#pragma mark - FSStoreDelegate
-(void)buySucceed:(NSString *)productId
{
    if([productId isEqualToString:BaoYueID_7Day] || [productId isEqualToString:BaoYueID_30Day] || [productId isEqualToString:BaoYueID_90Day])
    {
        long long currentBaoYuetime=[KKSharedLocalPlistManager kkLongForKey:Plist_Key_BaoYueEndTime];
        if(currentBaoYuetime==0) currentBaoYuetime=[[NSDate date] timeIntervalSince1970];
        
        if([productId isEqualToString:BaoYueID_7Day])
        {
            currentBaoYuetime+=7*24*3600;
        }
        else if([productId isEqualToString:BaoYueID_30Day])
        {
            currentBaoYuetime+=30*24*3600;
        }
        else if([productId isEqualToString:BaoYueID_90Day])
        {
            currentBaoYuetime+=90*24*3600;
        }
        [KKSharedLocalPlistManager setKKValue:@(currentBaoYuetime) forKey:Plist_Key_BaoYueEndTime];
        
        KKSharedCurrentUser.baoyueEndTime=[[NSDate dateWithTimeIntervalSince1970:currentBaoYuetime] stringYearMonthDay];
        KKSharedCurrentUser.isBaoYue=YES;
    }
    else
    {
        NSInteger beannum=[KKSharedLocalPlistManager kkIntergerForKey:Plist_Key_BeanNum];
        if([productId isEqualToString:BeanID_300])
        {
            beannum+=300;
        }
        else if([productId isEqualToString:BeanID_600])
        {
            beannum+=600;
        }
        else if([productId isEqualToString:BeanID_900])
        {
            beannum+=900;
        }
        [KKSharedLocalPlistManager setKKValue:@(beannum) forKey:Plist_Key_BeanNum];
        KKSharedCurrentUser.beannum=beannum;
    }
    
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
