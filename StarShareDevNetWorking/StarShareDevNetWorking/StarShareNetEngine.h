//
//  StarShareNetEngine.h
//  StarShareDevNetWorking
//
//  Created by BUBUKO on 2017/10/27.
//  Copyright © 2017年 BUBUKO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSNetWorkEngine.h"

@class SSNetDomainBeanRequest;
@class SSNetDomainBeanResponse;

@interface StarShareNetEngine : NSObject

+ (instancetype)sharedInstance;

- (id<SSNetRequestHandleProtocol>)excuteWithRequestBean:(in SSNetDomainBeanRequest *)requestBean
                                           responseBean:(in SSNetDomainBeanResponse *)responseBean;

- (id<SSNetRequestHandleProtocol>)excuteWithRequestBean:(in SSNetDomainBeanRequest *)requestBean
                                           responseBean:(in SSNetDomainBeanResponse *)responseBean
                                              successed:(in SSNetEngineRequestBeanSuccessedBlock)successed
                                                 failed:(in SSNetEngineRequestBeanFailedBlock)failed;

- (id<SSNetRequestHandleProtocol>)excuteWithRequestBean:(in SSNetDomainBeanRequest *)requestBean
                                           responseBean:(in SSNetDomainBeanResponse *)responseBean
                                                  begin:(in SSNetEngineRequestBeanBeginBlock)begin
                                              successed:(in SSNetEngineRequestBeanSuccessedBlock)successed
                                                 failed:(in SSNetEngineRequestBeanFailedBlock)failed
                                                    end:(in SSNetEngineRequestBeanEndBlock)end;

@end

