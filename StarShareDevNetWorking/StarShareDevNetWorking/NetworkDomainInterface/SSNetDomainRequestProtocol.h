//
//  SSNetDomainRequestProtocol.h
//  StarShareDevNetWorking
//
//  Created by BUBUKO on 2017/10/27.
//  Copyright © 2017年 BUBUKO. All rights reserved.
//

#import "SSNetWorkConstants.h"
#import "SSNetRequestData.h"
#import "SSNetRequestCachePolocyProtocol.h"
#import "SSNetDomainRequestHelperProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SSNetDomainRequestProtocol <SSNetDomainRequestHelperProtocol>

@required

/**
 请求地址链接 default -> [SSNetworkConfig sharedConfig].baseUrl

 @return baseUrl
 */
- (nonnull NSString *)baseUrl;

/**
 请求接口地址 default -> nil

 @return requestUrl
 */
- (nullable NSString *)requestUrl;

/**
 安全策略 default -> nil

 @return securityPolicy
 */
- (nullable id)securityPolicy;

/**
 请求方式 default -> SSNetRequestMethodGet

 @return SSNetRequestMethod
 */
- (SSNetRequestMethod)requestMethod;

/**
 请求数据序列化方式 default -> SSNetRequestSerializerHTTP

 @return SSNetRequestSerializer
 */
- (SSNetRequestSerializer)requestSerializerType;

/**
 响应数据序列化方式 default -> SSNetResponseSerializerJSON

 @return SSNetResponseSerializer
 */
- (SSNetResponseSerializer)responseSerializerType;

/**
 请求优先级 default -> SSNetRequestPriorityNormall

 @return SSNetRequestPriority
 */
- (SSNetRequestPriority)requestPriority;

/**
 服务器认证信息 default ->  nil & @[@"admin",@"1234"]

 @return requestAuthorizationHeaderFieldArray
 */
- (nullable NSArray<NSString *> *)requestAuthorizationHeaderFieldArray;

/**
 请求头 default -> nil

 @return requestHeaderFieldValueDictionary
 */
- (nullable NSDictionary<NSString *, NSString *> *)requestHeaderFieldValueDictionary;
- (nullable NSDictionary<NSString *, NSString *> *)publicHeaders;

/**
 请求参数 default -> nil

 @return requestArgument
 */
- (nullable id)requestArgument;
- (nullable id)publicArgument;

/**
 缓存文件名字过滤  default -> requestArgument

 @param argument requestArgument
 @return cacheFileName
 */
- (nullable id)cacheFileNameFilterForRequestArgument:(id)argument;

/**
 请求发送数据 default -> nil

 @return requestData
 */
- (nullable SSNetRequestData*)requestData;

/**
 超时时间 default -> [SSNetworkConfig sharedConfig].timeoutInterval

 @return timeoutInterval
 */
- (NSTimeInterval)timeoutInterval;

/**
 是否允许蜂窝数据访问 default -> [SSNetworkConfig sharedConfig].allowsCellularAccess

 @return allowsCellularAccess
 */
- (BOOL)allowsCellularAccess;

/**
 缓存操作对象  default -> SSNetRequestCachePolocy

 @return cachePolocy
 */
- (id<SSNetRequestCachePolocyProtocol>)cachePolocy;

/**
 请求策略(只读取缓存数据还是读取缓存同时更新缓存)  default -> SSNetRequestReadCacheWithUpdate

 @param requestBean requestBean
 @return SSNetRequestPolicy
 */
- (SSNetRequestPolicy)requestPolicyWithRequestBean:(nonnull in SSNetDomainBeanRequest *)requestBean;
@end

NS_ASSUME_NONNULL_END
