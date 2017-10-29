//
//  SSNetDomainResponseProtocol.h
//  StarShareDevNetWorking
//
//  Created by BUBUKO on 2017/10/27.
//  Copyright © 2017年 BUBUKO. All rights reserved.
//

#import "SSNetDomainResponseHelperProtocol.h"
#import "SSNetWorkConstants.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SSNetDomainResponseProtocol <SSNetDomainResponseHelperProtocol>

@required
- (void)respondBeanComplement:(in id)respondBean requestBean:(in id)requestBean;
@end

NS_ASSUME_NONNULL_END
