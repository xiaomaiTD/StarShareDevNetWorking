//
//  SSNetworkConfig.h
//  StarShareDevNetWorking
//
//  Created by BUBUKO on 2017/10/27.
//  Copyright © 2017年 BUBUKO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSNetworkConfig : NSObject

+ (SSNetworkConfig *)sharedConfig;

@property (nonatomic, copy) NSString *baseUrl;
@property (nonatomic, copy) NSString *cachePath;
@property (nonatomic, copy) NSString *codeKey;
@property (nonatomic, copy) NSDictionary *errorCodeInfo;
@property (nonatomic, assign) NSInteger rightCode;
@property (nonatomic) BOOL debugLogEnabled;
@property (nonatomic, strong) id securityPolicy;
@property (nonatomic, strong) NSDictionary *publicArgument;
@property (nonatomic, strong) NSDictionary *publicHeaders;
@property (nonatomic, strong) NSDictionary *jsonStrucValidator;
@property (nonatomic, strong) NSDictionary *jsonStrucAndValueValidator;
@property (nonatomic, assign) NSTimeInterval timeoutInterval;
@property (nonatomic, assign) BOOL allowsCellularAccess;
@end

