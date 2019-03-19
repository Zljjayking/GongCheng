//
//  DDProvinceInAndOutVC.m
//  GongChengDD
//
//  Created by feizhiniumini2 on 2017/12/5.
//  Copyright © 2017年 FeiZhiNiu. All rights reserved.
//

#import "DDProvinceInAndOutVC.h"
#import "DDDefines.h"
#import "DDUtils.h"
#import "DDHttpManager.h"
#import "DDContractListHeadView.h"

@interface DDProvinceInAndOutVC ()<DDContractListHeadViewDelegate,WKNavigationDelegate,WKUIDelegate>

@property(nonatomic,strong) WKWebView * webView1;
@property (strong, nonatomic) UIProgressView *progressView;
@property (nonatomic,strong) WKWebView * webView2;

@end

@implementation DDProvinceInAndOutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSelectView];
}
- (void)setupSelectView{
    DDContractListHeadView * headView = [[DDContractListHeadView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 50)];
    headView.backgroundColor = kColorWhite;
    headView.delegate = self;
    headView.titleFont = kFontSize30;
    headView.titleNormalColor = kColorBlue;
    headView.titleSelectedColor = [UIColor whiteColor];
    headView.selectBackgroundImage = [UIImage imageNamed:@"cer_bluebox"];
    headView.normalBackgroundImage = [UIImage imageNamed:@"cer_greybox"];
    [headView loadWithTitleArray:@[@"省内调转",@"省外调转",]];
    headView.currendIndex = 0;
    [self.view addSubview:headView];
}

#pragma mark DDContractListHeadViewDelegate
-(void)buttonSelectView:(DDContractListHeadView *)view didSelectButtonAtIndex:(NSInteger)index{
    NSLog(@"+++++%ld",index);
    
    if (index == 0) {
        
        [self.webView2 removeFromSuperview];
        //加载网页
        [self setupWebView1];
        
    }else{
        
        [self.webView1 removeFromSuperview];
        //加载tableView
        [self setupWebView2];
    }
}

#pragma mark 设置webView
-(void)setupWebView1{
    if (self.webView1) {
        [self.view addSubview:self.webView1];
    }
    else{
        //进度条
        self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 50, Screen_Width, 2)];
        self.progressView.tintColor = kColorBlue;
        self.progressView.trackTintColor = [UIColor whiteColor];
        //设置进度条的高度，下面这句代码表示进度条的宽度变为原来的1倍，高度变为原来的1.5倍.
        self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
        [self.view addSubview:self.progressView];
        
        self.webView1= [[WKWebView alloc] initWithFrame:CGRectMake(0,50,Screen_Width, Screen_Height)];
        //添加KVO，WKWebView有一个属性estimatedProgress，就是当前网页加载的进度，所以监听这个属性。
        [self.webView1 addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        //URL暂时用https://www.baidu.com/测试
        //NSURL * URL = [NSURL URLWithString:@"https://www.baidu.com/"];
        NSString * str = [NSString stringWithFormat:@"%@%@",DD_Http_Server,@"/webops/guide/guideflow"];
        NSURL * URL = [NSURL URLWithString:str];
        //    NSURL * URL = [NSURL URLWithString:_URLString];
        NSURLRequest * resquest = [NSURLRequest requestWithURL:URL];
        [self.webView1 loadRequest:resquest];
        self.webView1.navigationDelegate = self;
        self.webView1.UIDelegate = self;
        //self.webView.backgroundColor = [UIColor redColor];
        [self.view addSubview:self.webView1];
    }
}

-(void)setupWebView2{
    if (self.webView2) {
        [self.view addSubview:self.webView2];
    }
    else{
        //进度条
        self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 50, Screen_Width, 2)];
        self.progressView.tintColor = kColorBlue;
        self.progressView.trackTintColor = [UIColor whiteColor];
        //设置进度条的高度，下面这句代码表示进度条的宽度变为原来的1倍，高度变为原来的1.5倍.
        self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
        [self.view addSubview:self.progressView];
        
        self.webView2= [[WKWebView alloc] initWithFrame:CGRectMake(0,50,Screen_Width, Screen_Height)];
        //添加KVO，WKWebView有一个属性estimatedProgress，就是当前网页加载的进度，所以监听这个属性。
        [self.webView2 addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        //URL暂时用https://www.baidu.com/测试
        //NSURL * URL = [NSURL URLWithString:@"https://www.baidu.com/"];
        NSString * str = [NSString stringWithFormat:@"%@%@",DD_Http_Server,@"/webops/guide/guideflow"];
        NSURL * URL = [NSURL URLWithString:str];
        //    NSURL * URL = [NSURL URLWithString:_URLString];
        NSURLRequest * resquest = [NSURLRequest requestWithURL:URL];
        [self.webView2 loadRequest:resquest];
        self.webView2.navigationDelegate = self;
        self.webView2.UIDelegate = self;
        //self.webView.backgroundColor = [UIColor redColor];
        [self.view addSubview:self.webView2];
    }
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
    if (object == self.webView1 && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            self.progressView.hidden = YES;
            [self.progressView setProgress:0 animated:NO];
        }else {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }
    else if (object == self.webView2 && [keyPath isEqualToString:@"estimatedProgress"]) {
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
    [self.webView1 removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView2 removeObserver:self forKeyPath:@"estimatedProgress"];
}

@end
