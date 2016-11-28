//
//  KKMediaPreviewController.m
//  KuaiKuai
//
//  Created by liujichang on 15/7/2.
//  Copyright (c) 2015年 liujichang. All rights reserved.
//

#import "KKMediaPreviewController.h"
#import "KKMediaPlayerController.h"
#import "KKMediaThumbnailController.h"

@interface KKMediaPreviewController () <UIPageViewControllerDataSource, KKMediaThumbnailControllerDelegate,KKMediaPlayerControllerDelegate>

@property (weak, nonatomic) UIButton *thumbnailModeButton;

@property (assign, nonatomic) NSUInteger currentPageIndex;

@end

@implementation KKMediaPreviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor blackColor];
    
    self.dataSource = self;
    
    _currentPageIndex=_startIndex;

    KKMediaPlayerController *vc = [self displayViewControllerForPageIndex:_startIndex];
    [self setViewControllers:@[vc]
                   direction:UIPageViewControllerNavigationDirectionForward
                    animated:NO
                  completion:nil];
    
    if (_thumbnailModeEnabled) {
        [self setupAlbumButton];
    }
    
    if(_showDeleteButton)
    {
        [self setupDeleteButton];
    }
}

-(BOOL)shouldAutorotate
{
    return NO;
}

- (void)setupAlbumButton {
    UIButton *thumbnailModeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [thumbnailModeButton setBackgroundImage:[UIImage imageNamed:@"barbutton_album_time_line"] forState:UIControlStateNormal];
    thumbnailModeButton.frame = CGRectMake(self.view.bounds.size.width - 55.0, self.view
                                           .bounds.size.height - 48.0, 55.0, 55.0);
    thumbnailModeButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
    [thumbnailModeButton addTarget:self action:@selector(thumbnailModeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _thumbnailModeButton = thumbnailModeButton;
    [self.view addSubview:thumbnailModeButton];
}

- (void)thumbnailModeButtonClicked:(UIButton *)button {
    
    KKMediaThumbnailController *vc = [[KKMediaThumbnailController alloc] init];
    vc.medias = _medias;
    vc.previewModeEnabled = NO;
    vc.delegate = self;
    
    UINavigationController *navc = [[UINavigationController alloc] initWithRootViewController:vc];
    [KKApplication setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [self presentViewController:navc animated:YES completion:nil];
}

-(void)setupDeleteButton
{
    UIBarButtonItem *deleteBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteBarButtonClicked)];
    
    self.navigationItem.rightBarButtonItem=deleteBarButton;
}

/** 删除图片 */
- (void)deleteBarButtonClicked {

    if(_preDelegate) [_preDelegate deleteImageIndex:_currentPageIndex];
    
    NSUInteger index = _currentPageIndex == 0 ? 0 : _currentPageIndex - 1;
    [_medias removeObjectAtIndex:_currentPageIndex];
    
    if (_medias.count == 0) {
        if (self.navigationController.viewControllers.firstObject == self.parentViewController) {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else {
        KKMediaPlayerController *vc = [self displayViewControllerForPageIndex:index];
        [self setViewControllers:@[vc] direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
    }
   
}

#pragma mark - UIPageViewController data source
- (UIViewController *)pageViewController:(UIPageViewController *)pvc
      viewControllerBeforeViewController:(KKMediaPlayerController *)vc {
    return [self displayViewControllerForPageIndex:vc.pageIndex - 1];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pvc
       viewControllerAfterViewController:(KKMediaPlayerController *)vc {
    return [self displayViewControllerForPageIndex:vc.pageIndex + 1];
}

 //page indiactor
-(NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return self.medias.count;
}

-(NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return _startIndex;
}

- (KKMediaPlayerController *)displayViewControllerForPageIndex:(NSUInteger)pageIndex {
    
    if (pageIndex > _medias.count - 1) {
        return nil;
    } else {
        KKMediaPlayerController *vc = [[KKMediaPlayerController alloc] init];
        vc.pageIndex = pageIndex;
        vc.delegate=self;
        vc.media = _medias[pageIndex];
        
        return vc;
    }
}

- (void)mediaThumbnailController:(KKMediaThumbnailController *)mediaThumbnailController
                  didSelectMedia:(KKMedia *)media {
    
    NSUInteger index = [_medias indexOfObject:media];
    KKMediaPlayerController *vc = [self displayViewControllerForPageIndex:index];
    [self setViewControllers:@[vc]
                   direction:UIPageViewControllerNavigationDirectionForward
                    animated:NO
                  completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.presentedViewController) {
        [KKApplication setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    }
}

#pragma mark - KKMediaPlayerControllerDelegate
-(void)didMedicalDisplayController:(KKMediaPlayerController *)medicalImageDisplayController
{
    _currentPageIndex=medicalImageDisplayController.pageIndex;
    //KKLog(@"did media index:%d",_currentPageIndex);
    
    self.navigationItem.title=KKStringWithFormat(@"%ld/%lu",(long)(_currentPageIndex+1),(unsigned long)_medias.count);
}

@end
