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

#define PerPageNumber 10

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
    
    //未读数量
    KKNotificationCenterAddObserverOfSelf(unReadCount:, ONSChatManagerNotification_UnReadCount, nil);
 
    //读取未读数量
    [KKSharedONSChatManager getUnReadCount];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    KKNotificationCenterRemoveObserverOfSelf;
}

#pragma mark - UnReadCount
-(void)unReadCount:(NSNotification*)notification
{
    if(notification.object)
    {
        NSNumber *num=(NSNumber*)notification.object;
        NSInteger count = [num integerValue];
        UIView *view=[self.view viewWithTag:9990];
        if(view)
        {
            if(count>0)
            {
                NotificationView *notificationView=(NotificationView*)view;
                [notificationView setNotificationNum:count];
            }
            else
            {
                [view removeFromSuperview];
            }
        }
        else
        {
            if(count>0)
            {
                NotificationView *notificationView=[[NotificationView alloc] initWithFrame:CGRectMake(10, 74, KKScreenWidth-20, 35)];
                notificationView.tag=9990;
                [self.view addSubview:notificationView];
                [notificationView setNotificationNum:count];
            }
        }
    }
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
        NSInteger status=[dic integerForKey:@"status" defaultValue:0];
        if(status==1)
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
    
    if(arrNumber>=PerPageNumber || arrNumber== -1)
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
    return self.arrDatas.count/2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 210*KKScreenWidth/320.0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    TwoPicCell *cell=[tableView dequeueReusableCellWithIdentifier:cellTwoPicIdentifier forIndexPath:indexPath];
    
    if(self.arrDatas.count>(indexPath.row*2+1))
    {
        [cell displayLeftDic:self.arrDatas[indexPath.row*2] rightDic:self.arrDatas[indexPath.row*2+1]];
    }
    
    KKWEAKSELF
    cell.clickBlock=^(KKUser *user){
        
        RecommendUserInfoViewController *recommendUser = KKViewControllerOfMainSB(@"RecommendUserInfoViewController");
        recommendUser.uid = user.userId;
        recommendUser.dynamicsID=user.dynamicsId;
        [weakself.navigationController pushViewController:recommendUser animated:YES];

    };
    
    return cell;

    
}

-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{

}

@end
