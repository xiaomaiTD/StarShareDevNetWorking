//
//  SSNetDomainRequestHelperProtocol.h
//  StarShareDevNetWorking
//
//  Created by BUBUKO on 2017/10/27.
//  Copyright © 2017年 BUBUKO. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SSNetDomainBeanRequest;
@class SSNetDomainBeanResponse;

NS_ASSUME_NONNULL_BEGIN

@protocol SSNetDomainRequestHelperProtocol <NSObject>

@required
- (BOOL)statusCodeValidator:(NSURLResponse *)response;
- (nullable NSString*)requestUrlMosaicWithRequestBean:(in nonnull SSNetDomainBeanRequest *)requestBean error:(out NSError **)error;
- (nonnull id)requestArgumentMosaicWithRequestBean:(in nonnull SSNetDomainBeanRequest *)requestBean error:(out NSError **)error;
- (nonnull id)requestArgumentMapWithArguments:(in nonnull id)arguments error:(out NSError **)error;
@end

NS_ASSUME_NONNULL_END
