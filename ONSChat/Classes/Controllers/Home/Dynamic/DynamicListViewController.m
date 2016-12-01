//
//  DynamicListViewController.m
//  ONSChat
//
//  Created by 王磊 on 2016/11/30.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "DynamicListViewController.h"
#import "DynamicDetailViewController.h"
#import "NewDynamicViewController.h"

#import "DynamicCell.h"

#define cellDynamicIdentifier @"DynamicCell"

#define PerPageNumber 10

@interface DynamicListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSInteger currentPage;
//选中动态索引
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, assign) CGFloat cellH;
@end

@implementation DynamicListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tableView registerNib:[UINib nibWithNibName:cellDynamicIdentifier bundle:nil] forCellReuseIdentifier:cellDynamicIdentifier];
    self.currentPage = 0;
    self.selectIndex = 0;
    self.dataArr = [NSMutableArray array];
    if (self.showRightItem==YES) {
        self.title = @"我的动态";
        UIBarButtonItem *rightItem=[[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
        self.navigationItem.rightBarButtonItem=rightItem;
    }
    KKNotificationCenterAddObserverOfSelf(updatePraiseNub:, @"updatePraiseNub", nil);
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
-(void)loadNewData
{
    [self.dataArr removeAllObjects];
    _currentPage=0;
    
    [self loadDynamicData];
}
-(void)loadMoreData
{
    _currentPage+=1;
    
    [self loadDynamicData];
}
-(void)loadDynamicData
{
    NSDictionary *params=@{@"currentPage":@(_currentPage),@"limit":@(PerPageNumber),@"userid":self.uidStr};
    
    [FSSharedNetWorkingManager POST:ServiceInterfaceDynamics parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic=(NSDictionary*)responseObject;
        KKLog(@"dynamicList:%@",dic);
        NSInteger status=[dic integerForKey:@"status" defaultValue:0];
        if(status==1)
        {
            NSArray *arr=[dic objectForKey:@"aaData"];
            if(arr&&[arr isKindOfClass:[NSArray class]])
            {
                for (NSDictionary *dic in arr) {
                    
                    KKDynamic *user = [[KKDynamic alloc] initWithDic:dic];
                    [self.dataArr addObject:user];
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

#pragma mark - UITabelViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  
    return self.dataArr.count;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArr.count>indexPath.row) {
        KKDynamic*dy = [self.dataArr objectAtIndex:indexPath.row];
        NSString *dyStr = dy.dynamicText;
        CGSize size = [dyStr sizeWithFont:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(KKScreenWidth-20, 500)];
        return self.cellH;
    }
    return 0;    
}

-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0000001;

}
-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0000001;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KKWEAKSELF
    DynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:cellDynamicIdentifier forIndexPath:indexPath];
    cell.cellHeightBlock = ^(CGFloat height){
        weakself.cellH = height;
    };
    if (self.dataArr.count>indexPath.row) {
        cell.dynamic = self.dataArr[indexPath.row];

    }

    return cell;
}
-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if (self.dataArr.count>indexPath.row) {
        DynamicDetailViewController *detail = KKViewControllerOfMainSB(@"DynamicDetailViewController");
        detail.dynamicData = self.dataArr[indexPath.row];
        self.selectIndex = indexPath.row;
        [self.navigationController pushViewController:detail animated:YES];
    }

}

#pragma mark - 私有方法
-(void)rightItemClick{
    KKLog(@"发布");
    NewDynamicViewController *newDy = KKViewControllerOfMainSB(@"NewDynamicViewController");
    [self.navigationController pushViewController:newDy animated:YES];
}

-(void)updatePraiseNub:(NSNotification*)dataDic{
    NSInteger nub = [dataDic.userInfo integerForKey:@"pariseNum" defaultValue:0];
    KKDynamic *selDy = [self.dataArr objectAtIndex:self.selectIndex];
    selDy.praiseNum = nub;
    [self.tableView reloadData];
}

-(void)dealloc{
    KKNotificationCenterRemoveObserverOfSelf;
}
@end
