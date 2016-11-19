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
#define App @"kas"

//登陆
#define ServiceInterfaceLogin KKStringWithFormat(@"%@/%@/ulogin", KKServerDomain, App)



#endif
