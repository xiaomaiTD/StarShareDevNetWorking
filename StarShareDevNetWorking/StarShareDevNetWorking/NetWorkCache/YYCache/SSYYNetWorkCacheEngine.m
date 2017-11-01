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
#import "SSNetDataCacheMeta.h"
#import "SSYYNetWorkCacheHandle.h"
#import "SSNetDomainBeanRequest.h"

@implementation SSYYNetWorkCacheEngine

- (id<SSNetWorkCacheHandleProtocol>)writeCacheWithPolocy:(in id<SSNetRequestCachePolocyProtocol>)polocy
                                             requestBean:(in SSNetDomainBeanRequest *)requestBean
                                                   error:(out NSError **)error
{
  do {
    
    ///< 接口数据是否需要缓存
    BOOL cacheEnable = NO;
    SS_SAFE_SEND_MESSAGE(polocy, needCacheWithRequestBean:){
      cacheEnable = [polocy needCacheWithRequestBean:requestBean];
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
    NSInteger cacheEffectiveTime = -1;
    SS_SAFE_SEND_MESSAGE(polocy, cacheEffectiveTimeInSeconds){
      cacheEffectiveTime = [polocy cacheEffectiveTimeInSeconds];
    }
    
    ///< 缓存存储方式
    SSNetRequestCachePolicy cachePolicy = SSNetRequestCacheMemory;
    SS_SAFE_SEND_MESSAGE(polocy, cachePolicyWithRequestBean:){
      cachePolicy = [polocy cachePolicyWithRequestBean:requestBean];
    }
    
    ///< 缓存存储方式是否有效
    if (cachePolicy != SSNetRequestCacheMemory && cachePolicy != SSNetRequestCacheDisk){
      if (error) {
        *error = [NSError errorWithDomain:SSNetWorkCacheErrorDomain
                                     code:SSNetWorkCacheErrorInvalidCachePolicy
                                 userInfo:@{ NSLocalizedDescriptionKey:[NSString stringWithFormat:@"网络缓存：%@ 存储方式无效！",requestBean]}];
      }
      break;
    }
    
    NSString *const cacheName = [self cacheName:requestBean];
    NSString *const cacheMetaName = [self cacheMetaName:requestBean];
    YYCache *cache = [YYCache cacheWithName:[self cachePath]];
    
    if (cacheEffectiveTime > 0) {
      
      ///< 是否有有效数据
      if (requestBean.responseObject == nil) {
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
      
      ///< 是否外部拦截缓存事件
      BOOL shouldHoldCacheEvent = NO;
      SS_SAFE_SEND_MESSAGE(polocy, shouldHoldCacheEventWithRequestBean:){
        shouldHoldCacheEvent = [polocy shouldHoldCacheEventWithRequestBean:requestBean];
      }
      
      if (shouldHoldCacheEvent) {
        BOOL canCache = NO;
        SS_SAFE_SEND_MESSAGE(polocy, canCacheEventWithRequestBean:){
          canCache = [polocy canCacheEventWithRequestBean:requestBean];
        }
        if (canCache) {
          id cacheObjectByFilter;
          SS_SAFE_SEND_MESSAGE(polocy, cacheObjectFilter:){
            cacheObjectByFilter = [polocy cacheObjectFilter:requestBean.responseObject];
          }
          if (cacheObjectByFilter == nil) {
            if (error) {
              *error = [NSError errorWithDomain:SSNetWorkCacheErrorDomain
                                           code:SSNetWorkCacheErrorInvalidCacheData
                                       userInfo:@{ NSLocalizedDescriptionKey:[NSString stringWithFormat:@"网络缓存：%@ 数据过滤失败！",requestBean]}];
            }
            break;
          }
          
          if (cachePolicy == SSNetRequestCacheMemory) {
            [cache.memoryCache setObject:cacheObjectByFilter forKey:cacheName];
            [cache.memoryCache setObject:metadata forKey:cacheMetaName];
          }else{
            [cache setObject:cacheObjectByFilter forKey:cacheName];
            [cache setObject:metadata forKey:cacheMetaName];
          }
        }else{
          SSNetWorkLog(@"StarShareDevNetWorking -> cacheEvent hold, not should write cache!");
        }
      }else{
        if (cachePolicy == SSNetRequestCacheMemory) {
          [cache.memoryCache setObject:requestBean.responseObject forKey:cacheName];
          [cache.memoryCache setObject:metadata forKey:cacheMetaName];
        }else{
          [cache setObject:requestBean.responseObject forKey:cacheName];
          [cache setObject:metadata forKey:cacheMetaName];
        }
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
                                            requestBean:(in SSNetDomainBeanRequest *)requestBean
                                                  error:(out NSError **)error
{
  do {
    
    ///< 接口数据是否需要缓存
    BOOL cacheEnable = NO;
    SS_SAFE_SEND_MESSAGE(polocy, needCacheWithRequestBean:){
      cacheEnable = [polocy needCacheWithRequestBean:requestBean];
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
    NSInteger cacheEffectiveTime = -1;
    SS_SAFE_SEND_MESSAGE(polocy, cacheEffectiveTimeInSeconds){
      cacheEffectiveTime = [polocy cacheEffectiveTimeInSeconds];
    }
    
    ///< 缓存存储方式
    SSNetRequestCachePolicy cachePolicy = SSNetRequestCacheMemory;
    SS_SAFE_SEND_MESSAGE(polocy, cachePolicyWithRequestBean:){
      cachePolicy = [polocy cachePolicyWithRequestBean:requestBean];
    }
    
    ///< 缓存存储方式是否有效
    if (cachePolicy != SSNetRequestCacheMemory && cachePolicy != SSNetRequestCacheDisk){
      if (error) {
        *error = [NSError errorWithDomain:SSNetWorkCacheErrorDomain
                                     code:SSNetWorkCacheErrorInvalidCachePolicy
                                 userInfo:@{ NSLocalizedDescriptionKey:[NSString stringWithFormat:@"网络缓存：%@ 存储方式无效！",requestBean]}];
      }
      break;
    }
    
    NSString *const cacheName = [self cacheName:requestBean];
    NSString *const cacheMetaName = [self cacheMetaName:requestBean];
    YYCache *cache = [YYCache cacheWithName:[self cachePath]];
    
    if (cacheEffectiveTime > 0) {
      
      ///< 是否有有效数据
      if (requestBean == nil) {
        if (error) {
          *error = [NSError errorWithDomain:SSNetWorkCacheErrorDomain
                                       code:SSNetWorkCacheErrorInvalidCacheData
                                   userInfo:@{ NSLocalizedDescriptionKey:[NSString stringWithFormat:@"网络缓存：%@ 数据无效！",requestBean]}];
        }
        break;
      }
      
      SSNetDataCacheMeta *metadata;
      
      if (cachePolicy == SSNetRequestCacheMemory) {
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
      NSString *const cacheVersionFileContent = metadata.version;
      if ([cacheVersionFileContent isEqualToString:[polocy cacheVersion]]) {
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
      
      id cacheObject = nil;
      
      ///< 是否外部拦截缓存事件
      BOOL shouldHoldCacheEvent = NO;
      SS_SAFE_SEND_MESSAGE(polocy, shouldHoldCacheEventWithRequestBean:){
        shouldHoldCacheEvent = [polocy shouldHoldCacheEventWithRequestBean:requestBean];
      }
      
      if(shouldHoldCacheEvent){
        BOOL canCache = NO;
        SS_SAFE_SEND_MESSAGE(polocy, canCacheEventWithRequestBean:){
          canCache = [polocy canCacheEventWithRequestBean:requestBean];
        }
        if (canCache) {
          id cacheObjectWillFilter = nil;
          if (cachePolicy == SSNetRequestCacheMemory) {
            cacheObjectWillFilter = [cache.memoryCache objectForKey:cacheName];
          }else{
            cacheObjectWillFilter = [cache objectForKey:cacheName];
          }
          
          id cacheObjectByFilter;
          SS_SAFE_SEND_MESSAGE(polocy, cacheObjectFilter:){
            cacheObjectByFilter = [polocy cacheObjectFilter:cacheObjectWillFilter];
          }
          if (cacheObjectByFilter == nil) {
            if (error) {
              *error = [NSError errorWithDomain:SSNetWorkCacheErrorDomain
                                           code:SSNetWorkCacheErrorInvalidCacheData
                                       userInfo:@{ NSLocalizedDescriptionKey:[NSString stringWithFormat:@"网络缓存：%@ 数据过滤失败！",requestBean]}];
            }
            break;
          }
          
          cacheObject = cacheObjectByFilter;
        }else{
          SSNetWorkLog(@"StarShareDevNetWorking -> cacheEvent hold, not should read cache!");
        }
      }else{
        if (cachePolicy == SSNetRequestCacheMemory) {
          cacheObject = [cache.memoryCache objectForKey:cacheName];
        }else{
          cacheObject = [cache objectForKey:cacheName];
        }
      }
      
      if (cacheObject == nil) {
        if (error) {
          *error = [NSError errorWithDomain:SSNetWorkCacheErrorDomain
                                       code:SSNetWorkCacheErrorInvalidCacheData
                                   userInfo:@{ NSLocalizedDescriptionKey:[NSString stringWithFormat:@"网络缓存：%@ 数据无效！",requestBean]}];
        }
        break;
      }
      
      requestBean.responseObject = cacheObject;
      
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
                                             requestBean:(in SSNetDomainBeanRequest *)requestBean
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
  SS_SAFE_SEND_MESSAGE(requestBean, requestUrlMosaicWithRequestBean:error:){
    requestUrlString = [requestBean requestUrlMosaicWithRequestBean:requestBean error:NULL];
  }
  id requestArgument;
  SS_SAFE_SEND_MESSAGE(requestBean, requestArgumentMosaicWithRequestBean:error:){
    requestArgument = [requestBean requestArgumentMosaicWithRequestBean:requestBean error:NULL];
  }
  if (requestArgument != nil) {
    SS_SAFE_SEND_MESSAGE(requestBean, requestArgumentFilterWithArguments:error:){
      requestArgument = [requestBean requestArgumentFilterWithArguments:requestArgument error:NULL];
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
