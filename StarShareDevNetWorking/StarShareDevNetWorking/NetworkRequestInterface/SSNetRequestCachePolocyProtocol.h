//
//  SSNetRequestCachePolocyProtocol.h
//  StarShareDevNetWorking
//
//  Created by BUBUKO on 2017/10/27.
//  Copyright © 2017年 BUBUKO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSNetWorkConstants.h"

@protocol SSNetRequestCachePolocyProtocol <NSObject>

@required
- (BOOL)needCache;
- (SSNetRequestCachePolicy)cachePolicy;
- (NSInteger)cacheTimeInSeconds;
- (long long)cacheVersion;
- (nullable id)cacheSensitiveData;
- (BOOL)writeCacheAsynchronously;

@end
