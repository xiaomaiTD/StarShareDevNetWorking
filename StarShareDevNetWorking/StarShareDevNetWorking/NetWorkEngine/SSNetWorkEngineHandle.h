//
//  SSNetWorkEngineHandle.h
//  StarShareDevNetWorking
//
//  Created by BUBUKO on 2017/10/28.
//  Copyright © 2017年 BUBUKO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSNetRequestHandleProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface SSNetWorkEngineHandle : NSObject<SSNetRequestHandleProtocol>
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithTask:(NSURLSessionTask *)task;
@end

@interface SSNetWorkEngineHandleNilObject : NSObject<SSNetRequestHandleProtocol>
@end

NS_ASSUME_NONNULL_END
