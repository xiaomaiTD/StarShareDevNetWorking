//
//  SSNetRequestProtocol.h
//  StarShareDevNetWorking
//
//  Created by BUBUKO on 2017/10/26.
//  Copyright © 2017年 BUBUKO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSNetRequestData.h"
#import "SSNetRequestHandleProtocol.h"

@protocol SSNetRequestProtocol <NSObject>

- (id<SSNetRequestHandleProtocol>)requestWithUrlString:(in NSString *)urlString
                                        securityPolicy:(in id)securityPolicy
                                                method:(in SSNetRequestMethod)method
                                     requestSerializer:(in SSNetRequestSerializer)requestSerializer
                                    responseSerializer:(in SSNetResponseSerializer)responseSerializer
                                              priority:(in SSNetRequestPriority)priority
                                         authorization:(in NSArray *)authorization
                                               headers:(in NSDictionary *)headers
                                              argument:(in id)argument
                                                  data:(in SSNetRequestData *)data
                                               timeout:(in NSTimeInterval)timeout
                                  allowsCellularAccess:(in BOOL)allowsCellularAccess
                                               success:(in SSNetRequestSuccessedCallback)success
                                               failure:(in SSNetRequestFailedCallback)failure;

@end
