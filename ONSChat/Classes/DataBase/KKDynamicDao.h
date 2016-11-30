//
//  KKDynamicDao.h
//  ONSChat
//
//  Created by liujichang on 2016/11/30.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "KKBaseDao.h"
#import "KKDynamic.h"


#define KKSharedDynamicDao [KKDynamicDao sharedDynamicDao]


@interface KKDynamicDao : KKBaseDao

+(instancetype)sharedDynamicDao;

//添加动态
-(void)addDynamic:(KKDynamic *)dynamic completion:(KKDaoUpdateCompletion)completion inBackground:(BOOL)inbackground;

//删除动态
-(void)deleteDynamic:(NSString*)dynamicId completion:(KKDaoUpdateCompletion)completion inBackground:(BOOL)inbackground;

//读取动态
-(void)getDynamicById:(NSString*)dynamicId completion:(KKDaoQueryCompletion)completion inBackground:(BOOL)inbackground;

//读取动态列表
-(void)getDynamicListCompletion:(KKDaoQueryCompletion)completion inBackground:(BOOL)inbackground;


@end
