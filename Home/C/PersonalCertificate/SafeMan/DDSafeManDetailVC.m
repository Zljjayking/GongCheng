//
//  DDSafeManDetailVC.m
//  GongChengDD
//
//  Created by xzx on 2018/9/28.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDSafeManDetailVC.h"
#import "DataLoadingView.h"//加载页面
//#import "DDNoResult2View.h"//无数据视图
#import "DDSafeManDetailInfoModel.h"//model
#import "DDPersonalClaimBenefitVC.h"//认领页面
#import "DDCertiExplainVC.h"//申述页面

#import <UShareUI/UShareUI.h>//友盟分享
#import <MessageUI/MessageUI.h>//系统信息发送

@interface DDSafeManDetailVC ()<MFMessageComposeViewControllerDelegate>

{
    UIView *_titleView;
    UIButton *checkBtn;
}
@property (nonatomic,strong) DataLoadingView *loadingView;
//@property (nonatomic,strong) DDNoResult2View *noResultView;//无数据视图
@property (nonatomic,strong) DDSafeManDetailInfoModel *detailInfoModel;
@property (strong,nonatomic) MFMessageComposeViewController *messageController;
@end

@implementation DDSafeManDetailVC

-(void)viewWillDisappear:(BOOL)animated{
    [_titleView removeFromSuperview];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar addSubview:_titleView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=kColorBackGroundColor;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshData) name:KRefreshUI object:nil];//接收收到刷新页面的通知
    self.navigationItem.leftBarButtonItem=[DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
    self.navigationItem.rightBarButtonItem=[DDUtils rightbuttonItemWithImage:@"right_share" highlightedImage:@"right_share" target:self action:@selector(shareClick)];
    [self createLoadView];
    [self requestDetailInfo];
}
-(void)refreshData{
    [self requestDetailInfo];
//    checkBtn.userInteractionEnabled = NO;
//    [checkBtn setTitle:@"已认领" forState:UIControlStateNormal];
//    checkBtn.titleLabel.textColor=KColorOrangeSubTitle;
//    checkBtn.backgroundColor=KColorFDF5E9;
}
#pragma mark 分享点击
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
            _messageController.body = [NSString stringWithFormat:@"下载工程点点,查看人员证书信息、变更记录及个人工程业绩。http://m.koncendy.com/pages/StaffDetail/main?name=safety&id=%@&certId=%@",_staffInfoId,_certiId];
            
            // 设置收件人列表
            //            _messageController.recipients = @[@"13812345678"];
            // 设置代理
            _messageController.messageComposeDelegate = self;
            // 显示控制器
            [self presentViewController:_messageController animated:YES completion:nil];
        }else{
            UMShareWebpageObject * shareObject = [UMShareWebpageObject shareObjectWithTitle:self.titleStr descr:@"下载工程点点,查看人员证书信息、变更记录及个人工程业绩。" thumImage:[UIImage imageNamed:@"share_logo"]];
            
            //设置网页地址
            shareObject.webpageUrl =[NSString stringWithFormat:@"http://m.koncendy.com/pages/StaffDetail/main?name=safety&id=%@&certId=%@",_staffInfoId,_certiId];
            
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
- (void)cancelSendSMSClick{
    [_messageController dismissViewControllerAnimated:YES completion:nil];
}
//返回上一页面
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 创建加载视图
-(void)createLoadView{
    __weak __typeof(self) weakSelf=self;
//    _noResultView=[[DDNoResult2View alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-KNavigationBarHeight-45)];
//    [self.view addSubview:_noResultView];
    
    _loadingView = [[DataLoadingView alloc] initWithController:self];
    _loadingView.loadingTitle = KLoading;
    _loadingView.failureTitle = KLoadingFailure;
    _loadingView.reloadHandle = ^(void){
        [weakSelf requestDetailInfo];
    };
    [_loadingView showLoadingView];
}

#pragma mark 请求详情数据
-(void)requestDetailInfo{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:self.staffInfoId forKey:@"staffId"];
    [params setValue:self.certiId forKey:@"certId"];
    [params setValue:@"2" forKey:@"type"];
    
    __weak __typeof(self) weakSelf=self;
    [[DDHttpManager sharedInstance]sendPostRequest:KHttpRequest_bulderDetailInfo params:params success:^(NSURLSessionDataTask *operation, id responseObject){
        NSLog(@"**********安全员详情数据结果***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            [_loadingView hiddenLoadingView];
            
            weakSelf.detailInfoModel=[[DDSafeManDetailInfoModel alloc]initWithDictionary:responseObject[KData] error:nil];
            
            //标题
            NSString *certyType;
            if ([DDUtils isEmptyString:_detailInfoModel.certType]) {
                certyType=@"安全员";
            }
            else{
                certyType=[NSString stringWithFormat:@"安全员%@类",_detailInfoModel.certType];
            }
            CGRect frame1 = [_detailInfoModel.name boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:KfontSize34Bold} context:nil];
            CGRect frame2 = [certyType boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
            _titleView=[[UIView alloc]initWithFrame:CGRectMake((Screen_Width-(frame1.size.width+5+frame2.size.width))/2, 12, frame1.size.width+5+frame2.size.width, 20)];
            
            UILabel *lab1=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame1.size.width, 20)];
            lab1.text=_detailInfoModel.name;
            lab1.textColor=KColorCompanyTitleBalck;
            lab1.font=KfontSize34Bold;
            [_titleView addSubview:lab1];
            
            UILabel *lab2=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lab1.frame)+5, 0, frame2.size.width, 20)];
            lab2.text=certyType;
            lab2.textColor=KColorGreySubTitle;
            lab2.font=kFontSize30;
            [_titleView addSubview:lab2];
            
            [weakSelf.navigationController.navigationBar addSubview:_titleView];
            
            //weakSelf.title=_detailInfoModel.name;
            [self createScrollView];
        }
        else{
            [_loadingView failureLoadingView];
        }
        
    }  failure:^(NSURLSessionDataTask *operation, id responseObject)  {
        [DDUtils showToastWithMessage:kRequestFailed];
        [_loadingView failureLoadingView];
    }];
}

-(void)createScrollView{
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 145)];
    bgView.backgroundColor=kColorWhite;
    [self.view addSubview:bgView];
    
    CGRect typeLabFrame = [@"证书类别：" boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize28} context:nil];
    UILabel *typeLab1=[[UILabel alloc]initWithFrame:CGRectMake(12, 20, typeLabFrame.size.width, 15)];
    typeLab1.text=@"证书类别：";
    typeLab1.textColor=KColorGreySubTitle;
    typeLab1.font=kFontSize28;
    [bgView addSubview:typeLab1];

    UILabel *typeLab2=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(typeLab1.frame), 20, Screen_Width-24-typeLabFrame.size.width, 15)];
//    if ([DDUtils isEmptyString:_detailInfoModel.certType]) {
//        typeLab2.text=@"";
//    }
//    else{
//        typeLab2.text=[NSString stringWithFormat:@"%@类",_detailInfoModel.certType];
//    }
    typeLab2.text=_detailInfoModel.certType;
    typeLab2.textColor=KColorBlackSubTitle;
    typeLab2.font=kFontSize28;
    [bgView addSubview:typeLab2];
    
    
    
    CGRect numberLabFrame = [@"证书号：" boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize28} context:nil];
    UILabel *numberLab1=[[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(typeLab1.frame)+15, numberLabFrame.size.width, 15)];
    numberLab1.text=@"证书号：";
    numberLab1.textColor=KColorGreySubTitle;
    numberLab1.font=kFontSize28;
    [bgView addSubview:numberLab1];
    
    UILabel *numberLab2=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(numberLab1.frame), CGRectGetMaxY(typeLab1.frame)+15, Screen_Width-24-numberLabFrame.size.width, 15)];
    numberLab2.text=_detailInfoModel.certNo;
    numberLab2.textColor=KColorBlackSubTitle;
    numberLab2.font=kFontSize28;
    [bgView addSubview:numberLab2];
    
    
    
    CGRect statusLabFrame = [@"状态：" boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize28} context:nil];
    UILabel *statusLab1=[[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(numberLab1.frame)+15, statusLabFrame.size.width, 15)];
    statusLab1.text=@"状态：";
    statusLab1.textColor=KColorGreySubTitle;
    statusLab1.font=kFontSize28;
    [bgView addSubview:statusLab1];
    
    UILabel *statusLab2=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(statusLab1.frame), CGRectGetMaxY(numberLab1.frame)+15, Screen_Width-24-statusLabFrame.size.width, 15)];
    if ([_detailInfoModel.certStateSource isEqualToString:@"有效"]) {
        statusLab2.textColor=KColorBlackSubTitle;
    }
    else{
        statusLab2.textColor=kColorRed;
    }
    statusLab2.text=_detailInfoModel.certStateSource;
    statusLab2.font=kFontSize28;
    [bgView addSubview:statusLab2];
    
    CGRect validLabFrame = [@"有效期：" boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize28} context:nil];
    UILabel *validLab1=[[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(statusLab1.frame)+15, validLabFrame.size.width, 15)];
    validLab1.text=@"有效期：";
    validLab1.textColor=KColorGreySubTitle;
    validLab1.font=kFontSize28;
    [bgView addSubview:validLab1];
    
    UILabel *validLab2=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(validLab1.frame), CGRectGetMaxY(statusLab1.frame)+15, Screen_Width-24-validLabFrame.size.width, 15)];
    if (![DDUtils isEmptyString:_detailInfoModel.validityPeriodEnd]) {
        validLab2.text=_detailInfoModel.validityPeriodEnd;
        //timestr与当前时间相比,返回三种时间间隔的代号(0,1,2),0表示已过期，1表示90日之内，2表示超过90日
        NSString *resultStr = [DDUtils newCompareTimeSpaceIn90:_detailInfoModel.validityPeriodEnd];
        if ([resultStr isEqualToString:@"2"]) {
            validLab2.textColor=kColorBlue;
        }else if ([resultStr isEqualToString:@"1"]){
            validLab2.textColor=KColorTextOrange;
        } else{
            validLab2.textColor=kColorRed;
        }
    }
    else{
        validLab2.text = @"-";
    }
    validLab2.font=kFontSize28;
    [bgView addSubview:validLab2];
    
    checkBtn=[[UIButton alloc]initWithFrame:CGRectMake(Screen_Width-12-60, 145-20-30, 60, 30)];
    [checkBtn setTitle:@"认领" forState:UIControlStateNormal];
    checkBtn.titleLabel.font=kFontSize30;
    checkBtn.layer.cornerRadius=3;
    checkBtn.layer.masksToBounds=YES;
    [bgView addSubview:checkBtn];
    
    if ([DDUtils isEmptyString:_detailInfoModel.userId]) {
        if ([[DDUserManager sharedInstance].staffClaim integerValue]== 0) {//未认领
            [checkBtn setTitleColor:kColorBlue forState:UIControlStateNormal];
            [checkBtn setTitle:@"认领" forState:UIControlStateNormal];
            checkBtn.layer.borderWidth=1;
            checkBtn.layer.borderColor=kColorBlue.CGColor;
            checkBtn.backgroundColor=kColorWhite;
            checkBtn.userInteractionEnabled=YES;
            [checkBtn addTarget:self action:@selector(checkBtnClick) forControlEvents:UIControlEventTouchUpInside];
        }
        else{//已经认领
            checkBtn.layer.borderColor=KColorBgBlue.CGColor;
            checkBtn.backgroundColor=KColorBgBlue;
            [checkBtn setTitleColor:kColorBlue forState:UIControlStateNormal];
            [checkBtn setTitle:@"未认领" forState:UIControlStateNormal];
            checkBtn.userInteractionEnabled=NO;
        }
    }else{
        
        checkBtn.layer.borderColor=KColorCellBgOrange.CGColor;
        [checkBtn setTitleColor:KColorTextOrange forState:UIControlStateNormal];
        checkBtn.backgroundColor = KColorCellBgOrange;
        [checkBtn setTitle:@"已认领" forState:UIControlStateNormal];
        checkBtn.userInteractionEnabled=NO;
    }
}

-(void)checkBtnClick{
    DDPersonalClaimBenefitVC *vc=[[DDPersonalClaimBenefitVC alloc]init];
    vc.claimBenefitType = DDClaimBenefitTypeDefault;
    vc.peopleName = _detailInfoModel.name;
    vc.peopleId = _detailInfoModel.staffInfoId;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:KRefreshUI object:nil];
}
@end
