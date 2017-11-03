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
- (NSString * _Nonnull)cacheIdentificationWithRequestBean:(nonnull in SSNetDomainBeanRequest *)requestBean;
- (NSString * _Nonnull)cacheVersion;
- (NSInteger)cacheEffectiveTimeInSeconds;
- (BOOL)writeCacheAsynchronously;

@optional
- (BOOL)holdCacheWithRequestBean:(nonnull in SSNetDomainBeanRequest *)requestBean;
@end
