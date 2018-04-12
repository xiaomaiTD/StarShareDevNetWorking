//
//  SSNetWorkCacheProtocol.h
//  StarShareDevNetWorking
//
//  Created by BUBUKO on 2017/10/27.
//  Copyright © 2017年 BUBUKO. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SSNetWorkCacheHandleProtocol;
@protocol SSNetRequestCachePolocyProtocol;
@protocol SSNetDomainRequestProtocol;
@protocol SSNetDomainResponseProtocol;

@class SSNetWorkCachePolocy;
@class SSNetDomainBeanRequest;
@class SSNetDomainBeanResponse;

@protocol SSNetWorkCacheProtocol <NSObject>

- (id<SSNetWorkCacheHandleProtocol>)writeCacheWithRequestBean:(in SSNetDomainBeanRequest *)requestBean
                                               responseObject:(in id)responseObject
                                                        error:(out NSError **)error;

- (id<SSNetWorkCacheHandleProtocol>)readCacheWithRequestBean:(in SSNetDomainBeanRequest *)requestBean
                                                       error:(out NSError **)error;

- (id<SSNetWorkCacheHandleProtocol>)clearCacheWithRequestBean:(in SSNetDomainBeanRequest *)requestBean
                                                        error:(out NSError **)error;

- (BOOL)hasCacheWithRequestBean:(in SSNetDomainBeanRequest *)requestBean;
@end
