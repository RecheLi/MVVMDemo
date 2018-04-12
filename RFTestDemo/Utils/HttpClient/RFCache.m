//
//  RFCache.m
//  RFTestDemo
//
//  Created by linitial on 2018/4/12.
//  Copyright © 2018年 redfinge. All rights reserved.
//

#import "RFCache.h"

static NSTimeInterval const rf_cacheOverdueTime = (double)60*30;//1*60 1分钟
static NSString *const rf_baseCachePath = @".RFCaches";
static NSString *const rf_cacheKey = @"RFCacheStorageKey";

@implementation RFCache

#pragma mark - 清空缓存目录
+ (void)removeAllCache {
    [[NSFileManager defaultManager] removeItemAtPath:[self cacheDirectory] error:nil];
}

#pragma mark - 缓存数据
+ (void)setData:(NSDictionary *)dataDic
         forKey:(NSString *)key {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *fileName = [self.cacheDirectory stringByAppendingPathComponent:key];
    
    NSMutableData *cacheData = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:cacheData];
    [archiver encodeObject:dataDic forKey:rf_cacheKey];
    [archiver finishEncoding];
    
    if (![fileManager fileExistsAtPath:fileName]) {
        NSLog(@"创建数据");
        [self writeData:cacheData inFile:fileName];
        return;
    }
    NSDate *modifiedDate = [[fileManager attributesOfItemAtPath:fileName error:nil] objectForKey:NSFileModificationDate];
    NSMutableData *data = [NSMutableData dataWithContentsOfFile:fileName];
    
    if (ABS([modifiedDate timeIntervalSinceNow]) >= rf_cacheOverdueTime) {
        if (cacheData && cacheData.length > 0 && ![cacheData isEqualToData:data]) {
            NSLog(@"缓存过期");
            [[NSFileManager defaultManager] removeItemAtPath:fileName error:nil];
            [self setData:dataDic forKey:key];
        } else {
            NSLog(@"缓存过期，但数据不变");
        }
    } else {
        if (![cacheData isEqualToData:data]) {
            NSLog(@"数据更新");
            [[NSFileManager defaultManager] removeItemAtPath:fileName error:nil];
            [self setData:dataDic forKey:key];
        } else {
            NSLog(@"%f秒后过期", rf_cacheOverdueTime - ABS([modifiedDate timeIntervalSinceNow]));
        }
    }
}

#pragma mark - 读取缓存数据，是否存在、是否过期
+ (NSDictionary *)objectForKey:(NSString *)key {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filename = [self.cacheDirectory stringByAppendingPathComponent:key];
    if ([fileManager fileExistsAtPath:filename]) {
        NSMutableData *data = [NSMutableData dataWithContentsOfFile:filename];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        NSDictionary *dictionary = [unarchiver decodeObjectForKey:rf_cacheKey];
        [unarchiver finishDecoding];
        if (data && [data length] > 1) {
            return dictionary;
        }
    }
    return nil;
}

#pragma mark - Private

#pragma mark - 缓存目录
+ (NSString *)cacheDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:rf_baseCachePath];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path
                                  withIntermediateDirectories:NO
                                                   attributes:nil
                                                        error:nil];
    }
    return path;
}

#pragma mark - 数据写入缓存
+ (void)writeData:(NSData *)data
           inFile:(NSString *)fileName {
    NSError *error;
    @try {
        if (data && [data length] > 0) {
            [data writeToFile:fileName options:NSDataWritingAtomic error:&error];
        }
    }
    @catch (NSException * e) {
        //TODO: error handling maybe
    }
}


@end
