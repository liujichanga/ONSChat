//
//  KKMediaNavigationController.m
//  KuaiKuai
//
//  Created by liujichang on 15/7/2.
//  Copyright (c) 2015年 liujichang. All rights reserved.
//

#import "KKMediaNavigationController.h"
#import "KKMediaThumbnailController.h"
#import "KKMediaPreviewController.h"

NSString *const KKMediaNavigationControllerStartIndexKey = @"KKMediaNavigationControllerStartIndexKey";
NSString *const KKMediaPageControllerOrientationKey = @"KKMediaPageControllerOrientationKey";
NSString *const KKMediaPageControllerSpacingKey = @"KKMediaPageControllerSpacingKey";


@implementation KKMediaNavigationController

+ (instancetype)mediaNavigationControllerWithMedias:(NSMutableArray *)medias
                                     displayMode:(KKMediaDisplayMode)displayMode
                                         options:(NSDictionary *)options {
    return [[self alloc] initWithMedias:medias displayMode:displayMode options:options];
}

- (instancetype)initWithMedias:(NSMutableArray *)medias
                   displayMode:(KKMediaDisplayMode)displayMode
                       options:(NSDictionary *)options {
    
    if (self = [super init]) {
        
        UIPageViewControllerNavigationOrientation orientation = [options integerForKey:KKMediaPageControllerOrientationKey defaultValue:UIPageViewControllerNavigationOrientationHorizontal];
        CGFloat spacing = [options doubleForKey:KKMediaPageControllerSpacingKey defaultValue:16.0];
        
        switch (displayMode) {
            case KKMediaDisplayModeThumbnailAndPreview:
            case KKMediaDisplayModeThumbnail: {
                KKMediaThumbnailController *vc = [[KKMediaThumbnailController alloc] init];
                vc.orientation = orientation;
                vc.spacing = spacing;
                vc.medias = medias;
                vc.previewModeEnabled = displayMode == KKMediaDisplayModeThumbnailAndPreview;
                self.viewControllers = @[vc];
            } break;
            
            case KKMediaDisplayModePreviewAndThumbnail:
            case KKMediaDisplayModePreview: {
                KKMediaPreviewController *vc = [[KKMediaPreviewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:orientation options:@{UIPageViewControllerOptionInterPageSpacingKey : @(spacing)}];
                vc.medias = medias;
                vc.startIndex = [options unsignedIntegerForKey:KKMediaNavigationControllerStartIndexKey defaultValue:0];
                vc.thumbnailModeEnabled = displayMode == KKMediaDisplayModePreviewAndThumbnail;
                self.viewControllers = @[vc];
                
                [self setNavigationBarHidden:YES animated:NO];
            } break;
            default:
                break;
        }
    }
    
    return self;
}

-(BOOL)shouldAutorotate
{
    return NO;
}

@end
