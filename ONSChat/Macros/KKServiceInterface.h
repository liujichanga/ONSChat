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

#define AppPre @"sp-api"
#define AppMobile @"mobile"

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
//获取验证码
#define ServiceInterfaceUserSendSmsCode KKStringWithFormat(@"%@/%@/sendsms", KKServerDomain, App)
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
//支付
#define ServiceInterfacePay KKStringWithFormat(@"%@/%@/pay", KKServerDomain, App)
//支付回调
#define ServiceInterfacePayCallBack KKStringWithFormat(@"%@/%@/payEco/callback", KKServerDomain, AppPre)
//绑定手机号
#define ServiceInterfaceUsertTelbind KKStringWithFormat(@"%@/%@/user/telbind", KKServerDomain, AppPre)
//读取红豆随机人
#define ServiceInterfaceBoysRand KKStringWithFormat(@"%@/%@/user/boys/rand", KKServerDomain, AppPre)
//减去红豆
#define ServiceInterfaceReduceBeanNum KKStringWithFormat(@"%@/%@/reduceBeannum", KKServerDomain, App)
//喜欢我的人
#define ServiceInterfaceLikeMe KKStringWithFormat(@"%@/%@/user/likelist", KKServerDomain, App)
//我喜欢的人
#define ServiceInterfaceMeLike KKStringWithFormat(@"%@/%@/user/melike", KKServerDomain, App)
//最近访客
#define ServiceInterfaceVisit KKStringWithFormat(@"%@/%@/user/visitlist", KKServerDomain, App)
//修改密码
#define ServiceInterfaceModifypassword KKStringWithFormat(@"%@/%@/modifypassword", KKServerDomain, App)





/**  h5 URL **/
//客服中心
#define ServiceInterfaceCustomCallCenter @"http://www.tongchengsupei.cn/appdocument/callCenter.html"
//用户协议
#define ServiceInterfaceUserAgreement @"http://www.tongchengsupei.cn/appdocument/agreement.html"
//用户关心的问题
#define ServiceInterfaceQuestions @"http://www.tongchengsupei.cn/appdocument/questions.html"




#endif
