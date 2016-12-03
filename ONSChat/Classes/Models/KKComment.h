//
//  KKComment.h
//  ONSChat
//
//  Created by 王磊 on 2016/12/2.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KKComment : NSObject
//动态ID
@property(strong,nonatomic) NSString *dynamicsId;
//评论人ID
@property(strong,nonatomic) NSString *userId;
//评论人昵称
@property(strong,nonatomic) NSString *name;
//评论人年龄
@property(assign,nonatomic) NSInteger age;
//头像
@property(strong,nonatomic) NSString *avatarUrl;
//距离
@property(strong,nonatomic) NSString *distanceKm;
//身高 cm
@property(assign,nonatomic) NSInteger height;
//评论内容
@property (nonatomic, strong) NSString *commentText;
//地址
@property (nonatomic, strong) NSString *address;

-(instancetype)initWithDic:(NSDictionary*)dic;
@end
