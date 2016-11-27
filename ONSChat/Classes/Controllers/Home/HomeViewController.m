//
//  HomeViewController.m
//  ONSChat
//
//  Created by liujichang on 2016/11/21.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "HomeViewController.h"
#import "TwoPicCell.h"
#import "OneVideoCell.h"
#import "RecommendUserInfoViewController.h"

#define cellTwoPicIdentifier @"TwoPicCell"
#define cellOneVideoIdentifier @"OneVideoCell"

#define PerPageNumber 5

@interface HomeViewController ()
{
    NSInteger currentPage;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(strong,nonatomic) NSMutableArray *arrDatas;


@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.backgroundColor=[UIColor groupTableViewBackgroundColor];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    //使用registerNib 方法可以从XIB加载控件
    [self.tableView registerNib:[UINib nibWithNibName:cellTwoPicIdentifier bundle:nil] forCellReuseIdentifier:cellTwoPicIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:cellOneVideoIdentifier bundle:nil] forCellReuseIdentifier:cellOneVideoIdentifier];
    
    currentPage=0;
    self.arrDatas=[NSMutableArray array];
    
    //读取数据
    KKWEAKSELF
    MJRefreshNormalHeader *header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself loadNewData];
        
    }];
    self.tableView.header=header;
    [self.tableView.header beginRefreshing];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PrivateMethod
-(void)loadNewData
{
    [self.arrDatas removeAllObjects];
    currentPage=0;
    
    [self loadData];
}
-(void)loadMoreData
{
    currentPage+=1;
    
    [self loadData];
}
-(void)loadData
{
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    [params setValue:@(PerPageNumber) forKey:@"limit"];
    [params setValue:@(currentPage) forKey:@"currentPage"];
    
    [FSSharedNetWorkingManager GET:ServiceInterfaceIndex parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic=(NSDictionary*)responseObject;
        KKLog(@"index:%@",dic);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}



#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
        return 210*KKScreenWidth/320.0;
    else return 267*KKScreenWidth/320.0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row==0)
    {
        TwoPicCell *cell=[tableView dequeueReusableCellWithIdentifier:cellTwoPicIdentifier forIndexPath:indexPath];
        
        return cell;
    }
    else
    {
        OneVideoCell *cell=[tableView dequeueReusableCellWithIdentifier:cellOneVideoIdentifier forIndexPath:indexPath];
        return cell;
    }
    
}

-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    RecommendUserInfoViewController *recommendUser = KKViewControllerOfMainSB(@"RecommendUserInfoViewController");
    recommendUser.nickStr = @"二丫";
    recommendUser.uid = 12684;
    [self.navigationController pushViewController:recommendUser animated:YES];
}

@end
