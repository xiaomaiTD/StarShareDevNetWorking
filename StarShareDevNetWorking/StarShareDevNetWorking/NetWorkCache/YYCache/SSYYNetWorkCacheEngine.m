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
#import "StarShareNetEngine.h"

@implementation SSYYNetWorkCacheEngine

- (id<SSNetWorkCacheHandleProtocol>)writeCacheWithRequestBean:(in SSNetDomainBeanRequest *)requestBean
                                               responseObject:(in id)responseObject
                                                        error:(out NSError **)error
{
  do {
    
    ///< 缓存策略
    id<SSNetRequestCachePolocyProtocol>polocy;
    SS_SAFE_SEND_MESSAGE(requestBean, cachePolocy){
      polocy = [requestBean cachePolocy];
    }
    if (!polocy) {
      if (error) {
        *error = [NSError errorWithDomain:SSNetWorkCacheErrorDomain
                                     code:SSNetWorkCacheErrorInvalidCachePolicy
                                 userInfo:@{ NSLocalizedDescriptionKey:[NSString stringWithFormat:@"网络缓存：%@ 缺失缓存策略！",requestBean]}];
      }
      break;
    }
    
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
    
    ///< 缓存存储方式是否合法
    if (cachePolicy != SSNetRequestCacheMemory && cachePolicy != SSNetRequestCacheDisk){
      if (error) {
        *error = [NSError errorWithDomain:SSNetWorkCacheErrorDomain
                                     code:SSNetWorkCacheErrorInvalidCacheType
                                 userInfo:@{ NSLocalizedDescriptionKey:[NSString stringWithFormat:@"网络缓存：%@ 存储方式无效！",requestBean]}];
      }
      break;
    }
    
    ///< 缓存标识符
    NSString *const cacheName = [polocy cacheIdentificationWithRequestBean:requestBean];
    if (cacheName == nil) {
      if (error) {
        *error = [NSError errorWithDomain:SSNetWorkCacheErrorDomain
                                     code:SSNetWorkCacheErrorInvalidCacheKey
                                 userInfo:@{ NSLocalizedDescriptionKey:[NSString stringWithFormat:@"网络缓存：%@ 缓存标识不能为空！",requestBean]}];
      }
      break;
    }
    NSString *const cacheMetaName = [cacheName stringByAppendingString:@".Metadata"];
    
    YYCache *cache = [SSYYNetWorkCacheEngine cacheInstance];
    
    if (cacheEffectiveTime > 0) {
      
      ///< 是否有有效数据
      if (responseObject == nil) {
        if (error) {
          *error = [NSError errorWithDomain:SSNetWorkCacheErrorDomain
                                       code:SSNetWorkCacheErrorInvalidCacheData
                                   userInfo:@{ NSLocalizedDescriptionKey:[NSString stringWithFormat:@"网络缓存：%@ 数据无效！",requestBean]}];
        }
        break;
      }
      
      SSNetDataCacheMeta *metadata = [[SSNetDataCacheMeta alloc] init];
      metadata.version = [polocy cacheVersion];
      metadata.creationDate = [NSDate date];
      metadata.appVersionString = [SSNetworkUtils appVersionString];
      
      ///< 是否外部拦截缓存事件
      BOOL shouldHoldCacheEvent = NO;
      SS_SAFE_SEND_MESSAGE(polocy, holdCacheWithRequestBean:){
        shouldHoldCacheEvent = [polocy holdCacheWithRequestBean:requestBean];
      }
      
      if (shouldHoldCacheEvent) {
        SSNetWorkLog(@"StarShareDevNetWorking -> cacheEvent hold, not should write cache!");
        break;
      }else{
        if (cachePolicy == SSNetRequestCacheMemory) {
          [cache.memoryCache setObject:responseObject forKey:cacheName];
          [cache.memoryCache setObject:metadata forKey:cacheMetaName];
        }else{
          [cache setObject:responseObject forKey:cacheName];
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

- (id<SSNetWorkCacheHandleProtocol>)readCacheWithRequestBean:(in SSNetDomainBeanRequest *)requestBean
                                                       error:(out NSError **)error
{
  do {
    
    ///< 缓存策略
    id<SSNetRequestCachePolocyProtocol>polocy;
    SS_SAFE_SEND_MESSAGE(requestBean, cachePolocy){
      polocy = [requestBean cachePolocy];
    }
    if (!polocy) {
      if (error) {
        *error = [NSError errorWithDomain:SSNetWorkCacheErrorDomain
                                     code:SSNetWorkCacheErrorInvalidCachePolicy
                                 userInfo:@{ NSLocalizedDescriptionKey:[NSString stringWithFormat:@"网络缓存：%@ 缺失缓存策略！",requestBean]}];
      }
      break;
    }
    
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
                                     code:SSNetWorkCacheErrorInvalidCacheType
                                 userInfo:@{ NSLocalizedDescriptionKey:[NSString stringWithFormat:@"网络缓存：%@ 存储方式无效！",requestBean]}];
      }
      break;
    }
    
    ///< 缓存标识符
    NSString *const cacheName = [polocy cacheIdentificationWithRequestBean:requestBean];
    if (cacheName == nil) {
      if (error) {
        *error = [NSError errorWithDomain:SSNetWorkCacheErrorDomain
                                     code:SSNetWorkCacheErrorInvalidCacheKey
                                 userInfo:@{ NSLocalizedDescriptionKey:[NSString stringWithFormat:@"网络缓存：%@ 缓存标识不能为空！",requestBean]}];
      }
      break;
    }
    NSString *const cacheMetaName = [cacheName stringByAppendingString:@".Metadata"];
    YYCache *cache = [SSYYNetWorkCacheEngine cacheInstance];
    
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
      
      ///< 缓存是否过期
      NSDate *creationDate = metadata.creationDate;
      NSTimeInterval duration = -[creationDate timeIntervalSinceNow];
      if (duration < 0 || duration > cacheEffectiveTime) {
        if (error) {
          *error = [NSError errorWithDomain:SSNetWorkCacheErrorDomain
                                       code:SSNetWorkCacheErrorInvalidCacheTime
                                   userInfo:@{ NSLocalizedDescriptionKey:[NSString stringWithFormat:@"网络缓存：%@ 时间过期！",requestBean]}];
        }
        break;
      }
      
      ///< 缓存版本
      NSString *const cacheVersionFileContent = metadata.version;
      if (![cacheVersionFileContent isEqualToString:[polocy cacheVersion]]) {
        if (error) {
          *error = [NSError errorWithDomain:SSNetWorkCacheErrorDomain
                                       code:SSNetWorkCacheErrorVersionMismatch
                                   userInfo:@{ NSLocalizedDescriptionKey:[NSString stringWithFormat:@"网络缓存：%@ 版本不一致！",requestBean]}];
        }
        break;
      }
      
      id cacheObject = nil;
      
      ///< 是否外部拦截缓存事件
      BOOL shouldHoldCacheEvent = NO;
      SS_SAFE_SEND_MESSAGE(polocy, holdCacheWithRequestBean:){
        shouldHoldCacheEvent = [polocy holdCacheWithRequestBean:requestBean];
      }
      
      if(shouldHoldCacheEvent){
        SSNetWorkLog(@"StarShareDevNetWorking -> cacheEvent hold, not should read cache!");
        break;
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
                                   userInfo:@{ NSLocalizedDescriptionKey:[NSString stringWithFormat:@"网络缓存：%@ 没有从缓存中取到有效数据！",requestBean]}];
        }
        break;
      }
      
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

- (id<SSNetWorkCacheHandleProtocol>)clearCacheWithRequestBean:(in SSNetDomainBeanRequest *)requestBean
                                                        error:(out NSError **)error
{
  
  ///< 缓存策略
  id<SSNetRequestCachePolocyProtocol>polocy;
  SS_SAFE_SEND_MESSAGE(requestBean, cachePolocy){
    polocy = [requestBean cachePolocy];
  }
  if (!polocy) {
    if (error) {
      *error = [NSError errorWithDomain:SSNetWorkCacheErrorDomain
                                   code:SSNetWorkCacheErrorInvalidCachePolicy
                               userInfo:@{ NSLocalizedDescriptionKey:[NSString stringWithFormat:@"网络缓存：%@ 缺失缓存策略！",requestBean]}];
    }
    return SSNetWorkCacheHandleNilObject.alloc.init;
  }
  
  ///< 缓存标识符
  NSString *const cacheName = [polocy cacheIdentificationWithRequestBean:requestBean];
  if (cacheName == nil) {
    if (error) {
      *error = [NSError errorWithDomain:SSNetWorkCacheErrorDomain
                                   code:SSNetWorkCacheErrorInvalidCacheKey
                               userInfo:@{ NSLocalizedDescriptionKey:[NSString stringWithFormat:@"网络缓存：%@ 缓存标识不能为空！",requestBean]}];
    }
    return SSNetWorkCacheHandleNilObject.alloc.init;
  }
  NSString *const cacheMetaName = [cacheName stringByAppendingString:@".Metadata"];
  
  YYCache *cache = [SSYYNetWorkCacheEngine cacheInstance];
  
  [cache removeObjectForKey:cacheName];
  [cache removeObjectForKey:cacheMetaName];
  
  SSYYNetWorkCacheHandle *handle = [[SSYYNetWorkCacheHandle alloc] initWithCache:cache key:cacheName];
  
  return handle;
}

#pragma mark - cache

+ (YYCache *)cacheInstance{
  static dispatch_once_t onceToken;
  static YYCache *instance;
  dispatch_once(&onceToken, ^{
    instance = [YYCache cacheWithName:[self cachePath]];
  });
  
  return instance;
}

#pragma mark - cache path

+ (NSString *)cachePath {
  if ([StarShareNetEngine sharedInstance].engineConfigation.cachePath == nil ||
      [StarShareNetEngine sharedInstance].engineConfigation.cachePath.length == 0) {
    [StarShareNetEngine sharedInstance].engineConfigation.cachePath = @"StarShareRequestCache";
  }
  return [SSNetworkUtils md5StringFromString:[StarShareNetEngine sharedInstance].engineConfigation.cachePath];
}

@end
