//
//  SSNetWorkCacheEngine.m
//  StarShareDevNetWorking
//
//  Created by BUBUKO on 2017/10/27.
//  Copyright © 2017年 BUBUKO. All rights reserved.
//

#import <pthread/pthread.h>
#import "SSNetworkUtils.h"
#import "SSNetWorkCacheEngine.h"
#import "SSNetWorkConstants.h"
#import "SSNetDataCacheMeta.h"
#import "SSNetDomainBeanRequest.h"
#import "SSNetDomainBeanResponse.h"
#import "SSYYNetWorkCacheEngine.h"

@interface SSNetWorkCacheEngine ()
@property (nonatomic, strong) id<SSNetWorkCacheProtocol> yyCacheEngine;
@end

@implementation SSNetWorkCacheEngine

- (instancetype)init
{
  if (self = [super init]) {
    self.yyCacheEngine = SSYYNetWorkCacheEngine.alloc.init;
  }
  return self;
}

- (id<SSNetWorkCacheHandleProtocol>)writeCacheWithRequestBean:(in SSNetDomainBeanRequest *)requestBean
                                               responseObject:(in id)responseObject
                                                        error:(out NSError *__autoreleasing *)error
{
  return [self.yyCacheEngine writeCacheWithRequestBean:requestBean
                                        responseObject:responseObject
                                                 error:error];
}

- (id<SSNetWorkCacheHandleProtocol>)readCacheWithRequestBean:(in SSNetDomainBeanRequest *)requestBean
                                                       error:(out NSError *__autoreleasing *)error
{
  return [self.yyCacheEngine readCacheWithRequestBean:requestBean
                                                error:error];
}

- (id<SSNetWorkCacheHandleProtocol>)clearCacheWithRequestBean:(in SSNetDomainBeanRequest *)requestBean
                                                        error:(out NSError *__autoreleasing *)error {
  return [self.yyCacheEngine clearCacheWithRequestBean:requestBean
                                                 error:error];
}

- (BOOL)hasCacheWithRequestBean:(in SSNetDomainBeanRequest *)requestBean {
  return [self.yyCacheEngine hasCacheWithRequestBean:requestBean];
}
@end
