//
//  SSNetDomainRequestHelperProtocol.h
//  StarShareDevNetWorking
//
//  Created by BUBUKO on 2017/10/27.
//  Copyright © 2017年 BUBUKO. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SSNetDomainRequestHelperProtocol <NSObject>

@required
- (BOOL)statusCodeValidator;
- (nullable NSString*)requestUrlMosaic:(in nonnull id)netRequestBean error:(out NSError **)error;
- (nonnull id)requestArgumentMosaic:(in nonnull id)netRequestBean error:(out NSError **)error;
- (nonnull id)requestArgumentFilter:(in nonnull id)arguments error:(out NSError **)error;
@end

NS_ASSUME_NONNULL_END
