//
//  SSNetworkUtils.m
//  StarShareDevNetWorking
//
//  Created by BUBUKO on 2017/10/27.
//  Copyright © 2017年 BUBUKO. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import "SSNetworkUtils.h"
#import "SSNetworkConfig.h"

void SSNetWorkLog(NSString *format, ...) {
#ifdef DEBUG
  if (![SSNetworkConfig sharedConfig].debugLogEnabled) {
    return;
  }
  va_list argptr;
  va_start(argptr, format);
  NSLogv(format, argptr);
  va_end(argptr);
#endif
}

@implementation SSNetworkUtils

+ (BOOL)validateJSON:(id)json withValidator:(id)jsonValidator {
  if ([json isKindOfClass:[NSDictionary class]] &&
      [jsonValidator isKindOfClass:[NSDictionary class]]) {
    NSDictionary * dict = json;
    NSDictionary * validator = jsonValidator;
    BOOL result = YES;
    NSEnumerator * enumerator = [validator keyEnumerator];
    NSString * key;
    while ((key = [enumerator nextObject]) != nil) {
      id value = dict[key];
      id format = validator[key];
      if ([value isKindOfClass:[NSDictionary class]]
          || [value isKindOfClass:[NSArray class]]) {
        result = [self validateJSON:value withValidator:format];
        if (!result) {
          break;
        }
      } else {
        if ([value isKindOfClass:format] == NO &&
            [value isKindOfClass:[NSNull class]] == NO) {
          result = NO;
          break;
        }
      }
    }
    return result;
  } else if ([json isKindOfClass:[NSArray class]] &&
             [jsonValidator isKindOfClass:[NSArray class]]) {
    NSArray * validatorArray = (NSArray *)jsonValidator;
    if (validatorArray.count > 0) {
      NSArray * array = json;
      NSDictionary * validator = jsonValidator[0];
      for (id item in array) {
        BOOL result = [self validateJSON:item withValidator:validator];
        if (!result) {
          return NO;
        }
      }
    }
    return YES;
  } else if ([json isKindOfClass:jsonValidator]) {
    return YES;
  } else {
    return NO;
  }
}

+ (void)addDoNotBackupAttribute:(NSString *)path {
  NSURL *url = [NSURL fileURLWithPath:path];
  NSError *error = nil;
  [url setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:&error];
  if (error) {
    SSNetWorkLog(@"error to set do not backup attribute, error = %@", error);
  }
}

+ (NSString *)md5StringFromString:(NSString *)string {
  NSParameterAssert(string != nil && [string length] > 0);
  
  const char *value = [string UTF8String];
  
  unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
  CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
  
  NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
  for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
    [outputString appendFormat:@"%02x", outputBuffer[count]];
  }
  
  return outputString;
}

+ (NSString *)appVersionString {
  return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+ (BOOL)validateResumeData:(NSData *)data {
  // From http://stackoverflow.com/a/22137510/3562486
  if (!data || [data length] < 1) return NO;
  
  NSError *error;
  NSDictionary *resumeDictionary = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListImmutable format:NULL error:&error];
  if (!resumeDictionary || error) return NO;
  
  // Before iOS 9 & Mac OS X 10.11
#if (defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED < 90000)\
|| (defined(__MAC_OS_X_VERSION_MAX_ALLOWED) && __MAC_OS_X_VERSION_MAX_ALLOWED < 101100)
  NSString *localFilePath = [resumeDictionary objectForKey:@"NSURLSessionResumeInfoLocalPath"];
  if ([localFilePath length] < 1) return NO;
  return [[NSFileManager defaultManager] fileExistsAtPath:localFilePath];
#endif
  // After iOS 9 we can not actually detects if the cache file exists. This plist file has a somehow
  // complicated structue. Besides, the plist structure is different between iOS 9 and iOS 10.
  // We can only assume that the plist being successfully parsed means the resume data is valid.
  return YES;
}

+ (NSString *)requestMethod:(SSNetRequestMethod)method
{
  switch (method) {
    case SSNetRequestMethodGET:
      return @"GET";
      break;
    case SSNetRequestMethodPUT:
      return @"PUT";
      break;
    case SSNetRequestMethodPOST:
      return @"POST";
      break;
    case SSNetRequestMethodDELETE:
      return @"DELETE";
      break;
    case SSNetRequestMethodHEAD:
      return @"HEAD";
      break;
    case SSNetRequestMethodPATCH:
      return @"PATCH";
      break;
      
    default:
      return @"Unknow";
      break;
  }
}

+ (NSString *)requestPriority:(SSNetRequestPriority)priority
{
  switch (priority) {
    case SSNetRequestPriorityVeryLow:
      return @"VeryLow";
      break;
    case SSNetRequestPriorityLow:
      return @"Low";
      break;
    case SSNetRequestPriorityNormal:
      return @"Normal";
      break;
    case SSNetRequestPriorityHigh:
      return @"High";
      break;
    case SSNetRequestPriorityVeryHigh:
      return @"VeryHigh";
      break;
      
    default:
      return @"Unknow";
      break;
  }
}

+ (NSString *)cachePolicy:(SSNetRequestCachePolicy)policy
{
  switch (policy) {
    case SSNetRequestCachePolicyMemory:
      return @"Memory";
      break;
    case SSNetRequestCachePolicyDisk:
      return @"Disk";
      break;
      
    default:
      return @"Nill";
      break;
  }
}

@end
