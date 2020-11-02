//
//  HomeViewModel.h
//  RFTestDemo
//
//  Created by linitial on 2018/4/2.
//  Copyright © 2018年 redfinge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeCellViewModel.h"
#import "Box.h"

@interface HomeViewModel : Box

@property (nonatomic, copy) Box *title;

@property (nonatomic, readonly, strong) NSMutableArray *dataSource;

- (void)getDataSuccess:(void(^)(NSArray *data))succeed
                failed:(void(^)(NSError *error))failed;

@end
