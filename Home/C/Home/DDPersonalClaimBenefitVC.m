//
//  DDPersonalClaimBenefitVC.m
//  GongChengDD
//
//  Created by xzx on 2018/12/8.
//  Copyright © 2018年 Koncendy. All rights reserved.
//
#import "DDPersonalClaimBenefitVC.h"
#import "DDPersonalCertiClaimListVC.h"//个人证书认领列表
#import "DDPersonalIdentityCheckVC.h" //认领
#import <UShareUI/UShareUI.h>//友盟分享
#import <MessageUI/MessageUI.h>
@interface DDPersonalClaimBenefitVC ()

@end

@implementation DDPersonalClaimBenefitVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent=NO;
    self.view.backgroundColor=kColorBackGroundColor;
    self.title=@"证书认领的好处";
    self.navigationItem.leftBarButtonItem=[DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
    self.navigationItem.rightBarButtonItem=[DDUtils rightbuttonItemWithImage:@"right_share" highlightedImage:@"right_share" target:self action:@selector(shareClick)];
    [self createUI];
}

#pragma mark 返回上一级
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 画布局
-(void)createUI{
    CGFloat topViewHeight = 50;
    UIScrollView *scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-KNavigationBarHeight-57.5)];
    scrollView.backgroundColor=kColorBackGroundColor;
    [self.view addSubview:scrollView];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 15, Screen_Width, topViewHeight)];
    topView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:topView];
    UILabel * lab = [[UILabel alloc] init];
    lab.frame = CGRectMake(0, 0, CGRectGetWidth(topView.frame), CGRectGetHeight(topView.frame));
    lab.text = @"认领的好处?";
    lab.textColor =  KColorFindingPeopleBlue;
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = KfontSize32Bold;
    [topView addSubview:lab];
    
    [self.view addSubview:scrollView];
    
    UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame), Screen_Width, 727.5*Scale)];
    imgView.backgroundColor=kColorWhite;
    imgView.image=[UIImage imageNamed:@"home_certiBenefit"];
    [scrollView addSubview:imgView];
    scrollView.contentSize=CGSizeMake(Screen_Width, imgView.frameBottom+20);
    UIView *bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, Screen_Height-KNavigationBarHeight-57.5, Screen_Width, 57.5)];
    bottomView.backgroundColor=kColorWhite;
    UIButton *setBtn=[[UIButton alloc]initWithFrame:CGRectMake(15, 17.5/2, Screen_Width-30, 40)];
    [setBtn setTitle:@"去认领" forState:UIControlStateNormal];
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
    if(_claimBenefitType == DDClaimBenefitTypeHomeList){
        DDPersonalCertiClaimListVC *vc=[[DDPersonalCertiClaimListVC alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        DDPersonalIdentityCheckVC *check=[[DDPersonalIdentityCheckVC alloc]init];
        check.peopleName=_peopleName;
        check.staffInfoId = _peopleId;
        check.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:check animated:YES];
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
            
        }else{
            
        }
        
    }];
}

@end
