//
//  SSNetWorkEngineHandle.m
//  StarShareDevNetWorking
//
//  Created by BUBUKO on 2017/10/28.
//  Copyright © 2017年 BUBUKO. All rights reserved.
//

#import "SSNetWorkEngineHandle.h"
#import "SSAFNetWorkEngineHandle.h"

@interface SSNetWorkEngineHandle ()
@property (nonatomic, strong) id<SSNetRequestHandleProtocol> handleOfAFNetworking;
@end

@implementation SSNetWorkEngineHandle

#pragma mark - <init>

- (instancetype)initWithTask:(NSURLSessionTask *)task
{
  if (self = [super init]) {
    self.handleOfAFNetworking = [[SSAFNetWorkEngineHandle alloc] initWithTask:task];
  }
  return self;
}

#pragma mark - <SSNetRequestHandleProtocol>
- (BOOL)isCancelled{
  return [self.handleOfAFNetworking isCancelled];
}
- (BOOL)isBusy{
  return [self.handleOfAFNetworking isBusy];
}
- (void)cancel{
  [self.handleOfAFNetworking cancel];
}
@end

@implementation SSNetWorkEngineHandleNilObject
#pragma mark - <SSNetRequestHandleProtocol>
- (BOOL)isCancelled{return YES;}
- (BOOL)isBusy{return NO;}
- (void)cancel{}
@end
