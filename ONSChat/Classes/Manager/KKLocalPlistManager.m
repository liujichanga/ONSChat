//
//  KKLocalPlistManager.m
//  KuaiKuai
//
//  Created by liujichang on 16/3/1.
//  Copyright © 2016年 liujichang. All rights reserved.
//

#import "KKLocalPlistManager.h"

@interface KKLocalPlistManager()

//从plist读取到的dic
@property(strong,nonatomic) NSMutableDictionary *plistDataDic;

//plist路径
@property(strong,nonatomic) NSString *plistPath;

-(void)savePlist;

@end

@implementation KKLocalPlistManager


static dispatch_once_t once;
static KKLocalPlistManager *instance;

+ (instancetype)sharedLocalPlistManager {
    
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
        KKLog(@"sharedLocalPlistManager init");
    });
    
    return instance;
}

+ (void)releaseSingleton {
    
    once = 0;
    instance = nil;
    
}

-(instancetype)init
{
    self=[super init];
    if(self)
    {
        if(_plistDataDic||_plistDataDic.count>0) [_plistDataDic removeAllObjects];
        
        _plistDataDic=[NSMutableDictionary dictionary];
        
        NSLog(@"path:%@",CacheUserPath);
        BOOL dicExist=[[NSFileManager defaultManager] fileExistsAtPath:CacheUserPath isDirectory:nil];
        if(!dicExist)
        {
            //创建目录
            [[NSFileManager defaultManager] createDirectoryAtPath:CacheUserPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        NSString *plistname=KKStringWithFormat(@"kkprofile_%lld.plist",KKSharedCurrentUser.userId);
        self.plistPath=KKStringWithFormat(@"%@/%@",KKPathOfDocument,plistname);
       
        BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:self.plistPath];
        if(exist)//存在路径，初始化数据
        {
            NSDictionary *data=[NSDictionary dictionaryWithContentsOfFile:self.plistPath];
            if(data&&data.count>0) [_plistDataDic addEntriesFromDictionary:data];
        }
        
    }
    
    return self;
}

-(void)setKKValue:(id)value forKey:(NSString *)key
{
    @synchronized(self) {
      
        [_plistDataDic setValue:value forKey:key];
        
        [self savePlist];
    }
    
}

-(void)removeKKValueForKey:(NSString *)key
{
    @synchronized(self) {
       
        [_plistDataDic removeObjectForKey:key];
        
        [self savePlist];
    }
    
}

-(id)kkValueForKey:(NSString *)key
{
     return [_plistDataDic valueForKey:key];
}



-(void)savePlist
{
    [_plistDataDic writeToFile:self.plistPath atomically:YES];
}

@end
