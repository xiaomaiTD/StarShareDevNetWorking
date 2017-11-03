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
  return @"http://47.95.226.243:9090/api/app/getcode";
}

- (id)requestArgument
{
  return @{@"phone":@"17744437544"};
}

- (id<SSNetRequestCachePolocyProtocol>)cachePolocy
{
  return [[HomePageCachePolocy alloc] init];
}

- (SSNetRequestMethod)requestMethod
{
  return SSNetRequestMethodPOST;
}

@end
