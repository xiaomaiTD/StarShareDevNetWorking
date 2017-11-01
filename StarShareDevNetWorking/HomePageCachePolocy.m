//
//  HomePageCachePolocy.m
//  StarShareDevNetWorking
//
//  Created by BUBUKO on 2017/10/28.
//  Copyright © 2017年 BUBUKO. All rights reserved.
//

#import "HomePageCachePolocy.h"

@implementation HomePageCachePolocy

- (BOOL)needCacheWithRequestBean:(in SSNetDomainBeanRequest *)requestBean
{
  return YES;
}

//- (SSNetRequestPolicy)requestPolicyWithRequestBean:(in SSNetDomainBeanRequest *)requestBean
//{
//  return SSNetRequestReadCacheWithUpdate;
//}

- (SSNetRequestCachePolicy)cachePolicyWithRequestBean:(in SSNetDomainBeanRequest *)requestBean
{
  return SSNetRequestCacheDisk;
}

@end
