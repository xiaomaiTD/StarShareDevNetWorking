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

@protocol SSNetWorkCacheProtocol <NSObject>

- (id<SSNetWorkCacheHandleProtocol>)writeCacheWithPolocy:(in id<SSNetRequestCachePolocyProtocol>)polocy
                                             requestBean:(in id<SSNetDomainRequestProtocol>)requestBean
                                            responseBean:(in id<SSNetDomainResponseProtocol>)responseBean
                                                   error:(out NSError **)error;

- (id<SSNetWorkCacheHandleProtocol>)readCacheWithPolocy:(in id<SSNetRequestCachePolocyProtocol>)polocy
                                            requestBean:(in id<SSNetDomainRequestProtocol>)requestBean
                                           responseBean:(in id<SSNetDomainResponseProtocol>)responseBean
                                                  error:(out NSError **)error;

- (id<SSNetWorkCacheHandleProtocol>)clearCacheWithPolocy:(in id<SSNetRequestCachePolocyProtocol>)polocy
                                             requestBean:(in id<SSNetDomainRequestProtocol>)requestBean
                                            responseBean:(in id<SSNetDomainResponseProtocol>)responseBean
                                                   error:(out NSError **)error;

@end
