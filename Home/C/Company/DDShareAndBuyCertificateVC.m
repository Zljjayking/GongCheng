//
//  DDShareAndBuyCertificateVC.m
//  GongChengDD
//
//  Created by csq on 2019/2/25.
//  Copyright © 2019 Koncendy. All rights reserved.
//

#import "DDShareAndBuyCertificateVC.h"
#import "DDBuyCreditReportSuccessVC.h"
#import <UShareUI/UShareUI.h>//友盟分享
#import <MessageUI/MessageUI.h>
#import "DDBuyAAACertificateVC.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "DDNoResult2View.h"
@interface DDShareAndBuyCertificateVC ()<UIScrollViewDelegate,MFMessageComposeViewControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) UIScrollView *scroll;
@property (nonatomic, strong) UIView *alert;
@property (nonatomic, strong) UIView *shareAlert;
@property (strong,nonatomic)MFMessageComposeViewController *messageController;
@property (nonatomic, strong) NSString *shareContent;
@property (nonatomic, assign) UMSocialPlatformType platformType;
@property (nonatomic, strong) NSDictionary *userInfo;
@property (nonatomic, strong) UIView *warnAlert;
@property (nonatomic,strong) DataLoadingView *loadingView;
@property (nonatomic,strong) DDNoResult2View *noResultView;//无数据视图
@end

@implementation DDShareAndBuyCertificateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=kColorBackGroundColor;
    self.title = @"邀请好友";
    self.inviteCode = @"DHKZ4S9H";
    self.navigationItem.leftBarButtonItem=[DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
    self.navigationItem.rightBarButtonItem=[DDUtils rightbuttonItemWithTitle:@"规则说明" target:self action:@selector(rightButtonClick)];
    [self requestInviteCount];
//    [self setupDataLoadingView];
}
- (void)setupDataLoadingView{
    _noResultView=[[DDNoResult2View alloc]initWithFrame:CGRectMake(0,0, Screen_Width, Screen_Height-KNavigationBarHeight)];
    [self.scroll addSubview:_noResultView];
    
    __weak __typeof(self) weakSelf = self;
    _loadingView = [[DataLoadingView alloc] initWithController:self];
    _loadingView.loadingTitle = KLoading;
    _loadingView.failureTitle = KLoadingFailure;
    _loadingView.reloadHandle = ^(void){
        [weakSelf requestInviteCount];
    };
    [_loadingView showLoadingView];
}
#pragma mark 查询已经推荐多少人
-(void)requestInviteCount {
    MBProgressHUD * hud = [DDUtils showHUDCustom:@""];
    [[DDHttpManager sharedInstance] sendPostRequest:KHttpRequest_validCnt params:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
//            _noResultView.hidden = YES;
//            [_loadingView hiddenLoadingView];
            self.invitedCount = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"cnt"]];
            self.inviteCode = response.data[@"inviteCode"];
            [self createUI];
            [self createAlert];
        }else{
            [DDUtils showToastWithMessage:response.message];
//            [_loadingView failureLoadingView];
        }
        [hud hide:YES afterDelay:0];
    } failure:^(NSURLSessionDataTask *operation, id responseObject) {
        [DDUtils showToastWithMessage:kRequestFailed];
//        [_loadingView failureLoadingView];
        [hud hide:YES afterDelay:0];
    }];
}

- (void)leftButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createAlert {
    UIView *alert = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
    alert.backgroundColor = RGBA(0, 0, 0, 0.5);
    self.alert = alert;
    
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width-100*Scale, Screen_Width-80)];
    bgView.backgroundColor = kColorWhite;
    bgView.layer.cornerRadius = 7;
    bgView.center = CGPointMake(self.alert.center.x, self.alert.center.y-40) ;
    [alert addSubview:bgView];
    
    UILabel *titlLb = [[UILabel alloc] init];
    titlLb.font = KFontSize38;
    titlLb.textAlignment = NSTextAlignmentCenter;
    titlLb.text = @"规则说明";
    [bgView addSubview:titlLb];
    [titlLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgView.mas_centerX);
        make.top.equalTo(bgView.mas_top).offset(20);
        make.height.mas_equalTo(20);
    }];
    
    UIImageView *closeImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"quxiao"]];
    [bgView addSubview:closeImage];
    [closeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgView.mas_right).offset(-12);
        make.top.equalTo(bgView.mas_top).offset(12);
        make.width.height.mas_equalTo(15);
    }];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [closeBtn setBackgroundImage:[UIImage imageNamed:@"quxiao"] forState:UIControlStateNormal];
    [bgView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgView.mas_right).offset(-7);
        make.top.equalTo(bgView.mas_top).offset(7);
        make.width.height.mas_equalTo(25);
    }];
    [closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *contentLb = [[UILabel alloc] init];
    contentLb.font = kFontSize30;
    contentLb.textColor = KColorGreySubTitle;
    contentLb.numberOfLines = 0;
    NSString *contentStr = @"1.您分享给好友且好友首次下载工程点点后的10日内填写邀请码的，则视为你邀请好友成功\n2.一个手机只能输入一次邀请码，已经输入过邀请码的手机，切换账号也无法输入其他邀请码\n备注：（邀请码为本平台每位用户设立的独立ID号，用于邀请时使用）";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:contentStr];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 4;  //设置行间距
    paragraphStyle.lineBreakMode = contentLb.lineBreakMode;
    paragraphStyle.alignment = contentLb.textAlignment;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [contentStr length])];
    contentLb.attributedText = attributedString;
    [bgView addSubview:contentLb];
    [contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView.mas_left).offset(23);
        make.right.equalTo(bgView.mas_right).offset(-23);
        make.top.equalTo(titlLb.mas_bottom).offset(30);
    }];
    
}
- (void)closeBtnClick {
    [self.alert removeFromSuperview];
    [self.shareAlert removeFromSuperview];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.fd_interactivePopDisabled = NO;
    
}
- (void)rightButtonClick{
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [self.navigationController.view addSubview:self.alert];
    self.fd_interactivePopDisabled = YES;
}
- (void)createUI {
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-KNavigationBarHeight-58-KHomeIndicatorHeight)];
    scroll.backgroundColor = kColorBackGroundColor;
    scroll.bounces = NO;
    scroll.contentSize = CGSizeMake(0, (165+284+185)*Scale+115);
    [self.view addSubview:scroll];
    scroll.delegate = self;
    scroll.scrollEnabled = YES;
    self.scroll = scroll;
    [self setupTopView];
    
    [self setupBottomView];
    
}
#pragma mark 头部视图
- (void)setupTopView{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 165*Scale+50)];
    topView.backgroundColor = kColorWhite;
    [self.scroll addSubview:topView];
    
    UIImageView *bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 165*Scale)];
    bgImage.userInteractionEnabled  =   YES;
    bgImage.image = [UIImage imageNamed:@"banner_bg"];
    [topView addSubview:bgImage];
    
    UILabel *titleLb = [[UILabel alloc] init];
    [bgImage addSubview:titleLb];
    NSString *titleStr = [NSString stringWithFormat:@"邀请%@人并成功注册享 %@元",self.inviteCount,self.price];
    titleLb.textColor = kColorWhite;
    titleLb.font = [UIFont boldSystemFontOfSize:CustomFontSize(16)];
    titleLb.textAlignment = NSTextAlignmentCenter;
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(bgImage).offset(17*Scale);
        make.right.equalTo(bgImage.mas_right).offset(-17*Scale);
    }];
    
    //NSFontAttributeName:[UIFont boldSystemFontOfSize:12]
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:titleStr];
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:CustomFontSize(30)] range:NSMakeRange(10+self.inviteCount.length, self.price.length)];
    titleLb.attributedText = attributedStr;
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bgImage addSubview:shareBtn];
    shareBtn.layer.masksToBounds = YES;
    shareBtn.layer.cornerRadius = 37*Scale/2.0;
//    [shareBtn setBackgroundImage:[DDUtils imageWithColor:kColorWhite] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [shareBtn setBackgroundColor:kColorWhite];
    [shareBtn setTitle:@"立即邀请" forState:UIControlStateNormal];
    [shareBtn setTitleColor:UIColorFromRGB(0x3196fc) forState:UIControlStateNormal];
    shareBtn.enabled = YES;
    shareBtn.titleLabel.font = kFontSize32;
    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgImage);
        make.top.equalTo(titleLb.mas_bottom).offset(25*Scale);
        make.width.mas_equalTo(153*Scale);
        make.height.mas_equalTo(37*Scale);
    }];
    
    UILabel *inviteCodeLb = [[UILabel alloc] init];
    inviteCodeLb.text = [NSString stringWithFormat:@"我的邀请码：%@",self.inviteCode];
    inviteCodeLb.textColor = kColorWhite;
    inviteCodeLb.font = kFontSize26;
    [bgImage addSubview:inviteCodeLb];
    [inviteCodeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(shareBtn.mas_bottom).offset(24*Scale);
        make.centerX.equalTo(bgImage.mas_centerX).offset(-20);
    }];
    
    UIButton *copyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [copyBtn setBackgroundImage:[DDUtils imageWithColor:UIColorFromRGB(0x4B90E1)] forState:UIControlStateNormal];
    copyBtn.layer.masksToBounds = YES;
    copyBtn.layer.cornerRadius = 2;
    copyBtn.layer.borderColor = kColorWhite.CGColor;
    copyBtn.layer.borderWidth = 0.5;
    [copyBtn setTitle:@"复制" forState:UIControlStateNormal];
    copyBtn.titleLabel.font = KFontSize22;
    [bgImage addSubview:copyBtn];
    [copyBtn addTarget:self action:@selector(copyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [copyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(inviteCodeLb.mas_right).offset(5);
        make.centerY.equalTo(inviteCodeLb.mas_centerY);
        make.width.mas_equalTo(36);
        make.height.mas_equalTo(17);
    }];
    
    UILabel *invitedCountLb = [[UILabel alloc] init];
    invitedCountLb.font = kFontSize30;
    NSString *invitedCountStr = [NSString stringWithFormat:@"已经成功邀请%@位",self.invitedCount];
    NSMutableAttributedString *invitedAttributedStr = [[NSMutableAttributedString alloc] initWithString:invitedCountStr];
    [invitedAttributedStr addAttribute:NSFontAttributeName value:kFontSize48 range:NSMakeRange(6, self.invitedCount.length)];
    [invitedAttributedStr addAttribute:NSForegroundColorAttributeName value:KColorTextOrange range:NSMakeRange(6, self.invitedCount.length)];
    invitedCountLb.attributedText = invitedAttributedStr;
    [topView addSubview:invitedCountLb];
    [invitedCountLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topView.mas_centerX);
        make.top.equalTo(bgImage.mas_bottom).offset(10);
    }];
    
    UIImageView *howInviteImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"howShare"]];
    [self.scroll addSubview:howInviteImage];
    [howInviteImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom).offset(12);
        make.width.mas_equalTo(Screen_Width);
        make.height.mas_equalTo(284*Scale);
    }];
    
    UIImageView *howUseImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"howShare2"]];
    [self.scroll addSubview:howUseImage];
    [howUseImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(howInviteImage.mas_bottom).offset(12);
        make.width.mas_equalTo(Screen_Width);
        make.height.mas_equalTo(185*Scale);
    }];
}
- (void)copyBtnClick {
    if (![DDUtils isEmptyString:self.inviteCode]) {
        UIPasteboard *paste = [UIPasteboard generalPasteboard];
        [paste setString:self.inviteCode];
        MBProgressHUD * hud = [DDUtils showHUDCustom:@""];
        hud.mode = MBProgressHUDModeCustomView;
        hud.customView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"myinfo_saveSuccess"]];
        //            hud.labelText=@"监控成功";
        hud.detailsLabelText = @"已复制到粘贴板";
        [hud hide:YES afterDelay:KHudShowTimeSecound];
    }
}
#pragma mark 支付按钮view
- (void)setupBottomView {
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.scroll.frame), Screen_Width, 58)];
    [self.view addSubview:bottomView];
    bottomView.backgroundColor = kColorWhite;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 0.6)];
    line.backgroundColor = UIColorFromRGB(0xEAEAEA);
    [bottomView addSubview:line];
    
    UIButton *payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [payBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    [payBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
    [payBtn setBackgroundColor:RGB(56, 152, 249)];
    payBtn.layer.masksToBounds = YES;
    payBtn.layer.cornerRadius = 5;
    payBtn.alpha = 0.5;
    payBtn.enabled = NO;
    if ([self.invitedCount integerValue] >= [self.inviteCount integerValue]) {
        payBtn.alpha = 1;
        payBtn.enabled = YES;
    }
    [payBtn addTarget:self action:@selector(buyClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:payBtn];
    [payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView).offset(12);
        make.right.equalTo(bottomView).offset(-12);
        make.top.equalTo(bottomView).offset(10);
        make.bottom.equalTo(bottomView).offset(-10);
    }];
}
- (void)buyClick {
    if (!self.isCanBuy) {
        [self setupWarnAlertView];
    }else {
        if (self.isClaimed) {
            DDBuyAAACertificateVC *buyCertificate = [[DDBuyAAACertificateVC alloc]init];
            if (self.type == 2 || self.type == 3) {
                buyCertificate.type = self.type;
            }
            buyCertificate.email          = self.email;
            buyCertificate.enterpriseName = self.enterpriseName;
            buyCertificate.enterpriseId   = self.enterpriseId;
            buyCertificate.price = self.price;
            buyCertificate.invitedCount = self.inviteCount;
            buyCertificate.refreshChoose = ^{
                if (self.refreshChooseTwo) {
                    self.refreshChooseTwo();
                }
                [self requestIsCanOrder];
                for (UIView *view in [self.view subviews]) {
                    [view removeFromSuperview];
                }
                [self requestInviteCount];
            };
            [self.navigationController pushViewController:buyCertificate animated:YES];
        }else {
            [DDUtils showToastWithMessage:@"认领此公司，才可购买信用等级证书"];
        }
        
    }
}
- (void)shareBtnClick {
    
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine ),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Sms)]];
    //配置上面需求的参数
    [UMSocialShareUIConfig shareInstance].shareTitleViewConfig.isShow = NO;
    [UMSocialShareUIConfig shareInstance].shareCancelControlConfig.shareCancelControlText = @"取消";
    //显示分享面板
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        
        NSString *content = [NSString stringWithFormat:@"1.下载【工程点点】\n2.我的-输入邀请码【%@】\n3.复制此消息可自动 填写邀请码",self.inviteCode];
        [self createShareUIWithContent:content andPlatForm:platformType andUserInfo:userInfo];
    }];
}

- (void)createShareUIWithContent:(NSString *)content andPlatForm:(UMSocialPlatformType)platformType andUserInfo:(NSDictionary *)userInfo {
    self.shareContent = content;
    self.platformType = platformType;
    self.userInfo = userInfo;
    UIView *alert = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
    alert.backgroundColor = RGBA(0, 0, 0, 0.5);
    self.shareAlert = alert;
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width-100*Scale, Screen_Width-80)];
    bgView.backgroundColor = kColorWhite;
    bgView.layer.cornerRadius = 7;
    bgView.center = CGPointMake(self.alert.center.x, self.alert.center.y-40) ;
    [alert addSubview:bgView];
    
    UILabel *titlLb = [[UILabel alloc] init];
    titlLb.font = KFontSize38;
    titlLb.textAlignment = NSTextAlignmentCenter;
    titlLb.text = @"您的口令已生成";
    [bgView addSubview:titlLb];
    [titlLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgView.mas_centerX);
        make.top.equalTo(bgView.mas_top).offset(25);
        make.height.mas_equalTo(20);
    }];
    
    UILabel *titlLb1 = [[UILabel alloc] init];
    titlLb1.font = kFontSize28;
    titlLb1.textAlignment = NSTextAlignmentCenter;
    titlLb1.text = @"已帮你自动复制，选择好友粘贴给他";
    titlLb1.textColor = KColorGreySubTitle;
    [bgView addSubview:titlLb1];
    [titlLb1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgView.mas_centerX);
        make.top.equalTo(titlLb.mas_bottom).offset(15);
        make.height.mas_equalTo(15);
    }];
    
    UIImageView *closeImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"quxiao"]];
    [bgView addSubview:closeImage];
    [closeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgView.mas_right).offset(-12);
        make.top.equalTo(bgView.mas_top).offset(12);
        make.width.height.mas_equalTo(15);
    }];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [closeBtn setBackgroundImage:[UIImage imageNamed:@"quxiao"] forState:UIControlStateNormal];
    [bgView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgView.mas_right).offset(-7);
        make.top.equalTo(bgView.mas_top).offset(7);
        make.width.height.mas_equalTo(25);
    }];
    [closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *contentV = [[UIView alloc] init];
    contentV.layer.borderColor = UIColorFromRGB(0xE5E6F0).CGColor;
    contentV.layer.borderWidth = 0.7;
    contentV.layer.cornerRadius = 10;
    [bgView addSubview:contentV];
    [contentV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView.mas_left).offset(15);
        make.right.equalTo(bgView.mas_right).offset(-15);
        make.top.equalTo(titlLb1.mas_bottom).offset(20);
        make.height.mas_equalTo(150);
    }];
    
    
    UILabel *contentLb = [[UILabel alloc] init];
    contentLb.font = kFontSize30;
    contentLb.textColor = KColorGreySubTitle;
    contentLb.numberOfLines = 0;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 7;  //设置行间距
    paragraphStyle.lineBreakMode = contentLb.lineBreakMode;
    paragraphStyle.alignment = contentLb.textAlignment;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [content length])];
    contentLb.attributedText = attributedString;
    [contentV addSubview:contentLb];
    [contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentV.mas_left).offset(15);
        make.right.equalTo(contentV.mas_right).offset(-15);
        make.centerY.equalTo(contentV.mas_centerY).offset(0);
    }];
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setTitle:@"去粘贴" forState:UIControlStateNormal];
    [shareBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
    //    [payBtn setBackgroundImage:[DDUtils imageWithColor:RGB(56, 152, 249)] forState:UIControlStateNormal];
    [shareBtn setBackgroundColor:RGB(56, 152, 249)];
    shareBtn.layer.masksToBounds = YES;
    shareBtn.layer.cornerRadius = 5;
    shareBtn.enabled = YES;
    [shareBtn addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:shareBtn];
    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(12);
        make.right.equalTo(bgView).offset(-12);
        make.bottom.equalTo(bgView).offset(-20);
        make.height.mas_equalTo(40);
    }];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [self.navigationController.view addSubview:self.shareAlert];
}
- (void)shareClick {
    [self.shareAlert removeFromSuperview];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [self shareWithContent:self.shareContent andPlatForm:self.platformType andUserInfo:self.userInfo];
}
- (void)shareWithContent:(NSString *)content andPlatForm:(UMSocialPlatformType)platformType andUserInfo:(NSDictionary *)userInfo{
    // 根据获取的platformType确定所选平台进行下一步操作
    if (platformType == UMSocialPlatformType_Sms) {
        _messageController= [[MFMessageComposeViewController alloc] init];
        UINavigationItem * navigationItem = [[[_messageController viewControllers] lastObject] navigationItem];
        [navigationItem setTitle:@"新信息"];
        UIButton * cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [cancelButton addTarget:self action:@selector(cancelSendSMSClick) forControlEvents:UIControlEventTouchUpInside];
        navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:cancelButton];
        
        
        // 设置短信内容
        _messageController.body = content;
        
        // 设置收件人列表
        //            _messageController.recipients = @[@"13812345678"];
        // 设置代理
        _messageController.messageComposeDelegate = self;
        // 显示控制器
        [self presentViewController:_messageController animated:YES completion:nil];
    }else{
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        //设置文本
        messageObject.text = content;
        
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
            if (error) {
                UMSocialLogInfo(@"************分享返回的结果：%@*********",error);
            }
            else{
                if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                    UMSocialShareResponse *resp = data;
                    //分享结果消息
                    UMSocialLogInfo(@"response message is %@",resp.message);
                    //第三方原始返回的数据
                    UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                    
                }else{
                    UMSocialLogInfo(@"response data is %@",data);
                }
            }
        }];
    }
}
#pragma mark MFMessageComposeViewControllerDelegate代理方法
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    // 关闭短信界面
    [controller dismissViewControllerAnimated:YES completion:nil];
    if(result == MessageComposeResultCancelled) {
        NSLog(@"取消发送");
    } else if(result == MessageComposeResultSent) {
        NSLog(@"发送成功");
    } else {
        NSLog(@"发送失败");
    }
}
- (void)cancelSendSMSClick{
    [_messageController dismissViewControllerAnimated:YES completion:nil];
}

- (void)setupWarnAlertView {
    //禁用滑动返回
    
    self.fd_interactivePopDisabled = YES;
    
    UIView *alert = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
    alert.backgroundColor = RGBA(0, 0, 0, 0.5);
    self.warnAlert = alert;
    [self.navigationController.view addSubview:self.warnAlert];
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
    [self.warnAlert removeFromSuperview];
    self.fd_interactivePopDisabled = NO;
}


#pragma mark 查询是否可以购买(否表示此企业已经购买)
- (void)requestIsCanBuy {
    MBProgressHUD * hud = [DDUtils showHUDCustom:@""];
    [[DDHttpManager sharedInstance] sendPostRequest:KHttpRequest_canBuy params:@{@"entId":_enterpriseId} success:^(NSURLSessionDataTask *operation, id responseObject) {
        DDHttpResponse *response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            BOOL isCanBuy = [responseObject[@"data"] boolValue];
            if (isCanBuy) {
                [self requestIsCanOrder];//查询是否可以下单
            }else {
                self.isCanBuy = NO;
            }
        }else {
            
            [DDUtils showToastWithMessage:response.message];
        }
        [hud hide:YES afterDelay:0];
    } failure:^(NSURLSessionDataTask *operation, id responseObject) {
        [DDUtils showToastWithMessage:kRequestFailed];
        [hud hide:YES afterDelay:0];
    }];
}
#pragma mark 查询是否可以下单(否表示已存在一个未支付订单)
- (void)requestIsCanOrder {
    
    [[DDHttpManager sharedInstance] sendPostRequest:KHttpRequset_canOrder params:@{@"entId":_enterpriseId} success:^(NSURLSessionDataTask *operation, id responseObject) {
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            BOOL isCanBuy = [responseObject[@"data"] boolValue];
            if (!isCanBuy) {
                self.isCanBuy = NO;
            }else {
                self.isCanBuy = YES;
            }
        }else {
            [DDUtils showToastWithMessage:response.message];
        }
    } failure:^(NSURLSessionDataTask *operation, id responseObject) {
        [DDUtils showToastWithMessage:kRequestFailed];
    }];
}
@end
