//
//  Box.h
//  RFTestDemo
//
//  Created by linitial on 2018/4/11.
//  Copyright © 2018年 redfinge. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Box<ObjectType> : NSObject<NSCopying,NSMutableCopying>

typedef void(^Listener)(ObjectType object);

@property (nonatomic, copy) ObjectType value;

@property (nonatomic, copy) Listener listener;

- (instancetype)initWithValue:(ObjectType)value;

- (void)bindListener:(Listener)listener;

@end
