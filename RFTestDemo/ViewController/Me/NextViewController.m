//
//  NextViewController.m
//  RFTestDemo
//
//  Created by linitial on 2018/3/28.
//  Copyright © 2018年 redfinge. All rights reserved.
//

#import "NextViewController.h"
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@interface NextViewController () <WKNavigationDelegate,WKScriptMessageHandler>

@property (strong, nonatomic) WKWebView *webView;

@end

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

@implementation NextViewController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.webView];
    [self loadHTML];
}

#pragma mark - Private
- (void)loadHTML {
    NSURL *htmlPath = [[NSBundle mainBundle] URLForResource:@"test.html" withExtension:nil];
    [_webView loadRequest:[NSURLRequest requestWithURL:htmlPath]];
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSLog(@"方法名:%@", message.name);
    NSLog(@"参数:%@", message.body);
    // 方法名
    NSString *methods = [NSString stringWithFormat:@"%@:", message.name];
    SEL selector = NSSelectorFromString(methods);
    // 调用方法
    if (![self respondsToSelector:selector]) {
        NSLog(@"未实行方法：%@", methods);
        return;
    }
    SuppressPerformSelectorLeakWarning(
       [self performSelector:selector withObject:message.body];
    );
}

- (void)clickBtn:(id)body {
    NSLog(@"点击了按钮");
}


#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
//    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"]; // UIWebView
//    NSLog(@"context is %@",context);
}

#pragma mark - Getter
- (WKWebView *)webView {
    if (!_webView) {
        // js配置
        WKUserContentController *userContentController = [[WKUserContentController alloc] init];
        [userContentController addScriptMessageHandler:self name:@"RFAction"];
        [userContentController addScriptMessageHandler:self name:@"clickBtn"];
        WKPreferences *preferences = [WKPreferences new];
        preferences.javaScriptCanOpenWindowsAutomatically = YES;
        preferences.minimumFontSize = 40.0;

        // WKWebView的配置
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.preferences = preferences;
        configuration.userContentController = userContentController;
        _webView = [[WKWebView alloc]initWithFrame:self.view.frame configuration:configuration];
        _webView.navigationDelegate = self;
    }
    return _webView;
}



@end
