//
//  SSNetWorkEngine.m
//  StarShareDevNetWorking
//
//  Created by BUBUKO on 2017/10/26.
//  Copyright © 2017年 BUBUKO. All rights reserved.
//

#import "SSNetWorkEngine.h"
#import "SSAFNetWorkEngine.h"
#import "SSNetRequestHandleProtocol.h"

@interface SSNetWorkEngine ()
@property (nonatomic, strong) id<SSNetRequestProtocol> engineOfAFNetworking;
@end

@implementation SSNetWorkEngine

- (instancetype)init {
  if ((self = [super init])) {
    self.engineOfAFNetworking = [[SSAFNetWorkEngine alloc] init];
  }
  return self;
}

#pragma mark - <SSNetRequestProtocol>

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
                                               failure:(in SSNetRequestFailedCallback)failure
{
  return [self.engineOfAFNetworking requestWithUrlString:urlString
                                          securityPolicy:securityPolicy
                                                  method:method
                                       requestSerializer:requestSerializer
                                      responseSerializer:responseSerializer
                                                priority:priority
                                           authorization:authorization
                                                 headers:headers
                                                argument:argument
                                                    data:data
                                                 timeout:timeout
                                    allowsCellularAccess:allowsCellularAccess
                                                 success:success
                                                 failure:failure];
}

@end

