//
//  User.m
//  StarShareDevNetWorking
//
//  Created by BUBUKO on 2017/11/1.
//  Copyright © 2017年 BUBUKO. All rights reserved.
//

#import "User.h"

@implementation User
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper
{
  return @{@"userId":@"id"};
}
@end
