//
//  SSNetDataCacheMeta.m
//  StarShareDevNetWorking
//
//  Created by BUBUKO on 2017/10/27.
//  Copyright © 2017年 BUBUKO. All rights reserved.
//

#import "SSNetDataCacheMeta.h"

@implementation SSNetDataCacheMeta

+ (BOOL)supportsSecureCoding
{
  return YES;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
  [aCoder encodeObject:self.version forKey:NSStringFromSelector(@selector(version))];
  [aCoder encodeObject:self.creationDate forKey:NSStringFromSelector(@selector(creationDate))];
  [aCoder encodeObject:self.appVersionString forKey:NSStringFromSelector(@selector(appVersionString))];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [self init];
  if (!self) {
    return nil;
  }
  
  self.version = [aDecoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(version))];
  self.creationDate = [aDecoder decodeObjectOfClass:[NSDate class] forKey:NSStringFromSelector(@selector(creationDate))];
  self.appVersionString = [aDecoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(appVersionString))];
  
  return self;
}

@end
