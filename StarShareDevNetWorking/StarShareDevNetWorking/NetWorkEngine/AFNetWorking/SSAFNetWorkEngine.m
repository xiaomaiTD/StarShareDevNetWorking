//
//  SSAFNetWorkEngine.m
//  StarShareDevNetWorking
//
//  Created by BUBUKO on 2017/10/26.
//  Copyright © 2017年 BUBUKO. All rights reserved.
//

#import "SSAFNetWorkEngine.h"
#import "SSNetworkConfig.h"
#import "SSNetWorkEngineHandle.h"
#import "SSAFNetWorkEngineHandle.h"

@interface SSAFNetWorkEngine()
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (nonatomic, strong) AFHTTPResponseSerializer *httpResponseSerializer;
@property (nonatomic, strong) AFJSONResponseSerializer *jsonResponseSerializer;
@property (nonatomic, strong) AFXMLParserResponseSerializer *xmlParserResponseSerialzier;
@end

@implementation SSAFNetWorkEngine{
  dispatch_queue_t _processingQueue;
  NSIndexSet *_allStatusCodes;
}

#pragma mark - <Instancetype>

- (instancetype)init {
  if ((self = [super init])) {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    _manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
    
    _processingQueue = dispatch_queue_create("com.starshare.networkengine.processing", DISPATCH_QUEUE_CONCURRENT);
    _allStatusCodes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(100, 500)];
    
    _manager.responseSerializer = self.httpResponseSerializer;
    _manager.completionQueue = _processingQueue;
  }
  return self;
}

#pragma mark - <Serializer>

- (AFHTTPResponseSerializer *)httpResponseSerializer {
  if (!_httpResponseSerializer) {
    _httpResponseSerializer = [AFHTTPResponseSerializer serializer];
    _httpResponseSerializer.acceptableStatusCodes = _allStatusCodes;
  }
  return _httpResponseSerializer;
}

- (AFJSONResponseSerializer *)jsonResponseSerializer {
  if (!_jsonResponseSerializer) {
    _jsonResponseSerializer = [AFJSONResponseSerializer serializer];
    _jsonResponseSerializer.acceptableStatusCodes = _allStatusCodes;
  }
  return _jsonResponseSerializer;
}

- (AFXMLParserResponseSerializer *)xmlParserResponseSerialzier {
  if (!_xmlParserResponseSerialzier) {
    _xmlParserResponseSerialzier = [AFXMLParserResponseSerializer serializer];
    _xmlParserResponseSerialzier.acceptableStatusCodes = _allStatusCodes;
  }
  return _xmlParserResponseSerialzier;
}

#pragma mark - <SSNetRequestProtocol>

- (id<SSNetRequestHandleProtocol>)requestWithUrlString:(in NSString *)urlString
                                        securityPolicy:(in id)securityPolicy
                                                method:(in SSNetRequestMethod)method
                                     requestSerializer:(in SSNetRequestSerializer)requestSerializer
                                    responseSerializer:(in SSNetResponseSerializer)responseSerializer
                                              priority:(in SSNetRequestPriority)priority
                                         authorization:(in NSArray *)authorization
                                               headers:(in NSDictionary *)headers
                                              argument:(in id)argument
                                                  data:(in SSNetRequestData *)data
                                               timeout:(in NSTimeInterval)timeout
                                  allowsCellularAccess:(in BOOL)allowsCellularAccess
                                               success:(in SSNetRequestSuccessedCallback)success
                                               failure:(in SSNetRequestFailedCallback)failure
{
  
  if (securityPolicy != nil && [securityPolicy isKindOfClass:[AFSecurityPolicy class]]) {
    _manager.securityPolicy = securityPolicy;
  }
  
  NSError * __autoreleasing requestSerializationError = nil;
  NSURLSessionDataTask *task = [self sessionTaskForUrlString:urlString
                                                      method:method
                                           requestSerializer:requestSerializer
                                          responseSerializer:responseSerializer
                                               authorization:authorization
                                                     headers:headers
                                                    argument:argument
                                                        data:data
                                                     timeout:timeout
                                        allowsCellularAccess:allowsCellularAccess
                                                     success:success
                                                     failure:failure
                                                       error:&requestSerializationError];
  if (requestSerializationError) {
    if (failure) {
      failure(nil,nil,requestSerializationError);
    }
    return [[SSNetWorkEngineHandleNilObject alloc] init];
  }
  
  NSAssert(task != nil, @"requestTask should not be nil");
  
  if ([task respondsToSelector:@selector(priority)]) {
    switch (priority) {
      case SSNetRequestPriorityHigh:
      case SSNetRequestPriorityVeryHigh:
        task.priority = NSURLSessionTaskPriorityHigh;
        break;
      case SSNetRequestPriorityLow:
      case SSNetRequestPriorityVeryLow:
        task.priority = NSURLSessionTaskPriorityLow;
        break;
      case SSNetRequestPriorityNormal:
        /*!!fall through*/
      default:
        task.priority = NSURLSessionTaskPriorityDefault;
        break;
    }
  }
  
  [task resume];
  
  SSAFNetWorkEngineHandle *requestHandle = [[SSAFNetWorkEngineHandle alloc] initWithTask:task];
  
  return requestHandle;
}

#pragma mark - sessionTask

- (NSURLSessionDataTask *)sessionTaskForUrlString:(NSString *)urlString
                                           method:(SSNetRequestMethod)method
                                requestSerializer:(SSNetRequestSerializer)requestSerializer
                               responseSerializer:(SSNetResponseSerializer)responseSerializer
                                    authorization:(NSArray *)authorization
                                          headers:(NSDictionary *)headers
                                         argument:(id)argument
                                             data:(SSNetRequestData *)data
                                          timeout:(NSTimeInterval)timeout
                             allowsCellularAccess:(BOOL)allowsCellularAccess
                                          success:(SSNetRequestSuccessedCallback)success
                                          failure:(SSNetRequestFailedCallback)failure
                                            error:(NSError * _Nullable __autoreleasing *)error{
  
  AFHTTPRequestSerializer *AFRequestSerializer = [self requestSerializer:requestSerializer
                                                         timeoutInterval:timeout
                                                    allowsCellularAccess:allowsCellularAccess
                                                     authorizationHeader:authorization
                                                                 headers:headers];
  
  AFHTTPResponseSerializer *AFResponseSerializer = [self responseSerializer:responseSerializer];
  
  switch (method) {
    case SSNetRequestMethodGET:
      return [self dataTaskWithHTTPMethod:@"GET"
                        requestSerializer:AFRequestSerializer
                       responseSerializer:AFResponseSerializer
                                URLString:urlString
                                 argument:argument
                                  success:success
                                  failure:failure
                                    error:error];
    case SSNetRequestMethodPOST:
      return [self dataTaskWithHTTPMethod:@"POST"
                        requestSerializer:AFRequestSerializer
                       responseSerializer:AFResponseSerializer
                                URLString:urlString
                                 argument:argument
                                     data:data
                                  success:success
                                  failure:failure
                                    error:error];
    case SSNetRequestMethodHEAD:
      return [self dataTaskWithHTTPMethod:@"HEAD"
                        requestSerializer:AFRequestSerializer
                       responseSerializer:AFResponseSerializer
                                URLString:urlString
                                 argument:argument
                                  success:success
                                  failure:failure
                                    error:error];
    case SSNetRequestMethodPUT:
      return [self dataTaskWithHTTPMethod:@"PUT"
                        requestSerializer:AFRequestSerializer
                       responseSerializer:AFResponseSerializer
                                URLString:urlString
                                 argument:argument
                                  success:success
                                  failure:failure
                                    error:error];
    case SSNetRequestMethodDELETE:
      return [self dataTaskWithHTTPMethod:@"DELETE"
                        requestSerializer:AFRequestSerializer
                       responseSerializer:AFResponseSerializer
                                URLString:urlString
                                 argument:argument
                                  success:success
                                  failure:failure
                                    error:error];
    case SSNetRequestMethodPATCH:
      return [self dataTaskWithHTTPMethod:@"PATCH"
                        requestSerializer:AFRequestSerializer
                       responseSerializer:AFResponseSerializer
                                URLString:urlString
                                 argument:argument
                                  success:success
                                  failure:failure
                                    error:error];
    default:
      return nil;
  }
}

#pragma mark - data task

- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                               requestSerializer:(AFHTTPRequestSerializer *)requestSerializer
                              responseSerializer:(AFHTTPResponseSerializer *)responseSerializer
                                       URLString:(NSString *)URLString
                                        argument:(id)argument
                                         success:(SSNetRequestSuccessedCallback)success
                                         failure:(SSNetRequestFailedCallback)failure
                                           error:(NSError * _Nullable __autoreleasing *)error {
  return [self dataTaskWithHTTPMethod:method
                    requestSerializer:requestSerializer
                   responseSerializer:responseSerializer
                            URLString:URLString
                             argument:argument
                                 data:nil
                              success:success
                              failure:failure
                                error:error];
}

- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                               requestSerializer:(AFHTTPRequestSerializer *)requestSerializer
                              responseSerializer:(AFHTTPResponseSerializer *)responseSerializer
                                       URLString:(NSString *)URLString
                                        argument:(id)argument
                                            data:(SSNetRequestData *)data
                                         success:(SSNetRequestSuccessedCallback)success
                                         failure:(SSNetRequestFailedCallback)failure
                                           error:(NSError * _Nullable __autoreleasing *)error {
  NSMutableURLRequest *request = nil;
  id parameters = argument;
  if (data) {
    __block SSNetRequestData *requestData = data;
    request = [requestSerializer multipartFormRequestWithMethod:method
                                                      URLString:URLString
                                                     parameters:parameters
                                      constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                                        if (requestData.type == SSNetRequestDataTypeFile && requestData.data != nil) {
                                          [formData appendPartWithFileData:requestData.data
                                                                      name:requestData.name
                                                                  fileName:requestData.fileName
                                                                  mimeType:requestData.mimeType];
                                        }
                                        if (requestData.type == SSNetRequestDataTypeForm && requestData.data != nil) {
                                          [formData appendPartWithFormData:requestData.data
                                                                      name:requestData.name];
                                        }
                                        if (requestData.type == SSNetRequestDataTypeFileUrl && requestData.fileUrl != nil) {
                                          [formData appendPartWithFileURL:requestData.fileUrl
                                                                     name:requestData.name
                                                                 fileName:requestData.fileName
                                                                 mimeType:requestData.mimeType
                                                                    error:nil];
                                        }
                                      }
                                                          error:error];
  } else {
    request = [requestSerializer requestWithMethod:method
                                         URLString:URLString
                                        parameters:parameters
                                             error:error];
  }
  
  __block NSURLSessionDataTask *dataTask = nil;
  dataTask = [_manager dataTaskWithRequest:request
                         completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *_error) {
                           if (_error && failure) {
                             failure(response,responseObject,_error);
                           }
                           if (!_error && success) {
                             
                             NSError * __autoreleasing serializationError = nil;
                             
                             if ([responseObject isKindOfClass:[NSData class]]) {
                               if ([responseSerializer isKindOfClass:[AFJSONResponseSerializer class]]) {
                                 responseObject = [(AFJSONResponseSerializer *)responseSerializer responseObjectForResponse:response
                                                                                                                       data:responseObject
                                                                                                                      error:&serializationError];
                               }
                               if ([responseSerializer isKindOfClass:[AFXMLParserResponseSerializer class]]) {
                                 responseObject = [(AFXMLParserResponseSerializer *)responseSerializer responseObjectForResponse:response
                                                                                                                            data:responseObject
                                                                                                                           error:&serializationError];
                               }
                             }
                             
                             if (serializationError) {
                               if (failure) {
                                 failure(response,responseObject,serializationError);
                               }
                             }else{
                               success(response,responseObject);
                             }
                             
                           }
                         }];
  
  return dataTask;
}

#pragma mark - requestSerializer

- (AFHTTPRequestSerializer *)requestSerializer:(SSNetRequestSerializer)serializer
                               timeoutInterval:(NSTimeInterval)timeoutInterval
                          allowsCellularAccess:(BOOL)allowsCellularAccess
                           authorizationHeader:(NSArray *)authorizationHeader
                                       headers:(NSDictionary *)headers
{
  AFHTTPRequestSerializer *requestSerializer = nil;
  if (serializer == SSNetRequestSerializerHTTP) {
    requestSerializer = [AFHTTPRequestSerializer serializer];
  }else if (serializer == SSNetRequestSerializerJSON) {
    requestSerializer = [AFJSONRequestSerializer serializer];
  }else if (serializer == SSNetRequestSerializerPropertyList) {
    requestSerializer = [AFPropertyListRequestSerializer serializer];
  }
  
  requestSerializer.timeoutInterval = timeoutInterval;
  requestSerializer.allowsCellularAccess = allowsCellularAccess;
  
  // If api needs server username and password
  NSArray<NSString *> *authorizationHeaderFieldArray = authorizationHeader;
  if (authorizationHeaderFieldArray != nil && authorizationHeaderFieldArray.count == 2) {
    [requestSerializer setAuthorizationHeaderFieldWithUsername:authorizationHeaderFieldArray.firstObject
                                                      password:authorizationHeaderFieldArray.lastObject];
  }
  
  // If api needs to add custom value to HTTPHeaderField
  NSDictionary<NSString *, NSString *> *headerFieldValueDictionary = headers;
  if (headerFieldValueDictionary != nil) {
    for (NSString *httpHeaderField in headerFieldValueDictionary.allKeys) {
      NSString *value = headerFieldValueDictionary[httpHeaderField];
      [requestSerializer setValue:value forHTTPHeaderField:httpHeaderField];
    }
  }
  return requestSerializer;
}

#pragma mark - responseSerializer

- (AFHTTPResponseSerializer *)responseSerializer:(SSNetResponseSerializer)serializer
{
  if (serializer == SSNetResponseSerializerJSON) {
    return self.jsonResponseSerializer;
  }else if (serializer == SSNetResponseSerializerXMLParser){
    return self.xmlParserResponseSerialzier;
  }else{
    return self.httpResponseSerializer;
  }
}

@end
