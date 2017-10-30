//
//  SSNetDomainBeanResponse.m
//  StarShareDevNetWorking
//
//  Created by BUBUKO on 2017/10/27.
//  Copyright © 2017年 BUBUKO. All rights reserved.
//

#import "SSNetDomainBeanResponse.h"
#import "SSNetWorkCachePolocy.h"

@implementation SSNetDomainBeanResponse

#pragma mark - <SSNetDomainResponseProtocol>

- (void)respondBeanComplement:(in id)respondBean requestBean:(in id)requestBean isDataFromCache:(BOOL)isDataFromCache
{
  
}

#pragma mark - <SSNetDomainResponseHelperProtocol>

- (nullable id)jsonValidator
{
  return nil;
}

- (BOOL)respondBeanValidity:(in id)respondBean error:(out NSError **)error
{
  return YES;
}

@end
