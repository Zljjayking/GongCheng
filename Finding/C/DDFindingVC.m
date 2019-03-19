//
//  DDFindingVC.m
//  GongChengDD
//
//  Created by xzx on 2018/11/2.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDFindingVC.h"
#import "DDNavigationUtil.h"
#import "DDLoginCheckVC.h"
#import "NBLScrollTabController.h"//多页面滚动视图工具
#import "DDNewsUnReadCountModel.h"//model
#import "DDFindingEnterpriseVC.h"//查找之企业库页面
#import "DDFindingPeopleVC.h"//查找之人员库页面
#import "DDFindingProjectVC.h"//查找之中标库页面
#import "DDFindingCallBiddingVC.h"//查找之招标库页面
#import "DDFindingConditionQueryVC.h"//条件查询页面
#import "DDMySuperVisionVC.h"//我的监控页面
#import "DDMajorSelectModel.h"
#import "DDMoneySelectModel.h"
@interface DDFindingVC ()<UIScrollViewDelegate,NBLScrollTabControllerDelegate>{
    DDFindingEnterpriseVC *_vc1;
    DDFindingPeopleVC *_vc2;
    DDFindingProjectVC *_vc3;
    DDFindingCallBiddingVC *_vc4;
    NSInteger lastIndex;
}

@property (nonatomic, strong) NBLScrollTabController *scrollTabController;
@property (nonatomic, strong) NSArray *viewControllers;
@property (nonatomic, strong) NSMutableArray *projectClassArray;//工程类别数组
@property (nonatomic, strong) NSMutableArray *moneyArray;//金额数组

@end

@implementation DDFindingVC
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
- (void)viewWillDisappear:(BOOL)animated{
     [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
     [self.navigationController.navigationBar setTranslucent:NO]; // 设置navigationBar的透明效果
}

-(void)viewWillAppear:(BOOL)animated{
    //设置导航栏的背景图片
    [self.navigationController.navigationBar setTranslucent:YES]; // 设置navigationBar的透明效果
    //去除导航栏下方的横线
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init]
                                                  forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];

    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, KNavigationBarHeight)];
    imageView.image=[UIImage imageNamed:@"finding_top"];
    [self.view addSubview:imageView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLab.text=@"查找";
    titleLab.textColor=kColorWhite;
    titleLab.font=kFontSize36Bold;
    titleLab.textAlignment=NSTextAlignmentCenter;
    self.navigationItem.titleView=titleLab;
    self.navigationItem.rightBarButtonItem = [DDUtils rightbuttonItemWithImage:@"zuhechazhao" highlightedImage:@"zuhechazhao" target:self action:@selector(rightButtonClick)];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(itemAction:) name:@"ItemDidClickNotification" object:nil];
//    [self createScrollView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(itemReAction:) name:@"ItemReDidClickNotification" object:nil];
    self.projectClassArray = [NSMutableArray arrayWithCapacity:0];
    self.moneyArray = [NSMutableArray arrayWithCapacity:0];
    [self requestProjectClass];
}
#pragma mark 点击跳转条件查找
- (void)rightButtonClick{
        //通知子页面处理自身的UI
    switch (lastIndex) {
        case 0:
            [_vc1 viewWillCloseView];
            break;
        case 1:
            [_vc2 viewWillCloseView];
            break;
        case 2:
            [_vc3 viewWillCloseView];
            break;
        case 3:
            [_vc4 viewWillCloseView];
            break;
        default:
            break;
    }
    DDFindingConditionQueryVC * vc = [[DDFindingConditionQueryVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//创建滚动视图
-(void)createScrollView{
    NBLScrollTabTheme * theme = [[NBLScrollTabTheme alloc] init];
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, KNavigationBarHeight, Screen_Width, 45)];
    imageView.image=[UIImage imageNamed:@"finding_bottom"];
    [self.view addSubview:imageView];
    theme.indicatorViewColor = kColorWhite;
    theme.titleColor = kColorWhite;
    theme.highlightColor = kColorWhite;
    theme.titleViewBGColor=[UIColor clearColor];
    theme.titleFont=kFontSize30;
    _scrollTabController = [[NBLScrollTabController alloc] initWithTabTheme:theme andType:1];
    _scrollTabController.view.frame = CGRectMake(0, KNavigationBarHeight, Screen_Width, Screen_Height);
    _scrollTabController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _scrollTabController.scrollView.scrollEnabled=NO;//禁止scrollView滑动
    _scrollTabController.delegate = self;
    _scrollTabController.viewControllers = self.viewControllers;
    [self.view addSubview:_scrollTabController.view];
}

- (NSArray *)viewControllers{
    if (!_viewControllers) {
        _vc1 = [[DDFindingEnterpriseVC alloc] init];
        NBLScrollTabItem *item1 = [[NBLScrollTabItem alloc] init];
        item1.title = @"企业库";
        item1.hideBadge = YES;
        _vc1.tabItem = item1;
        _vc1.mainViewContoller = self;
        
        _vc2 = [[DDFindingPeopleVC alloc] init];
        NBLScrollTabItem *item2 = [[NBLScrollTabItem alloc] init];
        item2.title = @"人员库";
        item2.hideBadge = YES;
        _vc2.tabItem = item2;
        _vc2.mainViewContoller = self;
        
        _vc3 = [[DDFindingProjectVC alloc] init];
        NBLScrollTabItem *item3 = [[NBLScrollTabItem alloc] init];
        item3.title = @"中标库";
        item3.hideBadge = YES;
        _vc3.tabItem = item3;
        _vc3.projectClassArray = self.projectClassArray;
        _vc3.moneyArray = self.moneyArray;
        _vc3.mainViewContoller = self;
        
        _vc4 = [[DDFindingCallBiddingVC alloc] init];
        NBLScrollTabItem *item4 = [[NBLScrollTabItem alloc] init];
        item4.title = @"招标库";
        item4.hideBadge = YES;
        _vc4.tabItem = item4;
        _vc4.projectClassArray = self.projectClassArray;
        _vc4.moneyArray = self.moneyArray;
        _vc4.mainViewContoller = self;
        
        _viewControllers = @[_vc1,_vc2,_vc3,_vc4,];
    }
    return _viewControllers;
}

#pragma mark - NBLScrollTabControllerDelegate
- (void)tabController:(NBLScrollTabController * __nonnull)tabController
didSelectViewController:(UIViewController * __nonnull)viewController andIndex:(NSInteger)index{
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)index],@"index",nil];
    //业务逻辑处理
    UITabBarItem *item = [self.tabBarController.tabBar.items objectAtIndex:1];
    item.image = [[UIImage imageNamed:@"tab_find_gray"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    item.selectedImage = [[UIImage imageNamed:@"tab_find_blue"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item.title = @"查找";
    
    //业务逻辑处理
    UITabBarItem *item2 = [self.tabBarController.tabBar.items objectAtIndex:2];
    item2.image = [[UIImage imageNamed:@"tab_service_gray"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    item2.selectedImage = [[UIImage imageNamed:@"tab_service_blue"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item2.title = @"服务";
    
    //业务逻辑处理
    UITabBarItem *item3 = [self.tabBarController.tabBar.items objectAtIndex:3];
    item3.image = [[UIImage imageNamed:@"tab_my_gray"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    item3.selectedImage = [[UIImage imageNamed:@"tab_my_blue"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item3.title = @"我的";
    switch (lastIndex) {
        case 0:
            [_vc1 viewWillCloseView];
            break;
        case 1:
            [_vc2 viewWillCloseView];
            break;
        case 2:
            [_vc3 viewWillCloseView];
            break;
        case 3:
            [_vc4 viewWillCloseView];
            break;
        default:
            break;
    }
    switch (index) {
        case 0:
            [_vc1 viewWillDidCurrentView];
            break;
        case 1:
            [_vc2 viewWillDidCurrentView];
            break;
        case 2:
            [_vc3 viewWillDidCurrentView];
            break;
        case 3:
            [_vc4 viewWillDidCurrentView];
            break;
        default:
            break;
    }
    lastIndex = index;
}
- (void)requestProjectClass {
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:@"410000" forKey:@"certLevl"];
    
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_builderMajorList params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"***********工程类别筛选请求数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {//请求成功
            
            NSArray *listArr= responseObject[KData];
            for (NSDictionary *dic in listArr) {
                DDMajorSelectModel *model=[[DDMajorSelectModel alloc]initWithDictionary:dic error:nil];
                [_projectClassArray addObject:model];
            }
            
            //手动增加"不限"模块
            DDMajorSelectModel * allItem = [[DDMajorSelectModel alloc] init];
            allItem.name = @"不限";
            allItem.cert_type_id = @"";
            [_projectClassArray insertObject:allItem atIndex:0];
            
            [self requestMoneyArray];
        }
        else{//显示异常
            [DDUtils showToastWithMessage:response.message];
        }
        
        
    } failure:^(NSURLSessionDataTask *operation, id responseObject) {
        [DDUtils showToastWithMessage:kRequestFailed];
    }];
}

- (void)requestMoneyArray {
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [params setValue:@"1" forKey:@"type"];
    
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_projecAmount params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"***********金额筛选请求数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {//请求成功
            
            NSArray *listArr= responseObject[KData];
            for (NSDictionary *dic in listArr) {
                DDMoneySelectModel *model=[[DDMoneySelectModel alloc]initWithDictionary:dic error:nil];
                [_moneyArray addObject:model];
            }
            
            //手动增加"其它"按钮
            DDMoneySelectModel * lastModel = [[DDMoneySelectModel alloc] init];
            lastModel.id = @"16";
            lastModel.minMoney = @"";
            lastModel.maxMoney = @"";
            [_moneyArray addObject:lastModel];
            
            //手动增加"不限"按钮
            DDMoneySelectModel * firstModel = [[DDMoneySelectModel alloc] init];
            firstModel.id = @"0";
            firstModel.minMoney = @"";
            firstModel.maxMoney = @"";
            [_moneyArray insertObject:firstModel atIndex:0];
            [self createScrollView];
        }
        else{//显示异常
            [DDUtils showToastWithMessage:response.message];
        }
        
    } failure:^(NSURLSessionDataTask *operation, id responseObject) {
        [DDUtils showToastWithMessage:kRequestFailed];
    }];
}
-(void)itemAction:(NSNotification *)notification{
    NSDictionary *dict = notification.userInfo;
    if ([dict[@"name"] isEqualToString:@"查找"]) {
        if (_scrollTabController.tabView.selectedIndex != 0) {
            [_scrollTabController.tabView setSelectedIndex:0 animated:YES];
        }else{
            [_vc1 viewWillDidCurrentView];
        }
    }
}

-(void)itemReAction:(NSNotification *)notification{
    NSDictionary *dict = notification.userInfo;
    if ([dict[@"name"] isEqualToString:@"回到顶部"]) {
        NSIndexPath* indexPat = [NSIndexPath indexPathForRow:0 inSection:0];
        switch (lastIndex) {
            case 0:
                [_vc1.tableView scrollToRowAtIndexPath:indexPat atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                break;
            case 1:
                [_vc2.tableView scrollToRowAtIndexPath:indexPat atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                break;
            case 2:
                [_vc3.tableView scrollToRowAtIndexPath:indexPat atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                break;
            case 3:
                [_vc4.tableView scrollToRowAtIndexPath:indexPat atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                break;
            default:
                break;
        }
    }
}

#pragma mark dealloc取消通知建观察者
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"ItemDidClickNotification" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"ItemReDidClickNotification" object:nil];
}
@end
