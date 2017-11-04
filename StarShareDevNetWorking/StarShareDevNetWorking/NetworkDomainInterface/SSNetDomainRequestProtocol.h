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
- (nonnull NSString *)baseUrl;
- (nullable NSString *)requestUrl;
- (nullable id)securityPolicy;
- (SSNetRequestMethod)requestMethod;
- (SSNetRequestSerializer)requestSerializerType;
- (SSNetResponseSerializer)responseSerializerType;
- (SSNetRequestPriority)requestPriority;
- (nullable NSArray<NSString *> *)requestAuthorizationHeaderFieldArray;
- (nullable NSDictionary<NSString *, NSString *> *)requestHeaderFieldValueDictionary;
- (nullable NSDictionary<NSString *, NSString *> *)publicHeaders;
- (nullable id)requestArgument;
- (nullable id)publicArgument;
- (nullable SSNetRequestData*)requestData;
- (NSTimeInterval)timeoutInterval;
- (BOOL)allowsCellularAccess;
@optional
- (id<SSNetRequestCachePolocyProtocol>)cachePolocy;
@end

NS_ASSUME_NONNULL_END
