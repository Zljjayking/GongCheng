//
//  DDHomeVC.m
//  GongChengDD
//
//  Created by csq on 2018/5/8.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDHomeVC.h"
#import "DDLabelUtil.h"
#import "MJRefresh.h"
#import "DDRefreshHeader.h"
#import "DDNavigationUtil.h"
#import "DDLoginCheckVC.h"//登录注册页面
#import "DDQRCodeScanVC.h"//扫描二维码页面
#import "SGAdvertScrollView.h"//新的轮播图
#import "DDIndustryNews1Cell.h"//第一种tableView的cell
#import "DDIndustryNews2Cell.h"//第二种tableView的cell
#import "DDIndustryNews3Cell.h"//第三种tableView的cell
#import "DDIndustryNews4Cell.h"//第四种tableView的cell
#import "DDAllSearchVC.h"//公共搜索页面
#import "DDHotSearchModel.h"//热搜词条model
#import "DDAllTypesVC.h"//全部分类页面
#import "DDAllTypesCell.h"//集合视图的cell
#import "DDAllTypesModel.h"//首页类别model
#import "DDBannerPicturesModel.h"//首页Banner图model
#import "DDCompanyDetailVC.h"//公司详情页面

#import "DDSearchBuyCompanyListVC.h"//买公司搜索页面
#import "DDIndustryDynamicListModel.h"//行业动态model
#import <iflyMSC/iflyMSC.h>
#import "DDGlobalListVC.h"//全局搜索页面
#import "DDIndustryDynamicDetailVC.h"//行业动态详情页面
#import "DDExamineTrainingVC.h"//考试培训页面
#import "DDCheckAppVerModel.h"
#import "DDProjectCheckOriginWebVC.h"//借用webView页面，展示Banner图点击跳转的网页
#import "DDOpenNotificationView.h"//弹出开启通知服务的对话框
#import "DDNearCompanyVC.h"//附近公司
#import "DDRemindOpenNotiView.h"
#import <BMKLocationkit/BMKLocationComponent.h>//百度地图定位

#import "DDMyCertificateVC.h"//我的证书页面
#import "DDProjectSubscribeBenefitVC.h"//中标监控好处页面
#import "DDProjectSubscribeVC.h"//中标监控页面
#import "DDTalentSubscribeDetailModel.h"//人才订阅详情信息model

#import "DDMySuperVisionDynamicListModel.h"//model
#import "DDMySuperVisionDynamicList1Cell.h"//cell
#import "DDMySuperVisionDynamicList2Cell.h"//cell

#import "DDMyMonitorLoopsListModel.h"//监控轮播数据model
#import "DDCompanyClaimBenefitVC.h"//公司认领的好处页面
#import "DDPersonalClaimBenefitVC.h"//证书认领的好处页面
#import "DDNewsJumpManager.h"//消息和监控跳转控制类

#import <UShareUI/UShareUI.h>//友盟分享
#import <MessageUI/MessageUI.h>

#import "DDMyEnterpriseVC.h"//已认领公司列表
#import "DDServiceWebViewVC.h"
#import "DDTabBarController.h"
#import "UITabBar+Badge.h"
#import "DDSearchHistoryDAOAndDB.h"

#import "DDLabelUtil.h"
#define topViewHeight KNavigationBarHeight+129
#define scrollLineWidth 21
#define scrollLineHeight 2
@interface DDHomeVC ()<UITableViewDataSource,UITableViewDelegate,SGAdvertScrollViewDelegate,IFlyRecognizerViewDelegate,UITabBarControllerDelegate,BMKLocationManagerDelegate,MFMessageComposeViewControllerDelegate>

{
    NSInteger updateNumCount;
    NSInteger currentPage;
    NSInteger pageCount;
    NSMutableArray *_dataSourceArr;
    NSMutableDictionary *_dict;
    
    NSMutableArray *_hotWordsArr;//存放请求到的所有热搜词条
    NSMutableArray *_showedHotWordsArr;
    NSMutableArray *_bannerPicturesArr;//存放首页请求到的banner图数据
    UIImageView *_topImage;
    UIImageView *_newTopImgView;
    UIView *_bgView1;
    UIView *_bgView3;
    UIView *_tipsView;//放置热搜词的View

    UILabel *_dot1;
    UILabel *_dot2;
    UILabel *_updateNumL;
    UIScrollView *_horizonScrollView;
    UIView *_firstView;
    UIView *_secondView;
    UIView *_applicationView;
    
    NSString *_region;//定位出来的市
    UIButton *_dynamicBtn;//行业动态按钮
    UIButton *_myVisionBtn;//我的监控按钮
    UILabel *_scrollLine;//行业动态和我的监控下面的小横线
    
    NSString *_isIndustryClick;//1表示行业动态被点击，2表示我的监控被点击
    
    NSString *_newsUnread;//消息未读数量
    NSString *_monitorUnread;//我的监控未读数量
    NSMutableArray *_monitorLoopsArr;//存放监控轮播数据
    
    UILabel *_numLab;//我的监控小红点
    
    UILabel *_unLogLab;
    UIButton *_logBtn;
    MBProgressHUD * _hud;
    BOOL isLastData;
    BOOL isShowUpdate;
}

@property (nonatomic, assign) BOOL hotSearchChanged;

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,assign) CGFloat offset;
@property (nonatomic,assign) CGFloat yy;
@property (nonatomic,strong) UIView *bigHeaderView;
@property (nonatomic,strong) BMKLocationManager * baiduLocationManager;//百度定位
@property (strong,nonatomic) MFMessageComposeViewController *messageController;
@property(nonatomic,strong) NSMutableArray *dataSourceArray;
@property (nonatomic,strong) NSMutableArray *requestUrlArray;//正在请求的url数组
@property (nonatomic, assign) CGFloat topViewH;//头部视图的高度
@end
@implementation DDHomeVC
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
- (void)viewWillAppear:(BOOL)animated{
    //self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.translucent = YES;
    //设置导航栏背景图片为一个空的image，这样就透明了
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    if (_yy>self.offset) {
        if (_yy>=0) {
            _bgView3.hidden = NO;
        }
    }
    [self requestMyVisionNum];//我的监控的数量(登录了再请求)
}

- (void)viewWillDisappear:(BOOL)animated{
    if (_yy>self.offset) {
        if (_yy>=0) {
            _bgView3.hidden = YES;
        }
    }
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBar.translucent = NO;
    //如果不想让其他页面的导航栏变为透明 需要重置
    [DDNavigationUtil setNavigationBottomLineNomalColor:self.navigationController];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _newsUnread=@"0";
    _isIndustryClick=@"1";
    _hotSearchChanged = YES;
    self.view.backgroundColor=kColorBackGroundColor;
    _dataSourceArr=[[NSMutableArray alloc]init];
    _hotWordsArr=[[NSMutableArray alloc]init];//初始化存放热搜词条的数组
    _showedHotWordsArr=[[NSMutableArray alloc]init];
    _bannerPicturesArr=[[NSMutableArray alloc]init];
    _monitorLoopsArr=[[NSMutableArray alloc]init];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadSuccessAction) name:KLoginSuccessNotification object:nil];//接收登录成功的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveMyVisionAction) name:KMyVisionRedPointNotification object:nil];//接收收到监控消息的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(itemAction:) name:@"ItemDidClickNotification" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(itemReAction:) name:@"ItemReDidClickNotification" object:nil];
    //监听退出登录
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logOutAction:) name:KLogOutNotification object:nil];
    self.tabBarController.delegate = self;
    [self checkNewVersion];//版本更新
    [self locationInfoAction];//位置信息相关操作
    [self startLocation];//开始定位
    [self createTableView];
    [self editTopView];
    [self createNavSearchBtn];
    [self createBigHeaderView];
    [self requestNewsData];//轮播监控的消息(登录了再请求)
//    [self initReachability];//初始化网络状态判断类
    
    //业务逻辑处理
    UITabBarItem *item1 = [self.tabBarController.tabBar.items objectAtIndex:1];
    item1.image = [[UIImage imageNamed:@"tab_find_gray"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    item1.selectedImage = [[UIImage imageNamed:@"tab_find_blue"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item1.title = @"查找";
    
    //业务逻辑处理
    UITabBarItem *item2 = [self.tabBarController.tabBar.items objectAtIndex:2];
    item2.image = [[UIImage imageNamed:@"tab_service_gray"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    item2.selectedImage = [[UIImage imageNamed:@"tab_service_blue"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item2.title = @"服务";
    
    //业务逻辑处理
    UITabBarItem *item3 = [self.tabBarController.tabBar.items objectAtIndex:3];
    item3.image = [[UIImage imageNamed:@"tab_my_gray"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    item3.selectedImage = [[UIImage imageNamed:@"tab_my_blue"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item3.title = @"我的";
    
}

-(void)logOutAction:(NSNotification*)notification{
    _newsUnread = @"0";
    _monitorUnread = @"0";
    [_monitorLoopsArr removeAllObjects];
    [self createBigHeaderView];
    [self layoutHotWordsBtns];
     [_dataSourceArray removeAllObjects];
     [_dataSourceArr removeAllObjects];
    if ([_isIndustryClick isEqualToString:@"2"]) {
        _tableView.mj_footer.hidden=YES;
        _tableView.mj_header.automaticallyChangeAlpha = YES;
       
        _unLogLab=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_bigHeaderView.frame)+33, Screen_Width, 15)];
        _unLogLab.text=@"你还没有登录，登录后可查看监控动态";
        _unLogLab.font=kFontSize30;
        _unLogLab.textColor=KColorBlackSecondTitle;
        _unLogLab.textAlignment=NSTextAlignmentCenter;
        [_tableView addSubview:_unLogLab];
        
        _logBtn=[[UIButton alloc]initWithFrame:CGRectMake((Screen_Width-94)/2, CGRectGetMaxY(_unLogLab.frame)+33, 94, 40)];
        [_logBtn setTitle:@"去登录" forState:UIControlStateNormal];
        [_logBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
        _logBtn.titleLabel.font=kFontSize28;
        [_logBtn setBackgroundColor:KColorFindingPeopleBlue];
        _logBtn.layer.cornerRadius=3;
        _logBtn.clipsToBounds=YES;
        [_logBtn addTarget:self action:@selector(presentLoginVC) forControlEvents:UIControlEventTouchUpInside];
        [_tableView addSubview:_logBtn];
    }else{
        [self requestIndustryData:YES];
    }
    [_tableView reloadData];
}

#pragma mark 登录成功收到通知
-(void)loadSuccessAction{
    if ([_isIndustryClick isEqualToString:@"2"]) {
        _isIndustryClick = @"1";
        [self mySuperVisionClick];
    }
    [self requestNewsData];
}
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    UITabBarItem *item = [self.tabBarController.tabBar.items objectAtIndex:0];
    item.image = [[UIImage imageNamed:@"tab_home_gray"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    item.selectedImage = [[UIImage imageNamed:@"tab_home_blue"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item.title = @"查询";

    UITabBarItem *item1 = [self.tabBarController.tabBar.items objectAtIndex:1];
    item1.image = [[UIImage imageNamed:@"tab_find_gray"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    item1.selectedImage = [[UIImage imageNamed:@"tab_find_blue"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item1.title = @"查找";
    return YES;
}
#pragma mark 收到监控消息的通知处理
-(void)receiveMyVisionAction{
    if ([_isIndustryClick isEqualToString:@"1"]) {//请求行业动态数据
    
    }
    else{
        [self requestMyVisionData:YES];//刷新我的监控列表
       
    }
    [self requestMyVisionNum];//我的监控的数量(登录了再请求)
    [self requestNewsData];//轮播监控的消息(登录了再请求)
}

#pragma mark 定位相关操作
- (void)locationInfoAction{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status){
        //定位不能用
        _region = @"南京市";
    } else {
        //定位功能可用
        DDUserManager * userManger = [DDUserManager sharedInstance];
        if (NO == [DDUtils isEmptyString:userManger.city]) {
            //如果保存有定位到的市,使用"市"
            _region = userManger.city;
            
        }else if (YES == [DDUtils isEmptyString:userManger.province] && NO == [DDUtils isEmptyString:userManger.city]){
            //如果是直辖市,使用"市"
            _region = userManger.city;
            
        }else{
            //都没有的话,默认江苏省
            _region = @"南京市";
        }
    }
}

#pragma mark 判断是否开启了通知
-(void)judgeOpenNotification{
    UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
    if (setting.types == UIUserNotificationTypeNone) {//关闭了通知
        DDRemindOpenNotiView * remindOpenNotinView = [[[NSBundle mainBundle]loadNibNamed:@"DDRemindOpenNotiView" owner:self options:nil] firstObject];
        [remindOpenNotinView show];
    }
}

#pragma mark 点击马上开启跳转到系统设置
-(void)actionsheetDisappear:(DDOpenNotificationView *)actionSheet{
    UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
    if (setting.types == UIUserNotificationTypeNone) {//关闭了通知
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
    else{
        [DDUtils showToastWithMessage:@"您已开启消息推送通知"];
    }
}

#pragma mark 页面顶部的一大块的内容（页面未上滑时）
-(void)editTopView{
    //蓝色的背景图片
    _topImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, topViewHeight)];
    _topImage.image=[UIImage imageNamed:@"home_topbg4"];
    [self.view addSubview:_topImage];
    _topImage.userInteractionEnabled=YES;
    
    //搜索框那一块
    _bgView1=[[UIView alloc]initWithFrame:CGRectMake(12, topViewHeight-47, Screen_Width-24, 47)];
    _bgView1.backgroundColor=kColorWhite;
    _bgView1.layer.cornerRadius=5;
    _bgView1.clipsToBounds=YES;
    [_topImage addSubview:_bgView1];
    
    //搜索放大镜
    UIImageView *searchMirror=[[UIImageView alloc]initWithFrame:CGRectMake(10, 17, 13, 13)];
    searchMirror.image=[UIImage imageNamed:@"home_search"];
    [_bgView1 addSubview:searchMirror];

    //搜索输入文本框
    UILabel *searchLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(searchMirror.frame)+10, 17, Screen_Width-20-13-66, 13)];
    searchLabel.text=@"企业名称、姓名、项目名称等";
    searchLabel.textColor=kColorGrey;
    searchLabel.font=kFontSize28;
    [_bgView1 addSubview:searchLabel];
    
    //文字搜索按钮
    UIButton *textSearchBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, _bgView1.size.width-66, 47)];
    [textSearchBtn addTarget:self action:@selector(textSearchClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgView1 addSubview:textSearchBtn];

    //语音搜索按钮
    UIButton *videoSearchBtn=[[UIButton alloc]initWithFrame:CGRectMake(_bgView1.frameWidth-66, 0, 28, 47)];
    [videoSearchBtn addTarget:self action:@selector(videoSearchClick) forControlEvents:UIControlEventTouchUpInside];
    [videoSearchBtn setImage:DDIMAGE(@"home_video") forState:UIControlStateNormal];
    [_bgView1 addSubview:videoSearchBtn];

    //扫一扫按钮
    UIButton *sacnBtn=[[UIButton alloc]initWithFrame:CGRectMake(_bgView1.frameWidth-38, 0, 33, 47)];
    [sacnBtn setImage:DDIMAGE(@"home_newQRCode") forState:UIControlStateNormal];
    [sacnBtn addTarget:self action:@selector(sacnButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView1 addSubview:sacnBtn];
    
    //新的顶部log和文字
    _newTopImgView=[[UIImageView alloc]initWithFrame:CGRectMake((Screen_Width-157)/2, CGRectGetMinY(_bgView1.frame)-38-44, 157, 44)];
    _newTopImgView.image=[UIImage imageNamed:@"home_newTopImg"];
    [_topImage addSubview:_newTopImgView];
}

#pragma mark 创建导航条搜索框(页面上滑时填充导航条)
-(void)createNavSearchBtn{
    _bgView3=[[UIView alloc]initWithFrame:CGRectMake(7, 7, Screen_Width-14, 30)];
    _bgView3.backgroundColor=kColorWhite;
    _bgView3.layer.cornerRadius=3;
    _bgView3.clipsToBounds=YES;
    
    UIImageView *searchMirror=[[UIImageView alloc]initWithFrame:CGRectMake(10, 8.5, 13, 13)];
    searchMirror.image=[UIImage imageNamed:@"home_search"];
    [_bgView3 addSubview:searchMirror];
    
    UILabel *searchLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(searchMirror.frame)+10, 8.5, Screen_Width-50-10-13-10, 13)];
    searchLabel.text=@"企业名称、姓名、项目名称等";
    searchLabel.textColor=KColorPlaceholderColor;
    searchLabel.font=kFontSize28;
    [_bgView3 addSubview:searchLabel];
    
    UIButton *textSearchBtn=[[UIButton alloc]initWithFrame:_bgView3.frame];
    [textSearchBtn addTarget:self action:@selector(textSearchClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgView3 addSubview:textSearchBtn];
}

#pragma mark 创建headerView(这个headerView有点大)
-(void)createBigHeaderView{
    [_bigHeaderView removeFromSuperview];
    CGFloat height = 0;
    if (_monitorLoopsArr.count == 0) {
        height = 0;
    }else{
        height = 73;
    }
    _bigHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 210.5+height)];
    _bigHeaderView.backgroundColor=kColorWhite;
    
    //************************换一换热搜词模块************************
    UIView *changeHotWordsBgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 52)];
    changeHotWordsBgView.backgroundColor=KColorTopBgBlue;
    
    UILabel *hotLable=[[UILabel alloc]initWithFrame:CGRectMake(12, 18, 40, 16)];
    hotLable.textColor=KColorHotChangeGray;
    hotLable.textAlignment = NSTextAlignmentLeft;
    hotLable.text=@"热搜:";
    hotLable.font=kFontSize26Bold;
    [hotLable sizeToFit];
    [changeHotWordsBgView addSubview:hotLable];
    
    //放置热搜词的View
    _tipsView=[[UIView alloc]initWithFrame:CGRectMake(22+hotLable.frameWidth, 0, Screen_Width-12-hotLable.frameWidth-10-10-50-10-13-10, 52)];
    [changeHotWordsBgView addSubview:_tipsView];
    
    UILabel *changeLabel=[[UILabel alloc]initWithFrame:CGRectMake(Screen_Width-12-45, 18, 45, 16)];
    changeLabel.textColor=KColorHotChangeGray;
    changeLabel.textAlignment = NSTextAlignmentRight;
    changeLabel.font=kFontSize26Bold;
    changeLabel.text=@"换一换";
    changeLabel.textAlignment=NSTextAlignmentRight;
    [changeHotWordsBgView addSubview:changeLabel];
    
    UIImageView *refresh=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(changeLabel.frame)-15, 19.5, 13, 13)];
    refresh.image=[UIImage imageNamed:@"home_refresh"];
    [changeHotWordsBgView addSubview:refresh];
    
    UIButton *changeBtn=[[UIButton alloc]initWithFrame:CGRectMake(Screen_Width-13-10-50-10, 0, 13+10+50+10, 52)];
    [changeBtn addTarget:self action:@selector(changeClick) forControlEvents:UIControlEventTouchUpInside];
    [changeHotWordsBgView addSubview:changeBtn];
    [_bigHeaderView addSubview:changeHotWordsBgView];
    
    //************************广告轮播模块************************
    UILabel *seperateLab1=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(changeHotWordsBgView.frame), Screen_Width, 10)];
    seperateLab1.backgroundColor=kColorBackGroundColor;
    [_bigHeaderView addSubview:seperateLab1];

    SGAdvertScrollView *advertScrollView=[[SGAdvertScrollView alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(seperateLab1.frame), Screen_Width-24, 63)];
    //advertScrollView.titleColor = KColorBlackTitle;
    advertScrollView.scrollTimeInterval = 3;
    advertScrollView.advertScrollViewStyle=SGAdvertScrollViewStyleNormal;
    advertScrollView.loopsArray=_monitorLoopsArr;
    advertScrollView.delegate = self;
    [_bigHeaderView addSubview:advertScrollView];
    //************************公司认领，个人证书认领，中标监控模块************************
    UILabel *seperateLab2=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(seperateLab1.frame)+63, Screen_Width, 10)];
    seperateLab2.backgroundColor=kColorBackGroundColor;
    [_bigHeaderView addSubview:seperateLab2];
    
    
    if (_monitorLoopsArr.count == 0) {
        advertScrollView.hidden = YES;
        seperateLab2.hidden = YES;
    }else{
        advertScrollView.hidden = NO;
        seperateLab2.hidden = NO;
    }
    
    UIButton *companyCheckBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(seperateLab1.frame)+height, Screen_Width/3, 93)];
    UIImageView *imgView1=[[UIImageView alloc]initWithFrame:CGRectMake((Screen_Width/3-41)/2, 14, 41, 41)];
    imgView1.image=[UIImage imageNamed:@"home_leftIcon"];
    [companyCheckBtn addSubview:imgView1];
    UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imgView1.frame)+13, Screen_Width/3, 15)];
    label1.text=@"公司认领";
    label1.font=kFontSize28;
    label1.textColor=KColorCompanyTitleBalck;
    label1.textAlignment=NSTextAlignmentCenter;
    [companyCheckBtn addSubview:label1];
    [companyCheckBtn addTarget:self action:@selector(companyCheckBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_bigHeaderView addSubview:companyCheckBtn];
    
    UIButton *peopleCheckBtn=[[UIButton alloc]initWithFrame:CGRectMake(Screen_Width/3, CGRectGetMaxY(seperateLab1.frame)+height, Screen_Width/3, 93)];
    UIImageView *imgView2=[[UIImageView alloc]initWithFrame:CGRectMake((Screen_Width/3-41)/2, 14, 41, 41)];
    imgView2.image=[UIImage imageNamed:@"home_middleIcon"];
    [peopleCheckBtn addSubview:imgView2];
    UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imgView2.frame)+13, Screen_Width/3, 15)];
    label2.text=@"个人证书认领";
    label2.font=kFontSize28;
    label2.textColor=KColorCompanyTitleBalck;
    label2.textAlignment=NSTextAlignmentCenter;
    [peopleCheckBtn addSubview:label2];
    [peopleCheckBtn addTarget:self action:@selector(peopleCheckBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_bigHeaderView addSubview:peopleCheckBtn];
    
    UIButton *biddingSubscribeBtn=[[UIButton alloc]initWithFrame:CGRectMake(Screen_Width/3*2, CGRectGetMaxY(seperateLab1.frame)+height, Screen_Width/3, 93)];
    UIImageView *imgView3=[[UIImageView alloc]initWithFrame:CGRectMake((Screen_Width/3-41)/2, 14, 41, 41)];
    imgView3.image=[UIImage imageNamed:@"home_rightIcon"];
    [biddingSubscribeBtn addSubview:imgView3];
    UILabel *label3=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imgView3.frame)+13, Screen_Width/3, 15)];
    label3.text=@"中标监控";
    label3.font=kFontSize28;
    label3.textColor=KColorCompanyTitleBalck;
    label3.textAlignment=NSTextAlignmentCenter;
    [biddingSubscribeBtn addSubview:label3];
    [biddingSubscribeBtn addTarget:self action:@selector(biddingSubscribeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bigHeaderView addSubview:biddingSubscribeBtn];
    
    
    //************************行业动态和我的监控按钮************************
    UILabel *seperateLab3=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(companyCheckBtn.frame), Screen_Width, 10)];
    seperateLab3.backgroundColor=kColorBackGroundColor;
    [_bigHeaderView addSubview:seperateLab3];
    
    _dynamicBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(seperateLab3.frame), Screen_Width/2, 45)];
    [_dynamicBtn setTitle:@"行业动态" forState:UIControlStateNormal];
    
    [_dynamicBtn setTitleColor:[_isIndustryClick isEqualToString:@"1"]?KColorFindingPeopleBlue:KColorBlackTitle forState:UIControlStateNormal];
    _dynamicBtn.titleLabel.font=KfontSize32Bold;
    [_dynamicBtn addTarget:self action:@selector(dynamicBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_bigHeaderView addSubview:_dynamicBtn];
    
    _myVisionBtn=[[UIButton alloc]initWithFrame:CGRectMake(Screen_Width/2, CGRectGetMaxY(seperateLab3.frame), Screen_Width/2, 45)];
    [_myVisionBtn setTitle:@"我的监控" forState:UIControlStateNormal];
    [_myVisionBtn setTitleColor:[_isIndustryClick isEqualToString:@"2"]?KColorFindingPeopleBlue:KColorBlackTitle forState:UIControlStateNormal];
    _myVisionBtn.titleLabel.font=KfontSize32Bold;
    [_myVisionBtn addTarget:self action:@selector(mySuperVisionClick) forControlEvents:UIControlEventTouchUpInside];
    if (_monitorUnread.length > 2) {
        _numLab=[[UILabel alloc]initWithFrame:CGRectMake((Screen_Width/2-70)/2+44, 14.5, 26, 16)];
        _numLab.text=@"99+";
        _numLab.layer.cornerRadius=8;
    } else {
        _numLab=[[UILabel alloc]initWithFrame:CGRectMake((Screen_Width/2-70)/2+54, 14.5, 16, 16)];
        _numLab.text=_monitorUnread;
        _numLab.layer.cornerRadius=_numLab.frame.size.width/2;
    }
    _numLab.center = CGPointMake(_numLab.center.x, CGRectGetHeight(_myVisionBtn.frame) / 2);
    
    _numLab.font=KFontSize22;
    _numLab.textColor=kColorWhite;
    _numLab.backgroundColor=kColorRed;
    
    _numLab.clipsToBounds=YES;
    _numLab.textAlignment=NSTextAlignmentCenter;
    CGFloat leftInset = 0;
    if ([_monitorUnread integerValue] > 0) {
        _numLab.hidden = NO;
        if ([_monitorUnread integerValue] > 99){
            _myVisionBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -52, 0, 0);
            _dynamicBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 52, 0, 0);
            leftInset = 26;
        }else{
            _myVisionBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -32, 0, 0);
            _dynamicBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 32, 0, 0);
            leftInset = 16;
        }
        
    }else{
        _numLab.hidden = YES;
        _myVisionBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        _dynamicBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    [_myVisionBtn addSubview:_numLab];
    [_bigHeaderView addSubview:_myVisionBtn];
    
    _scrollLine=[[UILabel alloc]initWithFrame:CGRectMake((Screen_Width/2-scrollLineWidth)/2+leftInset, CGRectGetMaxY(_dynamicBtn.frame) - scrollLineHeight-5, scrollLineWidth, scrollLineHeight)];
    
    
    if([_isIndustryClick isEqualToString:@"2"]){
        if ([_monitorUnread integerValue] > 0) {
            if ([_monitorUnread integerValue] > 99){
                _scrollLine.frame=CGRectMake((Screen_Width/2-scrollLineWidth)/2+Screen_Width/2-26, CGRectGetMaxY(_dynamicBtn.frame)-scrollLineHeight-5, scrollLineWidth, scrollLineHeight);
            }else{
                _scrollLine.frame=CGRectMake((Screen_Width/2-scrollLineWidth)/2+Screen_Width/2-16, CGRectGetMaxY(_dynamicBtn.frame)-scrollLineHeight-5, scrollLineWidth, scrollLineHeight);
            }
            
        }else{
            _scrollLine.frame=CGRectMake((Screen_Width/2-scrollLineWidth)/2+Screen_Width/2, CGRectGetMaxY(_dynamicBtn.frame)-scrollLineHeight-5, scrollLineWidth, scrollLineHeight);
        }
    }
    _scrollLine.backgroundColor=KColorFindingPeopleBlue;
    _scrollLine.layer.cornerRadius=1;
    _scrollLine.layer.masksToBounds = YES;
    [_bigHeaderView addSubview:_scrollLine];
    
    //************************一条分割线************************
//    UILabel *line2=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_dynamicBtn.frame), Screen_Width, 0.5)];
//    line2.backgroundColor=KColorGreyLine;
//    [_bigHeaderView addSubview:line2];
    
    _tableView.tableHeaderView=_bigHeaderView;
//    [self.view addSubview:_bigHeaderView];
//    self.topViewH = CGRectGetMaxY(_bigHeaderView.frame);
//    _tableView.contentInset=UIEdgeInsetsMake(self.topViewH-KNavigationBarHeight, 0, 0, 0);
//    self.offset = _tableView.contentOffset.y;//tableView的偏移量
}

#pragma mark 公司认领点击事件
-(void)companyCheckBtnClick{
    if ([DDUtils isEmptyString:[DDUserManager sharedInstance].userid]) {//未登录
        DDLoginCheckVC * vc = [[DDLoginCheckVC alloc] init];
        vc.loginSuccessBlock = ^{

        };
        
        UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
        [DDNavigationUtil setNavigationAndBottomLineWhiteColor:nav];
        [self showViewController:nav sender:nil];
    }
    else{//已登录
        DDCurrentCompanyModel * currentCompanyModel = [DDUserManager sharedInstance].currentCompanyModel;
        DDScAttestationEntityModel *scAttestationEntityModel = currentCompanyModel.scAttestationEntity;
        
        __weak __typeof(self) weakSelf=self;
        if ([DDUtils isEmptyString:scAttestationEntityModel.entId]) {
            //如果没有认证公司,去认证公司页(先跳到认领好处页面)
            DDCompanyClaimBenefitVC *vc=[[DDCompanyClaimBenefitVC alloc]init];
            vc.hidesBottomBarWhenPushed=YES;
            vc.isFromMyInfo = NO;
            vc.companyClaimBenefitType = CompanyClaimBenefitTypeDefault;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
        else{
            //如果已经认证了,去公司列表页
            DDMyEnterpriseVC * vc = [[DDMyEnterpriseVC alloc] init];
            vc.deleteSuccessBlock = ^{
                
            };
            vc.isFromMyInfo = NO;
            vc.myEnterpriseType = MyEnterpriseTypeDefault;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark 个人证书认领点击事件
-(void)peopleCheckBtnClick{
    if ([DDUtils isEmptyString:[DDUserManager sharedInstance].userid]) {
        DDLoginCheckVC *vc = [[DDLoginCheckVC alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [DDNavigationUtil setNavigationAndBottomLineWhiteColor:nav];
        vc.loginSuccessBlock = ^{
            if ([_isIndustryClick isEqualToString:@"2"]) {
                if (![DDUtils isEmptyString:[DDUserManager sharedInstance].userid]) {
                    [self mySuperVisionClick];
                }
            }
            if (_monitorLoopsArr.count==0) {
                [self requestNewsData];
            }
        };
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }
    else{
        //0没有认领过个人证书  1认领过个人证书
        if ([[DDUserManager sharedInstance].staffClaim isEqualToString:@"1"]) {//跳转到我的证书页面
            DDMyCertificateVC *vc=[[DDMyCertificateVC alloc]init];
            vc.hidesBottomBarWhenPushed=YES;
            vc.myCertificateType = DDMyCertificateTypeDefault;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else{//跳转到个人证书认领好处页面
            DDPersonalClaimBenefitVC *vc=[[DDPersonalClaimBenefitVC alloc]init];
            vc.hidesBottomBarWhenPushed=YES;
            vc.claimBenefitType = DDClaimBenefitTypeHomeList;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark 中标监控点击事件
-(void)biddingSubscribeBtnClick:(UIButton *)sender{
    sender.userInteractionEnabled = NO;
    if ([DDUtils isEmptyString:[DDUserManager sharedInstance].userid]) {
        [self presentLoginVC];
        sender.userInteractionEnabled = YES;
    }
    else{
        
        NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
        [params setValue:@"2" forKey:@"monitorType"];
        
        __weak __typeof(self) weakSelf=self;
        [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_monitorDetailInfo params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
//            NSLog(@"***********中标监控详情请求数据***************%@",responseObject);
            sender.userInteractionEnabled = YES;
            DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
            if (response.isSuccess) {//请求成功
                NSArray *listArr= responseObject[KData];
                if (listArr.count==0) {
                    DDProjectSubscribeBenefitVC *benefit=[[DDProjectSubscribeBenefitVC alloc]init];
                    benefit.hidesBottomBarWhenPushed=YES;
                    [weakSelf.navigationController pushViewController:benefit animated:YES];
                }
                else{
                    NSMutableArray *passRegionIds=[[NSMutableArray alloc]init];
                    NSMutableArray *passRegionStrs=[[NSMutableArray alloc]init];
                    NSMutableArray *dataSource=[[NSMutableArray alloc]init];
                    for (NSDictionary *dic in listArr) {
                        DDTalentSubscribeDetailModel *model=[[DDTalentSubscribeDetailModel alloc]initWithDictionary:dic error:nil];
                        [passRegionIds addObject:model.regionId];
                        [passRegionStrs addObject:model.name];
                        [dataSource addObject:model];
                    }
                    DDTalentSubscribeDetailModel *model=dataSource[0];
                    NSArray *passCertiTypes=[model.projectCertType componentsSeparatedByString:@","];
                    
                    DDProjectSubscribeVC *projectSubscribe=[[DDProjectSubscribeVC alloc]init];
                    projectSubscribe.type=@"1";
                    projectSubscribe.passRegionIds=passRegionIds;
                    projectSubscribe.passRegionStrs=passRegionStrs;
                    projectSubscribe.passProjectTypes=passCertiTypes;
                    projectSubscribe.hidesBottomBarWhenPushed=YES;
                    [weakSelf.navigationController pushViewController:projectSubscribe animated:YES];
                }
            }
            else{//显示异常
                [DDUtils showToastWithMessage:response.message];
            }
            
        } failure:^(NSURLSessionDataTask *operation, id responseObject) {
            sender.userInteractionEnabled = YES;
            [DDUtils showToastWithMessage:kRequestFailed];
        }];
    }
}

#pragma mark 行业动态点击事件
-(void)dynamicBtnClick{
    if([_isIndustryClick isEqualToString:@"1"]){
        return;
    }
     _isIndustryClick=@"1";
    _tableView.mj_footer.hidden=YES;
    [_unLogLab removeFromSuperview];
    [_logBtn removeFromSuperview];
    [_dataSourceArr removeAllObjects];
    [_tableView reloadData];
    _logBtn.hidden = YES;
    _unLogLab.hidden = YES;
    
    [UIView animateWithDuration:0.3 animations:^{
        if ([_monitorUnread integerValue] > 0) {
            if ([_monitorUnread integerValue]>99) {
                _scrollLine.frame=CGRectMake((Screen_Width/2-scrollLineWidth)/2+26, CGRectGetMaxY(_dynamicBtn.frame)-scrollLineHeight-5, scrollLineWidth, scrollLineHeight);
            }else {
                _scrollLine.frame=CGRectMake((Screen_Width/2-scrollLineWidth)/2+16, CGRectGetMaxY(_dynamicBtn.frame)-scrollLineHeight-5, scrollLineWidth, scrollLineHeight);
            }
        }else {
            _scrollLine.frame=CGRectMake((Screen_Width/2-scrollLineWidth)/2, CGRectGetMaxY(_dynamicBtn.frame)-scrollLineHeight-5, scrollLineWidth, scrollLineHeight);
        }
        
    } completion:^(BOOL finished) {
    }];
    [_dynamicBtn setTitleColor:KColorFindingPeopleBlue forState:UIControlStateNormal];
    [_myVisionBtn setTitleColor:KColorBlackTitle forState:UIControlStateNormal];
    _hud =[DDUtils showHUDCustom:@""];
    
//    [self.view makeToastActivity:CSToastPositionCenter];
    [self requestIndustryData:YES];
}

#pragma mark 我的监控点击事件
-(void)mySuperVisionClick{
    if([_isIndustryClick isEqualToString:@"2"]){
        return;
    }
    _isIndustryClick=@"2";
    CGFloat lineLfet = 0.0;
    if ([_monitorUnread integerValue] > 0) {
        if ([_monitorUnread integerValue] > 99){
            lineLfet = 26.0;
        }else{
           lineLfet = 16.0;
        }
        
    }
    [UIView animateWithDuration:0.3 animations:^{
        _scrollLine.frame=CGRectMake((Screen_Width/2-scrollLineWidth)/2+Screen_Width/2-lineLfet, CGRectGetMaxY(_dynamicBtn.frame)-scrollLineHeight-5, scrollLineWidth, scrollLineHeight);
    } completion:^(BOOL finished) {
    }];

    [_myVisionBtn setTitleColor:KColorFindingPeopleBlue forState:UIControlStateNormal];
    [_dynamicBtn setTitleColor:KColorBlackTitle forState:UIControlStateNormal];
    
    if ([DDUtils isEmptyString:[DDUserManager sharedInstance].userid]) {
        _tableView.mj_footer.hidden=YES;
        _tableView.mj_header.automaticallyChangeAlpha = YES;
        [_dataSourceArr removeAllObjects];
        [_tableView reloadData];
        
        _unLogLab=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_bigHeaderView.frame)+33, Screen_Width, 15)];
        _unLogLab.text=@"你还没有登录，登录后可查看监控动态";
        _unLogLab.font=kFontSize30;
        _unLogLab.textColor=KColorBlackSecondTitle;
        _unLogLab.textAlignment=NSTextAlignmentCenter;
        [_tableView addSubview:_unLogLab];
        
        _logBtn=[[UIButton alloc]initWithFrame:CGRectMake((Screen_Width-94)/2, CGRectGetMaxY(_unLogLab.frame)+33, 94, 40)];
        [_logBtn setTitle:@"去登录" forState:UIControlStateNormal];
        [_logBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
        _logBtn.titleLabel.font=kFontSize28;
        [_logBtn setBackgroundColor:KColorFindingPeopleBlue];
        _logBtn.layer.cornerRadius=3;
        _logBtn.clipsToBounds=YES;
        [_logBtn addTarget:self action:@selector(presentLoginVC) forControlEvents:UIControlEventTouchUpInside];
        [_tableView addSubview:_logBtn];
    }
    else{
        _tableView.mj_footer.hidden=NO;
        [_logBtn removeFromSuperview];
        [_unLogLab removeFromSuperview];
        _hud =[DDUtils showHUDCustom:@""];
        [self requestMyVisionData:YES];
    }
    _tableView.mj_footer.hidden=YES;
}

#pragma mark ***********************************业务分割线*************************************
#pragma mark 全局文本搜索
-(void)textSearchClick{
    DDAllSearchVC *allSearch=[[DDAllSearchVC alloc]init];
    allSearch.type=@"1";
    allSearch.hidesBottomBarWhenPushed=YES;
    allSearch.placeholderText=@"企业名称、姓名、项目名称等";
    [self.navigationController pushViewController:allSearch animated:NO];
}

#pragma mark 全局语音搜索
-(void)videoSearchClick{
    NSString *mediaType = AVMediaTypeAudio;//读取媒体类型
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"手机麦克风权限受限,请在设置中启用" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * actionCancel = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
            
        }];
        
        UIAlertAction * actionReStart = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertController addAction:actionCancel];
        [alertController addAction:actionReStart];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else{
        IFlyRecognizerView *audioView=[[IFlyRecognizerView alloc]initWithCenter:CGPointMake(Screen_Width/2, Screen_Height/2)];
        
        [audioView setParameter:@"iat" forKey:@"domain"];
        //[audioView setParameter:@"500" forKey:@"vad_bos"];
        [audioView setParameter:@"500" forKey:@"vad_eos"];
        
        audioView.delegate=self;
        [audioView start];
    
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:audioView];
        audioView.subviews[0].subviews[1].hidden=YES;
    }
}

#pragma mark 收到语音内容的回调1
-(void)onResult:(NSArray *)resultArray isLast:(BOOL)isLast{
    if (isLast==NO) {
        if (resultArray.count>0) {
            NSMutableString *string=[[NSMutableString alloc]init];
            NSDictionary *dic1=resultArray[0];
            NSString *dic2=dic1.allKeys[0];
            NSData *data=[dic2 dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dic3 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            for (NSDictionary *dic in dic3[@"ws"]) {
                [string appendString:dic[@"cw"][0][@"w"]];
            }
            
            if (![DDUtils isEmptyString:string]) {
                
                if (string.length>=1) {
                    DDAllSearchVC *allSearch=[[DDAllSearchVC alloc]init];
                    allSearch.type=@"1";
                    allSearch.hidesBottomBarWhenPushed=YES;
                    allSearch.placeholderText=@"企业名称、姓名、项目名称";
                    allSearch.audioSingleText=string;
                    allSearch.audioType=@"1";
                    [self.navigationController pushViewController:allSearch animated:NO];
                }
            }
            
        }
    }
}

#pragma mark 收到语音内容的回调2
- (void)onError:(IFlySpeechError *)error {

}

#pragma mark 跳转到二维码扫描页面
- (void)sacnButtonClick:(UIButton*)sender{
    if ([DDUtils isEmptyString:[DDUserManager sharedInstance].userid]) {//没登录时，跳转到登录页
        [self presentLoginVCAndCodeScan];
    }
    else{//跳转二维码扫描页面
        NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
        if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"应用相机权限受限,请在设置中启用" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction * actionCancel = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }
                
            }];
            
            UIAlertAction * actionReStart = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertController addAction:actionCancel];
            [alertController addAction:actionReStart];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        else{
            DDQRCodeScanVC *QRCodeScan = [[DDQRCodeScanVC alloc] init];
            QRCodeScan.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:QRCodeScan animated:YES];
        }
    }
}

#pragma mark ***********************************业务分割线*************************************

#pragma mark 请求我的监控数量
- (void)requestMyVisionNum{
    DDUserManager * userManger = [DDUserManager sharedInstance];
    if (![DDUtils isEmptyString:userManger.userid]) {
        if ([_requestUrlArray containsObject:KHttpRequest_monitorNews]) {
            return ;
        }
        [_requestUrlArray addObject:KHttpRequest_monitorNews];
        [[DDHttpManager sharedInstance]sendPostRequest:KHttpRequest_monitorNews params:nil success:^(NSURLSessionDataTask *operation, id responseObject){
            [_requestUrlArray removeObject:KHttpRequest_monitorNews];
//            NSLog(@"我的监控消息数量:%@",responseObject);
            DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
            if (response.isSuccess) {
                _monitorUnread=[NSString stringWithFormat:@"%@",response.data];
                if (![DDUtils isEmptyString:_monitorUnread] && [_monitorUnread integerValue] > 0) {
                    [self.tabBarController.tabBar showBadgeOnItemIndex:3];
                }
                CGFloat leftInset = 0;
                if ([_monitorUnread integerValue] > 0) {
                    _numLab.hidden = NO;
                    if ([_monitorUnread integerValue]>99) {
                        _myVisionBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -52, 0, 0);
                        _dynamicBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 52, 0, 0);
                        leftInset = 26;
                        _numLab.frame = CGRectMake((Screen_Width/2-70)/2+44, 14.5, 26, 16);
                        _numLab.text = @"99+";
                        _numLab.layer.cornerRadius=8;
                        
                    }else{
                        _myVisionBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -32, 0, 0);
                        _dynamicBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 32, 0, 0);
                        leftInset = 16;
                        _numLab.frame=CGRectMake((Screen_Width/2-70)/2+54, 14.5, 16, 16);
                        _numLab.text= _monitorUnread;
                        _numLab.layer.cornerRadius=_numLab.frame.size.width/2;
                    }
                }else{
                    _myVisionBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
                    _dynamicBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
                    _numLab.hidden = YES;
                }
                if([_isIndustryClick isEqualToString:@"2"]){
                    if ([_monitorUnread integerValue] > 0) {
                        if ([_monitorUnread integerValue] > 99){
                            _scrollLine.frame=CGRectMake((Screen_Width/2-scrollLineWidth)/2+Screen_Width/2-26, CGRectGetMaxY(_dynamicBtn.frame)-scrollLineHeight-5, scrollLineWidth, scrollLineHeight);
                        }else{
                            _scrollLine.frame=CGRectMake((Screen_Width/2-scrollLineWidth)/2+Screen_Width/2-16, CGRectGetMaxY(_dynamicBtn.frame)-scrollLineHeight-5, scrollLineWidth, scrollLineHeight);
                        }
                        
                    }else{
                        _scrollLine.frame=CGRectMake((Screen_Width/2-scrollLineWidth)/2+Screen_Width/2, CGRectGetMaxY(_dynamicBtn.frame)-scrollLineHeight-5, scrollLineWidth, scrollLineHeight);
                    }
                }else {
                    _scrollLine.frame = CGRectMake((Screen_Width/2-scrollLineWidth)/2+leftInset, CGRectGetMaxY(_dynamicBtn.frame)-scrollLineHeight-5, scrollLineWidth, scrollLineHeight);
                }
            }
            
        } failure:^(NSURLSessionDataTask *operation, id responseObject) {
           [_requestUrlArray removeObject:KHttpRequest_monitorNews];
        }];
    }
}

#pragma mark 请求监控轮播数据
- (void)requestNewsData{
    DDUserManager * userManger = [DDUserManager sharedInstance];
    if (![DDUtils isEmptyString:userManger.userid]) {
        NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
        [params setValue:@"1" forKey:@"current"];
        [params setValue:@"50" forKey:@"size"];
        if ([_requestUrlArray containsObject:KHttpRequest_monitorLoops]) {
            return ;
        }
        [_requestUrlArray addObject:KHttpRequest_monitorLoops];
        [[DDHttpManager sharedInstance]sendPostRequest:KHttpRequest_monitorLoops params:params success:^(NSURLSessionDataTask *operation, id responseObject){
//            NSLog(@"首页监控轮播数据:%@",responseObject);
            [_requestUrlArray removeObject:KHttpRequest_monitorLoops];
            [_monitorLoopsArr removeAllObjects];
            DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
            if (response.isSuccess) {
                if ([response.data isKindOfClass:[NSDictionary class]]) {
                    for (NSDictionary *dic in responseObject[KData][@"records"]) {
                        DDMyMonitorLoopsListModel *model=[[DDMyMonitorLoopsListModel alloc]initWithDictionary:dic error:nil];
                        [model handleModel];
                        [_monitorLoopsArr addObject:model];
                    }
                    
                    [self createBigHeaderView];
                    [self layoutHotWordsBtns];
                    if(_dataSourceArr.count){
                        [_tableView reloadData];
                    }
                }
            }
        } failure:^(NSURLSessionDataTask *operation, id responseObject) {
            [_requestUrlArray removeObject:KHttpRequest_monitorLoops];
        }];
    }
}

#pragma mark 请求换一换热搜词接口
-(void)requestHotWords{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    NSString *provice;
    NSString *city;
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status){
        //定位不能用
        provice=@"江苏省";
        city=@"南京市";
    }
    else{
        //定位功能可用
        //如果保存有定位到的省,首先使用保存的,没有的话,默认江苏省
        DDUserManager *manager=[DDUserManager sharedInstance];
        if (![DDUtils isEmptyString:manager.province]) {
            provice=manager.province;
            city=manager.city;
        }
        else{
            provice=@"江苏省";
            city=@"南京市";
        }
    }
    NSString *regionName=[NSString stringWithFormat:@"%@,%@",provice,city];
    [params setValue:regionName forKey:@"regionName"];
    [params setValue:@"1" forKey:@"type"];
    
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_hotSearchWords params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
//        NSLog(@"***********热搜词条请求数据***************%@",responseObject);
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {//请求成功
            [_hotWordsArr removeAllObjects];
            NSArray *listArr= responseObject[KData];
            for (NSDictionary *dic in listArr) {
                DDHotSearchModel *model=[[DDHotSearchModel alloc]initWithDictionary:dic error:nil];
                [_hotWordsArr addObject:model];
            }
        }
        else{//显示异常
            [DDUtils showToastWithMessage:response.message];
        }
        [self layoutHotWordsBtns];
    } failure:^(NSURLSessionDataTask *operation, id responseObject) {
        [DDUtils showToastWithMessage:kRequestFailed];
    }];
}

#pragma mark 地区定位
-(void)startLocation{
    //初始化实例
    _baiduLocationManager = [[BMKLocationManager alloc] init];
    //设置delegate
    _baiduLocationManager.delegate = self;
    //设置返回位置的坐标系类型
    _baiduLocationManager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
    //设置距离过滤参数
    _baiduLocationManager.distanceFilter = kCLDistanceFilterNone;
    //设置预期精度参数
    _baiduLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //设置应用位置类型
    _baiduLocationManager.activityType = CLActivityTypeAutomotiveNavigation;
    //设置是否自动停止位置更新
    _baiduLocationManager.pausesLocationUpdatesAutomatically = NO;
    //设置是否允许后台定位
    //_baiduLocationManager.allowsBackgroundLocationUpdates = YES;
    //设置位置获取超时时间
    _baiduLocationManager.locationTimeout = 10;
    //设置获取地址信息超时时间
    _baiduLocationManager.reGeocodeTimeout = 10;
    //开启连续定位
    [_baiduLocationManager startUpdatingLocation];
}
#pragma mark BMKLocationManagerDelegate 百度地图定位代理方法
 // 当定位发生错误时，会调用代理的此方法。
- (void)BMKLocationManager:(BMKLocationManager * _Nonnull)manager didFailWithError:(NSError * _Nullable)error{
    _region = @"南京市";
    [self requestHotWords];
    [self requestIndustryData:YES];
}
//连续定位回调函数。
- (void)BMKLocationManager:(BMKLocationManager * _Nonnull)manager didUpdateLocation:(BMKLocation * _Nullable)location orError:(NSError * _Nullable)error{
    //停止连续定位
    [manager stopUpdatingLocation];
    BMKLocationReGeocode * rgcdata =  location.rgcData;//地址数据
    //储存用户经纬度信息
    DDUserManager * userManger = [DDUserManager sharedInstance];
    userManger.longitude = [NSString stringWithFormat:@"%f",location.location.coordinate.longitude];
    userManger.latitude = [NSString stringWithFormat:@"%f",location.location.coordinate.latitude];
    //储存用户的省市区信息
    userManger.province = rgcdata.province;
    userManger.city = rgcdata.city;
    userManger.area = rgcdata.district;
    _region=rgcdata.city;
    [self requestHotWords];
    [self requestIndustryData:YES];
}
#pragma mark 换一换点击事件
-(void)changeClick{
    _hotSearchChanged = YES;
    [self layoutHotWordsBtns];
}

#pragma mark 放置热词
-(void)layoutHotWordsBtns {
    [_showedHotWordsArr removeAllObjects];
    //随机取八个热搜词
    [_tipsView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSMutableArray *tempArr1=[[NSMutableArray alloc]init];
    NSMutableArray *tempArr2=[[NSMutableArray alloc]initWithArray:_hotWordsArr];//获取到hotWordsArr的内容
    
    if (tempArr2.count==0) {//如果没有请求到数据，则终止
        return;
    }
    _hotSearchChanged = NO;
    if (tempArr2.count>=7) {//个数大于等于7个
        for (int i=0; i<7; i++) {
            int index = arc4random() % tempArr2.count;
            [tempArr1 addObject:tempArr2[index]];
            [tempArr2 removeObjectAtIndex:index];
        }
    }
    else{
        for (int i=0; i<tempArr2.count; i++) {
            int index = arc4random() % tempArr2.count;
            [tempArr1 addObject:tempArr2[index]];
            [tempArr2 removeObjectAtIndex:index];
        }
    }
    
    int length=0;
    for (int i=0; i<tempArr1.count; i++) {
        DDHotSearchModel *model=tempArr1[i];
        //float btnWidth=[DDUtils widthForText:model.searchTitle withTextHeigh:13 withFont:kFontSize26];
        CGRect wordFrame = [model.searchTitle boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName:kFontSize26Bold} context:nil];
        float btnWidth=wordFrame.size.width;
        
        if (i==0) {
            length=btnWidth;
        }
        else if(i==tempArr1.count-1){
            length=length+btnWidth;
        }
        else{
            length=length+btnWidth+10;
        }
        
        if (length<=_tipsView.size.width) {
            UIButton *btn;
            if (i==0) {
                btn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, btnWidth, 52)];
            }
            else if(i==tempArr1.count-1){
                btn=[[UIButton alloc]initWithFrame:CGRectMake(length-btnWidth+10, 0, btnWidth, 52)];
            }
            else{
                btn=[[UIButton alloc]initWithFrame:CGRectMake(length-btnWidth, 0, btnWidth, 52)];
            }
            
            btn.tag=50+i;//给btn打Tag
            [_showedHotWordsArr addObject:model];
            [btn addTarget:self action:@selector(hotWordClick:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitle:model.searchTitle forState:UIControlStateNormal];
            [btn setTitleColor:kColorWhite forState:UIControlStateNormal];
            btn.titleLabel.font=kFontSize26Bold;
            [_tipsView addSubview:btn];
        }
        else{
            break;
        }
    }
}

#pragma mark 热词点击事件
-(void)hotWordClick:(UIButton *)btn{
    DDHotSearchModel *model=_showedHotWordsArr[btn.tag-50];
    
    //存浏览历史
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithData:[model.searchContent dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    [DDSearchHistoryDAOAndDB insertHistorySearchByTypeId:@"9909" andSearchResult:[DDUtils transformAttributedText:attributeStr] andGlobalType:@"0" andTransId:model.enterpriseId];
    
    DDCompanyDetailVC *companyDetail=[[DDCompanyDetailVC alloc]init];
    companyDetail.enterpriseId=model.enterpriseId;
    companyDetail.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:companyDetail animated:NO];
}

#pragma mark 请求行业动态接口
-(void)requestIndustryData:(BOOL)isrefresh{
    if (isrefresh) {
        currentPage = 1;
    }
    DDUserManager *manager=[DDUserManager sharedInstance];
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [params setValue:_region forKey:@"region"];
    if (![DDUtils isEmptyString:manager.userid]) {
        [params setValue:manager.userid forKey:@"userId"];
    }
    [params setValue:[NSString stringWithFormat:@"%ld",currentPage] forKey:@"current"];
    [params setValue:@"10" forKey:@"size"];
    NSLog(@"**********首页行***************%@",params);
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_industryDynamic params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"**********首页行业动态数据***************%@",responseObject);
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            currentPage+=1;
            if (isrefresh) {
                [_dataSourceArr removeAllObjects];
                if (self.tableView.mj_footer) {
                    [self.tableView.mj_footer resetNoMoreData];
                    self.tableView.mj_footer = nil;
                }
            }
            
            
            _dict = responseObject[KData];
            if([_dict[@"numFoundCount"] integerValue]>0){
                updateNumCount = [_dict[@"numFoundCount"] integerValue];
                isShowUpdate = YES;
            }
            
            pageCount = [_dict[@"totalCount"] integerValue];
            if (pageCount==0) {
                [self showNoDataWithWithType];
            }
        
            NSArray *listArr=_dict[@"list"];
            if (listArr.count>0) {
                _tableView.mj_footer.hidden = NO;
                _tableView.tableFooterView = [UIView new];
                for (NSDictionary *dic in listArr) {
                    DDIndustryDynamicListModel *model = [[DDIndustryDynamicListModel alloc]initWithDictionary:dic error:nil];
                    [_dataSourceArr addObject:model];
                }
            }
            if (_dataSourceArr.count<pageCount) {
                isLastData = NO;
            }else{
                isLastData = YES;
            }
            [_tableView reloadData];
            [self endRefrshing:YES];
        }
        else{
            [self showNoDataWithWithType];
            [DDUtils showToastWithMessage:response.message];
        }
        [_hud hide:YES];
    }  failure:^(NSURLSessionDataTask *operation, id responseObject)  {
        [self endRefrshing:NO];
        [DDUtils showToastWithMessage:kRequestFailed];
        [_hud hide:YES];
    }];
}
-(void)delayMethod{
     [_updateNumL removeFromSuperview];
    isShowUpdate = NO;
    [self.tableView reloadData];
}
-(void)endRefrshing:(BOOL)requestSucceed
{
    if (_tableView) {
        if (_tableView.mj_header.isRefreshing) {
            [_tableView.mj_header  endRefreshing];
        }
        if (requestSucceed) {
            if (isLastData==NO && !self.tableView.mj_footer) {
                //如果不是最后一条数据 设置footer
               _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                   if ([_isIndustryClick isEqualToString:@"1"]) {
                       [self requestIndustryData:NO];
                   }else{
                       [self requestMyVisionData:NO];
                   }
                }];
            }
            else if (isLastData == YES && !self.tableView.mj_footer)
            {
                return;
            }
            else if(isLastData == YES && self.tableView.mj_footer)
            {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            else
            {
                if (_tableView.mj_footer.isRefreshing) {
                    [_tableView.mj_footer endRefreshing];
                }
            }
        }
        else
        {
            if (_tableView.mj_footer.isRefreshing) {
                [_tableView.mj_footer endRefreshing];
            }
        }
    }
}

#pragma mark 请求我的监控数据
- (void)requestMyVisionData:(BOOL)isrefresh{
    if (isrefresh) {
         currentPage = 1;
    }
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:[NSString stringWithFormat:@"%ld",currentPage] forKey:@"current"];
    [params setValue:@"10" forKey:@"size"];
    if ([_requestUrlArray containsObject:KHttpRequest_myMonitorList]) {
        return ;
    }
    [_requestUrlArray addObject:KHttpRequest_myMonitorList];
    [[DDHttpManager sharedInstance]sendPostRequest:KHttpRequest_myMonitorList params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
//        NSLog(@"**********我的监控动态列表数据***************%@",responseObject);
        [_requestUrlArray removeObject:KHttpRequest_myMonitorList];
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            currentPage+=1;
            if (isrefresh) {
                [self.dataSourceArray removeAllObjects];
                if (self.tableView.mj_footer) {
                    [self.tableView.mj_footer resetNoMoreData];
                    self.tableView.mj_footer = nil;
                }
            }
            if (![response isEmpty]) {
                _dict = responseObject[KData];
                pageCount = [_dict[@"totalCount"] integerValue];
                if (pageCount==0) {
                    [self showNoDataWithWithType];
                }
                NSArray *listArr=_dict[@"list"];
                
                for (NSDictionary *dic in listArr) {
                    DDMySuperVisionDynamicListModel *model = [[DDMySuperVisionDynamicListModel alloc]initWithDictionary:dic error:nil];
                    [model handleModel];
                    [_dataSourceArray addObject:model];
                }
                if (_dataSourceArray.count<pageCount) {
                    isLastData = NO;
                }else{
                    isLastData = YES;
                }
            }
            else{
                isLastData = YES;
                [self showNoDataWithWithType];
            }
            [_tableView reloadData];
            [self endRefrshing:YES];
        }
        else{
            [self endRefrshing:NO];
            [self showNoDataWithWithType];
        }
        [_hud hide:YES];
    }  failure:^(NSURLSessionDataTask *operation, id responseObject)  {
        [self endRefrshing:NO];
        [_requestUrlArray removeObject:KHttpRequest_myMonitorList];
        [DDUtils showToastWithMessage:kRequestFailed];
        [_hud hide:YES];
    }];
}

- (void)showNoDataWithWithType{
    _tableView.mj_footer.hidden = YES;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 300)];
    view.backgroundColor = [UIColor colorWithRed:242/255.0
                                           green:242/255.0
                                            blue:242/255.0
                                           alpha:1];
    UIImageView *imageView = [UIImageView new];
    [view addSubview: imageView];
    imageView.image = [UIImage imageNamed:@"noResult_content"];
   [view addSubview: imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(view);
        make.centerY.mas_equalTo(view).offset(-30);
        make.size.mas_equalTo(CGSizeMake(72, 72));
    }];
    UILabel *label = [UILabel labelWithFont:kFontSize30 textColor:KColorBlackSecondTitle textAlignment:NSTextAlignmentCenter numberOfLines:1];
    [view addSubview: label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(view);
        make.top.equalTo(imageView.mas_bottom).offset(20);
    }];
    _tableView.tableFooterView = view;
    if ([_isIndustryClick isEqualToString:@"1"]) {
        //行业动态
        label.text = @"暂无行业动态信息~";
    }else{
        //我的监控
        label.text = @"暂无监控动态信息~";
    }
}

#pragma mark 创建tableView
-(void)createTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, KNavigationBarHeight, Screen_Width, Screen_Height-KNavigationBarHeight-KTabbarHeight) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.backgroundColor=kColorBackGroundColor;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.showsVerticalScrollIndicator=YES;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.separatorColor=KColorTableSeparator;
    _tableView.contentInset=UIEdgeInsetsMake(topViewHeight-KNavigationBarHeight, 0, 0, 0);
    self.offset = _tableView.contentOffset.y;//tableView的偏移量
    __weak __typeof(self) weakSelf = self;
    DDRefreshHeader  * header =[DDRefreshHeader headerWithRefreshingBlock:^{
        if ([_isIndustryClick isEqualToString:@"1"]) {
            [weakSelf requestIndustryData:YES];
        }
        else{
            if (![DDUtils isEmptyString:[DDUserManager sharedInstance].userid]) {
                [weakSelf requestMyVisionData:YES];
            }
        }
        
        if (_monitorLoopsArr.count==0) {
            [weakSelf requestNewsData];
        }
        
    }];
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    // 隐藏状态
    header.stateLabel.hidden = YES;
    self.tableView.mj_header = header;
}

#pragma mark tableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([_isIndustryClick isEqualToString:@"1"]) {
        return _dataSourceArr.count;
    }
    return _dataSourceArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_isIndustryClick isEqualToString:@"1"]) {
        DDIndustryDynamicListModel *model=_dataSourceArr[indexPath.section];
        if([model.title_type isEqualToString:@"2"]){//单张图片
            static NSString * cellID = @"DDIndustryNews4Cell";
            DDIndustryNews4Cell * cell = (DDIndustryNews4Cell *)[tableView dequeueReusableCellWithIdentifier:cellID];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
            }
            
            if (indexPath.section==0) {
                cell.tipLab.hidden=NO;
                cell.tipLab.text=@"置顶";
                cell.leftDistance.constant=62;
            }
            else if (indexPath.section==1) {
                cell.tipLab.hidden=NO;
                cell.tipLab.text=@"热点";
                cell.leftDistance.constant=62;
            }
            else if (indexPath.section==2) {
                cell.tipLab.hidden=NO;
                cell.tipLab.text=@"热点";
                cell.leftDistance.constant=62;
            }
            else{
                cell.tipLab.hidden=YES;
                cell.leftDistance.constant=17;
            }
            
//            cell.titleLab.text=model.title;
            cell.titleStr = model.title;
            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",DD_Http_Image_Server,model.attr_img]] placeholderImage:[UIImage imageNamed:@"home_pic_loading"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (image) {
                    cell.imgView.image = image;
                }
            }];
            cell.attachLab1.text=model.dept_source;
            //cell.attachLab3.text=[DDUtils compareTime:model.publish_date_source];
            cell.attachLab3.text=[DDUtils getDateLineByStandardTime:model.publish_date_source];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
        else if([model.title_type isEqualToString:@"3"]){//多张图片
            static NSString * cellID = @"DDIndustryNews3Cell";
            DDIndustryNews3Cell * cell = (DDIndustryNews3Cell *)[tableView dequeueReusableCellWithIdentifier:cellID];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
            }
            if (indexPath.section==0) {
                cell.tipLab.hidden=NO;
                cell.tipLab.text=@"置顶";
                cell.leftDistance.constant=62;
            }
            else if (indexPath.section==1) {
                cell.tipLab.hidden=NO;
                cell.tipLab.text=@"热点";
                cell.leftDistance.constant=62;
            }
            else if (indexPath.section==2) {
                cell.tipLab.hidden=NO;
                cell.tipLab.text=@"热点";
                cell.leftDistance.constant=62;
            }
            else{
                cell.tipLab.hidden=YES;
                cell.leftDistance.constant=17;
            }
            [cell loadDataWithContent:model.title];
            cell.attachLab1.text=model.dept_source;
            cell.attachLab3.text=[DDUtils getDateLineByStandardTime:model.publish_date_source];
            NSArray *array;
            if ([model.attr_img containsString:@";"]) {
                array=[model.attr_img componentsSeparatedByString:@";"];
            }
            else{
                [cell.img1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",DD_Http_Image_Server,model.attr_img]] placeholderImage:[UIImage imageNamed:@"home_pic_loading"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if (image) {
                        cell.img1.image = image;
                    }
                }];
            }
            if (array.count>0) {
                [cell.img1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",DD_Http_Image_Server,array[0]]] placeholderImage:[UIImage imageNamed:@"home_pic_loading"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if (image) {
                        cell.img1.image = image;
                    }
                }];
            }
            
            if (array.count>1) {
                [cell.img2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",DD_Http_Image_Server,array[1]]] placeholderImage:[UIImage imageNamed:@"home_pic_loading"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if (image) {
                        cell.img2.image = image;
                    }
                }];
            }
            
            if (array.count>2) {
                [cell.img3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",DD_Http_Image_Server,array[2]]] placeholderImage:[UIImage imageNamed:@"home_pic_loading"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if (image) {
                        cell.img3.image = image;
                    }
                }];
            }
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
        else{//纯文本
            static NSString * cellID = @"DDIndustryNews1Cell";
            DDIndustryNews1Cell * cell = (DDIndustryNews1Cell *)[tableView dequeueReusableCellWithIdentifier:cellID];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
            }
            
            if (indexPath.section==0) {
                cell.tipLab.hidden=NO;
                cell.tipLab.text=@"置顶";
                cell.leftDistance.constant=62;
            }
            else if (indexPath.section==1) {
                cell.tipLab.hidden=NO;
                cell.tipLab.text=@"热点";
                cell.leftDistance.constant=62;
            }
            else if (indexPath.section==2) {
                cell.tipLab.hidden=NO;
                cell.tipLab.text=@"热点";
                cell.leftDistance.constant=62;
            }
            else{
                cell.tipLab.hidden=YES;
                cell.leftDistance.constant=17;
            }
            [cell loadDataWithContent:model.title];
            cell.attachLab1.text=model.dept_source;
            cell.attachLab3.text=[DDUtils getDateLineByStandardTime:model.publish_date_source];
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    else{
        DDMySuperVisionDynamicListModel *model=_dataSourceArray[indexPath.section];
        //main_type:1-公司证书，2-人员证书, 3-认领公司，4-关注公司，5-本人证书，6-半日报
        //sub_type:1-到期监控，2-中标监控，3-变更单位，4-公司名称变更，5-行政处罚，6-事故通知，7-人员电话公开，8-招标监控
            model.mainType = [NSString stringWithFormat:@"%@",model.mainType];
            if ([model.mainType isEqualToString:@"6"]) {//半日报
                static NSString * cellID = @"DDMySuperVisionDynamicList2Cell";
                DDMySuperVisionDynamicList2Cell * cell = (DDMySuperVisionDynamicList2Cell *)[tableView dequeueReusableCellWithIdentifier:cellID];
                if (cell == nil) {
                    cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
                }
                [cell loadDataWithModel:model];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            else{//其余类型
                static NSString *cellID = @"DDMySuperVisionDynamicList1Cell";
                DDMySuperVisionDynamicList1Cell * cell = (DDMySuperVisionDynamicList1Cell *)[tableView dequeueReusableCellWithIdentifier:cellID];
                if (cell == nil) {
                    cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
                }
                [cell loadDataWithModel:model];
                cell.makeBtn.tag = 1000+indexPath.section;
                [cell.makeBtn addTarget:self action:@selector(hasClickMakeAction:) forControlEvents:UIControlEventTouchUpInside];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
       
    }
}
-(void)hasClickMakeAction:(UIButton *)sender{
    DDMySuperVisionDynamicListModel *model=_dataSourceArray[sender.tag-1000];
    if ([sender.titleLabel.text isEqualToString:@"办理"]) {
        if ([model.typeCode isEqualToString:@"ECE_005"]) {
            DDServiceWebViewVC * checkVC = [DDServiceWebViewVC new];
            checkVC.hostUrl = [NSString stringWithFormat:@"%@enterprise_service/pages/handle_list.html?groupId=10&typeId=48&_t=1545135570014",DD_baseService_Server];
            checkVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:checkVC animated:YES];
            return;
        }
        //工商社保
        if ([model.typeCode isEqualToString:@"ECE_001"] ||[model.typeCode isEqualToString:@"ECE_002"] ){
            DDServiceWebViewVC *checkVC = [DDServiceWebViewVC new];
            checkVC.hostUrl = [NSString stringWithFormat:@"%@enterprise_service/pages/handle_list.html?groupId=7",DD_baseService_Server];
            checkVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:checkVC animated:YES];
            return;
        }
        //资质办理
        if ([model.typeCode isEqualToString:@"ECE_003"]){
            DDServiceWebViewVC *checkVC = [DDServiceWebViewVC new];
            checkVC.hostUrl = @"http://gcdd.koncendy.com/apphs/enterprise_service/pages/handle_list.html?groupId=1";
            checkVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:checkVC animated:YES];
            return;
        }
        //管理体系
        if ([model.typeCode isEqualToString:@"ECE_006"] || [model.typeCode isEqualToString:@"ECE_007"]) {
            DDServiceWebViewVC *checkVC = [DDServiceWebViewVC new];
            checkVC.hostUrl = @"http://gcdd.koncendy.com/apphs/enterprise_service/pages/handle_list.html?groupId=10";
            checkVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:checkVC animated:YES];
            return;
        }
        //施工工法
        if ([model.typeCode isEqualToString:@"ECE_008"]){
            DDServiceWebViewVC *checkVC = [DDServiceWebViewVC new];
            checkVC.hostUrl = @"http://gcdd.koncendy.com/apphs/enterprise_service/pages/handle_list.html?groupId=10";
            checkVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:checkVC animated:YES];
            return;
        }
        //安许证办理
        if ([model.typeCode isEqualToString:@"ECE_004"]){
            DDServiceWebViewVC *checkVC = [DDServiceWebViewVC new];
            checkVC.hostUrl = @"http://gcdd.koncendy.com/apphs/enterprise_service/pages/handle_list.html?groupId=2";
            checkVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:checkVC animated:YES];
            return;
        }
        if([model.typeCode isEqualToString:@"SCE_002"]||[model.typeCode isEqualToString:@"SCE_003"]) {//二建 //三类
            DDExamineTrainingVC *trainVC = [DDExamineTrainingVC new];
            trainVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:trainVC animated:YES];
            return;
        }
        return;
    }
    if([model.subType isEqualToString:@"2"]){
//        if ([model.in3Month integerValue] == 1) {
//            //买履约保证险
//            NSLog(@"买履约保证险");
//        } else {
//            //买质量保证险
//            NSLog(@"买质量保证险");
//        }
        DDServiceWebViewVC * checkVC = [DDServiceWebViewVC new];
        checkVC.hostUrl = @"http://gcdd.koncendy.com/apphs/insuranceAndCompanyTrading/#/insuranceList";
        checkVC.hidesBottomBarWhenPushed=YES;
        checkVC.serviceWebViewType = DDServiceWebViewTypeOther;
        [self.navigationController pushViewController:checkVC animated:YES];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_isIndustryClick isEqualToString:@"1"]) {
        if(_dataSourceArr.count <= 0){
            return;
        }
        DDIndustryDynamicListModel *model=_dataSourceArr[indexPath.section];
        
        DDIndustryDynamicDetailVC *industryDynamicDetail=[[DDIndustryDynamicDetailVC alloc]init];
        industryDynamicDetail.hidesBottomBarWhenPushed=YES;
        industryDynamicDetail.docId=model.doc_id;
        industryDynamicDetail.titleStr=model.title;
        [self.navigationController pushViewController:industryDynamicDetail animated:NO];
    }
    else{
        if(_dataSourceArray.count <= 0){
            return;
        }
        DDMySuperVisionDynamicListModel *model=_dataSourceArray[indexPath.section];
        if (![model.isReaded isEqualToString:@"1"]) {
            [self readOneItem:indexPath];
        }
        //处理跳转（我的监控的跳转）
        DDNewsJumpManager * newsJumpManager = [[DDNewsJumpManager alloc] init];
        newsJumpManager.mainViewContoller = self;
        newsJumpManager.model2 = model;
        [newsJumpManager handleJump];
    }
}

#pragma mark 阅读单条记录
-(void)readOneItem:(NSIndexPath *)indexPath{
    DDMySuperVisionDynamicListModel *model=_dataSourceArray[indexPath.section];
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:1];
    [params setValue:model.id forKey:@"id"];
    
    [[DDHttpManager sharedInstance]sendPostRequest:KHttpRequest_monitorReadOne params:params success:^(NSURLSessionDataTask *operation, id responseObject){
//        NSLog(@"阅读单条监控消息数据:%@",responseObject);
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {

            model.isReaded=@"1";
            [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    } failure:^(NSURLSessionDataTask *operation, id responseObject) {
    }];
}
-(void)readOneItemIndex:(NSInteger)indexPath{
    DDMyMonitorLoopsListModel *model=_monitorLoopsArr[indexPath];
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:1];
    [params setValue:model.id forKey:@"id"];
    
    [[DDHttpManager sharedInstance]sendPostRequest:KHttpRequest_monitorReadOne params:params success:^(NSURLSessionDataTask *operation, id responseObject){
//        NSLog(@"阅读单条监控消息数据:%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            model.isReaded=@"1";
        }
    } failure:^(NSURLSessionDataTask *operation, id responseObject) {
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_isIndustryClick isEqualToString:@"1"]) {
        DDIndustryDynamicListModel *model=_dataSourceArr[indexPath.section];
        if([model.title_type isEqualToString:@"2"]){//单张图片
            return 112+30;
        }
        else if([model.title_type isEqualToString:@"3"]){//多张图片
            return [DDLabelUtil getSpaceLabelHeightWithString:model.title font:kFontSize34 width:(Screen_Width-34)]+75+88;
        }
        else{//纯文本
            return [DDLabelUtil getSpaceLabelHeightWithString:model.title font:kFontSize34 width:(Screen_Width-34)]+75;
        }
    }
    else{
        DDMySuperVisionDynamicListModel *model=_dataSourceArray[indexPath.section];
        model.mainType = [NSString stringWithFormat:@"%@",model.mainType];
        if ([model.mainType isEqualToString:@"6"]) {//半日报
            if(model.lineSplited.count>3){
                return 12+24+12+4*25+12;
            }
            return 12+24+12+model.lineSplited.count*25+12;
        }
        else{
            CGFloat infoH = 0;
            if([model.typeCode isEqualToString:@"SCE_001"]){
                infoH = 20;
            }else {
                infoH = 0;
            }
            if ([model.subType integerValue] == 2) {
                if ([model.mainType integerValue] == 5) {
                    
                    if(![DDUtils isEmptyString:model.lineB]){
                        NSString *nameStr = model.lineB;
                        if ([model.lineBString.string hasPrefix:@"中标:"]) {
                            nameStr = [NSString stringWithFormat:@"中标:%@",nameStr];
                        }
                    
                        CGSize labelSize = [[NSString stringWithFormat:@"%@",nameStr] boundingRectWithSize:CGSizeMake(Screen_Width-20, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:kFontSize28} context:nil].size;
                        return labelSize.height+125+infoH;
                    }else{
                        if(![DDUtils isEmptyString:model.lineC]){
                            CGSize labelSize = [[NSString stringWithFormat:@"%@",model.lineC] boundingRectWithSize:CGSizeMake(Screen_Width-20, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:kFontSize28} context:nil].size;
                            return labelSize.height+105+infoH;
                        }
                    }
                }else{
                    if ([DDUtils isEmptyString:model.lineB]) {
                        if(![DDUtils isEmptyString:model.lineC]){
                            CGSize labelSize = [[NSString stringWithFormat:@"%@",model.lineC] boundingRectWithSize:CGSizeMake(Screen_Width-160, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:kFontSize28} context:nil].size;
                            return labelSize.height+120+infoH;
                        }
                    }else{
                        if(![DDUtils isEmptyString:model.lineB]){
                            NSString *nameStr = model.lineB;
                            if ([model.lineBString.string hasPrefix:@"中标:"]) {
                                nameStr = [NSString stringWithFormat:@"中标:%@",nameStr];
                            }
                            
                            
                            CGSize labelSize = [[NSString stringWithFormat:@"%@",nameStr] boundingRectWithSize:CGSizeMake(Screen_Width-20, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:kFontSize28} context:nil].size;
                            return labelSize.height+125+infoH;
                        }
                    }
                }
            }else{
                CGFloat labelH = 0;
                if(![DDUtils isEmptyString:model.lineB]){
                    NSString *nameStr = model.lineB;
                    if ([model.lineBString.string hasPrefix:@"中标:"]) {
                        nameStr = [NSString stringWithFormat:@"中标:%@",nameStr];
                    }
                    CGSize labelSize = [[NSString stringWithFormat:@"%@",nameStr] boundingRectWithSize:CGSizeMake(Screen_Width-20, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:kFontSize28} context:nil].size;
                    labelH = labelSize.height;
                }
                if(![DDUtils isEmptyString:model.lineC]){
                    CGSize labelSize = [[NSString stringWithFormat:@"%@",model.lineC] boundingRectWithSize:CGSizeMake(Screen_Width-20, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:kFontSize28} context:nil].size;
                    return labelSize.height+105+infoH+labelH;
                }
            }
            return 110+infoH;
        }
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if ([_isIndustryClick isEqualToString:@"1"]) {
        if (section == 0) {
            if(isShowUpdate){
                UIView *headV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, WidthByiPhone6(30))];
                _updateNumL = [UILabel labelWithFont:kFontSize28 textString:[NSString stringWithFormat:@"已更新%ld条内容",(long)updateNumCount] textColor:kColorBlue textAlignment:NSTextAlignmentCenter numberOfLines:1];
                _updateNumL.backgroundColor = [UIColor hexStringToColor:@"#cce4fe"];
                _updateNumL.frame = CGRectMake(0, 0, Screen_Width, WidthByiPhone6(30));
                [headV addSubview:_updateNumL];
                [self performSelector:@selector(delayMethod) withObject:nil afterDelay:2.0];
                return headV;
            }
            return nil;
        }
        return nil;
    }
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(_dataSourceArr.count == 0){
        return nil;
    }
    if ([_isIndustryClick isEqualToString:@"1"]) {
        DDIndustryDynamicListModel *model=_dataSourceArr[section];
        
        UIView *footerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 51)];
        footerView.backgroundColor=kColorWhite;
        
        UILabel *lab1=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, Screen_Width/3, 41)];
        if ([DDUtils isEmptyString:model.reading_quantity]) {
            lab1.text=@"";
        }
        else if([model.reading_quantity isEqualToString:@"0"]){
            
            lab1.text=[NSString stringWithFormat:@"阅读 %@",model.reading_quantity];
            
        }
        else{
            lab1.text=[NSString stringWithFormat:@"阅读 %@",[self readingForString:model.reading_quantity]];
        }
        lab1.textColor=KColorBlackSecondTitle;
        lab1.font=kFontSize28;
        lab1.textAlignment=NSTextAlignmentCenter;
        [footerView addSubview:lab1];
        
        UILabel *greyL=[[UILabel alloc]initWithFrame:CGRectMake(0, 41, Screen_Width, 10)];
        greyL.backgroundColor = kColorBackGroundColor;
        [footerView addSubview:greyL];
        
        UIButton *btn2=[[UIButton alloc]initWithFrame:CGRectMake(Screen_Width/3, 0, Screen_Width/3, 41)];
        UIImageView *imgView1=[[UIImageView alloc]initWithFrame:CGRectMake((Screen_Width/3-15-5-50)/2, 13, 15, 15)];
        if ([model.isThumbUp isEqualToString:@"1"]) {
            imgView1.image=[UIImage imageNamed:@"home_thumbUp"];
        }
        else{
            imgView1.image=[UIImage imageNamed:@"home_thumbDown"];
        }
        [btn2 addSubview:imgView1];
        UILabel *countLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imgView1.frame)+5, 0, 50, 41)];
        if ([model.count isEqualToString:@"0"] || [DDUtils isEmptyString:model.count]) {
            countLab.text=@"点赞";
        }
        else{
         countLab.text=model.count;
        }
        countLab.textColor=KColorBlackSecondTitle;
        countLab.font=kFontSize28;
        [btn2 addSubview:countLab];
        btn2.tag=section;
        [btn2 addTarget:self action:@selector(thumbUpClick:) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:btn2];
        
        
        UIButton *btn3=[[UIButton alloc]initWithFrame:CGRectMake(Screen_Width/3*2, 0, Screen_Width/3, 41)];
        UIImageView *imgView2=[[UIImageView alloc]initWithFrame:CGRectMake((Screen_Width/3-15-5-50)/2, 13, 15, 15)];
        imgView2.image=[UIImage imageNamed:@"finding_share"];
        [btn3 addSubview:imgView2];
        UILabel *shareLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imgView2.frame)+5, 0, 50, 41)];
        shareLab.text=@"转发";
        shareLab.textColor=KColorBlackSecondTitle;
        shareLab.font=kFontSize28;
        [btn3 addSubview:shareLab];
        btn3.tag=section;
        [btn3 addTarget:self action:@selector(transmitClick:) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:btn3];
        
        return footerView;
    }
    else{
        return nil;
    }
}
- (NSString *)readingForString:(NSString *)string
{
    if (string.length>5) {
        CGFloat intss = [string floatValue];
        intss = intss/100000.0;
        return [NSString stringWithFormat:@"%.1f万+",intss];
    }else if (string.length>4){
        CGFloat intss = [string floatValue];
        intss = intss/10000.0;
        return [NSString stringWithFormat:@"%.1f万+",intss];

    }
    
    return string;
}
#pragma mark 点赞点击事件
-(void)thumbUpClick:(UIButton *)sender{
    sender.userInteractionEnabled = NO;
    DDUserManager * userManger = [DDUserManager sharedInstance];
    if ([DDUtils isEmptyString:userManger.userid]) {
        sender.userInteractionEnabled = YES;
        [self presentLoginVC];
    }
    else{
        DDIndustryDynamicListModel *model=_dataSourceArr[sender.tag];
        
        if ([model.isThumbUp isEqualToString:@"1"]) {
            sender.userInteractionEnabled = YES;
            [DDUtils showToastWithMessage:@"您已点过赞"];
        }
        else{
            NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:1];
            [params setValue:model.doc_id forKey:@"docId"];
            
            [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_dynamicsThumbUp params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
//                NSLog(@"点赞数据:%@",responseObject);
                DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
               sender.userInteractionEnabled = YES;
                if (response.isSuccess) {
                    
                    model.isThumbUp=@"1";
                    model.count=[NSString stringWithFormat:@"%ld",model.count.integerValue+1];
                    //[_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:sender.tag]] withRowAnimation:UITableViewRowAnimationNone];
                    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:sender.tag] withRowAnimation:UITableViewRowAnimationNone];
                }
            } failure:^(NSURLSessionDataTask *operation, id responseObject) {
                sender.userInteractionEnabled = YES;
            }];
        }
    }
}

#pragma mark 转发点击事件
-(void)transmitClick:(UIButton *)sender{
    DDUserManager * userManger = [DDUserManager sharedInstance];
    if ([DDUtils isEmptyString:userManger.userid]) {
        [self presentLoginVC];
    }
    else{
        DDIndustryDynamicListModel *model=_dataSourceArr[sender.tag];
        
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
                _messageController.body = [NSString stringWithFormat:@"%@http://m.koncendy.com/pages/IndustryDetails/main?hideTop=1&doc_id=%@",model.share_title,model.doc_id];
                // 设置代理
                _messageController.messageComposeDelegate = self;
                // 显示控制器
                [self presentViewController:_messageController animated:YES completion:nil];
            }else{
                UMShareWebpageObject * shareObject = [UMShareWebpageObject shareObjectWithTitle:model.title descr:model.share_title thumImage:[UIImage imageNamed:@"share_logo"]];
                
                //设置网页地址
                shareObject.webpageUrl =[NSString stringWithFormat:@"https://gcdd.koncendy.com/gcdd-mobile/#/pages/IndustryDetails/main?doc_id=%@",model.doc_id];
                
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
//    if(result == MessageComposeResultCancelled) {
//        NSLog(@"取消发送");
//    }
//    else if(result == MessageComposeResultSent) {
//        NSLog(@"发送成功");
//    }
//    else {
//        NSLog(@"发送失败");
//    }
}

- (void)cancelSendSMSClick{
    [_messageController dismissViewControllerAnimated:YES completion:nil];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if ([_isIndustryClick isEqualToString:@"1"]) {
        if (section == 0) {
            if (isShowUpdate) {
                return WidthByiPhone6(30);
            }
            return CGFLOAT_MIN;
        }
        return CGFLOAT_MIN;
    }
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if ([_isIndustryClick isEqualToString:@"1"]) {
        return 51;
    }
    else{
        return 10;
    }
}

#pragma mark ScrollViewDelegate滚动视图回调方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _tableView) {
        CGFloat y = scrollView.contentOffset.y;
        _yy = scrollView.contentOffset.y;
        UITabBarItem *item = [self.tabBarController.tabBar.items objectAtIndex:0];
        if (y>Screen_Height) {
            item.image = [[UIImage imageNamed:@"fanhuidingbu"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            
            item.selectedImage = [[UIImage imageNamed:@"fanhuidingbu"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            item.title = @"回到顶部";
        }else if (y<=Screen_Height&&y>0) {
            item.image = [[UIImage imageNamed:@"tab_home_gray"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            
            item.selectedImage = [[UIImage imageNamed:@"tab_home_blue"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            item.title = @"查询";
        }
        
        
        CGRect frame = _topImage.frame;
        _bgView1.hidden=NO;
        [_bgView3 removeFromSuperview];
        _newTopImgView.hidden=NO;
        if (y > self.offset) {//向上拉
            _topImage.frame=CGRectMake(0, 0, Screen_Width, topViewHeight);
            CGRect frame = _topImage.frame;
            if (y>0 || y==0) {
                _bgView1.hidden=YES;
                _newTopImgView.hidden=YES;
                [self.navigationController.navigationBar addSubview:_bgView3];
                _bgView3.hidden = NO;
                frame.origin.y = self.offset;
                _topImage.frame = frame;
//                CGRect HeaderFrame = _bigHeaderView.frame;
//                _bigHeaderView.frame = CGRectMake(0, CGRectGetMaxY(frame), HeaderFrame.size.width, HeaderFrame.size.height);
            }
            else{
                frame.origin.y = self.offset-y;
                _topImage.frame = frame;
//                CGRect HeaderFrame = _bigHeaderView.frame;
//                _bigHeaderView.frame = CGRectMake(0, CGRectGetMaxY(frame), HeaderFrame.size.width, HeaderFrame.size.height);
            }
        }
        else if (self.offset == 0){//tableView设置偏移时不能立马获取他的偏移量，所以一开始获取的offset值为0
            return;
        }
        else {//向下拉
            CGFloat x = self.offset - y;
            frame = CGRectMake(-x/2, -x/2, Screen_Width + x, topViewHeight+x);
            _topImage.frame = frame;
//            CGRect HeaderFrame = _bigHeaderView.frame;
//            _bigHeaderView.frame = CGRectMake(0, CGRectGetMaxY(frame), HeaderFrame.size.width, HeaderFrame.size.height);
            _bgView1.frame=CGRectMake(12+x/2, _topImage.size.height-47, Screen_Width-24, 47);
            _newTopImgView.frame=CGRectMake((Screen_Width-157)/2+x/2, CGRectGetMinY(_bgView1.frame)-38-44, 157, 44);
            //_QRCodeBtn.frame=CGRectMake(_topImage.size.width-40-x/2, CGRectGetMinY(_titleLabel.frame)-10-20, 20, 20);
        }
    }
}

#pragma mark ***********************************业务分割线*************************************
#pragma mark ***********************************业务分割线*************************************

#pragma mark SGAdvertScrollViewDelegate新轮播图代理方法
-(void)advertScrollView:(SGAdvertScrollView *)advertScrollView didSelectedItemAtIndex:(NSInteger)index{
    DDMyMonitorLoopsListModel *model=_monitorLoopsArr[index];
    if (![model.isReaded isEqualToString:@"1"]) {
        [self readOneItemIndex:index];
    }
    //处理跳转（我的监控的跳转）
    DDNewsJumpManager * newsJumpManager = [[DDNewsJumpManager alloc] init];
    newsJumpManager.mainViewContoller = self;
    newsJumpManager.model3 = model;
    [newsJumpManager handleJump];
}

#pragma mark 弹出登录注册页面，跳转到扫码登录页面
- (void)presentLoginVCAndCodeScan{
    __weak __typeof(self) weakSelf=self;
    
    DDLoginCheckVC * vc = [[DDLoginCheckVC alloc] init];
    vc.loginSuccessBlock = ^{
        //[weakSelf requestTypesData];
        NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
        if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"应用相机权限受限,请在设置中启用" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction * actionCancel = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }
                
            }];
            
            UIAlertAction * actionReStart = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertController addAction:actionCancel];
            [alertController addAction:actionReStart];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        else{
            DDQRCodeScanVC *QRCodeScan = [[DDQRCodeScanVC alloc] init];
            QRCodeScan.hidesBottomBarWhenPushed=YES;
            [weakSelf.navigationController pushViewController:QRCodeScan animated:YES];
        }
        
        //DDQRCodeScanVC *QRCodeScan = [[DDQRCodeScanVC alloc] init];
        //QRCodeScan.hidesBottomBarWhenPushed=YES;
        //[weakSelf.navigationController pushViewController:QRCodeScan animated:YES];
    };
    
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [DDNavigationUtil setNavigationAndBottomLineWhiteColor:nav];
    [self showViewController:nav sender:nil];
}

#pragma mark 弹出登录注册页面，跳转到全部分类页面
- (void)presentLoginVC{
    DDLoginCheckVC * vc = [[DDLoginCheckVC alloc] init];
    vc.loginSuccessBlock = ^{
        if ([_isIndustryClick isEqualToString:@"2"]) {
            if (![DDUtils isEmptyString:[DDUserManager sharedInstance].userid]) {
                _isIndustryClick = @"1";
                [self mySuperVisionClick];
            }
        }
        if (_monitorLoopsArr.count==0) {
            [self requestNewsData];
        }
    };
    
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [DDNavigationUtil setNavigationAndBottomLineWhiteColor:nav];
    [self showViewController:nav sender:nil];
}

#pragma mark 弹出登录注册页面，跳转到公司详情页面
- (void)presentLoginVCWithBtn:(UIButton *)btn{
  __weak __typeof(self) weakSelf=self;
    DDLoginCheckVC * vc = [[DDLoginCheckVC alloc] init];
    vc.loginSuccessBlock = ^{
        //发出登录成功通知
        //[weakSelf requestTypesData];
        
        DDHotSearchModel *model=_showedHotWordsArr[btn.tag-50];
        //[DDUtils showToastWithMessage:[NSString stringWithFormat:@"搜索词是：%@，type是：%@",model.searchTitle,model.searchType]];
        DDCompanyDetailVC *companyDetail=[[DDCompanyDetailVC alloc]init];
        companyDetail.enterpriseId=model.enterpriseId;
        companyDetail.hidesBottomBarWhenPushed=YES;
        [weakSelf.navigationController pushViewController:companyDetail animated:NO];
    };
    
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [DDNavigationUtil setNavigationAndBottomLineWhiteColor:nav];
    [self showViewController:nav sender:nil];
}

#pragma mark ***********************************业务分割线*************************************
#pragma mark ***********************************业务分割线*************************************
#pragma mark 版本更新
-(void)checkNewVersion{
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_checkAppVer params:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
//        NSLog(@"版本更新返回值:%@",responseObject);
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            
            if ([response.data isKindOfClass:[NSDictionary class]]) {
                DDCheckAppVerModel * model = [[DDCheckAppVerModel alloc]initWithDictionary:response.data error:nil];
                NSString *areaVer = [[NSUserDefaults standardUserDefaults] objectForKey:@"areaVer"];
                if ([DDUtils isEmptyString:areaVer]) {
                    [self downloadAreaJsonWithUrl:model.areaUrl areaVer:model.areaVer];
                }else {
                    if (![areaVer isEqualToString:model.areaVer] ) {
                        [self downloadAreaJsonWithUrl:model.areaUrl areaVer:model.areaVer];
                    }
                }
                
                
                
                NSString * newVersionString = model.verName;
                NSString * currentVerString = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"];;
                
                CGFloat newVersion =  [DDSystem versionFloatValue:newVersionString];
                CGFloat currentVersion = [DDSystem versionFloatValue:currentVerString];
                
                if (newVersion > currentVersion) {
                    //新版本>当前版本,需要更新
                    if ([model.must isEqualToString:@"1"]) {
                        //强制更新
                        [self forceUpdateWithAppVersionModel:model];
                    }else{
                        //普通更新
                        [self generalUpdateWithAppVersionModel:model];
                    }
                }
                
            }
        }
    } failure:^(NSURLSessionDataTask *operation, id responseObject) {
    }];
}
- (void)downloadAreaJsonWithUrl:(NSString *)url areaVer:(NSString *)areaVer{
    NSURL *jsonUrl = [NSURL URLWithString:url];
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
    NSURLRequest *request = [NSURLRequest requestWithURL:jsonUrl];
    NSURLSessionDownloadTask *download = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        //监听下载进度
        //completedUnitCount 已经下载的数据大小
        //totalUnitCount     文件数据的中大小
        NSLog(@"%f",1.0 *downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        /**
         * 1:1：请求路径：NSUrl *url = [NSUrl urlWithString:path];从网络请求路径  2：把本地的file文件路径转成url，NSUrl *url = [NSURL fileURLWithPath:fullPath]；
         2：返回值是一个下载文件的路径
         *
         */
        NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:response.suggestedFilename];
        
        NSLog(@"targetPath:%@",targetPath);
        NSLog(@"fullPath:%@",fullPath);
        
        return [NSURL fileURLWithPath:fullPath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        [[NSUserDefaults standardUserDefaults] setObject:areaVer forKey:@"areaVer"];
        /**
         *filePath:下载后文件的保存路径
         */
        NSLog(@"%@",filePath);
    }];
    
    //3.执行Task
    [download resume];
}
//强制更新
- (void)forceUpdateWithAppVersionModel:(DDCheckAppVerModel*)model{
    
   NSString *strUrl = [model.summary stringByReplacingOccurrencesOfString:@"；" withString:@"；\n"];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"版本过旧，已影响使用，请更新！" message:strUrl preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"去升级" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.url]];
        
        return;
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        exit(0);
        return;
    }];
    [alert addAction:sure];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}
//普通更新
- (void)generalUpdateWithAppVersionModel:(DDCheckAppVerModel*)model{
    NSString * title = [NSString stringWithFormat:@"版本更新V%@",model.verName];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:model.summary preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"去升级" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.url]];
        
        return;
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        return;
    }];
    [alert addAction:sure];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}
//#pragma mark --监控网络情况
//- (void)initReachability{
//    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
//    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//        switch (status) {
//            case AFNetworkReachabilityStatusUnknown:
//                //未知网络
//                break;
//            case AFNetworkReachabilityStatusNotReachable:{
//                //没有网络(断网)
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:KMainNetWorkError delegate:nil cancelButtonTitle:nil otherButtonTitles:KMainOk, nil];
//                    [alertView show];
//                });
//            }
//                break;
//            case AFNetworkReachabilityStatusReachableViaWWAN:
//                //手机自带网络
//                break;
//            case AFNetworkReachabilityStatusReachableViaWiFi:
//                //WIFI
//                break;
//        }
//    }];
//    //开始监控
//    [manager startMonitoring];
//}
-(void)itemAction:(NSNotification *)notification{
    NSDictionary *dict = notification.userInfo;
    if (_monitorLoopsArr.count==0) {
        [self requestNewsData];
    }
    if ([dict[@"name"] isEqualToString:@"查询"]) {
        [self startLocation];
    }else{
        if ([_isIndustryClick isEqualToString:@"2"]){
            if (_dataSourceArray.count>0) {
                NSIndexPath* indexPat = [NSIndexPath indexPathForRow:0 inSection:0];
                [self.tableView scrollToRowAtIndexPath:indexPat atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
            [self dynamicBtnClick];
        }else{
            if (_dataSourceArr.count>0) {
                NSIndexPath* indexPat = [NSIndexPath indexPathForRow:0 inSection:0];
                [self.tableView scrollToRowAtIndexPath:indexPat atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
        }
    }
}
-(void)itemReAction:(NSNotification *)notification{
    NSDictionary *dict = notification.userInfo;
    if ([dict[@"name"] isEqualToString:@"回到顶部"]) {
        UITabBarItem *item = [self.tabBarController.tabBar.items objectAtIndex:0];
        item.image = [[UIImage imageNamed:@"tab_home_gray"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        item.selectedImage = [[UIImage imageNamed:@"tab_home_blue"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item.title = @"查询";
        NSIndexPath* indexPat = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPat atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}

#pragma mark dealloc取消通知建观察者
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:KLoginSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:KMyVisionRedPointNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:KLogOutNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"ItemDidClickNotification" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"ItemReDidClickNotification" object:nil];
}

-(NSMutableArray *)dataSourceArray{
    if (!_dataSourceArray) {
        _dataSourceArray = [[NSMutableArray alloc]init];
    }
    return _dataSourceArray;
}
-(NSMutableArray *)requestUrlArray {
    if (!_requestUrlArray) {
        _requestUrlArray = [[NSMutableArray alloc]init];
    }
    return _requestUrlArray;
}

@end


