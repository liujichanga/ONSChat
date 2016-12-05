//
//  KKDomain.h
//  KuaiKuai
//
//  Created by liujichang on 15/9/24.
//  Copyright (c) 2015年 liujichang. All rights reserved.
//

#ifndef KuaiKuai_KKDomain_h
#define KuaiKuai_KKDomain_h

// Domain
//#define KKServerDomain @"http://192.168.40.56:8080"
//#define KKServerDomain @"http://s.kuaikuaikeji.com"
#define KKServerDomain @"http://114.215.81.244:8080" 
//@"http://jiaoyou2app.tongchengsupei.cn:8090"

#ifdef DEBUG
#define KKBuildVersion KKStringWithFormat(@"dev-%@-%@", KKAppVersion,KKAppBuildVersion)
#else
#define KKBuildVersion KKStringWithFormat(@"%@-%@", KKAppVersion,KKAppBuildVersion)
#endif

#endif
