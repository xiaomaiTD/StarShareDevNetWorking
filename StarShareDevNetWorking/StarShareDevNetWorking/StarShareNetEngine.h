//
//  StarShareNetEngine.h
//  StarShareDevNetWorking
//
//  Created by BUBUKO on 2017/10/27.
//  Copyright © 2017年 BUBUKO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSNetWorkEngine.h"

@interface StarShareNetEngine : NSObject

+ (instancetype)sharedInstance;

- (id<SSNetRequestHandleProtocol>)excuteWithRequestBean:(in id)requestBean
                                           responseBean:(in id)responseBean;

- (id<SSNetRequestHandleProtocol>)excuteWithRequestBean:(in id)requestBean
                                           responseBean:(in id)responseBean
                                              successed:(in SSNetEngineRequestBeanSuccessedBlock)successed
                                                 failed:(in SSNetEngineRequestBeanFailedBlock)failed;

- (id<SSNetRequestHandleProtocol>)excuteWithRequestBean:(in id)requestBean
                                           responseBean:(in id)responseBean
                                                  begin:(in SSNetEngineRequestBeanBeginBlock)begin
                                              successed:(in SSNetEngineRequestBeanSuccessedBlock)successed
                                                 failed:(in SSNetEngineRequestBeanFailedBlock)failed
                                                    end:(in SSNetEngineRequestBeanEndBlock)end;

@end

