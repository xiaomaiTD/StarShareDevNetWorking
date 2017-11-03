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
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


@end
