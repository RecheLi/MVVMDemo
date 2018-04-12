//
//  TestViewController.m
//  RFTestDemo
//
//  Created by linitial on 2018/4/3.
//  Copyright © 2018年 redfinge. All rights reserved.
//

#import "TestViewController.h"
#import <GLKit/GLKit.h>
#import <OpenGLES/EAGLIOSurface.h>

@interface TestViewController ()

@property (nonatomic, strong) UIView *glView;

@property (nonatomic, strong) EAGLContext *glContext;

@property (nonatomic, strong) CAEAGLLayer *glLayer;

@property (nonatomic, strong) GLKBaseEffect *effect;

@property (nonatomic, assign) GLuint frameBuffer;

@property (nonatomic, assign) GLuint colorRenderBuffer;

@property (nonatomic, assign) GLuint glFrameHeight;

@property (nonatomic, assign) GLuint glFrameWidth;

@end

@implementation TestViewController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setup];
//    [self _cashTest];
}

#pragma mark - Private
- (void)_setup {
    [self.view addSubview:self.glView];
}

- (void)_setupBuffer {
}

- (void)_cashTest {
    //常见异常1---不存在方法引用
    
    //        [self performSelector:@selector(thisMthodDoesNotExist) withObject:nil];
    
    //常见异常2---键值对引用nil
    
//    [[NSMutableDictionary dictionary] setObject:nil forKey:@"nil"];
    
    //常见异常3---数组越界
    
    //    [[NSArray array] objectAtIndex:1];
    
    //常见异常4---memory warning 级别3以上
    
    //    [self performSelector:@selector(killMemory) withObject:nil];
}


#pragma mark - Getter
- (UIView *)glView {
    if (!_glView) {
        _glView = [[UIView alloc]initWithFrame:({
            CGRect rect = {0,0,self.view.frame.size.width,self.view.frame.size.height};
            rect;
        })];
    }
    return _glView;
}


@end
