//
//  ONSMessageDao.m
//  ONSChat
//
//  Created by liujichang on 2016/12/1.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "ONSMessageDao.h"


//表名
#define TableName KKStringWithFormat(@"Message_%@",KKSharedCurrentUser.userId)

//表所有字段
#define ColID @"messageId"
#define ColTargetId @"targetId"
#define ColContent @"content"
#define ColMessageType @"messageType"
#define ColReplyType @"replyType"
#define ColMessageDirection @"messageDirection"
#define ColTime @"time"


//所有列
#define AllColumns ColTargetId,ColContent,ColMessageType,ColReplyType,ColMessageDirection,ColTime

//Run实列所有字段值
#define AllFields record.targetId,record.content,@(record.messageType),@(record.replyType),@(record.messageDirection),@(record.time)

//-------------CURD------------------/
//插入语句
#define InsertRecordSql KKStringWithFormat(@"INSERT INTO %@(%@, %@, %@, %@, %@, %@) VALUES (?, ?, ?, ?, ?, ?)", TableName, AllColumns)
//插入数值
#define InsertRecordSqlArgs @[AllFields]

//更新语句
#define UpdateRecordSql KKStringWithFormat(@"UPDATE %@ SET %@=?, %@=?,%@=?,%@=?,%@=?,%@=? WHERE %@=?",TableName, AllColumns,ColID)
//更新数值
#define UpdateRecordSqlArgs @[AllFields,@(record.messageId)]


@implementation ONSMessageDao

static dispatch_once_t _once;
static ONSMessageDao *instance;

+(instancetype)sharedMessageDao
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
    return KKStringWithFormat(@"CREATE TABLE %@ (%@ INTEGER PRIMARY KEY AUTOINCREMENT, %@ char(100),%@ TEXT,%@ INTEGER,%@ INTEGER,%@ INTEGER,%@ INTEGER)", TableName, ColID, AllColumns);
}


//序列化实体
-(ONSMessage *)serializeWithRS:(FMResultSet*)rs
{
    ONSMessage *record = [[ONSMessage alloc] init];
    record.messageId = [rs longLongIntForColumn:ColID];
    record.targetId=[rs stringForColumn:ColTargetId];
    record.content=[rs stringForColumn:ColContent];
    record.messageType=[rs intForColumn:ColMessageType];
    record.replyType=[rs intForColumn:ColReplyType];
    record.messageDirection=[rs intForColumn:ColMessageDirection];
    record.time=[rs longLongIntForColumn:ColTime];
    
    return record;
}

//-----------------CRUD----------------------------/

-(void)addMessage:(ONSMessage *)record completion:(KKDaoUpdateCompletion)completion inBackground:(BOOL)inbackground
{
    record.time=[[NSDate date] timeIntervalSince1970];
    
    [self update:^BOOL(FMDatabase *db) {
        BOOL succeed = [db executeUpdate:InsertRecordSql withArgumentsInArray:InsertRecordSqlArgs];
        if(succeed) record.messageId = db.lastInsertRowId;
        return succeed;
    } completion:completion inBackground:inbackground];
}

//修改记录
-(void)updateMessage:(ONSMessage *)record completion:(KKDaoUpdateCompletion)completion inBackground:(BOOL)inbackground
{
    record.time=[[NSDate date] timeIntervalSince1970];
    
    [self update:^BOOL(FMDatabase *db) {
        return [db executeUpdate:UpdateRecordSql withArgumentsInArray:UpdateRecordSqlArgs];
    } completion:completion inBackground:inbackground];
}

//读取
-(void)getMessageByMessageId:(long long)messageId completion:(KKDaoQueryCompletion)completion inBackground:(BOOL)inbackground
{
    [self query:^id(FMDatabase *db) {
        NSString *sql = KKStringWithFormat(@"SELECT * FROM %@ WHERE %@=?", TableName, ColID);
        FMResultSet *rs = [db executeQuery:sql withArgumentsInArray:@[@(messageId)]];
        if (!rs.next) {
            return nil;
        }
        
        //序列化实体
        ONSMessage *record=[self serializeWithRS:rs];
        
        [rs close];
        
        return record;
    } completion:completion inBackground:inbackground];
}

//读取记录列表
-(void)getMessageListByTargetId:(NSString*)targetId Completion:(KKDaoQueryCompletion)completion inBackground:(BOOL)inbackground
{
    [self query:^id(FMDatabase *db) {
        NSString *sql = KKStringWithFormat(@"SELECT * FROM %@ WHERE %@=? ORDER BY time DESC", TableName,ColTargetId);
        FMResultSet *rs = [db executeQuery:sql withArgumentsInArray:@[targetId]];
        
        NSMutableArray *arr = [NSMutableArray array];
        
        while (rs.next) {
            
            //序列化实体
            ONSMessage *record=[self serializeWithRS:rs];
            
            [arr addObject:record];
        }
        
        [rs close];
        
        if(arr.count==0) return nil;
        
        return arr;
        
    } completion:completion inBackground:inbackground];
}


@end
