//
//  RFReactView.h
//  RFTestDemo
//
//  Created by linitial on 2018/4/1.
//  Copyright © 2018年 redfinge. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RFReactView <NSObject>

@optional
- (void)bindViewModel:(id)viewModel;

@end
