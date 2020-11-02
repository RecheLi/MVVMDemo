//
//  RFExceptionUploader.h
//  RFTestDemo
//
//  Created by linitial on 2018/4/4.
//  Copyright © 2018年 redfinge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void(^RFExceptionUploadSucceed)(NSInteger successCount,NSInteger index);
typedef void(^RFExceptionUploadFailed)(void);

@interface RFExceptionUploader : NSObject

+ (void)uploadExceptionForPath:(NSString *)filePath
                 uploadSuccess:(RFExceptionUploadSucceed)succeed
                 uploadFail:(RFExceptionUploadFailed)failed;

@end
