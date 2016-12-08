//
//  KKServiceInterface.h
//  KuaiKuai
//
//  Created by liujichang on 15/6/26.
//  Copyright (c) 2015年 liujichang. All rights reserved.
//

#ifndef KuaiKuai_KKServiceInterface_h
#define KuaiKuai_KKServiceInterface_h


// Domain
//#define KKServerDomain @"http://192.168.40.80"
//#define KKServerDomain @"http://test.kuaikuaikeji.com"

// Application
#define App @"sp-api/mobile"

//登陆
#define ServiceInterfaceLogin KKStringWithFormat(@"%@/%@/login", KKServerDomain, App)
//注册
#define ServiceInterfaceRegister KKStringWithFormat(@"%@/%@/register", KKServerDomain, App)
//根据ip返回城市
#define ServiceInterfaceGetCityByIp @"https://whois.pconline.com.cn/ipJson.jsp"
//每日推荐
#define ServiceInterfaceDailyRecommand KKStringWithFormat(@"%@/%@/daily", KKServerDomain, App)
//随机昵称
#define ServiceInterfaceRandomNickName KKStringWithFormat(@"%@/%@/getnickname", KKServerDomain, App)
//打招呼
#define ServiceInterfaceGreet KKStringWithFormat(@"%@/%@/greet", KKServerDomain, App)
//去聊天
#define ServiceInterfaceSeduce KKStringWithFormat(@"%@/%@/seduce", KKServerDomain, App)
//发送聊天消息
#define ServiceInterfaceMessageSend KKStringWithFormat(@"%@/%@/chat/msg/send", KKServerDomain, App)
//接收到聊天消息
#define ServiceInterfaceMessageSendback KKStringWithFormat(@"%@/%@/chat/msg/sendback", KKServerDomain, App)


//获取资料
#define ServiceInterfaceUserInfo KKStringWithFormat(@"%@/%@/user/info", KKServerDomain, App)
//绑定手机号
#define ServiceInterfaceUserSendSmsCode KKStringWithFormat(@"%@/%@/user/SendSmsCode", KKServerDomain, App)
//首页推荐
#define ServiceInterfaceIndex KKStringWithFormat(@"%@/%@/indexdata", KKServerDomain, App)
//动态列表
#define ServiceInterfaceDynamics KKStringWithFormat(@"%@/%@/user/dynamics", KKServerDomain, App)
//我的页面，付费信息
#define ServiceInterfaceUserCenter KKStringWithFormat(@"%@/%@/user/center", KKServerDomain, App)
//喜欢某人
#define ServiceInterfaceLike KKStringWithFormat(@"%@/%@/like", KKServerDomain, App)
//动态相关
#define ServiceInterfaceDynamicsabout KKStringWithFormat(@"%@/%@/user/dynamicsabout", KKServerDomain, App)
//点赞
#define ServiceInterfaceAddPraise KKStringWithFormat(@"%@/%@/addpraise", KKServerDomain, App)
//获取评论列表
#define ServiceInterfaceGetCommentList KKStringWithFormat(@"%@/%@/user/getCommentList", KKServerDomain, App)
//提交评论
#define ServiceInterfacePublishComment KKStringWithFormat(@"%@/%@/user/PublishComment", KKServerDomain, App)
//我的资料选项
#define ServiceInterfaceConstAll KKStringWithFormat(@"%@/%@/const/all", KKServerDomain, App)
//我的资料修改提交
#define ServiceInterfaceUserEdit KKStringWithFormat(@"%@/%@/user/edit", KKServerDomain, App)
//获取手机号 QQ号 微信号
#define ServiceInterfaceGetVipphone KKStringWithFormat(@"%@/%@/getVipphone", KKServerDomain, App)
//获取客服电话
#define ServiceInterfaceSPhone KKStringWithFormat(@"%@/%@/const/sphone", KKServerDomain, App)
//读取商品列表
#define ServiceInterfaceGoodList KKStringWithFormat(@"%@/%@/goods/list", KKServerDomain, App)




#endif
