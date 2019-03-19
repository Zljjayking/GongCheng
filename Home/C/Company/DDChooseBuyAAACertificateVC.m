//
//  DDChooseBuyAAACertificateVC.m
//  GongChengDD
//
//  Created by csq on 2019/2/25.
//  Copyright © 2019 Koncendy. All rights reserved.
//

#import "DDChooseBuyAAACertificateVC.h"
#import "DDBuyAAACertificateVC.h"
#import "DDShareAndBuyCertificateVC.h"
#import "DDAAACertificateDemoVC.h"
#import "UIView+WhenTappedBlocks.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "DDNoResult2View.h"
@interface DDChooseBuyAAACertificateVC ()
@property (nonatomic, strong) UIView *btnView;
@property (nonatomic, strong) UILabel *buiedLb;//企业已经购买
@property (nonatomic, assign) BOOL isCanBuy;//是否能购买（默认是YES NO表示已经存在一个未支付订单）
@property (nonatomic, assign) BOOL isClaimed;
@property (nonatomic, strong) UIView *Alert;
@property (nonatomic,strong)DDNoResult2View *noResultView;//无数据视图
@property (nonatomic,strong)DataLoadingView * loadingView;
@end

@implementation DDChooseBuyAAACertificateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=kColorBackGroundColor;
    self.title=@"信用等级证书";
    self.navigationItem.leftBarButtonItem=[DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
    self.isCanBuy = YES;
    self.isClaimed = NO;
    [self createUI];
    [self setupDataLoadingView];
    [self requestIsCanBuy];//查询是否可以购买
    
}
- (void)setupDataLoadingView{
    _noResultView=[[DDNoResult2View alloc]initWithFrame:CGRectMake(0,0, Screen_Width, Screen_Height-KNavigationBarHeight)];
    [self.view addSubview:_noResultView];
    
    __weak __typeof(self) weakSelf = self;
    _loadingView = [[DataLoadingView alloc] initWithController:self];
    _loadingView.loadingTitle = KLoading;
    _loadingView.failureTitle = KLoadingFailure;
    _loadingView.reloadHandle = ^(void){
        [weakSelf requestIsCanBuy];
    };
    [_loadingView showLoadingView];
}
#pragma mark 返回上一级
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark 查询是否可以购买(否表示此企业已经购买)
- (void)requestIsCanBuy {
    MBProgressHUD * hud = [DDUtils showHUDCustom:@""];
    [[DDHttpManager sharedInstance] sendPostRequest:KHttpRequest_canBuy params:@{@"entId":_enterpriseId} success:^(NSURLSessionDataTask *operation, id responseObject) {
        DDHttpResponse *response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            [_loadingView hiddenLoadingView];
            _noResultView.hidden = YES;
             BOOL isCanBuy = [responseObject[@"data"] boolValue];
            if (isCanBuy) {
                self.buiedLb.hidden = YES;
                [self requestIsCanOrder];//查询是否可以下单
            }else {
                self.buiedLb.hidden = NO;
                for (int i=0; i<3; i++) {
                    UIButton *btn=(UIButton *)[self.btnView viewWithTag:i+1];
                    btn.layer.borderColor = UIColorFromRGB(0xE5E6F0).CGColor;
                    [btn setBackgroundColor:RGB(240, 240, 240)];
                    btn.enabled = NO;
                    
                    UILabel *titleLb = (UILabel *)[self.btnView viewWithTag:i+4];
                    titleLb.textColor = KColorGreySubTitle;
                    
                    UILabel *priceLb = (UILabel *)[self.btnView viewWithTag:i+7];
                    priceLb.textColor = RGB(145, 205, 246);
                }
                
            }
        }else {
            self.buiedLb.hidden = YES;
            [_loadingView failureLoadingView];
            for (int i=0; i<3; i++) {
                UIButton *btn=(UIButton *)[self.btnView viewWithTag:i+1];
                btn.layer.borderColor = UIColorFromRGB(0xE5E6F0).CGColor;
                [btn setBackgroundColor:RGB(240, 240, 240)];
                btn.enabled = NO;
                
                UILabel *titleLb = (UILabel *)[self.btnView viewWithTag:i+4];
                titleLb.textColor = KColorGreySubTitle;
                
                UILabel *priceLb = (UILabel *)[self.btnView viewWithTag:i+7];
                priceLb.textColor = RGB(145, 205, 246);
            }
            [DDUtils showToastWithMessage:response.message];
        }
        [hud hide:YES afterDelay:0];
    } failure:^(NSURLSessionDataTask *operation, id responseObject) {
        self.buiedLb.hidden = YES;
        [DDUtils showToastWithMessage:kRequestFailed];
        [hud hide:YES afterDelay:0];
        [_loadingView failureLoadingView];
    }];
}
#pragma mark 查询是否可以下单(否表示已存在一个未支付订单)
- (void)requestIsCanOrder {
    
    [[DDHttpManager sharedInstance] sendPostRequest:KHttpRequset_canOrder params:@{@"entId":_enterpriseId} success:^(NSURLSessionDataTask *operation, id responseObject) {
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        
        if (response.isSuccess) {
            [_loadingView hiddenLoadingView];
            _noResultView.hidden = YES;
            BOOL isCanBuy = [responseObject[@"data"] boolValue];
            if (!isCanBuy) {
                self.isCanBuy = NO;

            }
        }else {
            [_loadingView failureLoadingView];
            for (int i=0; i<3; i++) {
                UIButton *btn=(UIButton *)[self.btnView viewWithTag:i+1];
                btn.layer.borderColor = UIColorFromRGB(0xE5E6F0).CGColor;
                [btn setBackgroundColor:RGB(240, 240, 240)];
                btn.enabled = NO;
                
                UILabel *titleLb = (UILabel *)[self.btnView viewWithTag:i+4];
                titleLb.textColor = KColorGreySubTitle;
                
                UILabel *priceLb = (UILabel *)[self.btnView viewWithTag:i+7];
                priceLb.textColor = RGB(145, 205, 246);
            }
            [DDUtils showToastWithMessage:response.message];
        }
//        [hud hide:YES afterDelay:KHudShowTimeSecound];
    } failure:^(NSURLSessionDataTask *operation, id responseObject) {
        [DDUtils showToastWithMessage:kRequestFailed];
//        [hud hide:YES afterDelay:KHudShowTimeSecound];
        [_loadingView failureLoadingView];
    }];
}

#pragma mark 画布局
-(void)createUI{
    
    UILabel *signLb = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, Screen_Width-24, 36)];
    [self.view addSubview:signLb];
    signLb.font = kFontSize26;
    signLb.textColor = KColorGreySubTitle;
    NSString *signStr = @"购买证书后可在“我的订单”中开具发票";
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:signStr];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:KColorOrangeSubTitle range:NSMakeRange(8, 4)];
    signLb.attributedText = attributedStr;
    
    
    UIView *bgView1=[[UIView alloc]initWithFrame:CGRectMake(0, 36, Screen_Width, 135)];
    bgView1.backgroundColor=kColorWhite;
    [self.view addSubview:bgView1];
    
    UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(12, 0, 120, 46)];
    lab.text=@"证书清单";
    lab.textColor=KColorBlackTitle;
    lab.font=kFontSize34;
    [bgView1 addSubview:lab];
    
    UIButton *checkSampleBtn=[[UIButton alloc]initWithFrame:CGRectMake(Screen_Width-14-63, 12.5, 63, 21)];
    [checkSampleBtn setTitle:@"查看示例" forState:UIControlStateNormal];
    [checkSampleBtn setTitleColor:KColorFindingPeopleBlue forState:UIControlStateNormal];
    [checkSampleBtn setBackgroundColor:kColorWhite];
    checkSampleBtn.titleLabel.font=kFontSize24;
    checkSampleBtn.layer.borderColor=KColorFindingPeopleBlue.CGColor;
    checkSampleBtn.layer.borderWidth=0.5;
    checkSampleBtn.layer.cornerRadius=3;
    [checkSampleBtn addTarget:self action:@selector(checkSampleClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView1 addSubview:checkSampleBtn];
    
    UILabel *listLb = [[UILabel alloc] init];
    listLb.numberOfLines = 0;
    listLb.textColor = KColorGreySubTitle;
    listLb.font = kFontSize30;
    [bgView1 addSubview:listLb];
    [listLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView1.mas_left).offset(12);
        make.right.equalTo(bgView1.mas_right).offset(12);
        make.top.equalTo(lab.mas_bottom).offset(3);
    }];
    NSString *listStr = @"1.AAA信用等级证书正、副本一套\n2.AAA信用证书铜牌一套\n3.信用报告一份";
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 7;  //设置行间距
    paragraphStyle.lineBreakMode = listLb.lineBreakMode;
    paragraphStyle.alignment = listLb.textAlignment;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:listStr];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [listStr length])];
    listLb.attributedText = attributedString;
    
    
    UILabel *buiedLb = [[UILabel alloc] init];
    buiedLb.text = @"此企业已购买";
    buiedLb.font = kFontSize28;
    buiedLb.textAlignment = NSTextAlignmentCenter;
    buiedLb.layer.masksToBounds = YES;
    buiedLb.layer.cornerRadius = 2;
    buiedLb.backgroundColor = UIColorFromRGB(0xFDF5E9);
    buiedLb.textColor = UIColorFromRGB(0xFF9801);
    [bgView1 addSubview:buiedLb];
    self.buiedLb = buiedLb;
    [buiedLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgView1.mas_right).offset(-12);
        make.bottom.equalTo(bgView1.mas_bottom).offset(-10);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(25);
    }];
    
    UIView *btnView = [[UIView alloc] init];
    btnView.backgroundColor = kColorWhite;
    [self.view addSubview:btnView];
    [btnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(bgView1.mas_bottom).offset(13);
        make.height.mas_equalTo(90*Scale+32);
    }];
    self.btnView = btnView;
    NSArray *btnContentArr = @[@{@"title":@"直接购买",@"price":@"¥3990"},
                               @{@"title":@"分享5人并成功注册",@"price":@"¥1299"},
                               @{@"title":@"分享10人并成功注册",@"price":@"¥699"}];
    
    for ( int i = 0; i < btnContentArr.count; i++) {
        NSDictionary *contentDic = btnContentArr[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnView addSubview:btn];
        [btn setBackgroundColor:RGB(250, 253, 255)];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 5;
        btn.layer.borderColor = KColorFindingPeopleBlue.CGColor;
        btn.layer.borderWidth = 0.7;
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(btnView.mas_left).offset(10+i*((Screen_Width-40)/3.0+10));
            make.top.equalTo(btnView.mas_top).offset(16);
            make.height.mas_equalTo(90*Scale);
            make.width.mas_equalTo((Screen_Width-40)/3.0);
        }];
        btn.tag = i+1;
        [btn addTarget:self action:@selector(buyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *titleLb = [[UILabel alloc] init];
        [btn addSubview:titleLb];
        titleLb.tag = 4+i;
        titleLb.font = kFontSize26;
        titleLb.textColor = KColorSearchPlaceholder;
        titleLb.numberOfLines = 0;
        titleLb.text = contentDic[@"title"];
        [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(btn).offset(10);
            make.top.equalTo(btn).offset(14);
            make.right.equalTo(btn.mas_right).offset(-10);
        }];
        
        UILabel *priceLb = [[UILabel alloc] init];
        [btn addSubview:priceLb];
        priceLb.tag = 7+i;
        priceLb.textAlignment = NSTextAlignmentCenter;
        priceLb.font = [UIFont boldSystemFontOfSize:CustomFontSize(22)];
        priceLb.textColor = KColorFindingPeopleBlue;
        priceLb.text = contentDic[@"price"];
        [priceLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(btn.mas_left).offset(10);
            make.right.equalTo(btn.mas_right).offset(-10);
            make.bottom.equalTo(btn.mas_bottom).offset(-15);
        }];
    }
    
    
    UILabel *bottomLb = [[UILabel alloc] init];
    [self.view addSubview:bottomLb];
    bottomLb.textAlignment = NSTextAlignmentCenter;
    bottomLb.textColor = UIColorFromRGB(0xbbbbbb);
    bottomLb.font = kFontSize24;
    bottomLb.numberOfLines = 2;
    NSString *bottomStrOne = @"信用等级证书由江苏点点信用评估有限公司统一颁发\n备案编号：JS010904004 ";
    NSString *bottomStrTwo = @"查看备案证书";
    
    NSMutableParagraphStyle *bottomParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    bottomParagraphStyle.lineSpacing = 5;  //设置行间距
    bottomParagraphStyle.lineBreakMode = bottomLb.lineBreakMode;
    bottomParagraphStyle.alignment = bottomLb.textAlignment;
    
    NSString *bottomStrAll = [bottomStrOne stringByAppendingString:bottomStrTwo];
    NSMutableAttributedString *bottomStr = [[NSMutableAttributedString alloc] initWithString:bottomStrAll];
    [bottomStr addAttribute:NSForegroundColorAttributeName value:kColorBlue range:NSMakeRange(bottomStrOne.length, 6)];
    [bottomStr addAttribute:NSParagraphStyleAttributeName value:bottomParagraphStyle range:NSMakeRange(0, [bottomStrAll length])];
    
    bottomLb.attributedText = bottomStr;
    [bottomLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-11);
    }];
    [bottomLb whenTapped:^{
        DDAAACertificateDemoVC *reportVC = [DDAAACertificateDemoVC new];
        reportVC.type = 2;
        [self.navigationController pushViewController:reportVC animated:YES];
    }];
    
}

- (void)checkSampleClick {
    DDAAACertificateDemoVC *reportVC = [DDAAACertificateDemoVC new];
    [self.navigationController pushViewController:reportVC animated:YES];
}

- (void)buyBtnClick:(UIButton *)sender {
    
    if (!self.isCanBuy) {
        if (sender.tag == 1) {
            [self setupAlertView];
        }else {
            [self requestIsClaimed:sender.tag];
        }
    }else {
        [self requestIsClaimed:sender.tag];
    }
}
//
- (void)requestIsClaimed:(NSInteger)tag{
    
    [[DDHttpManager sharedInstance] sendPostRequest:KHttpRequest_claimed params:@{@"entId":_enterpriseId} success:^(NSURLSessionDataTask *operation, id responseObject) {
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if(response.isSuccess){
            BOOL isClaimed = [responseObject[@"data"] boolValue];
            switch (tag) {
                case 1:
                {
                    if (!isClaimed) {
                        [DDUtils showToastWithMessage:@"认领此公司，才可购买信用等级证书"];
                    }else {
                        DDBuyAAACertificateVC *buyCertificate = [[DDBuyAAACertificateVC alloc]init];
                        //从信用报告 或 从服务
                        if (self.type == 2 || self.type == 3) {
                            buyCertificate.type = self.type;
                        }
                        buyCertificate.email          =self.email;
                        buyCertificate.enterpriseName = self.enterpriseName;
                        buyCertificate.enterpriseId   = self.enterpriseId;
                        buyCertificate.price = @"3990";
                        buyCertificate.invitedCount = @"0";
                        buyCertificate.refreshChoose = ^{
                            [self requestIsCanBuy];
                        };
                        [self.navigationController pushViewController:buyCertificate animated:YES];
                    }
                    
                }
                    break;
                case 2:
                {
                    DDShareAndBuyCertificateVC *shareAndBuy = [DDShareAndBuyCertificateVC new];
                    //从信用报告 或 从服务
                    if (self.type == 2 || self.type == 3) {
                        shareAndBuy.type = self.type;
                    }
                    shareAndBuy.refreshChooseTwo = ^{
                        [self requestIsCanBuy];
                    };
                    shareAndBuy.isClaimed = isClaimed;
                    shareAndBuy.isCanBuy = self.isCanBuy;
                    shareAndBuy.price = @"1299";
                    shareAndBuy.inviteCount = @"5";
                    shareAndBuy.invitedCount = @"0";
                    shareAndBuy.email          = self.email;
                    shareAndBuy.enterpriseName = self.enterpriseName;
                    shareAndBuy.enterpriseId   = self.enterpriseId;
                    [self.navigationController pushViewController:shareAndBuy animated:YES];
                }
                    break;
                default:
                {
                    DDShareAndBuyCertificateVC *shareAndBuy = [DDShareAndBuyCertificateVC new];
                    //从信用报告 或 从服务
                    if (self.type == 2 || self.type == 3) {
                        shareAndBuy.type = self.type;
                    }
                    shareAndBuy.refreshChooseTwo = ^{
                        [self requestIsCanBuy];
                    };
                    shareAndBuy.isClaimed = isClaimed;
                    shareAndBuy.isCanBuy = self.isCanBuy;
                    shareAndBuy.price = @"699";
                    shareAndBuy.inviteCount = @"10";
                    shareAndBuy.invitedCount = @"0";
                    shareAndBuy.email          = self.email;
                    shareAndBuy.enterpriseName = self.enterpriseName;
                    shareAndBuy.enterpriseId   = self.enterpriseId;
                    [self.navigationController pushViewController:shareAndBuy animated:YES];
                }
                    break;
            }
        }else{
            [DDUtils showToastWithMessage:response.message];
        }
    } failure:^(NSURLSessionDataTask *operation, id responseObject) {
        [DDUtils showToastWithMessage:kRequestFailed];
    }];
}
- (void)setupAlertView {
    self.fd_interactivePopDisabled = YES;
    UIView *alert = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
    alert.backgroundColor = RGBA(0, 0, 0, 0.5);
    self.Alert = alert;
    [self.navigationController.view addSubview:self.Alert];
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width-100*Scale, 190)];
    bgView.backgroundColor = kColorWhite;
    bgView.layer.cornerRadius = 7;
    bgView.center = CGPointMake(self.view.center.x, self.view.center.y-20) ;
    [alert addSubview:bgView];
    
    UILabel *titlLb = [[UILabel alloc] init];
    titlLb.font = KFontSize38;
    titlLb.textAlignment = NSTextAlignmentCenter;
    titlLb.text = @"温馨提示";
    [bgView addSubview:titlLb];
    [titlLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgView.mas_centerX);
        make.top.equalTo(bgView.mas_top).offset(25);
        make.height.mas_equalTo(20);
    }];
    
    UILabel *titlLb1 = [[UILabel alloc] init];
    titlLb1.font = kFontSize28;
    titlLb1.text = @"目前您还有未支付的订单，请您到【我的订单】进行处理！";
    titlLb1.numberOfLines = 0;
    titlLb1.textColor = KColorGreySubTitle;
    [bgView addSubview:titlLb1];
    [titlLb1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgView.mas_centerX);
        make.left.equalTo(bgView).offset(20);
        make.right.equalTo(bgView).offset(-20);
        make.top.equalTo(titlLb.mas_bottom).offset(15);
        make.height.mas_equalTo(50);
    }];
    
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
    [sureBtn setBackgroundColor:kColorBlue];
    sureBtn.layer.masksToBounds = YES;
    sureBtn.layer.cornerRadius = 5;
    sureBtn.enabled = YES;
    [sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgView);
        make.width.mas_equalTo(230*Scale);
        make.bottom.equalTo(bgView).offset(-20);
        make.height.mas_equalTo(40);
    }];
}
- (void)sureBtnClick {
    [self.Alert removeFromSuperview];
    self.fd_interactivePopDisabled = NO;
}
@end
