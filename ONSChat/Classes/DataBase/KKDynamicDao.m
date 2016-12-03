//
//  KKDynamicDao.m
//  ONSChat
//
//  Created by liujichang on 2016/11/30.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "KKDynamicDao.h"


//表名
#define TableName KKStringWithFormat(@"KKDynamic_%@",KKSharedCurrentUser.userId)

//所有字段
#define ColID @"dynamicsId"
#define ColCommentNum @"commentNum"
#define ColPraiseNum @"praiseNum"
#define ColType @"dynamicsType"
#define ColUrl @"dynamicUrl"
#define ColVideoThumbnail @"dynamiVideoThumbnail"
#define ColText @"dynamicText"
#define ColDate @"date"

//所有列
#define AllColumns ColCommentNum,ColPraiseNum,ColType,ColUrl,ColVideoThumbnail,ColText,ColDate

//user实列所有字段值
#define AllFields @(dynamic.commentNum),@(dynamic.praiseNum),@(dynamic.dynamicsType),dynamic.dynamicUrl,dynamic.dynamiVideoThumbnail,dynamic.dynamicText,dynamic.date

//-------------CURD------------------/
//插入语句
#define InDynamicSql KKStringWithFormat(@"INSERT INTO %@(%@, %@, %@, %@, %@, %@, %@) VALUES (?, ?, ?, ?, ?, ?, ?)", TableName, AllColumns)
//插入数值
#define InsertDynamicSqlArgs @[AllFields]

//删除语句
#define DeleteDynamicSql KKStringWithFormat(@"DELETE FROM %@ WHERE %@=?",TableName,ColID)
//删除数值
#define DeleteDynamicSqlArgs @[dynamicId]


@implementation KKDynamicDao

static dispatch_once_t _once;
static KKDynamicDao *instance;

+(instancetype)sharedDynamicDao
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
    [self checkTable:TableName createTable:^NSString *{
        return [self createTableSql];
    } updateTable:^(FMDatabase *db) {
        
    }];
}

//创建表语句
-(NSString*)createTableSql
{
    return KKStringWithFormat(@"CREATE TABLE %@ (%@ INTEGER PRIMARY KEY AUTOINCREMENT,%@ INTEGER,%@ INTEGER,%@ INTEGER,%@ char(100),%@ char(100),%@ char(100),%@ char(100))", TableName, ColID, AllColumns);
}

//序列化实体
-(KKDynamic *)serializeWithRS:(FMResultSet*)rs
{
    KKDynamic *dynamic = [[KKDynamic alloc] init];
    dynamic.userId = KKStringWithFormat(@"%lld",[rs longLongIntForColumn:ColID]);
    dynamic.commentNum = [rs intForColumn:ColCommentNum];
    dynamic.praiseNum = [rs intForColumn:ColPraiseNum];
    dynamic.dynamicsType = [rs intForColumn:ColType];

    dynamic.dynamicUrl=[rs stringForColumn:ColUrl];
    dynamic.dynamiVideoThumbnail=[rs stringForColumn:ColVideoThumbnail];
    dynamic.dynamicText=[rs stringForColumn:ColText];
    dynamic.date=[rs stringForColumn:ColDate];
    
    return dynamic;
}

//-----------------CRUD----------------------------/

-(void)addDynamic:(KKDynamic *)dynamic completion:(KKDaoUpdateCompletion)completion inBackground:(BOOL)inbackground
{
    [self update:^BOOL(FMDatabase *db) {
        BOOL succeed = [db executeUpdate:InDynamicSql withArgumentsInArray:InsertDynamicSqlArgs];
        if(succeed) dynamic.dynamicsId = KKStringWithFormat(@"%lld",db.lastInsertRowId);
        return succeed;
    } completion:completion inBackground:inbackground];
}

-(void)deleteDynamic:(NSString*)dynamicId completion:(KKDaoUpdateCompletion)completion inBackground:(BOOL)inbackground
{
    [self update:^BOOL(FMDatabase *db) {
        return [db executeUpdate:DeleteDynamicSql withArgumentsInArray:DeleteDynamicSqlArgs];
    } completion:completion inBackground:inbackground];
}

-(void)getDynamicById:(NSString*)dynamicId completion:(KKDaoQueryCompletion)completion inBackground:(BOOL)inbackground
{
    [self query:^id(FMDatabase *db) {
        NSString *sql = KKStringWithFormat(@"SELECT * FROM %@ WHERE %@=?", TableName, ColID);
        FMResultSet *rs = [db executeQuery:sql withArgumentsInArray:@[dynamicId]];
        if (!rs.next) {
            return nil;
        }
        
        //序列化实体
        KKDynamic *dynamic=[self serializeWithRS:rs];
        
        [rs close];
        
        return dynamic;
    } completion:completion inBackground:inbackground];
}

-(void)getDynamicListCompletion:(KKDaoQueryCompletion)completion inBackground:(BOOL)inbackground
{
    [self query:^id(FMDatabase *db) {
        NSString *sql = KKStringWithFormat(@"SELECT * FROM %@ ORDER BY %@ DESC",TableName,ColID);
        FMResultSet *rs = [db executeQuery:sql withArgumentsInArray:nil];
        
        NSMutableArray *arr = [NSMutableArray array];
        
        while (rs.next) {
            
            //序列化实体
            KKDynamic *record=[self serializeWithRS:rs];
            
            [arr addObject:record];
        }
        
        [rs close];
        
        if(arr.count==0) return nil;
        
        return arr;
        
    } completion:completion inBackground:inbackground];
}

@end
