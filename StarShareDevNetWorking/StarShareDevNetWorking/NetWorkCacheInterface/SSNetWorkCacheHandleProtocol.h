//
//  SSNetWorkCacheHandleProtocol.h
//  StarShareDevNetWorking
//
//  Created by BUBUKO on 2017/10/27.
//  Copyright © 2017年 BUBUKO. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SSNetWorkCacheHandleProtocol <NSObject>

@required
- (nullable id)cacheData;
- (void)clearCache;

@end

NS_ASSUME_NONNULL_END
