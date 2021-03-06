//
//  DDBuilderDetailInfoVC.m
//  GongChengDD
//
//  Created by xzx on 2018/12/1.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDBuilderDetailInfoVC.h"
#import "DataLoadingView.h"
#import "DDPersonalDetailInfoModel.h"//人员详情model
#import "NBLScrollTabController.h"//多页面滚动视图工具
#import "DDReceivedProjectsListVC.h"//承接项目页面
#import "DDBuilderChangeRecordVC.h"//变更记录页面
#import "DDReceivedProjectsHeaderView.h"//顶部头视图
#import "DDPersonalClaimBenefitVC.h"//认领页面
#import <UShareUI/UShareUI.h>//友盟分享
#import <MessageUI/MessageUI.h>//系统信息发送


@interface DDBuilderDetailInfoVC ()<NBLScrollTabControllerDelegate,DDReceivedProjectsHeaderViewDelegate,MFMessageComposeViewControllerDelegate>

{
    UIView *_titleView;
    NSInteger  _selectIndex;
}
@property (nonatomic,strong) DDReceivedProjectsHeaderView *topView;//顶部视图
@property (nonatomic, strong) DDPersonalDetailInfoModel *detailInfoModel;//人员详情信息model
@property (nonatomic, strong) NBLScrollTabController *scrollTabController;
@property (nonatomic, strong) NSArray *viewControllers;
@property (strong,nonatomic) MFMessageComposeViewController *messageController;
@property (strong,nonatomic) DataLoadingView *loadingView;

@end

@implementation DDBuilderDetailInfoVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:_titleView];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_titleView removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=kColorBackGroundColor;
    self.navigationItem.leftBarButtonItem=[DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
    
    //[self createScrollView];
    [self setupDataLoadingView];
    [self requestDetailInfo];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshData) name:KRefreshUI object:nil];//接收收到刷新页面的通知
}

-(void)refreshData{
    [self requestDetailInfo];
}

- (void)setupDataLoadingView{
    __weak __typeof(self) weakSelf=self;
    _loadingView = [[DataLoadingView alloc] initWithController:self];
    _loadingView.loadingTitle = KLoading;
    _loadingView.failureTitle = KLoadingFailure;
    _loadingView.reloadHandle = ^(void){
        [weakSelf requestDetailInfo];
    };
    [_loadingView showLoadingView];
}
#pragma mark 返回上一页面
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
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
            _messageController.body = [NSString stringWithFormat:@"下载工程点点,查看人员证书信息、变更记录及个人工程业绩。http://m.koncendy.com/pages/StaffDetail/main?specialityCode=%@&name=%@&id=%@",_specialityCode,_nameStr,_staffInfoId];
            
            // 设置收件人列表
            //            _messageController.recipients = @[@"13812345678"];
            // 设置代理
            _messageController.messageComposeDelegate = self;
            // 显示控制器
            [self presentViewController:_messageController animated:YES completion:nil];
        }else{
            UMShareWebpageObject * shareObject = [UMShareWebpageObject shareObjectWithTitle:self.titleStr descr:@"下载工程点点,查看人员证书信息、变更记录及个人工程业绩。" thumImage:[UIImage imageNamed:@"share_logo"]];
            
            //设置网页地址
            shareObject.webpageUrl =[NSString stringWithFormat:@"http://m.koncendy.com/pages/StaffDetail/main?specialityCode=%@&name=%@&id=%@",_specialityCode,_nameStr,_staffInfoId];
            
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

//创建顶部View
- (void)createTopView{
    self.navigationItem.rightBarButtonItem=[DDUtils rightbuttonItemWithImage:@"right_share" highlightedImage:@"right_share" target:self action:@selector(shareClick)];
    UIView * bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(0, 0, Screen_Width, 175);
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    _topView = [[[NSBundle mainBundle] loadNibNamed:@"DDReceivedProjectsHeaderView" owner:self options:nil] firstObject];
    _topView.frame = CGRectMake(0,0, Screen_Width, 175);
    _topView.delegate = self;
    [bgView addSubview:_topView];
}

#pragma mark 请求详情数据
-(void)requestDetailInfo{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:self.staffInfoId forKey:@"staffId"];
    [params setValue:self.type forKey:@"type"];
    [params setValue:self.specialityCode forKey:@"specialityCode"];
    __weak __typeof(self) weakSelf=self;
    [[DDHttpManager sharedInstance]sendPostRequest:KHttpRequest_bulderDetailInfo params:params success:^(NSURLSessionDataTask *operation, id responseObject){
        NSLog(@"**********建造师详情数据结果***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            [_loadingView hiddenLoadingView];
            [weakSelf createTopView];
            weakSelf.detailInfoModel=[[DDPersonalDetailInfoModel alloc]initWithDictionary:responseObject[KData] error:nil];
            
            [weakSelf createScrollView];
          
            //标题
            NSString *subTitleStr;
            if ([weakSelf.type isEqualToString:@"0"]) {
                subTitleStr=@"一级建造师";
            }
            else{
                subTitleStr=@"二级建造师";
            }
            CGRect frame1 = [_detailInfoModel.name boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:KfontSize34Bold} context:nil];
            CGRect frame2 = [subTitleStr boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
            _titleView=[[UIView alloc]initWithFrame:CGRectMake((Screen_Width-(frame1.size.width+5+frame2.size.width))/2, 12, frame1.size.width+5+frame2.size.width, 20)];
            
            UILabel *lab1=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame1.size.width, 20)];
            lab1.text=_detailInfoModel.name;
            lab1.textColor=KColorCompanyTitleBalck;
            lab1.font=KfontSize34Bold;
            [_titleView addSubview:lab1];
            
            UILabel *lab2=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lab1.frame)+5, 0, frame2.size.width, 20)];
            lab2.text=subTitleStr;
            lab2.textColor=KColorGreySubTitle;
            lab2.font=kFontSize30;
            [_titleView addSubview:lab2];
            [weakSelf.navigationController.navigationBar addSubview:_titleView];
            [weakSelf.topView loadDataWithModel:_detailInfoModel];
        }
        else{
            [DDUtils showToastWithMessage:response.message];
            [_loadingView failureLoadingView];
        }
        
    }  failure:^(NSURLSessionDataTask *operation, id responseObject)  {
        [DDUtils showToastWithMessage:kRequestFailed];
        [_loadingView failureLoadingView];
    }];
}

//创建滚动视图
-(void)createScrollView{
    NBLScrollTabTheme * theme = [[NBLScrollTabTheme alloc] init];
    theme.indicatorViewColor = KColorFindingPeopleBlue;
    theme.titleColor = KColorBlackTitle;
    theme.highlightColor = KColorFindingPeopleBlue;
    theme.titleViewBGColor=kColorWhite;
    theme.titleFont=kFontSize30;
    
    _scrollTabController = [[NBLScrollTabController alloc] initWithTabTheme:theme andType:1];
    _scrollTabController.viewControllers = self.viewControllers;
    _scrollTabController.view.frame = CGRectMake(0, 175+15, Screen_Width, Screen_Height);
    
    _scrollTabController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _scrollTabController.scrollView.scrollEnabled=NO;//禁止scrollView滑动
    _scrollTabController.delegate = self;
    
    [self.view addSubview:_scrollTabController.view];
    //设置选中第二个tabb
    [_scrollTabController updateSelectIndexWithIndex:_selectIndex];
    
    if ([self.type isEqualToString:@"1"]) {
        _scrollTabController.view.frame = CGRectMake(0, 175, Screen_Width, Screen_Height);
        
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 175, Screen_Width, 45)];
        titleView.backgroundColor = kColorBackGroundColor;
        [self.view addSubview:titleView];
        UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, Screen_Width-24, 45)];
        if ([DDUtils isEmptyString:_detailInfoModel.achievementNum]) {
            titleLb.text = @"承接项目";
        }
        else{
            titleLb.text = [NSString stringWithFormat:@"承接项目(%@)",_detailInfoModel.achievementNum];
        }
        titleLb.textColor = kColorGrey;
        titleLb.font = kFontSize30;
        [titleView addSubview:titleLb];
    }
}

#pragma mark - 从外部选择过来
- (void)changeSelectIndex
{
    _selectIndex = 1;
}

- (NSArray *)viewControllers{
    if (!_viewControllers) {
        if ([self.type isEqualToString:@"1"]) {
            DDReceivedProjectsListVC *vc1 = [[DDReceivedProjectsListVC alloc] init];
            NBLScrollTabItem *item1 = [[NBLScrollTabItem alloc] init];
            if ([DDUtils isEmptyString:_detailInfoModel.achievementNum]) {
                item1.title = @"承接项目";
            }
            else{
                item1.title = [NSString stringWithFormat:@"承接项目%@",_detailInfoModel.achievementNum];
            }
            item1.hideBadge = YES;
            vc1.tabItem = item1;
            vc1.staffInfoId=self.staffInfoId;
            vc1.type=self.type;
            vc1.specialityCode=self.specialityCode;
            vc1.mainViewContoller = self;
            _viewControllers = @[vc1];
        }
        else{
            DDReceivedProjectsListVC *vc1 = [[DDReceivedProjectsListVC alloc] init];
            NBLScrollTabItem *item1 = [[NBLScrollTabItem alloc] init];
            if ([DDUtils isEmptyString:_detailInfoModel.achievementNum]) {
                item1.title = @"承接项目";
            }
            else{
                item1.title = [NSString stringWithFormat:@"承接项目%@",_detailInfoModel.achievementNum];
            }
            item1.hideBadge = YES;
            vc1.tabItem = item1;
            vc1.staffInfoId=self.staffInfoId;
            vc1.type=self.type;
            vc1.specialityCode=self.specialityCode;
            vc1.mainViewContoller = self;
            
            DDBuilderChangeRecordVC *vc2 = [[DDBuilderChangeRecordVC alloc] init];
            NBLScrollTabItem *item2 = [[NBLScrollTabItem alloc] init];
            if ([DDUtils isEmptyString:_detailInfoModel.changeNum]) {
                item2.title = @"变更记录";
            }
            else{
                item2.title = [NSString stringWithFormat:@"变更记录%@",_detailInfoModel.changeNum];
            }
            item2.hideBadge = YES;
            vc2.tabItem = item2;
            vc1.staffInfoId=self.staffInfoId;
            vc2.staffId = self.staffInfoId;
            if ([self.type isEqualToString:@"0"]) {
                vc1.type=@"1";
                vc2.type=@"1";
            }
            else{
                vc1.type=@"2";
                vc2.type=@"2";
            }
            vc2.mainViewContoller = self;
            _viewControllers = @[vc1,vc2];
        }
    }
    return _viewControllers;
}
#pragma mark MFMessageComposeViewControllerDelegate代理方法
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    // 关闭短信界面
    [controller dismissViewControllerAnimated:YES completion:nil];
    if(result == MessageComposeResultCancelled) {
        NSLog(@"取消发送");
    }
    else if(result == MessageComposeResultSent) {
        NSLog(@"发送成功");
    }
    else {
        NSLog(@"发送失败");
    }
}

- (void)cancelSendSMSClick{
    [_messageController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - NBLScrollTabControllerDelegate
- (void)tabController:(NBLScrollTabController * __nonnull)tabController
didSelectViewController:(UIViewController * __nonnull)viewController{
    //业务逻辑处理
    NSLog(@"++++%@",viewController);
}

#pragma mark DDReceivedProjectsHeaderViewDelegate
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
