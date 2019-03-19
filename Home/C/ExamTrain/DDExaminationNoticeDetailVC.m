//
//  DDExaminationNoticeDetailVC.m
//  GongChengDD
//
//  Created by xzx on 2018/6/7.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDExaminationNoticeDetailVC.h"
#import <WebKit/WebKit.h>
#import "DataLoadingView.h"//加载页面
#import "DDExaminationNotice2DetailModel.h"//model
#import "DDActionSheetView.h"//弹出视图

@interface DDExaminationNoticeDetailVC ()<DDExamCitySelectViewDelegate,UIGestureRecognizerDelegate,WKNavigationDelegate,WKUIDelegate,DDActionSheetViewDelegate>

{
    NSMutableArray *_dataSource;//存放请求到的考试通知日期数据
    
    UILabel *_label1;//放左边那个城市选择文字
    UILabel *_label2;//放右边那个资质等级选择文字

    NSString *_region;//地区筛选
    NSString *_date;//日期筛选
    
    NSString *_urlStr;
}
@property (nonatomic,strong) DataLoadingView *loadingView;
@property(nonatomic,strong) WKWebView * webView;
@property (strong, nonatomic) UIProgressView *progressView;
@property(nonatomic,strong) DDActionSheetView *dateSheetView;//日期选择View

@end

@implementation DDExaminationNoticeDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];

    _region=@"南京市";
    DDUserManager *manager=[DDUserManager sharedInstance];
    if (![DDUtils isEmptyString:manager.city]) {
        _region=manager.city;
    }
    
    _isCitySelected=@"0";
    _isMoneySelected=@"0";
    self.title=self.titleName;
    self.view.backgroundColor=kColorBackGroundColor;
    self.navigationItem.leftBarButtonItem=[DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
    _dataSource=[[NSMutableArray alloc]init];
    
    
    _townSelectTableView=[[DDExamCitySelectView alloc]initWithFrame:CGRectMake(0, 39, Screen_Width, Screen_Height-KNavigationBarHeight-39)];
    __weak __typeof(self) weakSelf=self;
    //DDUserManager *manager=[DDUserManager sharedInstance];
    if (![DDUtils isEmptyString:manager.city]) {
        _townSelectTableView.type=@"1";
    }
    _townSelectTableView.hiddenBlock = ^{
        weakSelf.imgView1.image=[UIImage imageNamed:@"home_search_down"];
        
        //[weakSelf.townSelectTableView hiddenActionSheet];
        [weakSelf.townSelectTableView hidden];
        
        _isCitySelected=@"0";
    };
    _townSelectTableView.delegate=self;
    [_townSelectTableView show];
//    [self createLoadView];
//    [self createChooseBtns];
//    [self createWebView];
    [self requestData];
}

//返回上一页
- (void)leftButtonClick{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }
    else{
        [_townSelectTableView hiddenActionSheet];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    if (self.navigationController==NULL) {
        [_townSelectTableView hiddenActionSheet];
    }
}

#pragma mark 创建加载视图
-(void)createLoadView{
    __weak __typeof(self) weakSelf=self;
    
    _loadingView = [[DataLoadingView alloc] initWithController:self];
    _loadingView.loadingTitle = KLoading;
    _loadingView.failureTitle = KLoadingFailure;
    _loadingView.reloadHandle = ^(void){
        [weakSelf requestData];
    };
    [_loadingView showLoadingView];
}

#pragma mark 请求数据
-(void)requestData{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    //[params setValue:self.tab forKey:@"examCertType"];
    [params setValue:self.certType forKey:@"examCertType"];
    [params setValue:_region forKey:@"regionName"];
    [params setValue:@"1" forKey:@"flag"];
    
    [[DDHttpManager sharedInstance]sendPostRequest:KHttpRequest_examNoticeDetail2 params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"**********考试通知请求日期数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            [_loadingView hiddenLoadingView];
            
            [_dataSource removeAllObjects];
            if ([responseObject[KData] count]>=1) {
                NSArray *listArray=responseObject[KData];
                if (listArray.count>=1) {
                    for (NSDictionary *dic in listArray) {
                        DDExaminationNotice2DetailModel *model=[[DDExaminationNotice2DetailModel alloc]initWithDictionary:dic error:nil];
                        [_dataSource addObject:model.noticeDate];
                    }
                    _date=_dataSource[0];
                    
                    //通知主线程刷新
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //回调或者说是通知主线程刷新，
                        [self createLoadView];
                        [self createChooseBtns];
                        [self createWebView];
                    });
                    
//                    if ([self.type isEqualToString:@"1"]) {//建造师
//                        _urlStr=[NSString stringWithFormat:@"%@/app/eeexamnotice/detail?examCertType=%@&regionName=%@&noticeYear=%@",DD_Http_Server,self.certType,_region,_date];
//                    }
//                    else{//八大员和安全员
//                        _urlStr=[NSString stringWithFormat:@"%@/app/eeexamnotice/detail?examCertType=%@&regionName=%@&noticeMonth=%@",DD_Http_Server,self.certType,_region,_date];
//                    }
//                    NSString *encodedString = [_urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//                    NSURL * URL = [NSURL URLWithString:encodedString];
//                    NSLog(@"URL全拼%@",_urlStr);
//                    NSMutableURLRequest * resquest = [NSMutableURLRequest requestWithURL:URL];
//                    [self.webView loadRequest:resquest];
//                    [self.view addSubview:self.webView];
                }
            }
            else{
                _label2.text=@"日期筛选";
                CGRect rightTextFrame = [@"日期筛选" boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
                CGFloat rightWidth=rightTextFrame.size.width+4+15;
                if (rightWidth>=(Screen_Width/2-40)) {
                    _label2.frame=CGRectMake(20, 12, (Screen_Width/2-40)-4-15, 15);
                    _imgView2.frame=CGRectMake(CGRectGetMaxX(_label2.frame)+4, 12, 15, 15);
                }
                else{
                    _label2.frame=CGRectMake((Screen_Width/2-rightWidth)/2, 12, rightWidth-4-15, 15);
                    _imgView2.frame=CGRectMake(CGRectGetMaxX(_label2.frame)+4, 12, 15, 15);
                }
            }
        }
        else{
            
            [_loadingView failureLoadingView];
        }
        
    }  failure:^(NSURLSessionDataTask *operation, id responseObject)  {
        [DDUtils showToastWithMessage:kRequestFailed];
        [_loadingView failureLoadingView];
    }];
}


#pragma mark 创建筛选按钮
-(void)createChooseBtns{
    //地区选择按钮
    UIButton *areaSelectBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, Screen_Width/2, 39)];
    [areaSelectBtn setBackgroundColor:kColorWhite];
    
    _label1=[[UILabel alloc]init];
    //_label1.text=@"全国";
    _label1.text=_region;
    _label1.textColor=KColorBlackTitle;
    _label1.font=kFontSize30;
    [areaSelectBtn addSubview:_label1];
    
    _imgView1=[[UIImageView alloc]init];
    _imgView1.contentMode = UIViewContentModeScaleAspectFit;
    _imgView1.image=[UIImage imageNamed:@"home_search_down"];
    [areaSelectBtn addSubview:_imgView1];
    [areaSelectBtn addTarget:self action:@selector(areaSelectClick) forControlEvents:UIControlEventTouchUpInside];
    
    //CGRect leftTextFrame = [@"全国" boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
    CGRect leftTextFrame = [_region boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
    CGFloat leftWidth=leftTextFrame.size.width+4+15;
    if (leftWidth>=(Screen_Width/2-40)) {
        _label1.frame=CGRectMake(20, 12, (Screen_Width/2-40)-4-15, 15);
        _imgView1.frame=CGRectMake(CGRectGetMaxX(_label1.frame)+4, 12, 15, 15);
    }
    else{
        _label1.frame=CGRectMake((Screen_Width/2-leftWidth)/2, 12, leftWidth-4-15, 15);
        _imgView1.frame=CGRectMake(CGRectGetMaxX(_label1.frame)+4, 12, 15, 15);
    }
    
    [self.view addSubview:areaSelectBtn];
    
    //日期筛选按钮
    UIButton *moneySelectBtn=[[UIButton alloc]initWithFrame:CGRectMake(Screen_Width/2, 0, Screen_Width/2, 39)];
    [moneySelectBtn setBackgroundColor:kColorWhite];
    
    _label2=[[UILabel alloc]init];
    if (_dataSource.count>0) {
        if ([self.type isEqualToString:@"2"]) {
            _label2.text=[NSString stringWithFormat:@"%@月",_dataSource[0]];
        }
        else{
            _label2.text=_dataSource[0];
        }
    }
    else{
        _label2.text=@"日期筛选";
    }
    _label2.textColor=KColorBlackTitle;
    _label2.font=kFontSize30;
    [moneySelectBtn addSubview:_label2];
    
    _imgView2=[[UIImageView alloc]init];
    _imgView2.contentMode = UIViewContentModeScaleAspectFit;
    _imgView2.image=[UIImage imageNamed:@"home_search_down"];
    [moneySelectBtn addSubview:_imgView2];
    [moneySelectBtn addTarget:self action:@selector(moneySelectClick) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect rightTextFrame;
    if (_dataSource.count>0) {
        if ([self.type isEqualToString:@"2"]) {
            rightTextFrame = [[NSString stringWithFormat:@"%@月",_dataSource[0]] boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
        }
        else{
            rightTextFrame = [_dataSource[0] boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
        }
    }
    else{
        rightTextFrame = [@"日期筛选" boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
    }
    CGFloat rightWidth=rightTextFrame.size.width+4+15;
    if (rightWidth>=(Screen_Width/2-40)) {
        _label2.frame=CGRectMake(20, 12, (Screen_Width/2-40)-4-15, 15);
        _imgView2.frame=CGRectMake(CGRectGetMaxX(_label2.frame)+4, 12, 15, 15);
    }
    else{
        _label2.frame=CGRectMake((Screen_Width/2-rightWidth)/2, 12, rightWidth-4-15, 15);
        _imgView2.frame=CGRectMake(CGRectGetMaxX(_label2.frame)+4, 12, 15, 15);
    }
    
    [self.view addSubview:moneySelectBtn];
    
//    _townSelectTableView=[[DDExamCitySelectView alloc]initWithFrame:CGRectMake(0, 39, Screen_Width, Screen_Height-KNavigationBarHeight-39)];
//    __weak __typeof(self) weakSelf=self;
//    DDUserManager *manager=[DDUserManager sharedInstance];
//    if (![DDUtils isEmptyString:manager.city]) {
//        _townSelectTableView.type=@"1";
//    }
//    _townSelectTableView.hiddenBlock = ^{
//        weakSelf.imgView1.image=[UIImage imageNamed:@"home_search_down"];
//
//        //[weakSelf.townSelectTableView hiddenActionSheet];
//        [weakSelf.townSelectTableView hidden];
//
//        _isCitySelected=@"0";
//    };
//    _townSelectTableView.delegate=self;
//    [_townSelectTableView show];
}

//创建webView
-(void)createWebView{
    //进度条
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 39, Screen_Width, 2)];
    self.progressView.tintColor = kColorBlue;
    self.progressView.trackTintColor = [UIColor whiteColor];
    //设置进度条的高度，下面这句代码表示进度条的宽度变为原来的1倍，高度变为原来的1.5倍.
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    [self.view addSubview:self.progressView];
    
    self.webView= [[WKWebView alloc] initWithFrame:CGRectMake(0,39,Screen_Width, Screen_Height-KNavigationBarHeight-39)];
    
    //添加KVO，WKWebView有一个属性estimatedProgress，就是当前网页加载的进度，所以监听这个属性。
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    

    //NSURL * URL = [NSURL URLWithString:@"http://www.baidu.com"];
    if ([self.type isEqualToString:@"1"]) {//建造师
        _urlStr=[NSString stringWithFormat:@"%@/app/eeexamnotice/detail?examCertType=%@&regionName=%@&noticeYear=%@",DD_Http_Server,self.certType,_region,_date];
    }
    else{//八大员和安全员
        _urlStr=[NSString stringWithFormat:@"%@/app/eeexamnotice/detail?examCertType=%@&regionName=%@&noticeMonth=%@",DD_Http_Server,self.certType,_region,_date];
    }
    NSString *encodedString = [_urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL * URL = [NSURL URLWithString:encodedString];
    NSLog(@"URL全拼%@",_urlStr);
    NSMutableURLRequest * resquest = [NSMutableURLRequest requestWithURL:URL];

    //[resquest setValue:[NSString stringWithFormat:@"%@=%@",@"X-Token", [DDUserManager sharedInstance].token] forHTTPHeaderField:@"Cookie"];

    [self.webView loadRequest:resquest];
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    self.webView.backgroundColor =kColorWhite;
    [self.view addSubview:self.webView];
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

#pragma mark 点击城市选择
-(void)areaSelectClick{
    if ([_isCitySelected isEqualToString:@"0"]) {
        //将金额筛选隐藏
        _imgView2.image=[UIImage imageNamed:@"home_search_down"];
        //[_moneySelectView hiddenActionSheet];
        _isMoneySelected=@"0";
        
        
        _imgView1.image=[UIImage imageNamed:@"home_search_up"];
        
        [_townSelectTableView noHidden];
        
        _isCitySelected=@"1";
    }
    else{
        _imgView1.image=[UIImage imageNamed:@"home_search_down"];
        
        //[_townSelectTableView hiddenActionSheet];
        [_townSelectTableView hidden];
        
        _isCitySelected=@"0";
    }
}

#pragma mark CitySelectPickerView代理回调
-(void)actionsheetDisappear:(DDExamCitySelectView *)actionSheet andAreaInfo:(NSString *)area{
    NSString *areaStr=area;
    if ([areaStr containsString:@"全省"]) {
        areaStr=[areaStr stringByReplacingOccurrencesOfString:@"全省" withString:@""];
    }
    else if ([areaStr containsString:@"全市"]) {
        areaStr=[areaStr stringByReplacingOccurrencesOfString:@"全市" withString:@""];
    }
    else if ([areaStr containsString:@"全区"]) {
        areaStr=[areaStr stringByReplacingOccurrencesOfString:@"全区" withString:@""];
    }
    
    _region=areaStr;
    
    [self requestData];//重新请求日期数据
    
    CGRect leftTextFrame = [_region boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
    CGFloat leftWidth=leftTextFrame.size.width+4+15;
    if (leftWidth>=(Screen_Width/2-40)) {
        _label1.frame=CGRectMake(20, 12, (Screen_Width/2-40)-4-15, 15);
        _imgView1.frame=CGRectMake(CGRectGetMaxX(_label1.frame)+4, 12, 15, 15);
    }
    else{
        _label1.frame=CGRectMake((Screen_Width/2-leftWidth)/2, 12, leftWidth-4-15, 15);
        _imgView1.frame=CGRectMake(CGRectGetMaxX(_label1.frame)+4, 12, 15, 15);
    }
    
    _label1.text=_region;
    
    
    if ([self.type isEqualToString:@"1"]) {//建造师
        _urlStr=[NSString stringWithFormat:@"%@/app/eeexamnotice/detail?examCertType=%@&regionName=%@&noticeYear=%@",DD_Http_Server,self.certType,_region,_date];
    }
    else{//八大员和安全员
        _urlStr=[NSString stringWithFormat:@"%@/app/eeexamnotice/detail?examCertType=%@&regionName=%@&noticeMonth=%@",DD_Http_Server,self.certType,_region,_date];
    }
    NSString *encodedString = [_urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL * URL = [NSURL URLWithString:encodedString];
    NSLog(@"URL全拼%@",_urlStr);
    NSMutableURLRequest * resquest = [NSMutableURLRequest requestWithURL:URL];
    [self.webView loadRequest:resquest];
}

#pragma mark 点击日期筛选
-(void)moneySelectClick{
    if ([_isMoneySelected isEqualToString:@"0"]) {
        //将区域筛选隐藏
        _imgView1.image=[UIImage imageNamed:@"home_search_down"];
        //[_townSelectTableView hiddenActionSheet];
        [_townSelectTableView hidden];
        _isCitySelected=@"0";
        
        
        _imgView2.image=[UIImage imageNamed:@"home_search_up"];
        
        _dateSheetView= [[DDActionSheetView alloc]initWithFrame:self.view.window.frame];
        _dateSheetView.delegate = self;
        _dateSheetView.type=@"1";
        __weak __typeof(self) weakSelf=self;
        _dateSheetView.arrowChangeBlock = ^{
            weakSelf.imgView2.image=[UIImage imageNamed:@"home_search_down"];
            _isMoneySelected=@"0";
        };
        [_dateSheetView setTitle:_dataSource cancelTitle:@"取消"];
        [_dateSheetView show];
        
        _isMoneySelected=@"1";
    }
    else{
        _imgView2.image=[UIImage imageNamed:@"home_search_down"];
        

        
        _isMoneySelected=@"0";
    }
}


#pragma mark DDActionSheetViewDelegate
-(void)actionsheetSelectButton:(DDActionSheetView *)actionSheet buttonIndex:(NSInteger)index{
    _date=_dataSource[index-1];
    
    _imgView2.image=[UIImage imageNamed:@"home_search_down"];
    _isMoneySelected=@"0";
    
    
    CGRect rightTextFrame;
    if (_dataSource.count>0) {
        if ([self.type isEqualToString:@"2"]) {
            rightTextFrame = [[NSString stringWithFormat:@"%@月",_date] boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
        }
        else{
            rightTextFrame = [_date boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
        }
    }
    else{
        rightTextFrame = [@"日期筛选" boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
    }
    CGFloat rightWidth=rightTextFrame.size.width+4+15;
    if (rightWidth>=(Screen_Width/2-40)) {
        _label2.frame=CGRectMake(20, 12, (Screen_Width/2-40)-4-15, 15);
        _imgView2.frame=CGRectMake(CGRectGetMaxX(_label2.frame)+4, 12, 15, 15);
    }
    else{
        _label2.frame=CGRectMake((Screen_Width/2-rightWidth)/2, 12, rightWidth-4-15, 15);
        _imgView2.frame=CGRectMake(CGRectGetMaxX(_label2.frame)+4, 12, 15, 15);
    }
    
    if (_dataSource.count>0) {
        if ([self.type isEqualToString:@"2"]) {
            _label2.text=[NSString stringWithFormat:@"%@月",_date];
        }
        else{
            _label2.text=_date;
        }
    }
    else{
        _label2.text=@"日期筛选";
    }

    
    
    if ([self.type isEqualToString:@"1"]) {//建造师
        _urlStr=[NSString stringWithFormat:@"%@/app/eeexamnotice/detail?examCertType=%@&regionName=%@&noticeYear=%@",DD_Http_Server,self.certType,_region,_date];
    }
    else{//八大员和安全员
        _urlStr=[NSString stringWithFormat:@"%@/app/eeexamnotice/detail?examCertType=%@&regionName=%@&noticeMonth=%@",DD_Http_Server,self.certType,_region,_date];
    }
    NSString *encodedString = [_urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL * URL = [NSURL URLWithString:encodedString];
    NSLog(@"URL全拼%@",_urlStr);
    NSMutableURLRequest * resquest = [NSMutableURLRequest requestWithURL:URL];
    [self.webView loadRequest:resquest];
}





@end
