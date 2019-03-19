//
//  DDIndustryDynamicDetailVC.m
//  GongChengDD
//
//  Created by xzx on 2018/6/23.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDIndustryDynamicDetailVC.h"
#import <UShareUI/UShareUI.h>//友盟分享
//#import "UIImage+EMGIF.h"
#import "FLAnimatedImage.h"
#import <MessageUI/MessageUI.h>
#import "DDNavigationUtil.h"
@interface DDIndustryDynamicDetailVC ()<WKNavigationDelegate,WKUIDelegate,MFMessageComposeViewControllerDelegate>

@property(nonatomic,strong) WKWebView * webView;
@property (strong, nonatomic) UIProgressView *progressView;
@property(nonatomic,strong) UIView *loadingView;
@property (strong,nonatomic)MFMessageComposeViewController *messageController;
@end

@implementation DDIndustryDynamicDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kColorBackGroundColor;
    self.title = _titleStr;
    self.navigationItem.leftBarButtonItem=[DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
    self.navigationItem.rightBarButtonItem=[DDUtils rightbuttonItemWithImage:@"right_share" highlightedImage:@"right_share" target:self action:@selector(shareClick)];
    
    //监听UIWindow显示
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(beginFullScreen) name:UIWindowDidBecomeVisibleNotification object:nil];
    //监听UIWindow隐藏
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(endFullScreen) name:UIWindowDidBecomeHiddenNotification object:nil];
    
    //自定义加载动画
    _loadingView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-KNavigationBarHeight)];
    _loadingView.backgroundColor=kColorWhite;
//    //NSString  *filePath = [[NSBundle bundleWithPath:[[NSBundle mainBundle] bundlePath]] pathForResource:@"home_loadingImg" ofType:@"gif"];
//    //NSData *imageData = [NSData dataWithContentsOfFile:filePath];
//    NSString *filePath;
//    NSData *imageData;
//    UIImageView *loadingImageView;
//    if ([UIScreen mainScreen].scale==2) {
//        loadingImageView = [[UIImageView alloc]initWithFrame:CGRectMake((Screen_Width-150)/2, (Screen_Height-KNavigationBarHeight-33)/2-50, 150, 33)];
//        //loadingImageView.image = [UIImage sd_animatedGIFNamed:@"home_loadingImg1"];
//        filePath = [[NSBundle bundleWithPath:[[NSBundle mainBundle] bundlePath]] pathForResource:@"home_loadingImg1" ofType:@"gif"];
//        imageData = [NSData dataWithContentsOfFile:filePath];
//    }
//    else{
//        loadingImageView = [[UIImageView alloc]initWithFrame:CGRectMake((Screen_Width-150)/2, (Screen_Height-KNavigationBarHeight-33)/2-50, 150, 33)];
//        //loadingImageView.image = [UIImage sd_animatedGIFNamed:@"home_loadingImg2"];
//        filePath = [[NSBundle bundleWithPath:[[NSBundle mainBundle] bundlePath]] pathForResource:@"home_loadingImg2" ofType:@"gif"];
//        imageData = [NSData dataWithContentsOfFile:filePath];
//    }
//    //第一种方法使用imageData加载
//    loadingImageView.image = [UIImage sd_animatedGIFWithData:imageData];
//    //第二种方法使用图片名字加载
//    //loadingImageView.image = [UIImage sd_animatedGIFNamed:@"home_loadingImg"];
//    [_loadingView addSubview:loadingImageView];
//    [self.view addSubview:_loadingView];
    
    FLAnimatedImageView *imageView1=[[FLAnimatedImageView alloc]initWithFrame:CGRectMake((Screen_Width-150)/2, (Screen_Height-KNavigationBarHeight-33)/2-50, 150, 33)];
    NSURL *url1 = [[NSBundle mainBundle] URLForResource:@"home_loadingImg2" withExtension:@"gif"];
    NSData *data1 = [NSData dataWithContentsOfURL:url1];
    FLAnimatedImage *animatedImage1 = [FLAnimatedImage animatedImageWithGIFData:data1];
    imageView1.animatedImage = animatedImage1;
    [_loadingView addSubview:imageView1];
    [self.view addSubview:_loadingView];
    

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
    
    NSString *urlStr=[NSString stringWithFormat:@"%@/#/pages/IndustryDetails/main?doc_id=%@&hideTop=1",DDBaseUrl,self.docId];
    NSURL * URL = [NSURL URLWithString:urlStr];
    //NSURL * URL = [NSURL URLWithString:@"http://www.baidu.com"];
    
    NSMutableURLRequest * resquest = [NSMutableURLRequest requestWithURL:URL];
    
    //[resquest setValue:[NSString stringWithFormat:@"%@=%@",@"X-Token", [DDUserManager sharedInstance].token] forHTTPHeaderField:@"Cookie"];
    
    [self.webView loadRequest:resquest];
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
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
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }
    else{
        [self.navigationController popViewControllerAnimated:NO];
    }
}

//分享
-(void)shareClick{
    
   [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine ),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Sms)]];
    //配置上面需求的参数
    [UMSocialShareUIConfig shareInstance].shareTitleViewConfig.isShow = NO;
    [UMSocialShareUIConfig shareInstance].shareCancelControlConfig.shareCancelControlText = @"取消";
    //显示分享面板
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        if (platformType == UMSocialPlatformType_Sms) {
            _messageController= [[MFMessageComposeViewController alloc] init];
            UINavigationItem * navigationItem = [[[_messageController viewControllers] lastObject] navigationItem];
            [navigationItem setTitle:@"新信息"];
            UIButton * cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
            [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
            [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
            [cancelButton addTarget:self action:@selector(cancelSendSMSClick) forControlEvents:UIControlEventTouchUpInside];
            navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:cancelButton];
            
            
            // 设置短信内容
            _messageController.body = [NSString stringWithFormat:@"行业动态，最新资讯 %@/#/pages/IndustryDetails/main?doc_id=%@",DDBaseUrl,self.docId];
            
            // 设置收件人列表
            //            _messageController.recipients = @[@"13812345678"];
            // 设置代理
            _messageController.messageComposeDelegate = self;
            // 显示控制器
            [self presentViewController:_messageController animated:YES completion:nil];
        }else{
            UMShareWebpageObject * shareObject = [UMShareWebpageObject shareObjectWithTitle:self.titleStr descr:@"行业动态，最新资讯" thumImage:[UIImage imageNamed:@"share_logo"]];
            
            //设置网页地址
            shareObject.webpageUrl =[NSString stringWithFormat:@"%@/#/pages/IndustryDetails/main?doc_id=%@",DDBaseUrl,self.docId];
            
            //创建分享消息对象
            UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
            //分享消息对象设置分享内容对象
            messageObject.shareObject = shareObject;
            
            //调用分享接口
            [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
                if (error) {
                    UMSocialLogInfo(@"************分享返回的结果：%@*********",error);
                }
                else{
                    if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                        UMSocialShareResponse *resp = data;
                        //分享结果消息
                        UMSocialLogInfo(@"response message is %@",resp.message);
                        //第三方原始返回的数据
                        UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                        
                    }else{
                        UMSocialLogInfo(@"response data is %@",data);
                    }
                }
            }];
        }
    
    }];
}
#pragma mark MFMessageComposeViewControllerDelegate代理方法
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
            // 关闭短信界面
            [controller dismissViewControllerAnimated:YES completion:nil];
            if(result == MessageComposeResultCancelled) {
                NSLog(@"取消发送");
            } else if(result == MessageComposeResultSent) {
                NSLog(@"发送成功");
            } else {
                NSLog(@"发送失败");
            }
}
- (void)cancelSendSMSClick{
            [_messageController dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark WKNavigationDelegate
//页面跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSLog(@"打印URL:%@",navigationAction.request.URL);
    decisionHandler(WKNavigationActionPolicyAllow);
}

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    [self.view bringSubviewToFront:_loadingView];
    
    //开始加载网页时展示出progressView
    //self.progressView.hidden = NO;
    self.progressView.hidden = YES;
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
    [self.view sendSubviewToBack:_loadingView];
    
    //隐藏progressView
    self.progressView.hidden = YES;
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    [self.view sendSubviewToBack:_loadingView];
    
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
            //self.progressView.hidden = NO;
            self.progressView.hidden = YES;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }
}

// 记得取消监听
- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}
-(void)viewWillDisappear:(BOOL)animated{
    //还原导航底部线条颜色
    [DDNavigationUtil setNavigationBottomLineNomalColor:self.navigationController];
}

-(void)viewWillAppear:(BOOL)animated{
    //导航底部线条设为透明
    [DDNavigationUtil setNavigationBottomLineClearColor:self.navigationController];
    
}
@end
