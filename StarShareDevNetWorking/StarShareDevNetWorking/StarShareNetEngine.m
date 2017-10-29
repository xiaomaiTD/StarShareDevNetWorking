//
//  StarShareNetEngine.m
//  StarShareDevNetWorking
//
//  Created by BUBUKO on 2017/10/27.
//  Copyright © 2017年 BUBUKO. All rights reserved.
//

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

@interface StarShareNetEngine ()
@property (nonatomic, strong) SSNetWorkEngine *netWorkEngine;
@property (nonatomic, strong) SSNetWorkCacheEngine *cacheEngine;
@end

@implementation StarShareNetEngine

- (instancetype)init
{
  if (self = [super init]) {
    self.netWorkEngine = SSNetWorkEngine.alloc.init;
    self.cacheEngine = SSNetWorkCacheEngine.alloc.init;
  }
  
  return self;
}

+ (instancetype)sharedInstance {
  static id singletonInstance = nil;
  static dispatch_once_t pred;
  dispatch_once(&pred, ^{singletonInstance = [[self alloc] init];});
  return singletonInstance;
}

- (id<SSNetRequestHandleProtocol>)excuteWithRequestBean:(in id)requestBean
                                           responseBean:(in id)responseBean
{
  return [self excuteWithRequestBean:requestBean
                        responseBean:responseBean
                           successed:nil
                              failed:nil];
}

- (id<SSNetRequestHandleProtocol>)excuteWithRequestBean:(in id)requestBean
                                           responseBean:(in id)responseBean
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

- (id<SSNetRequestHandleProtocol>)excuteWithRequestBean:(in id)requestBean
                                           responseBean:(in id)responseBean
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
    
    ///< 拼接请求链接
    NSString * requestUrlString = nil;
    SS_SAFE_SEND_MESSAGE(requestBean, requestUrlMosaic:error:){
      requestUrlString = [requestBean requestUrlMosaic:requestBean error:&verificationError];
    };
    if (verificationError) break;
    
    ///< 拼接请求参数
    NSDictionary *fullParams = nil;
    SS_SAFE_SEND_MESSAGE(requestBean, requestArgumentMosaic:error:){
      fullParams = [requestBean requestArgumentMosaic:requestBean error:&verificationError];
    };
    if (verificationError) break;
    
    ///< 请求参数过滤
    SS_SAFE_SEND_MESSAGE(requestBean, requestArgumentFilter:error:){
      fullParams = [requestBean requestArgumentFilter:fullParams error:&verificationError];
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
    if(timeout <= 0) timeout = [SSNetworkConfig sharedConfig].timeoutInterval;
    if(timeout <= 0) timeout = 60;
    
    ///< 是否允许使用蜂窝数据
    BOOL allowsCellularAccess = YES;
    SS_SAFE_SEND_MESSAGE(requestBean, allowsCellularAccess){
      allowsCellularAccess = [requestBean allowsCellularAccess];
    };
    
    ///< 数据缓存处理
    id<SSNetRequestCachePolocyProtocol> cachePolocy = nil;
    SS_SAFE_SEND_MESSAGE(requestBean, cachePolocy){
      cachePolocy = [requestBean cachePolocy];
    }
    if (cachePolocy == nil) cachePolocy = [[SSNetWorkCachePolocy alloc] init];
    
    ///< 是否支持缓存
    BOOL cacheEnable = NO;
    SS_SAFE_SEND_MESSAGE(cachePolocy, needCache){
      cacheEnable = [cachePolocy needCache];
    }
    
    ///< 读取缓存数据
    id cacheData = nil;
    if (cacheEnable) {
      NSError *cacheError;
      id<SSNetWorkCacheHandleProtocol> cacheHandle =
      [self.cacheEngine readCacheWithPolocy:cachePolocy
                                requestBean:requestBean
                               responseBean:responseBean
                                      error:&cacheError];
      if (cacheError) {
        SSNetWorkLog(@"StarShareDevNetWorking -> readCache Error : %@",cacheError.localizedDescription);
      }else{
        cacheData = [cacheHandle cacheData];
        SSNetWorkLog(@"StarShareDevNetWorking -> readCache Data %@!",cacheData != nil ? @"Success" : @"Failed");
      }
      ((SSNetDomainBeanParent*)requestBean).cacheHandle = cacheHandle;
      ((SSNetDomainBeanParent*)responseBean).cacheHandle = cacheHandle;
    }
    
    ///< 返回缓存数据
    if (cacheData) {
      if (successed) {
        ((SSNetDomainBeanParent*)requestBean).responseObject = cacheData;
        ((SSNetDomainBeanParent*)requestBean).dataFromCache = YES;
        
        ((SSNetDomainBeanParent*)responseBean).responseObject = cacheData;
        ((SSNetDomainBeanParent*)responseBean).dataFromCache = YES;
        
        successed(requestBean,responseBean,YES);
      }
      if (end != NULL) {
        end();
      }
    }
    
    SSNetWorkLog(@"\n############################# \nRequest: %@ \nMethod: %@ \nParams: %@ \nPriority: %@ \nHeaders: %@ \nTimeout: %@ \nAllowsCellularAccess: %@ \nCacheEnable: %@ \nCachePolicy: %@ \nDataFromCache: %@ \n#############################",
                 requestUrlString,
                 [SSNetworkUtils requestMethod:method],
                 fullParams,
                 [SSNetworkUtils requestPriority:priority],
                 headers,
                 @(timeout),
                 BOOL_STRING(allowsCellularAccess),
                 BOOL_STRING(cacheEnable),
                 [SSNetworkUtils cachePolicy:[cachePolocy cachePolicy]],
                 BOOL_STRING(cacheEnable && cacheData != nil));
    
    
    __block SSNetDomainBeanParent <SSNetDomainRequestProtocol>*domainBeanRequest = requestBean;
    __block SSNetDomainBeanParent <SSNetDomainResponseProtocol>*domainBeanResponse = responseBean;
    
    SSNetRequestSuccessedCallback requestSuccess = ^(NSURLResponse *response, id responseObject){
      
      domainBeanRequest.response = response;
      domainBeanRequest.responseObject = responseObject;
      domainBeanRequest.dataFromCache = NO;
      
      domainBeanResponse.response = response;
      domainBeanResponse.responseObject = responseObject;
      domainBeanResponse.dataFromCache = NO;
      
      NSError *validatError = nil;
      
      do {
        
        ///< 网络状态吗校验
        BOOL statusCodeValidator = NO;
        SS_SAFE_SEND_MESSAGE(domainBeanRequest, statusCodeValidator){
          statusCodeValidator = [domainBeanRequest statusCodeValidator];
        }
        if (!statusCodeValidator) {
          validatError = [NSError errorWithDomain:SSNetWorkEngineErrorDomain
                                             code:SSNetWorkEngineErrorNetResponseBeanInvalid
                                         userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"网络请求：%@ 网络请求状态码校验失败！",requestBean]}];
          break;
        }
        
        ///< 校验响应数据 json 合法性
        id json = responseObject;
        id validator = nil;
        SS_SAFE_SEND_MESSAGE(domainBeanResponse, jsonValidator){
          validator = [domainBeanResponse jsonValidator];
        };
        if (json && validator) {
          BOOL result = [SSNetworkUtils validateJSON:json withValidator:validator];
          if (!result) {
            validatError = [NSError errorWithDomain:SSNetWorkEngineErrorDomain
                                               code:SSNetWorkEngineErrorNetResponseBeanInvalid
                                           userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"网络请求：%@ JSON 校验失败！",requestBean]}];
            break;
          }
        }
        
        ///< 校验 respondBean 合法性
        SS_SAFE_SEND_MESSAGE(domainBeanResponse, respondBeanValidity:error:){
          NSError *validityError = nil;
          BOOL result = [domainBeanResponse respondBeanValidity:domainBeanResponse error:&validityError];
          if (!result && validityError) {
            validatError = validityError;
            break;
          }
        };
        
        ///< 数据缓存处理
        id<SSNetRequestCachePolocyProtocol> cachePolocy = nil;
        SS_SAFE_SEND_MESSAGE(domainBeanRequest, cachePolocy){
          cachePolocy = [domainBeanRequest cachePolocy];
        }
        if (cachePolocy == nil) cachePolocy = [[SSNetWorkCachePolocy alloc] init];
        
        ///< 是否支持缓存
        BOOL cacheEnable = NO;
        SS_SAFE_SEND_MESSAGE(cachePolocy, needCache){
          cacheEnable = [cachePolocy needCache];
        }
        
        if (cacheEnable) {
          NSError *cacheError;
          id<SSNetWorkCacheHandleProtocol> cacheHandle =
          [self.cacheEngine writeCacheWithPolocy:cachePolocy
                                     requestBean:domainBeanRequest
                                    responseBean:domainBeanResponse
                                           error:&cacheError];
          if (cacheError) {
            SSNetWorkLog(@"StarShareDevNetWorking -> writeCache Error : %@",cacheError.localizedDescription);
          }else{
            SSNetWorkLog(@"StarShareDevNetWorking -> writeCache data %@!",cacheData != nil ? @"Success" : @"Failed");
          }
          domainBeanRequest.cacheHandle = cacheHandle;
          domainBeanResponse.cacheHandle = cacheHandle;
        }
        
        ///< 告诉请求完成，进行模型解析等操作
        SS_SAFE_SEND_MESSAGE(domainBeanResponse, respondBeanComplement:requestBean:){
          [domainBeanResponse respondBeanComplement:domainBeanResponse requestBean:domainBeanRequest];
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
                                                                                      
                                                                                      domainBeanRequest.response = response;
                                                                                      domainBeanRequest.responseObject = responseObject;
                                                                                      domainBeanRequest.dataFromCache = NO;
                                                                                      
                                                                                      domainBeanResponse.response = response;
                                                                                      domainBeanResponse.responseObject = responseObject;
                                                                                      domainBeanResponse.dataFromCache = NO;
                                                                                      
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
