//
//  SSNetWorkCachePolocy.m
//  StarShareDevNetWorking
//
//  Created by BUBUKO on 2017/10/27.
//  Copyright © 2017年 BUBUKO. All rights reserved.
//

#import "SSNetWorkCachePolocy.h"

@implementation SSNetWorkCachePolocy

#pragma mark - <SSNetRequestCachePolocyProtocol>

- (BOOL)needCache
{
  return NO;
}

- (SSNetRequestCachePolicy)cachePolicy
{
  return 0;
}

- (NSInteger)cacheTimeInSeconds
{
  return -1;
}

- (long long)cacheVersion
{
  return 0;
}

- (nullable id)cacheSensitiveData
{
  return nil;
}

- (BOOL)writeCacheAsynchronously
{
  return YES;
}

- (BOOL)shouldHoldCacheEvent
{
  return NO;
}

- (BOOL)canCacheEvent:(nonnull in id)requestBean
{
  return NO;
}

- (nonnull id)cacheObjectFilter:(nonnull in id)object
{
  return object;
}
@end
