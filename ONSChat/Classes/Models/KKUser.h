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
    KKSExNone=0, //未知
    KKMale=1, // 男
    KKFemale=2, // 女
};

/** 健身目标 */
typedef NS_ENUM(NSUInteger, KKTargetType) {
    KKTargetTypeNone=0, //未知
    KKTargetTypeJianFei=1, // 减肥
    KKTargetTypeSuXing=2, // 塑形
    KKTargetTypeZengJi=3, // 增肌
};

@interface KKUser : NSObject

@property(assign,nonatomic) long long userId;
@property(copy,nonatomic) NSString *name;


//邮件姓名
@property(nonatomic,strong) NSString *mail_name;
//邮寄地址省
@property (nonatomic,strong) NSString *mail_city;
//邮寄地址市
@property (nonatomic,strong) NSString *mail_province;
@property (nonatomic,strong) NSString *mail_tele;
@property (nonatomic,strong) NSString *mail_address;

// 身份证号
@property (nonatomic,strong) NSString *insurance_id;

//用户名、密码
@property(strong,nonatomic) NSString *userName;
@property(strong,nonatomic) NSString *password;
//uuid
@property(strong,nonatomic) NSString *userUUID;
//uuid 不带横线
@property(strong,nonatomic) NSString *userUUIDNoLine;


//邀请人ID
@property(strong,nonatomic) NSString *userCode;

//当前是否正在绑定手机号,如果是弹出绑定手机号了，那不检测个人信息是否齐全,不让用户操作的页面过多
@property(assign,nonatomic) BOOL isBindPhone;

//其他信息
@property(strong,nonatomic) NSString *headImgUrl;
@property(strong,nonatomic) NSString *nickName;
@property(assign,nonatomic) KKSex sex;
@property(strong,nonatomic) NSString *birthday;
@property(strong,nonatomic) NSString *province;
@property(strong,nonatomic) NSString *city;
// 真实姓名
@property (nonatomic,strong) NSString *real_name;
@property(strong,nonatomic) NSString *tele;
@property(assign,nonatomic) CGFloat weight;//公斤
@property(assign,nonatomic) CGFloat height;//厘米
@property(assign,nonatomic) CGFloat targetWeight;//要减掉的体重
@property(assign,nonatomic) CGFloat phase_init_weight;//阶段初始体重
@property(assign,nonatomic) NSInteger targetDays;//暂时用不到
@property(assign,nonatomic) NSInteger pulse;
@property(assign,nonatomic) NSInteger points;
@property(assign,nonatomic) CGFloat initweight;
@property(assign,nonatomic) NSInteger type;//账号类型，3是手机号注册，如果不是3，设置里面修改密码的功能隐藏
@property(assign,nonatomic) BOOL userUpdateProfile;//是否更新过个人信息，默认在昵称第一步完成提交为ture
@property(assign,nonatomic) KKTargetType targetType;//健身目标
@property(assign,nonatomic) KKUserIdentifierType circleUserType;//身份标示
@property(assign,nonatomic) KKCourseVoiceType courseVoiceType;//男女配音

//是否允许查看隐私
@property (nonatomic, assign, getter=isCheckPrivacy) BOOL checkPrivacy;
//订阅弹出
@property (nonatomic, assign, getter=isSubscribe) BOOL subscribe;

//headImageData
@property(strong,nonatomic) UIImage *headImage;

@property(assign,nonatomic) NSInteger age;

//本地通知 Created by sra on 2016/01/20
@property (strong,nonatomic) NSArray *localNotificationWeights;     //体重提醒数组
@property (assign,nonatomic) BOOL localNotificationWeightOpen;      //体重提醒开关
@property (strong,nonatomic) NSArray *localNotificationEats;        //饮食提醒数组
@property (assign,nonatomic) BOOL localNotificationEatOpen;         //饮食提醒开关
@property (strong,nonatomic) NSArray *localNotificationDrinks;      //饮水提醒数组
@property (assign,nonatomic) BOOL localNotificationDrinkOpen;       //饮水提醒开关


//显示省份+城市
-(NSString*)provinceAndCityDisplay;

//读取性别
-(NSString*)sexDisplay;

//计算bmi，
-(CGFloat)calBMI;
//返回BMI描述
-(NSString*)calBMIDesc;

/******************转16进制*****************************/
-(NSString*)hexWithUserID;
-(NSString*)hexWithHeight;
-(NSString*)hexWithWeight;
-(NSString*)hexWithAge;
-(NSString*)hexWithSex;
-(NSString*)hexWithPulse;
-(NSString*)hexWithPhone;


@end
