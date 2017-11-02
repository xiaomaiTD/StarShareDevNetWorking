//
//  SSNetworkConfig.m
//  StarShareDevNetWorking
//
//  Created by BUBUKO on 2017/10/27.
//  Copyright © 2017年 BUBUKO. All rights reserved.
//

#import "SSNetworkConfig.h"

@implementation SSNetworkConfig

+ (SSNetworkConfig *)sharedConfig {
  static id sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[self alloc] init];
  });
  return sharedInstance;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _baseUrl = @"";
    _cachePath = @"StarShareRequestCache";
    _debugLogEnabled = YES;
    _securityPolicy = nil;
    _publicArgument = nil;
    _publicHeaders = nil;
    _timeoutInterval = 60;
    _allowsCellularAccess = YES;
  }
  return self;
}

@end
