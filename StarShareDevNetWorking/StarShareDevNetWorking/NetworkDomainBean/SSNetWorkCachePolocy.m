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
  return -1;
}

- (SSNetRequestReadCachePolicy)readCachePolicyWithRequestBean:(nonnull in id<SSNetDomainRequestProtocol>)requestBean
{
  return SSNetRequestReadCacheFirst;
}

- (NSString * _Nonnull)cacheIdentificationWithRequestBean:(nonnull in SSNetDomainBeanRequest *)requestBean
{
  return [NSString stringWithFormat:@"%s",object_getClassName(requestBean)];
}

- (NSString * _Nonnull)cacheVersion
{
  return @"0.0.1";
}

- (NSInteger)cacheEffectiveTimeInSeconds
{
  return NSIntegerMax;
}

- (BOOL)writeCacheAsynchronously
{
  return YES;
}

- (BOOL)holdCacheWithRequestBean:(nonnull in SSNetDomainBeanRequest *)requestBean
{
  return NO;
}
@end
