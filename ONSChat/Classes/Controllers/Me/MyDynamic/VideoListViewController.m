//
//  VideoListViewController.m
//  ONSChat
//
//  Created by 王磊 on 2016/12/6.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "VideoListViewController.h"
#import <Photos/Photos.h>
#import "VideoThumbnailCell.h"

#define cellIdentifier @"VideoThumbnailCell"

@interface VideoListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *videoImgArray;
@end

@implementation VideoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.videoImgArray = [NSMutableArray array];
    [self.tableView registerNib:[UINib nibWithNibName:cellIdentifier bundle:nil] forCellReuseIdentifier:cellIdentifier];
    self.tableView.tableFooterView = [UIView new];
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(leftItemClick)];
    self.navigationItem.leftBarButtonItem=leftItem;
    
    PHFetchResult *videoAlbums = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeVideo options:nil];
    if (videoAlbums.count>0) {
        NSMutableArray *arr = [NSMutableArray array];
        for (PHAsset *asset in videoAlbums) {
            
            [arr addObject:asset];
        }
        //倒叙排列
        self.videoImgArray = (NSMutableArray*)[[arr reverseObjectEnumerator] allObjects];
        [self.tableView reloadData];
    }else{
        [MBProgressHUD showMessag:@"您没有视频" toView:nil];
        [self performSelector:@selector(leftItemClick) withObject:nil afterDelay:1.5];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITabelViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.videoImgArray.count;    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VideoThumbnailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if (self.videoImgArray.count>indexPath.row) {
        cell.asset = [self.videoImgArray objectAtIndex:indexPath.row];
    }
    
    return cell;
}

-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    if (self.videoImgArray.count>indexPath.row) {
        PHAsset *asset = [self.videoImgArray objectAtIndex:indexPath.row];
        if (self.selectBlock) {
            self.selectBlock(asset);
        }
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)leftItemClick{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];

}
@end
