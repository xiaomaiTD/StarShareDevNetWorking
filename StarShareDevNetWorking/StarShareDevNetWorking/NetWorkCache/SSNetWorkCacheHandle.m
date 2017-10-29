//
//  SSNetWorkCacheHandle.m
//  StarShareDevNetWorking
//
//  Created by BUBUKO on 2017/10/29.
//  Copyright © 2017年 BUBUKO. All rights reserved.
//

#import "SSNetWorkCacheHandle.h"

@implementation SSNetWorkCacheHandle

#pragma mark - <SSNetWorkCacheHandleProtocol>

- (nullable id)cacheData
{
  return nil;
}

- (void)clearCache{}

@end

@implementation SSNetWorkCacheHandleNilObject

#pragma mark - <SSNetWorkCacheHandleProtocol>

- (nullable id)cacheData
{
  return nil;
}

- (void)clearCache{}

@end
