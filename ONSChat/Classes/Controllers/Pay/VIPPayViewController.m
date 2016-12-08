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

#define cellVIPHeadIdentifier @"VIPHeadCell"
#define cellVIPProductIdentifier @"VIPProductCell"
#define cellVIPBottomIdentifier @"VIPBottomCell"


@interface VIPPayViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(strong,nonatomic) NSMutableArray *arrDatas;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation VIPPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //使用registerNib 方法可以从XIB加载控件
    [self.tableView registerNib:[UINib nibWithNibName:cellVIPHeadIdentifier bundle:nil] forCellReuseIdentifier:cellVIPHeadIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:cellVIPProductIdentifier bundle:nil] forCellReuseIdentifier:cellVIPProductIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:cellVIPBottomIdentifier bundle:nil] forCellReuseIdentifier:cellVIPBottomIdentifier];

    self.arrDatas=[NSMutableArray array];
    
    NSDictionary *dic=@{@"type":@(3),@"gender":@(KKSharedCurrentUser.sex)};
    [FSSharedNetWorkingManager GET:ServiceInterfaceGoodList parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       
        NSDictionary *respDic=(NSDictionary*)responseObject;
        NSLog(@"goodlist:%@",respDic);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
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
    if(indexPath.row==0) return KKScreenWidth/320.0*140.0;
    else if(indexPath.row==1) return 120;
    else return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    VIPHeadCell *cell=[tableView dequeueReusableCellWithIdentifier:cellVIPHeadIdentifier forIndexPath:indexPath];
    
    return cell;
    
}

@end
