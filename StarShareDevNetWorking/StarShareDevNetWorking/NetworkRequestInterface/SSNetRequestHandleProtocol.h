//
//  SSNetRequestHandleProtocol.h
//  StarShareDevNetWorking
//
//  Created by BUBUKO on 2017/10/26.
//  Copyright © 2017年 BUBUKO. All rights reserved.
//

@protocol SSNetRequestHandleProtocol <NSObject>
- (BOOL)isBusy;
- (void)cancel;
- (BOOL)isCancelled;
@end
