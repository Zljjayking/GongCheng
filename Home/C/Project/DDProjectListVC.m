//
//  DDProjectListVC.m
//  GongChengDD
//
//  Created by xzx on 2018/5/17.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDProjectListVC.h"
#import "MJRefresh.h"
#import "DDNavigationUtil.h"
#import "DDLoginCheckVC.h"//登录注册页面
#import "DataLoadingView.h"//加载页面
#import "DDNoResultView.h"//无数据视图
#import "DDSearchProjectListModel.h"//model
//#import "DDProjectListCell.h"//cell
#import "DDNewFindingWinBiddingProjectCell.h"//cell

#import "DDAreaSelectTableView.h"//市的选择View
#import "DDFindingCallBiddingMoneySelectView.h"//金额选择页面
#import "DDFindingCallBiddingProjectTypeSelectView.h"//工程类别选择视图
#import "DDFindingWinBiddingDateSelectView.h"//中标时间选择视图
#import "DDSearchHistoryDAOAndDB.h"//搜索历史数据库操作类
#import "DDProjectDetailVC.h"//项目详情页面
#import "DDCompanyDetailVC.h"//公司详情页面
#import "DDPeopleDetailVC.h"//人员详情页面
#import "DDUMengEventDefines.h"

@interface DDProjectListVC ()<UITableViewDelegate,UITableViewDataSource,AreaSelectTableViewDelegate,DDFindingCallBiddingProjectTypeSelectViewDelegate,DDFindingWinBiddingDateSelectViewDelegate,DDFindingCallBiddingMoneySelectViewDelegate>

{
    NSInteger currentPage;
    NSInteger pageCount;
    NSMutableArray *_dataSourceArr;
    NSMutableDictionary *_dict;
    
    UILabel *_label1;//放左边那个城市选择文字
    UILabel *_label2;//放中间那个工程类别选择文字
    UILabel *_label3;//放中间那个金额选择文字
    UILabel *_label4;//放右边那个中标时间选择文字
    
    UILabel *_leftLab;//"搜索到"三个字的label
    UILabel *_numLabel;//总计数量label
    UILabel *_rightLab;//"个公司"三个字的label
    
    BOOL _isCitySelected;//判断是否点开了城市选择视图
    BOOL _isProjectTypeSelected;//判断是否点开了工程类别选择视图
    BOOL _isMoneySelected;//判断是否点开了金额筛选视图
    BOOL _isDateSelected;//判断是否点开了中标时间筛选视图
    
    NSString *_region;//地区筛选
    NSString *_projectTypeId;//工程类别筛选
    NSString *_projectTypeStr;//工程类别筛选
    NSString *_amount;//金额筛选
    NSString *_date;//中标时间筛选
    NSString *_moneyId;//用来金额高亮显示用
}
@property (nonatomic,strong) DataLoadingView *loadingView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) DDNoResultView *noResultView;//无数据视图
@property (nonatomic,strong) UIImageView *imgView1;//放左边那个城市选择小箭头
@property (nonatomic,strong) DDAreaSelectTableView *areaSelectTableView;//区域筛选视图
@property (nonatomic,strong) UIImageView *imgView2;//放中间那个工程类别选择小箭头
@property (nonatomic,strong) DDFindingCallBiddingProjectTypeSelectView *projectTypeSelectView;//工程类别筛选视图
@property (nonatomic,strong) UIImageView *imgView3;//放中间那个金额选择小箭头
@property (nonatomic,strong) DDFindingCallBiddingMoneySelectView *moneySelectView;//金额筛选视图
@property (nonatomic,strong) UIImageView *imgView4;//放右边那个中标时间选择小箭头
@property (nonatomic,strong) DDFindingWinBiddingDateSelectView *dateSelectView;//中标时间筛选视图

@end

@implementation DDProjectListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [MobClick event:search_project];
    self.view.backgroundColor=kColorBackGroundColor;
    _amount=@"";//金额筛选
    _region=@"";//地区筛选
    _projectTypeId=@"";
    _projectTypeStr=@"";
    _date=@"";
    _moneyId=@"0";
    _searchText=@"";
    _isCitySelected=NO;
    _isProjectTypeSelected=NO;
    _isMoneySelected=NO;
    _isDateSelected=NO;
    _dataSourceArr=[[NSMutableArray alloc]init];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveNotice:) name:@"globalSearchNotice" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveHiddenActionView) name:@"hiddenActionView" object:nil];
    [self createChooseBtns];
    [self createTableView];
    [self createLoadView];
    //[self requestData];
}

//收到全局搜索文字的改变
-(void)receiveNotice:(NSNotification *)notice{
    _imgView1.image=[UIImage imageNamed:@"home_search_down"];
    //[_areaSelectTableView hiddenActionSheet];
    [_areaSelectTableView hidden];
    _isCitySelected=NO;
    
    [_projectTypeSelectView hiddenActionSheet];
    self.imgView2.image=[UIImage imageNamed:@"home_search_down"];
    _isProjectTypeSelected = NO;
    
    _imgView3.image=[UIImage imageNamed:@"home_search_down"];
    [_moneySelectView hiddenActionSheet];
    _isMoneySelected=NO;
    
    _imgView4.image=[UIImage imageNamed:@"home_search_down"];
    [_dateSelectView hiddenActionSheet];
    _isDateSelected=NO;
    
//    self.searchText=notice.userInfo[@"searchText"];
//    [self requestData];
}

//收弹出视图
-(void)receiveHiddenActionView{
    _imgView1.image=[UIImage imageNamed:@"home_search_down"];
    //[_areaSelectTableView hiddenActionSheet];
    [_areaSelectTableView hidden];
    _isCitySelected=NO;
    
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

#pragma mark 创建加载视图
-(void)createLoadView{
    __weak __typeof(self) weakSelf=self;
    _noResultView=[[DDNoResultView alloc]initWithFrame:CGRectMake(0, 39, Screen_Width, Screen_Height-KNavigationBarHeight-39-60)];
    [self.view addSubview:_noResultView];
    
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
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    _tableView.scrollEnabled=NO;
    _tableView.userInteractionEnabled=NO;
    
    if (_dataSourceArr.count>0) {
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    }
    
    currentPage = 1;
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:self.searchText forKey:@"keys"];
    [params setValue:@"53" forKey:@"searchType"];
    [params setValue:_region forKey:@"region"];
    [params setValue:_projectTypeStr forKey:@"projectType"];
    [params setValue:_amount forKey:@"amount"];
    [params setValue:_date forKey:@"date"];
    [params setValue:[NSString stringWithFormat:@"%ld",currentPage] forKey:@"page"];
    [params setValue:@"10" forKey:@"rows"];
    
    
    [[DDHttpManager sharedInstance]sendPostRequest:KHttpRequest_queryHighLightList params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"**********工程搜索结果数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        __weak __typeof(self) weakSelf = self;
        [_loadingView hiddenLoadingView];
        if (response.isSuccess) {
            if (![response isEmpty]) {
                //[_dataSourceArr removeAllObjects];
                [_loadingView hiddenLoadingView];
                _dict = responseObject[KData];
                pageCount = [_dict[@"numFound"] integerValue];
                if (pageCount>0) {
                    NSArray *listArr=_dict[@"result"];
                    //给数量label赋值
                    NSString *totlaNum=[NSString stringWithFormat:@"%@",_dict[@"numFound"]];
                    _numLabel.text=totlaNum;
                    CGRect numberFrame = [totlaNum boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
                    _numLabel.frame=CGRectMake(CGRectGetMaxX(_leftLab.frame)+2, 15, numberFrame.size.width, 15);
                    _rightLab.frame=CGRectMake(CGRectGetMaxX(_numLabel.frame)+2, 15, 70, 15);
                    
                    if (listArr.count!=0) {
                        [_noResultView hiddenNoDataView];
                        [_dataSourceArr removeAllObjects];
                        for (NSDictionary *dic in listArr) {
                            DDSearchProjectListModel *model = [[DDSearchProjectListModel alloc]initWithDictionary:dic error:nil];
                            [model handle];
                            [_dataSourceArr addObject:model];
                        }
                        if (listArr.count<pageCount) {
                            self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                                [weakSelf addData];
                            }];
                        }else{
                            [_tableView.mj_footer removeFromSuperview];
                        }
                    }
                    else{
                        [_noResultView showNoResultViewWithTitle:@"项目信息" andImage:@"noResult_project"];
                    }
                }else{
                   [_noResultView showNoResultViewWithTitle:@"项目信息" andImage:@"noResult_project"];
                }
            }
            else{
                [_noResultView showNoResultViewWithTitle:@"项目信息" andImage:@"noResult_project"];
            }
        }
        else{
            [_noResultView showNoResultViewWithTitle:@"项目信息" andImage:@"noResult_project"];
        }

        [self.tableView.mj_header endRefreshing];
        
        if (_dataSourceArr.count>0) {
            [_tableView reloadData];
            [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        }
        
        _tableView.scrollEnabled=YES;
        _tableView.userInteractionEnabled=YES;
        
    }  failure:^(NSURLSessionDataTask *operation, id responseObject)  {
        [DDUtils showToastWithMessage:kRequestFailed];
        [_loadingView failureLoadingView];
    }];
}

- (void)addData{
    currentPage++;
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [params setValue:self.searchText forKey:@"keys"];
    [params setValue:@"53" forKey:@"searchType"];
    [params setValue:_region forKey:@"region"];
    [params setValue:_projectTypeStr forKey:@"projectType"];
    [params setValue:_amount forKey:@"amount"];
    [params setValue:_date forKey:@"date"];
    [params setValue:[NSString stringWithFormat:@"%ld",currentPage] forKey:@"page"];
    [params setValue:@"10" forKey:@"rows"];
    
    
    [[DDHttpManager sharedInstance]sendPostRequest:KHttpRequest_queryHighLightList params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"**********工程搜索结果数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        __weak __typeof(self) weakSelf = self;
        if (response.isSuccess) {
            if (![response isEmpty]) {
                _dict = responseObject[KData];
                NSArray *listArr = _dict[@"result"];
                for (NSDictionary *dic in listArr) {
                    DDSearchProjectListModel *model = [[DDSearchProjectListModel alloc]initWithDictionary:dic error:nil];
                    [model handle];
                    [_dataSourceArr addObject:model];
                }
                
                if (_dataSourceArr.count<pageCount) {
                    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                        [weakSelf addData];
                    }];
                }
                else{
                  [_tableView.mj_footer removeFromSuperview];
                }
            }
            else{
                
            }
        }
        else{
           [DDUtils showToastWithMessage:response.message];
        }
        
        //[self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
        
    }  failure:^(NSURLSessionDataTask *operation, id responseObject)  {
        [DDUtils showToastWithMessage:kRequestFailed];
    }];
}


#pragma mark 创建筛选按钮
-(void)createChooseBtns{
    //地区选择按钮
    UIButton *areaSelectBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, Screen_Width/4, 39)];
    [areaSelectBtn setBackgroundColor:kColorWhite];
    
    _label1=[[UILabel alloc]init];
    _label1.text=@"全国";
    _label1.textColor=KColorBlackTitle;
    _label1.font=kFontSize28;
    [areaSelectBtn addSubview:_label1];
    
    _imgView1=[[UIImageView alloc]init];
    _imgView1.contentMode = UIViewContentModeScaleAspectFit;
    _imgView1.image=[UIImage imageNamed:@"home_search_down"];
    [areaSelectBtn addSubview:_imgView1];
    [areaSelectBtn addTarget:self action:@selector(areaSelectClick) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect leftTextFrame = [@"全国" boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize28} context:nil];
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
    UIView *summaryView=[[UIView alloc]initWithFrame:CGRectMake(0, 39, Screen_Width, 45)];
    [self.view addSubview:summaryView];
    
    _leftLab=[[UILabel alloc]initWithFrame:CGRectMake(12, 15, 45, 15)];
    _leftLab.text=@"搜索到";
    _leftLab.textColor=KColorGreySubTitle;
    _leftLab.font=kFontSize26;
    [summaryView addSubview:_leftLab];
    
    _numLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_leftLab.frame)+2, 15, 1, 15)];
    _numLabel.text=@"";
    _numLabel.textColor=KColorBlackTitle;
    _numLabel.font=kFontSize26;
    [summaryView addSubview:_numLabel];
    
    _rightLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_numLabel.frame)+2, 15, 70, 15)];
    _rightLab.text=@"个中标信息";
    _rightLab.textColor=KColorGreySubTitle;
    _rightLab.font=kFontSize26;
    [summaryView addSubview:_rightLab];
    
    _areaSelectTableView=[[DDAreaSelectTableView alloc]initWithFrame:CGRectMake(0, 39+60, Screen_Width, Screen_Height-KNavigationBarHeight-39-60)];
    _areaSelectTableView.isNeedArea = YES;
    _areaSelectTableView.attachHeight=@"60";
    __weak __typeof(self) weakSelf=self;
    _areaSelectTableView.hiddenBlock = ^{
        weakSelf.imgView1.image=[UIImage imageNamed:@"home_search_down"];
        
        //[weakSelf.areaSelectTableView hiddenActionSheet];
        [weakSelf.areaSelectTableView hidden];
        
        _isCitySelected=NO;
    };
    _areaSelectTableView.delegate=self;
    [_areaSelectTableView show];
}

#pragma mark 创建tableView
-(void)createTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 39+45, Screen_Width, Screen_Height-KNavigationBarHeight-39-45-60) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=kColorBackGroundColor;
    _tableView.showsVerticalScrollIndicator=YES;
    _tableView.estimatedRowHeight = 44;
    _tableView.separatorColor=KColorTableSeparator;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, KTableViewFooterViewHeight)];
    [_tableView registerClass:[DDNewFindingWinBiddingProjectCell class] forCellReuseIdentifier:@"DDNewFindingWinBiddingProjectCell"];
    
    __weak __typeof(self) weakSelf=self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestData];
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
    if (_dataSourceArr.count>0) {
        DDSearchProjectListModel *model=_dataSourceArr[indexPath.section];
        DDNewFindingWinBiddingProjectCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDNewFindingWinBiddingProjectCell" forIndexPath:indexPath];
        [cell loadDataWithModel3:model];
        if (![DDUtils isEmptyString:model.winBidOrg]) {
            cell.winBiddingBtn.userInteractionEnabled=YES;
            cell.winBiddingBtn.tag=indexPath.section;
            [cell.winBiddingBtn addTarget:self action:@selector(companyDetailClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        else{
            cell.winBiddingBtn.userInteractionEnabled=NO;
        }
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    else{
        DDNewFindingWinBiddingProjectCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDNewFindingWinBiddingProjectCell" forIndexPath:indexPath];
        return cell;
    }
    
}

#pragma mark 点击跳转到公司详情
-(void)companyDetailClick:(UIButton *)sender{
    _imgView1.image=[UIImage imageNamed:@"home_search_down"];
    [_areaSelectTableView hidden];
    _isCitySelected=NO;
    
    [_projectTypeSelectView hiddenActionSheet];
    self.imgView2.image=[UIImage imageNamed:@"home_search_down"];
    _isProjectTypeSelected = NO;
    
    _imgView3.image=[UIImage imageNamed:@"home_search_down"];
    [_moneySelectView hiddenActionSheet];
    _isMoneySelected=NO;
    
    _imgView4.image=[UIImage imageNamed:@"home_search_down"];
    [_dateSelectView hiddenActionSheet];
    _isDateSelected=NO;
    
    DDSearchProjectListModel *model=_dataSourceArr[sender.tag];
    
    DDCompanyDetailVC *companyDetailVC=[[DDCompanyDetailVC alloc]init];
    companyDetailVC.enterpriseId=model.enterpriseId;
    [self.mainViewContoller.navigationController pushViewController:companyDetailVC animated:YES];
}

#pragma mark 点击跳转到人员详情
-(void)peopleDetailClick:(UIButton *)sender{
    _imgView1.image=[UIImage imageNamed:@"home_search_down"];
    [_areaSelectTableView hidden];
    _isCitySelected=NO;
    
    [_projectTypeSelectView hiddenActionSheet];
    self.imgView2.image=[UIImage imageNamed:@"home_search_down"];
    _isProjectTypeSelected = NO;
    
    _imgView3.image=[UIImage imageNamed:@"home_search_down"];
    [_moneySelectView hiddenActionSheet];
    _isMoneySelected=NO;
    
    _imgView4.image=[UIImage imageNamed:@"home_search_down"];
    [_dateSelectView hiddenActionSheet];
    _isDateSelected=NO;
    
    if ([DDUtils isEmptyString:[DDUserManager sharedInstance].userid]) {
        [self presentLoginVCWithSender2:sender];
    }
    else{
        DDSearchProjectListModel *model=_dataSourceArr[sender.tag];
        
        DDPeopleDetailVC *peopleDetail=[[DDPeopleDetailVC alloc]init];
        peopleDetail.staffInfoId=model.staffInfoId;
        [self.mainViewContoller.navigationController pushViewController:peopleDetail animated:YES];
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _imgView1.image=[UIImage imageNamed:@"home_search_down"];
    [_areaSelectTableView hidden];
    _isCitySelected=NO;
    
    [_projectTypeSelectView hiddenActionSheet];
    self.imgView2.image=[UIImage imageNamed:@"home_search_down"];
    _isProjectTypeSelected = NO;
    
    _imgView3.image=[UIImage imageNamed:@"home_search_down"];
    [_moneySelectView hiddenActionSheet];
    _isMoneySelected=NO;
    
    _imgView4.image=[UIImage imageNamed:@"home_search_down"];
    [_dateSelectView hiddenActionSheet];
    _isDateSelected=NO;
    
    if ([DDUtils isEmptyString:[DDUserManager sharedInstance].userid]) {
        [self presentLoginVCWithIndexPath:indexPath];
    }
    else{
        DDSearchProjectListModel *model=_dataSourceArr[indexPath.section];
        //此时需要存数据库了
        //存最近搜索
        [DDSearchHistoryDAOAndDB insertRecentSearchByTypeId:@"9909" andSearchText:self.searchText];
        //存浏览历史
        NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithData:[model.title dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        [DDSearchHistoryDAOAndDB insertHistorySearchByTypeId:@"9909" andSearchResult:[DDUtils transformAttributedText:attributeStr] andGlobalType:@"2" andTransId:model.winCaseId];
        
        
        DDProjectDetailVC *projectDetail=[[DDProjectDetailVC alloc]init];
        projectDetail.winCaseId=model.winCaseId;
        [self.mainViewContoller.navigationController pushViewController:projectDetail animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    DDSearchProjectListModel *model=_dataSourceArr[indexPath.section];
    NSString *titleStr=[model.titleString string];
     CGFloat cellHeight = 0.0;
    if(![DDUtils isEmptyString:[NSString stringWithFormat:@"%@",titleStr]]){
        CGSize labelSize = [[NSString stringWithFormat:@"%@",titleStr] boundingRectWithSize:CGSizeMake(Screen_Width-WidthByiPhone6(24), 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:kFontSize34} context:nil].size;
        cellHeight =  labelSize.height;
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
        
        UIView *footerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 40)];
        footerView.backgroundColor=kColorWhite;
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(12, 12.5, Screen_Width-54, 15)];
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
            return 40;
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
        _imgView2.image=[UIImage imageNamed:@"home_search_down"];
        [_projectTypeSelectView hiddenActionSheet];
        _isProjectTypeSelected=NO;
        //将金额筛选隐藏
        _imgView3.image=[UIImage imageNamed:@"home_search_down"];
        [_moneySelectView hiddenActionSheet];
        _isMoneySelected=NO;
        //将中标时间筛选隐藏
        _imgView4.image=[UIImage imageNamed:@"home_search_down"];
        [_dateSelectView hiddenActionSheet];
        _isDateSelected=NO;
        
        _imgView1.image=[UIImage imageNamed:@"home_search_up"];
        
        [_areaSelectTableView noHidden];
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        
        _isCitySelected=YES;
    }
    else{
        _imgView1.image=[UIImage imageNamed:@"home_search_down"];
        
        //[_areaSelectTableView hiddenActionSheet];
        [_areaSelectTableView hidden];
        
        _isCitySelected=NO;
    }
}

#pragma mark CitySelectPickerView代理回调
-(void)actionsheetDisappear:(DDAreaSelectTableView *)actionSheet andAreaInfo:(NSString *)area{
    _label1.text=area;
    
    if ([area containsString:@"直辖县"]) {
        NSRange range = [area rangeOfString:@","];
        NSString *regionStr=[area substringFromIndex:(range.location+1)];
        _label1.text=regionStr;
    }
    [_label1 sizeToFit];
    CGFloat leftWidth=_label1.size.width+4+15;
    if (leftWidth>=(Screen_Width/4-5)) {
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
    }else if ([areaStr containsString:@"北京市"] || [areaStr containsString:@"天津市"] || [areaStr containsString:@"上海市"]) {
        areaStr=[areaStr stringByReplacingOccurrencesOfString:@"市" withString:@""];
    }else if ([areaStr isEqualToString:@"全国"]) {
        areaStr=@"";
    }
    _region=areaStr;
    [self requestData];
}

#pragma mark 点击工程类别筛选
-(void)projectTypeSelectClick{
    if (_isProjectTypeSelected==NO) {
        //将区域筛选隐藏
        _imgView1.image=[UIImage imageNamed:@"home_search_down"];
        //[_areaSelectTableView hiddenActionSheet];
        [_areaSelectTableView hidden];
        _isCitySelected=NO;
        //将金额筛选隐藏
        _imgView3.image=[UIImage imageNamed:@"home_search_down"];
        [_moneySelectView hiddenActionSheet];
        _isMoneySelected=NO;
        //将中标时间筛选隐藏
        _imgView4.image=[UIImage imageNamed:@"home_search_down"];
        [_dateSelectView hiddenActionSheet];
        _isDateSelected=NO;
        
        
        _imgView2.image=[UIImage imageNamed:@"home_search_up"];
        
        _projectTypeSelectView=[[DDFindingCallBiddingProjectTypeSelectView alloc]initWithFrame:CGRectMake(0, 39+60, Screen_Width, Screen_Height-KNavigationBarHeight-39-60)];
        _projectTypeSelectView.attachHeight=@"60";
        _projectTypeSelectView.typeId=_projectTypeId;
        __weak __typeof(self) weakSelf=self;
        _projectTypeSelectView.hiddenBlock = ^{
            weakSelf.imgView2.image=[UIImage imageNamed:@"home_search_down"];
            
            [weakSelf.projectTypeSelectView hiddenActionSheet];
            
            _isProjectTypeSelected=NO;
        };
        _projectTypeSelectView.delegate=self;
        [_projectTypeSelectView show];
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        
        _isProjectTypeSelected=YES;
    }
    else{
        _imgView2.image=[UIImage imageNamed:@"home_search_down"];
        
        [_projectTypeSelectView hiddenActionSheet];
        
        _isProjectTypeSelected=NO;
    }
}

#pragma mark DDFindingCallBiddingProjectTypeSelectViewDelegate代理回调
-(void)actionsheetDisappear:(DDFindingCallBiddingProjectTypeSelectView *)actionSheet andTypeStr:(NSString *)typeStr andTypeCode:(NSString *)typeCode andSelectIndex:(NSInteger)select{
    _projectTypeId=typeCode;
    
    CGRect middle1TextFrame = [typeStr boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
    CGFloat middle1Width=middle1TextFrame.size.width+4+15;
    if (middle1Width>=(Screen_Width/4-5)) {
        _label2.frame=CGRectMake(5, 12, (Screen_Width/4-9)-15, 15);
        _imgView2.frame=CGRectMake(CGRectGetMaxX(_label2.frame)+4, 12, 15, 15);
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
    
    [self requestData];
}

#pragma mark 点击金额筛选
-(void)moneySelectClick{
    if (_isMoneySelected==NO) {
        //将区域筛选隐藏
        _imgView1.image=[UIImage imageNamed:@"home_search_down"];
        //[_areaSelectTableView hiddenActionSheet];
        [_areaSelectTableView hidden];
        _isCitySelected=NO;
        //将工程类别筛选隐藏
        _imgView2.image=[UIImage imageNamed:@"home_search_down"];
        [_projectTypeSelectView hiddenActionSheet];
        _isProjectTypeSelected=NO;
        //将中标时间筛选隐藏
        _imgView4.image=[UIImage imageNamed:@"home_search_down"];
        [_dateSelectView hiddenActionSheet];
        _isDateSelected=NO;
        
        
        _imgView3.image=[UIImage imageNamed:@"home_search_up"];
        
        _moneySelectView=[[DDFindingCallBiddingMoneySelectView alloc]initWithFrame:CGRectMake(0, 39+60, Screen_Width, Screen_Height-KNavigationBarHeight-39-60)];
        _moneySelectView.attachHeight=@"60";
        _moneySelectView.moneyId=_moneyId;
        __weak __typeof(self) weakSelf=self;
        _moneySelectView.hiddenBlock = ^{
            weakSelf.imgView3.image=[UIImage imageNamed:@"home_search_down"];
            
            [weakSelf.moneySelectView hiddenActionSheet];
            
            _isMoneySelected=NO;
        };
        _moneySelectView.delegate=self;
        [_moneySelectView show];
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        
        _isMoneySelected=YES;
    }
    else{
        _imgView3.image=[UIImage imageNamed:@"home_search_down"];
        
        [_moneySelectView hiddenActionSheet];
        
        _isMoneySelected=NO;
    }
}

#pragma mark DDFindingCallBiddingMoneySelectViewDelegate代理回调
-(void)actionsheetDisappear:(DDFindingCallBiddingMoneySelectView *)actionSheet andMoneyStr:(NSString *)moneyStr andMoneyId:(NSString *)moneyId andMoneyCode:(NSString *)MoneyCode{
    _amount=MoneyCode;
    
    CGRect middle2TextFrame = [moneyStr boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
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
    
    [self requestData];
}

#pragma mark 点击中标时间筛选
-(void)dateSelectClick{
    if (_isDateSelected==NO) {
        //将区域筛选隐藏
        _imgView1.image=[UIImage imageNamed:@"home_search_down"];
        //[_areaSelectTableView hiddenActionSheet];
        [_areaSelectTableView hidden];
        _isCitySelected=NO;
        //将工程类别筛选隐藏
        _imgView2.image=[UIImage imageNamed:@"home_search_down"];
        [_projectTypeSelectView hiddenActionSheet];
        _isProjectTypeSelected=NO;
        //将金额筛选隐藏
        _imgView3.image=[UIImage imageNamed:@"home_search_down"];
        [_moneySelectView hiddenActionSheet];
        _isMoneySelected=NO;
        
        
        _imgView4.image=[UIImage imageNamed:@"home_search_up"];
        
        _dateSelectView=[[DDFindingWinBiddingDateSelectView alloc]initWithFrame:CGRectMake(0, 39+60, Screen_Width, Screen_Height-KNavigationBarHeight-39-60)];
        _dateSelectView.attachHeight=@"60";
        _dateSelectView.dateCode=_date;
        __weak __typeof(self) weakSelf=self;
        _dateSelectView.hiddenBlock = ^{
            weakSelf.imgView4.image=[UIImage imageNamed:@"home_search_down"];
            
            [weakSelf.dateSelectView hiddenActionSheet];
            
            _isDateSelected=NO;
        };
        _dateSelectView.delegate=self;
        [_dateSelectView show];
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        
        _isDateSelected=YES;
    }
    else{
        _imgView4.image=[UIImage imageNamed:@"home_search_down"];
        
        [_dateSelectView hiddenActionSheet];
        
        _isDateSelected=NO;
    }
}

#pragma mark DDFindingWinBiddingDateSelectViewDelegate代理回调
-(void)actionsheetDisappear:(DDFindingWinBiddingDateSelectView *)actionSheet andDateStr:(NSString *)dateStr andDateCode:(NSString *)dateCode{
    _date=dateCode;
    
    CGRect rightTextFrame = [dateStr boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
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
    
    [self requestData];
}

#pragma mark 弹出登录注册页面
- (void)presentLoginVCWithIndexPath:(NSIndexPath *)indexPath{
    DDLoginCheckVC * vc = [[DDLoginCheckVC alloc] init];
    vc.loginSuccessBlock = ^{
        //__weak __typeof(self) weakSelf=self;
        //[weakSelf requestTypesData];
        
        DDSearchProjectListModel *model=_dataSourceArr[indexPath.section];
        //此时需要存数据库了
        //存最近搜索
        [DDSearchHistoryDAOAndDB insertRecentSearchByTypeId:@"9909" andSearchText:self.searchText];
        //存浏览历史
        NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithData:[model.title dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        [DDSearchHistoryDAOAndDB insertHistorySearchByTypeId:@"9909" andSearchResult:[DDUtils transformAttributedText:attributeStr] andGlobalType:@"2" andTransId:model.winCaseId];
        
        
        DDProjectDetailVC *projectDetail=[[DDProjectDetailVC alloc]init];
        projectDetail.winCaseId=model.winCaseId;
        [self.mainViewContoller.navigationController pushViewController:projectDetail animated:YES];
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
        [self.mainViewContoller.navigationController pushViewController:companyDetailVC animated:YES];
    };
    
    
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [DDNavigationUtil setNavigationAndBottomLineWhiteColor:nav];
    [self showViewController:nav sender:nil];
}

#pragma mark 弹出登录注册页面
- (void)presentLoginVCWithSender2:(UIButton *)sender{
    DDLoginCheckVC * vc = [[DDLoginCheckVC alloc] init];
    vc.loginSuccessBlock = ^{
        //__weak __typeof(self) weakSelf=self;
        //[weakSelf requestTypesData];
        
        DDSearchProjectListModel *model=_dataSourceArr[sender.tag];
        
        DDPeopleDetailVC *peopleDetail=[[DDPeopleDetailVC alloc]init];
        peopleDetail.staffInfoId=model.staffInfoId;
        [self.mainViewContoller.navigationController pushViewController:peopleDetail animated:YES];
    };
    
    
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [DDNavigationUtil setNavigationAndBottomLineWhiteColor:nav];
    [self showViewController:nav sender:nil];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}


@end
