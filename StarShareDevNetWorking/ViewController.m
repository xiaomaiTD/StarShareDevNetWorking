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
  
  
  [[StarShareNetEngine sharedInstance] excuteWithRequestBean:HomePageRequest.alloc.init
                                                responseBean:HomePageResponse.alloc.init
                                                   successed:^(id requestDomainBean, id respondDomainBean,BOOL dataFromCache) {
                                                     NSLog(@"success");
                                                   }
                                                      failed:^(id requestDomainBean, id respondDomainBean, NSError *error) {
                                                        NSLog(@"error");
                                                      }];
  
  [[[SSNetWorkEngine   alloc] init] downloadWithUrlString:@"https://ww2.sinaimg.cn/mw1024/005zWjpngy1fljqke2zgaj30t616i78l"
                                           securityPolicy:nil
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
  
  SSNetRequestData *data = [[SSNetRequestData alloc] init];
  data.type = SSNetRequestDataTypeFile;
  data.name = @"image";
  data.fileName = @"testupload.png";
  data.mimeType = @"image/*";
  data.data = UIImagePNGRepresentation([UIImage imageNamed:@"testupload"]);
  
  [[[SSNetWorkEngine alloc] init] requestWithUrlString:@"http://47.95.226.243/api/app/upload"
                                        securityPolicy:nil
                                                method:SSNetRequestMethodPOST
                                     requestSerializer:SSNetRequestSerializerHTTP
                                    responseSerializer:SSNetResponseSerializerJSON
                                              priority:SSNetRequestPriorityNormal
                                         authorization:nil
                                               headers:@{@"Authorization":[NSString stringWithFormat:@"Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjZlZWRiYzA4OTQwNzFhY2Q4YmUxMDdjZTZjMDdiMjE3NTIzMjMzMmI3ZjQxNjg0MDk3MGFiZGJhZDA5ZjkzYWM4ZjZlMDk5MjU1NjMyZjE5In0.eyJhdWQiOiIxIiwianRpIjoiNmVlZGJjMDg5NDA3MWFjZDhiZTEwN2NlNmMwN2IyMTc1MjMyMzMyYjdmNDE2ODQwOTcwYWJkYmFkMDlmOTNhYzhmNmUwOTkyNTU2MzJmMTkiLCJpYXQiOjE1MjMzMzI5MTcsIm5iZiI6MTUyMzMzMjkxNywiZXhwIjoxNTU0ODY4OTE3LCJzdWIiOiI0MSIsInNjb3BlcyI6W119.wllJpN-_UK3FYnE4aXRQU5Vcyjmq0Au-CJzUO39U010K7ReaCJN_foioXTV6f_zriZeA92_Lm8OrjMDFO3BHLiYQu-3zjLSmwbDnZoMRPvBooni1hTYwpF_gZwckaLcbwGqxvwiJSXnvQCkYT32fjik7fa-0aKPHIx-QJhhIexKh01Gvh47yhi-LmOjLHQymYdyXWbJ8lsjzAui39yAduCXt7RtkPDHH97TGRu2Zx3x_3eR6J6Ze1e58iSngUdb9I2qPnxyfIUpcRh-XqeLmcSMjFI78NRCq3g71_PsMUPs0inZUob2it4fgUT7bxyzdiMpUi4p-Bfue5SPs1eOY_Ev3Ah8LhYOb-RvgVq4P3JO1SLR3zXRjo1Gx3ZhcOv4gRuosrDfW03O-kFPwergyB3Bxf9Ekj0zq3fDmbYQxPiggcts280xKIL6jYXe5V_AzH0auNn8nXWkJc5-NBD0c2RX4BipAco-KikD8mcylo0bcsoho9jTMyQykmmG5poxENR1koHsh5TK03UTni35E0Cwg-e-rK2AnUW9bvUvBVwo1eZR0thw-cL5Y72cS18UwntzkGdSXB5h3pkRuqz1yVan37L8DpVzA-TfLmcdIvQGJw9Y6biIiy6Zlz8_16OHqzWxddRLjTogSi9C55fFJntjpnodDwZe6VJvrThK_6l8"]}
                                              argument:nil
                                                  data:data
                                               timeout:100
                                  allowsCellularAccess:YES
                                              progress:^(NSProgress *uploadProgress) {
                                                NSLog(@"23333");
                                              }
                                               success:^(NSURLResponse *response, id responseObject) {
                                                 NSLog(@"%@",responseObject);
                                               }
                                               failure:^(NSURLResponse *response, id responseObject, NSError *error) {
                                                 NSLog(@"%@",error);
                                               }];
}
@end
