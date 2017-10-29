//
//  SSYYNetWorkCacheHandle.m
//  StarShareDevNetWorking
//
//  Created by BUBUKO on 2017/10/29.
//  Copyright © 2017年 BUBUKO. All rights reserved.
//

#import "SSYYNetWorkCacheHandle.h"
#import <YYCache/YYCache.h>

@interface SSYYNetWorkCacheHandle ()
@property (nonatomic, strong) YYCache *cache;
@property (nonatomic, copy) NSString *cacheKey;
@end

@implementation SSYYNetWorkCacheHandle

- (instancetype)initWithCache:(YYCache *)cache key:(nonnull NSString *)key
{
  if (self = [super init]) {
    _cache = cache;
    _cacheKey = key;
  }
  return self;
}

#pragma mark - <SSNetWorkCacheHandleProtocol>

- (nullable id)cacheData
{
  if (_cache == nil || _cacheKey == nil) {
    return nil;
  }
  return [_cache objectForKey:_cacheKey];
}

- (void)clearCache
{
  if (_cache == nil || _cacheKey == nil) {
    return;
  }
  [_cache removeObjectForKey:_cacheKey];
}

@end
