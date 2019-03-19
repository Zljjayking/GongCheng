//
//  DDPersonalCheckSuccessVC.m
//  GongChengDD
//
//  Created by xzx on 2018/9/28.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDPersonalCheckSuccessVC.h"
#import "DDMyCertificateVC.h"//我的证书页面

@interface DDPersonalCheckSuccessVC ()

@end

@implementation DDPersonalCheckSuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    if ([self.type isEqualToString:@"1"]) {
//        self.title=@"申诉成功";
//    }
//    else{
//        self.title=@"认领成功";
//    }
    self.view.backgroundColor=kColorBackGroundColor;
    self.navigationItem.leftBarButtonItem = [DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
    [self createSuccessViews];
}

#pragma mark 返回
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
    self.popbackBlock();
}

-(void)createSuccessViews{
    UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake((Screen_Width-72)/2, 100, 72, 72)];
    imgView.image=[UIImage imageNamed:@"home_company_checkSuccess"];
    [self.view addSubview:imgView];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imgView.frame)+30, Screen_Width, 20)];
    if ([self.type isEqualToString:@"1"]) {
        label.text=@"申诉成功";
    }
    else{
        label.text=@"认领成功";
    }
    label.textColor=kColorBlue;
    label.font=KFontSize42;
    label.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    UIButton *otherBtn=[[UIButton alloc]initWithFrame:CGRectMake((Screen_Width-210)/2, CGRectGetMaxY(label.frame)+120, 210, 40)];
    [otherBtn addTarget:self action:@selector(checkOtherClick) forControlEvents:UIControlEventTouchUpInside];
    [otherBtn setBackgroundColor:kColorBlue];
    [otherBtn setTitle:@"继续查看其它证书" forState:UIControlStateNormal];
    [otherBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
    otherBtn.titleLabel.font=kFontSize32;
    otherBtn.layer.cornerRadius=3;
    [self.view addSubview:otherBtn];
    
    
    UIButton *myBtn=[[UIButton alloc]initWithFrame:CGRectMake((Screen_Width-210)/2, CGRectGetMaxY(otherBtn.frame)+25, 210, 40)];
    [myBtn addTarget:self action:@selector(myCertiClick) forControlEvents:UIControlEventTouchUpInside];
    [myBtn setBackgroundColor:kColorWhite];
    [myBtn setTitle:@"我认领的证书" forState:UIControlStateNormal];
    [myBtn setTitleColor:kColorBlue forState:UIControlStateNormal];
    myBtn.titleLabel.font=kFontSize32;
    myBtn.layer.cornerRadius=3;
    myBtn.layer.borderColor=kColorBlue.CGColor;
    myBtn.layer.borderWidth=1;
    [self.view addSubview:myBtn];
}

#pragma mark 继续查看其它证书
-(void)checkOtherClick{
    [self.navigationController popViewControllerAnimated:NO];
    self.popbackBlock();
}

#pragma mark 我认领的证书
-(void)myCertiClick{
    DDMyCertificateVC *myCertificate=[[DDMyCertificateVC alloc]init];
    [self.navigationController pushViewController:myCertificate animated:YES];
}


@end
