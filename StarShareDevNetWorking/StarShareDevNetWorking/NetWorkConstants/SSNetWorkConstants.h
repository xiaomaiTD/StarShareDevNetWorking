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
  SSNetWorkCacheErrorAppVersionMismatch = -3,
  SSNetWorkCacheErrorInvalidCacheTime = -4,
  SSNetWorkCacheErrorInvalidMetadata = -5,
  SSNetWorkCacheErrorInvalidCacheData = -6,
  SSNetWorkCacheErrorInvalidCacheEnable = -7,
  SSNetWorkCacheErrorInvalidCachePolicy = -8,
  SSNetWorkCacheErrorInvalidCacheType = -9,
  SSNetWorkCacheErrorInvalidCacheKey = -10
};
  
#define SSNetWorkEngineErrorDomain @"com.starshare.engine"
NS_ENUM(NSInteger) {
  SSNetWorkEngineErrorNone = -1024,
  SSNetWorkEngineErrorNilDomainBean = 1001,
  SSNetWorkEngineErrorDomainBeanInvalid = 1002,
  SSNetWorkEngineErrorNullPointer = 1003,
  SSNetWorkEngineErrorRequestUrlInvalid = 1004,
  SSNetWorkEngineErrorNetStatusCodeInvalid = 1005,
  SSNetWorkEngineErrorResponseStatusCodeInvalid = 1006,
  SSNetWorkEngineErrorResponseJSONInvalid = 1007,
  SSNetWorkEngineErrorRequestArgumentInvalid = 1008,
  SSNetWorkEngineErrorPostDataInvalid = 1009,
  SSNetWorkEngineErrorUploadDataInvalid = 1010
};

typedef void (^SSNetRequestProgressCallback)(NSProgress *uploadProgress);
typedef void (^SSNetRequestSuccessedCallback)(NSURLResponse * __unused response,id responseObject);
typedef void (^SSNetRequestFailedCallback)(NSURLResponse * __unused response, id responseObject,NSError *error);
typedef void (^SSNetDownloadCompleteCallback)(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error);
typedef void (^SSNetDownloadProgressCallback)(NSProgress *downloadProgress);
  
typedef void (^SSNetEngineRequestBeanBeginBlock)(void);
typedef void (^SSNetEngineRequestBeanEndBlock)(void);
typedef void (^SSNetEngineRequestBeanSuccessedBlock)(id requestDomainBean,id respondDomainBean,BOOL dataFromCache);
typedef void (^SSNetEngineRequestBeanFailedBlock)(id requestDomainBean,id respondDomainBean,NSError *error);
