//
//  RFCache.h
//  RFTestDemo
//
//  Created by linitial on 2018/4/12.
//  Copyright © 2018年 redfinge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RFCache : NSObject

/**
 调用此方法直接将数据写入磁盘
 
 @param dataDic 需要缓存的数据 NSDictionary
 @param key 缓存的key
 */
+ (void)setData:(NSDictionary *)dataDic
         forKey:(NSString *)key;

/**
 通过key值获取缓存

 @param key 一般为请求的url
 @return 返回缓存数据 NSDictionary
 */
+ (NSDictionary *)objectForKey:(NSString *)key;

/**
 移除所有缓存
 */
+ (void)removeAllCache;

@end
