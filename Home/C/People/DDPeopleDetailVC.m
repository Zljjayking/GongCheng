//
//  DDPeopleDetailVC.m
//  GongChengDD
//
//  Created by xzx on 2018/5/25.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDPeopleDetailVC.h"
#import "DDNavigationUtil.h"
#import "DataLoadingView.h"
#import "NBLScrollTabController.h"//多页面滚动视图工具
#import "DDPeopleDetailModel.h"//model
#import "DDCompanyDetailVC.h"//公司详情页面
#import "DDPeopleBelongCertiVC.h"//证书页面
#import "DDPeopleBelongProjectVC.h"//个人业绩页面
#import "DDPeopleBelongPunishVC.h"//行政处罚页面
#import "DDPeopleBelongAccidentVC.h"//事故情况页面
#import "DDPeopleBelongAwardVC.h"//获奖荣誉页面
#import <UShareUI/UShareUI.h>//友盟分享
#import <MessageUI/MessageUI.h>
#import "DDPersonalClaimBenefitVC.h"//人员认领页面
#import "DDOpenContactWayVC.h"//公开联系方式设置页面
@interface DDPeopleDetailVC ()<NBLScrollTabControllerDelegate,MFMessageComposeViewControllerDelegate>

{
    DDPeopleDetailModel *_model;
    
    CGFloat _height;
    CGFloat _bottomHeight;
    
    UIButton *_openOrCancelContactBtn;//公开联系方式按钮或者取消公开按钮
    UIButton *_collectionBtn;//收藏和已收藏按钮
    UIButton *confirmBtn;
}
@property (nonatomic, strong) NBLScrollTabController *scrollTabController;
@property (nonatomic, strong) NSArray *viewControllers;
@property (strong,nonatomic) DataLoadingView *loadingView;
@property (strong,nonatomic)MFMessageComposeViewController *messageController;
@end

@implementation DDPeopleDetailVC

-(void)viewWillDisappear:(BOOL)animated{
    //还原导航底部线条颜色
    [DDNavigationUtil setNavigationBottomLineNomalColor:self.navigationController];
}

-(void)viewWillAppear:(BOOL)animated{
    //导航底部线条设为透明
    [DDNavigationUtil setNavigationBottomLineClearColor:self.navigationController];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshData) name:KRefreshUI object:nil];//接收收到刷新页面的通知
    [self editNavItem];
    [self setupDataLoadingView];
    [self requestBaseData];
}
-(void)refreshData{
  [self requestBaseData];
}
//定制导航条
-(void)editNavItem{
    self.view.backgroundColor=kColorBackGroundColor;
    self.navigationItem.leftBarButtonItem=[DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
    self.navigationItem.rightBarButtonItem=[DDUtils rightbuttonItemWithImage:@"right_share" highlightedImage:@"right_share" target:self action:@selector(shareClick)];
}

//返回上一页
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
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
            _messageController.body = [NSString stringWithFormat:@"%@的资料 下载工程点点APP，立即查看该人员作为法人、项目经理、建造师、安全员的背景资料 %@/?#/pages/PersonDetail/main?staffInfoId=%@",_model.name,DDBaseUrl,self.staffInfoId];
            // 设置收件人列表
            //            _messageController.recipients = @[@"13812345678"];
            // 设置代理
            _messageController.messageComposeDelegate = self;
            // 显示控制器
            [self presentViewController:_messageController animated:YES completion:nil];
        }else{
            //创建分享消息对象
            UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
            
            UMShareWebpageObject *shareObject;
            shareObject = [UMShareWebpageObject shareObjectWithTitle:[NSString stringWithFormat:@"%@的资料",_model.name] descr:@"下载工程点点APP，立即查看该人员作为法人、项目经理、建造师、安全员的背景资料" thumImage:[UIImage imageNamed:@"share_logo"]];
            
            //设置网页地址
            shareObject.webpageUrl =[NSString stringWithFormat:@"%@/?#/pages/PersonDetail/main?staffInfoId=%@",DDBaseUrl,self.staffInfoId];
            
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
        [weakSelf requestBaseData];
    };
    [_loadingView showLoadingView];
}

//请求人员基本信息
-(void)requestBaseData{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:self.staffInfoId forKey:@"staffInfoId"];
    
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_peopleDetailBaseInfo params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"***********人员基本信息数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {//请求成功
            [_loadingView hiddenLoadingView];
            _model=[[DDPeopleDetailModel alloc]initWithDictionary:responseObject[KData] error:nil];
            
            [self createPeopleBaseInfoView];
            [self createScrollView];
        }
        else{//显示异常
            //[DDUtils showToastWithMessage:response.message];
            [_loadingView failureLoadingView];
        }
        
    } failure:^(NSURLSessionDataTask *operation, id responseObject) {
        [DDUtils showToastWithMessage:kRequestFailed];
        [_loadingView failureLoadingView];
    }];
    
}

#pragma mark 人员认领点击事件
-(void)peopleConfirmClick{
    DDPersonalClaimBenefitVC *vc=[[DDPersonalClaimBenefitVC alloc]init];
    vc.claimBenefitType = DDClaimBenefitTypeDefault;
    vc.peopleName = _model.name;
    vc.peopleId = _model.staff_info_id;
    [self.navigationController pushViewController:vc animated:YES];
}

//创建人员基本信息视图
-(void)createPeopleBaseInfoView{
    UIView *baseInfoView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 144)];
    baseInfoView.backgroundColor=kColorWhite;
    [self.view addSubview:baseInfoView];
    
    UILabel *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(12, 15, Screen_Width-24-60-10, 25)];
    nameLab.text=_model.name;
    nameLab.textColor=KColorCompanyTitleBalck;
    nameLab.font=KFontSize50Bold;
    [baseInfoView addSubview:nameLab];
    
    if ([DDUtils isEmptyString:_model.user_id]) {
        if ([[DDUserManager sharedInstance].staffClaim integerValue]== 0) {//未认领
            
            confirmBtn=[[UIButton alloc]initWithFrame:CGRectMake(Screen_Width-12-60, 15, 60, 27)];
            [confirmBtn setTitle:@"认领" forState:UIControlStateNormal];
            [confirmBtn setTitleColor:KColorFindingPeopleBlue forState:UIControlStateNormal];
            [confirmBtn setBackgroundColor:kColorWhite];
            confirmBtn.titleLabel.font=kFontSize28;
            confirmBtn.layer.cornerRadius=3;
            confirmBtn.layer.borderColor=KColorFindingPeopleBlue.CGColor;
            confirmBtn.layer.borderWidth=0.5;
            [confirmBtn addTarget:self action:@selector(peopleConfirmClick) forControlEvents:UIControlEventTouchUpInside];
            [baseInfoView addSubview:confirmBtn];
        }
        else{//已经认领
            UILabel *confirmLab=[[UILabel alloc]initWithFrame:CGRectMake(Screen_Width-12-60, 15, 60, 27)];
            confirmLab.text=@"未认领";
            confirmLab.textColor=kColorBlue;
            confirmLab.backgroundColor=KColorBtnBgBlue;
            confirmLab.font=kFontSize28;
            confirmLab.layer.cornerRadius=3;
            confirmLab.textAlignment=NSTextAlignmentCenter;
            [baseInfoView addSubview:confirmLab];
        }
    }else{
        UILabel *confirmLab=[[UILabel alloc]initWithFrame:CGRectMake(Screen_Width-12-60, 15, 60, 27)];
        confirmLab.text=@"已认领";
        confirmLab.textColor=KColorOrangeSubTitle;
        confirmLab.backgroundColor=KColorFDF5E9;
        confirmLab.font=kFontSize28;
        confirmLab.layer.cornerRadius=3;
        confirmLab.textAlignment=NSTextAlignmentCenter;
        [baseInfoView addSubview:confirmLab];
    }

    UIView *btnsView=[[UIView alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(nameLab.frame)+15, Screen_Width-24, 20)];
    [self.view addSubview:btnsView];
    
    CGFloat X=0;//初始化X值
    CGFloat Y=0;//初始化Y值
    
    [btnsView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //法人：1,项目经理：2,建造师：3,三类人员：4
    /*
     1 法人',
     2 项目经理',
     3 建造师等级 (0,1,2,3)',
     4 安全员等级',
     5 建筑师等级',
     6 结构师等级',
     7 土木工程师',
     8 公用设备师',
     9 电气工程师',
     10 化工工程师',
     11 监理工程师',
     12 造价工程师',
     13 消防工程师',
     */
    for (DDRolesModel *rolesModel in _model.roles) {
        
        CGRect frame_W = [rolesModel.role boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
        
        CGFloat tempX=X+frame_W.size.width+16+10;
        
        if (tempX>Screen_Width-24) {
            X=0;
            Y=Y+20+10;
        }
        
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(X, Y, frame_W.size.width+16, 20)];
        label.text=rolesModel.role;
        label.font=kFontSize24;
        label.textAlignment=NSTextAlignmentCenter;
        label.layer.cornerRadius=3;
        label.clipsToBounds=YES;
        label.layer.borderWidth=0.5;
        
        if ([rolesModel.code isEqualToString:@"1"]) {//法人
            label.textColor=kColorBlue;
            label.layer.borderColor=kColorBlue.CGColor;
            label.backgroundColor=KColorBgBlue;
        }
        else if([rolesModel.code isEqualToString:@"2"]){//项目经理
            label.textColor=KColorTextOrange;
            label.layer.borderColor=KColorTextOrange.CGColor;
            label.backgroundColor=KColorBGOrange;
        }
        else if([rolesModel.code isEqualToString:@"3"]){//建造师
            label.textColor=KColorTextGreen;
            label.layer.borderColor=KColorTextGreen.CGColor;
            label.backgroundColor=KColorBGGreen;
        }
        else if([rolesModel.code isEqualToString:@"4"]){//三类人员
            label.textColor=KColorBlackSecondTitle;
            label.layer.borderColor=KColorBlackSecondTitle.CGColor;
            label.backgroundColor=KColorLinkBackViewColor;
        }
        else if([rolesModel.code isEqualToString:@"5"]){//建筑师
            label.textColor=KColorArchitect;
            label.layer.borderColor=KColorArchitect.CGColor;
            label.backgroundColor=KColorArchitectBg;
        }
        else if([rolesModel.code isEqualToString:@"6"]){//结构师
            label.textColor=KColorConstruct;
            label.layer.borderColor=KColorConstruct.CGColor;
            label.backgroundColor=KColorConstructBg;
        }
        else if([rolesModel.code isEqualToString:@"7"]){//土木工程师
            label.textColor=KColorCivil;
            label.layer.borderColor=KColorCivil.CGColor;
            label.backgroundColor=KColorCivilBg;
        }
        else if([rolesModel.code isEqualToString:@"8"]){//共用设备师
            label.textColor=KColorDevice;
            label.layer.borderColor=KColorDevice.CGColor;
            label.backgroundColor=KColorDeviceBg;
        }
        else if([rolesModel.code isEqualToString:@"9"]){//电气工程师
            label.textColor=KColorElectric;
            label.layer.borderColor=KColorElectric.CGColor;
            label.backgroundColor=KColorElectricBg;
        }
        else if([rolesModel.code isEqualToString:@"10"]){//化工工程师
            label.textColor=KColorChemical;
            label.layer.borderColor=KColorChemical.CGColor;
            label.backgroundColor=KColorChemicalBg;
        }
        else if([rolesModel.code isEqualToString:@"11"]){//监理工程师
            label.textColor=KColorSupervisor;
            label.layer.borderColor=KColorSupervisor.CGColor;
            label.backgroundColor=KColorSupervisorBg;
        }else if([rolesModel.code isEqualToString:@"12"]){//造价工程师
            label.textColor=KColorCost;
            label.layer.borderColor=KColorCost.CGColor;
            label.backgroundColor=KColorCostBg;
        }
        else if([rolesModel.code isEqualToString:@"13"]){//消防工程师
            label.textColor=KColorFire;
            label.layer.borderColor=KColorFire.CGColor;
            label.backgroundColor=KColorFireBg;
        }
        
        [btnsView addSubview:label];
        
        X=X+frame_W.size.width+16+10;
    }
    
    btnsView.frame=CGRectMake(12, CGRectGetMaxY(nameLab.frame)+15, Screen_Width-24, Y+20);
    
    baseInfoView.frame=CGRectMake(0, 0, Screen_Width, 144+15+Y+20);
    
    if (_model.roles.count) {
        _height=144+15+Y+20;
    }else {
        _height=135;
        baseInfoView.frame = CGRectMake(0, 0, Screen_Width, 135);
    }
    //公司名称
    UIButton *companyBtn=[[UIButton alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(btnsView.frame)+34, Screen_Width-24, 15)];
    if (_model.roles.count == 0) {
        companyBtn.frame = CGRectMake(12, CGRectGetMaxY(nameLab.frame)+34, Screen_Width-24, 15);
    }
    [baseInfoView addSubview:companyBtn];
    
    CGRect compNameWidth = [_model.enterprise_name boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize32} context:nil];
    UILabel *companyNameLab;
    if (compNameWidth.size.width>Screen_Width-24-15-2) {
        companyNameLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, Screen_Width-24-15-2, 15)];
    }
    else{
        companyNameLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, compNameWidth.size.width, 15)];
    }
    companyNameLab.text=_model.enterprise_name;
    companyNameLab.textColor=kColorBlack;
    companyNameLab.font=kFontSize32;
    [companyBtn addSubview:companyNameLab];
    
    UIImageView *companyArrow=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(companyNameLab.frame)+2, 0, 15, 15)];
    companyArrow.image=[UIImage imageNamed:@"home_people_arrow"];
    [companyBtn addSubview:companyArrow];
    
    [companyBtn addTarget:self action:@selector(companyDetailClick) forControlEvents:UIControlEventTouchUpInside];
    
    //地址
    NSString *addressStr;
    if ([DDUtils isEmptyString:_model.address]) {
        addressStr=@"地址:";
    }
    else{
        addressStr=[NSString stringWithFormat:@"地址:%@",_model.address];
    }
    CGRect addressWidth = [addressStr boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize28} context:nil];
    UILabel *addressLab;
    if (addressWidth.size.width>(Screen_Width-24-20)/5*3) {
        addressLab=[[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(companyBtn.frame)+15, (Screen_Width-24-20)/5*3, 15)];
    }
    else{
        addressLab=[[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(companyBtn.frame)+15, addressWidth.size.width, 15)];
    }
    addressLab.text=addressStr;
    addressLab.textColor=KColorBlackSubTitle;
    addressLab.font=kFontSize28;
    [baseInfoView addSubview:addressLab];
    
    //法定代表人
    NSString *representStr;
    if ([DDUtils isEmptyString:_model.legal_representative]) {
        representStr=@"法定代表人:";
    }
    else{
        representStr=[NSString stringWithFormat:@"法定代表人:%@",_model.legal_representative];
    }
    UILabel *representLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(addressLab.frame)+20, CGRectGetMaxY(companyBtn.frame)+15, Screen_Width-24-20-addressLab.size.width, 15)];
    representLab.text=representStr;
    representLab.textColor=KColorBlackSubTitle;
    representLab.font=kFontSize28;
    [baseInfoView addSubview:representLab];
}

//跳转到公司详情页
-(void)companyDetailClick{
    DDCompanyDetailVC *companyDetail=[[DDCompanyDetailVC alloc]init];
    companyDetail.enterpriseId=_model.enterprise_id;
    [self.navigationController pushViewController:companyDetail animated:YES];
}

//创建滚动视图
-(void)createScrollView{
    if ([self.isFromMyCerti isEqualToString:@"1"]) {//表示从我的证书跳转过来的
        //创建底部按钮
        UIView *bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, Screen_Height-KNavigationBarHeight-49, Screen_Width, 49)];
        bottomView.backgroundColor=kColorWhite;
        
        _openOrCancelContactBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 49)];
        if ([_model.isopen isEqualToString:@"1"]) {
            [_openOrCancelContactBtn setTitle:@"取消公开联系方式" forState:UIControlStateNormal];
            [_openOrCancelContactBtn setBackgroundColor:kColorWhite];
            [_openOrCancelContactBtn setTitleColor:KColorFindingPeopleBlue forState:UIControlStateNormal];
            [_openOrCancelContactBtn addTarget:self action:@selector(cancelContactWayClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        else{
            [_openOrCancelContactBtn setTitle:@"公开联系方式" forState:UIControlStateNormal];
            [_openOrCancelContactBtn setBackgroundColor:KColorFindingPeopleBlue];
            [_openOrCancelContactBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
            [_openOrCancelContactBtn addTarget:self action:@selector(openContactWayClick) forControlEvents:UIControlEventTouchUpInside];
        }
        _openOrCancelContactBtn.titleLabel.font=kFontSize32;
        [bottomView addSubview:_openOrCancelContactBtn];
        
        [self.view addSubview:bottomView];
        
        _bottomHeight=49;
    }
    else if([self.isFromCompanyDetail isEqualToString:@"1"]){//表示从企业详情跳转过来的
        _bottomHeight=0;
    }
    else{
        if (![DDUtils isEmptyString:_model.user_id] && [_model.user_id isEqualToString:[[DDUserManager sharedInstance] userid]]) {
            //创建底部按钮
            UIView *bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, Screen_Height-KNavigationBarHeight-49, Screen_Width, 49)];
            bottomView.backgroundColor=kColorWhite;
            
            UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 0.5)];
            lineV.backgroundColor = kColorNavBottomLineGray;
            [bottomView addSubview:lineV];
            
            _openOrCancelContactBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0.5, Screen_Width, 48.5)];
            if ([_model.isopen isEqualToString:@"1"]) {
                [_openOrCancelContactBtn setTitle:@"取消公开联系方式" forState:UIControlStateNormal];
                [_openOrCancelContactBtn setBackgroundColor:kColorWhite];
                [_openOrCancelContactBtn setTitleColor:KColorFindingPeopleBlue forState:UIControlStateNormal];
                [_openOrCancelContactBtn addTarget:self action:@selector(cancelContactWayClick:) forControlEvents:UIControlEventTouchUpInside];
            }
            else{
                [_openOrCancelContactBtn setTitle:@"公开联系方式" forState:UIControlStateNormal];
                [_openOrCancelContactBtn setBackgroundColor:KColorFindingPeopleBlue];
                [_openOrCancelContactBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
                [_openOrCancelContactBtn addTarget:self action:@selector(openContactWayClick) forControlEvents:UIControlEventTouchUpInside];
            }
            _openOrCancelContactBtn.titleLabel.font=kFontSize32;
            [bottomView addSubview:_openOrCancelContactBtn];
            
            [self.view addSubview:bottomView];
            
            _bottomHeight=49;
        }
        else{
            //创建底部按钮
            UIView *bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, Screen_Height-KNavigationBarHeight-49, Screen_Width, 49)];
            bottomView.backgroundColor=kColorWhite;
            
            UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 0.5)];
            lineV.backgroundColor = kColorNavBottomLineGray;
            [bottomView addSubview:lineV];
            
            _collectionBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0.5, Screen_Width/2, 48.5)];
            if ([DDUtils isEmptyString:_model.is_collect]) {
                [_collectionBtn setTitle:@"收藏" forState:UIControlStateNormal];
                [_collectionBtn setTitleColor:KColorBlackTitle forState:UIControlStateNormal];
                [_collectionBtn addTarget:self action:@selector(collectClick) forControlEvents:UIControlEventTouchUpInside];
            }
            else{
                [_collectionBtn setTitle:@"已收藏" forState:UIControlStateNormal];
                [_collectionBtn setTitleColor:KColorGreySubTitle forState:UIControlStateNormal];
            }
            _collectionBtn.titleLabel.font=kFontSize32;
            [bottomView addSubview:_collectionBtn];
            
            UIButton *contactBtn=[[UIButton alloc]initWithFrame:CGRectMake(Screen_Width/2, 0.5, Screen_Width/2, 48.5)];
            [contactBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
            
            
            
            if (![DDUtils isEmptyString:_model.user_id] && [_model.isopen isEqualToString:@"1"]) {
                [contactBtn setTitle:@"联系他" forState:UIControlStateNormal];
                [contactBtn setBackgroundColor:KColorFindingPeopleBlue];
                [contactBtn addTarget:self action:@selector(contactClick) forControlEvents:UIControlEventTouchUpInside];
            }
            else{
                [contactBtn setTitle:@"电话未公开" forState:UIControlStateNormal];
                [contactBtn setBackgroundColor:KColorGreyLight];
            }
            contactBtn.titleLabel.font=kFontSize32;
            [bottomView addSubview:contactBtn];
            
            [self.view addSubview:bottomView];
            
            _bottomHeight=49;
        }
    }
    
    
    NBLScrollTabTheme * theme = [[NBLScrollTabTheme alloc] init];
    theme.indicatorViewColor = kColorBlue;
    theme.titleColor = KColorBlackTitle;
    //theme.highlightColor = KColorCompanyTitleBalck;
    theme.highlightColor = kColorBlue;
    theme.titleViewBGColor=kColorWhite;
    
    theme.titleFont=kFontSize30;
    
    _scrollTabController = [[NBLScrollTabController alloc] initWithTabTheme:theme andType:1];
    //_scrollTabController.view.frame = CGRectMake(0, 144+15, Screen_Width, Screen_Height-KNavigationBarHeight-144-15);
    _scrollTabController.view.frame = CGRectMake(0, _height+15, Screen_Width, Screen_Height-KNavigationBarHeight-_height-15-_bottomHeight);
    _scrollTabController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _scrollTabController.scrollView.scrollEnabled=NO;//禁止scrollView滑动
    _scrollTabController.delegate = self;
    _scrollTabController.viewControllers = self.viewControllers;
    [self.view addSubview:_scrollTabController.view];
    
    //UILabel *line=[[UILabel alloc]initWithFrame:CGRectMake(0, 144+15+45, Screen_Width, 1)];
    UILabel *line=[[UILabel alloc]initWithFrame:CGRectMake(0, _height+15+45, Screen_Width, 1)];
    line.backgroundColor=kColorNavBottomLineGray;
    line.alpha=0.5;
    [self.view addSubview:line];
}

- (NSArray *)viewControllers{
    if (!_viewControllers) {
        
        DDPeopleBelongCertiVC *vc1 = [[DDPeopleBelongCertiVC alloc] init];
        NBLScrollTabItem *item1 = [[NBLScrollTabItem alloc] init];
        if ([DDUtils isEmptyString:_model.cert_count]) {
            item1.title = @"证书";
        }
        else{
            item1.title = [NSString stringWithFormat:@"证书%@",_model.cert_count];
        }
        item1.hideBadge = YES;
        vc1.tabItem = item1;
        vc1.staffInfoId=self.staffInfoId;
        vc1.height=_height;
        vc1.bottomHeight=_bottomHeight;
        vc1.mainViewContoller = self;
        
        DDPeopleBelongProjectVC *vc2 = [[DDPeopleBelongProjectVC alloc] init];
        NBLScrollTabItem *item2 = [[NBLScrollTabItem alloc] init];
        if ([DDUtils isEmptyString:_model.project_count]) {
            item2.title = @"个人业绩";
        }
        else{
            item2.title = [NSString stringWithFormat:@"个人业绩%@",_model.project_count];
        }
        item2.hideBadge = YES;
        vc2.tabItem = item2;
        vc2.staffInfoId=self.staffInfoId;
        vc2.height=_height;
        vc2.bottomHeight=_bottomHeight;
        vc2.mainViewContoller = self;
        
        DDPeopleBelongPunishVC *vc3 = [[DDPeopleBelongPunishVC alloc] init];
        NBLScrollTabItem *item3 = [[NBLScrollTabItem alloc] init];
        if ([DDUtils isEmptyString:_model.punish_count]) {
            item3.title = @"行政处罚";
        }
        else{
            item3.title = [NSString stringWithFormat:@"行政处罚%@",_model.punish_count];
        }
        item3.hideBadge = YES;
        vc3.tabItem = item3;
        vc3.staffInfoId=self.staffInfoId;
        vc3.height=_height;
        vc3.bottomHeight=_bottomHeight;
        vc3.mainViewContoller = self;

        DDPeopleBelongAccidentVC *vc4 = [[DDPeopleBelongAccidentVC alloc] init];
        NBLScrollTabItem *item4 = [[NBLScrollTabItem alloc] init];
        if ([DDUtils isEmptyString:_model.accident_count]) {
            item4.title = @"事故情况";
        }
        else{
            item4.title = [NSString stringWithFormat:@"事故情况%@",_model.accident_count];
        }
        item4.hideBadge = YES;
        vc4.tabItem = item4;
        vc4.staffInfoId=self.staffInfoId;
        vc4.height=_height;
        vc4.bottomHeight=_bottomHeight;
        vc4.mainViewContoller = self;

        DDPeopleBelongAwardVC *vc5 = [[DDPeopleBelongAwardVC alloc] init];
        NBLScrollTabItem *item5 = [[NBLScrollTabItem alloc] init];
        if ([DDUtils isEmptyString:_model.reward_count]) {
            item5.title = @"获奖荣誉";
        }
        else{
            item5.title = [NSString stringWithFormat:@"获奖荣誉%@",_model.reward_count];
        }
        item5.hideBadge = YES;
        vc5.tabItem = item5;
        vc5.staffInfoId=self.staffInfoId;
        vc5.height=_height;
        vc5.bottomHeight=_bottomHeight;
        vc5.mainViewContoller = self;
        
        _viewControllers = @[vc1,vc2,vc3,vc4,vc5];
        //_viewControllers = @[vc1,vc2];
    }
    return _viewControllers;
}

#pragma mark - NBLScrollTabControllerDelegate
- (void)tabController:(NBLScrollTabController * __nonnull)tabController
didSelectViewController:(UIViewController * __nonnull)viewController{
    //业务逻辑处理
    NSLog(@"++++%@",viewController);
}

#pragma mark 收藏点击事件
-(void)collectClick{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [params setValue:_model.staff_info_id forKey:@"collectId"];
    [params setValue:@"3" forKey:@"collectType"];
    
    MBProgressHUD * hud = [DDUtils showHUDCustom:@""];
    [[DDHttpManager sharedInstance]sendPostRequest:KHttpRequest_saveMyCollection params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"**********人员详情的收藏***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            hud.mode = MBProgressHUDModeCustomView;
            hud.customView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cer_success"]];
            hud.labelText=@"已收藏";
            hud.completionBlock= ^(){
                //发个通知,
                [[NSNotificationCenter defaultCenter]postNotificationName:KCollectWinBiddOrCancel object:nil];
            };
            
            [_collectionBtn setTitle:@"已收藏" forState:UIControlStateNormal];
            [_collectionBtn setTitleColor:KColorGreySubTitle forState:UIControlStateNormal];
            _collectionBtn.userInteractionEnabled=NO;
        }
        else if (response.code == 150){//150表示PC端已经收藏过了
            hud.labelText = @"你已经收藏过该人员";
            hud.completionBlock= ^(){
                //发个通知,
                [[NSNotificationCenter defaultCenter]postNotificationName:KCollectWinBiddOrCancel object:nil];
            };
            
            [_collectionBtn setTitle:@"已收藏" forState:UIControlStateNormal];
            [_collectionBtn setTitleColor:KColorGreySubTitle forState:UIControlStateNormal];
            _collectionBtn.userInteractionEnabled=NO;
        }
        else{
            [DDUtils showToastWithMessage:response.message];
        }
        
        [hud hide:YES afterDelay:KHudShowTimeSecound];
    } failure:^(NSURLSessionDataTask *operation, id responseObject) {
        hud.labelText = kRequestFailed;
        [hud hide:YES afterDelay:KHudShowTimeSecound];
    }];
}

#pragma mark 联系他点击事件
-(void)contactClick{
    if ([DDUtils isEmptyString:_model.user_tel]) {
        [DDUtils showToastWithMessage:@"暂无联系电话！"];
    }
    else{
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_model.user_tel]]];
    }
}

#pragma mark 取消公开联系方式
-(void)cancelContactWayClick:(UIButton *)sender{
    if([sender.titleLabel.text isEqualToString:@"取消公开联系方式"]){
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message:@"确定取消公开联系方式" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        UIAlertAction * actionReStart = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
            [params setValue:_model.staff_info_id forKey:@"staffInfoId"];
            [params setValue:_model.user_tel forKey:@"tel"];
            [params setValue:@"2" forKey:@"isopen"];
            
            __weak __typeof(self) weakSelf=self;
            MBProgressHUD * hud = [DDUtils showHUDCustom:@""];
            [[DDHttpManager sharedInstance]sendPostRequest:KHttpRequest_changeStaffTel params:params success:^(NSURLSessionDataTask *operation, id responseObject){
                NSLog(@"***********取消公开联系方式请求数据***************%@",responseObject);
                DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
                [hud hide:YES];
                if (response.isSuccess) {
                    [DDUtils showToastWithMessage:@"取消成功"];
                    [_openOrCancelContactBtn setTitle:@"公开联系方式" forState:UIControlStateNormal];
                    [_openOrCancelContactBtn setBackgroundColor:KColorFindingPeopleBlue];
                    [_openOrCancelContactBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
                }
                else{
                    [DDUtils showToastWithMessage:response.message];
                }
                
                [hud hide:YES afterDelay:KHudShowTimeSecound];
            } failure:^(NSURLSessionDataTask *operation, id responseObject) {
                [DDUtils showToastWithMessage:kRequestFailed];
            }];
        }];
        
        [alertController addAction:actionCancel];
        [alertController addAction:actionReStart];
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        DDOpenContactWayVC *vc=[[DDOpenContactWayVC alloc]init];
        vc.staffInfoId=self.staffInfoId;
        vc.phoneStr = _model.user_tel;
        vc.openContactWayType = OpenContactWayTypeOther;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark 公开联系方式
-(void)openContactWayClick{
    DDOpenContactWayVC *vc=[[DDOpenContactWayVC alloc]init];
    vc.staffInfoId=self.staffInfoId;
    vc.openContactWayType = OpenContactWayTypeOther;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:KRefreshUI object:nil];
}

@end
