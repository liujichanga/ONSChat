//
//  KKMediaPlayerController.m
//  KuaiKuai
//
//  Created by liujichang on 15/7/2.
//  Copyright (c) 2015年 liujichang. All rights reserved.
//

#import "KKMediaPlayerController.h"
#import "KKImageScrollView.h"

@interface KKMediaPlayerController() <KKImageScrollViewDelegate>

@property (weak, nonatomic) KKImageScrollView *imageScrollView;

@end

@implementation KKMediaPlayerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    KKImageScrollView *imageScrollView = [[KKImageScrollView alloc] initWithFrame:self.view.bounds];
    imageScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    if (_media.data) {
        imageScrollView.image = _media.data;
    } else {
        imageScrollView.imageUrl = _media.url;
    }
    
    imageScrollView.tapDelegate = self;
    _imageScrollView = imageScrollView;
    [self.view addSubview:imageScrollView];
  
}

-(BOOL)shouldAutorotate
{
    return NO;
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_delegate didMedicalDisplayController:self];
}


- (void)tapInImageScrollView:(KKImageScrollView *)imageScrollView {
    
    if (self.navigationController.viewControllers.firstObject == self.parentViewController) {
        [KKApplication setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        BOOL hidden = !self.navigationController.navigationBar.hidden;
        [KKApplication setStatusBarHidden:hidden withAnimation:UIStatusBarAnimationNone];
        [self.navigationController setNavigationBarHidden:hidden animated:NO];
    }
}

@end
