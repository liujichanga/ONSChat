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

#endif /* KKTypeDefine_h */
