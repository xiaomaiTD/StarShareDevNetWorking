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

- (id<SSNetWorkCacheHandleProtocol>)writeCacheWithPolocy:(in id<SSNetRequestCachePolocyProtocol>)polocy
                                             requestBean:(in id<SSNetDomainRequestProtocol>)requestBean
                                            responseBean:(in id<SSNetDomainResponseProtocol>)responseBean
                                                   error:(out NSError *__autoreleasing *)error
{
  return [self.yyCacheEngine writeCacheWithPolocy:polocy
                                      requestBean:requestBean
                                     responseBean:responseBean
                                            error:error];
}

- (id<SSNetWorkCacheHandleProtocol>)readCacheWithPolocy:(in id<SSNetRequestCachePolocyProtocol>)polocy
                                            requestBean:(in id<SSNetDomainRequestProtocol>)requestBean
                                           responseBean:(in id<SSNetDomainResponseProtocol>)responseBean
                                                  error:(out NSError *__autoreleasing *)error
{
  return [self.yyCacheEngine readCacheWithPolocy:polocy
                                     requestBean:requestBean
                                    responseBean:responseBean
                                           error:error];
}

- (id<SSNetWorkCacheHandleProtocol>)clearCacheWithPolocy:(in id<SSNetRequestCachePolocyProtocol>)polocy
                                             requestBean:(in id<SSNetDomainRequestProtocol>)requestBean
                                            responseBean:(in id<SSNetDomainResponseProtocol>)responseBean
                                                   error:(out NSError *__autoreleasing *)error
{
  return [self.yyCacheEngine clearCacheWithPolocy:polocy
                                      requestBean:requestBean
                                     responseBean:responseBean
                                            error:error];
}

@end
