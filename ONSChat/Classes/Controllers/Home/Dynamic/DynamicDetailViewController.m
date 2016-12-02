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

@end

@implementation DynamicDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc] initWithTitle:@"评论" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
    self.navigationItem.rightBarButtonItem=rightItem;

    [self.tableView registerNib:[UINib nibWithNibName:cellDynamicIdentifier bundle:nil] forCellReuseIdentifier:cellDynamicIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:cellDynamicCommentIdentifier bundle:nil] forCellReuseIdentifier:cellDynamicCommentIdentifier];
    self.currentPage = 0;
    self.dataArr = [NSMutableArray array];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITabelViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }
    
    return 5;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        NSString *dyStr = self.dynamicData.dynamicText;
        CGSize size = [dyStr sizeWithFont:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(KKScreenWidth-20, 500)];
        return (KKScreenWidth-20)*(290/320.0)+size.height;
    }else{
        return 200;
    }
}

-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0000001;
    
}
-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0000001;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KKWEAKSELF
    if (indexPath.section==0) {
        DynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:cellDynamicIdentifier forIndexPath:indexPath];
        cell.allowLike = YES;
        cell.dynamic = self.dynamicData;
        cell.praiseBlock = ^(){
            [weakself submitPraise];
        };
        return cell;
    }else{
        DynamicCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellDynamicCommentIdentifier forIndexPath:indexPath];
        return cell;
    }
}
-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
}

#pragma mark - 私有方法
-(void)rightItemClick{
    KKLog(@"评论");
    CommentPopView *popView = [CommentPopView showCommentPopViewInView:self.view AndFrame:CGRectMake(0, 0, KKScreenWidth, KKScreenHeight)];
    
}
//提交点赞
-(void)submitPraise{
    NSDictionary *param = @{@"userid":self.dynamicData.userId,@"dynamicsid":self.dynamicData.dynamicsId};
    [FSSharedNetWorkingManager POST:ServiceInterfaceAddpraise parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *respDic = (NSDictionary*)responseObject;
        KKLog(@"praise %@",respDic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
@end
