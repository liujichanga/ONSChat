//
//  DynamicDetailViewController.m
//  ONSChat
//
//  Created by 王磊 on 2016/12/1.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "DynamicDetailViewController.h"
#import "DynamicCell.h"
#import "DynamicCommentCell.h"
#import "CommentPopView.h"

#define cellDynamicIdentifier @"DynamicCell"
#define cellDynamicCommentIdentifier @"DynamicCommentCell"

#define PerPageNumber 10
@interface DynamicDetailViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) CGFloat cellH;
@property (nonatomic, assign) CGFloat commentH;



@end

@implementation DynamicDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.localData==YES) {
        UIBarButtonItem *rightItem=[[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
        self.navigationItem.rightBarButtonItem=rightItem;
    }else{
        UIBarButtonItem *rightItem=[[UIBarButtonItem alloc] initWithTitle:@"评论" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
        self.navigationItem.rightBarButtonItem=rightItem;
    }

    [self.tableView registerNib:[UINib nibWithNibName:cellDynamicIdentifier bundle:nil] forCellReuseIdentifier:cellDynamicIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:cellDynamicCommentIdentifier bundle:nil] forCellReuseIdentifier:cellDynamicCommentIdentifier];
    self.currentPage = 0;
    self.dataArr = [NSMutableArray array];
    
    //读取数据
    KKWEAKSELF
    MJRefreshNormalHeader *header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself loadData];
        
    }];
    self.tableView.header=header;
    [self.tableView.header beginRefreshing];
}

-(void)loadData{
    
    if (self.localData==YES) {

        [self.tableView reloadData];
        [self.tableView.header endRefreshing];

    }else{
        [self loadNewData];
    }
}

-(void)loadNewData
{
    [self.dataArr removeAllObjects];
    _currentPage=0;
    
    [self loadCommentData];
}
-(void)loadMoreData
{
    _currentPage+=1;
    
    [self loadCommentData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadCommentData{
    
    NSDictionary *params=@{@"currentPage":@(_currentPage),@"limit":@(PerPageNumber),@"dynamicsid":self.dynamicData.dynamicsId};
    [FSSharedNetWorkingManager POST:ServiceInterfaceGetCommentList parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *respDic = (NSDictionary*)responseObject;
        KKLog(@"commnet %@",respDic);
        NSInteger status=[respDic integerForKey:@"status" defaultValue:0];
        if(status==1)
        {
            NSArray *dataArr = [respDic objectForKey:@"aaData"];
            if (dataArr&&dataArr.count>0) {
                for (NSDictionary*dic in dataArr) {
                    KKComment *comment = [[KKComment alloc]initWithDic:dic];
                    [self.dataArr addObject:comment];
                }
                [self.tableView reloadData];
                [self.tableView.header endRefreshing];
            }else{
                [MBProgressHUD showMessag:@"还没有评论" toView:nil];
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
    }];
    
}

////tableview 重载
//-(void)tableViewReload:(NSInteger)arrNumber
//{
//    [self.tableView reloadData];
//    [self.tableView.header endRefreshing];
//    if(arrNumber==PerPageNumber || arrNumber== -1)
//    {
//        KKWEAKSELF
//        //显示加载更多
//        self.tableView.footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//            [weakself loadMoreData];
//        }];
//    }
//    else [self.tableView.footer noticeNoMoreData];
//}

#pragma mark - UITabelViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }
    return self.dataArr.count;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return self.cellH;
    }else{
        return self.commentH;
    }
}

-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
    
}
-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0000001;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KKWEAKSELF
    if (indexPath.section==0) {
        DynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:cellDynamicIdentifier forIndexPath:indexPath];
    
        cell.allowLike = YES;
        cell.local = self.localData;
        cell.cellHeightBlock = ^(CGFloat height){
            weakself.cellH = height;
        };
        cell.dynamic = self.dynamicData;

        cell.praiseBlock = ^(){
            [weakself submitPraise];
        };
        return cell;
    }else{
        DynamicCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellDynamicCommentIdentifier forIndexPath:indexPath];
        cell.cellHeightBlock = ^(CGFloat height){
            weakself.commentH = height;
        };
        if (self.dataArr.count>indexPath.row) {
            cell.comment = [self.dataArr objectAtIndex:indexPath.row];
        }
        return cell;
    }
}

#pragma mark - 私有方法
//右键点击事件 评论或删除
-(void)rightItemClick{
    if (self.localData==YES) {
        KKWEAKSELF
        [WCAlertView showAlertWithTitle:@"您确定要删除此动态" message:nil customizationBlock:nil completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
            if(buttonIndex == 1)
            {
                [weakself deleteDy];
            }
        } cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        
    }else{
        KKLog(@"评论");
        KKWEAKSELF
        CommentPopView *popView = [CommentPopView showCommentPopViewInView:self.view AndFrame:CGRectMake(0, 0, KKScreenWidth, KKScreenHeight)];
        popView.sendComment = ^(NSString *commentText){
            [weakself submitCommentWithComment:commentText];
        };
    }
}

//删除后返回列表
-(void)deleteDy{
    KKWEAKSELF
    [KKSharedDynamicDao deleteDynamic:self.dynamicData.dynamicsId completion:^(BOOL success) {
        if (success) {
            [KKNotificationCenter postNotificationName:@"updateList" object:nil];
            [weakself.navigationController popViewControllerAnimated:YES];

        }else{
            [MBProgressHUD showMessag:@"删除失败" toView:nil];
        }
    } inBackground:YES];
}

//提交点赞
-(void)submitPraise{
    NSDictionary *param = @{@"userid":self.dynamicData.userId,@"dynamicsid":self.dynamicData.dynamicsId};
    [FSSharedNetWorkingManager POST:ServiceInterfaceAddPraise parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *respDic = (NSDictionary*)responseObject;
        KKLog(@"praise %@",respDic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
//提交评论
-(void)submitCommentWithComment:(NSString*)comment{
    NSDictionary *param = @{@"dynamicsid":self.dynamicData.dynamicsId,@"comment":comment};
    [FSSharedNetWorkingManager POST:ServiceInterfacePublishComment parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSInteger status = [respDic integerForKey:@"status" defaultValue:0];
        if (status==1) {
            [MBProgressHUD showMessag:@"评论成功" toView:nil];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:KKErrorInfo(error) duration:1.2];
    }];
}


@end
