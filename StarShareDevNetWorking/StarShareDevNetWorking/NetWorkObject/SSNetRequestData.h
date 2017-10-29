//
//  SSNetRequestData.h
//  StarShareDevNetWorking
//
//  Created by BUBUKO on 2017/10/27.
//  Copyright © 2017年 BUBUKO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSNetWorkConstants.h"

@interface SSNetRequestData : NSObject
@property(nonatomic,assign) SSNetRequestDataType type;
@property(nonatomic,strong) NSData *data;
@property(nonatomic,strong) NSURL *fileUrl;
@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *fileName;
@property(nonatomic,copy) NSString *mimeType;
@end

