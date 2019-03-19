//
//  DDCompanyDetailVC.m
//  GongChengDD
//
//  Created by xzx on 2018/5/11.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDCompanyDetailVC.h"
#import "DataLoadingView.h"
#import "MJRefresh.h"
#import "DDCompanyDetailInfoCell.h"//公司详情cell
#import "DDCompanyDetailCreditScoreCell.h"//信用评分cell
#import "DDNineGridCell.h"//九宫格cell
#import "DDCompanyDetailModel1.h"//model1
#import "DDCompanyDetailModel2.h"//model2
#import "DDCompanyMoreContractInfoVC.h"//更过联络信息页面
#import "DDPeopleDetailVC.h"//人员详情页面

#import "DDAddCompanyConcernView.h"
#import "DDCorrectCompanyInfoVC.h"
#import "DDAffirmEnterpriseVC.h"//公司认证页面
#import "DDValidTimeSummaryVC.h"//有效期汇总

#import "DDSafePermissionVC.h"//安许证页面
#import "DDBusinesslicenseVC.h"//营业执照
#import "DDAptitudeCertificateVC.h"//资质证书页面
#import "DDManageListVC.h"//管理体系
#import "DDThreeACerVC.h"//3A证书
#import "DDAbideContractVC.h"//守合同重信用
#import "DDWorkingLawVC.h"//施工功法
#import "DDBrandVC.h"//商标
#import "DDNearCompanyVC.h"//附近同行
#import "DDShareholderInfoVC.h"//股东信息

#import "DDBuilderVC.h"//建造师页面
#import "DDSafeManVC.h"//安全员页面
#import "DDArchitectListVC.h"//1一级结构师 2二级结构师 3化工工程师 4一级建筑师 5二级建筑师
#import "DDCivilEngineerListVC.h"//1土木工程师 2公用设备师 3电气工程师 4监理工程师 5造价工程师
#import "DDFireEngineerListVC.h"//消防工程师

#import "DDWinTheBiddingVC.h"//中标情况页面
#import "DDProjectManagerVC.h"//项目经理页面
#import "DDContractCopyVC.h"//合同备案页面

#import "DDExcutedPeopleVC.h"//失信信息和被执行人页面
#import "DDCourtNoticeVC.h"//法院公告页面
#import "DDJudgePaperVC.h"//裁判文书页面
#import "DDAdminPunishVC.h"//行政处罚页面
#import "DDAccidentSituationVC.h"//事故情况页面
#import "DDEnvironementAndGroundPunishVC.h"//环保处罚，工地处罚页面
#import "DDSevereIllegalAndAbnormalVC.h"//严重违法，经营异常页面
#import "DDTaxIllegalVC.h"//税收违法页面
#import "DDOweTaxNoticeVC.h"//欠税公告页面
#import "DDSimpleCancelVC.h"//简易注销页面

#import "DDCompanyAwardVC.h"//获奖荣誉页面
#import "DDCultureWorkSiteVC.h"//文明工地.绿色工地
#import "DDRewardsListVC.h"//技术创新奖，QC奖页面

#import "DDCompanyCreditScoreListVC.h"//信用评分页面
#import "DDTaxCreditVC.h"//税务信用页面

#import "DDNavigationUtil.h"
#import "DDLoginCheckVC.h"//登录页面

#import "DDAttentionSuccessModel.h"
#import "DDSearchCompanyModel.h"
#import "DDdeleteCompanyView.h"
#import <UShareUI/UShareUI.h>//友盟分享
#import "DDMyEnterpriseVC.h"
#import "DDLabelUtil.h"
#import "DDUMengEventDefines.h"
#import "YBPopupMenu.h"//弹出气泡图
#import "DDInvoiceTitleModel.h"
#import "DDInvoiceTitleListVC.h"
#import "DDSaveInvoiceTitleView.h"
#import <MessageUI/MessageUI.h>
#import "DDCreditReportVC.h"//信用报告页面
#import "DDCompanyClaimBenefitVC.h"//公司认领的好处页面

#import "DDChooseBuyAAACertificateVC.h"
#import "DDBuyAAACertificateVC.h"
@interface DDCompanyDetailVC ()<UITableViewDelegate,UITableViewDataSource,DDNineGridCellDelegate,DDAddCompanyConcernViewDelegate,DDdeleteCompanyViewDelegate,DDSaveInvoiceTitleViewDelegate,YBPopupMenuDelegate,MFMessageComposeViewControllerDelegate>

{
    DDCompanyDetailModel1 *_companyInfoModel;
    NSMutableArray *_dataSource;
}
@property (nonatomic,strong) UITableView *tableView;
@property (strong,nonatomic) DataLoadingView *loadingView;
@property (strong,nonatomic) UIImageView * attentionImageView;//加关注图标
@property (strong,nonatomic) UILabel *attentionLabel;//加关注label
@property (strong,nonatomic) UIImageView  *collectBtnimgView;//收藏图标
@property (strong,nonatomic)  UILabel *collectlabel;//收藏label

@property (nonatomic,strong)DDInvoiceTitleModel * invoiceTitleModel;//发票抬头model
@property (strong,nonatomic)MFMessageComposeViewController *messageController;

@end

@implementation DDCompanyDetailVC

-(void)viewWillDisappear:(BOOL)animated{
    //还原导航底部线条颜色
    [DDNavigationUtil setNavigationBottomLineNomalColor:self.navigationController];
}

-(void)viewWillAppear:(BOOL)animated{
    //导航底部线条设为透明
    [DDNavigationUtil setNavigationBottomLineClearColor:self.navigationController];
    [self requestCompanyData];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataSource=[[NSMutableArray alloc]init];
    [self editNavItem];
    [self createTableView];
    [self createBottomBtns];
    [self setupDataLoadingView];
    [self requestBillDataShow:NO];
    //监听删除企业通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(delectCompanysuccessAction) name:KDelectCompanysuccess object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshAction) name:@"shoucirenlingchenggong" object:nil];
}
-(void)refreshAction{
    [self requestCompanyData];
}
//定制导航条
-(void)editNavItem{
    self.view.backgroundColor=kColorBackGroundColor;
    self.navigationItem.leftBarButtonItem=[DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
}

//返回上一页
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

//分享
-(void)shareClick{
    if ([DDUtils isEmptyString:[DDUserManager sharedInstance].userid]) {//未登录
        DDLoginCheckVC * vc = [[DDLoginCheckVC alloc] init];
        vc.loginSuccessBlock = ^{
    
        };
        
        UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
        [DDNavigationUtil setNavigationAndBottomLineWhiteColor:nav];
        [self showViewController:nav sender:nil];
    }
    else{//已登录
        [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine ),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Sms)]];
        //配置上面需求的参数
        [UMSocialShareUIConfig shareInstance].shareTitleViewConfig.isShow = NO;
        [UMSocialShareUIConfig shareInstance].shareCancelControlConfig.shareCancelControlText = @"取消";
        //显示分享面板
        [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
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
                _messageController.body = [NSString stringWithFormat:@"下载工程点点，洞察企业信用，监控中标 ，查资质、人员及风险情况等http://m.koncendy.com/pages/companyDetail/main?enterpriseId=%@",self.enterpriseId];
                // 设置代理
                _messageController.messageComposeDelegate = self;
                // 显示控制器
                [self presentViewController:_messageController animated:YES completion:nil];
            } else {
                UMShareWebpageObject * shareObject = [UMShareWebpageObject shareObjectWithTitle:_companyInfoModel.info.enterpriseName descr:@"下载工程点点，洞察企业信用，监控中标 ，查资质、人员及风险情况等" thumImage:[UIImage imageNamed:@"share_logo"]];
                //设置网页地址
                shareObject.webpageUrl =[NSString stringWithFormat:@"http://m.koncendy.com/pages/companyDetail/main?enterpriseId=%@",self.enterpriseId];
                
                //创建分享消息对象
                UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
                //分享消息对象设置分享内容对象
                messageObject.shareObject = shareObject;
                
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
- (void)setupDataLoadingView{
    __weak __typeof(self) weakSelf=self;
    _loadingView = [[DataLoadingView alloc] initWithController:self];
    _loadingView.loadingTitle = KLoading;
    _loadingView.failureTitle = KLoadingFailure;
    _loadingView.reloadHandle = ^(void){
        [weakSelf requestCompanyData];
    };
    [_loadingView showLoadingView];
}
#pragma mark 请求发票抬头
-(void)requestBillDataShow:(BOOL)isShow{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:_enterpriseId forKey:@"entId"];
    [[DDHttpManager sharedInstance] sendGetRequest:KHttpRequest_appMyEcBillInfoByEntId params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response) {
            if ([response.data isKindOfClass:[NSDictionary class]]) {
                _invoiceTitleModel = [[DDInvoiceTitleModel alloc]initWithDictionary:response.data error:nil];
                if(isShow){
                    DDSaveInvoiceTitleView * saveInvoiceTitleView = [[DDSaveInvoiceTitleView alloc] init];
                    [saveInvoiceTitleView loadWithInvoiceTitleModel:_invoiceTitleModel];
                    saveInvoiceTitleView.delegate = self;
                    [saveInvoiceTitleView show];
                }
            }
        }else{
            [DDUtils showToastWithMessage:response.message];
        }
    } failure:^(NSURLSessionDataTask *operation, id responseObject) {
        [DDUtils showToastWithMessage:kRequestFailed];
    }];
}
#pragma mark 请求企业信息
-(void)requestCompanyData{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    if ([DDUtils isEmptyString:[DDUserManager sharedInstance].userid]) {
        [params setValue:@"" forKey:@"userId"];
    }
    else{
        [params setValue:[DDUserManager sharedInstance].userid forKey:@"userId"];
    }
    [params setValue:self.enterpriseId forKey:@"enterpriseId"];
    
    [[DDHttpManager sharedInstance]sendPostRequest:KHttpRequest_companyDetail1 params:params success:^(NSURLSessionDataTask *operation, id responseObject){
        NSLog(@"***********企业详情1请求数据***************%@",responseObject);
                
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {//请求成功
            [_loadingView hiddenLoadingView];
            self.navigationItem.rightBarButtonItem=[DDUtils rightbuttonItemWithImage:@"right_share" highlightedImage:@"right_share" target:self action:@selector(shareClick)];
            _companyInfoModel=[[DDCompanyDetailModel1 alloc]initWithDictionary:responseObject[KData] error:nil];
        }
        else{//显示异常
            [DDUtils showToastWithMessage:response.message];
            [_loadingView failureLoadingView];
        }

        [self.tableView.mj_header endRefreshing];
        [_tableView reloadData];
        [self requestCompanyNumberData];
        [self changeAttentionImageAndText];
        [self changeCollectImageViewStates];
        
    } failure:^(NSURLSessionDataTask *operation, id responseObject) {
        [DDUtils showToastWithMessage:kRequestFailed];
        [_loadingView failureLoadingView];
    }];
}

//请求数量信息
-(void)requestCompanyNumberData{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:self.enterpriseId forKey:@"enterpriseId"];

    [[DDHttpManager sharedInstance]sendPostRequest:KHttpRequest_companyDetail2 params:params success:^(NSURLSessionDataTask *operation, id responseObject){
        NSLog(@"***********企业详情2请求数据***************%@",responseObject);

            DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
            if (response.isSuccess) {//请求成功
                [_dataSource removeAllObjects];
                if (responseObject[KData] != [NSNull null]) {
                    NSArray *listArr= responseObject[KData];
                    for (NSDictionary *dic in listArr) {
                        DDCompanyDetailModel2 *model=[[DDCompanyDetailModel2 alloc]initWithDictionary:dic error:nil];
                        [_dataSource addObject:model];
                    }
                }
                
            }
            else{//显示异常
                [DDUtils showToastWithMessage:response.message];
            }
        
            [_tableView reloadData];

    } failure:^(NSURLSessionDataTask *operation, id responseObject) {
        [DDUtils showToastWithMessage:kRequestFailed];
    }];
}


//创建tableView
-(void)createTableView{
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, -0.5, Screen_Width, Screen_Height-KNavigationBarHeight-KTabbarAndHomeIndicatorHeight) style:UITableViewStyleGrouped];
    
    [self.view addSubview:_tableView];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.backgroundColor=kColorBackGroundColor;
    _tableView.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.separatorColor=KColorTableSeparator;
    _tableView.estimatedRowHeight=44;
    _tableView.bounces=NO;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 15)];
    
//    __weak __typeof(self) weakSelf=self;
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [weakSelf requestCompanyData];
//    }];
    
    
    [_tableView registerNib:[UINib nibWithNibName:@"DDCompanyDetailInfoCell" bundle:nil] forCellReuseIdentifier:@"DDCompanyDetailInfoCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"DDCompanyDetailCreditScoreCell" bundle:nil] forCellReuseIdentifier:@"DDCompanyDetailCreditScoreCell"];
}

#pragma mark 创建底部按钮
-(void)createBottomBtns{

    CGFloat distanceToTop = Screen_Height-KNavigationBarHeight-KTabbarAndHomeIndicatorHeight;
    
    CGFloat buttonWidth = (Screen_Width/5);
    
    UIButton *leftBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, distanceToTop,buttonWidth, KTabbarHeight)];
    leftBtn.backgroundColor=kColorWhite;
    UIImageView *imgView1=[[UIImageView alloc]initWithFrame:CGRectMake((buttonWidth-20)/2, 7, 20, 20)];
    imgView1.image=[UIImage imageNamed:@"home_com_back"];
    [leftBtn addSubview:imgView1];
    UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imgView1.frame)+3, buttonWidth, 15)];
    label1.text=@"回首页";
    label1.textColor=UIColorFromRGB(0x616161);
    label1.font=KFontSize22;
    label1.textAlignment=NSTextAlignmentCenter;
    [leftBtn addSubview:label1];
    [leftBtn addTarget:self action:@selector(goBackClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftBtn];

    
    UIButton *middleBtn=[[UIButton alloc]initWithFrame:CGRectMake(buttonWidth, distanceToTop, buttonWidth, KTabbarHeight)];
    middleBtn.backgroundColor=kColorWhite;
    _attentionImageView=[[UIImageView alloc]initWithFrame:CGRectMake((buttonWidth-20)/2, 7, 20, 20)];
    _attentionImageView.image=[UIImage imageNamed:@"home_com_focus"];
    [middleBtn addSubview:_attentionImageView];
    _attentionLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_attentionImageView.frame)+3, buttonWidth, 15)];
    _attentionLabel.text=@"中标监控";
    _attentionLabel.textColor=UIColorFromRGB(0x616161);
    _attentionLabel.font=KFontSize22;
    _attentionLabel.textAlignment=NSTextAlignmentCenter;
    [middleBtn addSubview:_attentionLabel];
    [middleBtn addTarget:self action:@selector(focusClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:middleBtn];

    
    UIButton *rightBtn=[[UIButton alloc]initWithFrame:CGRectMake(buttonWidth*2, distanceToTop, Screen_Width/4, KTabbarHeight)];
    rightBtn.backgroundColor=kColorWhite;
    UIImageView *imgView3=[[UIImageView alloc]initWithFrame:CGRectMake((buttonWidth-20)/2, 7, 20, 20)];
    imgView3.image=[UIImage imageNamed:@"home_com_credit"];
    [rightBtn addSubview:imgView3];
    UILabel *label3=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imgView3.frame)+3, buttonWidth, 15)];
    label3.text=@"信用报告";
    label3.textColor=UIColorFromRGB(0x616161);
    label3.font=KFontSize22;
    label3.textAlignment=NSTextAlignmentCenter;
    [rightBtn addSubview:label3];
    [rightBtn addTarget:self action:@selector(creditReportClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightBtn];
    UIImageView *hot = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"company_hot"]];
    hot.frame = CGRectMake((buttonWidth-20)/2+12, 3, 22, 12);
    [rightBtn addSubview:hot];
    
    UIButton * collectBtn=[[UIButton alloc]initWithFrame:CGRectMake(buttonWidth*3, distanceToTop,buttonWidth, KTabbarHeight)];
    collectBtn.backgroundColor=kColorWhite;
    _collectBtnimgView=[[UIImageView alloc]initWithFrame:CGRectMake((buttonWidth-20)/2, 7, 20, 20)];
    _collectBtnimgView.image=[UIImage imageNamed:@"home_com_collect"];
    [collectBtn addSubview:_collectBtnimgView];
   _collectlabel=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_collectBtnimgView.frame)+3, buttonWidth, 15)];
    _collectlabel.text=@"收藏";
    _collectlabel.textColor=UIColorFromRGB(0x616161);
    _collectlabel.font=KFontSize22;
    _collectlabel.textAlignment=NSTextAlignmentCenter;
    [collectBtn addSubview:_collectlabel];
    [collectBtn addTarget:self action:@selector(collectBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:collectBtn];
    

    UIButton *lastBtn=[[UIButton alloc]initWithFrame:CGRectMake(buttonWidth*4, distanceToTop,buttonWidth, KTabbarHeight)];
    lastBtn.backgroundColor=kColorWhite;
    UIImageView *imgView4=[[UIImageView alloc]initWithFrame:CGRectMake((buttonWidth-20)/2, 7, 20, 20)];
    imgView4.image=[UIImage imageNamed:@"home_com_fix"];
    [lastBtn addSubview:imgView4];
    UILabel *label4=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imgView4.frame)+3, buttonWidth, 15)];
    label4.text=@"纠错";
    label4.textColor=UIColorFromRGB(0x616161);
    label4.font=KFontSize22;
    label4.textAlignment=NSTextAlignmentCenter;
    [lastBtn addSubview:label4];
    [lastBtn addTarget:self action:@selector(mistakeClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:lastBtn];
    
    UILabel *line=[[UILabel alloc]initWithFrame:CGRectMake(0, distanceToTop, Screen_Width, 0.5)];
    line.backgroundColor=KColor10AlphaBlack;
    [self.view addSubview:line];
}

//改变中标监控按钮图片
- (void)changeAttentionImageAndText{
    if ([DDUtils isEmptyString:_companyInfoModel.attention]) {
        _attentionImageView.image=[UIImage imageNamed:@"home_com_focus"];
        _attentionLabel.text = @"中标监控";
    }else{
        _attentionImageView.image=[UIImage imageNamed:@"home_com_focused"];
        _attentionLabel.text = @"取消监控";
    }
}

//改变收藏按钮图片
- (void)changeCollectImageViewStates{
    if ([DDUtils isEmptyString:_companyInfoModel.is_collect]) {
        _collectBtnimgView.image=[UIImage imageNamed:@"home_com_collect"];
        _collectlabel.text = @"收藏";
    }else{
        _collectBtnimgView.image=[UIImage imageNamed:@"home_com_collected"];
        _collectlabel.text = @"已收藏";
    }
}

#pragma mark 去认领
-(void)goVerifyClick{
    if ([DDUtils isEmptyString:[DDUserManager sharedInstance].userid]) {//未登录
        DDLoginCheckVC * vc = [[DDLoginCheckVC alloc] init];
        vc.loginSuccessBlock = ^{
        };
        
        UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
        [DDNavigationUtil setNavigationAndBottomLineWhiteColor:nav];
        [self showViewController:nav sender:nil];
    }
    else{//已登录
        //如果已经认领了,给个提示
        if ([_companyInfoModel.attestation isEqualToString:@"1"]||[_companyInfoModel.attestation isEqualToString:@"2"]) {
            [DDUtils showToastWithMessage:@"您已认领过该公司"];
            return;
        }
//        else if ([_companyInfoModel.attestation isEqualToString:@"0"]){
//            DDCompanyClaimBenefitVC *vc=[[DDCompanyClaimBenefitVC alloc]init];
//            vc.companyClaimBenefitType = CompanyClaimBenefitTypeCompany;
//            vc.isFromMyInfo = NO;
//            vc.companyid = _companyInfoModel.info.enterpriseId;
//            vc.companyName = _companyInfoModel.info.enterpriseName;
//            [self.navigationController pushViewController:vc animated:YES];
//            return;
//        }
        else if ([_companyInfoModel.attestation isEqualToString:@"-1"]){
            [DDUtils showToastWithMessage:@"您最多只能认领5家公司"];
            DDMyEnterpriseVC *vc = [[DDMyEnterpriseVC alloc] init];
            vc.myEnterpriseType = MyEnterpriseTypeDefault;
            vc.isFromMyInfo = NO;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            DDCurrentCompanyModel * currentCompanyModel = [DDUserManager sharedInstance].currentCompanyModel;
            DDScAttestationEntityModel *scAttestationEntityModel = currentCompanyModel.scAttestationEntity;
            
            if (![DDUtils isEmptyString:scAttestationEntityModel.entId]){
                DDAffirmEnterpriseVC * vc = [[DDAffirmEnterpriseVC alloc] init];
                vc.companyid = _companyInfoModel.info.enterpriseId;
                vc.companyName = _companyInfoModel.info.enterpriseName;
                vc.affirmEnterpriseType = AffirmEnterpriseTypeCompany;
                __weak __typeof(self) weakSelf=self;
                vc.affirmEnterpriseSuccessBlock = ^{
                    [weakSelf requestCompanyData];
                };
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                DDCompanyClaimBenefitVC *vc=[[DDCompanyClaimBenefitVC alloc]init];
                vc.companyClaimBenefitType = CompanyClaimBenefitTypeCompany;
                vc.isFromMyInfo = NO;
                vc.companyid = _companyInfoModel.info.enterpriseId;
                vc.companyName = _companyInfoModel.info.enterpriseName;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }
    }
}
#pragma mark 发票抬头按钮点击
-(void)billBtnClick:(UIButton *)sender{
    if (_invoiceTitleModel) {
        DDSaveInvoiceTitleView * saveInvoiceTitleView = [[DDSaveInvoiceTitleView alloc] init];
        [saveInvoiceTitleView loadWithInvoiceTitleModel:_invoiceTitleModel];
        saveInvoiceTitleView.delegate = self;
        [saveInvoiceTitleView show];
    }else{
        [self requestBillDataShow:YES];
    }
}

#pragma mark DDSaveInvoiceTitleViewDelegate代理方法
//点击了"保存至发票"
- (void)saveInvoiceTitleViewClickSure:(DDSaveInvoiceTitleView*)saveInvoiceTitleView{
    [self saveInvoiceTitle];
    [saveInvoiceTitleView hide];
}

#pragma mark 保存发票抬头
- (void)saveInvoiceTitle{
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:_invoiceTitleModel.address forKey:@"address"];
    [params setValue:_invoiceTitleModel.bankAccount forKey:@"bankAccount"];
    [params setValue:_invoiceTitleModel.billId forKey:@"billId"];
    [params setValue:_invoiceTitleModel.depositBank forKey:@"depositBank"];
    [params setValue:_invoiceTitleModel.entName forKey:@"entName"];
    [params setValue:_invoiceTitleModel.regionId forKey:@"regionId"];
    [params setValue:_invoiceTitleModel.taxNum forKey:@"taxNum"];
    [params setValue:_invoiceTitleModel.tel forKey:@"tel"];
    [params setValue:_invoiceTitleModel.entId forKey:@"entId"];
    DDUserManager * userManger = [DDUserManager sharedInstance];
    [params setValue:userManger.userid forKey:@"userId"];
    
    MBProgressHUD * hud = [DDUtils showHUDCustom:@""];
    [[DDHttpManager sharedInstance]sendPostRequest:KHttpRequest_myUauserBillSave params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        [hud hide:YES];
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if(response.isSuccess){
            [DDUtils showToastWithMessage:@"保存成功"];
            DDInvoiceTitleListVC * vc = [[DDInvoiceTitleListVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            
        }else{
            [DDUtils showToastWithMessage:response.message];
        }
    } failure:^(NSURLSessionDataTask *operation, id responseObject) {
        [hud hide:YES];
        [DDUtils showToastWithMessage:kRequestFailed];
    }];
}

#pragma mark 曾用名按钮点击
-(void)usedNameBtnClick:(UIButton *)sender{
    [YBPopupMenu showRelyOnView:sender titles:_companyInfoModel.info.usedNames icons:nil menuWidth:Screen_Width/4*3 delegate:self];
//    //推荐用这种写法
//    [YBPopupMenu showAtPoint:sender.center titles:@[@"修改", @"删除", @"扫一扫",@"付款"] icons:nil menuWidth:Screen_Width/2 otherSettings:^(YBPopupMenu *popupMenu) {
//        popupMenu.dismissOnSelected = NO;
//        popupMenu.isShowShadow = YES;
//        popupMenu.delegate = self;
//        popupMenu.offset = 0;
//        popupMenu.type = YBPopupMenuTypeDefault;
//        popupMenu.rectCorner = UIRectCornerBottomLeft;
//    }];
}

#pragma mark tableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataSource.count+1+1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

//定制cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {//公司信息
        DDCompanyDetailInfoCell *cell=[tableView dequeueReusableCellWithIdentifier:@"DDCompanyDetailInfoCell" forIndexPath:indexPath];
        
        [cell loadDataWithModel:_companyInfoModel];
        [cell.refreshBtn addTarget:self action:@selector(refreshBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.telBtn addTarget:self action:@selector(telBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.moreInfoBtn addTarget:self action:@selector(moreInfoBtnClick) forControlEvents:UIControlEventTouchUpInside];
        if (![DDUtils isEmptyString:_companyInfoModel.info.legalRepresentative]) {
            [cell.peopleBtn addTarget:self action:@selector(peopleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        //去认领点击
        [cell.goCheckBtn addTarget:self action:@selector(goVerifyClick) forControlEvents:UIControlEventTouchUpInside];
        
        //曾用名点击
        [cell.usedNameBtn addTarget:self action:@selector(usedNameBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        //发票抬头点击
        [cell.billBtn addTarget:self action:@selector(billBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if(indexPath.section==1){//信用分
        DDCompanyDetailCreditScoreCell *cell=[tableView dequeueReusableCellWithIdentifier:@"DDCompanyDetailCreditScoreCell" forIndexPath:indexPath];
        //*******************2.1.4**********************
        
        NSString *score = [NSString stringWithFormat:@"综合评分%@分,",_companyInfoModel.info.comprehensiveScore];
        if ([DDUtils isEmptyString:_companyInfoModel.info.comprehensiveScore]) {
            score = @"综合评分-分,";
        }
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:score];
        [attributedStr addAttribute:NSForegroundColorAttributeName value:kColorBlue range:NSMakeRange(4, _companyInfoModel.info.comprehensiveScore.length)];
//        [attributedStr addAttribute:NSForegroundColorAttributeName value:KColorCellTextOrange range:NSMakeRange(4, _companyInfoModel.info.comprehensiveScore.length)];
        cell.lab1.attributedText = attributedStr;
        NSMutableAttributedString *attributedStr2;
        if ([_companyInfoModel.info.comprehensiveScore floatValue] >= 60.0 && [_companyInfoModel.info.comprehensiveScore floatValue] < 80.0) {
            NSString *score2 = [NSString stringWithFormat:@"可直接购买AAA证书"];
            attributedStr2 = [[NSMutableAttributedString alloc] initWithString:score2];
            [attributedStr2 addAttribute:NSForegroundColorAttributeName value:KColorTextOrange range:NSMakeRange(5,3)];
            cell.nextImage.hidden = NO;
        }else if ([_companyInfoModel.info.comprehensiveScore floatValue] >= 80.0){
            NSString *score2 = [NSString stringWithFormat:@"暂时无法购买AAA+证书"];
            attributedStr2 = [[NSMutableAttributedString alloc] initWithString:score2];
            [attributedStr2 addAttribute:NSForegroundColorAttributeName value:KColorTextOrange range:NSMakeRange(6, 4)];
            cell.nextImage.hidden = YES;
        }
        else {
            NSString *score2 = [NSString stringWithFormat:@"无资格购买AAA证书"];
            attributedStr2 = [[NSMutableAttributedString alloc] initWithString:score2];
            [attributedStr2 addAttribute:NSForegroundColorAttributeName value:KColorTextOrange range:NSMakeRange(5, 3)];
            cell.nextImage.hidden = YES;
        }
        cell.lab2.attributedText = attributedStr2;
        cell.lab3.hidden = YES;
        cell.numLab.hidden = YES;
        
        //*******************2.1.4**********************
        
        
        cell.numLab.text=_companyInfoModel.totalScore.num;
        cell.scoreLab.hidden=YES;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (indexPath.section==2) {//企业证书
        DDNineGridCell *cell=(DDNineGridCell *)[tableView dequeueReusableCellWithIdentifier:@"DDNineGridCell"];
        if (!cell) {
            cell=[[DDNineGridCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DDNineGridCell"];
        }
        
        DDCompanyDetailModel2 *model=_dataSource[0];
        cell.delegate=self;
        cell.tag=101;
        
        //NSArray * imgArr = [[NSArray alloc] initWithObjects:@"home_com_Certi",@"home_com_Certi",@"home_com_safeCerti",@"home_com_builder",@"home_com_builder",@"home_com_threePeople", nil];
        NSArray * imgArr = [[NSArray alloc] init];
        [cell loadCellWithImageArray:imgArr andArray:model.sub];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (indexPath.section==3) {//人员证书
        DDNineGridCell *cell=(DDNineGridCell *)[tableView dequeueReusableCellWithIdentifier:@"DDNineGridCell"];
        if (!cell) {
            cell=[[DDNineGridCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DDNineGridCell"];
        }
        
        DDCompanyDetailModel2 *model=_dataSource[1];
        cell.delegate=self;
        cell.tag=102;
        
        NSArray * imgArr = [[NSArray alloc] initWithObjects:@"home_com_dishonesty",@"home_com_excuted", nil];
        [cell loadCellWithImageArray:imgArr andArray:model.sub];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (indexPath.section==4) {
        //中标业绩
        DDNineGridCell *cell=(DDNineGridCell *)[tableView dequeueReusableCellWithIdentifier:@"DDNineGridCell"];
        if (!cell) {
            cell=[[DDNineGridCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DDNineGridCell"];
        }
        
        DDCompanyDetailModel2 *model=_dataSource[2];
        cell.delegate=self;
        cell.tag=103;
        NSArray * imgArr = [[NSArray alloc] initWithObjects:@"home_com_bidding",@"home_com_manager",@"home_com_manager", nil];
        [cell loadCellWithImageArray:imgArr andArray:model.sub];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
       
    }
    else if (indexPath.section == 5){
        //风险信息
        DDNineGridCell *cell=(DDNineGridCell *)[tableView dequeueReusableCellWithIdentifier:@"DDNineGridCell"];
        if (!cell) {
            cell=[[DDNineGridCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DDNineGridCell"];
        }
        
        DDCompanyDetailModel2 *model=_dataSource[3];
        cell.delegate=self;
        cell.tag=104;
        NSArray * imgArr = [[NSArray alloc] initWithObjects:@"home_com_punish",@"home_com_accident", @"home_com_glory",@"home_com_glory",nil];
        [cell loadCellWithImageArray:imgArr andArray:model.sub];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if(indexPath.section == 6){
        //获奖荣誉
        DDNineGridCell *cell=(DDNineGridCell *)[tableView dequeueReusableCellWithIdentifier:@"DDNineGridCell"];
        if (!cell) {
            cell=[[DDNineGridCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DDNineGridCell"];
        }
        
        DDCompanyDetailModel2 *model=_dataSource[4];
        cell.delegate=self;
        cell.tag=105;
        NSArray * imgArr = [[NSArray alloc] initWithObjects:@"home_com_punish",@"home_com_accident", @"home_com_glory",@"home_com_glory",@"home_com_glory",nil];
        [cell loadCellWithImageArray:imgArr andArray:model.sub];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    else{
        //信用情况
        DDNineGridCell *cell=(DDNineGridCell *)[tableView dequeueReusableCellWithIdentifier:@"DDNineGridCell"];
        if (!cell) {
            cell=[[DDNineGridCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DDNineGridCell"];
        }
        
        DDCompanyDetailModel2 *model=_dataSource[5];
        cell.delegate=self;
        cell.tag=106;
        NSArray * imgArr = [[NSArray alloc] initWithObjects:@"home_com_punish",@"home_com_accident", @"home_com_glory",@"home_com_glory",@"home_com_glory",@"home_com_glory",nil];
        [cell loadCellWithImageArray:imgArr andArray:model.sub];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
}

//cell点击，此处跳转到信用评分页面
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1) {
        if ([DDUtils isEmptyString:[DDUserManager sharedInstance].userid]) {//未登录
            DDLoginCheckVC * vc = [[DDLoginCheckVC alloc] init];
            vc.loginSuccessBlock = ^{
            };
            
            UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
            [DDNavigationUtil setNavigationAndBottomLineWhiteColor:nav];
            [self showViewController:nav sender:nil];
        }
        else{//已登录
#pragma mark 新版本购买AAA证书
            //****************************
            if ([_companyInfoModel.info.comprehensiveScore floatValue] >= 60.0 && [_companyInfoModel.info.comprehensiveScore floatValue] < 80.0) {
                
                DDChooseBuyAAACertificateVC *buyCertificate = [[DDChooseBuyAAACertificateVC alloc]init];
                buyCertificate.email=_companyInfoModel.user_email;
                buyCertificate.enterpriseName=_companyInfoModel.info.enterpriseName;
                buyCertificate.enterpriseId=_companyInfoModel.info.enterpriseId;
                [self.navigationController pushViewController:buyCertificate animated:YES];
            }
#pragma mark 旧版本
            //****************************
//            DDCompanyCreditScoreListVC *creditScore=[[DDCompanyCreditScoreListVC alloc]init];
//            creditScore.enterpriseId=_companyInfoModel.info.enterpriseId;
//            [self.navigationController pushViewController:creditScore animated:YES];
            //*****************************
            
            //        DDWinTheBiddingVC *winBidding= [[DDWinTheBiddingVC alloc] init];
            //        winBidding.enterpriseId=_companyInfoModel.info.enterpriseId;
            //        winBidding.toAction=_companyInfoModel.totalBill.toAction;
            //        //winBidding.totalNum=_companyInfoModel.totalBill.totalNum;
            //        //winBidding.totalAmount=_companyInfoModel.totalBill.totalAmount;
            //        [self.navigationController pushViewController:winBidding animated:YES];
        }
    }
}
//KHttpRequest_claimed

//定制头视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==2) {
        DDCompanyDetailModel2 *model=_dataSource[0];
        
        UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 45)];
        bgView.backgroundColor=kColorWhite;
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(12, 0, 100, 45)];
        label.text=model.name;
        label.textColor=KColorBlackTitle;
        label.font=kFontSize28Bold;
        [bgView addSubview:label];
        
        UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(Screen_Width-12-15, 15, 15, 15)];
        imgView.image=[UIImage imageNamed:@"home_comopanyDetail_arrow"];
        [bgView addSubview:imgView];
        
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMinX(imgView.frame)-6-80, 15,80, 15)];
        [btn setTitleColor:KColorBlackTitle forState:UIControlStateNormal];
        [btn setTitle:@"有效期汇总" forState:UIControlStateNormal];
        btn.titleLabel.font=kFontSize28;
        [btn addTarget:self action:@selector(validSummaryClick1) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:btn];
        return bgView;
    }
    else if(section==3){
        DDCompanyDetailModel2 *model=_dataSource[1];
        
        UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 45)];
        bgView.backgroundColor=kColorWhite;
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(12, 0, 100, 45)];
        label.backgroundColor=kColorWhite;
        label.text=model.name;
        label.textColor=KColorBlackTitle;
        label.font=kFontSize28Bold;
        [bgView addSubview:label];

        UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(Screen_Width-12-15, 15, 15, 15)];
        imgView.image=[UIImage imageNamed:@"home_comopanyDetail_arrow"];
        [bgView addSubview:imgView];
        
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMinX(imgView.frame)-6-80, 15,80, 15)];
        [btn setTitleColor:KColorBlackTitle forState:UIControlStateNormal];
        [btn setTitle:@"有效期汇总" forState:UIControlStateNormal];
        btn.titleLabel.font=kFontSize28;
        [btn addTarget:self action:@selector(validSummaryClick2) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:btn];
        return bgView;
    }
    else if(section==4){
        DDCompanyDetailModel2 *model=_dataSource[2];
        
        UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 45)];
        bgView.backgroundColor=kColorWhite;
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(12, 0, 100, 45)];
        label.backgroundColor=kColorWhite;
        label.text=model.name;
        label.textColor=KColorBlackTitle;
        label.font=kFontSize28Bold;
        [bgView addSubview:label];
        return bgView;
    }
    else if(section==5){
        DDCompanyDetailModel2 *model=_dataSource[3];
        
        UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 45)];
        bgView.backgroundColor=kColorWhite;
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(12, 0, 100, 45)];
        label.backgroundColor=kColorWhite;
        label.text=model.name;
        label.textColor=KColorBlackTitle;
        label.font=kFontSize28Bold;
        [bgView addSubview:label];
        return bgView;
    }
    else if (section == 6){
        DDCompanyDetailModel2 *model=_dataSource[4];
        
        UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 45)];
        bgView.backgroundColor=kColorWhite;
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(12, 0, 100, 45)];
        label.backgroundColor=kColorWhite;
        label.text=model.name;
        label.textColor=KColorBlackTitle;
        label.font=kFontSize28Bold;
        [bgView addSubview:label];
        return bgView;
    }
    else if (section == 7){
        DDCompanyDetailModel2 *model=_dataSource[5];
        
        UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 45)];
        bgView.backgroundColor=kColorWhite;
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(12, 0, 100, 45)];
        label.backgroundColor=kColorWhite;
        label.text=model.name;
        label.textColor=KColorBlackTitle;
        label.font=kFontSize28Bold;
        [bgView addSubview:label];
        return bgView;
    }
    else{
        return nil;
    }
}


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

//返回每行行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        //return 223;
        return UITableViewAutomaticDimension;
    }
    else if(indexPath.section==1){
        return 60;
    }
    else if(indexPath.section==2){
        DDCompanyDetailModel2 *model=_dataSource[0];
        return [DDNineGridCell heightWithArrayNum:model.sub.count];
    }
    else if(indexPath.section==3){
        DDCompanyDetailModel2 *model=_dataSource[1];
        return [DDNineGridCell heightWithArrayNum:model.sub.count];
    }
    else if(indexPath.section==4){
        DDCompanyDetailModel2 *model=_dataSource[2];
        return [DDNineGridCell heightWithArrayNum:model.sub.count];
    }
    else if (indexPath.section ==5){
        DDCompanyDetailModel2 *model=_dataSource[3];
        return [DDNineGridCell heightWithArrayNum:model.sub.count];
    }
    else if (indexPath.section ==6){
        DDCompanyDetailModel2 *model=_dataSource[4];
        return [DDNineGridCell heightWithArrayNum:model.sub.count];
    }
    else{
        DDCompanyDetailModel2 *model=_dataSource[5];
        return [DDNineGridCell heightWithArrayNum:model.sub.count];
    }
}

//返回头视图高
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section==2 || section==3 || section==4 || section==5 || section ==6 || section ==7){
        return 45;
    }
    else{
        return CGFLOAT_MIN;
    }
}

//返回尾视图高
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==_dataSource.count+1) {
        return CGFLOAT_MIN;
    }
    else{
        return 15;
    }
}

//上滑改变标题
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y>50) {
        self.title=_companyInfoModel.info.enterpriseName;
    }
    else{
        self.title=@"";
    }
}

#pragma mark ***********************************业务分割线*************************************
#pragma mark 九宫格代理方法的实现
-(void)nineGridCell:(DDNineGridCell *)nineGridCell index:(NSInteger)index{
    if (nineGridCell.tag==101) {//企业证书
        [self companyCerClickWithIndex:index];
    }
    else if(nineGridCell.tag==102){//人员证书
        [self peopleCerClickWithIndex:index];
    }
    else if(nineGridCell.tag==103){// 中标业绩
        [self bidScoreClcikWithIndex:index];
    }
    else if(nineGridCell.tag==104){//风险信息
        [self riskInfoClickWithIndex:index];
    }
    else if (nineGridCell.tag==105){//奖惩荣誉
        [self awardHonorClickWithIndex:index];
    }
    else if (nineGridCell.tag==106){//信用情况
        [self creditSituationClickWithIndex:index];
    }
}

#pragma mark 企业证书点击
- (void)companyCerClickWithIndex:(NSInteger)index{
    DDCompanyDetailModel2 *model=_dataSource[0];
    DDSubModel *m=model.sub[index];
    
    if ([DDUtils isEmptyString:[DDUserManager sharedInstance].userid]) {//未登录
        [self conpmayCertiLogin:index];
    }
    else{//已登录
        if (index==0) {//营业执照
            DDBusinesslicenseVC * vc = [[DDBusinesslicenseVC alloc] init];
            vc.enterpriseId = _enterpriseId;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if (index==1) {//资质证书
          
                        if ([DDUtils isEmptyString:m.totalNum] || [m.totalNum isEqualToString:@"0"]) {//不能点击
                            [DDUtils showToastWithMessage:@"暂无资质证书"];
                        }
                        else{
                            DDAptitudeCertificateVC  * vc = [[DDAptitudeCertificateVC alloc]init];
                            vc.enterpriseId = _enterpriseId;
                            vc.toAction = m.toAction;
                            [self.navigationController pushViewController:vc animated:YES];
                        }
            
        }
        else if(index==2){//安许证
                        if ([DDUtils isEmptyString:m.totalNum] || [m.totalNum isEqualToString:@"0"]) {//不能点击
                            [DDUtils showToastWithMessage:@"暂无安许证信息"];
                        }
                        else{
                            DDSafePermissionVC * vc = [[DDSafePermissionVC alloc] init];
                            vc.enterpriseId = _enterpriseId;
                            [self.navigationController pushViewController:vc animated:YES];
                        }
           
        }
        else if(index==3){//商标
                        if ([DDUtils isEmptyString:m.totalNum] || [m.totalNum isEqualToString:@"0"]) {//不能点击
                            [DDUtils showToastWithMessage:@"暂无商标"];
                        }else{
                            DDBrandVC *brand= [[DDBrandVC alloc] init];
                            brand.enterpriseId=_companyInfoModel.info.enterpriseId;
                            brand.toAction=m.toAction;
                            [self.navigationController pushViewController:brand animated:YES];
                        }
            
        }
        else if(index==4){//管理体系

            //暂时
                        if ([DDUtils isEmptyString:m.totalNum] || [m.totalNum isEqualToString:@"0"]) {//不能点击
                            [DDUtils showToastWithMessage:@"暂无管理体系"];
                        }else{
                            DDManageListVC * manageList = [[DDManageListVC alloc] init];
                            manageList.enterpriseId=_companyInfoModel.info.enterpriseId;
                            manageList.toAction=m.toAction;
                            [self.navigationController pushViewController:manageList animated:YES];
                        }
            
        }
        else if (index == 5){//守合同重信用
                        if ([DDUtils isEmptyString:m.totalNum] || [m.totalNum isEqualToString:@"0"]) {//不能点击
                            [DDUtils showToastWithMessage:@"暂无守合同重信用"];
                        }else{
                            DDAbideContractVC * threeACer = [[DDAbideContractVC alloc] init];
                            threeACer.enterpriseId=_companyInfoModel.info.enterpriseId;
                            threeACer.toAction=m.toAction;
                            [self.navigationController pushViewController:threeACer animated:YES];
                        }
            
            
        }
        else if (index == 6){//施工工法
                if ([DDUtils isEmptyString:m.totalNum] || [m.totalNum isEqualToString:@"0"]) {//不能点击
                        [DDUtils showToastWithMessage:@"暂无施工工法"];
                }else{
                        DDWorkingLawVC * workingLaw = [[DDWorkingLawVC alloc] init];
                    workingLaw.enterpriseId=_companyInfoModel.info.enterpriseId;
                        workingLaw.toAction=m.toAction;
                        [self.navigationController pushViewController:workingLaw animated:YES];
                }
            
        }
        else if (index == 7){//股东信息
            //暂时
                    if ([DDUtils isEmptyString:m.totalNum] || [m.totalNum isEqualToString:@"0"]) {//不能点击
                        [DDUtils showToastWithMessage:@"暂无股东信息"];
                    }else{
                        DDShareholderInfoVC * shareholderInfo = [[DDShareholderInfoVC alloc] init];
                        shareholderInfo.enterpriseId=_companyInfoModel.info.enterpriseId;
                        [self.navigationController pushViewController:shareholderInfo animated:YES];
                    }
           
        }
        else if (index == 8){//附近同行
            //暂时
            DDNearCompanyVC * vc= [[DDNearCompanyVC alloc] init];
            vc.type =  @"1";
            vc.enterpriseId=_companyInfoModel.info.enterpriseId;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
}

#pragma mark 人员证书点击
- (void)peopleCerClickWithIndex:(NSInteger)index{
    DDCompanyDetailModel2 *model=_dataSource[1];
    DDSubModel *m=model.sub[index];
    
    if ([DDUtils isEmptyString:[DDUserManager sharedInstance].userid]) {//未登录
        [self personalCertiLogin:index];
    }
    else{//已登录
        if ([DDUtils isEmptyString:m.totalNum] || [m.totalNum isEqualToString:@"0"]) {
            
            switch (index) {
                case 0:
                    [DDUtils showToastWithMessage:@"暂无一级建造师"];
                    break;
                case 1:
                    [DDUtils showToastWithMessage:@"暂无二级建造师"];
                    break;
                case 2:
                    [DDUtils showToastWithMessage:@"暂无安全员"];
                    break;
                case 3:
                    [DDUtils showToastWithMessage:@"暂无一级建筑师"];
                    break;
                case 4:
                    [DDUtils showToastWithMessage:@"暂无二级建筑师"];
                    break;
                case 5:
                    [DDUtils showToastWithMessage:@"暂无一级结构师"];
                    break;
                case 6:
                    [DDUtils showToastWithMessage:@"暂无二级结构师"];
                    break;
                case 7:
                    [DDUtils showToastWithMessage:@"暂无土木工程师"];
                    break;
                case 8:
                    [DDUtils showToastWithMessage:@"暂无公用设备师"];
                    break;
                case 9:
                    [DDUtils showToastWithMessage:@"暂无电气工程师"];
                    break;
                case 10:
                    [DDUtils showToastWithMessage:@"暂无化工工程师"];
                    break;
                case 11:
                    [DDUtils showToastWithMessage:@"暂无监理工程师"];
                    break;
                case 12:
                    [DDUtils showToastWithMessage:@"暂无造价工程师"];
                    break;
                case 13:
                    [DDUtils showToastWithMessage:@"暂无消防工程师"];
                    break;
                default:
                    break;
            }
            return;
        }
        
        
        if (index==0) {
            [MobClick event:ent_yijian];
            DDBuilderVC *builder= [[DDBuilderVC alloc] init];
            builder.enterpriseId=_companyInfoModel.info.enterpriseId;
            builder.toAction=m.toAction;
            builder.certLevel=@"1";
            [self.navigationController pushViewController:builder animated:YES];
        }
        else if(index==1){
            [MobClick event:ent_yijian];
            DDBuilderVC *builder= [[DDBuilderVC alloc] init];
            builder.enterpriseId=_companyInfoModel.info.enterpriseId;
            builder.toAction=m.toAction;
            builder.certLevel=@"2";
            builder.isOpen = _companyInfoModel.open;
            builder.attestation = _companyInfoModel.attestation;
            builder.enterpriseName = _companyInfoModel.info.enterpriseName;
            [self.navigationController pushViewController:builder animated:YES];
        }
        else if(index==2){
            [MobClick event:ent_anquanyuan];
            DDSafeManVC *safeman= [[DDSafeManVC alloc] init];
            safeman.enterpriseId=_companyInfoModel.info.enterpriseId;
            safeman.toAction=m.toAction;
            safeman.isOpen = _companyInfoModel.open;
            safeman.attestation = _companyInfoModel.attestation;
            safeman.enterpriseName = _companyInfoModel.info.enterpriseName;
            [self.navigationController pushViewController:safeman animated:YES];
        }
        else if (index == 3){//一级建筑师
            DDArchitectListVC * architect = [[DDArchitectListVC alloc] init];
            architect.enterpriseId = _companyInfoModel.info.enterpriseId;
            architect.toAction = m.toAction;
            architect.type = @"4";
            [self.navigationController pushViewController:architect animated:YES];
        }
        else if (index == 4){//二级建筑师
            DDArchitectListVC * architect = [[DDArchitectListVC alloc] init];
            architect.enterpriseId = _companyInfoModel.info.enterpriseId;
            architect.toAction = m.toAction;
            architect.type = @"5";
            [self.navigationController pushViewController:architect animated:YES];
        }
        else if (index == 5){//一级结构师
            DDArchitectListVC * architect = [[DDArchitectListVC alloc] init];
            architect.enterpriseId = _companyInfoModel.info.enterpriseId;
            architect.toAction = m.toAction;
            architect.type = @"1";
            [self.navigationController pushViewController:architect animated:YES];
        }
        else if (index == 6){//二级结构师
            DDArchitectListVC * architect = [[DDArchitectListVC alloc] init];
            architect.enterpriseId = _companyInfoModel.info.enterpriseId;
            architect.toAction = m.toAction;
            architect.type = @"2";
            [self.navigationController pushViewController:architect animated:YES];
        }
        else if (index == 7){//土木工程师
            DDCivilEngineerListVC *civilEngineer = [[DDCivilEngineerListVC alloc] init];
            civilEngineer.enterpriseId = _companyInfoModel.info.enterpriseId;
            civilEngineer.toAction = m.toAction;
            civilEngineer.type = @"1";
            [self.navigationController pushViewController:civilEngineer animated:YES];
        }
        else if (index == 8){//共用设备师
            DDCivilEngineerListVC *civilEngineer = [[DDCivilEngineerListVC alloc] init];
            civilEngineer.enterpriseId = _companyInfoModel.info.enterpriseId;
            civilEngineer.toAction = m.toAction;
            civilEngineer.type = @"2";
            [self.navigationController pushViewController:civilEngineer animated:YES];
        }
        else if (index == 9){//电气工程师
            DDCivilEngineerListVC *civilEngineer = [[DDCivilEngineerListVC alloc] init];
            civilEngineer.enterpriseId = _companyInfoModel.info.enterpriseId;
            civilEngineer.toAction = m.toAction;
            civilEngineer.type = @"3";
            [self.navigationController pushViewController:civilEngineer animated:YES];
        }
        else if (index == 10){//化工工程师
            DDArchitectListVC * architect = [[DDArchitectListVC alloc] init];
            architect.enterpriseId = _companyInfoModel.info.enterpriseId;
            architect.toAction = m.toAction;
            architect.type = @"3";
            [self.navigationController pushViewController:architect animated:YES];
        }
        else if (index == 11){//监理工程师
            DDCivilEngineerListVC *civilEngineer = [[DDCivilEngineerListVC alloc] init];
            civilEngineer.enterpriseId = _companyInfoModel.info.enterpriseId;
            civilEngineer.toAction = m.toAction;
            civilEngineer.type = @"4";
            [self.navigationController pushViewController:civilEngineer animated:YES];
        }
        else if (index == 12){//造价工程师
            DDCivilEngineerListVC *civilEngineer = [[DDCivilEngineerListVC alloc] init];
            civilEngineer.enterpriseId = _companyInfoModel.info.enterpriseId;
            civilEngineer.toAction = m.toAction;
            civilEngineer.type = @"5";
            [self.navigationController pushViewController:civilEngineer animated:YES];
        }
        else if (index == 13){//消防工程师
            DDFireEngineerListVC *fireEngineer = [[DDFireEngineerListVC alloc] init];
            fireEngineer.enterpriseId = _companyInfoModel.info.enterpriseId;
            fireEngineer.toAction = m.toAction;
            [self.navigationController pushViewController:fireEngineer animated:YES];
        }
    }
    
}

#pragma mark 中标业绩点击
- (void)bidScoreClcikWithIndex:(NSInteger)index{
    DDCompanyDetailModel2 *model=_dataSource[2];
    DDSubModel *m=model.sub[index];
    
    if ([DDUtils isEmptyString:[DDUserManager sharedInstance].userid]) {//未登录
        [self winBiddingLogin:index];
    }
    else{//已登录
        if (index==0) {
            //中标情况
            if ([DDUtils isEmptyString:m.totalNum] || [m.totalNum isEqualToString:@"0"]) {//不能点击
                [DDUtils showToastWithMessage:@"暂无中标情况"];
            }
            else{//能点击
                [MobClick event:ent_zhongbiaoqingkuang];
                
                DDWinTheBiddingVC *winBidding= [[DDWinTheBiddingVC alloc] init];
                winBidding.enterpriseId=_companyInfoModel.info.enterpriseId;
                winBidding.toAction=m.toAction;
                winBidding.type = @"1";
                [self.navigationController pushViewController:winBidding animated:YES];
            }
        }
        else if(index==1){
            //项目经理
            if ([DDUtils isEmptyString:m.totalNum] || [m.totalNum isEqualToString:@"0"]) {//不能点击
                [DDUtils showToastWithMessage:@"暂无项目经理"];
            }
            else{//能点击
                [MobClick event:ent_xiangmujingli];
                
                DDProjectManagerVC *projectManager= [[DDProjectManagerVC alloc] init];
                projectManager.enterpriseId=_companyInfoModel.info.enterpriseId;
                projectManager.toAction=m.toAction;
                [self.navigationController pushViewController:projectManager animated:YES];
            }
        }
        else if(index==2){
            //合同备案
            if ([DDUtils isEmptyString:m.totalNum] || [m.totalNum isEqualToString:@"0"]) {//不能点击
                [DDUtils showToastWithMessage:@"暂无合同备案"];
            }
            else{//能点击
                [MobClick event:ent_hetongbeian];
                
                DDContractCopyVC *contractCopy= [[DDContractCopyVC alloc] init];
                contractCopy.enterpriseId=_companyInfoModel.info.enterpriseId;
                contractCopy.toAction=m.toAction;
                [self.navigationController pushViewController:contractCopy animated:YES];
            }
        }
    }

}
#pragma mark 风险信息点击
- (void)riskInfoClickWithIndex:(NSInteger)index{
    DDCompanyDetailModel2 *model=_dataSource[3];
    DDSubModel *m = model.sub[index];
    
    if ([DDUtils isEmptyString:[DDUserManager sharedInstance].userid]) {//未登录
        [self riskInfoLogin:index];
    }
    else{//已登录
        if (index==0) {
            //失信信息
            if ([DDUtils isEmptyString:m.totalNum] || [m.totalNum isEqualToString:@"0"]) {//不能点击
                [DDUtils showToastWithMessage:@"暂无失信信息"];
            }
            else{//能点击
                [MobClick event:ent_shixinxinxi];
                
                DDExcutedPeopleVC *excutedPeople=[[DDExcutedPeopleVC alloc]init];
                excutedPeople.enterpriseId=_companyInfoModel.info.enterpriseId;
                excutedPeople.toAction=m.toAction;
                excutedPeople.isDiscredit=@"1";
                [self.navigationController pushViewController:excutedPeople animated:YES];
            }
        }
        else if(index==1){
            //被执行人
            if ([DDUtils isEmptyString:m.totalNum] || [m.totalNum isEqualToString:@"0"]) {//不能点击
                [DDUtils showToastWithMessage:@"暂无被执行人"];
            }
            else{//能点击
                [MobClick event:ent_beizhixingren];
                
                DDExcutedPeopleVC *excutedPeople=[[DDExcutedPeopleVC alloc]init];
                excutedPeople.enterpriseId=_companyInfoModel.info.enterpriseId;
                excutedPeople.toAction=m.toAction;
                excutedPeople.isDiscredit=@"0";
                [self.navigationController pushViewController:excutedPeople animated:YES];
            }
        }
        else if(index==2){
            //法院公告
            if ([DDUtils isEmptyString:m.totalNum] || [m.totalNum isEqualToString:@"0"]) {//不能点击
                [DDUtils showToastWithMessage:@"暂无法院公告"];
            }
            else{//能点击
                [MobClick event:ent_fayuangonggao];
                
                DDCourtNoticeVC *courtNotice=[[DDCourtNoticeVC alloc]init];
                courtNotice.enterpriseId=_companyInfoModel.info.enterpriseId;
                courtNotice.toAction=m.toAction;
                [self.navigationController pushViewController:courtNotice animated:YES];
            }
            
        }
        else if (index == 3){
            //裁判文书
            if ([DDUtils isEmptyString:m.totalNum] || [m.totalNum isEqualToString:@"0"]) {//不能点击
                [DDUtils showToastWithMessage:@"暂无裁判文书"];
            }
            else{//能点击
                [MobClick event:ent_caipanwenshu];
                DDJudgePaperVC *judgePaper=[[DDJudgePaperVC alloc]init];
                judgePaper.enterpriseId=_companyInfoModel.info.enterpriseId;
                judgePaper.toAction=m.toAction;
                [self.navigationController pushViewController:judgePaper animated:YES];
            }
            
        }
        else if (index == 4){
            //行政处罚
            if ([DDUtils isEmptyString:m.totalNum] || [m.totalNum isEqualToString:@"0"]) {//不能点击
                    [DDUtils showToastWithMessage:@"暂无行政处罚"];
            }else{
                DDAdminPunishVC *adminPunish=[[DDAdminPunishVC alloc]init];
                adminPunish.enterpriseId=_companyInfoModel.info.enterpriseId;
                adminPunish.toAction=m.toAction;
                [self.navigationController pushViewController:adminPunish animated:YES];
            }
        }
        else if (index == 5){
            //事故情况
            if ([DDUtils isEmptyString:m.totalNum] || [m.totalNum isEqualToString:@"0"]) {//不能点击
                [DDUtils showToastWithMessage:@"暂无事故情况"];
            }
            else{//能点击
                [MobClick event:ent_shiguqingkuang];
                DDAccidentSituationVC *accidentSituation=[[DDAccidentSituationVC alloc]init];
                accidentSituation.enterpriseId=_companyInfoModel.info.enterpriseId;
                accidentSituation.toAction=m.toAction;
                [self.navigationController pushViewController:accidentSituation animated:YES];
            }
        }
        else if (index == 6){
            //环保处罚
            if ([DDUtils isEmptyString:m.totalNum] || [m.totalNum isEqualToString:@"0"]) {//不能点击
                [DDUtils showToastWithMessage:@"暂无环保处罚"];
            }else{
                DDEnvironementAndGroundPunishVC *environmentPunish=[[DDEnvironementAndGroundPunishVC alloc]init];
                environmentPunish.enterpriseId=_companyInfoModel.info.enterpriseId;
                environmentPunish.toAction=m.toAction;
                environmentPunish.punishType=@"1";
                [self.navigationController pushViewController:environmentPunish animated:YES];
            }
        }
        else if (index == 7){
            //工地处罚
            if ([DDUtils isEmptyString:m.totalNum] || [m.totalNum isEqualToString:@"0"]) {//不能点击
                    [DDUtils showToastWithMessage:@"暂无工地处罚"];
            }else{
                DDEnvironementAndGroundPunishVC *groundPunish=[[DDEnvironementAndGroundPunishVC alloc]init];
                groundPunish.enterpriseId=_companyInfoModel.info.enterpriseId;
                groundPunish.toAction=m.toAction;
                groundPunish.punishType=@"2";
                [self.navigationController pushViewController:groundPunish animated:YES];
            }
        }
        else if (index == 8){
            //严重违法
            if ([DDUtils isEmptyString:m.totalNum] || [m.totalNum isEqualToString:@"0"]) {//不能点击
                [DDUtils showToastWithMessage:@"暂无严重违法"];
            }else{
                DDSevereIllegalAndAbnormalVC *severeIllegal=[[DDSevereIllegalAndAbnormalVC alloc]init];
                severeIllegal.enterpriseId=_companyInfoModel.info.enterpriseId;
                severeIllegal.toAction=m.toAction;
                severeIllegal.illegalType=@"1";
                [self.navigationController pushViewController:severeIllegal animated:YES];
            }
        }
        else if (index == 9){
            //税收违法
            if ([DDUtils isEmptyString:m.totalNum] || [m.totalNum isEqualToString:@"0"]) {//不能点击
                [DDUtils showToastWithMessage:@"暂无税收违法"];
            }else{
                DDTaxIllegalVC *taxIllegal=[[DDTaxIllegalVC alloc]init];
                taxIllegal.enterpriseId=_companyInfoModel.info.enterpriseId;
                taxIllegal.toAction=m.toAction;
                [self.navigationController pushViewController:taxIllegal animated:YES];
            }
            
        }
        else if (index == 10){
            //欠税公告
            if ([DDUtils isEmptyString:m.totalNum] || [m.totalNum isEqualToString:@"0"]) {//不能点击
                [DDUtils showToastWithMessage:@"暂无欠税公告"];
            }else{
                DDOweTaxNoticeVC *oweTax=[[DDOweTaxNoticeVC alloc]init];
                oweTax.enterpriseId=_companyInfoModel.info.enterpriseId;
                oweTax.toAction=m.toAction;
                [self.navigationController pushViewController:oweTax animated:YES];
            }
        }
        else if (index == 11){
            //经营异常
            if ([DDUtils isEmptyString:m.totalNum] || [m.totalNum isEqualToString:@"0"]) {//不能点击
                [DDUtils showToastWithMessage:@"暂无经营异常"];
            }else{
                DDSevereIllegalAndAbnormalVC *abnormal=[[DDSevereIllegalAndAbnormalVC alloc]init];
                abnormal.enterpriseId=_companyInfoModel.info.enterpriseId;
                abnormal.toAction=m.toAction;
                abnormal.illegalType=@"2";
                [self.navigationController pushViewController:abnormal animated:YES];
            }
        }
    }
    
}

#pragma mark 获奖荣誉点击
- (void)awardHonorClickWithIndex:(NSInteger)index{
    DDCompanyDetailModel2 *model=_dataSource[4];
    DDSubModel *m = model.sub[index];
    
    if ([DDUtils isEmptyString:[DDUserManager sharedInstance].userid]) {//未登录
        [self rewardHonerLogin:index];
    }
    else{//已登录
        if (index == 0) {
            //获奖情况
            if ([DDUtils isEmptyString:m.totalNum] || [m.totalNum isEqualToString:@"0"]) {//不能点击
                [DDUtils showToastWithMessage:@"暂无获奖情况"];
            }
            else{//能点击
                [MobClick event:ent_huojiangrongyu];
                
                DDCompanyAwardVC *companyAward= [[DDCompanyAwardVC alloc] init];
                companyAward.enterpriseId=_companyInfoModel.info.enterpriseId;
                companyAward.toAction =m.toAction;
                [self.navigationController pushViewController:companyAward animated:YES];
            }
        }
        if (index == 1) {
            //技术创新奖
            if ([DDUtils isEmptyString:m.totalNum] || [m.totalNum isEqualToString:@"0"]) {//不能点击
                    [DDUtils showToastWithMessage:@"暂无技术创新奖"];
            }else{
              DDRewardsListVC *innovateReward= [[DDRewardsListVC alloc] init];
             innovateReward.enterpriseId=_companyInfoModel.info.enterpriseId;
             innovateReward.toAction =m.toAction;
             innovateReward.rewardType=@"1";
              [self.navigationController pushViewController:innovateReward  animated:YES];
            }
           
        }
        if (index == 2) {
            //QC奖
         
           
                    if ([DDUtils isEmptyString:m.totalNum] || [m.totalNum isEqualToString:@"0"]) {//不能点击
                        [DDUtils showToastWithMessage:@"暂无QC奖"];
                    }else{
                        DDRewardsListVC *QCReward= [[DDRewardsListVC alloc] init];
                        QCReward.enterpriseId=_companyInfoModel.info.enterpriseId;
                        QCReward.toAction =m.toAction;
                        QCReward.rewardType=@"2";
                        [self.navigationController pushViewController:QCReward animated:YES];
                    }
            
        }
        if (index == 3) {
            //文明工地
            if ([DDUtils isEmptyString:m.totalNum] || [m.totalNum isEqualToString:@"0"]) {//不能点击
                [DDUtils showToastWithMessage:@"暂无文明工地"];
            }
            else{//能点击
                DDCultureWorkSiteVC * cultureWorkSite = [[DDCultureWorkSiteVC alloc] init];
                cultureWorkSite.enterpriseId=_companyInfoModel.info.enterpriseId;
                //            cultureWorkSite.toAction =m.toAction;
                cultureWorkSite.type = @"1";
                [self.navigationController pushViewController:cultureWorkSite animated:YES];
            }
            
        }
        if (index == 4) {
            //绿色工地
            if ([DDUtils isEmptyString:m.totalNum] || [m.totalNum isEqualToString:@"0"]) {//不能点击
                [DDUtils showToastWithMessage:@"暂无绿色工地"];
            }
            else{//能点击
                DDCultureWorkSiteVC * cultureWorkSite = [[DDCultureWorkSiteVC alloc] init];
                cultureWorkSite.enterpriseId=_companyInfoModel.info.enterpriseId;
                //            cultureWorkSite.toAction =m.toAction;
                cultureWorkSite.type = @"2";
                [self.navigationController pushViewController:cultureWorkSite animated:YES];
            }
        }
    }

}

#pragma mark 信用情况点击
- (void)creditSituationClickWithIndex:(NSInteger)index{
    DDCompanyDetailModel2 *model=_dataSource[5];
    DDSubModel *m = model.sub[index];
    
    if ([DDUtils isEmptyString:[DDUserManager sharedInstance].userid]) {//未登录
        [self creditSituationLogin:index];
    }
    else{//已登录
        if (index == 0) {
            //信用评分
                    if ([DDUtils isEmptyString:m.totalNum] || [m.totalNum isEqualToString:@"0"]) {//不能点击
                        [DDUtils showToastWithMessage:@"暂无信用评价"];
                    }else{
                        DDCompanyCreditScoreListVC *creditScore=[[DDCompanyCreditScoreListVC alloc]init];
                        creditScore.enterpriseId=_companyInfoModel.info.enterpriseId;
                        [self.navigationController pushViewController:creditScore animated:YES];
                    }
           
        }
        if (index == 1) {
            //税务信用
            
                    if ([DDUtils isEmptyString:m.totalNum] || [m.totalNum isEqualToString:@"0"]) {//不能点击
                        [DDUtils showToastWithMessage:@"暂无税务信用"];
                    }else{
                        DDTaxCreditVC *taxCredit= [[DDTaxCreditVC alloc] init];
                        taxCredit.enterpriseId=_companyInfoModel.info.enterpriseId;
                        [self.navigationController pushViewController:taxCredit animated:YES];
                    }
           
        }
    }
    
}

#pragma mark ***********************************业务分割线*************************************
#pragma mark 企业证书点击跳转登录页面
-(void)conpmayCertiLogin:(NSInteger)index{
    DDLoginCheckVC * vc = [[DDLoginCheckVC alloc] init];
    vc.loginSuccessBlock = ^{
        DDCompanyDetailModel2 *model=_dataSource[0];
        DDSubModel *m=model.sub[index];
        if (index==0) {//营业执照
            DDBusinesslicenseVC * vc = [[DDBusinesslicenseVC alloc] init];
            vc.enterpriseId = _enterpriseId;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if (index==1) {//资质证书
            if ([DDUtils isEmptyString:m.totalNum] || [m.totalNum isEqualToString:@"0"]) {//不能点击
                [DDUtils showToastWithMessage:@"暂无资质证书"];
            }
            else{//能点击
                [MobClick event:ent_zizhizhengshu];
                
                DDAptitudeCertificateVC  * vc = [[DDAptitudeCertificateVC alloc]init];
                vc.enterpriseId = _enterpriseId;
                vc.toAction = m.toAction;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
        else if(index==2){//安许证
            if ([DDUtils isEmptyString:m.totalNum] || [m.totalNum isEqualToString:@"0"]) {//不能点击
                [DDUtils showToastWithMessage:@"暂无安许证信息"];
            }
            else{
                [MobClick event:ent_anxuzheng];
                
                DDSafePermissionVC * vc = [[DDSafePermissionVC alloc] init];
                vc.enterpriseId = _enterpriseId;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
        else if(index==3){//商标
            if ([DDUtils isEmptyString:m.totalNum] || [m.totalNum isEqualToString:@"0"]) {//不能点击
                [DDUtils showToastWithMessage:@"暂无商标"];
            }else{//能点击
                DDBrandVC *brand= [[DDBrandVC alloc] init];
                brand.enterpriseId=_companyInfoModel.info.enterpriseId;
                brand.toAction=m.toAction;
                [self.navigationController pushViewController:brand animated:YES];
            }
        }
        else if(index==4){//管理体系
            if ([DDUtils isEmptyString:m.totalNum] || [m.totalNum isEqualToString:@"0"]) {//不能点击
                [DDUtils showToastWithMessage:@"暂无管理体系"];
            }else{
                //能点击
                DDManageListVC * manageList = [[DDManageListVC alloc] init];
                manageList.enterpriseId=_companyInfoModel.info.enterpriseId;
                manageList.toAction=m.toAction;
                [self.navigationController pushViewController:manageList animated:YES];
            }
        }
        else if(index==5){//AAA证书
            if ([DDUtils isEmptyString:m.totalNum] || [m.totalNum isEqualToString:@"0"]) {//不能点击
                [DDUtils showToastWithMessage:@"暂无AAA证书"];
            }else{
                //能点击
                DDThreeACerVC * threeACer = [[DDThreeACerVC alloc] init];
                threeACer.enterpriseId=_companyInfoModel.info.enterpriseId;
                threeACer.toAction=m.toAction;
                [self.navigationController pushViewController:threeACer animated:YES];
            }
            
        }
        else if (index == 6){//守合同重信用
            if ([DDUtils isEmptyString:m.totalNum] || [m.totalNum isEqualToString:@"0"]) {//不能点击
                [DDUtils showToastWithMessage:@"暂无守合同重信用"];
            }else{
                //能点击
                DDAbideContractVC * threeACer = [[DDAbideContractVC alloc] init];
                threeACer.enterpriseId=_companyInfoModel.info.enterpriseId;
                threeACer.toAction=m.toAction;
                [self.navigationController pushViewController:threeACer animated:YES];
            }
            
        }
        else if (index == 7){//施工工法
            if ([DDUtils isEmptyString:m.totalNum] || [m.totalNum isEqualToString:@"0"]) {//不能点击
                [DDUtils showToastWithMessage:@"暂无施工工法"];
            }else{
                //能点击
                DDWorkingLawVC * workingLaw = [[DDWorkingLawVC alloc] init];
                workingLaw.enterpriseId=_companyInfoModel.info.enterpriseId;
                workingLaw.toAction=m.toAction;
                [self.navigationController pushViewController:workingLaw animated:YES];
            }
        }
        else if (index == 8){//附近同行
            //暂时
            DDNearCompanyVC * vc= [[DDNearCompanyVC alloc] init];
            vc.type =  @"1";
            vc.enterpriseId=_companyInfoModel.info.enterpriseId;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if (index == 9){//股东信息
            //        if ([DDUtils isEmptyString:m.totalNum] || [m.totalNum isEqualToString:@"0"]) {//不能点击
            //            [DDUtils showToastWithMessage:@"暂无股东信息"];
            //        }else{
            //            //能点击
            //            DDShareholderInfoVC * shareholderInfo = [[DDShareholderInfoVC alloc] init];
            //            shareholderInfo.enterpriseId=_companyInfoModel.info.enterpriseId;
            //            [self.navigationController pushViewController:shareholderInfo animated:YES];
            //        }
            //暂时
            if ([DDUtils isEmptyString:m.totalNum] || [m.totalNum isEqualToString:@"0"]) {//不能点击
                    [DDUtils showToastWithMessage:@"暂无股东信息"];
                }else{
                DDShareholderInfoVC * shareholderInfo = [[DDShareholderInfoVC alloc] init];
            shareholderInfo.enterpriseId=_companyInfoModel.info.enterpriseId;
                    [self.navigationController pushViewController:shareholderInfo animated:YES];
            }
            
        }
    };
    
    
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [DDNavigationUtil setNavigationAndBottomLineWhiteColor:nav];
    [self showViewController:nav sender:nil];
}

#pragma mark 人员证书点击跳转登录页面
-(void)personalCertiLogin:(NSInteger)index{
    DDLoginCheckVC * vc = [[DDLoginCheckVC alloc] init];
    vc.loginSuccessBlock = ^{
        DDCompanyDetailModel2 *model=_dataSource[1];
        DDSubModel *m=model.sub[index];
        
        if ([DDUtils isEmptyString:m.totalNum] || [m.totalNum isEqualToString:@"0"]) {
            
            switch (index) {
                case 0:
                    [DDUtils showToastWithMessage:@"暂无一级建造师"];
                    break;
                case 1:
                    [DDUtils showToastWithMessage:@"暂无二级建造师"];
                    break;
                case 2:
                    [DDUtils showToastWithMessage:@"暂无安全员"];
                    break;
                case 3:
                    [DDUtils showToastWithMessage:@"暂无一级建筑师"];
                    break;
                case 4:
                    [DDUtils showToastWithMessage:@"暂无二级建筑师"];
                    break;
                case 5:
                    [DDUtils showToastWithMessage:@"暂无一级结构师"];
                    break;
                case 6:
                    [DDUtils showToastWithMessage:@"暂无二级结构师"];
                    break;
                case 7:
                    [DDUtils showToastWithMessage:@"暂无土木工程师"];
                    break;
                case 8:
                    [DDUtils showToastWithMessage:@"暂无公用设备师"];
                    break;
                case 9:
                    [DDUtils showToastWithMessage:@"暂无电气工程师"];
                    break;
                case 10:
                    [DDUtils showToastWithMessage:@"暂无化工工程师"];
                    break;
                case 11:
                    [DDUtils showToastWithMessage:@"暂无监理工程师"];
                    break;
                case 12:
                    [DDUtils showToastWithMessage:@"暂无造价工程师"];
                    break;
                case 13:
                    [DDUtils showToastWithMessage:@"暂无消防工程师"];
                    break;
                default:
                    break;
            }
            return;
        }
        
        
        if (index==0) {
            //一级建造师
           
                [MobClick event:ent_yijian];
                
                DDBuilderVC *builder= [[DDBuilderVC alloc] init];
                builder.enterpriseId=_companyInfoModel.info.enterpriseId;
                builder.toAction=m.toAction;
                builder.certLevel=@"1";
                [self.navigationController pushViewController:builder animated:YES];
            
            
        }
        else if(index==1){
           
                [MobClick event:ent_yijian];
                
                DDBuilderVC *builder= [[DDBuilderVC alloc] init];
                builder.enterpriseId=_companyInfoModel.info.enterpriseId;
                builder.toAction=m.toAction;
                builder.certLevel=@"2";
                builder.isOpen = _companyInfoModel.open;
                builder.attestation = _companyInfoModel.attestation;
                builder.enterpriseName = _companyInfoModel.info.enterpriseName;
                [self.navigationController pushViewController:builder animated:YES];
        }
        else if(index==2){
                [MobClick event:ent_anquanyuan];
                DDSafeManVC *safeman= [[DDSafeManVC alloc] init];
                safeman.enterpriseId=_companyInfoModel.info.enterpriseId;
                safeman.toAction=m.toAction;
                safeman.isOpen = _companyInfoModel.open;
                safeman.attestation = _companyInfoModel.attestation;
                safeman.enterpriseName = _companyInfoModel.info.enterpriseName;
                [self.navigationController pushViewController:safeman animated:YES];
        }
        else if (index == 3){//一级建筑师
           
                DDArchitectListVC * architect = [[DDArchitectListVC alloc] init];
                architect.enterpriseId = _companyInfoModel.info.enterpriseId;
                architect.toAction = m.toAction;
                architect.type = @"4";
                [self.navigationController pushViewController:architect animated:YES];
            
        }
        else if (index == 4){//二级建筑师
            //暂时
            DDArchitectListVC * architect = [[DDArchitectListVC alloc] init];
            architect.enterpriseId = _companyInfoModel.info.enterpriseId;
            architect.toAction = m.toAction;
            architect.type = @"5";
            [self.navigationController pushViewController:architect animated:YES];
        }
        else if (index == 5){//一级结构师
            //暂时
            DDArchitectListVC * architect = [[DDArchitectListVC alloc] init];
            architect.enterpriseId = _companyInfoModel.info.enterpriseId;
            architect.toAction = m.toAction;
            architect.type = @"1";
            [self.navigationController pushViewController:architect animated:YES];
        }
        else if (index == 6){//二级结构师
            //暂时
            DDArchitectListVC * architect = [[DDArchitectListVC alloc] init];
            architect.enterpriseId = _companyInfoModel.info.enterpriseId;
            architect.toAction = m.toAction;
            architect.type = @"2";
            [self.navigationController pushViewController:architect animated:YES];
        }
        else if (index == 7){//土木工程师
            //暂时
            DDCivilEngineerListVC *civilEngineer = [[DDCivilEngineerListVC alloc] init];
            civilEngineer.enterpriseId = _companyInfoModel.info.enterpriseId;
            civilEngineer.toAction = m.toAction;
            civilEngineer.type = @"1";
            [self.navigationController pushViewController:civilEngineer animated:YES];
        }
        else if (index == 8){//共用设备师
            //暂时
            DDCivilEngineerListVC *civilEngineer = [[DDCivilEngineerListVC alloc] init];
            civilEngineer.enterpriseId = _companyInfoModel.info.enterpriseId;
            civilEngineer.toAction = m.toAction;
            civilEngineer.type = @"2";
            [self.navigationController pushViewController:civilEngineer animated:YES];
        }
        else if (index == 9){//电气工程师
            //暂时
            DDCivilEngineerListVC *civilEngineer = [[DDCivilEngineerListVC alloc] init];
            civilEngineer.enterpriseId = _companyInfoModel.info.enterpriseId;
            civilEngineer.toAction = m.toAction;
            civilEngineer.type = @"3";
            [self.navigationController pushViewController:civilEngineer animated:YES];
        }
        else if (index == 10){//化工工程师
            //暂时
            DDArchitectListVC * architect = [[DDArchitectListVC alloc] init];
            architect.enterpriseId = _companyInfoModel.info.enterpriseId;
            architect.toAction = m.toAction;
            architect.type = @"3";
            [self.navigationController pushViewController:architect animated:YES];
        }
        else if (index == 11){//监理工程师
            //暂时
            DDCivilEngineerListVC *civilEngineer = [[DDCivilEngineerListVC alloc] init];
            civilEngineer.enterpriseId = _companyInfoModel.info.enterpriseId;
            civilEngineer.toAction = m.toAction;
            civilEngineer.type = @"4";
            [self.navigationController pushViewController:civilEngineer animated:YES];
        }
        else if (index == 12){//造价工程师
            //暂时
            DDCivilEngineerListVC *civilEngineer = [[DDCivilEngineerListVC alloc] init];
            civilEngineer.enterpriseId = _companyInfoModel.info.enterpriseId;
            civilEngineer.toAction = m.toAction;
            civilEngineer.type = @"5";
            [self.navigationController pushViewController:civilEngineer animated:YES];
        }
        else if (index == 13){//消防工程师
            //暂时
            DDFireEngineerListVC *fireEngineer = [[DDFireEngineerListVC alloc] init];
            fireEngineer.enterpriseId = _companyInfoModel.info.enterpriseId;
            fireEngineer.toAction = m.toAction;
            [self.navigationController pushViewController:fireEngineer animated:YES];
        }
    };
    
    
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [DDNavigationUtil setNavigationAndBottomLineWhiteColor:nav];
    [self showViewController:nav sender:nil];
}

#pragma mark 中标业绩点击跳转登录页面
-(void)winBiddingLogin:(NSInteger)index{
    DDLoginCheckVC * vc = [[DDLoginCheckVC alloc] init];
    vc.loginSuccessBlock = ^{
        
        
        DDCompanyDetailModel2 *model=_dataSource[2];
        DDSubModel *m=model.sub[index];
        
        
        if (index==0) {
            //中标情况
            if ([DDUtils isEmptyString:m.totalNum] || [m.totalNum isEqualToString:@"0"]) {//不能点击
                [DDUtils showToastWithMessage:@"暂无中标情况"];
            }
            else{//能点击
                [MobClick event:ent_zhongbiaoqingkuang];
                
                DDWinTheBiddingVC *winBidding= [[DDWinTheBiddingVC alloc] init];
                winBidding.enterpriseId=_companyInfoModel.info.enterpriseId;
                winBidding.toAction=m.toAction;
                winBidding.type = @"1";
                [self.navigationController pushViewController:winBidding animated:YES];
            }
            
        }
        else if(index==1){
            //PPP项目
            if ([DDUtils isEmptyString:m.totalNum] || [m.totalNum isEqualToString:@"0"]) {//不能点击
                [DDUtils showToastWithMessage:@"暂无PPP项目"];
            }
            else{//能点击
                
                DDWinTheBiddingVC *winBidding= [[DDWinTheBiddingVC alloc] init];
                winBidding.enterpriseId=_companyInfoModel.info.enterpriseId;
                winBidding.toAction=m.toAction;
                winBidding.type = @"2";
                [self.navigationController pushViewController:winBidding animated:YES];
            }
        }
        else if(index==2){
            //项目经理
            if ([DDUtils isEmptyString:m.totalNum] || [m.totalNum isEqualToString:@"0"]) {//不能点击
                [DDUtils showToastWithMessage:@"暂无项目经理"];
            }
            else{//能点击
                [MobClick event:ent_xiangmujingli];
                
                DDProjectManagerVC *projectManager= [[DDProjectManagerVC alloc] init];
                projectManager.enterpriseId=_companyInfoModel.info.enterpriseId;
                projectManager.toAction=m.toAction;
                [self.navigationController pushViewController:projectManager animated:YES];
            }
        }
        else if(index==3){
            //合同备案
            if ([DDUtils isEmptyString:m.totalNum] || [m.totalNum isEqualToString:@"0"]) {//不能点击
                [DDUtils showToastWithMessage:@"暂无合同备案"];
            }
            else{//能点击
                [MobClick event:ent_hetongbeian];
                
                DDContractCopyVC *contractCopy= [[DDContractCopyVC alloc] init];
                contractCopy.enterpriseId=_companyInfoModel.info.enterpriseId;
                contractCopy.toAction=m.toAction;
                [self.navigationController pushViewController:contractCopy animated:YES];
            }
        }
    };
    
    
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [DDNavigationUtil setNavigationAndBottomLineWhiteColor:nav];
    [self showViewController:nav sender:nil];
}

#pragma mark 风险信息点击跳转登录页面
-(void)riskInfoLogin:(NSInteger)index{
    DDLoginCheckVC * vc = [[DDLoginCheckVC alloc] init];
    vc.loginSuccessBlock = ^{
        DDCompanyDetailModel2 *model=_dataSource[3];
        DDSubModel *m = model.sub[index];
        if (index==0) {
            //失信信息
            if ([DDUtils isEmptyString:m.totalNum] || [m.totalNum isEqualToString:@"0"]) {//不能点击
                [DDUtils showToastWithMessage:@"暂无失信信息"];
            }
            else{//能点击
                [MobClick event:ent_shixinxinxi];
                
                DDExcutedPeopleVC *excutedPeople=[[DDExcutedPeopleVC alloc]init];
                excutedPeople.enterpriseId=_companyInfoModel.info.enterpriseId;
                excutedPeople.toAction=m.toAction;
                excutedPeople.isDiscredit=@"1";
                [self.navigationController pushViewController:excutedPeople animated:YES];
            }
        }
        else if(index==1){
            //被执行人
            if ([DDUtils isEmptyString:m.totalNum] || [m.totalNum isEqualToString:@"0"]) {//不能点击
                [DDUtils showToastWithMessage:@"暂无被执行人"];
            }
            else{//能点击
                [MobClick event:ent_beizhixingren];
                
                DDExcutedPeopleVC *excutedPeople=[[DDExcutedPeopleVC alloc]init];
                excutedPeople.enterpriseId=_companyInfoModel.info.enterpriseId;
                excutedPeople.toAction=m.toAction;
                excutedPeople.isDiscredit=@"0";
                [self.navigationController pushViewController:excutedPeople animated:YES];
            }
        }
        else if(index==2){
            //法院公告
            if ([DDUtils isEmptyString:m.totalNum] || [m.totalNum isEqualToString:@"0"]) {//不能点击
                [DDUtils showToastWithMessage:@"暂无法院公告"];
            }
            else{//能点击
                [MobClick event:ent_fayuangonggao];
                
                DDCourtNoticeVC *courtNotice=[[DDCourtNoticeVC alloc]init];
                courtNotice.enterpriseId=_companyInfoModel.info.enterpriseId;
                courtNotice.toAction=m.toAction;
                [self.navigationController pushViewController:courtNotice animated:YES];
            }
            
        }
        else if (index == 3){
            //裁判文书
            if ([DDUtils isEmptyString:m.totalNum] || [m.totalNum isEqualToString:@"0"]) {//不能点击
                [DDUtils showToastWithMessage:@"暂无裁判文书"];
            }
            else{//能点击
                [MobClick event:ent_caipanwenshu];
                
                DDJudgePaperVC *judgePaper=[[DDJudgePaperVC alloc]init];
                judgePaper.enterpriseId=_companyInfoModel.info.enterpriseId;
                judgePaper.toAction=m.toAction;
                [self.navigationController pushViewController:judgePaper animated:YES];
            }
            
        }
        else if (index == 4){
            //行政处罚
            if ([DDUtils isEmptyString:m.totalNum] || [m.totalNum isEqualToString:@"0"]) {//不能点击
                [DDUtils showToastWithMessage:@"暂无行政处罚"];
            }else{
                DDAdminPunishVC *adminPunish=[[DDAdminPunishVC alloc]init];
                adminPunish.enterpriseId=_companyInfoModel.info.enterpriseId;
                adminPunish.toAction=m.toAction;
                [self.navigationController pushViewController:adminPunish animated:YES];
            }
        }
        else if (index == 5){
            //事故情况
            if ([DDUtils isEmptyString:m.totalNum] || [m.totalNum isEqualToString:@"0"]) {//不能点击
                [DDUtils showToastWithMessage:@"暂无事故情况"];
            }
            else{//能点击
                [MobClick event:ent_shiguqingkuang];
                
                DDAccidentSituationVC *accidentSituation=[[DDAccidentSituationVC alloc]init];
                accidentSituation.enterpriseId=_companyInfoModel.info.enterpriseId;
                accidentSituation.toAction=m.toAction;
                [self.navigationController pushViewController:accidentSituation animated:YES];
            }
        }
        else if (index == 6){
            //环保处罚
            if ([DDUtils isEmptyString:m.totalNum] || [m.totalNum isEqualToString:@"0"]) {//不能点击
                [DDUtils showToastWithMessage:@"暂无环保处罚"];
            }else{
                DDEnvironementAndGroundPunishVC *environmentPunish=[[DDEnvironementAndGroundPunishVC alloc]init];
                environmentPunish.enterpriseId=_companyInfoModel.info.enterpriseId;
                environmentPunish.toAction=m.toAction;
                environmentPunish.punishType=@"1";
                [self.navigationController pushViewController:environmentPunish animated:YES];
            }
        }
        else if (index == 7){
            //工地处罚
        if ([DDUtils isEmptyString:m.totalNum] || [m.totalNum isEqualToString:@"0"]) {//不能点击
                [DDUtils showToastWithMessage:@"暂无工地处罚"];
        }else{
            DDEnvironementAndGroundPunishVC *groundPunish=[[DDEnvironementAndGroundPunishVC alloc]init];
            groundPunish.enterpriseId=_companyInfoModel.info.enterpriseId;
            groundPunish.toAction=m.toAction;
            groundPunish.punishType=@"2";
            [self.navigationController pushViewController:groundPunish animated:YES];
                    }
        }
        else if (index == 8){
            //严重违法
            if ([DDUtils isEmptyString:m.totalNum] || [m.totalNum isEqualToString:@"0"]) {//不能点击
                    [DDUtils showToastWithMessage:@"暂无严重违法"];
            }else{
                DDSevereIllegalAndAbnormalVC *severeIllegal=[[DDSevereIllegalAndAbnormalVC alloc]init];
                severeIllegal.enterpriseId=_companyInfoModel.info.enterpriseId;
                severeIllegal.toAction=m.toAction;
                severeIllegal.illegalType=@"1";
                [self.navigationController pushViewController:severeIllegal animated:YES];
            }
           
        }
        else if (index == 9){
            //税收违法
            if ([DDUtils isEmptyString:m.totalNum] || [m.totalNum isEqualToString:@"0"]) {//不能点击
                [DDUtils showToastWithMessage:@"暂无税收违法"];
            }else{
                DDTaxIllegalVC *taxIllegal=[[DDTaxIllegalVC alloc]init];
                taxIllegal.enterpriseId=_companyInfoModel.info.enterpriseId;
                taxIllegal.toAction=m.toAction;
                [self.navigationController pushViewController:taxIllegal animated:YES];
            }
        }
        else if (index == 10){
            //欠税公告
            if ([DDUtils isEmptyString:m.totalNum] || [m.totalNum isEqualToString:@"0"]) {//不能点击
                    [DDUtils showToastWithMessage:@"暂无欠税公告"];
            }else{
                DDOweTaxNoticeVC *oweTax=[[DDOweTaxNoticeVC alloc]init];
                oweTax.enterpriseId=_companyInfoModel.info.enterpriseId;
                oweTax.toAction=m.toAction;
                [self.navigationController pushViewController:oweTax animated:YES];
            }
        }
        else if (index == 11){
            //经营异常
            if ([DDUtils isEmptyString:m.totalNum] || [m.totalNum isEqualToString:@"0"]) {//不能点击
                    [DDUtils showToastWithMessage:@"暂无经营异常"];
            }else{
                DDSevereIllegalAndAbnormalVC *abnormal=[[DDSevereIllegalAndAbnormalVC alloc]init];
                abnormal.enterpriseId=_companyInfoModel.info.enterpriseId;
                abnormal.toAction=m.toAction;
                abnormal.illegalType=@"2";
                [self.navigationController pushViewController:abnormal animated:YES];
            }
        }
    };
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [DDNavigationUtil setNavigationAndBottomLineWhiteColor:nav];
    [self showViewController:nav sender:nil];
}

#pragma mark 奖惩荣誉点击跳转登录页面
-(void)rewardHonerLogin:(NSInteger)index{
    DDLoginCheckVC * vc = [[DDLoginCheckVC alloc] init];
    vc.loginSuccessBlock = ^{
    
        
        DDCompanyDetailModel2 *model=_dataSource[4];
        DDSubModel *m = model.sub[index];
    
    
        if (index == 0) {
            //获奖情况
            if ([DDUtils isEmptyString:m.totalNum] || [m.totalNum isEqualToString:@"0"]) {//不能点击
                [DDUtils showToastWithMessage:@"暂无获奖荣誉"];
            }
            else{//能点击
                [MobClick event:ent_huojiangrongyu];
                
                DDCompanyAwardVC *companyAward= [[DDCompanyAwardVC alloc] init];
                companyAward.enterpriseId=_companyInfoModel.info.enterpriseId;
                companyAward.toAction =m.toAction;
                [self.navigationController pushViewController:companyAward animated:YES];
            }
        }
        if (index == 1) {
            //技术创新奖
            
    
            
        if ([DDUtils isEmptyString:m.totalNum] || [m.totalNum isEqualToString:@"0"]) {//不能点击
                    [DDUtils showToastWithMessage:@"暂无技术创新奖"];
        }else{
            DDRewardsListVC *innovateReward= [[DDRewardsListVC alloc] init];
            innovateReward.enterpriseId=_companyInfoModel.info.enterpriseId;
            innovateReward.toAction =m.toAction;
                innovateReward.rewardType=@"1";
                [self.navigationController pushViewController:innovateReward animated:YES];
        }
            
        }
        if (index == 2) {
            //QC奖
                    if ([DDUtils isEmptyString:m.totalNum] || [m.totalNum isEqualToString:@"0"]) {//不能点击
                        [DDUtils showToastWithMessage:@"暂无QC奖"];
                    }else{
                        DDRewardsListVC *QCReward= [[DDRewardsListVC alloc] init];
                        QCReward.enterpriseId=_companyInfoModel.info.enterpriseId;
                        QCReward.toAction =m.toAction;
                        QCReward.rewardType=@"2";
                        [self.navigationController pushViewController:QCReward animated:YES];
                    }
           
        }
        if (index == 3) {
            //文明工地
            if ([DDUtils isEmptyString:m.totalNum] || [m.totalNum isEqualToString:@"0"]) {//不能点击
                [DDUtils showToastWithMessage:@"暂无文明工地"];
            }
            else{//能点击
                DDCultureWorkSiteVC * cultureWorkSite = [[DDCultureWorkSiteVC alloc] init];
                cultureWorkSite.enterpriseId=_companyInfoModel.info.enterpriseId;
                //            cultureWorkSite.toAction =m.toAction;
                cultureWorkSite.type = @"1";
                [self.navigationController pushViewController:cultureWorkSite animated:YES];
            }
            
        }
        if (index == 4) {
            //绿色工地
            if ([DDUtils isEmptyString:m.totalNum] || [m.totalNum isEqualToString:@"0"]) {//不能点击
                [DDUtils showToastWithMessage:@"暂无绿色工地"];
            }
            else{//能点击
                DDCultureWorkSiteVC * cultureWorkSite = [[DDCultureWorkSiteVC alloc] init];
                cultureWorkSite.enterpriseId=_companyInfoModel.info.enterpriseId;
                //            cultureWorkSite.toAction =m.toAction;
                cultureWorkSite.type = @"2";
                [self.navigationController pushViewController:cultureWorkSite animated:YES];
            }
        }
    };


    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [DDNavigationUtil setNavigationAndBottomLineWhiteColor:nav];
    [self showViewController:nav sender:nil];
}

#pragma mark 信用情况点击跳转登录页面
-(void)creditSituationLogin:(NSInteger)index{
    DDLoginCheckVC * vc = [[DDLoginCheckVC alloc] init];
    vc.loginSuccessBlock = ^{
    
    
        DDCompanyDetailModel2 *model=_dataSource[5];
        DDSubModel *m = model.sub[index];
    
        if (index == 0) {
            //信用评价
          
           
                    if ([DDUtils isEmptyString:m.totalNum] || [m.totalNum isEqualToString:@"0"]) {//不能点击
                        [DDUtils showToastWithMessage:@"暂无信用评价"];
                    }else{
                        DDCompanyCreditScoreListVC *creditScore=[[DDCompanyCreditScoreListVC alloc]init];
                        creditScore.enterpriseId=_companyInfoModel.info.enterpriseId;
                        [self.navigationController pushViewController:creditScore animated:YES];
                    }
           
        }
        if (index == 1) {
            //税务信用
         
                    if ([DDUtils isEmptyString:m.totalNum] || [m.totalNum isEqualToString:@"0"]) {//不能点击
                        [DDUtils showToastWithMessage:@"暂无税务信用"];
                    }else{
                        DDTaxCreditVC *taxCredit= [[DDTaxCreditVC alloc] init];
                        taxCredit.enterpriseId=_companyInfoModel.info.enterpriseId;
                        [self.navigationController pushViewController:taxCredit animated:YES];
                    }
            
        }
    };


    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [DDNavigationUtil setNavigationAndBottomLineWhiteColor:nav];
    [self showViewController:nav sender:nil];
}

#pragma mark ***********************************业务分割线*************************************
#pragma mark 刷新点击事件
-(void)refreshBtnClick{
    [self requestCompanyNumberData];
}

#pragma mark 点击跳转到人员详情页面
-(void)peopleBtnClick:(UIButton *)sender{
    if ([DDUtils isEmptyString:[DDUserManager sharedInstance].userid]) {//未登录
        DDLoginCheckVC * vc = [[DDLoginCheckVC alloc] init];
        vc.loginSuccessBlock = ^{
            [self requestCompanyData];
            DDPeopleDetailVC *peopleDetail=[[DDPeopleDetailVC alloc]init];
            peopleDetail.staffInfoId=_companyInfoModel.info.legalRepresentativeId;
            peopleDetail.isFromCompanyDetail=@"1";
            [self.navigationController pushViewController:peopleDetail animated:YES];
        };
        
        UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
        [DDNavigationUtil setNavigationAndBottomLineWhiteColor:nav];
        [self showViewController:nav sender:nil];
    }
    else{//已登录
        DDPeopleDetailVC *peopleDetail=[[DDPeopleDetailVC alloc]init];
        peopleDetail.staffInfoId=_companyInfoModel.info.legalRepresentativeId;
        peopleDetail.isFromCompanyDetail=@"1";
        [self.navigationController pushViewController:peopleDetail animated:YES];
    }
}

#pragma mark 电话点击事件
-(void)telBtnClick{
    if ([DDUtils isEmptyString:[DDUserManager sharedInstance].userid]) {//未登录
        DDLoginCheckVC * vc = [[DDLoginCheckVC alloc] init];
        vc.loginSuccessBlock = ^{
            

        };
        
        UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
        [DDNavigationUtil setNavigationAndBottomLineWhiteColor:nav];
        [self showViewController:nav sender:nil];
    }
    else{//已登录
        if ([DDUtils isEmptyString:_companyInfoModel.info.contactNumber]) {
            [DDUtils showToastWithMessage:@"暂无联系电话！"];
        }
        else{
            if ([_companyInfoModel.info.contactNumber containsString:@";"]) {
                NSArray *telArray=[_companyInfoModel.info.contactNumber componentsSeparatedByString:@";"];
                
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",telArray[0]]]];
            }
            else{
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_companyInfoModel.info.contactNumber]]];
            }
        }
    }
}

#pragma mark 更多联络信息点击事件
-(void)moreInfoBtnClick{
    if ([DDUtils isEmptyString:[DDUserManager sharedInstance].userid]) {//未登录
        DDLoginCheckVC * vc = [[DDLoginCheckVC alloc] init];
        vc.loginSuccessBlock = ^{
            [self requestCompanyData];
            DDCompanyMoreContractInfoVC *moreContractInfo=[[DDCompanyMoreContractInfoVC alloc]init];
            moreContractInfo.contactNumber=_companyInfoModel.info.contactNumber;
            moreContractInfo.address=_companyInfoModel.info.address;
            moreContractInfo.offcialWebsite=_companyInfoModel.info.offcialWebsite;
            moreContractInfo.email=_companyInfoModel.info.email;
            moreContractInfo.enterpriseName=_companyInfoModel.info.enterpriseName;
            [self.navigationController pushViewController:moreContractInfo animated:YES];
        };
        
        UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
        [DDNavigationUtil setNavigationAndBottomLineWhiteColor:nav];
        [self showViewController:nav sender:nil];
    }
    else{//已登录
        DDCompanyMoreContractInfoVC *moreContractInfo=[[DDCompanyMoreContractInfoVC alloc]init];
        moreContractInfo.contactNumber=_companyInfoModel.info.contactNumber;
        moreContractInfo.address=_companyInfoModel.info.address;
        moreContractInfo.offcialWebsite=_companyInfoModel.info.offcialWebsite;
        moreContractInfo.email=_companyInfoModel.info.email;
        moreContractInfo.enterpriseName=_companyInfoModel.info.enterpriseName;
        [self.navigationController pushViewController:moreContractInfo animated:YES];
    }
}

#pragma mark 点击证书有效期汇总,从企业证书点击进入
-(void)validSummaryClick1{
    if ([DDUtils isEmptyString:[DDUserManager sharedInstance].userid]) {//未登录
        DDLoginCheckVC * vc = [[DDLoginCheckVC alloc] init];
        vc.loginSuccessBlock = ^{
            [self requestCompanyData];
            DDValidTimeSummaryVC * vc = [[DDValidTimeSummaryVC alloc] init];
            //把企业id传过去
            vc.enterpriseId = _enterpriseId;
            vc.index=0;
            vc.isOpen = _companyInfoModel.open;
            [self.navigationController pushViewController:vc animated:YES];
        };
        
        UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
        [DDNavigationUtil setNavigationAndBottomLineWhiteColor:nav];
        [self showViewController:nav sender:nil];
    }
    else{//已登录
        DDValidTimeSummaryVC * vc = [[DDValidTimeSummaryVC alloc] init];
        //把企业id传过去
        vc.enterpriseId = _enterpriseId;
        vc.index=0;
        vc.isOpen = _companyInfoModel.open;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark 点击证书有效期汇总,从人员证书点击进入
-(void)validSummaryClick2{
    if ([DDUtils isEmptyString:[DDUserManager sharedInstance].userid]) {//未登录
        DDLoginCheckVC * vc = [[DDLoginCheckVC alloc] init];
        vc.loginSuccessBlock = ^{
            [self requestCompanyData];
            DDValidTimeSummaryVC * vc = [[DDValidTimeSummaryVC alloc] init];
            //把企业id传过去
            vc.enterpriseId = _enterpriseId;
            vc.index=1;
            vc.isOpen = _companyInfoModel.open;
            [self.navigationController pushViewController:vc animated:YES];
        };
        
        UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
        [DDNavigationUtil setNavigationAndBottomLineWhiteColor:nav];
        [self showViewController:nav sender:nil];
    }
    else{//已登录
        DDValidTimeSummaryVC * vc = [[DDValidTimeSummaryVC alloc] init];
        //把企业id传过去
        vc.enterpriseId = _enterpriseId;
        vc.index=1;
        vc.isOpen = _companyInfoModel.open;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark ***********************************业务分割线*************************************
#pragma mark 回首页
-(void)goBackClick{
    [self.navigationController popToRootViewControllerAnimated:NO];
    self.tabBarController.selectedIndex=0;
}

#pragma mark 中标监控点击事件（以前的关注）
-(void)focusClick{
    if ([DDUtils isEmptyString:[DDUserManager sharedInstance].userid]) {//未登录
        DDLoginCheckVC * vc = [[DDLoginCheckVC alloc] init];
        vc.loginSuccessBlock = ^{
            
 
        };
        
        UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
        [DDNavigationUtil setNavigationAndBottomLineWhiteColor:nav];
        [self showViewController:nav sender:nil];
    }
    else{//已登录
        if ([DDUtils isEmptyString:_companyInfoModel.attention]) {
            //直接关注(只关注中标);
            [self addCompanyConcernWithAttentionType:@"4"];
            
        }else{
            //之前关注过了
            //给个确认提示
            DDdeleteCompanyView * deleteCompanyView = [[[NSBundle mainBundle] loadNibNamed:@"DDdeleteCompanyView" owner:self options:nil] firstObject];
            deleteCompanyView.titleLab1.text = @"取消监控后,将不再收到该公司的中标动态提醒";
            deleteCompanyView.delegate = self;
            [deleteCompanyView show];
        }
    }
}

#pragma mark 信用报告点击事件
- (void)creditReportClick{
    if ([DDUtils isEmptyString:[DDUserManager sharedInstance].userid]) {//未登录
        DDLoginCheckVC * vc = [[DDLoginCheckVC alloc] init];
        vc.loginSuccessBlock = ^{
            
      
        };
        
        UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
        [DDNavigationUtil setNavigationAndBottomLineWhiteColor:nav];
        [self showViewController:nav sender:nil];
    }
    else{//已登录
        if ([DDUtils isEmptyString:_companyInfoModel.info.comprehensiveScore]) {
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message:@"信用评分目前只针对从事土木工程、建筑工程、线路管道设备安装工程的新建、扩建、改建等施工活动的有关单位和从业人员。\n该企业不在上述范围内，暂时无法评分下载信用报告，本公司将不断完善评分范围和评分规则，敬请期待！" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction * actionCancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertController addAction:actionCancel];
            [self presentViewController:alertController animated:YES completion:nil];
            return;
        }
        
        DDCreditReportVC *vc=[[DDCreditReportVC alloc]init];
        vc.email=_companyInfoModel.user_email;
        vc.enterpriseName=_companyInfoModel.info.enterpriseName;
        vc.enterpriseId=_companyInfoModel.info.enterpriseId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark 收藏点击事件
- (void)collectBtnClick{
    if ([DDUtils isEmptyString:[DDUserManager sharedInstance].userid]) {//未登录
        DDLoginCheckVC * vc = [[DDLoginCheckVC alloc] init];
        vc.loginSuccessBlock = ^{
            //发出登录成功通知
     
        };
        
        UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
        [DDNavigationUtil setNavigationAndBottomLineWhiteColor:nav];
        [self showViewController:nav sender:nil];
    }
    else{//已登录
        if ([DDUtils isEmptyString:_companyInfoModel.is_collect]) {
            //之前没有收藏
            [self sureCollectClick];
        }
//        else{
            //之前收藏过了
//            [self cancelCollectClick];
            
//        }
    }
}

#pragma mark 收藏之添加收藏
-(void)sureCollectClick{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [params setValue:_enterpriseId forKey:@"collectId"];
    [params setValue:@"4" forKey:@"collectType"];//1中标项目  2公司转让信息  3人员详情  4企业详情 5企业服务  6行业动态  7考试通知
    MBProgressHUD * hud = [DDUtils showHUDCustom:@""];
    [[DDHttpManager sharedInstance]sendPostRequest:KHttpRequest_saveMyCollection params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"**********企业详情的收藏***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            hud.mode = MBProgressHUDModeCustomView;
            hud.customView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"myinfo_saveSuccess"]];
            hud.labelText=@"已收藏";
            _companyInfoModel.is_collect = @"1000";
            
            hud.completionBlock= ^(){
                //发个通知
                [[NSNotificationCenter defaultCenter] postNotificationName:KBuyCompanyOrCannel object:nil];
            };
        }else if (response.code == 150){//已在其他端收藏过
            hud.mode = MBProgressHUDModeCustomView;
            hud.customView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"myinfo_saveSuccess"]];
            hud.labelText= @"你已经收藏过该条转让信息";
            hud.completionBlock= ^(){
                
                //发个通知
                //                [[NSNotificationCenter defaultCenter] postNotificationName:KBuyCompanyOrCannel object:nil];
            };
        }
        else{
            [DDUtils showToastWithMessage:response.message];
        }
        
        [self changeCollectImageViewStates];
        [hud hide:YES afterDelay:KHudShowTimeSecound];
    } failure:^(NSURLSessionDataTask *operation, id responseObject) {
        hud.labelText = kRequestFailed;
        [hud hide:YES afterDelay:KHudShowTimeSecound];
    }];
}

#pragma mark 纠错
-(void)mistakeClick{
    if ([DDUtils isEmptyString:[DDUserManager sharedInstance].userid]) {//未登录
        DDLoginCheckVC * vc = [[DDLoginCheckVC alloc] init];
        vc.loginSuccessBlock = ^{
            [self requestCompanyData];
            DDCorrectCompanyInfoVC * vc = [[DDCorrectCompanyInfoVC alloc]init];
            vc.passValueModel = _companyInfoModel;
            [self.navigationController pushViewController:vc animated:YES];
        };

        UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
        [DDNavigationUtil setNavigationAndBottomLineWhiteColor:nav];
        [self showViewController:nav sender:nil];
    }
    else{//已登录
        DDCorrectCompanyInfoVC * vc = [[DDCorrectCompanyInfoVC alloc]init];
        vc.passValueModel = _companyInfoModel;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark ***********************************业务分割线*************************************
#pragma mark DDdeleteCompanyViewDelegate 取消关注代理
//点击了确定
- (void)deleteCompanyViewClickSure:(DDdeleteCompanyView*)deleteCompanyView{
    [deleteCompanyView hide];
    [self deleteCompanyFocusWithModel:_companyInfoModel];
}

#pragma mark 取消关注
- (void)deleteCompanyFocusWithModel:(DDCompanyDetailModel1*)model{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:model.info.enterpriseId forKey:@"entId"];//企业id
    [params setValue:_companyInfoModel.attention forKey:@"attentionType"];// 1以上都关注   2企业证书  3人员证书   4中标业绩   5法律风险  6奖惩情况 7信用情况
   
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_myUaattentionDeleteById params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            MBProgressHUD *hud = [DDUtils showHUDCustom:@""];
            hud.mode = MBProgressHUDModeCustomView;
            hud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"myinfo_saveSuccess"]];
            hud.detailsLabelText = @"已取消监控";
            [hud hide:YES afterDelay:KHudShowTimeSecound];
            __weak __typeof(self) weakSelf=self;
            [weakSelf requestCompanyData];
            _companyInfoModel.attention = nil;
            [self changeAttentionImageAndText];
            
            //发个通知
            [[NSNotificationCenter defaultCenter] postNotificationName:KAddOrCancelAttention object:nil];
            
        }else{
             [DDUtils showToastWithMessage:response.message];
            
        }
       
        [_tableView reloadData];
    } failure:^(NSURLSessionDataTask *operation, id responseObject) {
         [DDUtils showToastWithMessage:kRequestFailed];
    }];
}

#pragma mark DDAddCompanyConcernViewDelegate代理方法
//选中的关注结果
- (void)addCompanyConcernViewdidSelectRowArray:(NSArray*)rowArray{
    NSString * attentionType = @"";
    for (NSString * rowStr in rowArray) {
        //1以上都关注   2企业证书  3人员证书   4中标业绩   5法律风险  6奖惩情况  7信用情况
        
        if ([rowStr isEqualToString:@"0"]) {//中标业绩
            attentionType = [attentionType stringByAppendingFormat:@"%@,",@"4"];
        }
        if ([rowStr isEqualToString:@"1"] ) {//企业证书
             attentionType = [attentionType stringByAppendingFormat:@"%@,",@"2"];
        }
        if ([rowStr isEqualToString:@"2"]) {//人员证书
             attentionType = [attentionType stringByAppendingFormat:@"%@,",@"3"];
        }
        if ([rowStr isEqualToString:@"3"]) {//风险信息
            attentionType = [attentionType stringByAppendingFormat:@"%@,",@"5"];
        }
        if ([rowStr isEqualToString:@"4"]) {//获奖荣誉
             attentionType = [attentionType stringByAppendingFormat:@"%@,",@"6"];
        }
        if ([rowStr isEqualToString:@"5"]) {//信用情况
             attentionType = [attentionType stringByAppendingFormat:@"%@,",@"7"];;
        }
        if ([rowStr isEqualToString:@"6"]) {//以上全部关注
             attentionType = [attentionType stringByAppendingFormat:@"%@,",@"1"];
        }
    }

    [self addCompanyConcernWithAttentionType:attentionType];
}

//加关注
- (void)addCompanyConcernWithAttentionType:(NSString*)attentionType{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:attentionType forKey:@"attentionType"];//1以上都关注   2企业证书  3人员证书   4中标业绩   5法律风险  6奖惩情况 7信用情况
    [params setValue:_companyInfoModel.info.enterpriseId forKey:@"entId"];//企业id

    [[DDHttpManager sharedInstance]sendPostRequest:KHttpRequest_uaAttentionSave params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            MBProgressHUD *hud =[DDUtils showHUDCustom:@""];
            hud.mode = MBProgressHUDModeCustomView;
            hud.customView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"myinfo_saveSuccess"]];
            hud.detailsLabelText = @"已监控";
            hud.userInteractionEnabled = NO;
            [hud hide:YES afterDelay:KHudShowTimeSecound];
             //关注成功后,改变数据源,改变底部图标
            if ([response.data isKindOfClass:[NSDictionary class]]) {
                DDAttentionSuccessModel * attentionSuccessModel = [[DDAttentionSuccessModel alloc] initWithDictionary:response.data error:nil];
                
                _companyInfoModel.attention = attentionSuccessModel.attentionType;
    
                [self changeAttentionImageAndText];
            }
            
            //发个通知
            [[NSNotificationCenter defaultCenter] postNotificationName:KAddOrCancelAttention object:nil];
        }else if (response.code == 150){//150表示在其他端已经收藏
            [DDUtils showToastWithMessage:@"你已经监控过该公司"];
            //关注成功后,改变数据源,改变底部图标
            if ([response.data isKindOfClass:[NSDictionary class]]) {
                DDAttentionSuccessModel * attentionSuccessModel = [[DDAttentionSuccessModel alloc] initWithDictionary:response.data error:nil];
                
                _companyInfoModel.attention = attentionSuccessModel.attentionType;
                
                [self changeAttentionImageAndText];
            }
            
            //发个通知
            [[NSNotificationCenter defaultCenter] postNotificationName:KAddOrCancelAttention object:nil];
        }
        else{
            [DDUtils showToastWithMessage:response.message];
        }
    } failure:^(NSURLSessionDataTask *operation, id responseObject) {
        [DDUtils showToastWithMessage:kRequestFailed];
    }];
}

#pragma mark 监听删除公司后的操作
- (void)delectCompanysuccessAction{
    [self requestCompanyData];
}

@end
