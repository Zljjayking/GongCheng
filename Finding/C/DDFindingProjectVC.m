//
//  DDFindingProjectVC.m
//  GongChengDD
//
//  Created by xzx on 2018/11/2.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDFindingProjectVC.h"
#import "MJRefresh.h"
#import "DDNavigationUtil.h"
#import "DDLoginCheckVC.h"//登录注册页面
#import "DataLoadingView.h"//加载页面
#import "DDNoResultView.h"//无数据视图
#import "DDSearchProjectListModel.h"//model

#import "DDNewFindingWinBiddingProjectCell.h"
#import "DDSearchHistoryDAOAndDB.h"//搜索历史数据库操作类
#import "DDProjectDetailVC.h"//项目详情页面
#import "DDCompanyDetailVC.h"//公司详情页面

#import "DDAreaSelectTableView.h"//市的选择View
#import "DDFindingCallBiddingMoneySelectView.h"//金额选择页面
#import "DDFindingCallBiddingProjectTypeSelectView.h"//工程类别选择视图
#import "DDFindingWinBiddingDateSelectView.h"//中标时间选择视图

#import "DDProjectSubscribeBenefitVC.h"//中标监控好处页面
#import "DDProjectSubscribeVC.h"//中标监控页面
#import "DDTalentSubscribeDetailModel.h"//人才订阅详情信息model
#import <BMKLocationkit/BMKLocationComponent.h>//百度地图定位
@interface DDFindingProjectVC ()<UITableViewDelegate,UITableViewDataSource,AreaSelectTableViewDelegate,UITabBarControllerDelegate,DDFindingCallBiddingProjectTypeSelectViewDelegate,DDFindingWinBiddingDateSelectViewDelegate,DDFindingCallBiddingMoneySelectViewDelegate,BMKLocationManagerDelegate>
{
    NSInteger currentPage;
    NSInteger pageCount;
    NSMutableArray *_dataSourceArr;
    NSMutableDictionary *_dict;
    
    
    UILabel *_leftLab;//"搜索到"三个字的label
    UILabel *_numLabel;//总计数量label
    UILabel *_rightLab;//"个公司"三个字的label
    UILabel *_numLabel2;
    UILabel *_rightLab2;
    
    BOOL _isCitySelected;//判断是否点开了城市选择视图
    BOOL _isProjectTypeSelected;//判断是否点开了工程类别选择视图
    BOOL _isMoneySelected;//判断是否点开了金额筛选视图
    BOOL _isDateSelected;//判断是否点开了中标时间筛选视图
    BOOL isLastData;
    
    NSString *_firstLocaStr;
    NSString *_region;//地区筛选
    NSInteger projectSelect;
    NSString *_projectTypeId;//工程类别筛选
    NSString *_projectTypeStr;//工程类别筛选
    NSString *_amount;//金额筛选
    NSString *_date;//中标时间筛选
    NSString *_moneyId;//用来金额高亮显示用
}
@property (nonatomic,strong) BMKLocationManager *baiduLocationManager;//百度定位
@property (nonatomic,strong) DataLoadingView *loadingView;
@property (nonatomic,strong) DDNoResultView *noResultView;//无数据视图
@property (nonatomic,strong) UIImageView *imgView1;//放左边那个城市选择小箭头
@property (nonatomic,strong) DDAreaSelectTableView *areaSelectTableView;//区域筛选视图
@property (nonatomic,strong) UIImageView *imgView2;//放中间那个工程类别选择小箭头
@property (nonatomic,strong) DDFindingCallBiddingProjectTypeSelectView *projectTypeSelectView;//工程类别筛选视图
@property (nonatomic,strong) UIImageView *imgView3;//放中间那个金额选择小箭头
@property (nonatomic,strong) DDFindingCallBiddingMoneySelectView *moneySelectView;//金额筛选视图
@property (nonatomic,strong) UIImageView *imgView4;//放右边那个中标时间选择小箭头
@property (nonatomic,strong) DDFindingWinBiddingDateSelectView *dateSelectView;//中标时间筛选视图
@property (nonatomic, strong) UILabel *label1;//放左边那个城市选择文字
@property (nonatomic, strong) UILabel *label2;//放中间那个工程类别选择文字
@property (nonatomic, strong) UILabel *label3;//放中间那个金额选择文字
@property (nonatomic, strong) UILabel *label4;//放右边那个中标时间选择文字

@end

@implementation DDFindingProjectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=kColorBackGroundColor;
    _amount=@"";//金额筛选
    projectSelect=0;
    _projectTypeId=@"";
    _projectTypeStr=@"";
    _date=@"";
    _moneyId=@"0";
    _isCitySelected=NO;
    _isProjectTypeSelected=NO;
    _isMoneySelected=NO;
    _isDateSelected=NO;
    _dataSourceArr=[[NSMutableArray alloc]init];
    //    [self editNavItem];
    [self createChooseBtns];
    [self createTableView];
    [self createProjectSubscribeBtn];
    [self createLoadView];
}
-(void)justicePower{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status){
        //定位不能用
        _region=@"";
        [self requestData:YES andClear:YES];
    } else {
        //定位功能可用,开始定位
        [self startLocation];
    }
}
#pragma mark 收到切换tab信息

-(void)viewWillDidCurrentView{
    _label1.textColor = KColorBlackTitle;
    _label2.textColor = KColorBlackTitle;
    _label3.textColor = KColorBlackTitle;
    _label4.textColor = KColorBlackTitle;
    [_loadingView showLoadingView];
    [self justicePower];
}

#pragma mark 创建加载视图
-(void)createLoadView{
    __weak __typeof(self) weakSelf=self;
    _noResultView=[[DDNoResultView alloc]initWithFrame:CGRectMake(0, 39, Screen_Width, Screen_Height-KNavigationBarHeight-39-KTabbarHeight)];
    [self.view addSubview:_noResultView];
    [_noResultView hiddenNoDataView];
    
    _loadingView = [[DataLoadingView alloc] initWithController:self];
    _loadingView.loadingTitle = KLoading;
    _loadingView.failureTitle = KLoadingFailure;
    _loadingView.reloadHandle = ^(void){
        [weakSelf requestData:YES andClear:YES];
    };
    [_loadingView showLoadingView];
}

#pragma mark 请求数据
- (void)requestData:(BOOL)isrefresh  andClear:(BOOL)isclear{
    if (isclear==YES) {
        [_dataSourceArr removeAllObjects];
        if (_tableView.mj_footer) {
            [_tableView.mj_footer removeFromSuperview];
            _tableView.mj_footer = nil;
        }
        [self.tableView reloadData];
        [_loadingView showLoadingView];
    }
    if (isrefresh) {
        currentPage = 1;
    }
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:@"3" forKey:@"searchType"];
    [params setValue:@"3" forKey:@"flag"];
    [params setValue:_region forKey:@"region"];
    [params setValue:_projectTypeStr forKey:@"projectType"];
    [params setValue:_amount forKey:@"amount"];
    [params setValue:_date forKey:@"date"];
    [params setValue:[NSString stringWithFormat:@"%ld",currentPage] forKey:@"page"];
    [params setValue:@"10" forKey:@"rows"];
    [[DDHttpManager sharedInstance]sendPostRequest:KHttpRequest_queryHighLightList params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
//        NSLog(@"**********中标库查找结果数据***************%@",responseObject);
        [_loadingView hiddenLoadingView];
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            if (![response isEmpty]) {
                currentPage += 1;
                if (isrefresh==YES) {
                    [_dataSourceArr removeAllObjects];
                    if (self.tableView.mj_footer) {
                        [self.tableView.mj_footer resetNoMoreData];
                    }
                }
                _dict = responseObject[KData];
                pageCount = [_dict[@"numFound"] integerValue];
                NSArray *listArr=_dict[@"result"];
                
                //给数量label赋值
                NSString *totlaNum=[NSString stringWithFormat:@"%@",_dict[@"numFoundCount"]];
                _numLabel.text=totlaNum;
                CGRect numberFrame = [totlaNum boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
                _numLabel.frame=CGRectMake(CGRectGetMaxX(_leftLab.frame)+2, 12, numberFrame.size.width, 15);
                CGRect textFrame = [@"个中标，当前区域共有" boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize26} context:nil];
                _rightLab.frame=CGRectMake(CGRectGetMaxX(_numLabel.frame), 12, textFrame.size.width, 15);
                
                NSString *totlaNum2=[NSString stringWithFormat:@"%@",_dict[@"numFound"]];
                _numLabel2.text=totlaNum2;
                CGRect numberFrame2 = [totlaNum2 boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
                _numLabel2.frame=CGRectMake(CGRectGetMaxX(_rightLab.frame)+2, 12, numberFrame2.size.width, 15);
                _rightLab2.frame=CGRectMake(CGRectGetMaxX(_numLabel2.frame), 12, 45, 15);
                
                
                if ([_region isEqualToString:@""]) {
                    _rightLab.text=@"个中标";
                    _numLabel2.hidden=YES;
                    _rightLab2.hidden=YES;
                }
                else{
                    _rightLab.text=@"个中标，当前区域共有";
                    _numLabel2.hidden=NO;
                    _rightLab2.hidden=NO;
                }
                
                
                if (listArr.count!=0) {
                    [_noResultView hiddenNoDataView];
                    for (NSDictionary *dic in listArr) {
                        DDSearchProjectListModel *model = [[DDSearchProjectListModel alloc]initWithDictionary:dic error:nil];
                        [model handle];
                        [_dataSourceArr addObject:model];
                    }
                    if (_dataSourceArr.count<pageCount) {
                        isLastData = NO;
                    }else{
                        isLastData = YES;
                    }
                }
                else{
                    isLastData = YES;
                    [_noResultView showNoResultViewWithTitle:@"项目信息" andImage:@"noResult_project"];
                }
            }
            else{
                isLastData = YES;
                [_noResultView showNoResultViewWithTitle:@"项目信息" andImage:@"noResult_project"];
            }
            [self.tableView reloadData];
            [self endRefrshing:YES];
        }
        else{
            [self endRefrshing:NO];
            [_noResultView showNoResultViewWithTitle:@"项目信息" andImage:@"noResult_project"];
        }
    }  failure:^(NSURLSessionDataTask *operation, id responseObject)  {
        [self endRefrshing:NO];
        [DDUtils showToastWithMessage:kRequestFailed];
        [_loadingView failureLoadingView];
    }];
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
                    [self requestData:NO andClear:NO];
                }];
            }
            else if (isLastData == YES && !self.tableView.mj_footer)
            {
                return;
            }
            else if(isLastData == YES && self.tableView.mj_footer)
            {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                self.tableView.mj_footer = nil;
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

#pragma mark 创建筛选按钮
-(void)createChooseBtns{
    //地区选择按钮
    UIButton *areaSelectBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, Screen_Width/4, 39)];
    [areaSelectBtn setBackgroundColor:kColorWhite];
    
    _label1=[[UILabel alloc]init];
    DDUserManager *manager=[DDUserManager sharedInstance];
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status){
        //定位不能用
        _label1.text=@"全国";
    }
    else{
        if (![DDUtils isEmptyString:manager.city]) {
            _label1.text=manager.city;
        }
        else{
            _label1.text=@"全国";
        }
    }
    
    _label1.textColor=KColorBlackTitle;
    _label1.font=kFontSize28;
    [areaSelectBtn addSubview:_label1];
    
    _imgView1=[[UIImageView alloc]init];
    _imgView1.contentMode = UIViewContentModeScaleAspectFit;
    _imgView1.image=[UIImage imageNamed:@"home_search_down"];
    [areaSelectBtn addSubview:_imgView1];
    [areaSelectBtn addTarget:self action:@selector(areaSelectClick) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect leftTextFrame;
    if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status){
        //定位不能用
        leftTextFrame = [@"全国" boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize28} context:nil];
    }
    else{
        if (![DDUtils isEmptyString:manager.city]) {
            leftTextFrame = [manager.city boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize28} context:nil];
        }
        else{
            leftTextFrame = [@"全国" boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize28} context:nil];
        }
    }
    
    CGFloat leftWidth=leftTextFrame.size.width+4+15;
    if (leftWidth>=(Screen_Width/4-5)) {
        _label1.frame=CGRectMake(5, 12, (Screen_Width/4-5)-4-15, 15);
        _imgView1.frame=CGRectMake(CGRectGetMaxX(_label1.frame)+4, 12, 15, 15);
    }
    else{
        _label1.frame=CGRectMake((Screen_Width/4-leftWidth)/2, 12, leftWidth-4-15, 15);
        _imgView1.frame=CGRectMake(CGRectGetMaxX(_label1.frame)+4, 12, 15, 15);
    }
    
    [self.view addSubview:areaSelectBtn];
    
    //工程类别筛选按钮
    UIButton *projectTypeSelectBtn=[[UIButton alloc]initWithFrame:CGRectMake(Screen_Width/4, 0, Screen_Width/4, 39)];
    [projectTypeSelectBtn setBackgroundColor:kColorWhite];
    
    _label2=[[UILabel alloc]init];
    _label2.text=@"工程类别";
    _label2.textColor=KColorBlackTitle;
    _label2.font=kFontSize28;
    [projectTypeSelectBtn addSubview:_label2];
    
    _imgView2=[[UIImageView alloc]init];
    _imgView2.contentMode = UIViewContentModeScaleAspectFit;
    _imgView2.image=[UIImage imageNamed:@"home_search_down"];
    [projectTypeSelectBtn addSubview:_imgView2];
    [projectTypeSelectBtn addTarget:self action:@selector(projectTypeSelectClick) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect middle1TextFrame = [@"工程类别" boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize28} context:nil];
    CGFloat middle1Width=middle1TextFrame.size.width+4+15;
    if (middle1Width>=(Screen_Width/4-5)) {
        _label2.frame=CGRectMake(5, 12, (Screen_Width/4-5)-4-15, 15);
        _imgView2.frame=CGRectMake(CGRectGetMaxX(_label2.frame)+4, 12, 15, 15);
    }
    else{
        _label2.frame=CGRectMake((Screen_Width/4-middle1Width)/2, 12, middle1Width-4-15, 15);
        _imgView2.frame=CGRectMake(CGRectGetMaxX(_label2.frame)+4, 12, 15, 15);
    }
    
    [self.view addSubview:projectTypeSelectBtn];
    
    //金额筛选按钮
    UIButton *moneySelectBtn=[[UIButton alloc]initWithFrame:CGRectMake(Screen_Width/2, 0, Screen_Width/4, 39)];
    [moneySelectBtn setBackgroundColor:kColorWhite];
    
    _label3=[[UILabel alloc]init];
    _label3.text=@"金额筛选";
    _label3.textColor=KColorBlackTitle;
    _label3.font=kFontSize28;
    [moneySelectBtn addSubview:_label3];
    
    _imgView3=[[UIImageView alloc]init];
    _imgView3.contentMode = UIViewContentModeScaleAspectFit;
    _imgView3.image=[UIImage imageNamed:@"home_search_down"];
    [moneySelectBtn addSubview:_imgView3];
    [moneySelectBtn addTarget:self action:@selector(moneySelectClick) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect middle2TextFrame = [@"金额筛选" boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize28} context:nil];
    CGFloat middle2Width=middle2TextFrame.size.width+4+15;
    if (middle2Width>=(Screen_Width/4-5)) {
        _label3.frame=CGRectMake(5, 12, (Screen_Width/4-5)-4-15, 15);
        _imgView3.frame=CGRectMake(CGRectGetMaxX(_label3.frame)+4, 12, 15, 15);
    }
    else{
        _label3.frame=CGRectMake((Screen_Width/4-middle2Width)/2, 12, middle2Width-4-15, 15);
        _imgView3.frame=CGRectMake(CGRectGetMaxX(_label3.frame)+4, 12, 15, 15);
    }
    
    [self.view addSubview:moneySelectBtn];
    
    //中标时间筛选按钮
    UIButton *dateSelectBtn=[[UIButton alloc]initWithFrame:CGRectMake(Screen_Width/4*3, 0, Screen_Width/4, 39)];
    [dateSelectBtn setBackgroundColor:kColorWhite];
    
    _label4=[[UILabel alloc]init];
    _label4.text=@"中标时间";
    _label4.textColor=KColorBlackTitle;
    _label4.font=kFontSize28;
    [dateSelectBtn addSubview:_label4];
    
    _imgView4=[[UIImageView alloc]init];
    _imgView4.contentMode = UIViewContentModeScaleAspectFit;
    _imgView4.image=[UIImage imageNamed:@"home_search_down"];
    [dateSelectBtn addSubview:_imgView4];
    [dateSelectBtn addTarget:self action:@selector(dateSelectClick) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect rightTextFrame = [@"中标时间" boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize28} context:nil];
    CGFloat rightWidth=rightTextFrame.size.width+4+15;
    if (rightWidth>=(Screen_Width/4-5)) {
        _label4.frame=CGRectMake(5, 12, (Screen_Width/4-5)-4-15, 15);
        _imgView4.frame=CGRectMake(CGRectGetMaxX(_label4.frame)+4, 12, 15, 15);
    }
    else{
        _label4.frame=CGRectMake((Screen_Width/4-rightWidth)/2, 12, rightWidth-4-15, 15);
        _imgView4.frame=CGRectMake(CGRectGetMaxX(_label4.frame)+4, 12, 15, 15);
    }
    
    [self.view addSubview:dateSelectBtn];

    
    //搜索结果统计
    UIView *summaryView=[[UIView alloc]initWithFrame:CGRectMake(0, 39, Screen_Width, 39)];
    [self.view addSubview:summaryView];
    
    _leftLab=[[UILabel alloc]initWithFrame:CGRectMake(12, 12, 60, 15)];
    _leftLab.text=@"全国共有";
    _leftLab.textColor=KColorGreySubTitle;
    _leftLab.font=kFontSize26;
    [summaryView addSubview:_leftLab];
    
    _numLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_leftLab.frame)+2, 12, 1, 15)];
    _numLabel.text=@"";
    _numLabel.textColor=KColorBlackTitle;
    _numLabel.font=kFontSize26;
    [summaryView addSubview:_numLabel];
    
    CGRect textFrame = [@"个中标，当前区域共有" boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize26} context:nil];
    _rightLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_numLabel.frame)+2, 12, textFrame.size.width, 15)];
    _rightLab.text=@"个中标，当前区域共有";
    _rightLab.textColor=KColorGreySubTitle;
    _rightLab.font=kFontSize26;
    [summaryView addSubview:_rightLab];
    
    _numLabel2=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_rightLab.frame)+2, 12, 1, 15)];
    _numLabel2.text=@"";
    _numLabel2.textColor=KColorBlackTitle;
    _numLabel2.font=kFontSize26;
    [summaryView addSubview:_numLabel2];
    
    _rightLab2=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_numLabel2.frame)+2, 12, 45, 15)];
    _rightLab2.text=@"个中标";
    _rightLab2.textColor=KColorGreySubTitle;
    _rightLab2.font=kFontSize26;
    [summaryView addSubview:_rightLab2];
    
    
    _areaSelectTableView=[[DDAreaSelectTableView alloc]initWithFrame:CGRectMake(0, 39+60, Screen_Width, Screen_Height-KNavigationBarHeight-39-60)];
    _areaSelectTableView.isNeedArea = YES;
    if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status){
        //定位不能用
        
    }
    else{
        if (![DDUtils isEmptyString:manager.city]) {
            _areaSelectTableView.type=@"1";
        }
    }
    
    _areaSelectTableView.attachHeight=@"45";
    __weak __typeof(self) weakSelf=self;
    _areaSelectTableView.hiddenBlock = ^{
        weakSelf.imgView1.image=[UIImage imageNamed:@"home_search_down"];
        weakSelf.label1.textColor = KColorBlackTitle;
        //[weakSelf.areaSelectTableView hiddenActionSheet];
        [weakSelf.areaSelectTableView hidden];
        
        _isCitySelected=NO;
    };
    _areaSelectTableView.delegate=self;
    [_areaSelectTableView show];
}

#pragma mark 创建中标监控按钮
-(void)createProjectSubscribeBtn{
    UIButton *subscribeBtn=[[UIButton alloc]initWithFrame:CGRectMake(Screen_Width-8-74, Screen_Height-KNavigationBarHeight-87-45-39-45, 74, 74)];
    [subscribeBtn setBackgroundImage:[UIImage imageNamed:@"finding_biddingSubscribe"] forState:UIControlStateNormal];
    [subscribeBtn addTarget:self action:@selector(projectSubscribeClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:subscribeBtn];
}

#pragma mark 中标监控按钮点击事件
-(void)projectSubscribeClick{
    if ([DDUtils isEmptyString:[DDUserManager sharedInstance].userid]) {
        [self presentLoginVC];
    }
    else{
        NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
        [params setValue:@"2" forKey:@"monitorType"];
        
        __weak __typeof(self) weakSelf=self;
        [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_monitorDetailInfo params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
//            NSLog(@"***********监控详情请求数据***************%@",responseObject);
            
            DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
            if (response.isSuccess) {//请求成功
                NSArray *listArr= responseObject[KData];
                if (listArr.count==0) {
                    DDProjectSubscribeBenefitVC *benefit=[[DDProjectSubscribeBenefitVC alloc]init];
                    benefit.hidesBottomBarWhenPushed=YES;
                    [weakSelf.mainViewContoller.navigationController pushViewController:benefit animated:YES];
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
                    [weakSelf.mainViewContoller.navigationController pushViewController:projectSubscribe animated:YES];
                }
            }
            else{//显示异常
                [DDUtils showToastWithMessage:response.message];
            }
            
        } failure:^(NSURLSessionDataTask *operation, id responseObject) {
            [DDUtils showToastWithMessage:kRequestFailed];
        }];
    }
}

#pragma mark 创建tableView
-(void)createTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 39+39, Screen_Width, Screen_Height-KNavigationBarHeight-39-39-KTabbarHeight-45) style:UITableViewStyleGrouped];
    _tableView.backgroundColor=kColorBackGroundColor;
    [self.view addSubview:_tableView];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.separatorColor=KColorTableSeparator;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 15)];
    [_tableView registerClass:[DDNewFindingWinBiddingProjectCell class] forCellReuseIdentifier:@"DDNewFindingWinBiddingProjectCell"];
    __weak __typeof(self) weakSelf=self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestData:YES andClear:NO];
    }];
    
}

#pragma mark tableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataSourceArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DDSearchProjectListModel *model=_dataSourceArr[indexPath.section];
    DDNewFindingWinBiddingProjectCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDNewFindingWinBiddingProjectCell" forIndexPath:indexPath];
    [cell loadDataWithModel:model];
    if (![DDUtils isEmptyString:model.winBidOrg]) {
        cell.winBiddingBtn.userInteractionEnabled=YES;
        cell.winBiddingBtn.tag=indexPath.section;
        [cell.winBiddingBtn addTarget:self action:@selector(companyDetailClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    else{
        cell.winBiddingBtn.userInteractionEnabled=NO;
    }
    return cell;
}

#pragma mark 点击跳转到公司详情
-(void)companyDetailClick:(UIButton *)sender{
    _imgView1.image=[UIImage imageNamed:@"home_search_down"];
    [_areaSelectTableView hidden];
    _isCitySelected=NO;
    _imgView3.image=[UIImage imageNamed:@"home_search_down"];
    [_moneySelectView hiddenActionSheet];
    _isMoneySelected=NO;
    DDSearchProjectListModel *model=_dataSourceArr[sender.tag];
    
    DDCompanyDetailVC *companyDetailVC=[[DDCompanyDetailVC alloc]init];
    companyDetailVC.enterpriseId=model.enterpriseId;
    companyDetailVC.hidesBottomBarWhenPushed=YES;
    [self.mainViewContoller.navigationController pushViewController:companyDetailVC animated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _imgView1.image=[UIImage imageNamed:@"home_search_down"];
    [_areaSelectTableView hidden];
    _isCitySelected=NO;
    _imgView3.image=[UIImage imageNamed:@"home_search_down"];
    [_moneySelectView hiddenActionSheet];
    _isMoneySelected=NO;
    if ([DDUtils isEmptyString:[DDUserManager sharedInstance].userid]) {
        [self presentLoginVCWithIndexPath:indexPath];
    }
    else{
        DDSearchProjectListModel *model=_dataSourceArr[indexPath.section];
        DDProjectDetailVC *projectDetail=[[DDProjectDetailVC alloc]init];
        projectDetail.winCaseId=model.winCaseId;
        projectDetail.hidesBottomBarWhenPushed=YES;
        [self.mainViewContoller.navigationController pushViewController:projectDetail animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    DDSearchProjectListModel *model=_dataSourceArr[indexPath.section];
    NSString *titleStr = model.title;
    if (![DDUtils isEmptyString:model.type]) {
        titleStr=[NSString stringWithFormat:@"[%@]%@",model.type,model.title];
    }
    
    CGFloat cellHeight = 0.0;
    if(![DDUtils isEmptyString:titleStr]){
        CGSize labelSize = [[NSString stringWithFormat:@"%@",titleStr] boundingRectWithSize:CGSizeMake(Screen_Width-WidthByiPhone6(24), 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:kFontSize34} context:nil].size;
        cellHeight = labelSize.height;
    }else{
        cellHeight = WidthByiPhone6(20);
    }
    
    if (![DDUtils isEmptyString:model.moneyType]) {
        if ([model.moneyType integerValue] != 0) {
            NSString *timeStr = model.winBidText;
            CGSize labelSize = [[NSString stringWithFormat:@"%@",timeStr] boundingRectWithSize:CGSizeMake(Screen_Width-WidthByiPhone6(73), 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:kFontSize28} context:nil].size;
            return labelSize.height+cellHeight + WidthByiPhone6(110);
        }else{
            return cellHeight+WidthByiPhone6(130);
        }
    }else{
        return cellHeight+WidthByiPhone6(130);
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (_dataSourceArr.count>0) {
        DDSearchProjectListModel *model=_dataSourceArr[section];
        
        UIView *footerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 37)];
        footerView.backgroundColor=kColorWhite;
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(12, 0, Screen_Width-24, 37)];
        if ([DDUtils isEmptyString:model.tradingCenter]) {
            label.text=@"-";
        }
        else{
            label.text=model.tradingCenter;
        }
        label.textColor=KColorGreySubTitle;
        label.font=kFontSize24;
        [footerView addSubview:label];
        
        return footerView;
    }
    else{
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return CGFLOAT_MIN;
    }
    else{
        return 15;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (_dataSourceArr.count>0) {
        DDSearchProjectListModel *model=_dataSourceArr[section];
        
        if ([DDUtils isEmptyString:model.tradingCenter]) {
            return CGFLOAT_MIN;
        }
        else{
            return 37;
        }
    }
    else{
        return CGFLOAT_MIN;
    }
}

#pragma mark 点击城市选择
-(void)areaSelectClick{
    if (_isCitySelected==NO) {
        //将工程类别筛选隐藏
        _label2.textColor = KColorBlackTitle;
        _imgView2.image=[UIImage imageNamed:@"home_search_down"];
        [_projectTypeSelectView hiddenActionSheet];
        _isProjectTypeSelected=NO;
        //将金额筛选隐藏
        _label3.textColor = KColorBlackTitle;
        _imgView3.image=[UIImage imageNamed:@"home_search_down"];
        [_moneySelectView hiddenActionSheet];
        _isMoneySelected=NO;
        //将中标时间筛选隐藏
        _label4.textColor = KColorBlackTitle;
        _imgView4.image=[UIImage imageNamed:@"home_search_down"];
        [_dateSelectView hiddenActionSheet];
        _isDateSelected=NO;
        
        _label1.textColor = kColorBlue;
        _imgView1.image=[UIImage imageNamed:@"home_search_up"];
        
        [_areaSelectTableView noHidden];
        
        _isCitySelected=YES;
    }
    else{
        _imgView1.image=[UIImage imageNamed:@"home_search_down"];
        _label1.textColor = KColorBlackTitle;
        //[_areaSelectTableView hiddenActionSheet];
        [_areaSelectTableView hidden];
        
        _isCitySelected=NO;
    }
}

#pragma mark CitySelectPickerView代理回调
-(void)actionsheetDisappear:(DDAreaSelectTableView *)actionSheet andAreaInfo:(NSString *)area{
    _label1.text=area;
    _label1.textColor = KColorBlackTitle;
    if ([area containsString:@"直辖县"]) {
        NSRange range = [area rangeOfString:@","];
        NSString *regionStr=[area substringFromIndex:(range.location+1)];
        _label1.text=regionStr;
    }
    
    CGFloat leftWidth=_label1.size.width+4+15;
    if (leftWidth>=(Screen_Width/4-20)) {
        _label1.frame=CGRectMake(5, 12, (Screen_Width/4-9)-15, 15);
        _imgView1.frame=CGRectMake(CGRectGetMaxX(_label1.frame)+4, 12, 15, 15);
    }
    else{
        _label1.frame=CGRectMake((Screen_Width/4-leftWidth)/2, 12, leftWidth-4-15, 15);
        _imgView1.frame=CGRectMake(CGRectGetMaxX(_label1.frame)+4, 12, 15, 15);
    }
    
    NSString *areaStr=area;
    if ([areaStr containsString:@"全省"]) {
        areaStr=[areaStr stringByReplacingOccurrencesOfString:@"全省" withString:@""];
    }
    else if ([areaStr containsString:@"市全市"]) {
        areaStr=[areaStr stringByReplacingOccurrencesOfString:@"市全市" withString:@""];
    }
    else if ([areaStr containsString:@"全区"]) {
        areaStr=[areaStr stringByReplacingOccurrencesOfString:@"全区" withString:@""];
    }else if ([areaStr isEqualToString:@"全国"]) {
        areaStr=@"";
    }else if ([areaStr isEqualToString:@"北京市"]||[areaStr isEqualToString:@"上海市"]||[areaStr isEqualToString:@"天津市"]) {
        areaStr = [areaStr substringToIndex:areaStr.length-1];
    }
    _region=areaStr;
    [self requestData:YES andClear:YES];
}

#pragma mark 点击工程类别筛选
-(void)projectTypeSelectClick{
    if (_isProjectTypeSelected==NO) {
        //将区域筛选隐藏
        _label1.textColor = KColorBlackTitle;
        _imgView1.image=[UIImage imageNamed:@"home_search_down"];
        //[_areaSelectTableView hiddenActionSheet];
        [_areaSelectTableView hidden];
        _isCitySelected=NO;
        //将金额筛选隐藏
        _label3.textColor = KColorBlackTitle;
        _imgView3.image=[UIImage imageNamed:@"home_search_down"];
        [_moneySelectView hiddenActionSheet];
        _isMoneySelected=NO;
        //将中标时间筛选隐藏
        _label4.textColor = KColorBlackTitle;
        _imgView4.image=[UIImage imageNamed:@"home_search_down"];
        [_dateSelectView hiddenActionSheet];
        _isDateSelected=NO;
        
        _label2.textColor = kColorBlue;
        _imgView2.image=[UIImage imageNamed:@"home_search_up"];
        
        _projectTypeSelectView=[[DDFindingCallBiddingProjectTypeSelectView alloc]initWithFrame:CGRectMake(0, 39+60, Screen_Width, Screen_Height-KNavigationBarHeight-39-60)];
        _projectTypeSelectView.attachHeight=@"45";
        _projectTypeSelectView.typeId=_projectTypeId;
        _projectTypeSelectView.selectIndex = projectSelect;
        _projectTypeSelectView.dataSource = _projectClassArray;
        __weak __typeof(self) weakSelf=self;
        _projectTypeSelectView.hiddenBlock = ^{
            weakSelf.imgView2.image=[UIImage imageNamed:@"home_search_down"];
            weakSelf.label2.textColor = KColorBlackTitle;
            [weakSelf.projectTypeSelectView hiddenActionSheet];
            
            _isProjectTypeSelected=NO;
        };
        _projectTypeSelectView.delegate=self;
        [_projectTypeSelectView showActionSheet];
        
        _isProjectTypeSelected=YES;
    }
    else{
        _imgView2.image=[UIImage imageNamed:@"home_search_down"];
        _label2.textColor = KColorBlackTitle;
        [_projectTypeSelectView hiddenActionSheet];
        _isProjectTypeSelected=NO;
    }
}

#pragma mark DDFindingCallBiddingProjectTypeSelectViewDelegate代理回调
-(void)actionsheetDisappear:(DDFindingCallBiddingProjectTypeSelectView *)actionSheet andTypeStr:(NSString *)typeStr andTypeCode:(NSString *)typeCode andSelectIndex:(NSInteger)select{
    _projectTypeId=typeCode;
    projectSelect = select;
    _label2.textColor = KColorBlackTitle;
    CGRect middle1TextFrame = [typeStr boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize28} context:nil];
    CGFloat middle1Width=middle1TextFrame.size.width+4+15;
    if (middle1Width>=(Screen_Width/4-5)) {
        _label2.frame=CGRectMake(5, 12, (Screen_Width/4-5)-4-15, 15);
        _imgView2.frame=CGRectMake(CGRectGetMaxX(_label2.frame)+2, 12, 15, 15);
    }
    else{
        _label2.frame=CGRectMake((Screen_Width/4-middle1Width)/2, 12, middle1Width-4-15, 15);
        _imgView2.frame=CGRectMake(CGRectGetMaxX(_label2.frame)+4, 12, 15, 15);
    }
    
    _label2.text=typeStr;
    
    _projectTypeStr=typeStr;
    if ([_projectTypeStr isEqualToString:@"不限"]) {
        _projectTypeStr=@"";
    }
    
    [self requestData:YES andClear:YES];
}

#pragma mark 点击金额筛选
-(void)moneySelectClick{
    if (_isMoneySelected==NO) {
        //将区域筛选隐藏
        _label1.textColor = KColorBlackTitle;
        _imgView1.image=[UIImage imageNamed:@"home_search_down"];
        //[_areaSelectTableView hiddenActionSheet];
        [_areaSelectTableView hidden];
        _isCitySelected=NO;
        //将工程类别筛选隐藏
        _label2.textColor = KColorBlackTitle;
        _imgView2.image=[UIImage imageNamed:@"home_search_down"];
        [_projectTypeSelectView hiddenActionSheet];
        _isProjectTypeSelected=NO;
        //将中标时间筛选隐藏
        _label4.textColor = KColorBlackTitle;
        _imgView4.image=[UIImage imageNamed:@"home_search_down"];
        [_dateSelectView hiddenActionSheet];
        _isDateSelected=NO;
        
        _label3.textColor = kColorBlue;
        _imgView3.image=[UIImage imageNamed:@"home_search_up"];
        
        _moneySelectView=[[DDFindingCallBiddingMoneySelectView alloc]initWithFrame:CGRectMake(0, 39+60, Screen_Width, Screen_Height-KNavigationBarHeight-39-60)];
        _moneySelectView.attachHeight=@"45";
        _moneySelectView.moneyId=_moneyId;
        _moneySelectView.dataSource = _moneyArray;
        __weak __typeof(self) weakSelf=self;
        _moneySelectView.hiddenBlock = ^{
            weakSelf.imgView3.image=[UIImage imageNamed:@"home_search_down"];
            weakSelf.label3.textColor = KColorBlackTitle;
            [weakSelf.moneySelectView hiddenActionSheet];
            
            _isMoneySelected=NO;
        };
        _moneySelectView.delegate=self;
        [_moneySelectView showActionSheet];
        
        _isMoneySelected=YES;
    }
    else{
        _imgView3.image=[UIImage imageNamed:@"home_search_down"];
        _label3.textColor = KColorBlackTitle;
        [_moneySelectView hiddenActionSheet];
        
        _isMoneySelected=NO;
    }
}

#pragma mark DDFindingCallBiddingMoneySelectViewDelegate代理回调
-(void)actionsheetDisappear:(DDFindingCallBiddingMoneySelectView *)actionSheet andMoneyStr:(NSString *)moneyStr andMoneyId:(NSString *)moneyId andMoneyCode:(NSString *)MoneyCode{
    _amount=MoneyCode;
    _label3.textColor = KColorBlackTitle;
    CGRect middle2TextFrame = [moneyStr boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize28} context:nil];
    CGFloat middle2Width=middle2TextFrame.size.width+4+15;
    if (middle2Width>=(Screen_Width/4-5)) {
        _label3.frame=CGRectMake(5, 12, (Screen_Width/4-9)-15, 15);
        _imgView3.frame=CGRectMake(CGRectGetMaxX(_label3.frame)+4, 12, 15, 15);
    }
    else{
        _label3.frame=CGRectMake((Screen_Width/4-middle2Width)/2, 12, middle2Width-4-15, 15);
        _imgView3.frame=CGRectMake(CGRectGetMaxX(_label3.frame)+4, 12, 15, 15);
    }
    
    _label3.text=moneyStr;
    _moneyId=moneyId;
    
    [self requestData:YES andClear:YES];
}

#pragma mark 点击中标时间筛选
-(void)dateSelectClick{
    if (_isDateSelected==NO) {
        //将区域筛选隐藏
        _label1.textColor = KColorBlackTitle;
        _imgView1.image=[UIImage imageNamed:@"home_search_down"];
        //[_areaSelectTableView hiddenActionSheet];
        [_areaSelectTableView hidden];
        _isCitySelected=NO;
        //将工程类别筛选隐藏
        _label2.textColor = KColorBlackTitle;
        _imgView2.image=[UIImage imageNamed:@"home_search_down"];
        [_projectTypeSelectView hiddenActionSheet];
        _isProjectTypeSelected=NO;
        //将金额筛选隐藏
        _label3.textColor = KColorBlackTitle;
        _imgView3.image=[UIImage imageNamed:@"home_search_down"];
        [_moneySelectView hiddenActionSheet];
        _isMoneySelected=NO;
        
        _label4.textColor = kColorBlue;
        _imgView4.image=[UIImage imageNamed:@"home_search_up"];
        
        _dateSelectView=[[DDFindingWinBiddingDateSelectView alloc]initWithFrame:CGRectMake(0, 39+60, Screen_Width, Screen_Height-KNavigationBarHeight-39-60)];
        _dateSelectView.attachHeight=@"45";
        _dateSelectView.dateCode=_date;
        __weak __typeof(self) weakSelf=self;
        _dateSelectView.hiddenBlock = ^{
            weakSelf.imgView4.image=[UIImage imageNamed:@"home_search_down"];
            weakSelf.label4.textColor = KColorBlackTitle;
            [weakSelf.dateSelectView hiddenActionSheet];
            
            _isDateSelected=NO;
        };
        _dateSelectView.delegate=self;
        [_dateSelectView show];
        
        _isDateSelected=YES;
    }
    else{
        _imgView4.image=[UIImage imageNamed:@"home_search_down"];
        _label4.textColor = KColorBlackTitle;
        [_dateSelectView hiddenActionSheet];
        
        _isDateSelected=NO;
    }
}

#pragma mark DDFindingWinBiddingDateSelectViewDelegate代理回调
-(void)actionsheetDisappear:(DDFindingWinBiddingDateSelectView *)actionSheet andDateStr:(NSString *)dateStr andDateCode:(NSString *)dateCode{
    _date=dateCode;
    _label4.textColor = KColorBlackTitle;
    CGRect rightTextFrame = [dateStr boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize28} context:nil];
    CGFloat rightWidth=rightTextFrame.size.width+4+15;
    if (rightWidth>=(Screen_Width/4-5)) {
        _label4.frame=CGRectMake(5, 12, (Screen_Width/4-9)-15, 15);
        _imgView4.frame=CGRectMake(CGRectGetMaxX(_label4.frame)+4, 12, 15, 15);
    }
    else{
        _label4.frame=CGRectMake((Screen_Width/4-rightWidth)/2, 12, rightWidth-4-15, 15);
        _imgView4.frame=CGRectMake(CGRectGetMaxX(_label4.frame)+4, 12, 15, 15);
    }
    
    _label4.text=dateStr;
    
    [self requestData:YES andClear:YES];
}

#pragma mark 弹出登录注册页面
- (void)presentLoginVCWithIndexPath:(NSIndexPath *)indexPath{
    DDLoginCheckVC * vc = [[DDLoginCheckVC alloc] init];
    vc.loginSuccessBlock = ^{
        //__weak __typeof(self) weakSelf=self;
        //[weakSelf requestTypesData];
        
        DDSearchProjectListModel *model=_dataSourceArr[indexPath.section];
        //    //此时需要存数据库了
        //    //存最近搜索
        //    [DDSearchHistoryDAOAndDB insertRecentSearchByTypeId:@"9909" andSearchText:self.searchText];
        //    //存浏览历史
        //    [DDSearchHistoryDAOAndDB insertHistorySearchByTypeId:@"9909" andSearchResult:model.title andGlobalType:@"2" andTransId:model.winCaseId];
        
        
        DDProjectDetailVC *projectDetail=[[DDProjectDetailVC alloc]init];
        projectDetail.winCaseId=model.winCaseId;
        projectDetail.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:projectDetail animated:YES];
        
    };
    
    
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [DDNavigationUtil setNavigationAndBottomLineWhiteColor:nav];
    [self showViewController:nav sender:nil];
}

#pragma mark 弹出登录注册页面
- (void)presentLoginVCWithSender1:(UIButton *)sender{
    DDLoginCheckVC * vc = [[DDLoginCheckVC alloc] init];
    vc.loginSuccessBlock = ^{
        //__weak __typeof(self) weakSelf=self;
        //[weakSelf requestTypesData];
        
        DDSearchProjectListModel *model=_dataSourceArr[sender.tag];
        
        DDCompanyDetailVC *companyDetailVC=[[DDCompanyDetailVC alloc]init];
        companyDetailVC.enterpriseId=model.enterpriseId;
        companyDetailVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:companyDetailVC animated:YES];
    };
    
    
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [DDNavigationUtil setNavigationAndBottomLineWhiteColor:nav];
    [self showViewController:nav sender:nil];
}

#pragma mark 弹出登录注册页面
- (void)presentLoginVC{
    DDLoginCheckVC * vc = [[DDLoginCheckVC alloc] init];
    vc.loginSuccessBlock = ^{
        //__weak __typeof(self) weakSelf=self;
        //[weakSelf requestTypesData];
        
        NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
        [params setValue:@"2" forKey:@"monitorType"];
        
        __weak __typeof(self) weakSelf=self;
        [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_monitorDetailInfo params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
//            NSLog(@"***********监控详情请求数据***************%@",responseObject);
            
            DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
            if (response.isSuccess) {//请求成功
                NSArray *listArr= responseObject[KData];
                if (listArr.count==0) {
                    DDProjectSubscribeBenefitVC *benefit=[[DDProjectSubscribeBenefitVC alloc]init];
                    benefit.hidesBottomBarWhenPushed=YES;
                    [weakSelf.mainViewContoller.navigationController pushViewController:benefit animated:YES];
                }
                else{
                    NSMutableArray *passRegionIds=[[NSMutableArray alloc]init];
                    NSMutableArray *dataSource=[[NSMutableArray alloc]init];
                    for (NSDictionary *dic in listArr) {
                        DDTalentSubscribeDetailModel *model=[[DDTalentSubscribeDetailModel alloc]initWithDictionary:dic error:nil];
                        [passRegionIds addObject:model.regionId];
                        [dataSource addObject:model];
                    }
                    DDTalentSubscribeDetailModel *model=dataSource[0];
                    NSArray *passCertiTypes=[model.projectCertType componentsSeparatedByString:@","];
                    
                    DDProjectSubscribeVC *projectSubscribe=[[DDProjectSubscribeVC alloc]init];
                    projectSubscribe.type=@"1";
                    projectSubscribe.passRegionIds=passRegionIds;
                    projectSubscribe.passProjectTypes=passCertiTypes;
                    projectSubscribe.hidesBottomBarWhenPushed=YES;
                    [weakSelf.mainViewContoller.navigationController pushViewController:projectSubscribe animated:YES];
                }
            }
            else{//显示异常
                [DDUtils showToastWithMessage:response.message];
            }
            
        } failure:^(NSURLSessionDataTask *operation, id responseObject) {
            [DDUtils showToastWithMessage:kRequestFailed];
        }];
        
    };
    
    
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [DDNavigationUtil setNavigationAndBottomLineWhiteColor:nav];
    [self showViewController:nav sender:nil];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat y = scrollView.contentOffset.y;
    UITabBarItem *item = [self.mainViewContoller.tabBarController.tabBar.items objectAtIndex:1];
    if (y>Screen_Height) {
        if ([item.title isEqualToString:@"回到顶部"]) {
            return;
        }
        item.image = [[UIImage imageNamed:@"fanhuidingbu"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        item.selectedImage = [[UIImage imageNamed:@"fanhuidingbu"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item.title = @"回到顶部";
    }else{
        if ([item.title isEqualToString:@"查找"]) {
            return;
        }
        item.image = [[UIImage imageNamed:@"tab_find_gray"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        item.selectedImage = [[UIImage imageNamed:@"tab_find_blue"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item.title = @"查找";
    }
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
    _region=@"";
    [self requestData:YES andClear:YES];
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
    
    if (![rgcdata.city isEqualToString:_firstLocaStr]) {
        _region=rgcdata.city;
        _firstLocaStr = rgcdata.city;
    }
    [self requestData:YES andClear:YES];
}
-(void)viewWillCloseView{
    [_areaSelectTableView hidden];
    self.imgView1.image=[UIImage imageNamed:@"home_search_down"];
    _isCitySelected = NO;
    
    [_projectTypeSelectView hiddenActionSheet];
    self.imgView2.image=[UIImage imageNamed:@"home_search_down"];
    _isProjectTypeSelected = NO;
    
    _imgView3.image=[UIImage imageNamed:@"home_search_down"];
    [_moneySelectView hiddenActionSheet];
    _isMoneySelected=NO;
    
    _imgView4.image=[UIImage imageNamed:@"home_search_down"];
    [_dateSelectView hiddenActionSheet];
    _isDateSelected=NO;
}
@end

