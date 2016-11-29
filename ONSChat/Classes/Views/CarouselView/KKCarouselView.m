//
//  KKCarouselView.m
//  KuaiKuai
//
//  Created by YK on 16/4/19.
//  Copyright © 2016年 liujichang. All rights reserved.
//

#import "KKCarouselView.h"
#import "UIImageView+WebCache.h"


@implementation ImagePageControl

- (void)setCurrentPage:(NSInteger)currentPage {
    [super setCurrentPage:currentPage];
    
    for (NSUInteger subviewIndex = 0; subviewIndex < [self.subviews count]; subviewIndex++) {
        UIImageView* subview = [self.subviews objectAtIndex:subviewIndex];
        
        for (UIView *imageSubView in subview.subviews) {
            [imageSubView removeFromSuperview];
        }
        
        
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((subview.frame.size.width - 5)/2.0, (subview.frame.size.height - 5)/2.0, 5, 5)];
        
        [subview addSubview:imageView];
        if(subviewIndex == currentPage){
            UIImage *image = [UIImage imageNamed:@"KKCarouselView_w"];
            image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            imageView.image = image;
        }else {
            UIImage *image = [UIImage imageNamed:@"KKCarouselView_g"];
            image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            imageView.image = image;
        }
    }
}


@end


@interface KKCarouselView ()<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;


@property (strong, nonatomic) NSArray *imageArray;
@property (assign, nonatomic) int currentPage;
@property (strong, nonnull) NSTimer *timer;

@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) ImagePageControl *pageConrol;
@property (strong, nonatomic) UIImageView *pageBgImageView;

@property (nonatomic, strong) UILabel *pageLab;
@end


@implementation KKCarouselView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]){
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
        _scrollView.scrollsToTop=NO;
        [self addSubview:_scrollView];

        for (int i = 0 ; i<3; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * frame.size.width, 0, frame.size.width, frame.size.height)];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.clipsToBounds = YES;
            [_scrollView addSubview:imageView];
            imageView.tag = 1000 + i;
            imageView.backgroundColor = [UIColor blackColor];
            imageView.image = [UIImage imageNamed:@"def_head"];
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
            [imageView addGestureRecognizer:tap];
        }
        
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width-KKScreenWidth*(68/375.0), frame.size.height-40,KKScreenWidth*(68/375.0), KKScreenWidth*(30/375.0))];
        _bottomView.backgroundColor = [UIColor clearColor];
        [self addSubview:_bottomView];

        UIImageView *pageImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KKScreenWidth*(68/375.0),KKScreenWidth*(30/375.0))];
        pageImg.image = [UIImage imageNamed:@"pageNubBg"];
        [_bottomView addSubview:pageImg];
        
        UILabel *pageLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, KKScreenWidth*(68/375.0),KKScreenWidth*(30/375.0))];
        pageLab.textColor = [UIColor whiteColor];
        pageLab.textAlignment = NSTextAlignmentCenter;
        pageLab.font = [UIFont systemFontOfSize:16];
        [_bottomView addSubview:pageLab];
        self.pageLab = pageLab;
        
//        _pageBgImageView = [UIImageView new];
//        _pageBgImageView.image = [UIImage imageNamed:@"KKCarouselViewBg"];
//        [_bottomView addSubview:_pageBgImageView];
//        
//        
//        _pageConrol = [ImagePageControl new];
//        _pageConrol.currentPageIndicatorTintColor = [UIColor clearColor];
//        _pageConrol.pageIndicatorTintColor = [UIColor clearColor];
//        [_bottomView addSubview:_pageConrol];
    }
    return self;
}

- (void)tapAction {
    KKLog(@"点击了第几张图片%d",_currentPage);
    if(self.KKCarouselViewTapBlcok){
        self.KKCarouselViewTapBlcok(_currentPage);
    }
}

- (void)setNetworkImageURLStr:(NSArray *)array {
    _imageArray = array;
    _currentPage = 0;
    _pageConrol.numberOfPages = array.count;
    _pageConrol.currentPage = _currentPage;
    [self invalidateTimer];
    if(array.count > 1){
        self.pageLab.text = [NSString stringWithFormat:@"%zd/%zd",_currentPage+1,array.count];
        _bottomView.hidden = NO;
        _pageConrol.hidden = NO;
        
        CGFloat width = array.count * 16 + 5;
        _pageBgImageView.frame = CGRectMake(KKScreenWidth - width, 0, width, _bottomView.frame.size.height);
        
        width = array.count * 16;
        _pageConrol.frame = CGRectMake(KKScreenWidth - width, 0, width, _bottomView.frame.size.height);

        _scrollView.contentSize = CGSizeMake(3 * _scrollView.frame.size.width, _scrollView.frame.size.height);
        [self refreshImage:@[@(_imageArray.count-1),@(_currentPage),@(1)]];
        [self createTimer];
    }else {
        _pageConrol.hidden = YES;
        _pageBgImageView.hidden = YES;
        _bottomView.hidden = YES;
        _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, _scrollView.frame.size.height);
        UIImageView *imageView = [_scrollView viewWithTag:1000];
        NSString *imageStr = array.firstObject;
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"def_head"]];
    }
}


# pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self changeImageWithPage:scrollView.contentOffset.x];
}



- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self invalidateTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self createTimer];
}

# pragma mark - Timer
- (void)createTimer {
    if(_timer == nil){
        _timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(refreshPage) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}

- (void)invalidateTimer {
    if(_timer){
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)refreshPage {
    [_scrollView setContentOffset:CGPointMake(_scrollView.contentOffset.x + _scrollView.frame.size.width, 0) animated:YES];
}


# pragma mark - ChangeImage
- (void)changeImageWithPage:(CGFloat)page {
    if(page == 0){
        _currentPage--;
    }else if(page == 2 * _scrollView.frame.size.width){
        _currentPage++;
    }else {
        return;
    }
    _currentPage = [self getImageCount:_currentPage];
    int leftIndex = [self getImageCount:_currentPage-1];
    int rightIndex = [self getImageCount:_currentPage+1];
    [self refreshImage:@[@(leftIndex),@(_currentPage),@(rightIndex)]];
    
    _pageConrol.currentPage = _currentPage;
    self.pageLab.text = [NSString stringWithFormat:@"%zd/%zd",_currentPage+1,_imageArray.count];
}



- (int)getImageCount:(int)page {
    if(page == -1){
        int count = [[NSNumber numberWithUnsignedInteger:_imageArray.count] intValue]  - 1;
        return count;
    }else if(page == _imageArray.count){
        return 0;
    }else {
        return page;
    }
}


- (void)refreshImage:(NSArray *)indexArray {
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0) animated:NO];
    for (int i= 0; i<indexArray.count; i++) {
        UIImageView *imageView = [_scrollView viewWithTag:1000 + i];
        NSInteger index = [[indexArray objectAtIndex:i] intValue];
        NSString *imageStr = [_imageArray objectAtIndex:index];
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"def_head"]];       
    }
}

- (void)dealloc {
    [self invalidateTimer];
    KKLog(@"KKCarouselView dealloc");
}

@end
