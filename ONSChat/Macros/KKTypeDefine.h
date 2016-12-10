//
//  KKTypeDefine.h
//  KuaiKuai
//
//  Created by liujichang on 16/1/12.
//  Copyright © 2016年 liujichang. All rights reserved.
//

#ifndef KKTypeDefine_h
#define KKTypeDefine_h


/** 动态类型 */
typedef NS_ENUM(NSUInteger, KKDynamicsType) {
    KKDynamicsTypeImage=1, // 图片
    KKDynamicsTypeVideo=2 // 视频
};

/*!
 消息的方向
 */
typedef NS_ENUM(NSUInteger, ONSMessageDirection) {
    /*!
     发送
     */
    ONSMessageDirection_SEND = 1,
    
    /*!
     接收
     */
    ONSMessageDirection_RECEIVE = 2
};

/** 消息类型 */
typedef NS_ENUM(NSUInteger, ONSMessageType) {
    ONSMessageType_System=1, // 系统消息
    ONSMessageType_Text=2, // 文本消息
    ONSMessageType_Choice=3, // 选择题
    ONSMessageType_NormImage=4, // 普通图片
    ONSMessageType_LockImage=5, // 加锁图片
    ONSMessageType_Video=6, // 视频消息
    ONSMessageType_Voice=7, // 语音消息
    ONSMessageType_WeChat=8, // 微信消息
    ONSMessageType_Hi=9, // 招呼消息
    ONSMessageType_Recommand=10, // 系统推荐
    ONSMessageType_NearBy=11, // 附近

};

/** 回复类型 */
typedef NS_ENUM(NSUInteger, ONSReplyType) {
    ONSReplyType_Normal=1, // 文本回复
    ONSReplyType_Contact=2, // 索要联系方式
    ONSReplyType_QQ=3 // 索要qq
    
};

/** 输入状态 */
typedef enum {
    ONSInputViewStateOther,
    ONSInputViewStateText,
    ONSInputViewStateVoice,
    ONSInputViewStateEmotion
}  ONSInputViewState;

//资料类型
typedef NS_ENUM(NSUInteger, MyInfoType){
   
    MyInfoType_Birthday=1, //生日
    MyInfoType_Address=2, //居住地
    MyInfoType_Height=3, //身高
    MyInfoType_Weight=4, //体重
    MyInfoType_Blood=5, //血型
    MyInfoType_Graduate=6, //学历
    MyInfoType_Job=7, //职业
    MyInfoType_Income=8, //收入
    MyInfoType_HasHouse=9, //是否有房
    MyInfoType_HasCar=10, //是否有车
    MyInfoType_Marry=11, //婚姻状况
    MyInfoType_Child=12, //是否想要小孩
    MyInfoType_DistanceLove=13, //是否接受异地恋
    MyInfoType_LoveType=14, //喜欢的异性类型
    MyInfoType_LiveTog=15, //是否接受婚前性行为
    MyInfoType_WithParent=16, //愿意跟父母同住
    MyInfoType_Pos=17 //魅力部位
};


#endif /* KKTypeDefine_h */
