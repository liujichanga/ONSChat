//
//  FSNetWorking.m
//  FSAFNetWorking
//
//  Created by liujichang on 2016/10/9.
//  Copyright © 2016年 liujichang. All rights reserved.
//

#import "FSNetWorking.h"

@implementation FSNetWorking

static dispatch_once_t once;
static FSNetWorking *instance;

+ (nullable instancetype)sharedManager {
    
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
        
    });
    
    return instance;
}

+ (void)releaseSingleton {
    
    once = 0;
    instance = nil;
    
}

-(void)dealloc
{
    KKLog(@"FSNetWork dealloc");
    KKNotificationCenterRemoveObserverOfSelf;
}

-(nullable instancetype)init
{
    if(self=[super init])
    {
        NSLog(@"FSNetWorking init");
        
        _sessionManager=[AFHTTPSessionManager manager];
        _sessionManager.requestSerializer.timeoutInterval=30;//超时改为30秒
        //_sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];//不直接序列化为json
        //_sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", nil];

        
        // 完全信任服务端证书模式
        //AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        
        // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
        //securityPolicy.allowInvalidCertificates = NO;
        
        //validatesDomainName 是否需要验证域名，默认为YES；
        //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
        //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
        //如置为NO，建议自己添加对应域名的校验逻辑。
        //securityPolicy.validatesDomainName = NO;
        
        //self.securityPolicy=securityPolicy;
        
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
         {
             NSLog(@"update net status");
             _currentNetWorkReachabilityStatus=status;
             switch (status)
             {
                 case AFNetworkReachabilityStatusUnknown:
                 case AFNetworkReachabilityStatusNotReachable:
                 {
                     [KKNotificationCenter postNotificationName:FSNetWorkingManagerNotification_NetWorkStatusChanged object:nil];
                 }
                     break;
                 case AFNetworkReachabilityStatusReachableViaWWAN:
                 {
                     [KKNotificationCenter postNotificationName:FSNetWorkingManagerNotification_NetWorkStatusChanged object:nil];
                 }
                     break;
                 case AFNetworkReachabilityStatusReachableViaWiFi:
                 {
                     [KKNotificationCenter postNotificationName:FSNetWorkingManagerNotification_NetWorkStatusChanged object:nil];
                 }
                     break;
                     
                 default:
                     break;
             }             
         }];
    }
    
    return self;
}



-(NSURLSessionDataTask *)GET:(NSString *)URLString parameters:(id)parameters progress:(void (^)(NSProgress *))downloadProgress success:(void (^)(NSURLSessionDataTask *, id _Nullable))success failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError *))failure
{
    return [_sessionManager GET:URLString parameters:parameters progress:downloadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //    NSData *data=(NSData*)responseObject;
        //    NSString *str=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //    NSLog(@"str:%@",str);
        success(task,responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError *error) {
        
        NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithDictionary:error.userInfo];
        [dic setObject:@"网络异常" forKey:@"KKHttpError"];
        NSError *customError=[NSError errorWithDomain:error.domain code:error.code userInfo:dic];
        NSLog(@"error:%@",customError);
        
        failure(task,customError);
    }];
}

-(NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(id)parameters progress:(void (^)(NSProgress *))uploadProgress success:(void (^)(NSURLSessionDataTask *, id _Nullable))success failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError *))failure
{
    return [_sessionManager POST:URLString parameters:parameters progress:uploadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //显示原始数据
//        NSData *data=(NSData*)responseObject;
//        NSString *str=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        NSLog(@"str:%@",str);
        success(task,responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError *error) {
      
        NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithDictionary:error.userInfo];
        [dic setObject:@"网络异常" forKey:@"KKHttpError"];
        NSError *customError=[NSError errorWithDomain:error.domain code:error.code userInfo:dic];
        NSLog(@"error:%@",customError);
        
        failure(task,customError);
    }];
}

-(NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(id)parameters constructingBodyWithBlock:(void (^)(id<AFMultipartFormData> _Nonnull))block progress:(void (^)(NSProgress * _Nonnull))uploadProgress success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure
{
    return [_sessionManager POST:URLString parameters:parameters constructingBodyWithBlock:block progress:uploadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //    NSData *data=(NSData*)responseObject;
        //    NSString *str=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //    NSLog(@"str:%@",str);
        success(task,responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithDictionary:error.userInfo];
        [dic setObject:@"网络异常" forKey:@"KKHttpError"];
        NSError *customError=[NSError errorWithDomain:error.domain code:error.code userInfo:dic];
        NSLog(@"error:%@",customError);
        
        failure(task,customError);

    }];
}

- (void)downloadFileURL:(NSString *)aUrl savePath:(NSString *)aSavePath tag:(NSInteger)aTag success:(void (^)(NSInteger))success failure:(void (^)(NSInteger, NSError *))failure
{
    //KKLog(@"aSavePath:%@",aSavePath);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //检查附件是否存在
    if ([fileManager fileExistsAtPath:aSavePath])
    {
        if(success) success(aTag);
        //KKLog(@"downloadFileURL success: 文件存在");
    }
    else
    {
        BOOL isDir = NO;
        NSString *foldDir=[aSavePath stringByDeletingLastPathComponent];
        BOOL dirExist=[fileManager fileExistsAtPath:foldDir isDirectory:&isDir];
        if(!(dirExist&&isDir))
        {
            //文件夹不存在，创建文件夹
            NSError *error;
            BOOL bCreateDir = [fileManager createDirectoryAtPath:foldDir withIntermediateDirectories:YES attributes:nil error:&error];
            if(bCreateDir)
            {
                KKLog(@"create folder succeed");
            }
            else
            {
                KKLog(@"create folder fail");
                if(failure) failure(aTag,error);
            }
        }
        
        //下载附件
        NSString *filename=[[aSavePath lastPathComponent] stringByDeletingPathExtension];//不带扩展名的文件名
        NSString *fileext=[aSavePath pathExtension];//扩展名
        //临时存储文件名
        NSString *tempSavePath=[NSString stringWithFormat:@"%@/%@-d.%@",[aSavePath stringByDeletingLastPathComponent],filename,fileext];
        
        aUrl = [aUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        //远程地址
        NSURL *URL = [NSURL URLWithString:aUrl];
        //请求
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        //下载Task操作
        NSURLSessionDownloadTask *downloadTask = [_sessionManager downloadTaskWithRequest:request progress:nil destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            return [NSURL fileURLWithPath:tempSavePath];
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            
            if(!error)
            {
                //下载成功,改名
                [fileManager moveItemAtPath:tempSavePath toPath:aSavePath error:nil];
                
                if(success) success(aTag);
            }
            else
            {
                if(failure) failure(aTag,error);
            }
            
        }];
        
        [downloadTask resume];
    }    
}


@end
