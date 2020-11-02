//
//  Box.m
//  RFTestDemo
//
//  Created by linitial on 2018/4/11.
//  Copyright © 2018年 redfinge. All rights reserved.
//

#import "Box.h"

@interface Box<ObjectType> ()

@end

@implementation Box

- (instancetype)initWithValue:(id)value {
    self = [super init];
    if (self) {
        self.value = value;
    }
    return self;
}

- (void)setValue:(id)value {
    _value = value;
    if (self.listener) {
        self.listener(_value);
    }
}

- (void)bindListener:(Listener)listener {
    self.listener = listener;
    if (self.listener) {
        self.listener(self.value);
    }
}

- (id)copyWithZone:(NSZone *)zone {
    Box *copy = [Box allocWithZone:zone];
    copy.value = _value;
    return copy;
}

- (id)mutableCopyWithZone:(nullable NSZone *)zone {
    Box *copy = [Box allocWithZone:zone];
    copy.value = _value;
    return copy;
}

@end
