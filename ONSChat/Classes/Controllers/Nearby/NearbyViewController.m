//
//  NearbyViewController.m
//  ONSChat
//
//  Created by liujichang on 2016/11/21.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "NearbyViewController.h"
#import "NearUserCell.h"

#define cellNearUserIdentifier @"NearUserCell"

@interface NearbyViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nearLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(strong,nonatomic) NSMutableArray *arrDatas;


@end

@implementation NearbyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.arrDatas=[NSMutableArray array];
    
    _nearLabel.text=KKStringWithFormat(@"您现在位于%@市，下面的美女都在你附近出没过，赶紧给她们他招呼吧！",KKSharedGlobalManager.GPSCity);
    //使用registerNib 方法可以从XIB加载控件
    [self.tableView registerNib:[UINib nibWithNibName:cellNearUserIdentifier bundle:nil] forCellReuseIdentifier:cellNearUserIdentifier];
    
    //读取数据
    KKWEAKSELF
    MJRefreshNormalHeader *header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself loadData];
        
    }];
    self.tableView.header=header;
    [self.tableView.header beginRefreshing];
    
    NotificationView *notificationView=[[NotificationView alloc] initWithFrame:CGRectMake(10, 74, KKScreenWidth-20, 35)];
    [self.view addSubview:notificationView];
    [notificationView setNotificationNum:30];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadData
{
    [self.arrDatas removeAllObjects];
    NSDictionary *params=@{@"currentPage":@(1),@"limit":@"30",@"userid":@(0)};
    
    [FSSharedNetWorkingManager POST:ServiceInterfaceDynamics parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic=(NSDictionary*)responseObject;
        KKLog(@"nearby:%@",dic);
        BOOL status=[dic boolForKey:@"status" defaultValue:NO];
        if(status)
        {
            NSArray *arr=[dic objectForKey:@"aaData"];
            if(arr&&[arr isKindOfClass:[NSArray class]])
            {
                for (NSDictionary *dic in arr) {
                    KKUser *user = [[KKUser alloc] initWithDicSimple:dic];
                    [self.arrDatas addObject:user];
                }
                
                [self tableViewReload:arr.count];
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:@"读取失败" duration:2.0];
                [self.tableView.header endRefreshing];
            }
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"读取失败" duration:2.0];
            [self.tableView.header endRefreshing];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:KKErrorInfo(error) duration:2.0];
        [self tableViewReload:-1];
    }];
}

//tableview 重载
-(void)tableViewReload:(NSInteger)arrNumber
{
    [self.tableView reloadData];
    [self.tableView.header endRefreshing];
    
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.arrDatas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NearUserCell *cell=[tableView dequeueReusableCellWithIdentifier:cellNearUserIdentifier forIndexPath:indexPath];
    
    return  cell;
    
}

-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
}

@end
