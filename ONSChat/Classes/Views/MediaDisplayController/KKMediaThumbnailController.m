//
//  KKMediaThumbnailController.m
//  KuaiKuai
//
//  Created by liujichang on 15/7/2.
//  Copyright (c) 2015年 liujichang. All rights reserved.
//

#import "KKMediaThumbnailController.h"
#import "KKMediaThumbnailCell.h"
#import "KKMedia.h"
#import "KKMediaPreviewController.h"

@interface KKMediaThumbnailController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) UICollectionView *collectionView;
/** 当前布局使用的屏幕方向 */
@property (assign, nonatomic) UIInterfaceOrientation currentUsedInterfaceOrientation;

@end

@implementation KKMediaThumbnailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonClicked:)];
    
    [self configureCollecitonView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_currentUsedInterfaceOrientation != [UIApplication sharedApplication].statusBarOrientation) {
        [self configureFlowLayout:(UICollectionViewFlowLayout *)_collectionView.collectionViewLayout
         withInterfaceOrientation:[UIApplication sharedApplication].statusBarOrientation];
    }
}

- (void)backBarButtonClicked:(UIBarButtonItem *)barButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UICollectionView dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _medias.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"KKMediaThumbnailCell";
    KKMediaThumbnailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    
    cell.media = _medias[indexPath.row];
    return cell;
}

#pragma mark - UICollectionView delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_previewModeEnabled) {
        KKMediaPreviewController *vc = [[KKMediaPreviewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:_orientation options:@{UIPageViewControllerOptionInterPageSpacingKey : @(_spacing)}];
        vc.medias = [NSMutableArray arrayWithArray:_medias];
        vc.startIndex = indexPath.row;
        vc.thumbnailModeEnabled = NO;
        
        [self.navigationController pushViewController:vc animated:YES];
    } else if (_delegate) {
        [_delegate mediaThumbnailController:self didSelectMedia:_medias[indexPath.row]];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - ViewController Init methods
/** 配置CollectionVeiw */
- (void)configureCollecitonView {
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [self configureFlowLayout:flowLayout withInterfaceOrientation:[UIApplication sharedApplication].statusBarOrientation];
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [collectionView registerClass:[KKMediaThumbnailCell class] forCellWithReuseIdentifier:@"KKMediaThumbnailCell"];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    
    self.collectionView = collectionView;
    [self.view addSubview:collectionView];
}

/** 配置Cell布局 */
- (void)configureFlowLayout:(UICollectionViewFlowLayout *)flowLayout
   withInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    _currentUsedInterfaceOrientation = interfaceOrientation;
    
    static CGFloat cellSpacing = 2.0;
    NSUInteger column = 0;
    if (KKDeviceIsPad) {
        column = UIInterfaceOrientationIsPortrait(interfaceOrientation) ? 5 : 7;
    } else {
        column = UIInterfaceOrientationIsPortrait(interfaceOrientation) ? 3 : 5;
    }
    CGFloat cellWH = (self.view.bounds.size.width - cellSpacing * (column - 1)) / column - 0.5;
    
    flowLayout.minimumLineSpacing = cellSpacing;
    flowLayout.minimumInteritemSpacing = cellSpacing;
    flowLayout.itemSize = CGSizeMake(cellWH, cellWH);
    flowLayout.sectionInset = UIEdgeInsetsMake(cellSpacing, 0.0, cellSpacing, 0.0);
}

#pragma mark - UIViewController methods
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration {
    [self configureFlowLayout:(UICollectionViewFlowLayout *)_collectionView.collectionViewLayout
     withInterfaceOrientation:toInterfaceOrientation];
}

@end
