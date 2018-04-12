//
//  HomeCellViewModel.m
//  RFTestDemo
//
//  Created by linitial on 2018/3/31.
//  Copyright © 2018年 redfinge. All rights reserved.
//

#import "HomeCellViewModel.h"

@interface HomeCellViewModel ()

@property (strong, nonatomic,readwrite) HomeModel *model;

@end


@implementation HomeCellViewModel
- (instancetype)initWithHomeModel:(HomeModel *)model {
    self = [super init];
    if (self) {
        self.model = model;
        if ([self.model.title containsString:@"0"]) {
            self.model.title = @"豌豆射手 带0";
        }
    }
    return self;
}
@end
