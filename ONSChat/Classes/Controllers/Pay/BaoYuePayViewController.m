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


#define cellBaoYueHeadIdentifier @"BaoYueHeadCell"
#define cellBaoYueProductIdentifier @"BaoYueProductCell"
#define cellBaoYueNamesIdentifier @"BaoYueNamesCell"
#define cellBaoYueBottomIdentifier @"BaoYueBottomCell"
#define cellBeanBottomIdentifier @"BeanBottomCell"


#define BaoYueSelected 1
#define BeanSelected 2


@interface BaoYuePayViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(assign,nonatomic) NSInteger selectedModel;

@property(strong,nonatomic) NSMutableArray *boysRandArr;

@property(strong,nonatomic) NSMutableArray *productArr;

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
    if(indexPath.row==0) return 180.0;
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


@end
