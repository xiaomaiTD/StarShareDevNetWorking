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
@class SSNetworkConfig;

@interface StarShareNetEngine : NSObject

@property (nonatomic, strong, readonly) SSNetworkConfig *engineConfigation;///< default is [SSNetworkConfig sharedConfig]
+ (instancetype)sharedInstance;
+ (void)setupEngineConfigation:(SSNetworkConfig *)configation;

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

- (id<SSNetRequestHandleProtocol>)excuteWithRequestBean:(in SSNetDomainBeanRequest *)requestBean
                                           responseBean:(in SSNetDomainBeanResponse *)responseBean
                                               progress:(in SSNetRequestProgressCallback)progress
                                              successed:(in SSNetEngineRequestBeanSuccessedBlock)successed
                                                 failed:(in SSNetEngineRequestBeanFailedBlock)failed;

- (id<SSNetRequestHandleProtocol>)excuteWithRequestBean:(in SSNetDomainBeanRequest *)requestBean
                                           responseBean:(in SSNetDomainBeanResponse *)responseBean
                                                  begin:(in SSNetEngineRequestBeanBeginBlock)begin
                                               progress:(in SSNetRequestProgressCallback)progress
                                              successed:(in SSNetEngineRequestBeanSuccessedBlock)successed
                                                 failed:(in SSNetEngineRequestBeanFailedBlock)failed
                                                    end:(in SSNetEngineRequestBeanEndBlock)end;
@end

