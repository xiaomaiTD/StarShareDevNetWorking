//
//  SSAFNetWorkEngineHandle.m
//  StarShareDevNetWorking
//
//  Created by BUBUKO on 2017/10/28.
//  Copyright © 2017年 BUBUKO. All rights reserved.
//

#import "SSAFNetWorkEngineHandle.h"

@interface SSAFNetWorkEngineHandle ()
@property (nonatomic, strong) NSURLSessionDataTask *task;
@end

@implementation SSAFNetWorkEngineHandle

- (instancetype)initWithTask:(NSURLSessionDataTask *)task
{
  if (self = [super init]) {
    _task = task;
  }
  return self;
}

#pragma mark - <SSNetRequestHandleProtocol>

- (BOOL)isBusy {
  return (_task.state != NSURLSessionTaskStateCompleted && _task.state != NSURLSessionTaskStateCanceling);
}

- (void)cancel {
  [_task cancel];
}

#pragma mark - <SSNetRequestStateProtocol>

- (BOOL)isCancelled {
  return (_task.state == NSURLSessionTaskStateCanceling);
}

@end
