//
//  SSNetWorkCachePolocy.m
//  StarShareDevNetWorking
//
//  Created by BUBUKO on 2017/10/27.
//  Copyright © 2017年 BUBUKO. All rights reserved.
//

#import "SSNetWorkCachePolocy.h"
#import "SSNetDomainRequestProtocol.h"

@implementation SSNetWorkCachePolocy

#pragma mark - <SSNetRequestCachePolocyProtocol>

- (BOOL)needCacheWithRequestBean:(nonnull in id<SSNetDomainRequestProtocol>)requestBean
{
  return NO;
}

- (SSNetRequestCachePolicy)cachePolicyWithRequestBean:(nonnull in id<SSNetDomainRequestProtocol>)requestBean
{
  return SSNetRequestCacheMemory;
}

- (NSInteger)cacheEffectiveTimeInSeconds
{
  return NSIntegerMax;
}

- (NSString * _Nonnull)cacheVersion
{
  return @"0.0.1";
}

- (nullable id)cacheSensitiveData
{
  return nil;
}

- (BOOL)writeCacheAsynchronously
{
  return YES;
}

- (BOOL)shouldHoldCacheEventWithRequestBean:(in SSNetDomainBeanRequest *)requestBean
{
  return NO;
}

- (BOOL)canCacheEventWithRequestBean:(nonnull in id<SSNetDomainRequestProtocol>)requestBean
{
  return NO;
}

- (nonnull id)cacheObjectFilter:(nonnull in id)object
{
  return object;
}
@end
