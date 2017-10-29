//
//  SSNetworkConfig.h
//  StarShareDevNetWorking
//
//  Created by BUBUKO on 2017/10/27.
//  Copyright © 2017年 BUBUKO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSNetworkConfig : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

+ (SSNetworkConfig *)sharedConfig;

@property (nonatomic, copy) NSString *baseUrl;
@property (nonatomic, copy) NSString *cachePath;
@property (nonatomic) BOOL debugLogEnabled;
@property (nonatomic, strong) NSURLSessionConfiguration* sessionConfiguration;
@property (nonatomic, strong) id securityPolicy;
@property (nonatomic, strong) NSDictionary *publicArgument;
@property (nonatomic, strong) NSDictionary *publicHeaders;
@property (nonatomic, assign) NSTimeInterval timeoutInterval;
@property (nonatomic, assign) BOOL allowsCellularAccess;
@end

