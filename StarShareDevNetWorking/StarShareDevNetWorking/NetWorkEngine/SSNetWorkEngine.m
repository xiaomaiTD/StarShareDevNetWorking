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
                                              progress:(in SSNetRequestProgressCallback)progress
                                               success:(in SSNetRequestSuccessedCallback)success
                                               failure:(in SSNetRequestFailedCallback)failure{
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
                                                progress:progress
                                                 success:success
                                                 failure:failure];
}

- (id<SSNetRequestHandleProtocol>)downloadWithUrlString:(in NSString *)urlString
                                         securityPolicy:(in id)securityPolicy
                                      requestSerializer:(in SSNetRequestSerializer)requestSerializer
                                               priority:(in SSNetRequestPriority)priority
                                          authorization:(in NSArray *)authorization
                                                headers:(in NSDictionary *)headers
                                               argument:(in id)argument
                                  resumableDownloadPath:(in NSString *)resumableDownloadPath
                                                timeout:(in NSTimeInterval)timeout
                                   allowsCellularAccess:(in BOOL)allowsCellularAccess
                                               progress:(in SSNetDownloadProgressCallback)progress
                                               complete:(in SSNetDownloadCompleteCallback)complete
                                                failure:(in SSNetRequestFailedCallback)failure {
  return [self.engineOfAFNetworking downloadWithUrlString:urlString
                                           securityPolicy:securityPolicy
                                        requestSerializer:requestSerializer
                                                 priority:priority
                                            authorization:authorization
                                                  headers:headers
                                                 argument:argument
                                    resumableDownloadPath:resumableDownloadPath
                                                  timeout:timeout
                                     allowsCellularAccess:allowsCellularAccess
                                                 progress:progress
                                                 complete:complete
                                                  failure:failure];
}
@end

