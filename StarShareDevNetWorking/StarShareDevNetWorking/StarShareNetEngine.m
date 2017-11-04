//
//  StarShareNetEngine.m
//  StarShareDevNetWorking
//
//  Created by BUBUKO on 2017/10/27.
//  Copyright © 2017年 BUBUKO. All rights reserved.
//

#import <objc/runtime.h>
#import "StarShareNetEngine.h"
#import "SSNetWorkEngine.h"
#import "SSNetWorkEngineHandle.h"
#import "SSNetworkConfig.h"
#import "SSNetworkUtils.h"
#import "SSNetWorkCachePolocy.h"
#import "SSNetWorkCacheEngine.h"
#import "SSNetDomainBeanRequest.h"
#import "SSNetDomainBeanResponse.h"
#import "SSNetWorkCacheHandle.h"
#import "SSNetDomainBeanRequest.h"
#import "SSNetDomainBeanResponse.h"

@interface SSNetDomainBeanRequest (Private_Status)
@property (nonatomic, assign) BOOL isExecuting;
@property (nonatomic, assign) BOOL isFirstRequested;
@end
static char *ExecutingKey = "ExecutingKey";
static char *FirstRequested = "FirstRequested";
@implementation SSNetDomainBeanRequest (Private_Status)
- (void)setIsExecuting:(BOOL)isExecuting
{
  objc_setAssociatedObject(self, ExecutingKey, @(isExecuting), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)isExecuting
{
  id obj = objc_getAssociatedObject(self, ExecutingKey);
  return obj ? [obj boolValue] : NO;
}
- (void)setIsFirstRequested:(BOOL)isFirstRequested
{
  objc_setAssociatedObject(self, FirstRequested, @(isFirstRequested), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)isFirstRequested
{
  id obj = objc_getAssociatedObject(self, FirstRequested);
  return obj ? [obj boolValue] : NO;
}
@end

@interface StarShareNetEngine ()
@property (nonatomic, strong) SSNetWorkEngine *netWorkEngine;
@property (nonatomic, strong) SSNetWorkCacheEngine *cacheEngine;
@property (nonatomic, strong) SSNetworkConfig *private_engineConfigation;
@end

@implementation StarShareNetEngine

- (instancetype)init
{
  if (self = [super init]) {
    self.netWorkEngine = SSNetWorkEngine.alloc.init;
    self.cacheEngine = SSNetWorkCacheEngine.alloc.init;
    self.private_engineConfigation = [SSNetworkConfig sharedConfig];
  }
  
  return self;
}

+ (instancetype)sharedInstance {
  static id singletonInstance = nil;
  static dispatch_once_t pred;
  dispatch_once(&pred, ^{singletonInstance = [[self alloc] init];});
  return singletonInstance;
}

+ (void)setupEngineConfigation:(SSNetworkConfig *)configation
{
  if (configation) {
    [StarShareNetEngine sharedInstance].private_engineConfigation = configation;;
  }
}

- (SSNetworkConfig *)engineConfigation
{
  return self.private_engineConfigation;
}

- (id<SSNetRequestHandleProtocol>)excuteWithRequestBean:(in SSNetDomainBeanRequest *)requestBean
                                           responseBean:(in SSNetDomainBeanResponse *)responseBean
{
  return [self excuteWithRequestBean:requestBean
                        responseBean:responseBean
                           successed:nil
                              failed:nil];
}

- (id<SSNetRequestHandleProtocol>)excuteWithRequestBean:(in SSNetDomainBeanRequest *)requestBean
                                           responseBean:(in SSNetDomainBeanResponse *)responseBean
                                              successed:(in SSNetEngineRequestBeanSuccessedBlock)successed
                                                 failed:(in SSNetEngineRequestBeanFailedBlock)failed
{
  return [self excuteWithRequestBean:requestBean
                        responseBean:responseBean
                               begin:nil
                           successed:successed
                              failed:failed
                                 end:nil];
}

- (id<SSNetRequestHandleProtocol>)excuteWithRequestBean:(in SSNetDomainBeanRequest *)requestBean
                                           responseBean:(in SSNetDomainBeanResponse *)responseBean
                                                  begin:(in SSNetEngineRequestBeanBeginBlock)begin
                                              successed:(in SSNetEngineRequestBeanSuccessedBlock)successed
                                                 failed:(in SSNetEngineRequestBeanFailedBlock)failed
                                                    end:(in SSNetEngineRequestBeanEndBlock)end
{
  
  if (begin != NULL) {
    begin();
  }
  
  NSError *verificationError = nil;
  
  do {
    
    ///< 入参内容是否有值检测
    if (requestBean == nil || responseBean == nil) {
      verificationError = [NSError errorWithDomain:SSNetWorkEngineErrorDomain
                                              code:SSNetWorkEngineErrorNilArgument
                                          userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"网络请求：%@ 请求对象不能为空！",requestBean]}];
      break;
    }
    
    ///< 入参合法性检测
    if (![requestBean isKindOfClass:[SSNetDomainBeanRequest class]] ||
        ![responseBean isKindOfClass:[SSNetDomainBeanResponse class]]) {
      verificationError = [NSError errorWithDomain:SSNetWorkEngineErrorDomain
                                              code:SSNetWorkEngineErrorIllegalArgument
                                          userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"网络请求：%@ 请求对象不合法！",requestBean]}];
      break;
    }
    
    if (requestBean.isExecuting) {
      SSNetWorkLog(@"%@ -> is Executing!",requestBean);
      return [[SSNetWorkEngineHandleNilObject alloc] init];
    }
    
    ///< 拼接请求链接
    NSString * requestUrlString = nil;
    SS_SAFE_SEND_MESSAGE(requestBean, requestUrlMosaicWithRequestBean:error:){
      requestUrlString = [requestBean requestUrlMosaicWithRequestBean:requestBean error:&verificationError];
    };
    if (verificationError) break;
    
    NSDictionary *fullParams = nil;
    ///< 请求参数过滤
    SS_SAFE_SEND_MESSAGE(requestBean, requestArgumentMapWithArguments:error:){
      fullParams = [requestBean requestArgumentMapWithArguments:fullParams error:&verificationError];
    };
    if (verificationError) break;
    
    ///< 拼接请求参数
    SS_SAFE_SEND_MESSAGE(requestBean, requestArgumentMosaicWithRequestBean:error:){
      fullParams = [requestBean requestArgumentMosaicWithRequestBean:requestBean error:&verificationError];
    };
    if (verificationError) break;
    
    ///< 安全政策
    id securityPolicy = nil;
    SS_SAFE_SEND_MESSAGE(requestBean, securityPolicy){
      securityPolicy = [requestBean securityPolicy];
    };
    
    ///< 请求方法
    SSNetRequestMethod method = SSNetRequestMethodGET;
    SS_SAFE_SEND_MESSAGE(requestBean, requestMethod){
      method = [requestBean requestMethod];
    };
    
    ///< 请求序列化
    SSNetRequestSerializer requestSerializer = SSNetRequestSerializerHTTP;
    SS_SAFE_SEND_MESSAGE(requestBean, requestSerializerType){
      requestSerializer = [requestBean requestSerializerType];
    };
    
    ///< 响应序列化
    SSNetResponseSerializer responseSerializer = SSNetResponseSerializerJSON;
    SS_SAFE_SEND_MESSAGE(requestBean, responseSerializerType){
      responseSerializer = [requestBean responseSerializerType];
    };
    
    ///< 请求优先级
    SSNetRequestPriority priority = SSNetRequestPriorityNormal;
    SS_SAFE_SEND_MESSAGE(requestBean, requestPriority){
      priority = [requestBean requestPriority];
    };
    
    ///< 服务器认证信息
    NSArray *authorization = @[];
    SS_SAFE_SEND_MESSAGE(requestBean, requestAuthorizationHeaderFieldArray){
      authorization = [requestBean requestAuthorizationHeaderFieldArray];
    };
    
    ///< 请求头
    NSDictionary *headers = @{};
    SS_SAFE_SEND_MESSAGE(requestBean, requestHeaderFieldValueDictionary){
      headers = [requestBean requestHeaderFieldValueDictionary];
    };
    
    ///< POST Data
    SSNetRequestData *data = nil;
    SS_SAFE_SEND_MESSAGE(requestBean, requestData){
      data = [requestBean requestData];
    };
    if(data != nil && ![data isKindOfClass:[SSNetRequestData class]]){
      verificationError = [NSError errorWithDomain:SSNetWorkEngineErrorDomain
                                              code:SSNetWorkEngineErrorMethodReturnValueInvalid
                                          userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"网络请求：%@ POST 数据不合法！",requestBean]}];
      break;
    }
    
    ///< 请求过期时间
    NSTimeInterval timeout = 0;
    SS_SAFE_SEND_MESSAGE(requestBean, timeoutInterval){
      timeout = [requestBean timeoutInterval];
    };
    if(timeout <= 0) timeout = self.engineConfigation.timeoutInterval;
    if(timeout <= 0) timeout = 60;
    
    ///< 是否允许使用蜂窝数据
    BOOL allowsCellularAccess = YES;
    SS_SAFE_SEND_MESSAGE(requestBean, allowsCellularAccess){
      allowsCellularAccess = [requestBean allowsCellularAccess];
    };
    
    ///< 数据缓存策略
    id<SSNetRequestCachePolocyProtocol> cachePolocy = nil;
    SS_SAFE_SEND_MESSAGE(requestBean, cachePolocy){
      cachePolocy = [requestBean cachePolocy];
    }
    if (cachePolocy == nil) cachePolocy = [[SSNetWorkCachePolocy alloc] init];
    
    ///< 是否支持缓存
    BOOL cacheEnable = NO;
    SS_SAFE_SEND_MESSAGE(cachePolocy, needCacheWithRequestBean:){
      cacheEnable = [cachePolocy needCacheWithRequestBean:requestBean];
    }
    
    ///< 缓存数据读取策略
    SSNetRequestReadCachePolicy readCachePolicy = SSNetRequestReadCacheFirst;
    SS_SAFE_SEND_MESSAGE(cachePolocy, readCachePolicyWithRequestBean:){
      readCachePolicy = [cachePolocy readCachePolicyWithRequestBean:requestBean];
    }
    
    ///< 读取缓存数据
    id cacheData = nil;
    if (cacheEnable && (readCachePolicy == SSNetRequestReadCacheEver || (readCachePolicy == SSNetRequestReadCacheFirst && requestBean.isFirstRequested == NO))) {
      NSError *cacheError;
      id<SSNetWorkCacheHandleProtocol> cacheHandle =
      [self.cacheEngine readCacheWithRequestBean:requestBean
                                           error:&cacheError];
      if (cacheError) {
        SSNetWorkLog(@"StarShareDevNetWorking -> readCache Error : %@",cacheError.localizedDescription);
      }else{
        cacheData = [cacheHandle cacheData];
        SSNetWorkLog(@"StarShareDevNetWorking -> readCache Data %@!",cacheData != nil ? @"Success" : @"Failed");
      }
    }
    
    SSNetWorkLog(@"\n############################# \nRequest: %@ \nMethod: %@ \nParams: %@ \nPriority: %@ \nHeaders: %@ \nTimeout: %@ \nAllowsCellularAccess: %@ \nCacheEnable: %@ \nReadCachePolicy: %@ \nCachePolicy: %@ \nDataFromCache: %@ \n#############################",
                 requestUrlString,
                 [SSNetworkUtils requestMethod:method],
                 fullParams,
                 [SSNetworkUtils requestPriority:priority],
                 headers,
                 @(timeout),
                 BOOL_STRING(allowsCellularAccess),
                 BOOL_STRING(cacheEnable),
                 [SSNetworkUtils readCachePolicy:[cachePolocy readCachePolicyWithRequestBean:requestBean]],
                 [SSNetworkUtils cachePolicy:[cachePolocy cachePolicyWithRequestBean:requestBean]],
                 BOOL_STRING(cacheEnable && cacheData != nil));
    
    ///< 读取缓存的策略是只有第一次请求读取缓存，并且是第一次请求，并且读取到了缓存数据，并且支持缓存
    if (readCachePolicy == SSNetRequestReadCacheFirst && cacheData && requestBean.isFirstRequested == NO) {
      
      responseBean.responseObject = cacheData;
      responseBean.dataFromCache = YES;
      requestBean.isFirstRequested = YES;
      
      ///< 告诉请求完成，进行模型解析等操作
      SS_SAFE_SEND_MESSAGE(responseBean, complementWithRequestBean:respondBean:isDataFromCache:){
        [responseBean complementWithRequestBean:requestBean respondBean:responseBean isDataFromCache:YES];
      }
      
      if (successed) {
        successed(requestBean,responseBean,YES);
      }
      
      if (end != NULL) {
        end();
      }
      return [[SSNetWorkEngineHandleNilObject alloc] init];
    }
    
    ///< 读取缓存的策略是每次都读取缓存，并且读取到了缓存数据
    if (readCachePolicy == SSNetRequestReadCacheEver && cacheData) {
      
      responseBean.responseObject = cacheData;
      responseBean.dataFromCache = YES;
      requestBean.isFirstRequested = YES;
      
      ///< 告诉请求完成，进行模型解析等操作
      SS_SAFE_SEND_MESSAGE(responseBean, complementWithRequestBean:respondBean:isDataFromCache:){
        [responseBean complementWithRequestBean:requestBean respondBean:responseBean isDataFromCache:YES];
      }
      
      if (successed) {
        successed(requestBean,responseBean,YES);
      }
      
    }
    
    ///< 读取缓存的策略是从来都不读取缓存数据，不做任何处理，直接请求网络最新数据
    if (readCachePolicy == SSNetRequestReadCacheNever) {
      
    }
    
    __block SSNetDomainBeanRequest *domainBeanRequest = requestBean;
    __block SSNetDomainBeanResponse *domainBeanResponse = responseBean;
    
    SSNetRequestSuccessedCallback requestSuccess = ^(NSURLResponse *response, id responseObject){
      
      domainBeanResponse.response = response;
      domainBeanResponse.responseObject = responseObject;
      domainBeanResponse.dataFromCache = NO;
      domainBeanRequest.isExecuting = NO;
      domainBeanRequest.isFirstRequested = YES;
      
      NSError *validatError = nil;
      
      do {
        
        ///< 网络请求状态码校验
        BOOL statusCodeValidator = NO;
        SS_SAFE_SEND_MESSAGE(domainBeanRequest, statusCodeValidator:){
          statusCodeValidator = [domainBeanRequest statusCodeValidator:response];
        }
        if (!statusCodeValidator) {
          validatError = [NSError errorWithDomain:SSNetWorkEngineErrorDomain
                                             code:SSNetWorkEngineErrorNetResponseBeanInvalid
                                         userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"网络请求：%@ 网络请求状态码校验失败！",requestBean]}];
          break;
        }
        
        ///< 校验响应数据 json 合法性
        id json = responseObject;
        id strusValidator = nil;
        id strusAndValueValidator = nil;
        SS_SAFE_SEND_MESSAGE(domainBeanResponse, jsonStrucValidator){
          strusValidator = [domainBeanResponse jsonStrucValidator];
        };
        SS_SAFE_SEND_MESSAGE(domainBeanResponse, jsonStrucAndValueValidator){
          strusAndValueValidator = [domainBeanResponse jsonStrucAndValueValidator];
        };
        if (json && strusAndValueValidator) {
          BOOL result = [SSNetworkUtils validateJSONValue:json withValidator:strusAndValueValidator];
          if (!result) {
            validatError = [NSError errorWithDomain:SSNetWorkEngineErrorDomain
                                               code:SSNetWorkEngineErrorNetResponseBeanInvalid
                                           userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"网络请求：%@ JSON 结构和值校验失败！",requestBean]}];
            break;
          }
        }else if (json && strusValidator){
          BOOL result = [SSNetworkUtils validateJSONStruc:json withValidator:strusValidator];
          if (!result) {
            validatError = [NSError errorWithDomain:SSNetWorkEngineErrorDomain
                                               code:SSNetWorkEngineErrorNetResponseBeanInvalid
                                           userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"网络请求：%@ JSON 结构校验失败！",requestBean]}];
            break;
          }
        }
        
        ///< 数据缓存处理
        id<SSNetRequestCachePolocyProtocol> cachePolocy = nil;
        SS_SAFE_SEND_MESSAGE(domainBeanRequest, cachePolocy){
          cachePolocy = [domainBeanRequest cachePolocy];
        }
        if (cachePolocy == nil) cachePolocy = [[SSNetWorkCachePolocy alloc] init];
        
        ///< 是否支持缓存
        BOOL cacheEnable = NO;
        SS_SAFE_SEND_MESSAGE(cachePolocy, needCacheWithRequestBean:){
          cacheEnable = [cachePolocy needCacheWithRequestBean:domainBeanRequest];
        }
        
        if (cacheEnable) {
          NSError *cacheError;
          id<SSNetWorkCacheHandleProtocol> cacheHandle =
          [self.cacheEngine writeCacheWithRequestBean:domainBeanRequest
                                       responseObject:domainBeanResponse.responseObject
                                                error:&cacheError];
          if (cacheError) {
            SSNetWorkLog(@"StarShareDevNetWorking -> writeCache Error : %@",cacheError.localizedDescription);
          }else{
            [cacheHandle cacheData];
            SSNetWorkLog(@"StarShareDevNetWorking -> writeCache data Success!");
          }
        }
        
        ///< 告诉请求完成，进行模型解析等操作
        SS_SAFE_SEND_MESSAGE(domainBeanResponse, complementWithRequestBean:respondBean:isDataFromCache:){
          [domainBeanResponse complementWithRequestBean:domainBeanRequest respondBean:domainBeanResponse isDataFromCache:NO];
        }
        
        if (successed != NULL) {
          if ([NSThread currentThread] != [NSThread mainThread]) {
            dispatch_sync(dispatch_get_main_queue(), ^{
              successed(domainBeanRequest,domainBeanResponse,NO);
            });
          }
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
          if (end != NULL) {
            end();
          }
        });
        
        return ;
        
      } while (NO);
      
      if (failed != NULL) {
        if ([NSThread currentThread] != [NSThread mainThread]) {
          dispatch_sync(dispatch_get_main_queue(), ^{
            failed(domainBeanRequest,domainBeanResponse,validatError);
          });
        }
      }
      
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (end != NULL) {
          end();
        }
      });

    };
    
    ///< 请求句柄
    requestBean.isExecuting = YES;
    id<SSNetRequestHandleProtocol> requestHandle = [self.netWorkEngine requestWithUrlString:requestUrlString
                                                                             securityPolicy:securityPolicy
                                                                                     method:method
                                                                          requestSerializer:requestSerializer
                                                                         responseSerializer:responseSerializer
                                                                                   priority:priority
                                                                              authorization:authorization
                                                                                    headers:headers
                                                                                   argument:fullParams
                                                                                       data:data
                                                                                    timeout:timeout
                                                                       allowsCellularAccess:allowsCellularAccess
                                                                                    success:requestSuccess
                                                                                    failure:^(NSURLResponse *response, id responseObject, NSError *error) {
                                                                                      
                                                                                      domainBeanResponse.response = response;
                                                                                      domainBeanResponse.responseObject = responseObject;
                                                                                      domainBeanResponse.dataFromCache = NO;
                                                                                      domainBeanRequest.isExecuting = NO;
                                                                                      domainBeanRequest.isFirstRequested = YES;
                                                                                      
                                                                                      if (failed != NULL) {
                                                                                        if ([NSThread currentThread] != [NSThread mainThread]) {
                                                                                          dispatch_sync(dispatch_get_main_queue(), ^{
                                                                                            failed(domainBeanRequest,domainBeanResponse,error);
                                                                                          });
                                                                                        }
                                                                                      }
                                                                                      
                                                                                      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                                                        if (end != NULL) {
                                                                                          end();
                                                                                        }
                                                                                      });
                                                                                      
                                                                                    }];
    
    return requestHandle;
    
  } while (NO);
  
  ///< 出现错误结束请求
  if (failed != NULL) {
    failed(requestBean,responseBean,verificationError);
  }
  
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    if (end != NULL) {
      end();
    }
  });
  
  return [[SSNetWorkEngineHandleNilObject alloc] init];
}

@end
