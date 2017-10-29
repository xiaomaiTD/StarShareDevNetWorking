//
//  SSYYNetWorkCacheEngine.m
//  StarShareDevNetWorking
//
//  Created by BUBUKO on 2017/10/29.
//  Copyright © 2017年 BUBUKO. All rights reserved.
//

#import "SSYYNetWorkCacheEngine.h"
#import "SSNetRequestCachePolocyProtocol.h"
#import "SSNetDomainRequestProtocol.h"
#import "SSNetDomainResponseProtocol.h"
#import "SSNetWorkCacheHandle.h"
#import "SSNetWorkConstants.h"
#import "SSNetworkUtils.h"
#import "SSNetworkConfig.h"
#import "SSNetDomainBeanParent.h"
#import "SSNetDataCacheMeta.h"
#import "SSYYNetWorkCacheHandle.h"

@implementation SSYYNetWorkCacheEngine

- (id<SSNetWorkCacheHandleProtocol>)writeCacheWithPolocy:(in id<SSNetRequestCachePolocyProtocol>)polocy
                                             requestBean:(in id<SSNetDomainRequestProtocol>)requestBean
                                            responseBean:(in id<SSNetDomainResponseProtocol>)responseBean
                                                   error:(out NSError **)error
{
  do {
    
    ///< 是否支持缓存
    BOOL cacheEnable = NO;
    SS_SAFE_SEND_MESSAGE(polocy, needCache){
      cacheEnable = [polocy needCache];
    }
    if(!cacheEnable){
      if (error) {
        *error = [NSError errorWithDomain:SSNetWorkCacheErrorDomain
                                     code:SSNetWorkCacheErrorInvalidCacheEnable
                                 userInfo:@{ NSLocalizedDescriptionKey:[NSString stringWithFormat:@"网络缓存：%@ 不支持缓存！",requestBean]}];
      }
      break;
    }
    
    ///< 缓存时间是否有效
    NSTimeInterval cacheTime = -1;
    SS_SAFE_SEND_MESSAGE(polocy, cacheTimeInSeconds){
      cacheTime = [polocy cacheTimeInSeconds];
    }
    
    ///< 缓存类型
    SSNetRequestCachePolicy cachePolicy = SSNetRequestCachePolicyMemory;
    SS_SAFE_SEND_MESSAGE(polocy, cachePolicy){
      cachePolicy = [polocy cachePolicy];
    }
    
    ///< 缓存类型是否有效
    if (cachePolicy != SSNetRequestCachePolicyMemory && cachePolicy != SSNetRequestCachePolicyDisk){
      if (error) {
        *error = [NSError errorWithDomain:SSNetWorkCacheErrorDomain
                                     code:SSNetWorkCacheErrorInvalidCachePolicy
                                 userInfo:@{ NSLocalizedDescriptionKey:[NSString stringWithFormat:@"网络缓存：%@ 策略无效！",requestBean]}];
      }
      break;
    }
    
    NSString *const cacheName = [self cacheName:requestBean];
    NSString *const cacheMetaName = [self cacheMetaName:requestBean];
    YYCache *cache = [YYCache cacheWithName:[self cachePath]];
    
    if (cacheTime > 0) {
      
      SSNetDomainBeanParent<SSNetDomainRequestProtocol>* domainBeanRequest = requestBean;
      SSNetDomainBeanParent<SSNetDomainResponseProtocol>* domainBeanResponse = responseBean;
      
      ///< 是否有有效数据
      if (domainBeanRequest.responseObject == nil || domainBeanResponse.responseObject == nil) {
        if (error) {
          *error = [NSError errorWithDomain:SSNetWorkCacheErrorDomain
                                       code:SSNetWorkCacheErrorInvalidCacheData
                                   userInfo:@{ NSLocalizedDescriptionKey:[NSString stringWithFormat:@"网络缓存：%@ 数据无效！",requestBean]}];
        }
        break;
      }
      
      SSNetDataCacheMeta *metadata = [[SSNetDataCacheMeta alloc] init];
      metadata.version = [polocy cacheVersion];
      metadata.sensitiveDataString = ((NSObject *)[polocy cacheSensitiveData]).description;
      metadata.creationDate = [NSDate date];
      metadata.appVersionString = [SSNetworkUtils appVersionString];
      
      if (cachePolicy == SSNetRequestCachePolicyMemory) {
        [cache.memoryCache setObject:domainBeanResponse.responseObject forKey:cacheName];
        [cache.memoryCache setObject:metadata forKey:cacheMetaName];
      }else{
        [cache setObject:domainBeanResponse.responseObject forKey:cacheName];
        [cache setObject:metadata forKey:cacheMetaName];
      }
      
      SSYYNetWorkCacheHandle *handle = [[SSYYNetWorkCacheHandle alloc] initWithCache:cache key:cacheName];
      
      return handle;
      
    }else{
      if (error) {
        *error = [NSError errorWithDomain:SSNetWorkCacheErrorDomain
                                     code:SSNetWorkCacheErrorInvalidCacheTime
                                 userInfo:@{ NSLocalizedDescriptionKey:[NSString stringWithFormat:@"网络缓存：%@ 时间过期！",requestBean]}];
      }
      [cache removeObjectForKey:cacheName];
      [cache removeObjectForKey:cacheMetaName];
      break;
    }
    
  } while (NO);
  
  return SSNetWorkCacheHandleNilObject.alloc.init;
}

- (id<SSNetWorkCacheHandleProtocol>)readCacheWithPolocy:(in id<SSNetRequestCachePolocyProtocol>)polocy
                                            requestBean:(in id<SSNetDomainRequestProtocol>)requestBean
                                           responseBean:(in id<SSNetDomainResponseProtocol>)responseBean
                                                  error:(out NSError **)error
{
  do {
    
    ///< 是否支持缓存
    BOOL cacheEnable = NO;
    SS_SAFE_SEND_MESSAGE(polocy, needCache){
      cacheEnable = [polocy needCache];
    }
    if(!cacheEnable){
      if (error) {
        *error = [NSError errorWithDomain:SSNetWorkCacheErrorDomain
                                     code:SSNetWorkCacheErrorInvalidCacheEnable
                                 userInfo:@{ NSLocalizedDescriptionKey:[NSString stringWithFormat:@"网络缓存：%@ 不支持缓存！",requestBean]}];
      }
      break;
    }
    
    ///< 缓存时间是否有效
    NSTimeInterval cacheTime = -1;
    SS_SAFE_SEND_MESSAGE(polocy, cacheTimeInSeconds){
      cacheTime = [polocy cacheTimeInSeconds];
    }
    
    ///< 缓存类型
    SSNetRequestCachePolicy cachePolicy = SSNetRequestCachePolicyMemory;
    SS_SAFE_SEND_MESSAGE(polocy, cachePolicy){
      cachePolicy = [polocy cachePolicy];
    }
    
    ///< 缓存类型是否有效
    if (cachePolicy != SSNetRequestCachePolicyMemory && cachePolicy != SSNetRequestCachePolicyDisk){
      if (error) {
        *error = [NSError errorWithDomain:SSNetWorkCacheErrorDomain
                                     code:SSNetWorkCacheErrorInvalidCachePolicy
                                 userInfo:@{ NSLocalizedDescriptionKey:[NSString stringWithFormat:@"网络缓存：%@ 策略无效！",requestBean]}];
      }
      break;
    }
    
    NSString *const cacheName = [self cacheName:requestBean];
    NSString *const cacheMetaName = [self cacheMetaName:requestBean];
    YYCache *cache = [YYCache cacheWithName:[self cachePath]];
    
    if (cacheTime > 0) {
      
      SSNetDomainBeanParent<SSNetDomainRequestProtocol>* domainBeanRequest = requestBean;
      SSNetDomainBeanParent<SSNetDomainResponseProtocol>* domainBeanResponse = responseBean;
      
      ///< 是否有有效数据
      if (domainBeanRequest == nil || domainBeanResponse == nil) {
        if (error) {
          *error = [NSError errorWithDomain:SSNetWorkCacheErrorDomain
                                       code:SSNetWorkCacheErrorInvalidCacheData
                                   userInfo:@{ NSLocalizedDescriptionKey:[NSString stringWithFormat:@"网络缓存：%@ 数据无效！",requestBean]}];
        }
        break;
      }
      
      SSNetDataCacheMeta *metadata;
      
      if (cachePolicy == SSNetRequestCachePolicyMemory) {
        metadata = (SSNetDataCacheMeta *)[cache.memoryCache objectForKey:cacheMetaName];
      }else{
        metadata = (SSNetDataCacheMeta *)[cache objectForKey:cacheMetaName];
      }
      
      ///< 缓存元数据是否有效
      if (metadata == nil) {
        if (error) {
          *error = [NSError errorWithDomain:SSNetWorkCacheErrorDomain
                                       code:SSNetWorkCacheErrorInvalidMetadata
                                   userInfo:@{ NSLocalizedDescriptionKey:[NSString stringWithFormat:@"网络缓存：%@ 元数据获取失败！",requestBean]}];
        }
        break;
      }
      
      ///< 缓存版本
      long long cacheVersionFileContent = metadata.version;
      if (cacheVersionFileContent != [polocy cacheVersion]) {
        if (error) {
          *error = [NSError errorWithDomain:SSNetWorkCacheErrorDomain
                                       code:SSNetWorkCacheErrorVersionMismatch
                                   userInfo:@{ NSLocalizedDescriptionKey:[NSString stringWithFormat:@"网络缓存：%@ 版本不一致！",requestBean]}];
        }
        break;
      }
      
      ///< 验证数据
      NSString *sensitiveDataString = metadata.sensitiveDataString;
      NSString *currentSensitiveDataString = ((NSObject *)[polocy cacheSensitiveData]).description;
      if (sensitiveDataString || currentSensitiveDataString) {
        if (sensitiveDataString.length != currentSensitiveDataString.length || ![sensitiveDataString isEqualToString:currentSensitiveDataString]) {
          if (error) {
            *error = [NSError errorWithDomain:SSNetWorkCacheErrorDomain
                                         code:SSNetWorkCacheErrorSensitiveDataMismatch
                                     userInfo:@{ NSLocalizedDescriptionKey:[NSString stringWithFormat:@"网络缓存：%@ 验证码错误！",requestBean]}];
          }
          break;
        }
      }
      
      ///< App 版本
      NSString *appVersionString = metadata.appVersionString;
      NSString *currentAppVersionString = [SSNetworkUtils appVersionString];
      if (appVersionString || currentAppVersionString) {
        if (appVersionString.length != currentAppVersionString.length || ![appVersionString isEqualToString:currentAppVersionString]) {
          if (error) {
            *error = [NSError errorWithDomain:SSNetWorkCacheErrorDomain
                                         code:SSNetWorkCacheErrorAppVersionMismatch
                                     userInfo:@{ NSLocalizedDescriptionKey:[NSString stringWithFormat:@"网络缓存：%@ 软件版本不一致！",requestBean]}];
          }
          break;
        }
      }
      
      id cacheObject = nil;
      if (cachePolicy == SSNetRequestCachePolicyMemory) {
        cacheObject = [cache.memoryCache objectForKey:cacheName];
      }else{
        cacheObject = [cache objectForKey:cacheName];
      }
      
      if (cacheObject == nil) {
        if (error) {
          *error = [NSError errorWithDomain:SSNetWorkCacheErrorDomain
                                       code:SSNetWorkCacheErrorInvalidCacheData
                                   userInfo:@{ NSLocalizedDescriptionKey:[NSString stringWithFormat:@"网络缓存：%@ 数据无效！",requestBean]}];
        }
        break;
      }
      
      domainBeanRequest.responseObject = cacheObject;
      domainBeanResponse.responseObject = cacheObject;
      
      SSYYNetWorkCacheHandle *handle = [[SSYYNetWorkCacheHandle alloc] initWithCache:cache key:cacheName];
      
      return handle;
      
    }else{
      if (error) {
        *error = [NSError errorWithDomain:SSNetWorkCacheErrorDomain
                                     code:SSNetWorkCacheErrorInvalidCacheTime
                                 userInfo:@{ NSLocalizedDescriptionKey:[NSString stringWithFormat:@"网络缓存：%@ 时间过期！",requestBean]}];
      }
      break;
    }
    
  } while (NO);
  
  return SSNetWorkCacheHandleNilObject.alloc.init;
}

- (id<SSNetWorkCacheHandleProtocol>)clearCacheWithPolocy:(in id<SSNetRequestCachePolocyProtocol>)polocy
                                             requestBean:(in id<SSNetDomainRequestProtocol>)requestBean
                                            responseBean:(in id<SSNetDomainResponseProtocol>)responseBean
                                                   error:(out NSError **)error
{
  
  NSString *const cachePath = [self cachePath];
  NSString *const cacheName = [self cacheName:requestBean];
  NSString *const cacheMetaName = [self cacheMetaName:requestBean];
  YYCache *cache = [YYCache cacheWithName:cachePath];
  
  [cache removeObjectForKey:cacheName];
  [cache removeObjectForKey:cacheMetaName];
  
  SSYYNetWorkCacheHandle *handle = [[SSYYNetWorkCacheHandle alloc] initWithCache:cache key:cacheName];
  
  return handle;
}

#pragma marbk - cache name

- (NSString *)cacheName:(in id<SSNetDomainRequestProtocol>)requestBean {
  NSString *requestUrlString;
  SS_SAFE_SEND_MESSAGE(requestBean, requestUrlMosaic:error:){
    requestUrlString = [requestBean requestUrlMosaic:requestBean error:NULL];
  }
  id requestArgument;
  SS_SAFE_SEND_MESSAGE(requestBean, requestArgumentMosaic:error:){
    requestArgument = [requestBean requestArgumentMosaic:requestBean error:NULL];
  }
  if (requestArgument != nil) {
    SS_SAFE_SEND_MESSAGE(requestBean, requestArgumentFilter:error:){
      requestArgument = [requestBean requestArgumentFilter:requestArgument error:NULL];
    }
  }
  
  NSString *requestInfo = [NSString stringWithFormat:@"Method:%ld RequestUrl:%@ Argument:%@",
                           (long)[requestBean requestMethod], requestUrlString, requestArgument];
  NSString *cacheFileName = [SSNetworkUtils md5StringFromString:requestInfo];
  return cacheFileName;
}

- (NSString *)cacheMetaName:(in id<SSNetDomainRequestProtocol>)requestBean {
  NSString *cacheFileName = [self cacheName:requestBean];
  return [cacheFileName stringByAppendingString:@"metadata"];
}

#pragma mark - cache path

- (NSString *)cachePath {
  if ([SSNetworkConfig sharedConfig].cachePath == nil || [SSNetworkConfig sharedConfig].cachePath.length == 0) {
    [SSNetworkConfig sharedConfig].cachePath = @"StarShareRequestCache";
  }
  return [SSNetworkUtils md5StringFromString:[SSNetworkConfig sharedConfig].cachePath];
}

@end
