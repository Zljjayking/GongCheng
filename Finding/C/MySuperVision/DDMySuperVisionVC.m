//
//  DDMySuperVisionVC.m
//  GongChengDD
//
//  Created by xzx on 2018/11/22.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDMySuperVisionVC.h"
#import "NBLScrollTabController.h"//多页面滚动视图工具
#import "DDMySuperVisionDynamicListVC.h"//监控动态页面
#import "DDMySuperVisionListVC.h"//监控列表页面
#import "DDSuperVisionSettingVC.h"//监控设置页面

@interface DDMySuperVisionVC ()<NBLScrollTabControllerDelegate>

@property (nonatomic, strong) NBLScrollTabController *scrollTabController;
@property (nonatomic, strong) NSArray *viewControllers;

@end

@implementation DDMySuperVisionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent=NO;
    self.view.backgroundColor=kColorBackGroundColor;
    self.title=@"我的监控";
    self.navigationItem.leftBarButtonItem=[DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"我的" target:self action:@selector(leftButtonClick)];
//    self.navigationItem.rightBarButtonItem=[DDUtils rightbuttonItemWithTitle:@"设置" target:self action:@selector(settingClick)];
    [self createScrollView];
}

#pragma mark 返回上一级
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

//#pragma mark 设置点击按钮
//-(void)settingClick{
//    DDSuperVisionSettingVC *superVisionSetting=[[DDSuperVisionSettingVC alloc]init];
//    [self.navigationController pushViewController:superVisionSetting animated:YES];
//}

//创建滚动视图
-(void)createScrollView{
    NBLScrollTabTheme * theme = [[NBLScrollTabTheme alloc] init];
    theme.indicatorViewColor = kColorBlue;
    theme.titleColor = KColorGreySubTitle;
    //theme.highlightColor = KColorCompanyTitleBalck;
    theme.highlightColor = kColorBlue;
    theme.titleViewBGColor=kColorWhite;
    theme.titleFont=kFontSize30;
    
    _scrollTabController = [[NBLScrollTabController alloc] initWithTabTheme:theme andType:1];
    _scrollTabController.view.frame = CGRectMake(0, 0, Screen_Width, Screen_Height);
    _scrollTabController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _scrollTabController.scrollView.scrollEnabled=NO;//禁止scrollView滑动
    _scrollTabController.delegate = self;
    _scrollTabController.viewControllers = self.viewControllers;
    [self.view addSubview:_scrollTabController.view];
    
    UILabel *line=[[UILabel alloc]initWithFrame:CGRectMake(0, 45, Screen_Width, 1)];
    line.backgroundColor=kColorNavBottomLineGray;
    line.alpha=0.5;
    [self.view addSubview:line];
}

- (NSArray *)viewControllers{
    if (!_viewControllers) {
        
        DDMySuperVisionDynamicListVC *vc1 = [[DDMySuperVisionDynamicListVC alloc] init];
        vc1.refreshNoticeBlock = ^{
            if (self.refreshNoticeItemBlock) {
                self.refreshNoticeItemBlock();
            }
        };
        NBLScrollTabItem *item1 = [[NBLScrollTabItem alloc] init];
        item1.title = @"监控动态";
        item1.hideBadge = YES;
        vc1.tabItem = item1;
        vc1.mainViewContoller = self;
        
        DDMySuperVisionListVC *vc2 = [[DDMySuperVisionListVC alloc] init];
        NBLScrollTabItem *item2 = [[NBLScrollTabItem alloc] init];
        item2.title = @"监控列表";
        item2.hideBadge = YES;
        vc2.tabItem = item2;
        vc2.mainViewContoller = self;
        
        _viewControllers = @[vc1,vc2];
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
