//
//  SSNetDomainBeanResponse.m
//  StarShareDevNetWorking
//
//  Created by BUBUKO on 2017/10/27.
//  Copyright © 2017年 BUBUKO. All rights reserved.
//

#import "SSNetDomainBeanResponse.h"
#import "SSNetWorkCachePolocy.h"
#import "StarShareNetEngine.h"
#import "SSNetworkConfig.h"

@implementation SSNetDomainBeanResponse

#pragma mark - <SSNetDomainResponseProtocol>

- (void)complementWithRequestBean:(in SSNetDomainBeanRequest *)requestBean respondBean:(in SSNetDomainBeanResponse *)respondBean isDataFromCache:(BOOL)isDataFromCache
{
  
}

#pragma mark - <SSNetDomainResponseHelperProtocol>

- (nullable id)jsonStrucValidator
{
  return [StarShareNetEngine sharedInstance].engineConfigation.jsonStrucValidator;
}

- (nullable id)jsonStrucAndValueValidator
{
  return [StarShareNetEngine sharedInstance].engineConfigation.jsonStrucAndValueValidator;
}

@end
