//
//  HomeCellViewModel.h
//  RFTestDemo
//
//  Created by linitial on 2018/3/31.
//  Copyright © 2018年 redfinge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeModel.h"

@interface HomeCellViewModel : NSObject
@property (strong, nonatomic,readonly) HomeModel *model;

- (instancetype)initWithHomeModel:(HomeModel *)model;
@end
