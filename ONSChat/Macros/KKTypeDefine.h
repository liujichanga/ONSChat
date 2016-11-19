//
//  KKTypeDefine.h
//  KuaiKuai
//
//  Created by liujichang on 16/1/12.
//  Copyright © 2016年 liujichang. All rights reserved.
//

#ifndef KKTypeDefine_h
#define KKTypeDefine_h

/** 分享的模块类型  */
typedef NS_ENUM(NSUInteger, KKShareModel) {
    KKShareModelApp=1, //app share
    KKShareModelSportReport=2, // 运动报告
    KKShareModelKKReport=3, // 形值报告
    KKShareModelRecommend = 4, //邀请人ID分享
    KKShareModelFoodReport=5, // 饮食报告
    KKShareModelTopic = 6, //分享帖子
    //KKShareModelVideoFinish = 7, //视频播放结束分享
    KKShareModelDateCenter = 8,//数据中心报告分享
    KKShareModelDataCenterImage = 9,//数据中心分享截图
    KKShareModelPromotionalVideo = 10,//宣传视频分享
    KKShareModelVideoFinishStandard = 11, //课程小结标准课分享
    KKShareModelVideoFinishCustom = 12, //课程小结定制课分享
    KKShareModelWeighting = 13, //记录体重分享
    KKShareModelCode = 14 ,//赠送兑换码
    KKShareModelWebView = 15, //分享H5
    KKShareModelRunReport = 16, //跑步报告
    KKShareModelHotTopic = 17, //热门话题
};

/** 用户身份类型  */
typedef NS_ENUM(NSUInteger, KKUserIdentifierType) {
    KKUserIdentifierTypeNormal=0, //普通人
    KKUserIdentifierTypeJiaoLian=1, // 教练
    KKUserIdentifierTypeYYS=2, // 营养师
    KKUserIdentifierTypeXueYuan=3, // 线下课学员

};

/** 绑定手机号页面类型  */
typedef NS_ENUM(NSUInteger,KKRegisterType) {
    KKPhoneNumbeiRegister = 0,  // 手机号注册
    KKLostPassword = 1,  // 忘记密码
    KKBindingMobilePhoneNumber = 2, //绑定手机号
};

/** 男女配音类型  */
typedef NS_ENUM(NSUInteger,KKCourseVoiceType) {
    KKCourseVoiceTypeFemale = 0,  //女
    KKCourseVoiceTypeMale = 1  // 男
};

/** 支付类型  */
typedef NS_ENUM(NSUInteger,KKPayType) {
    KKPayTypeWX = 1,  //微信
    KKPayTypeAli = 2,  //支付宝
    KKPayTypeTB = 3, //淘宝h5
};

/** 测量心率页面显示状态  */
typedef NS_ENUM(NSUInteger,KKHeartRateMeasureType) {
    KKHeartRateBeforMeasure = 0,  //测量之前
    KKHeartRateMeasureDone = 1,   // 测量
    KKHeartRateMeasureFail = 2,   // 测量失败
    KKHeartRateMeasureSucceed = 3 // 测量成功
};

/** 弹窗场景 */
typedef NS_ENUM(NSUInteger,KKPopTipScene) {
    KKPopTipSceneCourse = 0,  //上视频课
    KKPopTipSceneRun = 1,   // 跑步
    KKPopTipSceneFood = 2,   // 发布饮食
    KKPopTipSceneShareTopic = 3 // 分享帖子
};


#endif /* KKTypeDefine_h */
