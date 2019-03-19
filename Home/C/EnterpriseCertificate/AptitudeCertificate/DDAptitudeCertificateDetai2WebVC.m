//
//  DDAptitudeCertificateDetai2WebVC.m
//  GongChengDD
//
//  Created by csq on 2018/10/19.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDAptitudeCertificateDetai2WebVC.h"
#import "DDWebViewController.h"
#import "NBLScrollTabController.h"
#import "DDNavigationUtil.h"

@interface DDAptitudeCertificateDetai2WebVC ()<NBLScrollTabControllerDelegate>
@property (nonatomic, strong) NBLScrollTabController *scrollTabController;
@property (nonatomic, strong) NSMutableArray *viewControllers;

@end

@implementation DDAptitudeCertificateDetai2WebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"详情";
    self.view.backgroundColor = kColorBackGroundColor;
    self.navigationItem.leftBarButtonItem = [DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
    
    [DDNavigationUtil  setNavigationBottomLineClearColor:self.navigationController];
    [self setupTopTitleView];
}

#pragma mark 设置顶部标题view
- (void)setupTopTitleView{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.view addSubview:self.scrollTabController.view];
}
- (NBLScrollTabController *)scrollTabController
{
    if (!_scrollTabController) {
        NBLScrollTabTheme * theme = [[NBLScrollTabTheme alloc] init];
        theme.indicatorViewColor = kColorBlue;
        theme.titleColor = kColorBlack;
        theme.highlightColor = kColorBlue;
        theme.titleViewBGColor = kColorNavBarGray;
        
        _scrollTabController = [[NBLScrollTabController alloc] initWithTabTheme:theme andType:1];
     
        _scrollTabController.view.frame =  self.view.bounds;
      
        
        _scrollTabController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollTabController.delegate = self;
        _scrollTabController.viewControllers = self.viewControllers;
    }
    
    return _scrollTabController;
}
- (NSMutableArray *)viewControllers{
    if (!_viewControllers) {
        _viewControllers = [[NSMutableArray alloc] init];
        
        NSArray * titleArr = @[@"标准原文",@"承揽范围"];
        NSArray *urlArr=@[@"2",@"3"];
        
        for (int i=0; i<titleArr.count; i++){
            DDWebViewController * vc = [[DDWebViewController alloc] init];
            
            vc.URLString=[NSString stringWithFormat:@"%@%@?certTypeId=%@&majorType=%@",DD_Http_Server,KHttpRequest_ecqualificationQualExplain,_certTypeId,urlArr[i]];
            
            NBLScrollTabItem *item = [[NBLScrollTabItem alloc] init];
            item.title = titleArr[i];
          
            item.font = kFontSize32;
            
            item.hideBadge = YES;
            vc.tabItem = item;
            [_viewControllers addObject:vc];
        }
        
    }
    return _viewControllers;
}
#pragma mark  NBLScrollTabControllerDelegate
- (void)tabController:(NBLScrollTabController * __nonnull)tabController
didSelectViewController:( UIViewController * __nonnull)viewController{
    //业务逻辑处理
    NSLog(@"++++%@",viewController);
}

#pragma mark 返回上一页
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
