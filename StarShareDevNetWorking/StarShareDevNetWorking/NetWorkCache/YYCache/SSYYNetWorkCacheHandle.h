//
//  SSYYNetWorkCacheHandle.h
//  StarShareDevNetWorking
//
//  Created by BUBUKO on 2017/10/29.
//  Copyright © 2017年 BUBUKO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSNetWorkCacheHandleProtocol.h"

@class YYCache;

NS_ASSUME_NONNULL_BEGIN

@interface SSYYNetWorkCacheHandle : NSObject<SSNetWorkCacheHandleProtocol>
- (instancetype)initWithCache:(YYCache *)cache key:(nonnull NSString *)key;
@end

NS_ASSUME_NONNULL_END
