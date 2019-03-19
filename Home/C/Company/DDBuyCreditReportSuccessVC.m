//
//  DDBuyCreditReportSuccessVC.m
//  GongChengDD
//
//  Created by csq on 2019/2/22.
//  Copyright © 2019 Koncendy. All rights reserved.
//

#import "DDBuyCreditReportSuccessVC.h"
#import "DDMyCreditReportListVC.h"
#import "DDCompanyDetailVC.h"
#import "DDMyMenusListVC.h"
#import "DDMyMenusDetailVC.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "DDServiceVC.h"
#import "DDMyCreditReportListVC.h"
@interface DDBuyCreditReportSuccessVC ()<UINavigationControllerDelegate>
@end

@implementation DDBuyCreditReportSuccessVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //禁用滑动返回
    self.fd_interactivePopDisabled = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //开启滑动返回
    self.fd_interactivePopDisabled = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=kColorBackGroundColor;
    self.title=@"在线支付";
    self.navigationItem.leftBarButtonItem=[DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
    if (self.type == 5 || self.type == 6 || self.type == 7) {
        if (self.refreshBlock) {
            self.refreshBlock();
        }
    }
    if (self.type == 6 || self.type == 7) {
        if (self.refreshDetailBlock) {
            self.refreshDetailBlock(self.model);
        }
    }
    [self createUI];
}
#pragma mark 返回上一级
- (void)leftButtonClick{
    if (self.type == 1 || self.type == 2) {
        UINavigationController *nvc=self.navigationController;
        for (UIViewController *vc in [nvc viewControllers]) {
            if ([vc isKindOfClass:[DDCompanyDetailVC class]]) {
                [self.navigationController popToViewController:vc animated:YES];
                break;
            }
        }
    }else if (self.type == 3){//返回信用报告
        UINavigationController *nvc=self.navigationController;
        for (UIViewController *vc in [nvc viewControllers]) {
            if ([vc isKindOfClass:[DDMyCreditReportListVC class]]) {
                [self.navigationController popToViewController:vc animated:YES];
                break;
            }
        }
    }else if (self.type == 8){//返回服务界面
        UINavigationController *nvc=self.navigationController;
        for (UIViewController *vc in [nvc viewControllers]) {
            if ([vc isKindOfClass:[DDServiceVC class]]) {
                [self.navigationController popToViewController:vc animated:YES];
                break;
            }
        }
    }else {
        UINavigationController *nvc=self.navigationController;
        for (UIViewController *vc in [nvc viewControllers]) {
            if ([vc isKindOfClass:[DDMyMenusListVC class]]) {
                [self.navigationController popToViewController:vc animated:YES];
                break;
            }
        }
    }
}
- (void)createUI {
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 15, Screen_Width, Screen_Height-KNavigationBarHeight-15)];
    bgView.backgroundColor=kColorWhite;
    [self.view addSubview:bgView];
    
    UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake((Screen_Width-72)/2, 60, 72, 72)];
    imgView.image=[UIImage imageNamed:@"home_company_checkSuccess"];
    [bgView addSubview:imgView];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imgView.frame)+26, Screen_Width, 15)];
    label.text=@"支付成功，正在生成报告";
    if (self.type == 2 || self.type == 3 || self.type == 6 || self.type == 7 || self.type == 8) {
        label.text=@"支付成功";
    }
    
    label.textColor=KColorCompanyTitleBalck;
    label.font=kFontSize36;
    label.textAlignment=NSTextAlignmentCenter;
    [bgView addSubview:label];
    
    UIButton *lookBtn=[[UIButton alloc]initWithFrame:CGRectMake((Screen_Width-300)/2, CGRectGetMaxY(label.frame)+60, 300, 40)];
    [lookBtn setTitle:@"查看信用报告" forState:UIControlStateNormal];
    if (self.type == 2 || self.type == 3 || self.type == 6 || self.type == 7 || self.type == 8) {
        [lookBtn setTitle:@"查看订单详情" forState:UIControlStateNormal];
    }
    [lookBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
    lookBtn.titleLabel.font=kFontSize36;
    lookBtn.backgroundColor = kColorBlue;
    lookBtn.layer.cornerRadius=3;
    [lookBtn addTarget:self action:@selector(lookClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:lookBtn];
    
    UIButton *completeBtn=[[UIButton alloc]initWithFrame:CGRectMake((Screen_Width-300)/2, CGRectGetMaxY(lookBtn.frame)+20, 300, 40)];
    [completeBtn setTitle:@"完成" forState:UIControlStateNormal];
    [completeBtn setTitleColor:KColorFindingPeopleBlue forState:UIControlStateNormal];
    completeBtn.titleLabel.font=kFontSize36;
    completeBtn.layer.cornerRadius=3;
    completeBtn.layer.borderColor=KColorFindingPeopleBlue.CGColor;
    completeBtn.layer.borderWidth=1;
    [completeBtn addTarget:self action:@selector(completeClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:completeBtn];
}

- (void)lookClick{
    if (self.type == 3) {
        DDMyMenusDetailVC *vc = [[DDMyMenusDetailVC alloc] init];
        vc.type = @"7";
        vc.orderId = self.orderID;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (self.type == 2) {
        DDMyMenusDetailVC *vc = [[DDMyMenusDetailVC alloc] init];
        vc.type = @"6";
        vc.orderId = self.orderID;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (self.type == 6) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }else if (self.type == 7) {
        DDMyMenusDetailVC *vc = [[DDMyMenusDetailVC alloc] init];
        vc.deleteBlock = ^{
            if (self.deleteBlock) {
                self.deleteBlock();
            }
        };
        vc.type = @"5";
        vc.orderId = self.orderID;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (self.type == 8) {
        DDMyMenusDetailVC *vc = [[DDMyMenusDetailVC alloc] init];
        vc.type = @"8";
        vc.orderId = self.orderID;
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        DDMyCreditReportListVC *vc=[[DDMyCreditReportListVC alloc]init];
        vc.myCreditReportType = MyCreditReportTypeDownLoad;
        vc.type = 1;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)completeClick {
    if (self.type == 4 || self.type == 5 || self.type == 6 || self.type == 7) {
        UINavigationController *nvc=self.navigationController;
        for (UIViewController *vc in [nvc viewControllers]) {
            if ([vc isKindOfClass:[DDMyMenusListVC class]]) {
                [self.navigationController popToViewController:vc animated:YES];
                break;
            }
        }
        
    }else if (self.type == 3){//返回信用报告
        UINavigationController *nvc=self.navigationController;
        for (UIViewController *vc in [nvc viewControllers]) {
            if ([vc isKindOfClass:[DDMyCreditReportListVC class]]) {
                [self.navigationController popToViewController:vc animated:YES];
                break;
            }
        }
    }else if (self.type == 8){//返回服务界面
        UINavigationController *nvc=self.navigationController;
        for (UIViewController *vc in [nvc viewControllers]) {
            if ([vc isKindOfClass:[DDServiceVC class]]) {
                [self.navigationController popToViewController:vc animated:YES];
                break;
            }
        }
    }else {
        
        UINavigationController *nvc=self.navigationController;
        for (UIViewController *vc in [nvc viewControllers]) {
            if ([vc isKindOfClass:[DDCompanyDetailVC class]]) {
                [self.navigationController popToViewController:vc animated:YES];
                break;
            }
        }
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
