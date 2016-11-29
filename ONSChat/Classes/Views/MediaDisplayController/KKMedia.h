//
//  KKMedia.h
//  KuaiKuai
//
//  Created by liujichang on 15/7/2.
//  Copyright (c) 2015年 liujichang. All rights reserved.
//多媒体对象

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, KKMediaType) {
    KKMediaText, //文本
    KKMediaTypeImage, //图片
    KKMediaTypeVideo, //视频
    KKMediaTypeVoice, //音频
};

@interface KKMedia : NSObject

/** 封面图片Url */
@property (strong, nonatomic) NSURL *thumbnailUrl;
/** 封面图片 */
@property (strong, nonatomic) UIImage *thumbnail;

/** 原始数据Url */
@property (strong, nonatomic) NSURL *url;
/** 原始数据 */
@property (strong, nonatomic) id data;

/** 媒体类型 */
@property (assign, nonatomic) KKMediaType type;

+ (instancetype)mediaThumbnailUrl:(NSURL *)thumbnailUrl
                              url:(NSURL *)url
                             type:(KKMediaType)type;

- (instancetype)initWithThumbnailUrl:(NSURL *)thumbnailImageUrl
                                 url:(NSURL *)url
                                type:(KKMediaType)type;

+ (instancetype)mediaThumbnail:(UIImage *)thumbnail
                           url:(NSURL *)url
                          type:(KKMediaType)type;

- (instancetype)initWithThumbnail:(UIImage *)thumbnail
                              url:(NSURL *)url
                             type:(KKMediaType)type;

@end
