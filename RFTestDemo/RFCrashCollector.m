//
//  RFCrashCollector.m
//  RFTestDemo
//
//  Created by linitial on 2018/4/8.
//  Copyright © 2018年 redfinge. All rights reserved.
//

#import "RFCrashCollector.h"
#import "RFExceptionCapture.h"


@implementation RFCrashCollector

static NSUncaughtExceptionHandler *_previousUncaughtExceptionHandler;

+ (void)installCrashCollector {
    _previousUncaughtExceptionHandler = NSGetUncaughtExceptionHandler();
    NSUncaughtExceptionHandler *handler = NSGetUncaughtExceptionHandler();
    if (!handler) {
        NSLog(@"no previous handler");
    } else {
        _previousUncaughtExceptionHandler = handler;
    }
    NSSetUncaughtExceptionHandler(&_uncaughtExceptionHandler);
    signal(SIGABRT, _signalHandler);
    signal(SIGILL, _signalHandler);
    signal(SIGSEGV, _signalHandler);
    signal(SIGFPE, _signalHandler);
    signal(SIGBUS, _signalHandler);
    signal(SIGPIPE, _signalHandler);
    signal(SIGTRAP, _signalHandler);
}

void uninstallCrashCollector() {
    NSSetUncaughtExceptionHandler(NULL);
    signal(SIGABRT, SIG_DFL);
    signal(SIGILL, SIG_DFL);
    signal(SIGSEGV, SIG_DFL);
    signal(SIGFPE, SIG_DFL);
    signal(SIGBUS, SIG_DFL);
    signal(SIGPIPE, SIG_DFL);
    signal(SIGTRAP, SIG_DFL);
}

void _signalHandler(int signalCode) {
    NSLog(@"signalCode is %@", @(signalCode));
}

void _uncaughtExceptionHandler(NSException *exception) {
    NSLog(@"exception name is %@", exception.name);
    uninstallCrashCollector();
    if (_previousUncaughtExceptionHandler) {
        _previousUncaughtExceptionHandler(exception);
    }
}

@end
