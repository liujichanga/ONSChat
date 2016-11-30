//
//  KKDynamic.h
//  ONSChat
//
//  Created by liujichang on 2016/11/30.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKTypeDefine.h"



@interface KKDynamic : NSObject

@property(strong,nonatomic) NSString *userId;//用户id
@property(strong,nonatomic) NSString *avatarUrl;//头像url
@property(strong,nonatomic) NSString *nickName;//昵称
@property(assign,nonatomic) NSInteger age;//年龄
@property(assign,nonatomic) NSInteger height;//厘米
@property(strong,nonatomic) NSString *distanceKm;//距离
@property(assign,nonatomic) BOOL isliked;//是否已经喜欢

@property(strong,nonatomic) NSString *dynamicsId;//动态id
@property(assign,nonatomic) NSInteger commentNum;//评论数量
@property(assign,nonatomic) NSInteger praiseNum;//点赞数量
@property(assign,nonatomic) KKDynamicsType dynamicsType;//动态类型
@property(strong,nonatomic) NSString *dynamicUrl;//动态对应的url
@property(strong,nonatomic) NSString *dynamiVideoThumbnail;//动态对应的视频缩略图
@property(strong,nonatomic) NSString *dynamicText;//动态文本
@property(strong,nonatomic) NSString *date;//日期


-(instancetype)initWithDic:(NSDictionary*)dic;



@end
