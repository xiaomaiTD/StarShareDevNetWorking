//
//  SSNetDomainBeanRequest.m
//  StarShareDevNetWorking
//
//  Created by BUBUKO on 2017/10/27.
//  Copyright © 2017年 BUBUKO. All rights reserved.
//

#import "SSNetDomainBeanRequest.h"
#import "SSNetWorkCachePolocy.h"
#import "SSNetworkConfig.h"
#import "SSNetWorkConstants.h"
#import "StarShareNetEngine.h"

@implementation SSNetDomainBeanRequest

#pragma mark - <SSNetDomainRequestProtocol>

- (nonnull NSString *)baseUrl
{
  return NONNIL_STRING([StarShareNetEngine sharedInstance].engineConfigation.baseUrl);
}

- (nullable NSString *)requestUrl
{
  return nil;
}

- (nullable id)securityPolicy
{
  return [StarShareNetEngine sharedInstance].engineConfigation.securityPolicy;
}

- (SSNetRequestMethod)requestMethod
{
  return SSNetRequestMethodGET;
}

- (SSNetRequestSerializer)requestSerializerType
{
  return SSNetRequestSerializerHTTP;
}

- (SSNetResponseSerializer)responseSerializerType
{
  return SSNetResponseSerializerJSON;
}

- (SSNetRequestPriority)requestPriority
{
  return SSNetRequestPriorityNormal;
}

- (nullable NSArray<NSString *> *)requestAuthorizationHeaderFieldArray
{
  return nil;
}

- (nullable NSDictionary<NSString *, NSString *> *)requestHeaderFieldValueDictionary
{
  return nil;
}

- (nullable NSDictionary<NSString *, NSString *> *)publicHeaders
{
  return [StarShareNetEngine sharedInstance].engineConfigation.publicHeaders;
}

- (nullable id)requestArgument
{
  return nil;
}

- (nullable id)publicArgument
{
  return [StarShareNetEngine sharedInstance].engineConfigation.publicArgument;
}

- (nullable SSNetRequestData*)requestData
{
  return nil;
}

- (NSTimeInterval)timeoutInterval
{
  return [StarShareNetEngine sharedInstance].engineConfigation.timeoutInterval;
}

- (BOOL)allowsCellularAccess
{
  return [StarShareNetEngine sharedInstance].engineConfigation.allowsCellularAccess;
}

- (id<SSNetRequestCachePolocyProtocol>)cachePolocy
{
  return [[SSNetWorkCachePolocy alloc] init];
}

#pragma mark - <SSNetDomainRequestHelperProtocol>

- (BOOL)statusCodeValidator:(NSURLResponse *)response
{
  if (response == nil) {
    return NO;
  }
  NSInteger statusCode = ((NSHTTPURLResponse *)response).statusCode;
  return (statusCode >= 200 && statusCode <= 299);
}

- (nullable NSString*)requestUrlMosaicWithRequestBean:(in SSNetDomainBeanRequest *)requestBean error:(out NSError * _Nullable __autoreleasing *)error
{
  id <SSNetDomainRequestProtocol> bean = requestBean;
  
  NSString *requestUrl = [bean requestUrl];
  if (requestUrl == nil) {
    requestUrl = @"";
  }
  NSURL *temp = [NSURL URLWithString:requestUrl];
  if (temp && temp.host && temp.scheme) {
    return requestUrl;
  }
  
  NSString *baseUrl = [bean baseUrl];
  if (baseUrl == nil || baseUrl.length == 0) {
    if (error) {
      *error = [NSError errorWithDomain:SSNetWorkEngineErrorDomain
                                   code:SSNetWorkEngineErrorRequestUrlInvalid
                               userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"网络请求：%@ 地址不能为空！",requestBean]}];
    }
    return nil;
  }
  
  NSURL *url = [NSURL URLWithString:baseUrl];
  if (baseUrl.length > 0 && ![baseUrl hasSuffix:@"/"]) {
    url = [url URLByAppendingPathComponent:@""];
  }
  
  return [NSURL URLWithString:requestUrl relativeToURL:url].absoluteString;
}

- (nonnull id)requestArgumentMosaicWithRequestBean:(in SSNetDomainBeanRequest *)requestBean error:(out NSError * _Nullable __autoreleasing *)error
{
  id <SSNetDomainRequestProtocol> bean = requestBean;
  
  NSDictionary *publicArgument = [bean publicArgument];
  NSDictionary *requestArgument = [bean requestArgument];
  
  if ((publicArgument != nil && ![publicArgument isKindOfClass:[NSDictionary class]]) ||
      (requestArgument != nil && ![requestArgument isKindOfClass:[NSDictionary class]])) {
    if (error) {
      *error = [NSError errorWithDomain:SSNetWorkEngineErrorDomain
                                   code:SSNetWorkEngineErrorRequestArgumentInvalid
                               userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"网络请求：%@ 请求参数类型错误（不是字典）！",requestBean]}];
    }
  }
  
  NSMutableDictionary *fullArgument = [NSMutableDictionary dictionaryWithCapacity:50];
  if(publicArgument != nil)[fullArgument addEntriesFromDictionary:publicArgument];
  if(requestArgument != nil)[fullArgument addEntriesFromDictionary:requestArgument];
  
  return [fullArgument copy];
}

- (nonnull id)requestArgumentMapWithArguments:(in id)arguments error:(out NSError * _Nullable __autoreleasing *)error
{
  return NONNIL_DIC(arguments);
}

@end
