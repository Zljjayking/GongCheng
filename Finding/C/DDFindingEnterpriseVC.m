//
//  DDFindingEnterpriseVC.m
//  GongChengDD
//
//  Created by xzx on 2018/11/2.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDFindingEnterpriseVC.h"
#import "MJRefresh.h"
#import "DDNavigationUtil.h"
#import "DDLoginCheckVC.h"//登录注册页面
#import "DataLoadingView.h"//加载页面
#import "DDNoResultView.h"//无数据视图
#import "DDCompanyListCell.h"//cell
#import "DDCompanyList2Cell.h"//cell
#import "DDCompanyDetailVC.h"//公司详情页面
#import "DDAreaSelectTableView.h"//市的选择View
#import "DDCertiTypeSelectVC.h"//资质类别及等级页面
#import "DDSearchCompanyListModel.h"//model
#import "DDSearchHistoryDAOAndDB.h"//搜索历史数据库操作类
#import <BMKLocationkit/BMKLocationComponent.h>//百度地图定位

@interface DDFindingEnterpriseVC ()<UITableViewDelegate,UITableViewDataSource,AreaSelectTableViewDelegate,DDCertiTypeSelectDelegate,UITextFieldDelegate,UITabBarControllerDelegate,BMKLocationManagerDelegate>

{
    UIView *_topBgView;
    UITextField *_textField;
    NSString *_searchText;//搜索的文本
    NSString *_firstLocaStr;
    
    NSInteger currentPage;
    NSInteger pageCount;
    NSMutableArray *_dataSourceArr;
    NSMutableDictionary *_dict;
    
    
    //UIImageView *_imgView1;//放左边那个城市选择小箭头
    UILabel *_label2;//放右边那个资质等级选择文字
    UIImageView *_imgView2;//放右边那个资质等级选择小箭头
    
    UILabel *_leftLab;//"搜索到"三个字的label
    UILabel *_numLabel;//总计数量label
    UILabel *_rightLab;//"个公司"三个字的label
    UILabel *_numLabel2;
    UILabel *_rightLab2;
    
    BOOL _isCitySelected;//判断是否点开了城市选择视图
    //CitySelectTableView *_citySelectTableView;//区域筛选视图
    
    NSString *_certTypeLevels;//资质筛选等级
    NSString *_region;//地区筛选
    
    NSInteger _section;//组数，记录资质等级筛选
    NSInteger _rows;//行数，记录资质等级筛选
 
    BOOL isLastData;
   
}
@property (nonatomic,strong) DataLoadingView *loadingView;
@property (nonatomic,strong) DDNoResultView *noResultView;//无数据视图
@property (nonatomic,strong) UIImageView *imgView1;//放左边那个城市选择小箭头
@property (nonatomic,strong) DDAreaSelectTableView *citySelectTableView;//区域筛选视图
@property (nonatomic,copy) NSString *certTypeId;//资质id
@property (nonatomic,copy) NSString *certTypeCode;//资质级别code
@property (nonatomic,strong)DDCertiAndLevelModel * selectCertiModel;//记录选择到的资质,用来传值让子页面高亮,
@property (nonatomic,strong) BMKLocationManager *baiduLocationManager;//百度定位
@property (nonatomic, strong) UILabel *label1;//放左边那个城市选择文字
@end

@implementation DDFindingEnterpriseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=kColorBackGroundColor;
    _certTypeLevels=@"";
    _section=0;
    _rows=0;
    _searchText=@"";
    _isCitySelected=NO;
    _dataSourceArr=[[NSMutableArray alloc]init];
//    [self editNavItem];
    [self createChooseBtns];
    [self createTableView];
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
    [_loadingView showLoadingView];
    _label1.textColor = KColorBlackTitle;
    [self justicePower];
}

#pragma mark 创建加载视图
-(void)createLoadView{
    __weak __typeof(self) weakSelf=self;
    _noResultView=[[DDNoResultView alloc]initWithFrame:CGRectMake(0, 39, Screen_Width, Screen_Height-KNavigationBarHeight-39-KTabbarHeight)];
    [self.view addSubview:_noResultView];
    
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
    [params setValue:_searchText forKey:@"keys"];
    [params setValue:@"2" forKey:@"searchType"];
    [params setValue:@"2" forKey:@"flag"];
    [params setValue:_region forKey:@"region"];
    [params setValue:_certTypeId forKey:@"certTypeLevels"];//资质ID
    [params setValue:_certTypeCode forKey:@"level"];//资质等级code
    [params setValue:[NSString stringWithFormat:@"%ld",currentPage] forKey:@"page"];
    [params setValue:@"10" forKey:@"rows"];
    [[DDHttpManager sharedInstance]sendPostRequest:KHttpRequest_queryHighLightList params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
//        NSLog(@"**********公司搜索结果数据***************%@",responseObject);
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
                
                if (pageCount>0) {
                    NSArray *listArr=_dict[@"result"];
                    //给数量label赋值
                    NSString *totlaNum=[NSString stringWithFormat:@"%@",_dict[@"numFoundCount"]];
                    _numLabel.text=totlaNum;
                    CGRect numberFrame = [totlaNum boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize26} context:nil];
                    _numLabel.frame=CGRectMake(CGRectGetMaxX(_leftLab.frame), 12, numberFrame.size.width, 15);
                    CGRect textFrame = [@"家企业，当前区域共有" boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize26} context:nil];
                    _rightLab.frame=CGRectMake(CGRectGetMaxX(_numLabel.frame), 12, textFrame.size.width, 15);
                    
                    NSString *totlaNum2=[NSString stringWithFormat:@"%@",_dict[@"numFound"]];
                    _numLabel2.text=totlaNum2;
                    CGRect numberFrame2 = [totlaNum2 boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
                    _numLabel2.frame=CGRectMake(CGRectGetMaxX(_rightLab.frame), 12, numberFrame2.size.width, 15);
                    _rightLab2.frame=CGRectMake(CGRectGetMaxX(_numLabel2.frame), 12, 43, 15);
                    
                    if ([_region isEqualToString:@""]) {
                        _rightLab.text=@"家企业";
                        _numLabel2.hidden=YES;
                        _rightLab2.hidden=YES;
                    }
                    else{
                        _rightLab.text=@"家企业，当前区域共有";
                        _numLabel2.hidden=NO;
                        _rightLab2.hidden=NO;
                    }
                    
                    if (listArr.count!=0) {
                        [_noResultView hiddenNoDataView];
                        for (NSDictionary *dic in listArr) {
                            DDSearchCompanyListModel *model = [[DDSearchCompanyListModel alloc]initWithDictionary:dic error:nil];
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
                        [_noResultView showNoResultViewWithTitle:@"企业信息" andImage:@"noResult_company"];
                    }
                    [self.tableView reloadData];
                    [self endRefrshing:YES];
                }else{
                    isLastData = YES;
                    [_noResultView showNoResultViewWithTitle:@"企业信息" andImage:@"noResult_company"];
                }
            }
            else{
                [_noResultView showNoResultViewWithTitle:@"企业信息" andImage:@"noResult_company"];
                isLastData = YES;
                [self endRefrshing:NO];
            }
        }
        else{
            [_noResultView showNoResultViewWithTitle:@"企业信息" andImage:@"noResult_company"];
            [self endRefrshing:NO];
        }
    }  failure:^(NSURLSessionDataTask *operation, id responseObject)  {
        [self endRefrshing:NO];
        [DDUtils showToastWithMessage:kRequestFailed];
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
                _tableView.mj_footer = nil;
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
    UIButton *areaSelectBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, Screen_Width/2, 39)];
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
    if (leftWidth>=Screen_Width/2-5) {
        _label1.frame=CGRectMake(5, 12, Screen_Width/2-5-4-15, 15);
        _imgView1.frame=CGRectMake(CGRectGetMaxX(_label1.frame)+4, 12, 15, 15);
    }
    else{
        _label1.frame=CGRectMake((Screen_Width/2-leftWidth)/2, 12, leftWidth-4-15, 15);
        _imgView1.frame=CGRectMake(CGRectGetMaxX(_label1.frame)+4, 12, 15, 15);
    }
    
    [self.view addSubview:areaSelectBtn];
    
    
    UIButton *typeAndLevelBtn=[[UIButton alloc]initWithFrame:CGRectMake(Screen_Width/2, 0, Screen_Width/2, 39)];
    [typeAndLevelBtn setBackgroundColor:kColorWhite];
    
    _label2=[[UILabel alloc]init];
    _label2.text=@"资质类别";
    _label2.textColor=KColorBlackTitle;
    _label2.font=kFontSize28;
    [typeAndLevelBtn addSubview:_label2];
    
    _imgView2=[[UIImageView alloc]init];
    _imgView2.contentMode = UIViewContentModeScaleAspectFit;
    _imgView2.image=[UIImage imageNamed:@"home_search_down"];
    [typeAndLevelBtn addSubview:_imgView2];
    [typeAndLevelBtn addTarget:self action:@selector(typeAndLevelClick) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect rightTextFrame = [@"资质类别" boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize28} context:nil];
    CGFloat rightWidth=rightTextFrame.size.width+4+15;
    if (rightWidth>=Screen_Width/2-5) {
        _label2.frame=CGRectMake(5, 12, (Screen_Width/2-5)-4-15, 15);
        _imgView2.frame=CGRectMake(CGRectGetMaxX(_label2.frame)+4, 12, 15, 15);
    }
    else{
        _label2.frame=CGRectMake((Screen_Width/2-rightWidth)/2, 12, rightWidth-4-15, 15);
        _imgView2.frame=CGRectMake(CGRectGetMaxX(_label2.frame)+4, 12, 15, 15);
    }
    
    [self.view addSubview:typeAndLevelBtn];
    
    
    UIView *summaryView=[[UIView alloc]initWithFrame:CGRectMake(0, 39, Screen_Width, 39)];
    [self.view addSubview:summaryView];
    
    _leftLab=[[UILabel alloc]initWithFrame:CGRectMake(12, 12, 58, 15)];
    _leftLab.text=@"全国共有";
    _leftLab.textColor=KColorGreySubTitle;
    _leftLab.font=kFontSize26;
    [summaryView addSubview:_leftLab];
    
    _numLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_leftLab.frame), 12, 1, 15)];
    _numLabel.text=@"";
    _numLabel.textColor=KColorBlackTitle;
    _numLabel.font=kFontSize26;
    [summaryView addSubview:_numLabel];
    
    CGRect textFrame = [@"家企业，当前区域共有" boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize26} context:nil];
    _rightLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_numLabel.frame), 12, textFrame.size.width, 15)];
    _rightLab.text=@"家企业，当前区域共有";
    _rightLab.textColor=KColorGreySubTitle;
    _rightLab.font=kFontSize26;
    [summaryView addSubview:_rightLab];
    
    _numLabel2=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_rightLab.frame), 12, 1, 15)];
    _numLabel2.text=@"";
    _numLabel2.textColor=KColorBlackTitle;
    _numLabel2.font=kFontSize26;
    [summaryView addSubview:_numLabel2];
    
    _rightLab2=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_numLabel2.frame), 12, 43, 15)];
    _rightLab2.text=@"家企业";
    _rightLab2.textColor=KColorGreySubTitle;
    _rightLab2.font=kFontSize26;
    [summaryView addSubview:_rightLab2];
    
    _citySelectTableView=[[DDAreaSelectTableView alloc]initWithFrame:CGRectMake(0, 39, Screen_Width, Screen_Height-KNavigationBarHeight-39)];
    _citySelectTableView.isNeedArea = YES;
    if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status){
        //定位不能用
        
    }
    else{
        if (![DDUtils isEmptyString:manager.city]) {
            _citySelectTableView.type=@"1";
        }
    }
    
    _citySelectTableView.attachHeight=@"45";
    __weak __typeof(self) weakSelf=self;
    _citySelectTableView.hiddenBlock = ^{
        weakSelf.imgView1.image=[UIImage imageNamed:@"home_search_down"];
        weakSelf.label1.textColor = KColorBlackTitle;
        //[weakSelf.citySelectTableView hiddenActionSheet];
        [weakSelf.citySelectTableView hidden];
        
        _isCitySelected=NO;
    };
    _citySelectTableView.delegate=self;
    [_citySelectTableView show];
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
    if(_dataSourceArr.count == 0){
        return nil;
    }
        
    DDSearchCompanyListModel * model = _dataSourceArr[indexPath.section];
    
    static NSString * cellID = @"DDCompanyList2Cell";
    DDCompanyList2Cell * cell = (DDCompanyList2Cell*)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
    }
    
    [cell loadDataWithModel3:model];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _imgView1.image=[UIImage imageNamed:@"home_search_down"];
    [_citySelectTableView hidden];
    _isCitySelected=NO;
    
    DDSearchCompanyListModel *model=_dataSourceArr[indexPath.section];
    
    DDCompanyDetailVC *companyDetail=[[DDCompanyDetailVC alloc]init];
    companyDetail.enterpriseId=model.enterpriseId;
    companyDetail.hidesBottomBarWhenPushed=YES;
    [self.mainViewContoller.navigationController pushViewController:companyDetail animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    DDSearchCompanyListModel * model = _dataSourceArr[indexPath.section];
    if(![DDUtils isEmptyString:model.unitName]){
        CGSize labelSize = [[NSString stringWithFormat:@"%@",model.unitName] boundingRectWithSize:CGSizeMake(Screen_Width-66, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:kFontSize34} context:nil].size;
        return labelSize.height+142;
    }
    return 162;;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (_dataSourceArr.count == 0) {
        return nil;
    }
    DDSearchCompanyListModel *model=_dataSourceArr[section];
    if ([DDUtils isEmptyString:model.usedNames]) {
        return nil;
    }
    else{
        UIView *footerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 40)];
        footerView.backgroundColor=kColorWhite;
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(12, 12.5, Screen_Width-54, 15)];
        label.attributedText=model.usedNamesAttriString;
        label.font=kFontSize28;
        label.lineBreakMode = NSLineBreakByTruncatingTail;
        [footerView addSubview:label];
        
        UIButton *btn=[[UIButton alloc]initWithFrame:footerView.frame];
        [footerView addSubview:btn];
        btn.tag=150+section;
        [btn addTarget:self action:@selector(companyClick:) forControlEvents:UIControlEventTouchUpInside];
        
        return footerView;
    }
}

//点击公司名称
-(void)companyClick:(UIButton *)sender{
    _imgView1.image=[UIImage imageNamed:@"home_search_down"];
    [_citySelectTableView hidden];
    _isCitySelected=NO;
    DDSearchCompanyListModel *model=_dataSourceArr[sender.tag-150];
    
    DDCompanyDetailVC *companyDetail=[[DDCompanyDetailVC alloc]init];
    companyDetail.enterpriseId=model.enterpriseId;
    companyDetail.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:companyDetail animated:YES];
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
    DDSearchCompanyListModel *model=_dataSourceArr[section];
    
    if ([DDUtils isEmptyString:model.usedNames]) {
        return CGFLOAT_MIN;
    }
    else{
        return 40;
    }
}

#pragma mark 点击城市选择
-(void)areaSelectClick{
    if (_isCitySelected==NO) {
        _label1.textColor = kColorBlue;
        _imgView1.image=[UIImage imageNamed:@"home_search_up"];
        
        [_citySelectTableView noHidden];
        [_textField resignFirstResponder];
        
        _isCitySelected=YES;
    }
    else{
        _label1.textColor = KColorBlackTitle;
        _imgView1.image=[UIImage imageNamed:@"home_search_down"];
        [_citySelectTableView hidden];
        
        _isCitySelected=NO;
    }
}

#pragma mark AreaSelectTableViewDelegate代理回调
-(void)actionsheetDisappear:(DDAreaSelectTableView *)actionSheet andAreaInfo:(NSString *)area{
    _label1.text=area;
    _label1.textColor = KColorBlackTitle;
    if ([area containsString:@"直辖县"]) {
        if ([area containsString:@","]) {
            NSRange range = [area rangeOfString:@","];
            NSString *regionStr=[area substringFromIndex:(range.location+1)];
            _label1.text=regionStr;
        }
    }
    [_label1 sizeToFit];
    if (_label1.frameWidth>130) {
        _label1.frameWidth = 130;
    }
    _label1.frame=CGRectMake(Screen_Width/4-_label1.frameWidth/2-9.5, 12, _label1.frameWidth, 15);
    _label1.textAlignment = NSTextAlignmentCenter;
    _imgView1.frame=CGRectMake(CGRectGetMaxX(_label1.frame)+4, 12, 15, 15);
    
    NSString *areaStr=area;
    if ([areaStr containsString:@"全省"]) {
        areaStr=[areaStr stringByReplacingOccurrencesOfString:@"全省" withString:@""];
    }
    else if ([areaStr containsString:@"市全市"]) {
        areaStr=[areaStr stringByReplacingOccurrencesOfString:@"市全市" withString:@""];
    }
    else if ([areaStr containsString:@"全区"]) {
        areaStr=[areaStr stringByReplacingOccurrencesOfString:@"全区" withString:@""];
    }
    else if ([areaStr containsString:@"全州"]) {
        areaStr=[areaStr stringByReplacingOccurrencesOfString:@"全州" withString:@""];
    }
    else if ([areaStr containsString:@"全级"]) {
        areaStr=[areaStr stringByReplacingOccurrencesOfString:@"全级" withString:@""];
    }
    else if ([areaStr containsString:@"全盟"]) {
        areaStr=[areaStr stringByReplacingOccurrencesOfString:@"全盟" withString:@""];
    }else if ([areaStr isEqualToString:@"北京市"]||[areaStr isEqualToString:@"上海市"]||[areaStr isEqualToString:@"天津市"]) {
        areaStr = [areaStr substringToIndex:areaStr.length-1];
    }
    _region=areaStr;
//    _label1.text=_region;
    if ([areaStr isEqualToString:@"全国"]) {
        _region=@"";
    }
    
    [self requestData:YES andClear:YES];
}

#pragma mark 点击资质类别选择
-(void)typeAndLevelClick{
    _label1.textColor = KColorBlackTitle;
    _imgView1.image=[UIImage imageNamed:@"home_search_down"];
    //[_citySelectTableView hiddenActionSheet];
    [_citySelectTableView hidden];
    _isCitySelected=NO;
    
    DDCertiTypeSelectVC *certiAndLevel= [[DDCertiTypeSelectVC alloc] init];
    certiAndLevel.delegate = self;
    certiAndLevel.certiType=_certTypeLevels;
    certiAndLevel.section=_section;
    certiAndLevel.rows=_rows;
    certiAndLevel.passValueModel = _selectCertiModel;
    certiAndLevel.hidesBottomBarWhenPushed=YES;
    [self.mainViewContoller.navigationController pushViewController:certiAndLevel animated:YES];
    
}

#pragma mark DDCertiTypeSelectDelegate代理回调
//选择了资质类别和等级(带模型)
-(void)certiAndLevelSelect:(DDCertiTypeSelectVC *)certiSelectVC andCertiStr:(NSString *)certiStr andSection:(NSInteger)section andRows:(NSInteger)rows certiAndLevelModel:(DDCertiAndLevelModel *)certiAndLevelModel codeModel:(DDCodeModel *)codeModel{
//    NSLog(@"选择资质类别及等级 %@  %ld  %ld ",certiStr,section,rows);
    
    _certTypeLevels=certiStr;
    _section=section;
    _rows=rows;
    
    NSString *tempStr = certiStr;
    //建筑业资质  22 ；  电力承装承修  23；勘察资质  24；设计资质 25；监理资质  26；招标代理 27；造价咨询 28；
    if ([tempStr isEqualToString:@"22"]) {
        tempStr = @"建筑业资质";
    }
    else if([tempStr isEqualToString:@"23"]){
        tempStr = @"承装(修、试)电力设施许可证";
    }
    else if([tempStr isEqualToString:@"24"]){
        tempStr = @"勘察资质";
    }
    else if([tempStr isEqualToString:@"25"]){
        tempStr = @"设计资质";
    }
    else if([tempStr isEqualToString:@"26"]){
        tempStr = @"监理资质";
    }
    else if([tempStr isEqualToString:@"27"]){
        tempStr = @"招标代理机构";
    }
    else if([tempStr isEqualToString:@"28"]){
        tempStr = @"造价咨询企业";
    }
    else if([tempStr isEqualToString:@"29"]){
        tempStr = @"设计与施工一体化";
    }else if([tempStr isEqualToString:@"21"]){
        tempStr = @"消防技术服务机构";
    }else if([tempStr isEqualToString:@"51"]){
        tempStr = @"信息系统集成及服务资质";
    }else if([tempStr isEqualToString:@"52"]){
        tempStr = @"安防工程相关资质";
    }else if([tempStr isEqualToString:@"53"]){
        tempStr = @"信息通信建设服务能力资质";
    }else if([tempStr isEqualToString:@"54"]){
        tempStr = @"园林绿化资质";
    }
    else if([tempStr isEqualToString:@""]){
        tempStr = @"全部";
    }
    
    CGRect rightTextFrame = [tempStr boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
    CGFloat rightWidth=rightTextFrame.size.width+4+15;
    if (rightWidth>=(Screen_Width/2-5)) {
        _label2.frame=CGRectMake(5, 12, Screen_Width/2-9-15, 15);
        _imgView2.frame=CGRectMake(CGRectGetMaxX(_label2.frame)+4, 12, 15, 15);
    }
    else{
        _label2.frame=CGRectMake((Screen_Width/2-rightWidth)/2, 12, rightWidth-4-15, 15);
        _imgView2.frame=CGRectMake(CGRectGetMaxX(_label2.frame)+4, 12, 15, 15);
    }
    
    _label2.text=tempStr;

    
    if (certiAndLevelModel == nil) {
        //_certTypeId = @"";
        _certTypeId = _certTypeLevels;
        _certTypeCode = @"";
    }
    else{
        _certTypeId = certiAndLevelModel.certTypeId;
        _certTypeCode = codeModel.code;
    }
    
    _selectCertiModel = certiAndLevelModel;
    
//    NSLog(@"++++ %@ %@",certiAndLevelModel.certTypeId,codeModel.code);
    [self requestData:YES andClear:YES];
}
#pragma mark 弹出登录注册页面
- (void)presentLoginVCWithIndexPath:(NSIndexPath *)indexPath{
    DDLoginCheckVC * vc = [[DDLoginCheckVC alloc] init];
    vc.loginSuccessBlock = ^{
        DDSearchCompanyListModel *model=_dataSourceArr[indexPath.section];
        DDCompanyDetailVC *companyDetail=[[DDCompanyDetailVC alloc]init];
        companyDetail.enterpriseId=model.enterpriseId;
        companyDetail.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:companyDetail animated:YES];
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
        _label1.text = rgcdata.city;
        CGRect leftTextFrame;
        leftTextFrame = [_label1.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize28} context:nil];
        CGFloat leftWidth=leftTextFrame.size.width+4+15;
        if (leftWidth>=Screen_Width/2-5) {
            _label1.frame=CGRectMake(5, 12, Screen_Width/2-5-4-15, 15);
            _imgView1.frame=CGRectMake(CGRectGetMaxX(_label1.frame)+4, 12, 15, 15);
        }
        else{
            _label1.frame=CGRectMake((Screen_Width/2-leftWidth)/2, 12, leftWidth-4-15, 15);
            _imgView1.frame=CGRectMake(CGRectGetMaxX(_label1.frame)+4, 12, 15, 15);
        }
    }
    [self requestData:YES andClear:YES];
}
-(void)viewWillCloseView{
    [_citySelectTableView hidden];
    self.imgView1.image=[UIImage imageNamed:@"home_search_down"];
    _isCitySelected = NO;
}
@end
