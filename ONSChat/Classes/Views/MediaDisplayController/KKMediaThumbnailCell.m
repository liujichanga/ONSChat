//
//  KKMediaThumbnailCell.m
//  KuaiKuai
//
//  Created by liujichang on 15/7/2.
//  Copyright (c) 2015年 liujichang. All rights reserved.
//

#import "KKMediaThumbnailCell.h"

@interface KKMediaThumbnailCell ()

/** 图片 */
@property (weak, nonatomic) UIImageView *imageView;
/** 遮罩 */
@property (weak, nonatomic) UIView *coverView;

@end


@implementation KKMediaThumbnailCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        // 图片
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _imageView = imageView;
        [self.contentView addSubview:imageView];
        
        // 遮罩
        UIView *coverView = [[UIView alloc] initWithFrame:self.bounds];
        coverView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        coverView.backgroundColor = [UIColor blackColor];
        coverView.alpha = 0.0;
        _coverView = coverView;
        [self.contentView addSubview:coverView];
    }
    return self;
}

- (void)setMedia:(KKMedia *)media {
    _media = media;
    
    if (media.thumbnail) {
        _imageView.image = media.thumbnail;
    } else {
        [_imageView sd_setImageWithURL:media.thumbnailUrl];
    }
}

- (void)setHighlighted:(BOOL)highlighted {
    super.highlighted = highlighted;
    
    CGFloat toAlpha = highlighted ? 0.3 : 0.0;
    [UIView animateWithDuration:0.1 animations:^{
        _coverView.alpha = toAlpha;
    }];
}

@end
