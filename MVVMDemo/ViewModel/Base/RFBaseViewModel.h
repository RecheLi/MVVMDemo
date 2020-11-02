//
//  BaseViewModel.h
//  RFTestDemo
//
//  Created by linitial on 2018/4/13.
//  Copyright © 2018年 redfinge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RFBaseViewModel : NSObject<RFViewModelProtocol>

/**
 如导航栏title
 */
@property (nonatomic, copy) NSString *title;

/**
 view的背景颜色 16进制
 */
@property (nonatomic, copy) NSString *backgroundColorHex;

/**
 是否隐藏导航栏 默认为NO
 */
@property (nonatomic, assign) BOOL hideNavigationBar;



@end
