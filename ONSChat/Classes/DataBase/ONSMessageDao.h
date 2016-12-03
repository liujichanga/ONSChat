//
//  ONSMessageDao.h
//  ONSChat
//
//  Created by liujichang on 2016/12/1.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "KKBaseDao.h"
#import "ONSMessage.h"

#define ONSSharedMessageDao [ONSMessageDao sharedMessageDao]


@interface ONSMessageDao : KKBaseDao

+(instancetype)sharedMessageDao;

/*注意注意一定在注销时候调用此方法**/
+(void)releaseSingleton;

//添加记录
-(void)addMessage:(ONSMessage *)record completion:(KKDaoUpdateCompletion)completion inBackground:(BOOL)inbackground;

//修改记录
-(void)updateMessage:(ONSMessage *)record completion:(KKDaoUpdateCompletion)completion inBackground:(BOOL)inbackground;

//读取记录
-(void)getMessageByMessageId:(long long)messageId completion:(KKDaoQueryCompletion)completion inBackground:(BOOL)inbackground;


//读取记录列表
-(void)getMessageListByTargetId:(NSString*)targetId Completion:(KKDaoQueryCompletion)completion inBackground:(BOOL)inbackground;



@end
