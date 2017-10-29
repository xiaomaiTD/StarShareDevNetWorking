//
//  HomePageCachePolocy.m
//  StarShareDevNetWorking
//
//  Created by BUBUKO on 2017/10/28.
//  Copyright © 2017年 BUBUKO. All rights reserved.
//

#import "HomePageCachePolocy.h"

@implementation HomePageCachePolocy

- (BOOL)needCache
{
  return YES;
}

- (SSNetRequestCachePolicy)cachePolicy
{
  return SSNetRequestCachePolicyDisk;
}

- (long long)cacheVersion
{
  return 1;
}

- (NSInteger)cacheTimeInSeconds
{
  return -1;
}

@end
