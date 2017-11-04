//
//  SSNetWorkConstants.h
//  StarShareDevNetWorking
//
//  Created by BUBUKO on 2017/10/26.
//  Copyright © 2017年 BUBUKO. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SS_SAFE_SEND_MESSAGE(obj, msg) if ((obj) && [(obj) respondsToSelector:@selector(msg)])
#define NONNIL_STRING(str) str == nil ? @"" : str
#define NONNIL_DIC(dic) dic == nil ? @{} : dic
#define BOOL_STRING(r) r == YES ? @"YES" : @"NO"

typedef NSUInteger SSNetRequestMethod;
NS_ENUM(NSStringEncoding) {
  SSNetRequestMethodGET = 0,
  SSNetRequestMethodPOST = 1,
  SSNetRequestMethodHEAD = 2,
  SSNetRequestMethodPUT = 3,
  SSNetRequestMethodDELETE = 4,
  SSNetRequestMethodPATCH = 5,
};

typedef NSUInteger SSNetRequestSerializer;
NS_ENUM(NSStringEncoding) {
  SSNetRequestSerializerHTTP = 0,
  SSNetRequestSerializerJSON = 1,
  SSNetRequestSerializerPropertyList = 2,
};

typedef NSUInteger SSNetResponseSerializer;
NS_ENUM(NSStringEncoding) {
  SSNetResponseSerializerHTTP = 0,
  SSNetResponseSerializerJSON = 1,
  SSNetResponseSerializerXMLParser = 2,
  SSNetResponseSerializerXMLDocument = 3,
  SSNetResponseSerializerPropertyList = 4,
  SSNetResponseSerializerImage = 5,
  SSNetResponseSerializerCompound = 6,
};

typedef NSUInteger SSNetRequestPriority;
NS_ENUM(NSStringEncoding) {
  SSNetRequestPriorityVeryLow = -8L,
  SSNetRequestPriorityLow = -4L,
  SSNetRequestPriorityNormal = 0,
  SSNetRequestPriorityHigh = 4,
  SSNetRequestPriorityVeryHigh = 8,
};
  
typedef NSUInteger SSNetRequestDataType;
NS_ENUM(NSStringEncoding) {
  SSNetRequestDataTypeFile = 1,
  SSNetRequestDataTypeForm = 2,
  SSNetRequestDataTypeFileUrl = 3,
};
    
typedef NSUInteger SSNetRequestReadCachePolicy;
NS_ENUM(NSStringEncoding) {
  SSNetRequestReadCacheNever = 1,
  SSNetRequestReadCacheFirst = 0,
  SSNetRequestReadCacheEver = 2,
};
    
typedef NSUInteger SSNetRequestCachePolicy;
NS_ENUM(NSStringEncoding) {
  SSNetRequestCacheMemory = 1,
  SSNetRequestCacheDisk = 2,
};
  
#define SSNetWorkCacheErrorDomain @"com.starshare.caching"
NS_ENUM(NSInteger) {
  SSNetWorkCacheErrorExpired = -1,
  SSNetWorkCacheErrorVersionMismatch = -2,
  SSNetWorkCacheErrorSensitiveDataMismatch = -3,
  SSNetWorkCacheErrorAppVersionMismatch = -4,
  SSNetWorkCacheErrorInvalidCacheTime = -5,
  SSNetWorkCacheErrorInvalidMetadata = -6,
  SSNetWorkCacheErrorInvalidCacheData = -7,
  SSNetWorkCacheErrorInvalidCacheEnable = -8,
  SSNetWorkCacheErrorInvalidCachePolicy = -9
};
  
#define SSNetWorkEngineErrorDomain @"com.starshare.engine"
NS_ENUM(NSInteger) {
  SSNetWorkEngineErrorNone = -1024,
  SSNetWorkEngineErrorEngine = 1000,
  SSNetWorkEngineErrorProgramming = 1001,
  SSNetWorkEngineErrorNilArgument = 1002,
  SSNetWorkEngineErrorIllegalArgument = 1003,
  SSNetWorkEngineErrorNullPointer = 1004,
  SSNetWorkEngineErrorMethodReturnValueInvalid = 1005,
  SSNetWorkEngineErrorNetRequestBeanInvalid = 1006,
  SSNetWorkEngineErrorNetResponseBeanInvalid = 1007,
};

typedef void (^SSNetRequestSuccessedCallback)(NSURLResponse * __unused response,id responseObject);
typedef void (^SSNetRequestFailedCallback)(NSURLResponse * __unused response, id responseObject,NSError *error);

typedef void (^SSNetEngineRequestBeanBeginBlock)(void);
typedef void (^SSNetEngineRequestBeanEndBlock)(void);
typedef void (^SSNetEngineRequestBeanSuccessedBlock)(id requestDomainBean,id respondDomainBean,BOOL dataFromCache);
typedef void (^SSNetEngineRequestBeanFailedBlock)(id requestDomainBean,id respondDomainBean,NSError *error);
