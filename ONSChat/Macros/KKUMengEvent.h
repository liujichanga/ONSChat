//
//  KKUMengEvent.h
//  KuaiKuai
//
//  Created by liujichang on 15/11/15.
//  Copyright © 2015年 liujichang. All rights reserved.
//

#ifndef KKUMengEvent_h
#define KKUMengEvent_h

//首页加载
#define Event_HomePageLoad @"HomePageLoad"

//代餐商品页面加载
#define Event_FoodDetailLoad @"FoodDetailLoad"

//代餐订单页面加载
#define Event_FoodOrdeLoad @"FoodOrdeLoad"

//代餐购买
#define Event_FoodOrderBuy @"FoodOrderBuy"

//线下课购买页面加载
#define Event_OffLineCourseLoad @"OffLineCourseLoad"

//线下课订单页面加载
#define Event_OffLineCourseOrderLoad @"OffLineCourseOrderLoad"

//线下课购买
#define Event_OffLineCourseBuy @"OffLineCourseBuy"

//形值报告开始
#define Event_KKReportStart @"KKReportStart"

//形值测评成功
#define Event_KKReportSucceed @"KKReportSucceed"

//形值报告页面加载
#define Event_KKReportLoad @"KKReportLoad"

//线上课页面加载
#define Event_OnLineCourseLoad @"OnLineCourseLoad"

//线上课购买
#define Event_OnLineCourseBuy @"OnLineCourseBuy"

//称重页面加载
#define Event_WeightPageLoad @"WeightPageLoad"

//称重成功
#define Event_WeightSucceed @"WeightSucceed"

//app分享
#define Event_AppShare @"AppShare"

//形值报告分享
#define Event_KKReportShare @"KKReportShare"

//运动评估报告分享
#define Event_SportReportShare @"SportReportShare"

//有礼的商品详情点击
#define Event_GiftGoodsClick @"GiftGoodsClick"

//有礼根模块点击次数
#define Event_GiftRootClick @"GiftRootClick"

/*首页***********/
//开屏广告
#define Event_HomePageAD @"HomePageAD"
//下拉看看
#define Event_Homepulldown @"Homepulldown"
//体重管理
#define Event_HomeWeightmanagment @"HomeWeightmanagment"
//更多训练
#define Event_Homemoreexercises @"Homemoreexercises"
//更多饮食
#define Event_Homemorerecommendation @"Homemorerecommendation"
//首页饮食
#define Event_Homefood @"Homefood"
//首页体测
#define Event_HomeWeight @"HomeWeight"
//首页活动课程
#define Event_Homeactivity @"Homeactivity"
//首页更多
#define Event_HomePagemore @"HomePagemore"
//预约
#define Event_HomeOffline30 @"HomeOffline30"
#define Event_HomeOfflineCourse30 @"HomeOfflineCourse30"
#define Event_CustomCourse30 @"CustomCourse30"
#define Event_TrainingPlan30 @"TrainingPlan30"
#define Event_EntryTraining30 @"EntryTraining30"
#define Event_StartTraining30 @"StartTraining30"
#define Event_Coursedownload30 @"Coursedownload30"
#define Event_ExitTraining30 @"ExitTraining30"
#define Event_MyTrainingStandard30 @"MyTrainingStandard30"
#define Event_StandardPractice30 @"StandardPractice30"
#define Event_AddtrainingStandard30 @"AddtrainingStandard30"
#define Event_HomeAD30 @"HomeAD30"
#define Event_Kuaikuai30 @"Kuaikuai30"
#define Event_Find30 @"Find30"
#define Event_Shoppingmall30 @"Shoppingmall30"
#define Event_ME30 @"ME30"
#define Event_Exchangecourse30 @"Exchangecourse30"
#define Event_Shareapp30 @"Shareapp30"
//手机注册成功
#define Event_RegistrationSuccessios31 @"RegistrationSuccessios31"
//微信、qq或者其他第三方授权注册成功
#define Event_RegistrationSuccessBy3Authios31 @"RegistrationSuccessBy3Authios31"
//首页 - 记录饮食 - 饮食报告
#define Event_sharefoodC31 @"sharefoodC31"
//发现 - 分享动态
#define Event_sharefindC31 @"sharefindC31"
//我 - 推荐有礼 - 邀请好友
#define Event_shareinvitationC31 @"shareinvitationC31"
//我 - 兑换码 - 赠送好友
#define Event_shareDiscountcodeC31 @"shareDiscountcodeC31"
//定制课程小结-分享
#define Event_sharecourse31 @"sharecourse31"
//标准课程小线-分享
#define Event_shareScourse31 @"shareScourse31"
//首次开启定制课
#define Event_FirstCourse @"FirstCourse"
//定制课信息下一步
#define Event_CourseBMInext @"CourseBMInext"
//定制课改善下一步
#define Event_Courseimprove @"Courseimprove"
//定制课减肥目标男
#define Event_Coursegoalman @"Coursegoalman"
//定制课减肥-减脂
#define Event_Coursegoaljz @"Coursegoaljz"
//定制课减肥-塑形
#define Event_Coursegoalsx @"Coursegoalsx"
//定制课减肥-增肌
#define Event_Coursegoalzj @"Coursegoalzj"
//定制课减肥目标下一步
#define Event_Coursegoalnext @"Coursegoalnext"
//定制课属于类型下一步
#define Event_Coursestylenext @"Coursestylenext"
//定制课难度-初级
#define Event_Courseprimary @"Courseprimary"
//定制课难度-中级
#define Event_Coursemedium @"Coursemedium"
//定制课难度-中高级
#define Event_CourseseMS @"CourseseMS"
//定制课难度-高级
#define Event_Coursesenior @"Coursesenior"
//定制课难度下一步
#define Event_Coursedifficultynext @"Coursedifficultynext"
//定制课生成训练计划
#define Event_Courseplan @"Courseplan"
//定制课完成情况
#define Event_Coursefinish @"Coursefinish"
//定制课训练退出时间
#define Event_Coursequittime @"Coursequittime"
//标准课训练退出时间
#define Event_Scoursequittime @"Scoursequittime"
//线下课订单页面加载
#define Event_OffLineCourseOrderLoad @"OffLineCourseOrderLoad"
//标准课完成情况
#define Event_Scoursefinish @"OffLineCourseOrderLoad"
//数据中心分享截图打点
#define Event_DataCenterShare31 @"DataCenterShare31"
//崭新的自己视频分享
#define Event_VideoShare31 @"VideoShare31"
//H5分享
#define Event_H5Share31 @"H5Share31"


// 首页底部轮播打点
#define Event_3D1_HomeAD @"3D1_HomeAD"
// 发现头部打点
#define Event_3D1_FindAD @"3D1_FindAD"
//确认支付
#define Event_3D1_PurchaseCourse_OrderDetails_Pay @"3D1_PurchaseCourse_OrderDetails_Pay"



/****end**********/

//添加训练
#define Event_Addtraining @"Addtraining"
//开始训练
#define Event_Startfirsttraining @"Startfirsttraining"
//视频下载
#define Event_Coursedownload @"Coursedownload"
//查看动作示范
#define Event_click @"click"


#endif /* KKUMengEvent_h */
