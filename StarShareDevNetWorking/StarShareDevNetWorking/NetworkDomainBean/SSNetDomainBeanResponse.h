//
//  SSNetDomainBeanResponse.h
//  StarShareDevNetWorking
//
//  Created by BUBUKO on 2017/10/27.
//  Copyright © 2017年 BUBUKO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSNetDomainResponseProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface SSNetDomainBeanResponse : NSObject<SSNetDomainResponseProtocol>
@property(nonatomic, strong) NSURLResponse *response;
@property(nonatomic, strong) id responseObject;

@property(nonatomic, assign, getter=isDataFromCache) BOOL dataFromCache;
@end

NS_ASSUME_NONNULL_END
