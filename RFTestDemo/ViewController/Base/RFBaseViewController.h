//
//  RFBaseViewController.h
//  RFTestDemo
//
//  Created by linitial on 2018/4/13.
//  Copyright © 2018年 redfinge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RFBaseViewController : UIViewController

- (instancetype)initWithViewModel:(id<RFViewModelProtocol>)viewModel;

- (void)showHint:(NSString *)hintMsg;

- (void)setLeftNavigationItemTitle:(NSString *)title
                            action:(SEL)action;

- (void)setLeftNavigationItemImage:(NSString *)imageName
                            action:(SEL)action;

- (void)setRightNavigationItemTitle:(NSString *)title
                            action:(SEL)action;

- (void)setRightNavigationItemImage:(NSString *)imageName
                             action:(SEL)action;

@end
