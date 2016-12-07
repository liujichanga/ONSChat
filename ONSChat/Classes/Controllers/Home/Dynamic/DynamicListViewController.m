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
    KKNotificationCenterAddObserverOfSelf(loadData, @"updateList", nil);

    //读取数据
    KKWEAKSELF
    MJRefreshNormalHeader *header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself loadData];
        
    }];
    self.tableView.header=header;
    [self.tableView.header beginRefreshing];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadData{
 
    if (self.showRightItem==YES) {
       //读取本地数据库数据
        KKLog(@"SQL");
        [KKSharedDynamicDao getDynamicListCompletion:^(id result) {
          
            self.dataArr = [NSMutableArray arrayWithArray:(NSArray*)result];
              KKLog(@"%@",self.dataArr);
            [self tableViewReload:self.dataArr.count];

        } inBackground:NO];
        
    }else{
        [self loadNewData];
    }
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

    return self.cellH;
  
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
    cell.local = self.showRightItem;
    cell.cellHeightBlock = ^(CGFloat height){
        weakself.cellH = height;
    };
    if (self.dataArr.count>indexPath.row) {
        cell.dynamic = self.dataArr[indexPath.row];
    }
    //删除动态
    cell.deleteBlock = ^(NSString*dynamicID){
        [WCAlertView showAlertWithTitle:@"您确定要删除此动态" message:nil customizationBlock:nil completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
            if(buttonIndex == 1)
            {
                [weakself deleteDynamic:dynamicID AndIndexPath:indexPath];
            }
        } cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];    
    };
    return cell;
}
-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if (self.dataArr.count>indexPath.row) {
        DynamicDetailViewController *detail = KKViewControllerOfMainSB(@"DynamicDetailViewController");
        detail.dynamicData = self.dataArr[indexPath.row];
        detail.localData = self.showRightItem;
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

//更新点赞数
-(void)updatePraiseNub:(NSNotification*)dataDic{
    NSInteger nub = [dataDic.userInfo integerForKey:@"pariseNum" defaultValue:0];
    KKDynamic *selDy = [self.dataArr objectAtIndex:self.selectIndex];
    selDy.praiseNum = nub;
    [self.tableView reloadData];
}

//删除我的动态
-(void)deleteDynamic:(NSString*)dynamicID AndIndexPath:(NSIndexPath*)indexPath{
    KKWEAKSELF
    [KKSharedDynamicDao deleteDynamic:dynamicID completion:^(BOOL success) {
        if (success) {
            [weakself.dataArr removeObjectAtIndex:indexPath.row];
            [weakself.tableView beginUpdates];
            [weakself.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [weakself.tableView endUpdates];
            [weakself.tableView reloadData];
            [MBProgressHUD showMessag:@"删除成功" toView:nil];
        }
    } inBackground:YES];

}


-(void)dealloc{
    KKNotificationCenterRemoveObserverOfSelf;
}
@end
