//
//  KKUser.h
//  KuaiKuai
//
//  Created by jichang.liu on 15/6/26.
//  Copyright (c) 2015年 liujichang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKTypeDefine.h"

/** 性别 */
typedef NS_ENUM(NSUInteger, KKSex) {
    KKFemale=0, // 女
    KKMale=1 // 男
};


@interface KKUser : NSObject

//登录用户id跟密码
@property(assign,nonatomic) long long userId;
@property(strong,nonatomic) NSString *password;

//基本信息
@property(assign,nonatomic) NSInteger age;//年龄
@property(assign,nonatomic) KKSex sex;//性别
@property(strong,nonatomic) NSString *nickName;//昵称
@property(strong,nonatomic) NSString *birthday;//生日
@property(strong,nonatomic) NSString *address;//居住地(格式如“北京-北京”)
@property(assign,nonatomic) NSInteger height;//厘米
@property(assign,nonatomic) NSInteger weight;//公斤
@property(strong,nonatomic) NSString *blood;//血型
@property(strong,nonatomic) NSString *astro;//星座,根据生日计算
@property(strong,nonatomic) NSString *graduate;//学历
@property(strong,nonatomic) NSString *job;//职业
@property(strong,nonatomic) NSString *income;//收入
@property(strong,nonatomic) NSString *hasHouse;//是否有房
@property(assign,nonatomic) BOOL hasCar;//是否有车

@property(strong,nonatomic) NSString *marry;//婚姻状况
@property(strong,nonatomic) NSString *child;//是否想要小孩
@property(strong,nonatomic) NSString *distanceLove;//是否接受异地恋
@property(strong,nonatomic) NSString *lovetype;//喜欢的异性类型
@property(strong,nonatomic) NSString *livetog;//是否接受婚前性行为
@property(strong,nonatomic) NSString *withparent;//愿意跟父母同住
@property(strong,nonatomic) NSString *pos;//魅力部位

@property(strong,nonatomic) NSString *hobby;//兴趣爱好
@property(strong,nonatomic) NSString *personality;//个性特征

@property(strong,nonatomic) NSString *phone;//手机号码
@property(strong,nonatomic) NSString *qq;//QQ号码
@property(strong,nonatomic) NSString *weixin;//微信号码

@property(strong,nonatomic) NSString *sign;//内心独白


//征友条件
@property(strong,nonatomic) NSString *ta_age;//ta的年龄范围
@property(strong,nonatomic) NSString *ta_height;//ta的身高范围
@property(strong,nonatomic) NSString *ta_graduate;//ta的学历
@property(strong,nonatomic) NSString *ta_income;//TA的收入
@property(strong,nonatomic) NSString *ta_address;//TA的住所


//在登录时候跟我的页面会用到
@property(strong,nonatomic) NSString *avatarUrl;//头像地址
@property(assign,nonatomic) BOOL hasPhone;//是否手机验证
@property(assign,nonatomic) BOOL isVIP;//是否vip
@property(assign,nonatomic) BOOL isMsg;//短信包月状态
@property(assign,nonatomic) NSInteger beannum;//红豆数量
@property(assign,nonatomic) NSInteger likedmeNum;//喜欢我的人数量
@property(assign,nonatomic) NSInteger melikeNum;//我喜欢的人数量
@property(assign,nonatomic) NSInteger visitNum;//最近访客数量
@property(strong,nonatomic) NSString *vipEndTime;//vip到期时间
@property(strong,nonatomic) NSString *baoyueEndTime;//包月到期时间




//额外信息，在推荐跟附近页面会用到
@property(assign,nonatomic) BOOL isliked;//是否已经喜欢
@property(assign,nonatomic) BOOL noticedToday;//是否今天已打过招呼
@property(strong,nonatomic) NSArray *avatarUrlList;//头像相册列表
@property(strong,nonatomic) NSString *distanceKm;//显示的距离


@end
