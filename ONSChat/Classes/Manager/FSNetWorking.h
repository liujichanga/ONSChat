//
//  FSNetWorking.h
//  FSAFNetWorking
//
//  Created by liujichang on 2016/10/9.
//  Copyright © 2016年 liujichang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

#define FSSharedNetWorkingManager [FSNetWorking sharedManager]


//网络变化的通知
#define FSNetWorkingManagerNotification_NetWorkStatusChanged @"FSNetWorkingManagerNotification_NetWorkStatusChanged"

@interface FSNetWorking : NSObject

+(nullable instancetype)sharedManager;
+(void)releaseSingleton;

NS_ASSUME_NONNULL_BEGIN

@property(strong,nonatomic) AFHTTPSessionManager *sessionManager;
@property(assign,nonatomic) AFNetworkReachabilityStatus currentNetWorkReachabilityStatus;

- (nullable NSURLSessionDataTask *)GET:(NSString *)URLString
                            parameters:(nullable id)parameters
                              progress:(nullable void (^)(NSProgress *downloadProgress))downloadProgress
                               success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                               failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

- (nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                             parameters:(nullable id)parameters
                               progress:(nullable void (^)(NSProgress *uploadProgress))uploadProgress
                                success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

- (nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                             parameters:(nullable id)parameters
              constructingBodyWithBlock:(nullable void (^)(id <AFMultipartFormData> formData))block
                               progress:(nullable void (^)(NSProgress *uploadProgress))uploadProgress
                                success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

//下载文件
- (void)downloadFileURL:(NSString *)aUrl savePath:(NSString *)aSavePath tag:(NSInteger)aTag success:(void (^)(NSInteger tag))success failure:(void (^)(NSInteger tag ,NSError *error))failure;




NS_ASSUME_NONNULL_END

@end
