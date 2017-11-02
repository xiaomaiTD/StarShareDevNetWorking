//
//  HomePageRequest.m
//  StarShareDevNetWorking
//
//  Created by BUBUKO on 2017/10/28.
//  Copyright © 2017年 BUBUKO. All rights reserved.
//

#import "HomePageRequest.h"
#import "HomePageCachePolocy.h"

@implementation HomePageRequest

- (NSString *)requestUrl
{
  return @"https://www.v2ex.com/api/members/show.json";
}

- (id)requestArgument
{
  return @{@"username":@"rvw"};
}

- (id<SSNetRequestCachePolocyProtocol>)cachePolocy
{
  return [[HomePageCachePolocy alloc] init];
}

@end
