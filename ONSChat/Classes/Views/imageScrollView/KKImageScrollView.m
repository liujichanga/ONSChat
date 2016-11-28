//
//  KKImageScrollView.m
//  KuaiKuai
//
//  Created by liujichang on 15/7/2.
//  Copyright (c) 2015年 liujichang. All rights reserved.
//

#import "KKImageScrollView.h"
#import "UIImageView+WebCache.h"

@interface KKImageScrollView()<UIScrollViewDelegate,UIActionSheetDelegate>

@property(weak,nonatomic) UIImageView *imageView;
@property(weak,nonatomic) UIActivityIndicatorView *indicatorView;
@property(assign,nonatomic,getter=isDownLoading) BOOL downLoading;


@end

@implementation KKImageScrollView

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.showsVerticalScrollIndicator = NO;
        self.bounces = YES;
        self.bouncesZoom = YES;
        self.decelerationRate = UIScrollViewDecelerationRateNormal;
        self.backgroundColor = [UIColor blackColor];
        self.delegate = self;
        
        UIImageView *imageview =[[UIImageView alloc] init];
        imageview.backgroundColor=[UIColor blackColor];
        imageview.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        imageview.contentMode = UIViewContentModeScaleAspectFill;
        imageview.userInteractionEnabled = YES;
        self.imageView = imageview;
        [self addSubview:imageview];
        
        UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        [_imageView addGestureRecognizer:singleTapGestureRecognizer];
        
        UITapGestureRecognizer *singleTapGestureRecognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        [self addGestureRecognizer:singleTapGestureRecognizer2];
        
        UITapGestureRecognizer *doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        doubleTapGestureRecognizer.numberOfTapsRequired = 2;
        [_imageView addGestureRecognizer:doubleTapGestureRecognizer];
        
        [singleTapGestureRecognizer requireGestureRecognizerToFail:doubleTapGestureRecognizer];

        UILongPressGestureRecognizer *longPressGR =
        [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongTap:)];
        longPressGR.minimumPressDuration = 0.5;
        [_imageView addGestureRecognizer:longPressGR];
        
    }
    return self;
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)tapGestureRecognizer {
    if (_downLoading) {
        return;
    }
    
    if (self.zoomScale == 1.0) { // Zoom in
        if (self.zoomScale == self.maximumZoomScale)
            return;
        CGPoint center = [tapGestureRecognizer locationInView:_imageView];
        CGSize size = CGSizeMake(self.bounds.size.width / self.maximumZoomScale,
                                 self.bounds.size.height / self.maximumZoomScale);
        CGRect rect = CGRectMake(center.x - (size.width / 2.0), center.y - (size.height / 2.0), size.width, size.height);
        [self zoomToRect:rect animated:YES];
    } else { // Zoom out
        [self zoomToRect:self.bounds animated:YES];
    }
}

- (void)handleSingleTap:(UITapGestureRecognizer *)tapGestureRecognizer {
    [_tapDelegate tapInImageScrollView:self];
}

-(void)handleLongTap:(UILongPressGestureRecognizer *)tapGestureRecognizer {
    
    if(tapGestureRecognizer.state==UIGestureRecognizerStateBegan)
    {
        if(!self.imageView.image) return;
        
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存到相册", nil];
        [sheet showInView:self];
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0)
    {
         UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
    }
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (!error) {
        [SVProgressHUD showSuccessWithStatus:@"保存成功" duration:1.0];
    }else
    {
        [SVProgressHUD showErrorWithStatus:@"保存失败" duration:1.0];
        NSLog(@"save error is %@",[error description]);
    }
}
//返回图片尺寸
- (CGSize)imageSize {
    CGImageRef imageRef = _image.CGImage;
    CGFloat width = CGImageGetWidth(imageRef) / [UIScreen mainScreen].scale;
    CGFloat height = CGImageGetHeight(imageRef) / [UIScreen mainScreen].scale;
    return CGSizeMake(width, height);
}

//根据最大尺寸，计算imageview的frame
- (CGRect)imageViewFrameForMaxSize:(CGSize)maxSize {
    
    CGSize size = [self imageSize];
    CGFloat width = size.width;
    CGFloat height = size.height;
    KKLog(@"图片尺寸:%@", NSStringFromCGSize(size));
    
    CGFloat maxWidth = maxSize.width;
    CGFloat maxHeight = maxSize.height;
    
    // 适配宽高
    //    // 最大尺寸 && 最小尺寸
    //    if (width != maxWidth || height != maxHeight) {
    //        CGFloat widthScale = maxWidth / width;
    //        CGFloat heightScale = maxHeight / height;
    //        CGFloat scale = widthScale < heightScale ? widthScale : heightScale;
    //        width *= scale;
    //        height *= scale;
    //    }
    
    // 只适配宽度
    if(width<=0) width=1;//判断width=0
    CGFloat scale = maxWidth / width;
    width *= scale;
    height *= scale;
    
    CGFloat x = (maxWidth - width) / 2;
    CGFloat y = (maxHeight - height) / 2;
    y = y < 0.0 ? 0.0 : y;
    
    return CGRectMake(x, y, width, height);
}

//根据最大尺寸，计算缩放范围与尺寸大小
- (void)setupImageViewAndScrollViewForMaxSize:(CGSize)maxSize {
    
    _imageView.frame = [self imageViewFrameForMaxSize:maxSize];
    
    KKLog(@"ImageViewFrame尺寸:%@", NSStringFromCGRect(_imageView.frame));

    //    self.contentSize = self.bounds.size; // 适配宽高
    self.contentSize = _imageView.frame.size; // 只适配宽度
    
    // 缩放比例
    self.minimumZoomScale = 1.0;
    CGFloat currentScale = [self imageSize].width / _imageView.bounds.size.width;
    CGFloat scale = 2.5;
    self.maximumZoomScale = currentScale < 1.0 ? scale : currentScale * scale;
}

- (void)setImage:(UIImage *)image {
    _image = image;
    
    [self setupImageViewAndScrollViewForMaxSize:self.bounds.size];
    [UIView transitionWithView:_imageView
                      duration:0.1
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        _imageView.image = image;
                    }
                    completion:nil];
}

- (void)setAsset:(ALAsset *)asset {
    _asset = asset;
    
    [KKThredUtils runInGlobalQueue:^{
        [[[ALAssetsLibrary alloc]init] assetForURL:asset.defaultRepresentation.url resultBlock:^(ALAsset *asset) {
            
            ALAssetRepresentation *assetRepresentation = asset.defaultRepresentation;
            CGImageRef imageRef = assetRepresentation.fullScreenImage;
            UIImage *image = [UIImage imageWithCGImage:imageRef
                                                 scale:assetRepresentation.scale
                                           orientation:UIImageOrientationUp];
            [KKThredUtils runInMainQueue:^{
                self.image = image;
            }];
        } failureBlock:^(NSError *error) {
        }];
    }];
}

- (void)setImageUrl:(NSURL *)imageUrl {
    _imageUrl = imageUrl;
    _downLoading = YES;
    
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] init];
    indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    indicatorView.hidesWhenStopped = YES;
    indicatorView.center = self.center;
    
    [indicatorView startAnimating];
    _indicatorView = indicatorView;
    [self addSubview:indicatorView];
    
    KKWEAKSELF
    [_imageView sd_setImageWithURL:imageUrl placeholderImage:_image completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [weakself.indicatorView stopAnimating];
        [weakself.indicatorView removeFromSuperview];
        
        if(image) weakself.image = image;
       
        _downLoading = NO;
    }];
}

/** 应对屏幕旋转 */
- (void)setFrame:(CGRect)frame {
    
    BOOL sizeChanging = !CGSizeEqualToSize(frame.size, self.frame.size);
    super.frame = frame;
    
    if (sizeChanging) {
        [self setupImageViewAndScrollViewForMaxSize:frame.size];
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _downLoading ? nil : _imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width) ? (scrollView.bounds.size.width - scrollView.contentSize.width) / 2 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height) ? (scrollView.bounds.size.height - scrollView.contentSize.height) / 2 : 0.0;
    _imageView.center = CGPointMake(scrollView.contentSize.width / 2 + offsetX, scrollView.contentSize.height / 2 + offsetY);
}




@end
