//
//  DDAdminPunishVC.m
//  GongChengDD
//
//  Created by xzx on 2018/5/17.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDAdminPunishVC.h"
#import "DDNavigationUtil.h"
#import "DataLoadingView.h"
#import "DDAdminPunishModel.h"//model
#import "NBLScrollTabController.h"//多页面滚动视图工具
#import "DDAdminPunishConstructDeptVC.h"//建设部门
#import "DDAdminPunishTaxBureauVC.h"//税务局
#import "DDAdminPunishBusinessBureauVC.h"//工商局
#import "DDAdminPunishCreditChinaVC.h"//信用中国

@interface DDAdminPunishVC ()<NBLScrollTabControllerDelegate>

@property (nonatomic, strong) NBLScrollTabController *scrollTabController;
@property (nonatomic, strong) NSArray *viewControllers;
@property (strong,nonatomic) DataLoadingView *loadingView;
@property (strong,nonatomic) DDAdminPunishModel *model;

@end

@implementation DDAdminPunishVC

-(void)viewWillDisappear:(BOOL)animated{
    //还原导航底部线条颜色
    [DDNavigationUtil setNavigationBottomLineNomalColor:self.navigationController];
}

-(void)viewWillAppear:(BOOL)animated{
    //导航底部线条设为透明
    [DDNavigationUtil setNavigationBottomLineClearColor:self.navigationController];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self editNavItem];
    [self createLoadView];
    [self requestNumberData];
}

//定制导航条
-(void)editNavItem{
    self.view.backgroundColor=kColorBackGroundColor;
    self.title=@"行政处罚";
    self.navigationItem.leftBarButtonItem=[DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
}

//返回上一页
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 创建加载视图
-(void)createLoadView{
    __weak __typeof(self) weakSelf=self;
    _loadingView = [[DataLoadingView alloc] initWithController:self];
    _loadingView.loadingTitle = KLoading;
    _loadingView.failureTitle = KLoadingFailure;
    _loadingView.reloadHandle = ^(void){
        [weakSelf requestNumberData];
    };
    [_loadingView showLoadingView];
}

//请求数量数据
-(void)requestNumberData{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [params setValue:self.enterpriseId forKey:@"enterpriseId"];
//    [params setValue:self.enterpriseId forKey:@"punishId"];
    
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_companyAdminPunishListCount params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"***********行政处罚数量请求数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {//请求成功
            [_loadingView hiddenLoadingView];
            
            _model=[[DDAdminPunishModel alloc]initWithDictionary:responseObject[KData] error:nil];
            
            [self createScrollView];
        }
        else{//显示异常
            //[DDUtils showToastWithMessage:response.message];
            [_loadingView failureLoadingView];
        }
        
    } failure:^(NSURLSessionDataTask *operation, id responseObject) {
        [DDUtils showToastWithMessage:kRequestFailed];
        [_loadingView failureLoadingView];
    }];
}

//创建滚动视图
-(void)createScrollView{
    NBLScrollTabTheme * theme = [[NBLScrollTabTheme alloc] init];
    theme.indicatorViewColor = kColorBlue;
    theme.titleColor = KColorBlackTitle;
    //theme.highlightColor = KColorCompanyTitleBalck;
    theme.highlightColor = kColorBlue;
    theme.titleViewBGColor=kColorWhite;
    
    theme.titleFont=kFontSize30;
    //    if ([UIScreen mainScreen].scale==2) {
    //        theme.titleFont=kFontSize32;
    //    }
    //    else{
    //        theme.titleFont=kFontSize34;
    //    }
    
    _scrollTabController = [[NBLScrollTabController alloc] initWithTabTheme:theme andType:1];
    //_scrollTabController.view.frame = CGRectMake(0, 144+15, Screen_Width, Screen_Height-KNavigationBarHeight-144-15);
    _scrollTabController.view.frame = CGRectMake(0, 0, Screen_Width, Screen_Height-KNavigationBarHeight);
    _scrollTabController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _scrollTabController.scrollView.scrollEnabled=NO;//禁止scrollView滑动
    _scrollTabController.delegate = self;
    _scrollTabController.viewControllers = self.viewControllers;
    [self.view addSubview:_scrollTabController.view];
    
    //UILabel *line=[[UILabel alloc]initWithFrame:CGRectMake(0, 144+15+45, Screen_Width, 1)];
    UILabel *line=[[UILabel alloc]initWithFrame:CGRectMake(0, 45, Screen_Width, 1)];
    line.backgroundColor=kColorNavBottomLineGray;
    line.alpha=0.5;
    [self.view addSubview:line];
}

- (NSArray *)viewControllers{
    if (!_viewControllers) {
        
        DDAdminPunishConstructDeptVC *vc0 = [[DDAdminPunishConstructDeptVC alloc] init];
        vc0.type = @"-1";
        NBLScrollTabItem *item0 = [[NBLScrollTabItem alloc] init];
        int allCount = 0;
        int num0 = 0;
        int num1 = 0;
        int num2 = 0;
        int num3 = 0;
        if (![DDUtils isEmptyString:_model.num0]) {
            num0 = [_model.num0 intValue];
        }
        if (![DDUtils isEmptyString:_model.num1]) {
            num1 = [_model.num1 intValue];
        }
        if (![DDUtils isEmptyString:_model.num2]) {
            num2 = [_model.num2 intValue];
        }
        if (![DDUtils isEmptyString:_model.num3]) {
            num3 = [_model.num3 intValue];
        }
        allCount = num0+num1+num2+num3;
        item0.title = [NSString stringWithFormat:@"全部%d",allCount];
        item0.hideBadge = YES;
        vc0.tabItem = item0;
        vc0.enterpriseId=self.enterpriseId;
        vc0.toAction=self.toAction;
        vc0.mainViewContoller = self;
        
        DDAdminPunishConstructDeptVC *vc1 = [[DDAdminPunishConstructDeptVC alloc] init];
        NBLScrollTabItem *item1 = [[NBLScrollTabItem alloc] init];
        if ([DDUtils isEmptyString:_model.num0]) {
            item1.title = @"建设部门0";
        }
        else{
            item1.title = [NSString stringWithFormat:@"建设部门%@",_model.num0];
        }
        item1.hideBadge = YES;
        vc1.tabItem = item1;
        vc1.enterpriseId=self.enterpriseId;
        vc1.toAction=self.toAction;
        vc1.mainViewContoller = self;
        
        DDAdminPunishTaxBureauVC *vc2 = [[DDAdminPunishTaxBureauVC alloc] init];
        NBLScrollTabItem *item2 = [[NBLScrollTabItem alloc] init];
        if ([DDUtils isEmptyString:_model.num1]) {
            item2.title = @"税务局";
        }
        else{
            item2.title = [NSString stringWithFormat:@"税务局%@",_model.num1];
        }
        item2.hideBadge = YES;
        vc2.tabItem = item2;
        vc2.enterpriseId=self.enterpriseId;
        vc2.toAction=self.toAction;
        vc2.mainViewContoller = self;
        
        DDAdminPunishBusinessBureauVC *vc3 = [[DDAdminPunishBusinessBureauVC alloc] init];
        NBLScrollTabItem *item3 = [[NBLScrollTabItem alloc] init];
        if ([DDUtils isEmptyString:_model.num2]) {
            item3.title = @"工商局";
        }
        else{
            item3.title = [NSString stringWithFormat:@"工商局%@",_model.num2];
        }
        item3.hideBadge = YES;
        vc3.tabItem = item3;
        vc3.enterpriseId=self.enterpriseId;
        vc3.toAction=self.toAction;
        vc3.mainViewContoller = self;
        
        DDAdminPunishCreditChinaVC *vc4 = [[DDAdminPunishCreditChinaVC alloc] init];
        NBLScrollTabItem *item4 = [[NBLScrollTabItem alloc] init];
        if ([DDUtils isEmptyString:_model.num3]) {
            item4.title = @"信用中国";
        }
        else{
            item4.title = [NSString stringWithFormat:@"信用中国%@",_model.num3];
        }
        item4.hideBadge = YES;
        vc4.tabItem = item4;
        vc4.enterpriseId=self.enterpriseId;
        vc4.toAction=self.toAction;
        vc4.mainViewContoller = self;
        
        
        _viewControllers = @[vc0,vc1,vc2,vc3,vc4];
        //_viewControllers = @[vc1,vc2];
    }
    return _viewControllers;
}

#pragma mark - NBLScrollTabControllerDelegate
- (void)tabController:(NBLScrollTabController * __nonnull)tabController
didSelectViewController:(UIViewController * __nonnull)viewController{
    //业务逻辑处理
    NSLog(@"++++%@",viewController);
}



@end
