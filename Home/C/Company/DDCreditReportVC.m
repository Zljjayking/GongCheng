//
//  DDCreditReportVC.m
//  GongChengDD
//
//  Created by xzx on 2018/11/27.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDCreditReportVC.h"
#import "DDDownloadReportVC.h"//信用报告页面
#import "DDProjectCheckOriginWebVC.h"//查看样本页面
#import "DDBuyCreditReportVC.h"//购买页面
@interface DDCreditReportVC ()

@end

@implementation DDCreditReportVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor=kColorBackGroundColor;
    self.title=@"信用报告";
    self.navigationItem.leftBarButtonItem=[DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
    [self createUI];
}

#pragma mark 返回上一级
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 画布局
-(void)createUI{
    
    UILabel *signLb = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, Screen_Width-24, 36)];
    [self.view addSubview:signLb];
    signLb.font = kFontSize26;
    signLb.textColor = KColorGreySubTitle;
    NSString *signStr = @"购买报告后可在“我的订单”中开具发票";
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:signStr];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:KColorTextOrange range:NSMakeRange(8, 4)];
    signLb.attributedText = attributedStr;
    
    UIView *bgView1=[[UIView alloc]initWithFrame:CGRectMake(0, 36, Screen_Width, 46)];
    bgView1.backgroundColor=kColorWhite;
    
    UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(14, 0, 120, 46)];
    lab.text=@"企业信用报告";
    lab.textColor=KColorBlackTitle;
    lab.font=kFontSize34;
    [bgView1 addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView1.mas_left).offset(14);
        make.top.equalTo(bgView1);
        make.height.mas_equalTo(46);
    }];
    
    UILabel *priceLab=[[UILabel alloc]init];
    priceLab.text=@"企业信用报告";
    priceLab.textColor=KColorFindingPeopleBlue;
    priceLab.font=[UIFont boldSystemFontOfSize:CustomFontSize(17)];
    priceLab.text = @"¥15";
    [bgView1 addSubview:priceLab];
    [priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lab.mas_right).offset(10);
        make.centerY.equalTo(lab.mas_centerY);
        make.height.mas_equalTo(46);
    }];
    
    UIButton *checkSampleBtn=[[UIButton alloc]initWithFrame:CGRectMake(Screen_Width-14-63, 12.5, 63, 21)];
    [checkSampleBtn setTitle:@"查看样本" forState:UIControlStateNormal];
    [checkSampleBtn setTitleColor:KColorFindingPeopleBlue forState:UIControlStateNormal];
    [checkSampleBtn setBackgroundColor:kColorWhite];
    checkSampleBtn.titleLabel.font=kFontSize24;
    checkSampleBtn.layer.borderColor=KColorFindingPeopleBlue.CGColor;
    checkSampleBtn.layer.borderWidth=0.5;
    checkSampleBtn.layer.cornerRadius=3;
    [checkSampleBtn addTarget:self action:@selector(checkSampleClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView1 addSubview:checkSampleBtn];
    
    [self.view addSubview:bgView1];
    
    
    UIView *bgView2=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(bgView1.frame), Screen_Width, WidthByiPhone6(110)+25)];
    bgView2.backgroundColor=kColorWhite;
    UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 5, Screen_Width, WidthByiPhone6(110))];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    imgView.backgroundColor=kColorWhite;
    imgView.image=[UIImage imageNamed:@"myinfo_creditReport"];
    [bgView2 addSubview:imgView];
    [self.view addSubview:bgView2];
    
    
    UIView *bgView3=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(bgView2.frame)+1, Screen_Width, 46)];
    bgView3.backgroundColor=kColorWhite;
    
    UIButton *downloadBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 3, Screen_Width, 40)];
    [downloadBtn setTitle:@"立即购买报告" forState:UIControlStateNormal];
    [downloadBtn setTitleColor:KColorFindingPeopleBlue forState:UIControlStateNormal];
    [downloadBtn setBackgroundColor:kColorWhite];
    downloadBtn.titleLabel.font=kFontSize32;
    [downloadBtn addTarget:self action:@selector(buyImmediatelyClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView3 addSubview:downloadBtn];
    
    [self.view addSubview:bgView3];
}

#pragma mark 查看样本点击事件
-(void)checkSampleClick{
    
    DDProjectCheckOriginWebVC *vc=[[DDProjectCheckOriginWebVC alloc]init];
    vc.hostUrl=@"http://gcdd.koncendy.com/flib/fs/img/20181128/0b46f2e1f4754ecd8e72f14c9eba57db.pdf";
    vc.hostTitle = @"样本预览";
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 立即下载报告
-(void)downloadImmediatelyClick{
    DDDownloadReportVC *vc=[[DDDownloadReportVC alloc]init];
    vc.email=self.email;
    vc.enterpriseName=self.enterpriseName;
    vc.enterpriseId=self.enterpriseId;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 立即购买报告
- (void)buyImmediatelyClick {
    DDBuyCreditReportVC *vc = [[DDBuyCreditReportVC alloc]init];
    vc.email = self.email;
    vc.enterpriseName = self.enterpriseName;
    vc.enterpriseId = self.enterpriseId;
    vc.price = @"¥15";
    vc.type = 1;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
