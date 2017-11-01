//
//  SSNetDomainResponseProtocol.h
//  StarShareDevNetWorking
//
//  Created by BUBUKO on 2017/10/27.
//  Copyright © 2017年 BUBUKO. All rights reserved.
//

#import "SSNetDomainResponseHelperProtocol.h"
#import "SSNetWorkConstants.h"

@class SSNetDomainBeanRequest;
@class SSNetDomainBeanResponse;

NS_ASSUME_NONNULL_BEGIN

@protocol SSNetDomainResponseProtocol <SSNetDomainResponseHelperProtocol>

@required

/**
 请求完成后数据返回

 @param requestBean requestBean
 @param respondBean respondBean
 @param isDataFromCache isDataFromCache
 */
- (void)complementWithRequestBean:(in SSNetDomainBeanRequest *)requestBean respondBean:(in SSNetDomainBeanResponse *)respondBean isDataFromCache:(BOOL)isDataFromCache;
@end

NS_ASSUME_NONNULL_END
