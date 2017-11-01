//
//  SSNetRequestCachePolocyProtocol.h
//  StarShareDevNetWorking
//
//  Created by BUBUKO on 2017/10/27.
//  Copyright © 2017年 BUBUKO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSNetWorkConstants.h"

@class SSNetDomainBeanRequest;
@class SSNetDomainBeanResponse;

@protocol SSNetRequestCachePolocyProtocol <NSObject>

@required
- (BOOL)needCacheWithRequestBean:(nonnull in SSNetDomainBeanRequest *)requestBean;
- (SSNetRequestCachePolicy)cachePolicyWithRequestBean:(nonnull in SSNetDomainBeanRequest *)requestBean;
- (NSInteger)cacheEffectiveTimeInSeconds;
- (NSString * _Nonnull)cacheVersion;
- (nullable id)cacheSensitiveData;
- (BOOL)writeCacheAsynchronously;

@optional
- (BOOL)shouldHoldCacheEventWithRequestBean:(nonnull in SSNetDomainBeanRequest *)requestBean;
- (BOOL)canCacheEventWithRequestBean:(nonnull in SSNetDomainBeanRequest *)requestBean;
- (nonnull id)cacheObjectFilter:(nonnull in id)object;
@end
