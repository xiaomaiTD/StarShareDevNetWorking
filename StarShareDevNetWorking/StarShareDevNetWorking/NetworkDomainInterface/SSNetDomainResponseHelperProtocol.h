//
//  SSNetDomainResponseHelperProtocol.h
//  StarShareDevNetWorking
//
//  Created by BUBUKO on 2017/10/28.
//  Copyright © 2017年 BUBUKO. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SSNetDomainResponseHelperProtocol <NSObject>

@required
- (nullable id)jsonValidator;
- (BOOL)respondValidityWithRespondObject:(in id)respondObject error:(out NSError **)error;
@end

NS_ASSUME_NONNULL_END
