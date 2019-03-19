//
//  DDTalentSubscribeBenefitVC.m
//  GongChengDD
//
//  Created by xzx on 2018/11/24.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDTalentSubscribeBenefitVC.h"
#import "DDTalentSubscribeVC.h"//人才订阅页面

@interface DDTalentSubscribeBenefitVC ()

@end

@implementation DDTalentSubscribeBenefitVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent=NO;
    self.view.backgroundColor=kColorBackGroundColor;
    self.title=@"人才订阅";
    self.navigationItem.leftBarButtonItem=[DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
    [self createUI];
}

#pragma mark 返回上一级
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 画布局
-(void)createUI{
    UIScrollView *scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-KNavigationBarHeight-57.5)];
    scrollView.backgroundColor=kColorBackGroundColor;
    scrollView.contentSize=CGSizeMake(Screen_Width, 15+648.5*Scale+15);
    [self.view addSubview:scrollView];
    
    UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 15, Screen_Width, 648.5*Scale)];
    imgView.backgroundColor=kColorWhite;
    imgView.image=[UIImage imageNamed:@"finding_renyuan"];
    [scrollView addSubview:imgView];
    
    UIView *bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, Screen_Height-KNavigationBarHeight-57.5, Screen_Width, 57.5)];
    bottomView.backgroundColor=kColorWhite;
    UIButton *setBtn=[[UIButton alloc]initWithFrame:CGRectMake(15, 17.5/2, Screen_Width-30, 40)];
    [setBtn setTitle:@"去设置" forState:UIControlStateNormal];
    [setBtn setBackgroundColor:KColorFindingPeopleBlue];
    setBtn.titleLabel.font=kFontSize32;
    [setBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
    setBtn.layer.cornerRadius=3;
    [setBtn addTarget:self action:@selector(goSettingClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:setBtn];
    [self.view addSubview:bottomView];
}

#pragma mark 去设置点击事件
-(void)goSettingClick{
    DDTalentSubscribeVC *talentSubscribe=[[DDTalentSubscribeVC alloc]init];
    [self.navigationController pushViewController:talentSubscribe animated:YES];
}



@end
