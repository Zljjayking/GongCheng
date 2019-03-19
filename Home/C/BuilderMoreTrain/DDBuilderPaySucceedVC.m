//
//  DDBuilderPaySucceedVC.m
//  GongChengDD
//
//  Created by xzx on 2018/12/29.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDBuilderPaySucceedVC.h"
#import "DDTrainFinishDetailVC.h"//查看详情
#import "DDUnInvoiceVC.h"//开发票页面
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "DDBuilderMoreTrainVC.h"//建造师列表页面
#import "DDBuilderAddApplyRecordVC.h"//建造师添加报名记录页面

#import "DDSafeManMoreTrainVC.h"//安全员建造师页面
#import "DDSafeManAddApplyRecordVC.h"//安全员添加报名记录页面
#import "DDSafeManAgencySelectVC.h"//安全员机构选择页面


#import "DDSafeManNewAddApplyRecordVC.h"

#import "DDLiveManagerNewAddApplyRecordVC.h"//现场管理员新培添加报名记录页面
#import "DDLiveManagerNewAgencySelectVC.h"//现场管理员新培机构选择页面
#import "DDLiveManagerMoreAgencySelectVC.h"//现场管理员继续教育机构选择页面
#import "DDLiveManagerMoreAddApplyRecordVC.h"//现场管理员继续教育添加报名记录页面

#import "DDAgencySelectViewController.h" // 机构选择
#import "DDMyTrainVC.h" // 我的报名
#import "DDSafeManMoreTrainVC.h"

@interface DDBuilderPaySucceedVC ()
@property (nonatomic,strong) UIImageView *succeedImgV;
@property (nonatomic,strong) UILabel *succeedL;
@property (nonatomic,strong) UIButton *detailsBtn;
@property (nonatomic,strong) UIButton *applyBtn;

@end

@implementation DDBuilderPaySucceedVC

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
    self.view.backgroundColor = kColorWhite;
    self.title=@"在线支付";
    self.navigationItem.leftBarButtonItem = [DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
    [self creatUI];
}
-(void)detailsAction:(UIButton *)sender{
    DDTrainFinishDetailVC *detailsVC = [[DDTrainFinishDetailVC alloc]init];
    detailsVC.trainFinishType = DDTrainFinishTypePay;
    detailsVC.orderIdStr = _orderId;
    if ([DDUtils isEmptyString:self.vcName]) {
        detailsVC.vcName=@"DDBuilderMoreTrainVC";
    }
    else{
        detailsVC.vcName=self.vcName;
    }
    [self.navigationController pushViewController:detailsVC animated:YES];
}

/**
 检查是否可以开发票
 */
- (void)loadIsOpenInvoice:(void (^)(BOOL isSuccess))block {
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:@(DDReceiptTypeTrain) forKey:@"type"];
    
    MBProgressHUD * hud = [DDUtils showHUDCustom:@""];
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_loadIsOpenInvoice params:param success:^(NSURLSessionDataTask *operation, id responseObject) {
        [hud hide:YES];
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess && [response.data intValue] == 1) {//请求成功
            
            block(YES);
        } else {
            
            block(NO);
        }
    } failure:^(NSURLSessionDataTask *operation, id responseObject) {
        [hud hide:YES];
        [DDUtils showToastWithMessage:kRequestFailed];
    }];
}

-(void)applyAction:(UIButton *)sender{
    
    [self loadIsOpenInvoice:^(BOOL isSuccess) {
       
        DDUserManager *userManager=[DDUserManager sharedInstance];
        DDUnInvoiceVC *bill=[[DDUnInvoiceVC alloc]init];
        bill.orderId=userManager.orderId;
        bill.type=_isFromeExam;
        bill.receiptType = self.receiptType;
        if ([DDUtils isEmptyString:self.vcName]) {
            bill.vcName=@"DDBuilderMoreTrainVC";
        } else {
            bill.vcName=self.vcName;
        }
        if (isSuccess) {
            
            bill.bespeak = 0;
            [self.navigationController pushViewController:bill animated:YES];
        } else {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"非常抱歉！因平台税务开票系统单数限制，您可以选择下月再申请发票或立即预约您的发票，预约后将于下月初优先安排出票并及时通知您。敬请谅解！" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"立即预约" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                bill.bespeak = 1;
                [self.navigationController pushViewController:bill animated:YES];
            }];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"下次申请" style:UIAlertActionStyleCancel handler:nil];
            
            [alert addAction:okAction];
            [alert addAction:cancelAction];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}
#pragma mark 返回按钮点击事件
- (void)leftButtonClick{
    UINavigationController *nvc=self.navigationController;
    if ([self.vcName isEqualToString:@"DDBuilderMoreTrainVC"]) {//返回到建造师报名列表页面
        
    }
    if ([self.vcName isEqualToString:@"DDExamProgressVC"]) {//返回到上一层
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    
    for (UIViewController *vc in [nvc viewControllers]) {
        
        if ([vc isKindOfClass:[DDBuilderAddApplyRecordVC class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
        
        if ([vc isKindOfClass:[DDSafeManAddApplyRecordVC class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
        
        if ([_isFromeAddApply integerValue] == 0) {
            if ([vc isKindOfClass:[DDBuilderMoreTrainVC class]]) {
                [self.navigationController popToViewController:vc animated:YES];
                return;
            }
            if ([vc isKindOfClass:[DDSafeManMoreTrainVC class]]) {
                [self.navigationController popToViewController:vc animated:YES];
                return;
            }
        }
        
        if ([vc isKindOfClass:[DDAgencySelectViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
        
        if ([vc isKindOfClass:[DDBuilderMoreTrainVC class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
        
        if ([vc isKindOfClass:[DDSafeManMoreTrainVC class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
        
        if ([vc isKindOfClass:[DDMyTrainVC class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)creatUI{
    [self.view addSubview:self.succeedImgV];
    [self.view addSubview:self.succeedL];
    [self.view addSubview:self.detailsBtn];
    [self.view addSubview:self.applyBtn];
    [self.succeedImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(WidthByiPhone6(93));
        make.centerX.equalTo(self.view);
        make.width.height.mas_equalTo(WidthByiPhone6(72));
    }];
    [self.succeedL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.succeedImgV.mas_bottom).offset(WidthByiPhone6(30));
        make.centerX.equalTo(self.view);
    }];
    [self.detailsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.succeedL.mas_bottom).offset(WidthByiPhone6(80));
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(WidthByiPhone6(44));
        make.width.mas_equalTo(WidthByiPhone6(250));
    }];
    [self.applyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailsBtn.mas_bottom).offset(WidthByiPhone6(20));
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(WidthByiPhone6(44));
        make.width.mas_equalTo(WidthByiPhone6(250));
    }];
}
#pragma mark -- lazyload
-(UIImageView *)succeedImgV{
    if(!_succeedImgV){
        _succeedImgV = [[UIImageView alloc]initWithImage:DDIMAGE(@"paysuccess")];
    }
    return _succeedImgV;
}
-(UILabel *)succeedL{
    if(!_succeedL){
        _succeedL = [UILabel labelWithFont:KFontSize42 textString:@"支付成功" textColor:KColorFindingPeopleBlue textAlignment:NSTextAlignmentCenter numberOfLines:1];
    }
    return _succeedL;
}
-(UIButton *)detailsBtn{
    if(!_detailsBtn){
        _detailsBtn = [UIButton buttonWithbtnTitle:@"查看订单详情" textColor:KColorFindingPeopleBlue textFont:kFontSize32 backGroundColor:kColorWhite];
        _detailsBtn.layer.cornerRadius = WidthByiPhone6(3);
        _detailsBtn.layer.borderColor = KColorFindingPeopleBlue.CGColor;
        _detailsBtn.layer.borderWidth = 1;
        _detailsBtn.layer.masksToBounds = YES;
        [_detailsBtn addTarget:self action:@selector(detailsAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _detailsBtn;
}
-(UIButton *)applyBtn{
    if(!_applyBtn){
        _applyBtn = [UIButton buttonWithbtnTitle:@"申请发票" textColor:kColorWhite textFont:kFontSize32 backGroundColor:KColorFindingPeopleBlue];
        _applyBtn.layer.cornerRadius = WidthByiPhone6(3);
        _applyBtn.layer.borderColor = KColorFindingPeopleBlue.CGColor;
        _applyBtn.layer.borderWidth = 1;
        _applyBtn.layer.masksToBounds = YES;
        [_applyBtn addTarget:self action:@selector(applyAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _applyBtn;
}
@end
