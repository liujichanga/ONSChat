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




//点赞
#define ServiceInterfaceAddpraise KKStringWithFormat(@"%@/%@/addpraise", KKServerDomain, App)


#endif
