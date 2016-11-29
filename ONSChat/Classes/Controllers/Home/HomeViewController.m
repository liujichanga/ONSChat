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
 
    NotificationView *notificationView=[[NotificationView alloc] initWithFrame:CGRectMake(10, 74, KKScreenWidth-20, 35)];
    [self.view addSubview:notificationView];
    [notificationView setNotificationNum:30];
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
    
    if(arrNumber==PerPageNumber || arrNumber== -1)
    {
        KKWEAKSELF
        //显示加载更多
        self.tableView.footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakself loadMoreData];
        }];
    }
    else [self.tableView.footer noticeNoMoreData];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrDatas.count/PerPageNumber*3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%3==2)
    {
        return 287*KKScreenWidth/320.0;
    }
    else        
        return 210*KKScreenWidth/320.0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger val=indexPath.row/3;
    NSInteger mod = indexPath.row%3;
    
    if(mod==0 || mod==1)
    {
        TwoPicCell *cell=[tableView dequeueReusableCellWithIdentifier:cellTwoPicIdentifier forIndexPath:indexPath];
        
        if(self.arrDatas.count>(val*PerPageNumber+mod+1))
        {
            [cell displayLeftDic:self.arrDatas[val*PerPageNumber+mod] rightDic:self.arrDatas[val*PerPageNumber+mod+1]];
        }
        
        KKWEAKSELF
        cell.clickBlock=^(NSString *userid){
            
            RecommendUserInfoViewController *recommendUser = KKViewControllerOfMainSB(@"RecommendUserInfoViewController");
            recommendUser.uid = userid;
            [weakself.navigationController pushViewController:recommendUser animated:YES];

        };
        
        return cell;
    }
    else
    {
        OneVideoCell *cell=[tableView dequeueReusableCellWithIdentifier:cellOneVideoIdentifier forIndexPath:indexPath];
        
        if(self.arrDatas.count>(val*PerPageNumber+mod))
        {
            [cell displayDic:self.arrDatas[val*PerPageNumber+mod]];
        }
        
        KKWEAKSELF
        cell.clickBlock=^(NSString *userid){
            
            RecommendUserInfoViewController *recommendUser = KKViewControllerOfMainSB(@"RecommendUserInfoViewController");
            recommendUser.uid =userid;
            recommendUser.dynamicsID = @"796";
            [weakself.navigationController pushViewController:recommendUser animated:YES];
            
        };
        
        return cell;
    }
    
}

-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{

}

@end
