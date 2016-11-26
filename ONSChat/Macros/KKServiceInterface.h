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



#endif
