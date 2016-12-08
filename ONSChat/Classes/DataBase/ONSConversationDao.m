//
//  ONSConversationDao.m
//  ONSChat
//
//  Created by liujichang on 2016/12/1.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "ONSConversationDao.h"

//表名
#define TableName KKStringWithFormat(@"Conversation_%@",KKSharedCurrentUser.userId)

//表所有字段
#define ColID @"conversationId"
#define ColTargetId @"targetId"
#define ColAvatar @"avatar"
#define ColNickName @"nickName"
#define ColAddress @"address"
#define ColAge @"age"
#define ColLastMessageId @"lastMessageId"
#define ColUnReadCount @"unReadCount"
#define ColTime @"time"


//所有列
#define AllColumns ColTargetId,ColAvatar,ColNickName,ColAddress,ColAge,ColLastMessageId,ColUnReadCount,ColTime

//Run实列所有字段值
#define AllFields record.targetId,record.avatar,record.nickName,record.address,@(record.age),@(record.lastMessageId),@(record.unReadCount),@(record.time)

//-------------CURD------------------/
//插入语句
#define InsertRecordSql KKStringWithFormat(@"INSERT INTO %@(%@, %@, %@, %@, %@, %@, %@, %@) VALUES (?, ?, ?, ?, ?, ?, ?, ?)", TableName, AllColumns)
//插入数值
#define InsertRecordSqlArgs @[AllFields]

//更新语句
#define UpdateRecordSql KKStringWithFormat(@"UPDATE %@ SET %@=?, %@=?,%@=?,%@=?,%@=?,%@=?,%@=?,%@=? WHERE %@=?",TableName, AllColumns,ColID)
//更新数值
#define UpdateRecordSqlArgs @[AllFields,@(record.conversationId)]



@implementation ONSConversationDao

static dispatch_once_t _once;
static ONSConversationDao *instance;

+(instancetype)sharedConversationDao
{
    dispatch_once(&_once, ^{
        instance = [[self alloc] init];
        [instance checkTable];
    });
    
    return instance;
}

/*注意注意一定在注销时候调用此方法**/
+(void)releaseSingleton
{
    _once = 0;
    instance = nil;
}

//检查表
-(void)checkTable{
    KKLog(@"chcecktable:%@",TableName);
    [self checkTable:TableName createTable:^NSString *{
        return [self createTableSql];
    } updateTable:^(FMDatabase *db) {

    }];
}

//创建表语句
-(NSString*)createTableSql
{
    return KKStringWithFormat(@"CREATE TABLE %@ (%@ INTEGER PRIMARY KEY AUTOINCREMENT, %@ char(100),%@ char(200),%@ char(100),%@ char(100),%@ INTEGER,%@ INTEGER,%@ INTEGER,%@ INTEGER)", TableName, ColID, AllColumns);
}


//序列化实体
-(ONSConversation *)serializeWithRS:(FMResultSet*)rs
{
    ONSConversation *record = [[ONSConversation alloc] init];
    record.conversationId = [rs longLongIntForColumn:ColID];
    record.targetId=[rs stringForColumn:ColTargetId];
    record.avatar=[rs stringForColumn:ColAvatar];
    record.nickName=[rs stringForColumn:ColNickName];
    record.address=[rs stringForColumn:ColAddress];
    record.age=[rs intForColumn:ColAge];
    record.lastMessageId=[rs longLongIntForColumn:ColLastMessageId];
    record.unReadCount=[rs intForColumn:ColUnReadCount];
    record.time=[rs longLongIntForColumn:ColTime];
    
    return record;
}

//-----------------CRUD----------------------------/

-(void)addConversation:(ONSConversation *)record completion:(KKDaoUpdateCompletion)completion inBackground:(BOOL)inbackground
{
    record.time=[[NSDate date] timeIntervalSince1970];
    
    [self update:^BOOL(FMDatabase *db) {
        BOOL succeed = [db executeUpdate:InsertRecordSql withArgumentsInArray:InsertRecordSqlArgs];
        if(succeed) record.conversationId = db.lastInsertRowId;
        return succeed;
    } completion:completion inBackground:inbackground];
}

//修改记录
-(void)updateConversation:(ONSConversation *)record completion:(KKDaoUpdateCompletion)completion inBackground:(BOOL)inbackground
{
    record.time=[[NSDate date] timeIntervalSince1970];
    
    [self update:^BOOL(FMDatabase *db) {
        return [db executeUpdate:UpdateRecordSql withArgumentsInArray:UpdateRecordSqlArgs];
    } completion:completion inBackground:inbackground];
}

//读取
-(void)getConversationByTargetId:(NSString*)targetId completion:(KKDaoQueryCompletion)completion inBackground:(BOOL)inbackground
{
    [self query:^id(FMDatabase *db) {
        NSString *sql = KKStringWithFormat(@"SELECT * FROM %@ WHERE %@=?", TableName, ColTargetId);
        FMResultSet *rs = [db executeQuery:sql withArgumentsInArray:@[targetId]];
        if (!rs.next) {
            return nil;
        }
        
        //序列化实体
        ONSConversation *record=[self serializeWithRS:rs];
        
        [rs close];
        
        return record;
    } completion:completion inBackground:inbackground];
}

//读取记录列表,不包括系统会话
-(void)getConversationListCompletion:(KKDaoQueryCompletion)completion inBackground:(BOOL)inbackground
{
    [self query:^id(FMDatabase *db) {
        NSString *sql = KKStringWithFormat(@"SELECT * FROM %@ WHERE %@<>'0' ORDER BY %@ DESC", TableName,ColTargetId,ColTime);
        FMResultSet *rs = [db executeQuery:sql withArgumentsInArray:nil];
        
        NSMutableArray *arr = [NSMutableArray array];
        
        while (rs.next) {
            
            //序列化实体
            ONSConversation *record=[self serializeWithRS:rs];
            
            [arr addObject:record];
        }
        
        [rs close];
        
        if(arr.count==0) return nil;
        
        return arr;
        
    } completion:completion inBackground:inbackground];
}

//读取未读总数
-(void)getConversationUnReadCountCompletion:(KKDaoQueryCompletion)completion inBackground:(BOOL)inbackground
{
    [self query:^id(FMDatabase *db) {
        NSString *sql = KKStringWithFormat(@"SELECT SUM(%@) FROM %@ ", ColUnReadCount,TableName);
        FMResultSet *rs = [db executeQuery:sql withArgumentsInArray:nil];
        if (!rs.next) {
            return nil;
        }
        
        NSInteger count = [rs intForColumnIndex:0];
        
        [rs close];
        
        return [NSNumber numberWithInteger:count];
    } completion:completion inBackground:inbackground];

}

//更新未读总数为0
-(void)updateNoUnReadCountByTargetId:(NSString *)targetId completion:(KKDaoUpdateCompletion)completion inBackground:(BOOL)inbackground
{
    [self update:^BOOL(FMDatabase *db) {
        NSString *sql = KKStringWithFormat(@"UPDATE %@ SET %@=? WHERE %@=? ", TableName,ColUnReadCount,ColTargetId);

        return [db executeUpdate:sql withArgumentsInArray:@[@(0),targetId]];
    } completion:completion inBackground:inbackground];
}

@end
