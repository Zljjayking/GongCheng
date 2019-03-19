//
//  DDNearCompanyVC.m
//  GongChengDD
//
//  Created by csq on 2018/10/19.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDNearCompanyVC.h"
#import "MJRefresh.h"
#import "DataLoadingView.h"
#import "DDNoResult2View.h"
#import "DDNearCompanyCell.h"
#import "DDNearCompanyModel.h"
#import "DDActionSheetView.h"
#import "DDNavigationManager.h"
#import "DDLocationManager.h"
#import "DDGeocoderManager.h"
#import "DDDistanceSelectView.h"//距离选择
#import "DDMoreSelectView.h"//更多筛选
#import "DDCompanyDetailVC.h"//企业详情页
#import "DDServiceWebViewVC.h"
#import <BMKLocationkit/BMKLocationComponent.h>//百度地图定位
@interface DDNearCompanyVC ()<UITableViewDelegate,UITableViewDataSource,DDNearCompanyCellDelegate,DDActionSheetViewDelegate,DDLocationMangerDelegate,DDGeocoderMangerDelegate,DDDistanceSelectViewDelegate,DDMoreSelectViewDelegate,BMKLocationManagerDelegate>

{
    CLLocationCoordinate2D _startCoordinate;
    CLLocationCoordinate2D _endCoordinate;
    NSString *_addressName;
    
    UILabel *_label1;//放左边那个距离选择文字
    UILabel *_label2;//放右边那个更多选择文字
    
    BOOL _isDistanceSelected;//判断是否点开了距离选择视图
    BOOL _isMoreSelected;//判断是否点开了更多筛选视图
    
    NSString *_distance;//距离
    NSString *_registerCapital;//注册资本
    NSString *_registerYear;//注册年限
    NSString *_status;//企业状态
    NSString *_capitalType;//资本类型
}
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic,strong)DDNearCompanyModel * model;
@property (nonatomic,assign)NSInteger current;//当前页
@property (nonatomic,strong)DataLoadingView * loadingView;
@property (nonatomic,strong)DDNoResult2View *noResultView;//无数据视图

@property (nonatomic,strong) UIImageView *imgView1;//放左边那个城市选择小箭头
@property (nonatomic,strong) DDDistanceSelectView *distanceSelectView;//距离选择视图
@property (nonatomic,strong) UIImageView *imgView2;//放右边那个金额选择小箭头
@property (nonatomic,strong) DDMoreSelectView *moreSelectView;//更多筛选视图
@property (nonatomic,assign)NSInteger navClickIndex;//选择的导航地图索引
@property (nonatomic,strong) BMKLocationManager *baiduLocationManager;//百度定位
@property (nonatomic, strong) UILabel *headerLab;
@end

@implementation DDNearCompanyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _distance=@"";
    _registerCapital=@"";
    _registerYear=@"";
    _status=@"";
    _capitalType=@"";
    self.view.backgroundColor = kColorBackGroundColor;
    if ([_type isEqualToString:@"0"]) {
         self.navigationItem.title = @"附近公司";
         self.navigationItem.leftBarButtonItem = [DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"我的" target:self action:@selector(leftButtonClick)];
    } else {
         self.navigationItem.title = @"附近同行";
         self.navigationItem.leftBarButtonItem = [DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
    }
   
   
//    self.navigationItem.rightBarButtonItem = [DDUtils rightbuttonItemWithTitle:@"资质办理" target:self action:@selector(rightButtonClick)];
    
    _dataArray = [[NSMutableArray alloc] initWithCapacity:10];
    [self justicePower];
}

//-(void)rightButtonClick{
//    DDServiceWebViewVC *checkVC = [DDServiceWebViewVC new];
//    checkVC.hostUrl =@"http://gcdd.koncendy.com/apphs/enterprise_service/pages/handle_list.html?groupId=1";
//    [self.navigationController pushViewController:checkVC animated:YES];
//}
-(void)justicePower{
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        _noResultView=[[DDNoResult2View alloc]initWithFrame:CGRectMake(0,0, Screen_Width, Screen_Height-KNavigationBarHeight)];
        [self.view addSubview:_noResultView];
        [_noResultView showWithTitle:@"没有帮您找到想要的公司" subTitle:@"重新搜索看看" image:@"noResult_company"];
        [DDUtils showToastWithMessage:@"定位权限已关闭,将获取不到附近公司,建议打开"];
        return;
    }
    [self startLocationData];
    [self setupTopView];
    [self setupTableView];
    [self setupDataLoadingView];
}
#pragma mark 返回上一页
- (void)leftButtonClick{
    [_distanceSelectView hiddenActionSheet];
    [_moreSelectView hiddenActionSheet];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidDisappear:(BOOL)animated{
    if (self.navigationController==NULL) {
        [_distanceSelectView hiddenActionSheet];
        [_moreSelectView hiddenActionSheet];
    }
}

#pragma mark 设置顶部选择View
- (void)setupTopView{
    //距离选择按钮
    UIButton *areaSelectBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, Screen_Width/2, 39)];
    [areaSelectBtn setBackgroundColor:kColorWhite];
    
    _label1=[[UILabel alloc]init];
    _label1.text=@"不限距离";
    _label1.textColor=KColorBlackTitle;
    _label1.font=kFontSize30;
    [areaSelectBtn addSubview:_label1];
    
    _imgView1=[[UIImageView alloc]init];
    _imgView1.contentMode = UIViewContentModeScaleAspectFit;
    _imgView1.image=[UIImage imageNamed:@"home_search_down"];
    [areaSelectBtn addSubview:_imgView1];
    [areaSelectBtn addTarget:self action:@selector(distanceSelectClick) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect leftTextFrame = [@"不限距离" boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
    CGFloat leftWidth=leftTextFrame.size.width+4+15;
    if (leftWidth>=(Screen_Width/2-40)) {
        _label1.frame=CGRectMake(20, 12, (Screen_Width/2-40)-4-15, 15);
        _imgView1.frame=CGRectMake(CGRectGetMaxX(_label1.frame)+4, 12, 15, 15);
    }
    else{
        _label1.frame=CGRectMake((Screen_Width/2-leftWidth)/2, 12, leftWidth-4-15, 15);
        _imgView1.frame=CGRectMake(CGRectGetMaxX(_label1.frame)+4, 12, 15, 15);
    }
    
    [self.view addSubview:areaSelectBtn];
    
    //更多筛选按钮
    UIButton *moneySelectBtn=[[UIButton alloc]initWithFrame:CGRectMake(Screen_Width/2, 0, Screen_Width/2, 39)];
    [moneySelectBtn setBackgroundColor:kColorWhite];
    
    _label2=[[UILabel alloc]init];
    _label2.text=@"更多筛选";
    _label2.textColor=KColorBlackTitle;
    _label2.font=kFontSize30;
    [moneySelectBtn addSubview:_label2];
    
    _imgView2=[[UIImageView alloc]init];
    _imgView2.contentMode = UIViewContentModeScaleAspectFit;
    _imgView2.image=[UIImage imageNamed:@"home_search_down"];
    [moneySelectBtn addSubview:_imgView2];
    [moneySelectBtn addTarget:self action:@selector(moreSelectClick) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect rightTextFrame = [@"更多筛选" boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
    CGFloat rightWidth=rightTextFrame.size.width+4+15;
    if (rightWidth>=(Screen_Width/2-40)) {
        _label2.frame=CGRectMake(20, 12, (Screen_Width/2-40)-4-15, 15);
        _imgView2.frame=CGRectMake(CGRectGetMaxX(_label2.frame)+4, 12, 15, 15);
    }
    else{
        _label2.frame=CGRectMake((Screen_Width/2-rightWidth)/2, 12, rightWidth-4-15, 15);
        _imgView2.frame=CGRectMake(CGRectGetMaxX(_label2.frame)+4, 12, 15, 15);
    }
    
    [self.view addSubview:moneySelectBtn];
    
    
    UIView * header = [[UIView alloc] init];
    header.backgroundColor = kColorBackGroundColor;
    header.frame = CGRectMake(0, 39, Screen_Width, 44);
    [self.view addSubview:header];
    
    UILabel * lab = [[UILabel alloc] init];
    lab.frame = CGRectMake(10, 0, 300, 44);
    lab.backgroundColor = [UIColor clearColor];
    lab.textColor = KColorGreySubTitle;
    lab.font = kFontSize28;
    [header addSubview:lab];
    self.headerLab = lab;
    
}

#pragma mark 设置tableView
-(void)setupTableView{
   _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,39+44, Screen_Width, Screen_Height-KNavigationBarHeight-39-44) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.separatorColor = KColorTableSeparator;
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width,KTableViewFooterViewHeight)];
    [self.view addSubview:_tableView];
    
    __weak __typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestData];
    }];
}

- (void)setupDataLoadingView{
    _noResultView=[[DDNoResult2View alloc]initWithFrame:CGRectMake(0,39, Screen_Width, Screen_Height-KNavigationBarHeight-39)];
    [self.tableView addSubview:_noResultView];
    
    __weak __typeof(self) weakSelf = self;
    _loadingView = [[DataLoadingView alloc] initWithController:self];
    _loadingView.loadingTitle = KLoading;
    _loadingView.failureTitle = KLoadingFailure;
    _loadingView.reloadHandle = ^(void){
        [weakSelf requestData];
    };
    [_loadingView showLoadingView];
}

#pragma mark 请求数据
- (void)requestData{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    _current = 1;
    [params setValue:_enterpriseId forKey:@"entId"];
    [params setValue:_type forKey:@"type"];//入口方式 0列表 1企业详情
    [params setValue:[NSString stringWithFormat:@"%ld",_current] forKey:@"page"];
    [params setValue:@"10" forKey:@"rows"];
    [params setValue:_position forKey:@"position"];//经纬度

    [params setValue:_distance forKey:@"distance"];//距离,
    [params setValue:_registerCapital forKey:@"registerCapital"];//注册资本,
    [params setValue:_registerYear forKey:@"registerYear"];//注册年限,0:一年内、1：1-2年、2：2-3年、3：3-5年、4：5-10年、5：10年以上
    [params setValue:_status forKey:@"status"];//企业状态,传文字
    [params setValue:_capitalType forKey:@"capitalType"];//资本类型,0：人民币、1：美元
    
    [[DDHttpManager sharedInstance]sendPostRequest:KHttpRequest_findNearCompany params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"**********附近同行数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            [_loadingView hiddenLoadingView];
            [_dataArray removeAllObjects];
            
            if ([response.data isKindOfClass:[NSDictionary class]]) {
               
                _model = [[DDNearCompanyModel alloc]initWithDictionary:response.data error:nil];
                [_dataArray addObjectsFromArray:_model.result];
                NSString * totalString = [NSString stringWithFormat:@"为您找到 %@ 家公司",_model.numFound];
                NSMutableAttributedString * attributedString = [DDUtils adjustTextColor:(NSString *)totalString rangeText:_model.numFound color:KColorBlackTitle];
                self.headerLab.attributedText = attributedString;
                if (_model.result.count >= 10) {
                    //加载更多
                    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                        [self addData];
                    }];
                }else{
                    [_tableView.mj_footer removeFromSuperview];
                }
                
                //没有数据
                if (_dataArray.count == 0) {
                    [_noResultView showWithTitle:@"没有帮您找到想要的公司" subTitle:@"重新搜索看看" image:@"noResult_company"];
                }else{
                    [_noResultView hide];
                }
                
            }
        } else {
            [_loadingView failureLoadingView];
            [DDUtils showToastWithMessage:response.message];
        }
        [_tableView.mj_header endRefreshing];
        [_tableView reloadData];
    } failure:^(NSURLSessionDataTask *operation, id responseObject) {
        [_tableView.mj_header endRefreshing];
        [DDUtils showToastWithMessage:kRequestFailed];
        [_loadingView failureLoadingView];
    }];
}

- (void)addData{
    if ([_position isEqual:@"0"]) {
        return;
    }
    _current ++;
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:_enterpriseId forKey:@"entId"];
    [params setValue:_type forKey:@"type"];//入口方式 0列表 1企业详情
    [params setValue:[NSString stringWithFormat:@"%ld",_current] forKey:@"page"];
    [params setValue:@"10" forKey:@"rows"];
    [params setValue:_position forKey:@"position"];//经纬度

    [params setValue:_distance forKey:@"distance"];//距离,
    [params setValue:_registerCapital forKey:@"registerCapital"];//注册资本,
    [params setValue:_registerYear forKey:@"registerYear"];//注册年限,0:一年内、1：1-2年、2：2-3年、3：3-5年、4：5-10年、5：10年以上
    [params setValue:_status forKey:@"status"];//企业状态,传文字
    [params setValue:_capitalType forKey:@"capitalType"];//资本类型,0：人民币、1：美元

    
    [[DDHttpManager sharedInstance] sendPostRequest:KHttpRequest_findNearCompany params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"**********附近同行数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            
            if ([response.data isKindOfClass:[NSDictionary class]]) {
        
                _model = [[DDNearCompanyModel alloc]initWithDictionary:response.data error:nil];
                [_dataArray addObjectsFromArray:_model.result];
                
                if (_model.result.count >= 10) {
                    //加载更多
                    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                        [self addData];
                    }];
                }else{
                    [_tableView.mj_footer removeFromSuperview];
                }
            }
        } else {
            [DDUtils showToastWithMessage:response.message];
        }
        [_tableView.mj_footer endRefreshing];
        [_tableView reloadData];
    } failure:^(NSURLSessionDataTask *operation, id responseObject) {
        [DDUtils showToastWithMessage:kRequestFailed];
        [_tableView.mj_footer endRefreshing];
    }];
}

#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellID = @"DDNearCompanyCell";
    DDNearCompanyCell * cell = (DDNearCompanyCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:cellID owner:self options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    DDNearCompanyResultModel * model = _dataArray[indexPath.section];
    [cell loadWithModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [DDNearCompanyCell height];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DDCompanyDetailVC * detail = [[DDCompanyDetailVC alloc] init];
    DDNearCompanyResultModel* model = _dataArray[indexPath.section];
    detail.enterpriseId = model.enterpriseId;
    [self.navigationController pushViewController:detail animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.01;
    }
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * header = [[UIView alloc] init];
    header.frame = CGRectMake(0, 0, Screen_Width, 15);
    return header;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

#pragma mark DDNearCompanyCellDelegate 点击了地址
- (void)adressLabClick:(DDNearCompanyCell*)nearCompanyCell{
    
    NSIndexPath * indexPath = [_tableView indexPathForCell:nearCompanyCell];
    
    DDNearCompanyResultModel *  nearCompanyResultModel = _dataArray[indexPath.section];
    _addressName = nearCompanyResultModel.registerAddressSource;
    
    //选择导航
    DDActionSheetView * sheetView = [[DDActionSheetView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
    NSArray * titles =[[NSArray alloc] initWithObjects:charAppleMapNav,charBaiDuMapNav,charGaoDeMapNav, nil];
    [sheetView setTitle:titles cancelTitle:KMainCancel];
    sheetView.delegate = self;
    [sheetView show];
}

#pragma mark DDActionSheetViewDelegate
-(void)actionsheetSelectButton:(DDActionSheetView *)actionSheet buttonIndex:(NSInteger)index{
    _navClickIndex = index;
    //地理编码
    [self startGeocodeAddressString];
    //定位
    [self startLocation];
}

#pragma mark -- 地理编码
- (void)startGeocodeAddressString{
    DDGeocoderManager * manger = [DDGeocoderManager sharedInstance];
    [manger geocodeAddressString:_addressName];
    manger.delegate = self;
}

#pragma mark -- DDGeocoderMangerDelegate
- (void)geocodeResult:(DDGeocoderManager*)manger  location:(CLLocation*)location{
    if (location) {
        NSLog(@"地理编码成功--%f--%f",location.coordinate.longitude,location.coordinate.latitude);
        _endCoordinate.longitude =location.coordinate.longitude;
        _endCoordinate.latitude =location.coordinate.latitude;
        [self openMapApp];
        
    }
}

#pragma mark -- 定位
- (void)startLocation{
    DDLocationManager * locationManger = [DDLocationManager sharedInstance];
    locationManger.delegate = self;
    [locationManger startLocation];
}

#pragma mark -- DDLocationMangerDelegate
- (void)locationResult:(DDLocationManager*)manger  location:(CLLocation*)location isSuccess:(BOOL)success{
    if (YES == success) {
        NSLog(@"定位成功--%f--%f",location.coordinate.longitude,location.coordinate.latitude);
        _startCoordinate.longitude =location.coordinate.longitude;
        _startCoordinate.latitude =location.coordinate.latitude;
        [self openMapApp];
    }
}
#pragma mark 打开地图app导航
- (void)openMapApp{
    //参数检验
    if (_startCoordinate.longitude>0 && _endCoordinate.longitude>0) {
        DDNavigationManager * navManger = [DDNavigationManager sharedInstance];
        navManger.startCoordinate = _startCoordinate;
        navManger.endCoordinate = _endCoordinate;
        navManger.endName =_addressName;
        
        if (1 == _navClickIndex) {
            [navManger openAppleMapNavigation];
            
        }else if (2 == _navClickIndex){
            [navManger openBaiDuMapNavigation];
            
        }else if (3 == _navClickIndex){
            [navManger openGaoDeMapNavigation];
        }
    } else {
        NSLog(@"导航参数缺失");
    }
}

#pragma mark 不限距离点击
-(void)distanceSelectClick{
    if (_isDistanceSelected==NO) {
        //将更多筛选隐藏
        _imgView2.image=[UIImage imageNamed:@"home_search_down"];
        [_moreSelectView hiddenActionSheet];
        _isMoreSelected=NO;
        
        
        _imgView1.image=[UIImage imageNamed:@"home_search_up"];
        
        _distanceSelectView=[[DDDistanceSelectView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
        _distanceSelectView.attachHeight=@"0";
        _distanceSelectView.distance=_distance;
        __weak __typeof(self) weakSelf=self;
        _distanceSelectView.hiddenBlock = ^{
            weakSelf.imgView1.image=[UIImage imageNamed:@"home_search_down"];
            
            [weakSelf.distanceSelectView hiddenActionSheet];
            
            _isDistanceSelected=NO;
        };
        _distanceSelectView.delegate=self;
        [_distanceSelectView show];
        
        _isDistanceSelected=YES;
    }
    else{
        _imgView1.image=[UIImage imageNamed:@"home_search_down"];
        
        [_distanceSelectView hiddenActionSheet];
        
        _isDistanceSelected=NO;
    }
}

#pragma mark DDDistanceSelectViewDelegate代理回调
-(void)actionsheetDisappear:(DDDistanceSelectView *)actionSheet andDistanceStr:(NSString *)distanceStr andDistanceCode:(NSString *)distanceCode{
    _distance=distanceCode;
    
    CGRect leftTextFrame = [distanceStr boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
    CGFloat leftWidth=leftTextFrame.size.width+4+15;
    if (leftWidth>=(Screen_Width/2-40)) {
        _label1.frame=CGRectMake(20, 12, (Screen_Width/2-40)-4-15, 15);
        _imgView1.frame=CGRectMake(CGRectGetMaxX(_label1.frame)+4, 12, 15, 15);
    }
    else{
        _label1.frame=CGRectMake((Screen_Width/2-leftWidth)/2, 12, leftWidth-4-15, 15);
        _imgView1.frame=CGRectMake(CGRectGetMaxX(_label1.frame)+4, 12, 15, 15);
    }
    
    _label1.text=distanceStr;
    
    [self requestData];
}


#pragma mark 更多筛选点击
-(void)moreSelectClick{
    if (_isMoreSelected==NO) {
        //将区域筛选隐藏
        _imgView1.image=[UIImage imageNamed:@"home_search_down"];
        [_distanceSelectView hiddenActionSheet];
        _isDistanceSelected=NO;
        
        
        _imgView2.image=[UIImage imageNamed:@"home_search_up"];
        
        _moreSelectView=[[DDMoreSelectView alloc]initWithFrame:CGRectMake(0, 39+60, Screen_Width, Screen_Height-KNavigationBarHeight-39-60)];
        _moreSelectView.attachHeight=@"0";
        _moreSelectView.registerCapital=_registerCapital;
        _moreSelectView.registerYear=_registerYear;
        _moreSelectView.status=_status;
        _moreSelectView.capitalType=_capitalType;
        __weak __typeof(self) weakSelf=self;
        _moreSelectView.hiddenBlock = ^{
            weakSelf.imgView2.image=[UIImage imageNamed:@"home_search_down"];
            
            [weakSelf.moreSelectView hiddenActionSheet];
            
            _isMoreSelected=NO;
        };
        _moreSelectView.delegate=self;
        [_moreSelectView show];
        
        _isMoreSelected=YES;
    }
    else{
        _imgView2.image=[UIImage imageNamed:@"home_search_down"];
        
        [_moreSelectView hiddenActionSheet];
        
        _isMoreSelected=NO;
    }
}

#pragma mark DDMoreSelectViewDelegate代理回调
-(void)actionsheetDisappear:(DDMoreSelectView *)actionSheet andCaptical:(NSString *)captical andYear:(NSString *)year andStatus:(NSString *)status andType:(NSString *)type{
    _registerCapital=captical;
    _registerYear=year;
    _status=status;
    _capitalType=type;
    
    
    [self requestData];
}

#pragma mark 地区定位
-(void)startLocationData{
    //    DDLocationManager *locationManager=[DDLocationManager sharedInstance];
    //    locationManager.delegate=self;
    //    [locationManager startLocation];
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
    NSLog(@"百度定位发生错误 %@",error);
    
    DDUserManager * userManger = [DDUserManager sharedInstance];
    userManger.longitude = [NSString stringWithFormat:@"0"];
    userManger.latitude = [NSString stringWithFormat:@"0"];
    //    [self startLocation];
}

//连续定位回调函数。
- (void)BMKLocationManager:(BMKLocationManager * _Nonnull)manager didUpdateLocation:(BMKLocation * _Nullable)location orError:(NSError * _Nullable)error{
    NSLog(@"百度定位成功");
    
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
    _position = [NSString stringWithFormat:@"%@ %@",userManger.longitude,userManger.latitude];
     [self requestData];
}

@end
