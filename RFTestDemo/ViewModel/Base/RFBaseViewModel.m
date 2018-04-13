//
//  BaseViewModel.m
//  RFTestDemo
//
//  Created by linitial on 2018/4/13.
//  Copyright © 2018年 redfinge. All rights reserved.
//

#import "RFBaseViewModel.h"

@interface RFBaseViewModel ()

@property (nonatomic, readwrite, strong) RFBaseModel *model;
@end

@implementation RFBaseViewModel

- (instancetype)initWithModel:(RFBaseModel *)model {
    self = [super init];
    if (self) {
        self.model = model;
    }
    return self;
}

@end

