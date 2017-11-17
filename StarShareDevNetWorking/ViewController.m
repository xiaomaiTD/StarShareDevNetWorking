//
//  ViewController.m
//  StarShareDevNetWorking
//
//  Created by BUBUKO on 2017/10/26.
//  Copyright © 2017年 BUBUKO. All rights reserved.
//

#import "ViewController.h"
#import "StarShareNetEngine.h"
#import "HomePageRequest.h"
#import "HomePageResponse.h"
#import "SSAFNetWorkEngine.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  
//  [[StarShareNetEngine sharedInstance] excuteWithRequestBean:HomePageRequest.alloc.init
//                                                responseBean:HomePageResponse.alloc.init
//                                                   successed:^(id requestDomainBean, id respondDomainBean,BOOL dataFromCache) {
//                                                     NSLog(@"success");
//                                                   }
//                                                      failed:^(id requestDomainBean, id respondDomainBean, NSError *error) {
//                                                        NSLog(@"error");
//                                                      }];
  
  [[[SSAFNetWorkEngine alloc] init] downloadWithUrlString:@"https://ww2.sinaimg.cn/mw1024/005zWjpngy1fljqke2zgaj30t616i78l"
                                           securityPolicy:nil
                                                   method:SSNetRequestMethodGET
                                        requestSerializer:SSNetRequestSerializerHTTP
                                                 priority:SSNetRequestPriorityNormal
                                            authorization:nil
                                                  headers:nil
                                                 argument:nil
                                    resumableDownloadPath:[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject]
                                                  timeout:100
                                     allowsCellularAccess:YES
                                                 progress:^(NSProgress *downloadProgress) {
                                                   NSLog(@"23333");
                                                 }
                                                 complete:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                                                   NSLog(@"%@",filePath);
                                                 }
                                                  failure:^(NSURLResponse *response, id responseObject, NSError *error) {
                                                    NSLog(@"%@",error);
                                                  }];
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


@end
