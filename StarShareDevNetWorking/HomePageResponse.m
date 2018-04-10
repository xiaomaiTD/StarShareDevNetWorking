//
//  HomePageResponse.m
//  StarShareDevNetWorking
//
//  Created by BUBUKO on 2017/10/28.
//  Copyright © 2017年 BUBUKO. All rights reserved.
//

#import "SSNetDomainBeanRequest.h"
#import "HomePageResponse.h"
#import "User.h"

@implementation HomePageResponse

- (void)complementWithRequestBean:(in SSNetDomainBeanRequest *)requestBean respondBean:(in SSNetDomainBeanResponse *)respondBean isDataFromCache:(BOOL)isDataFromCache
{
  NSLog(@"complementWithRequestBean -> %@",respondBean.responseObject);
}

@end
