//
//  ONSConversationDao.h
//  ONSChat
//
//  Created by liujichang on 2016/12/1.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "KKBaseDao.h"
#import "ONSConversation.h"

#define ONSSharedConversationDao [ONSConversationDao sharedConversationDao]

@interface ONSConversationDao : KKBaseDao

+(instancetype)sharedConversationDao;

/*注意注意一定在注销时候调用此方法**/
+(void)releaseSingleton;

//添加会话
-(void)addConversation:(ONSConversation *)record completion:(KKDaoUpdateCompletion)completion inBackground:(BOOL)inbackground;

//修改记录
-(void)updateConversation:(ONSConversation *)record completion:(KKDaoUpdateCompletion)completion inBackground:(BOOL)inbackground;

//读取会话
-(void)getConversationByTargetId:(NSString*)targetId completion:(KKDaoQueryCompletion)completion inBackground:(BOOL)inbackground;


//读取会话列表，不包括系统会话
-(void)getConversationListCompletion:(KKDaoQueryCompletion)completion inBackground:(BOOL)inbackground;

//读取未读会话总数
-(void)getConversationUnReadCountCompletion:(KKDaoQueryCompletion)completion inBackground:(BOOL)inbackground;



@end
