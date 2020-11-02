//
//  RFExceptionHelper.h
//  RFTestDemo
//
//  Created by linitial on 2018/4/4.
//  Copyright © 2018年 redfinge. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const RFExceptionCacheFileName;

@interface RFExceptionHelper : NSObject

NSString *get_current_date(void);
NSString *get_device_info(void);
NSString *get_system_version(void);
NSString *get_current_network(void);
NSString *rf_application_documents_directory(void);

NSData *get_exception_data(void);
NSMutableArray *get_local_exception_array(void);

+ (NSString *)convertErrorCodeFromExceptionName:(NSString *)name;
+ (NSString *)convertFuncTypeFromExceptionReason:(NSString *)reason;

@end
