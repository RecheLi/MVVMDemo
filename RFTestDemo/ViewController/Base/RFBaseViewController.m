//
//  RFBaseViewController.m
//  RFTestDemo
//
//  Created by linitial on 2018/4/13.
//  Copyright © 2018年 redfinge. All rights reserved.
//

#import "RFBaseViewController.h"

@interface RFBaseViewController ()

@property (nonatomic, readwrite, strong) RFBaseViewModel *viewModel;

@end

@implementation RFBaseViewController

- (instancetype)initWithViewModel:(id<RFViewModelProtocol>)viewModel {
    self = [super init];
    if (self) {
        self.viewModel = viewModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Public
- (void)showHint:(NSString *)hintMsg {}

- (void)setLeftNavigationItemTitle:(NSString *)title
                            action:(SEL)action{}

- (void)setLeftNavigationItemImage:(NSString *)imageName
                            action:(SEL)action {}

- (void)setRightNavigationItemTitle:(NSString *)title
                             action:(SEL)action {}

- (void)setRightNavigationItemImage:(NSString *)imageName
                             action:(SEL)action {}

@end
