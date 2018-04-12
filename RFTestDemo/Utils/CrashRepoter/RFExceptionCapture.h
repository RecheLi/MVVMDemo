//
//  RFExceptionCapture.h
//  RFTestDemo
//
//  Created by linitial on 2018/4/4.
//  Copyright © 2018年 redfinge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RFExceptionCaptureProtocol.h"

@interface RFExceptionCapture : NSObject

+ (void)registerCrashCapture;

+ (void)configureDelegate:(id<RFExceptionCaptureProtocol>)delegate;

@end

