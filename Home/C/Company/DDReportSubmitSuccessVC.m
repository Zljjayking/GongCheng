//
//  DDReportSubmitSuccessVC.m
//  GongChengDD
//
//  Created by xzx on 2018/11/29.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDReportSubmitSuccessVC.h"
#import "DDMyCreditReportListVC.h"
#import "DDCompanyDetailVC.h"
@interface DDReportSubmitSuccessVC ()

@end

@implementation DDReportSubmitSuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor=kColorBackGroundColor;
    self.title=@"提交成功";
    self.navigationItem.leftBarButtonItem=[DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
    [self createUI];
}

#pragma mark 返回上一级
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 创建UI布局
-(void)createUI{
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-KNavigationBarHeight)];
    bgView.backgroundColor=kColorWhite;
    [self.view addSubview:bgView];
    
    UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake((Screen_Width-72)/2, 60, 72, 72)];
    imgView.image=[UIImage imageNamed:@"home_company_checkSuccess"];
    [bgView addSubview:imgView];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imgView.frame)+26, Screen_Width, 15)];
    label.text=@"正在生成报告";
    label.textColor=KColorCompanyTitleBalck;
    label.font=kFontSize36;
    label.textAlignment=NSTextAlignmentCenter;
    [bgView addSubview:label];
    
    UIButton *lookBtn=[[UIButton alloc]initWithFrame:CGRectMake((Screen_Width-300)/2, CGRectGetMaxY(label.frame)+60, 300, 40)];
    [lookBtn setTitle:@"查看报告" forState:UIControlStateNormal];
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

#pragma mark 完成点击事件
-(void)completeClick{
    UINavigationController *nvc=self.navigationController;
    for (UIViewController *vc in [nvc viewControllers]) {
        if ([vc isKindOfClass:[DDCompanyDetailVC class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
}

-(void)lookClick{
    DDMyCreditReportListVC *vc=[[DDMyCreditReportListVC alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.myCreditReportType = MyCreditReportTypeDownLoad;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
