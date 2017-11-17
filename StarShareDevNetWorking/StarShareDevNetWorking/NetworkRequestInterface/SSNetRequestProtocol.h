//
//  SSNetRequestProtocol.h
//  StarShareDevNetWorking
//
//  Created by BUBUKO on 2017/10/26.
//  Copyright © 2017年 BUBUKO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSNetRequestData.h"
#import "SSNetRequestHandleProtocol.h"

@protocol SSNetRequestProtocol <NSObject>

/**
 网络请求接口定义 -> 统一定义网络请求接口

 @param urlString 请求的完整链接
 @param securityPolicy 安全策略
 @param method 请求方式
 @param requestSerializer 请求序列化方式
 @param responseSerializer 响应数据序列化方式
 @param priority 请求优先级
 @param authorization 认证信息
 @param headers 请求头
 @param argument 请求参数
 @param data 请求数据
 @param timeout 超时时间
 @param allowsCellularAccess 是否允许蜂窝网络
 @param success 成功回调
 @param failure 失败回调
 @return 请求句柄
 */
- (id<SSNetRequestHandleProtocol>)requestWithUrlString:(in NSString *)urlString
                                        securityPolicy:(in id)securityPolicy
                                                method:(in SSNetRequestMethod)method
                                     requestSerializer:(in SSNetRequestSerializer)requestSerializer
                                    responseSerializer:(in SSNetResponseSerializer)responseSerializer
                                              priority:(in SSNetRequestPriority)priority
                                         authorization:(in NSArray *)authorization
                                               headers:(in NSDictionary *)headers
                                              argument:(in id)argument
                                                  data:(in SSNetRequestData *)data
                                               timeout:(in NSTimeInterval)timeout
                                  allowsCellularAccess:(in BOOL)allowsCellularAccess
                                               success:(in SSNetRequestSuccessedCallback)success
                                               failure:(in SSNetRequestFailedCallback)failure;

- (id<SSNetRequestHandleProtocol>)downloadWithUrlString:(in NSString *)urlString
                                         securityPolicy:(in id)securityPolicy
                                                 method:(in SSNetRequestMethod)method
                                      requestSerializer:(in SSNetRequestSerializer)requestSerializer
                                               priority:(in SSNetRequestPriority)priority
                                          authorization:(in NSArray *)authorization
                                                headers:(in NSDictionary *)headers
                                               argument:(in id)argument
                                  resumableDownloadPath:(in NSString*)resumableDownloadPath
                                                timeout:(in NSTimeInterval)timeout
                                   allowsCellularAccess:(in BOOL)allowsCellularAccess
                                               progress:(in SSNetDownloadProgressCallback)progress
                                               complete:(in SSNetDownloadCompleteCallback)complete
                                                failure:(in SSNetRequestFailedCallback)failure;

@end
