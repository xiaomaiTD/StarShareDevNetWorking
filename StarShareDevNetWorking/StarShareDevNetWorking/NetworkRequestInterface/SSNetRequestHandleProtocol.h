//
//  SSNetRequestHandleProtocol.h
//  StarShareDevNetWorking
//
//  Created by BUBUKO on 2017/10/26.
//  Copyright © 2017年 BUBUKO. All rights reserved.
//

@protocol SSNetRequestHandleProtocol <NSObject>

/**
 当前请求是否忙碌

 @return isBusy
 */
- (BOOL)isBusy;

/**
 取消当前请求
 */
- (void)cancel;

/**
 当前请求是否已被取消

 @return isCancelled
 */
- (BOOL)isCancelled;
@end
