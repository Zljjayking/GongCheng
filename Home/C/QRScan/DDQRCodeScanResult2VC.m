//
//  DDQRCodeScanResult2VC.m
//  GongChengDD
//
//  Created by xzx on 2018/8/24.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDQRCodeScanResult2VC.h"

@interface DDQRCodeScanResult2VC ()<WKNavigationDelegate,WKUIDelegate>

@property(nonatomic,strong)WKWebView * webView;
@property (strong, nonatomic) UIProgressView *progressView;

@end

@implementation DDQRCodeScanResult2VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kColorBackGroundColor;
    
    self.navigationItem.leftBarButtonItem=[DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
    //监听UIWindow显示
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(beginFullScreen) name:UIWindowDidBecomeVisibleNotification object:nil];
    //监听UIWindow隐藏
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(endFullScreen) name:UIWindowDidBecomeHiddenNotification object:nil];
    //进度条
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 2)];
    self.progressView.tintColor = kColorBlue;
    self.progressView.trackTintColor = [UIColor whiteColor];
    //设置进度条的高度，下面这句代码表示进度条的宽度变为原来的1倍，高度变为原来的1.5倍.
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    [self.view addSubview:self.progressView];
    
    self.webView= [[WKWebView alloc] initWithFrame:CGRectMake(0,0,Screen_Width, Screen_Height-KNavigationBarHeight)];
    
    //添加KVO，WKWebView有一个属性estimatedProgress，就是当前网页加载的进度，所以监听这个属性。
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    NSURL * URL = [NSURL URLWithString:self.hostUrl];
    //NSURL * URL = [NSURL URLWithString:@"http://www.baidu.com"];
    
    NSMutableURLRequest * resquest = [NSMutableURLRequest requestWithURL:URL];
    
    //[resquest setValue:[NSString stringWithFormat:@"%@=%@",@"X-Token", [DDUserManager sharedInstance].token] forHTTPHeaderField:@"Cookie"];
    
    [self.webView loadRequest:resquest];
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    //self.webView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.webView];
}
- (void)beginFullScreen {
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
- (void)endFullScreen {
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
//返回上一页
- (void)leftButtonClick{
    self.backBlock();
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark WKNavigationDelegate
//页面跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSLog(@"打印URL:%@",navigationAction.request.URL);
    decisionHandler(WKNavigationActionPolicyAllow);
}

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    //开始加载网页时展示出progressView
    self.progressView.hidden = NO;
    //开始加载网页的时候将progressView的Height恢复为1.5倍
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    //防止progressView被网页挡住
    [self.view bringSubviewToFront:self.progressView];
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    //隐藏progressView
    self.progressView.hidden = YES;
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    //隐藏progressView
    self.progressView.hidden = YES;
}

#pragma mark ---
// 计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.webView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            self.progressView.hidden = YES;
            [self.progressView setProgress:0 animated:NO];
        }else {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }
}

// 记得取消监听
- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}



@end
