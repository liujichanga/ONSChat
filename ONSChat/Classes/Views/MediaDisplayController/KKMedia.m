//
//  KKMedia.m
//  KuaiKuai
//
//  Created by liujichang on 15/7/2.
//  Copyright (c) 2015年 liujichang. All rights reserved.
//

#import "KKMedia.h"

@implementation KKMedia

+ (instancetype)mediaThumbnailUrl:(NSURL *)thumbnailUrl
                              url:(NSURL *)url
                             type:(KKMediaType)type  {
    return [[self alloc] initWithThumbnailUrl:thumbnailUrl url:url type:type];
}

- (instancetype)initWithThumbnailUrl:(NSURL *)thumbnailImageUrl
                                 url:(NSURL *)url
                                type:(KKMediaType)type {
    
    if (self = [super init]) {
        _thumbnailUrl = thumbnailImageUrl;
        _url = url;
        _type = type;
    }
    
    return self;
}

+ (instancetype)mediaThumbnail:(UIImage *)thumbnail
                           url:(NSURL *)url
                          type:(KKMediaType)type {
    return [[self alloc] initWithThumbnail:thumbnail url:url type:type];
}

- (instancetype)initWithThumbnail:(UIImage *)thumbnail
                              url:(NSURL *)url
                             type:(KKMediaType)type {
    
    if (self = [self initWithThumbnailUrl:nil url:url type:type]) {
        _thumbnail = thumbnail;
        _data=thumbnail;
    }
    
    return self;
}

@end
