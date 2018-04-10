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
#import "SSNetworkUtils.h"

#define kStarShareNetworkIncompleteDownloadFolderName @"Incomplete"

@interface SSAFNetWorkEngine()
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (nonatomic, strong) AFHTTPResponseSerializer *httpResponseSerializer;
@property (nonatomic, strong) AFJSONResponseSerializer *jsonResponseSerializer;
@property (nonatomic, strong) AFXMLParserResponseSerializer *xmlParserResponseSerialzier;
@end

@implementation SSAFNetWorkEngine{
  dispatch_queue_t _processingQueue;
  NSIndexSet *_allStatusCodes;
  NSSet <NSString *> *_allContentTypes;
}

#pragma mark - <Instancetype>

- (instancetype)init {
  if ((self = [super init])) {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    _manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
    
    _processingQueue = dispatch_queue_create("com.starshare.networkengine.processing", DISPATCH_QUEUE_CONCURRENT);
    _allStatusCodes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(100, 500)];
    _allContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",  @"text/html",nil];
    
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
    _httpResponseSerializer.acceptableContentTypes = _allContentTypes;
  }
  return _httpResponseSerializer;
}

- (AFJSONResponseSerializer *)jsonResponseSerializer {
  if (!_jsonResponseSerializer) {
    _jsonResponseSerializer = [AFJSONResponseSerializer serializer];
    _jsonResponseSerializer.acceptableStatusCodes = _allStatusCodes;
    _jsonResponseSerializer.acceptableContentTypes = _allContentTypes;
  }
  return _jsonResponseSerializer;
}

- (AFXMLParserResponseSerializer *)xmlParserResponseSerialzier {
  if (!_xmlParserResponseSerialzier) {
    _xmlParserResponseSerialzier = [AFXMLParserResponseSerializer serializer];
    _xmlParserResponseSerialzier.acceptableStatusCodes = _allStatusCodes;
    _xmlParserResponseSerialzier.acceptableContentTypes = _allContentTypes;
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
                                              progress:(in SSNetRequestProgressCallback)progress
                                               success:(in SSNetRequestSuccessedCallback)success
                                               failure:(in SSNetRequestFailedCallback)failure {
  
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
                                                    progress:progress
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

- (id<SSNetRequestHandleProtocol>)downloadWithUrlString:(in NSString *)urlString
                                         securityPolicy:(in id)securityPolicy
                                      requestSerializer:(in SSNetRequestSerializer)requestSerializer
                                               priority:(in SSNetRequestPriority)priority
                                          authorization:(in NSArray *)authorization
                                                headers:(in NSDictionary *)headers
                                               argument:(in id)argument
                                  resumableDownloadPath:(in NSString*)resumableDownloadPath
                                                timeout:(in NSTimeInterval)timeout
                                   allowsCellularAccess:(in BOOL)allowsCellularAccess
                                               progress:(in SSNetDownloadProgressCallback)progress
                                               complete:(in SSNetDownloadCompleteCallback)complete
                                                failure:(in SSNetRequestFailedCallback)failure
{
  if (securityPolicy != nil && [securityPolicy isKindOfClass:[AFSecurityPolicy class]]) {
    _manager.securityPolicy = securityPolicy;
  }
  
  NSError * __autoreleasing requestSerializationError = nil;
  NSURLSessionDataTask *task = [self sessionTaskForUrlString:urlString
                                           requestSerializer:requestSerializer
                                               authorization:authorization
                                                     headers:headers
                                                    argument:argument
                                                     timeout:timeout
                                       resumableDownloadPath:resumableDownloadPath
                                        allowsCellularAccess:allowsCellularAccess
                                                    progress:progress
                                                    complete:complete
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
                                         progress:(SSNetRequestProgressCallback)progress
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
                                     data:data
                                 progress:progress
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
                                 progress:progress
                                  success:success
                                  failure:failure
                                    error:error];
    case SSNetRequestMethodHEAD:
      return [self dataTaskWithHTTPMethod:@"HEAD"
                        requestSerializer:AFRequestSerializer
                       responseSerializer:AFResponseSerializer
                                URLString:urlString
                                 argument:argument
                                     data:data
                                 progress:progress
                                  success:success
                                  failure:failure
                                    error:error];
    case SSNetRequestMethodPUT:
      return [self dataTaskWithHTTPMethod:@"PUT"
                        requestSerializer:AFRequestSerializer
                       responseSerializer:AFResponseSerializer
                                URLString:urlString
                                 argument:argument
                                     data:data
                                 progress:progress
                                  success:success
                                  failure:failure
                                    error:error];
    case SSNetRequestMethodDELETE:
      return [self dataTaskWithHTTPMethod:@"DELETE"
                        requestSerializer:AFRequestSerializer
                       responseSerializer:AFResponseSerializer
                                URLString:urlString
                                 argument:argument
                                     data:data
                                 progress:progress
                                  success:success
                                  failure:failure
                                    error:error];
    case SSNetRequestMethodPATCH:
      return [self dataTaskWithHTTPMethod:@"PATCH"
                        requestSerializer:AFRequestSerializer
                       responseSerializer:AFResponseSerializer
                                URLString:urlString
                                 argument:argument
                                     data:data
                                 progress:progress
                                  success:success
                                  failure:failure
                                    error:error];
    default:
      return nil;
  }
}

- (NSURLSessionDataTask *)sessionTaskForUrlString:(NSString *)urlString
                                requestSerializer:(SSNetRequestSerializer)requestSerializer
                                    authorization:(NSArray *)authorization
                                          headers:(NSDictionary *)headers
                                         argument:(id)argument
                                          timeout:(NSTimeInterval)timeout
                            resumableDownloadPath:(NSString*)resumableDownloadPath
                             allowsCellularAccess:(BOOL)allowsCellularAccess
                                         progress:(SSNetDownloadProgressCallback)progress
                                         complete:(SSNetDownloadCompleteCallback)complete
                                          failure:(SSNetRequestFailedCallback)failure
                                            error:(NSError * _Nullable __autoreleasing *)error {
  AFHTTPRequestSerializer *AFRequestSerializer = [self requestSerializer:requestSerializer
                                                         timeoutInterval:timeout
                                                    allowsCellularAccess:allowsCellularAccess
                                                     authorizationHeader:authorization
                                                                 headers:headers];
  
  return (NSURLSessionDataTask *)[self dataTaskWithDownloadPath:resumableDownloadPath
                                              requestSerializer:AFRequestSerializer
                                                      URLString:urlString
                                                     parameters:argument
                                                       progress:progress
                                                       complete:complete
                                                          error:error];
}

#pragma mark - data task

- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                               requestSerializer:(AFHTTPRequestSerializer *)requestSerializer
                              responseSerializer:(AFHTTPResponseSerializer *)responseSerializer
                                       URLString:(NSString *)URLString
                                        argument:(id)argument
                                            data:(SSNetRequestData *)data
                                        progress:(SSNetRequestProgressCallback)progress
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
                            uploadProgress:progress
                          downloadProgress:nil
                         completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable _error) {
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

- (NSURLSessionDownloadTask *)dataTaskWithDownloadPath:(NSString *)downloadPath
                                     requestSerializer:(AFHTTPRequestSerializer *)requestSerializer
                                             URLString:(NSString *)URLString
                                            parameters:(id)parameters
                                              progress:(SSNetDownloadProgressCallback)progress
                                              complete:(SSNetDownloadCompleteCallback)complete
                                                 error:(NSError * _Nullable __autoreleasing *)error {
  NSMutableURLRequest *urlRequest = [requestSerializer requestWithMethod:@"GET"
                                                               URLString:URLString
                                                              parameters:parameters
                                                                   error:error];
  
  NSString *downloadTargetPath;
  BOOL isDirectory;
  if(![[NSFileManager defaultManager] fileExistsAtPath:downloadPath isDirectory:&isDirectory]) {
    isDirectory = NO;
  }
  
  if (isDirectory) {
    NSString *fileName = [urlRequest.URL lastPathComponent];
    downloadTargetPath = [NSString pathWithComponents:@[downloadPath, fileName]];
  } else {
    downloadTargetPath = downloadPath;
  }
  
  if ([[NSFileManager defaultManager] fileExistsAtPath:downloadTargetPath]) {
    [[NSFileManager defaultManager] removeItemAtPath:downloadTargetPath error:nil];
  }
  
  BOOL resumeDataFileExists = [[NSFileManager defaultManager] fileExistsAtPath:[self incompleteDownloadTempPathForDownloadPath:downloadPath].path];
  NSData *data = [NSData dataWithContentsOfURL:[self incompleteDownloadTempPathForDownloadPath:downloadPath]];
  BOOL resumeDataIsValid = [SSNetworkUtils validateResumeData:data];
  
  BOOL canBeResumed = resumeDataFileExists && resumeDataIsValid;
  BOOL resumeSucceeded = NO;
  __block NSURLSessionDownloadTask *downloadTask = nil;
  
  if (canBeResumed) {
    @try {
      downloadTask = [_manager downloadTaskWithResumeData:data
                                                 progress:progress
                                              destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                                                return [NSURL fileURLWithPath:downloadTargetPath isDirectory:NO];
                                              } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                                                if (complete) {
                                                  complete(response,filePath,error);
                                                }
                                              }];
      resumeSucceeded = YES;
    } @catch (NSException *exception) {
      SSNetWorkLog(@"Resume download failed, reason = %@", exception.reason);
      resumeSucceeded = NO;
    }
  }
  
  if (!resumeSucceeded) {
    downloadTask = [_manager downloadTaskWithRequest:urlRequest
                                            progress:progress
                                         destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                                           return [NSURL fileURLWithPath:downloadTargetPath isDirectory:NO];
                                         } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                                           if (complete) {
                                             complete(response,filePath,error);
                                           }
                                         }];
  }
  return downloadTask;
}

#pragma mark - Resumable Download

- (NSString *)incompleteDownloadTempCacheFolder {
  NSFileManager *fileManager = [NSFileManager new];
  static NSString *cacheFolder;
  
  if (!cacheFolder) {
    NSString *cacheDir = NSTemporaryDirectory();
    cacheFolder = [cacheDir stringByAppendingPathComponent:kStarShareNetworkIncompleteDownloadFolderName];
  }
  
  NSError *error = nil;
  if(![fileManager createDirectoryAtPath:cacheFolder withIntermediateDirectories:YES attributes:nil error:&error]) {
    SSNetWorkLog(@"Failed to create cache directory at %@", cacheFolder);
    cacheFolder = nil;
  }
  return cacheFolder;
}

- (NSURL *)incompleteDownloadTempPathForDownloadPath:(NSString *)downloadPath {
  NSString *tempPath = nil;
  NSString *md5URLString = [SSNetworkUtils md5StringFromString:downloadPath];
  tempPath = [[self incompleteDownloadTempCacheFolder] stringByAppendingPathComponent:md5URLString];
  return [NSURL fileURLWithPath:tempPath];
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
