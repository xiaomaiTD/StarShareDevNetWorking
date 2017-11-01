//
//  SSNetworkUtils.h
//  StarShareDevNetWorking
//
//  Created by BUBUKO on 2017/10/27.
//  Copyright © 2017年 BUBUKO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSNetWorkConstants.h"

FOUNDATION_EXPORT void SSNetWorkLog(NSString *format, ...) NS_FORMAT_FUNCTION(1,2);

@interface SSNetworkUtils : NSObject

+ (BOOL)validateJSON:(id)json withValidator:(id)jsonValidator;
+ (void)addDoNotBackupAttribute:(NSString *)path;
+ (NSString *)md5StringFromString:(NSString *)string;
+ (NSString *)appVersionString;
+ (BOOL)validateResumeData:(NSData *)data;
+ (NSString *)requestMethod:(SSNetRequestMethod)method;
+ (NSString *)requestPriority:(SSNetRequestPriority)priority;
+ (NSString *)cachePolicy:(SSNetRequestPolicy)policy;
+ (NSString *)requestPolicy:(SSNetRequestPolicy)policy;

@end

