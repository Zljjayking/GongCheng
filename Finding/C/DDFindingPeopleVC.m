//
//  DDFindingPeopleVC.m
//  GongChengDD
//
//  Created by xzx on 2018/11/22.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDFindingPeopleVC.h"
#import "MJRefresh.h"
#import "DDNavigationUtil.h"
#import "DDLoginCheckVC.h"//登录注册页面
#import "DataLoadingView.h"//加载页面
#import "DDNoResultView.h"//无数据视图
#import "DDSearchBossAndSafemanListCell.h"//cell
#import "DDAreaSelectTableView.h"//市的选择View
#import "DDFindingPeopleCertiTypeSelectView.h"//证书类别选择页面
#import "DDFindingPeopleDateSelectView.h"//有效期选择页面
#import "DDFindingPeopleContactWaySelectView.h"//联系方式选择页面
#import "DDPeopleDetailVC.h"//人员详情页面
#import "DDTalentSubscribeBenefitVC.h"//人才订阅的好处介绍页面
#import "DDTalentSubscribeVC.h"//人才订阅页面
#import "DDTalentSubscribeDetailModel.h"//人才订阅详情信息model
#import <BMKLocationkit/BMKLocationComponent.h>//百度地图定位
@interface DDFindingPeopleVC ()<UITableViewDelegate,UITableViewDataSource,AreaSelectTableViewDelegate,UITextFieldDelegate,UITabBarControllerDelegate,DDFindingPeopleCertiTypeSelectViewDelegate,DDFindingPeopleDateSelectViewDelegate,DDFindingPeopleContactWaySelectViewDelegate,BMKLocationManagerDelegate>

{
    NSString *_firstLocaStr;
    UIView *_topBgView;
    UITextField *_textField;
    NSString *_searchText;//搜索的文本
    
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
    BOOL _isCertiTypeSelect;//判断是否点开了证书类别选择视图
    BOOL _isDateSelected;//判断是否点开了有效期选择视图
    BOOL _isContactSelected;//判断是否点开了联系方式选择视图
    
    NSString *_region;//地区筛选
    NSString *_certiId;//证书类别之证书筛选
    NSString *_majorId;//证书类别之专业筛选
    NSString *_date;//有效期筛选
    NSString *_contactId;//联系方式筛选
    
    BOOL isLastData;
}
@property (nonatomic,strong) DataLoadingView *loadingView;
@property (nonatomic,strong) DDNoResultView *noResultView;//无数据视图
@property (nonatomic,strong) UIImageView *imgView1;//放左边那个城市选择小箭头
@property (nonatomic,strong) DDAreaSelectTableView *areaSelectTableView;//区域筛选视图
@property (nonatomic,strong) UIImageView *imgView2;//放中间那个证书类别选择小箭头
@property (nonatomic,strong) DDFindingPeopleCertiTypeSelectView *certiTypeSelectView;//证书类别筛选视图
@property (nonatomic,strong) UIImageView *imgView3;//放中间那个有效期选择小箭头
@property (nonatomic,strong) DDFindingPeopleDateSelectView *dateSelectView;//有效期筛选视图
@property (nonatomic,strong) UIImageView *imgView4;//放右边那个联系方式选择小箭头
@property (nonatomic,strong) DDFindingPeopleContactWaySelectView *contactWaySelectView;//联系方式筛选视图
@property (nonatomic,strong) BMKLocationManager *baiduLocationManager;//百度定位
@property (nonatomic, strong) UILabel *label1;//放左边那个城市选择文字
@property (nonatomic, strong) UILabel *label2;//放中间那个证书类别选择文字
@property (nonatomic, strong) UILabel *label3;//放中间那个有效期选择文字
@property (nonatomic, strong) UILabel *label4;//放右边那个联系方式选择文字
@end

@implementation DDFindingPeopleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=kColorBackGroundColor;
    _certiId=@"";
    _majorId=@"";
    _date=@"";
    _contactId=@"";
    _searchText=@"";
    _isCitySelected=NO;
    _isCertiTypeSelect=NO;
    _isDateSelected=NO;
    _isContactSelected=NO;
    _dataSourceArr=[[NSMutableArray alloc]init];
    //[self editNavItem];
    [self createChooseBtns];
    [self createTableView];
    [self createPeopleSuperVisionBtn];
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
- (void)requestData:(BOOL)isrefresh andClear:(BOOL)isclear{
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
    [params setValue:@"52" forKey:@"searchType"];
    [params setValue:_region forKey:@"region"];//区域
    [params setValue:_certiId forKey:@"roles"];//证书类别
    [params setValue:_majorId forKey:@"certCode"];//专业
    [params setValue:_date forKey:@"date"];//有效期
    [params setValue:_contactId forKey:@"contactWay"];//联系方式
    [params setValue:[NSString stringWithFormat:@"%ld",(long)currentPage] forKey:@"page"];
    [params setValue:@"10" forKey:@"rows"];
    [[DDHttpManager sharedInstance]sendPostRequest:KHttpRequest_queryHighLightList params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
//        NSLog(@"**********人员库查找结果数据***************%@",responseObject);
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
                pageCount = [_dict[@"totalCount"] integerValue];
                NSArray *listArr=_dict[@"list"];
                
                //给数量label赋值
                NSString *totlaNum=[NSString stringWithFormat:@"%@",_dict[@"numFoundCount"]];
                _numLabel.text=totlaNum;
                CGRect numberFrame = [totlaNum boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize26} context:nil];
                _numLabel.frame=CGRectMake(CGRectGetMaxX(_leftLab.frame), 12, numberFrame.size.width, 15);
                CGRect textFrame = [@"人员证书，当前区域" boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize26} context:nil];
                _rightLab.frame=CGRectMake(CGRectGetMaxX(_numLabel.frame), 12, textFrame.size.width, 15);
                
                NSString *totlaNum2=[NSString stringWithFormat:@"%@",_dict[@"totalCount"]];
                _numLabel2.text=totlaNum2;
                CGRect numberFrame2 = [totlaNum2 boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize26} context:nil];
                _numLabel2.frame=CGRectMake(CGRectGetMaxX(_rightLab.frame), 12, numberFrame2.size.width, 15);
                _rightLab2.frame=CGRectMake(CGRectGetMaxX(_numLabel2.frame), 12, 60, 15);
                
                if ([_region isEqualToString:@""]) {
                    _rightLab.text=@"人员证书";
                    _numLabel2.hidden=YES;
                    _rightLab2.hidden=YES;
                }
                else{
                    _rightLab.text=@"人员证书，当前区域";
                    _numLabel2.hidden=NO;
                    _rightLab2.hidden=NO;
                }
                
                if (listArr.count!=0) {
                    [_noResultView hiddenNoDataView];
                    for (NSDictionary *dic in listArr) {
                        DDSearchBuilderAndManagerListModel *model = [[DDSearchBuilderAndManagerListModel alloc]initWithDictionary:dic error:nil];
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
                    [_noResultView showNoResultViewWithTitle:@"人员信息" andImage:@"noResult_person"];
                }
            }
            else{
                [_noResultView showNoResultViewWithTitle:@"人员信息" andImage:@"noResult_person"];
                isLastData = YES;
            }
            [self.tableView reloadData];
            [self endRefrshing:YES];
        }
        else{
            [_noResultView showNoResultViewWithTitle:@"人员信息" andImage:@"noResult_person"];
            [self endRefrshing:NO];
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
    //地区选择
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
    if (leftWidth>=Screen_Width/4-5) {
        _label1.frame=CGRectMake(5, 12, Screen_Width/4-9-15, 15);
        _imgView1.frame=CGRectMake(CGRectGetMaxX(_label1.frame)+4, 12, 15, 15);
    }
    else{
        _label1.frame=CGRectMake((Screen_Width/4-leftWidth)/2, 12, leftWidth-4-15, 15);
        _imgView1.frame=CGRectMake(CGRectGetMaxX(_label1.frame)+4, 12, 15, 15);
    }
    
    [self.view addSubview:areaSelectBtn];
    
    //证书类别按钮
    UIButton *certiTypeSelectBtn=[[UIButton alloc]initWithFrame:CGRectMake(Screen_Width/4, 0, Screen_Width/4, 39)];
    [certiTypeSelectBtn setBackgroundColor:kColorWhite];
    
    _label2=[[UILabel alloc]init];
    _label2.text=@"证书类别";
    _label2.textColor=KColorBlackTitle;
    _label2.font=kFontSize28;
    [certiTypeSelectBtn addSubview:_label2];
    
    _imgView2=[[UIImageView alloc]init];
    _imgView2.contentMode = UIViewContentModeScaleAspectFit;
    _imgView2.image=[UIImage imageNamed:@"home_search_down"];
    [certiTypeSelectBtn addSubview:_imgView2];
    [certiTypeSelectBtn addTarget:self action:@selector(certiTypeClick) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect middle1TextFrame = [@"证书类别" boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize28} context:nil];
    CGFloat middle1Width=middle1TextFrame.size.width+4+15;
    if (middle1Width>=Screen_Width/4-5) {
        _label2.frame=CGRectMake(5, 12, Screen_Width/4-9-15, 15);
        _imgView2.frame=CGRectMake(CGRectGetMaxX(_label2.frame)+4, 12, 15, 15);
    }
    else{
        _label2.frame=CGRectMake((Screen_Width/4-middle1Width)/2, 12, middle1Width-4-15, 15);
        _imgView2.frame=CGRectMake(CGRectGetMaxX(_label2.frame)+4, 12, 15, 15);
    }
    
    [self.view addSubview:certiTypeSelectBtn];
    
    //有效期筛选按钮
    UIButton *dateSelectBtn=[[UIButton alloc]initWithFrame:CGRectMake(Screen_Width/2, 0, Screen_Width/4, 39)];
    [dateSelectBtn setBackgroundColor:kColorWhite];

    _label3=[[UILabel alloc]init];
    _label3.text=@"有效期";
    _label3.textColor=KColorBlackTitle;
    _label3.font=kFontSize28;
    [dateSelectBtn addSubview:_label3];

    _imgView3=[[UIImageView alloc]init];
    _imgView3.contentMode = UIViewContentModeScaleAspectFit;
    _imgView3.image=[UIImage imageNamed:@"home_search_down"];
    [dateSelectBtn addSubview:_imgView3];
    [dateSelectBtn addTarget:self action:@selector(dateSelectClick) forControlEvents:UIControlEventTouchUpInside];

    CGRect middle2TextFrame = [@"有效期" boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize28} context:nil];
    CGFloat middle2Width=middle2TextFrame.size.width+4+15;
    if (middle2Width>=Screen_Width/4-5) {
        _label3.frame=CGRectMake(5, 12, Screen_Width/4-9-15, 15);
        _imgView3.frame=CGRectMake(CGRectGetMaxX(_label3.frame)+4, 12, 15, 15);
    }
    else{
        _label3.frame=CGRectMake((Screen_Width/4-middle2Width)/2, 12, middle2Width-4-15, 15);
        _imgView3.frame=CGRectMake(CGRectGetMaxX(_label3.frame)+4, 12, 15, 15);
    }

    [self.view addSubview:dateSelectBtn];

    //联系方式筛选按钮
    UIButton *contactSelectBtn=[[UIButton alloc]initWithFrame:CGRectMake(Screen_Width/4*3, 0, Screen_Width/4, 39)];
    [contactSelectBtn setBackgroundColor:kColorWhite];

    _label4=[[UILabel alloc]init];
    _label4.text=@"联系方式";
    _label4.textColor=KColorBlackTitle;
    _label4.font=kFontSize28;
    [contactSelectBtn addSubview:_label4];

    _imgView4=[[UIImageView alloc]init];
    _imgView4.contentMode = UIViewContentModeScaleAspectFit;
    _imgView4.image=[UIImage imageNamed:@"home_search_down"];
    [contactSelectBtn addSubview:_imgView4];
    [contactSelectBtn addTarget:self action:@selector(contactWayClick) forControlEvents:UIControlEventTouchUpInside];

    CGRect rightTextFrame = [@"联系方式" boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize28} context:nil];
    CGFloat rightWidth=rightTextFrame.size.width+4+15;
    if (rightWidth>=Screen_Width/4-5) {
        _label4.frame=CGRectMake(5, 12, Screen_Width/4-9-15, 15);
        _imgView4.frame=CGRectMake(CGRectGetMaxX(_label4.frame)+4, 12, 15, 15);
    }
    else{
        _label4.frame=CGRectMake((Screen_Width/4-rightWidth)/2, 12, rightWidth-4-15, 15);
        _imgView4.frame=CGRectMake(CGRectGetMaxX(_label4.frame)+4, 12, 15, 15);
    }

    [self.view addSubview:contactSelectBtn];

    
    //统计文本
    UIView *summaryView=[[UIView alloc]initWithFrame:CGRectMake(0, 39, Screen_Width, 39)];
    [self.view addSubview:summaryView];
    
    _leftLab=[[UILabel alloc]initWithFrame:CGRectMake(12, 12, 30, 15)];
    _leftLab.text=@"全国";
    _leftLab.textColor=KColorGreySubTitle;
    _leftLab.font=kFontSize26;
    [summaryView addSubview:_leftLab];
    
    _numLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_leftLab.frame), 12, 1, 15)];
    _numLabel.text=@"";
    _numLabel.textColor=KColorBlackTitle;
    _numLabel.font=kFontSize26;
    [summaryView addSubview:_numLabel];
    
    CGRect textFrame = [@"人员证书，当前区域" boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize26} context:nil];
    _rightLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_numLabel.frame), 12, textFrame.size.width, 15)];
    _rightLab.text=@"人员证书，当前区域";
    _rightLab.textColor=KColorGreySubTitle;
    _rightLab.font=kFontSize26;
    [summaryView addSubview:_rightLab];
    
    _numLabel2=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_rightLab.frame), 12, 1, 15)];
    _numLabel2.text=@"";
    _numLabel2.textColor=KColorBlackTitle;
    _numLabel2.font=kFontSize26;
    [summaryView addSubview:_numLabel2];
    
    _rightLab2=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_numLabel2.frame), 12, 60, 15)];
    _rightLab2.text=@"人员证书";
    _rightLab2.textColor=KColorGreySubTitle;
    _rightLab2.font=kFontSize26;
    [summaryView addSubview:_rightLab2];
    
    //创建地区选择View
    _areaSelectTableView=[[DDAreaSelectTableView alloc]initWithFrame:CGRectMake(0, 39, Screen_Width, Screen_Height-KNavigationBarHeight-39)];
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
        //[weakSelf.citySelectTableView hiddenActionSheet];
        [weakSelf.areaSelectTableView hidden];
        
        _isCitySelected=NO;
    };
    _areaSelectTableView.delegate=self;
    [_areaSelectTableView show];
    
    //创建证书类别选择View
    _certiTypeSelectView=[[DDFindingPeopleCertiTypeSelectView alloc]initWithFrame:CGRectMake(0, 39+60, Screen_Width, Screen_Height-KNavigationBarHeight-39-60)];
    _certiTypeSelectView.certiId=_certiId;
    _certiTypeSelectView.majorId=_majorId;
    _certiTypeSelectView.attachHeight=@"45";
    _certiTypeSelectView.hiddenBlock = ^{
        weakSelf.imgView2.image=[UIImage imageNamed:@"home_search_down"];
        weakSelf.label2.textColor = KColorBlackTitle;
        //[weakSelf.certiTypeSelectView hiddenActionSheet];
        [weakSelf.certiTypeSelectView hidden];
        
        _isCertiTypeSelect=NO;
    };
    _certiTypeSelectView.delegate=self;
    [_certiTypeSelectView show];
}

#pragma mark 创建人才订阅按钮
-(void)createPeopleSuperVisionBtn{
    UIButton *subscribeBtn=[[UIButton alloc]initWithFrame:CGRectMake(Screen_Width-8-74, Screen_Height-KNavigationBarHeight-87-45-39-45, 74, 74)];
    [subscribeBtn setBackgroundImage:[UIImage imageNamed:@"finding_talentSubscribe"] forState:UIControlStateNormal];
    [subscribeBtn addTarget:self action:@selector(talentSubscribeClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:subscribeBtn];
}

#pragma mark 人才订阅按钮点击事件
-(void)talentSubscribeClick{
    if ([DDUtils isEmptyString:[DDUserManager sharedInstance].userid]) {
        [self presentLoginVC];
    }
    else{
        NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
        [params setValue:@"1" forKey:@"monitorType"];
        
        __weak __typeof(self) weakSelf=self;
        [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_monitorDetailInfo params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
//            NSLog(@"***********监控详情请求数据***************%@",responseObject);
            
            DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
            if (response.isSuccess) {//请求成功
                NSArray *listArr= responseObject[KData];
                if (listArr.count==0) {
                    DDTalentSubscribeBenefitVC *talentSubscribe=[[DDTalentSubscribeBenefitVC alloc]init];
                    talentSubscribe.hidesBottomBarWhenPushed=YES;
                    [weakSelf.mainViewContoller.navigationController pushViewController:talentSubscribe animated:YES];
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
                    
                    DDTalentSubscribeVC *talentSubscribe=[[DDTalentSubscribeVC alloc]init];
                    talentSubscribe.type=@"1";
                    talentSubscribe.passRegionIds=passRegionIds;
                    talentSubscribe.passCertiTypes=passCertiTypes;
                    talentSubscribe.passDate=model.validityType;
                    talentSubscribe.hidesBottomBarWhenPushed=YES;
                    [weakSelf.mainViewContoller.navigationController pushViewController:talentSubscribe animated:YES];
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
    DDSearchBuilderAndManagerListModel * model = _dataSourceArr[indexPath.section];
    
    static NSString * cellID = @"DDSearchBossAndSafemanListCell";
    DDSearchBossAndSafemanListCell * cell = (DDSearchBossAndSafemanListCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
    }
    
    [cell loadDataWithModel:model];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_areaSelectTableView hidden];
    self.imgView1.image=[UIImage imageNamed:@"home_search_down"];
    _isCitySelected = NO;
    
    [_certiTypeSelectView hidden];
    self.imgView2.image=[UIImage imageNamed:@"home_search_down"];
    _isCertiTypeSelect = NO;
    
    [_dateSelectView hiddenActionSheet];
    self.imgView3.image=[UIImage imageNamed:@"home_search_down"];
    _isDateSelected = NO;
    
    [_contactWaySelectView hiddenActionSheet];
    self.imgView4.image=[UIImage imageNamed:@"home_search_down"];
    _isContactSelected = NO;
    
    if ([DDUtils isEmptyString:[DDUserManager sharedInstance].userid]) {
        [self presentLoginVCWithIndexPath:indexPath];
    }
    else{
        DDSearchBuilderAndManagerListModel *model=_dataSourceArr[indexPath.section];
        
        DDPeopleDetailVC *peopleDetail=[[DDPeopleDetailVC alloc]init];
        peopleDetail.staffInfoId=model.staff_info_id;
        peopleDetail.hidesBottomBarWhenPushed=YES;
        peopleDetail.peopleModel = model;
        [self.mainViewContoller.navigationController pushViewController:peopleDetail animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    DDSearchBuilderAndManagerListModel *model=_dataSourceArr[indexPath.section];
    return [DDSearchBossAndSafemanListCell heightWithModel:model]+60+20-20;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    DDSearchBuilderAndManagerListModel *model=_dataSourceArr[section];
    
    if ([DDUtils isEmptyString:model.enterprise_name]) {
        return nil;
    }
    else{
        UIView *footerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 40)];
        footerView.backgroundColor=kColorWhite;
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(12, 12.5, Screen_Width-54, 15)];
        label.text=model.enterprise_name;
        label.font=kFontSize28;
        label.lineBreakMode = NSLineBreakByTruncatingTail;
        [footerView addSubview:label];
        
        return footerView;
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
    DDSearchBuilderAndManagerListModel *model=_dataSourceArr[section];
    
    if ([DDUtils isEmptyString:model.enterprise_name]) {
        return CGFLOAT_MIN;
    }
    else{
        return 40;
    }
}

#pragma mark 点击城市选择
-(void)areaSelectClick{
    if (_isCitySelected==NO) {
        //将证书类别筛选隐藏
        _label2.textColor = KColorBlackTitle;
        _imgView2.image=[UIImage imageNamed:@"home_search_down"];
        [_certiTypeSelectView hidden];
        _isCertiTypeSelect=NO;
        //将有效期筛选隐藏
        _label3.textColor = KColorBlackTitle;
        _imgView3.image=[UIImage imageNamed:@"home_search_down"];
        [_dateSelectView hiddenActionSheet];
        _isDateSelected=NO;
        //将联系方式筛选隐藏
        _label4.textColor = KColorBlackTitle;
        _imgView4.image=[UIImage imageNamed:@"home_search_down"];
        [_contactWaySelectView hiddenActionSheet];
        _isContactSelected=NO;
        
        _label1.textColor = kColorBlue;
        _imgView1.image=[UIImage imageNamed:@"home_search_up"];
        
        [_areaSelectTableView noHidden];
        [_textField resignFirstResponder];
        
        _isCitySelected=YES;
    }
    else{
        _imgView1.image=[UIImage imageNamed:@"home_search_down"];
        _label1.textColor = KColorBlackTitle;
        //[_citySelectTableView hiddenActionSheet];
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
    [_label1 sizeToFit];
    CGFloat leftWidth=_label1.size.width+4+15;
    if (leftWidth>=Screen_Width/4-5) {
        _label1.frame=CGRectMake(5, 12, Screen_Width/4-9-15, 15);
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

#pragma mark 点击证书类别选择
-(void)certiTypeClick{
    if (_isCertiTypeSelect==NO) {
        //将区域筛选隐藏
        _label1.textColor = KColorBlackTitle;
        _imgView1.image=[UIImage imageNamed:@"home_search_down"];
        //[_areaSelectTableView hiddenActionSheet];
        [_areaSelectTableView hidden];
        _isCitySelected=NO;
        //将有效期筛选隐藏
        _label3.textColor = KColorBlackTitle;
        _imgView3.image=[UIImage imageNamed:@"home_search_down"];
        [_dateSelectView hiddenActionSheet];
        _isDateSelected=NO;
        //将联系方式筛选隐藏
        _label4.textColor = KColorBlackTitle;
        _imgView4.image=[UIImage imageNamed:@"home_search_down"];
        [_contactWaySelectView hiddenActionSheet];
        _isContactSelected=NO;
        
        _label2.textColor = kColorBlue;
        _imgView2.image=[UIImage imageNamed:@"home_search_up"];
        
//        _certiTypeSelectView=[[DDFindingPeopleCertiTypeSelectView alloc]initWithFrame:CGRectMake(0, 39+60, Screen_Width, Screen_Height-KNavigationBarHeight-39-60)];
//        _certiTypeSelectView.attachHeight=@"45";
//        _certiTypeSelectView.certiId=_certiId;
//        _certiTypeSelectView.majorId=_majorId;
//        __weak __typeof(self) weakSelf=self;
//        _certiTypeSelectView.hiddenBlock = ^{
//            weakSelf.imgView2.image=[UIImage imageNamed:@"home_search_down"];
//
//            [weakSelf.certiTypeSelectView hiddenActionSheet];
//
//            _isCertiTypeSelect=NO;
//        };
//        _certiTypeSelectView.delegate=self;
//        [_certiTypeSelectView show];
//        [_textField resignFirstResponder];
        
        [_certiTypeSelectView noHidden];
        [_textField resignFirstResponder];
        
        _isCertiTypeSelect=YES;
    }
    else{
        _imgView2.image=[UIImage imageNamed:@"home_search_down"];
        _label2.textColor = KColorBlackTitle;
        [_certiTypeSelectView hidden];
        
        _isCertiTypeSelect=NO;
    }
}

#pragma mark DDFindingPeopleCertiTypeSelectViewDelegate代理回调
-(void)actionsheetDisappear:(DDFindingPeopleCertiTypeSelectView *)actionSheet andCertiStr:(NSString *)certiStr andCertiCode:(NSString *)certiCode andMajorStr:(NSString *)majorStr andMajorCode:(NSString *)majorCode{
    _certiId=certiCode;
    _majorId=majorCode;
    
    _label2.textColor = KColorBlackTitle;
    if (![DDUtils isEmptyString:majorStr]) {
        if ([majorStr isEqualToString:@"不限"]) {
            _label2.text=certiStr;
        }else{
            _label2.text=majorStr;
        }
    }else{
        _label2.text=certiStr;
    }
   
    CGRect middle1TextFrame = [_label2.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize28} context:nil];
    CGFloat middle1Width=middle1TextFrame.size.width+4+15;
    if (middle1Width>=Screen_Width/4-5) {
        _label2.frame=CGRectMake(5, 12, Screen_Width/4-9-15, 15);
        _imgView2.frame=CGRectMake(CGRectGetMaxX(_label2.frame)+4, 12, 15, 15);
    }
    else{
        _label2.frame=CGRectMake((Screen_Width/4-middle1Width)/2, 12, middle1Width-4-15, 15);
        _imgView2.frame=CGRectMake(CGRectGetMaxX(_label2.frame)+4, 12, 15, 15);
    }
    
    if ([DDUtils isEmptyString:_certiId]) {
        _date=@"";
        
        CGRect middle2TextFrame = [@"有效期" boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
        CGFloat middle2Width=middle2TextFrame.size.width+4+15;
        if (middle2Width>=Screen_Width/4-5) {
            _label3.frame=CGRectMake(5, 12, Screen_Width/4-9-15, 15);
            _imgView3.frame=CGRectMake(CGRectGetMaxX(_label3.frame)+4, 12, 15, 15);
        }
        else{
            _label3.frame=CGRectMake((Screen_Width/4-middle2Width)/2, 12, middle2Width-4-15, 15);
            _imgView3.frame=CGRectMake(CGRectGetMaxX(_label3.frame)+4, 12, 15, 15);
        }
        _label3.text=@"有效期";
    }
    
    [self requestData:YES andClear:YES];
}

#pragma mark 点击有效期选择
-(void)dateSelectClick{
    if ([DDUtils isEmptyString:_certiId]) {
        [DDUtils showToastWithMessage:@"为了更精准地查找符合您要求的证书，建议您先选择证书类别"];
    }
    else{
        if (_isDateSelected==NO) {
            //将区域筛选隐藏
            _label1.textColor = KColorBlackTitle;
            _imgView1.image=[UIImage imageNamed:@"home_search_down"];
            //[_areaSelectTableView hiddenActionSheet];
            [_areaSelectTableView hidden];
            _isCitySelected=NO;
            //将证书类别筛选隐藏
            _label2.textColor = KColorBlackTitle;
            _imgView2.image=[UIImage imageNamed:@"home_search_down"];
            [_certiTypeSelectView hidden];
            _isCertiTypeSelect=NO;
            //将联系方式筛选隐藏
            _label4.textColor = KColorBlackTitle;
            _imgView4.image=[UIImage imageNamed:@"home_search_down"];
            [_contactWaySelectView hiddenActionSheet];
            _isContactSelected=NO;
            
            _label3.textColor = kColorBlue;
            _imgView3.image=[UIImage imageNamed:@"home_search_up"];
            
            _dateSelectView=[[DDFindingPeopleDateSelectView alloc]initWithFrame:CGRectMake(0, 39+60, Screen_Width, Screen_Height-KNavigationBarHeight-39-60)];
            _dateSelectView.attachHeight=@"45";
            _dateSelectView.dateCode=_date;
            __weak __typeof(self) weakSelf=self;
            _dateSelectView.hiddenBlock = ^{
                weakSelf.imgView3.image=[UIImage imageNamed:@"home_search_down"];
                weakSelf.label3.textColor = KColorBlackTitle;
                [weakSelf.dateSelectView hiddenActionSheet];
                
                _isDateSelected=NO;
            };
            _dateSelectView.delegate=self;
            [_dateSelectView show];
            [_textField resignFirstResponder];
            
            _isDateSelected=YES;
        }
        else{
            _imgView3.image=[UIImage imageNamed:@"home_search_down"];
            _label3.textColor = KColorBlackTitle;
            [_dateSelectView hiddenActionSheet];
            
            _isDateSelected=NO;
        }
    }
}

#pragma mark DDFindingPeopleDateSelectViewDelegate代理回调
-(void)actionsheetDisappear:(DDFindingPeopleDateSelectView *)actionSheet andDateStr:(NSString *)dateStr andDateCode:(NSString *)dateCode{
    _date=dateCode;
    
    _label3.textColor = KColorBlackTitle;
    CGRect middle2TextFrame = [dateStr boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
    CGFloat middle2Width=middle2TextFrame.size.width+4+15;
    if (middle2Width>=Screen_Width/4-5) {
        _label3.frame=CGRectMake(5, 12, Screen_Width/4-9-15, 15);
        _imgView3.frame=CGRectMake(CGRectGetMaxX(_label3.frame)+4, 12, 15, 15);
    }
    else{
        _label3.frame=CGRectMake((Screen_Width/4-middle2Width)/2, 12, middle2Width-4-15, 15);
        _imgView3.frame=CGRectMake(CGRectGetMaxX(_label3.frame)+4, 12, 15, 15);
    }
    
    _label3.text=dateStr;
    
    [self requestData:YES andClear:YES];
}

#pragma mark 点击联系方式选择
-(void)contactWayClick{
    if (_isContactSelected==NO) {
        //将区域筛选隐藏
        _label1.textColor = KColorBlackTitle;
        _imgView1.image=[UIImage imageNamed:@"home_search_down"];
        //[_areaSelectTableView hiddenActionSheet];
        [_areaSelectTableView hidden];
        _isCitySelected=NO;
        //将证书类别筛选隐藏
        _label2.textColor = KColorBlackTitle;
        _imgView2.image=[UIImage imageNamed:@"home_search_down"];
        [_certiTypeSelectView hidden];
        _isCertiTypeSelect=NO;
        //将有效期筛选隐藏
        _label3.textColor = KColorBlackTitle;
        _imgView3.image=[UIImage imageNamed:@"home_search_down"];
        [_dateSelectView hiddenActionSheet];
        _isDateSelected=NO;
        
        _label4.textColor = kColorBlue;
        _imgView4.image=[UIImage imageNamed:@"home_search_up"];
        
        _contactWaySelectView=[[DDFindingPeopleContactWaySelectView alloc]initWithFrame:CGRectMake(0, 39+60, Screen_Width, Screen_Height-KNavigationBarHeight-39-60)];
        _contactWaySelectView.attachHeight=@"45";
        _contactWaySelectView.wayCode=_contactId;
        __weak __typeof(self) weakSelf=self;
        _contactWaySelectView.hiddenBlock = ^{
            weakSelf.imgView4.image=[UIImage imageNamed:@"home_search_down"];
            weakSelf.label4.textColor = KColorBlackTitle;
            [weakSelf.contactWaySelectView hiddenActionSheet];
            
            _isContactSelected=NO;
        };
        _contactWaySelectView.delegate=self;
        [_contactWaySelectView show];
        [_textField resignFirstResponder];
        
        _isContactSelected=YES;
    }
    else{
        _imgView4.image=[UIImage imageNamed:@"home_search_down"];
        _label4.textColor = KColorBlackTitle;
        [_contactWaySelectView hiddenActionSheet];
        
        _isContactSelected=NO;
    }
}

#pragma mark DDFindingPeopleContactWaySelectViewDelegate代理回调
-(void)actionsheetDisappear:(DDFindingPeopleContactWaySelectView *)actionSheet andWayStr:(NSString *)wayStr andWayCode:(NSString *)wayCode{
    _contactId=wayCode;
    _label4.textColor = KColorBlackTitle;
    CGRect rightTextFrame = [wayStr boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
    CGFloat rightWidth=rightTextFrame.size.width+4+15;
    if (rightWidth>=(Screen_Width/4-5)) {
        _label4.frame=CGRectMake(5, 12, (Screen_Width/4-5)-4-15, 15);
        _imgView4.frame=CGRectMake(CGRectGetMaxX(_label4.frame)+4, 12, 15, 15);
    }
    else{
        _label4.frame=CGRectMake((Screen_Width/4-rightWidth)/2, 12, rightWidth-4-15, 15);
        _imgView4.frame=CGRectMake(CGRectGetMaxX(_label4.frame)+4, 12, 15, 15);
    }
    
    _label4.text=wayStr;
    
    [self requestData:YES andClear:YES];
}

#pragma mark 弹出登录注册页面
- (void)presentLoginVCWithIndexPath:(NSIndexPath *)indexPath{
    DDLoginCheckVC * vc = [[DDLoginCheckVC alloc] init];
    vc.loginSuccessBlock = ^{
        //__weak __typeof(self) weakSelf=self;
        //[weakSelf requestTypesData];
        
        DDSearchBuilderAndManagerListModel *model=_dataSourceArr[indexPath.section];
        
        DDPeopleDetailVC *peopleDetail=[[DDPeopleDetailVC alloc]init];
        peopleDetail.staffInfoId=model.staff_info_id;
        peopleDetail.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:peopleDetail animated:YES];
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
        [params setValue:@"1" forKey:@"monitorType"];
        
        __weak __typeof(self) weakSelf=self;
        [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_monitorDetailInfo params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
//            NSLog(@"***********监控详情请求数据***************%@",responseObject);
            
            DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
            if (response.isSuccess) {//请求成功
                NSArray *listArr= responseObject[KData];
                if (listArr.count==0) {
                    DDTalentSubscribeBenefitVC *talentSubscribe=[[DDTalentSubscribeBenefitVC alloc]init];
                    talentSubscribe.hidesBottomBarWhenPushed=YES;
                    [weakSelf.mainViewContoller.navigationController pushViewController:talentSubscribe animated:YES];
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
                    
                    DDTalentSubscribeVC *talentSubscribe=[[DDTalentSubscribeVC alloc]init];
                    talentSubscribe.type=@"1";
                    talentSubscribe.passRegionIds=passRegionIds;
                    talentSubscribe.passCertiTypes=passCertiTypes;
                    talentSubscribe.passDate=model.validityType;
                    talentSubscribe.hidesBottomBarWhenPushed=YES;
                    [weakSelf.mainViewContoller.navigationController pushViewController:talentSubscribe animated:YES];
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

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [_textField resignFirstResponder];
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
    
    [_certiTypeSelectView hidden];
    self.imgView2.image=[UIImage imageNamed:@"home_search_down"];
    _isCertiTypeSelect = NO;
    
    [_dateSelectView hiddenActionSheet];
    self.imgView3.image=[UIImage imageNamed:@"home_search_down"];
    _isDateSelected = NO;
    [_contactWaySelectView hiddenActionSheet];
    self.imgView4.image=[UIImage imageNamed:@"home_search_down"];
    _isContactSelected = NO;
}
@end
