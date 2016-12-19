//
//  ONSChat.h
//  ONSChat
//
//  Created by liujichang on 2016/12/1.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKTypeDefine.h"


#define MessageInterval 20.0
#define MessageFont [UIFont systemFontOfSize:16]
#define MessageContentMaxWidth KKScreenWidth-130
#define MessageBackgoundInterval 80


@interface ONSMessage : NSObject

@property(assign,nonatomic) long long messageId;

@property(strong,nonatomic) NSString *targetId;
@property(assign,nonatomic) ONSMessageType messageType;
@property(assign,nonatomic) ONSReplyType replyType;
@property(assign,nonatomic) ONSMessageDirection messageDirection;
@property(strong,nonatomic) NSString *content;
@property(assign,nonatomic) long long time;//时间戳

//从数据库取出来的json数据
@property(strong,nonatomic) NSDictionary *contentJson;

-(instancetype)initWithDic:(NSDictionary*)dic;


//跟视图相关的信息
@property(assign,nonatomic) CGRect topViewFrame;
@property(assign,nonatomic) CGRect dateLabelFrame;

@property(assign,nonatomic) CGRect receiveHeadButtonFrame;
@property(assign,nonatomic) CGRect receiveBackGroundButtonFrame;
@property(assign,nonatomic) CGRect sendHeadButtonFrame;
@property(assign,nonatomic) CGRect sendBackGroundButtonFrame;

//换成文字的size
@property(assign,nonatomic) CGSize textSize;

//视图的高度
@property(assign,nonatomic) CGFloat cellHeight;


//图片大小
-(CGSize)imageSize;
//视频大小
-(CGSize)videoSize;
//微信大小
-(CGSize)wechatSize;
//声音大小
-(CGSize)voiceSize;


/***计算布局****/
-(void)calLayout;

//文字大小
-(CGSize)calTextContentSize;


@end
