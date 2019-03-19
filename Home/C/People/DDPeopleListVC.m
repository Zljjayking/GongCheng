//
//  DDPeopleListVC.m
//  GongChengDD
//
//  Created by xzx on 2018/5/17.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDPeopleListVC.h"
#import "MJRefresh.h"
#import "DDNavigationUtil.h"
#import "DDLoginCheckVC.h"//登录注册页面
#import "DataLoadingView.h"//加载页面
#import "DDNoResultView.h"//无数据视图
//#import "DDPeopleListCell.h"//cell
#import "DDSearchBossAndSafemanListCell.h"//cell
//#import "DDSearchPeopleListModel.h"//model
#import "DDSearchBuilderAndManagerListModel.h"//model
#import "DDSearchHistoryDAOAndDB.h"//搜索历史数据库操作类
#import "DDCompanyDetailVC.h"//公司详情页面
#import "DDPeopleDetailVC.h"//人员详情页面
#import "DDAreaSelectTableView.h"//市的选择View
#import "DDFindingPeopleCertiTypeSelectView.h"//证书类别选择页面
#import "DDFindingPeopleDateSelectView.h"//有效期选择页面
#import "DDFindingPeopleContactWaySelectView.h"//联系方式选择页面
#import "DDUMengEventDefines.h"

@interface DDPeopleListVC ()<UITableViewDelegate,UITableViewDataSource,AreaSelectTableViewDelegate,DDFindingPeopleCertiTypeSelectViewDelegate,DDFindingPeopleDateSelectViewDelegate,DDFindingPeopleContactWaySelectViewDelegate>

{
    NSInteger currentPage;
    NSInteger pageCount;
    NSMutableArray *_dataSourceArr;
    NSMutableDictionary *_dict;
    
    UILabel *_label1;//放左边那个城市选择文字
    UILabel *_label2;//放中间那个证书类别选择文字
    UILabel *_label3;//放中间那个有效期选择文字
    UILabel *_label4;//放右边那个联系方式选择文字
    
    UILabel *_leftLab;//"搜索到"三个字的label
    UILabel *_numLabel;//总计数量label
    UILabel *_rightLab;//"个公司"三个字的label
    
    BOOL _isCitySelected;//判断是否点开了城市选择视图
    BOOL _isCertiTypeSelect;//判断是否点开了证书类别选择视图
    BOOL _isDateSelected;//判断是否点开了有效期选择视图
    BOOL _isContactSelected;//判断是否点开了联系方式选择视图
    
    NSString *_region;//地区筛选
    NSString *_certiId;//证书类别之证书筛选
    NSString *_majorId;//证书类别之专业筛选
    NSString *_date;//有效期筛选
    NSString *_contactId;//联系方式筛选
}
@property (nonatomic,strong) UITableView *tableView;
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

@end

@implementation DDPeopleListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [MobClick event:search_person];
    self.view.backgroundColor=kColorBackGroundColor;
    _region=@"";
    _certiId=@"";
    _majorId=@"";
    _date=@"";
    _contactId=@"";
    _isCitySelected=NO;
    _isCertiTypeSelect=NO;
    _isDateSelected=NO;
    _isContactSelected=NO;
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
    [_areaSelectTableView hidden];
    _isCitySelected=NO;
    
    _imgView2.image=[UIImage imageNamed:@"home_search_down"];
    [_certiTypeSelectView hidden];
    _isCertiTypeSelect=NO;
    
    _imgView3.image=[UIImage imageNamed:@"home_search_down"];
    [_dateSelectView hiddenActionSheet];
    _isDateSelected=NO;
    
    _imgView3.image=[UIImage imageNamed:@"home_search_down"];
    [_contactWaySelectView hiddenActionSheet];
    _isContactSelected=NO;
    
//    self.searchText=notice.userInfo[@"searchText"];
//    [self requestData];
}

//收弹出视图
-(void)receiveHiddenActionView{
    _imgView1.image=[UIImage imageNamed:@"home_search_down"];
    [_areaSelectTableView hidden];
    _isCitySelected=NO;
    
    _imgView2.image=[UIImage imageNamed:@"home_search_down"];
    [_certiTypeSelectView hidden];
    _isCertiTypeSelect=NO;
    
    _imgView3.image=[UIImage imageNamed:@"home_search_down"];
    [_dateSelectView hiddenActionSheet];
    _isDateSelected=NO;
    
    _imgView3.image=[UIImage imageNamed:@"home_search_down"];
    [_contactWaySelectView hiddenActionSheet];
    _isContactSelected=NO;
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
    if (_dataSourceArr.count>0) {
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    }
    
    currentPage = 1;
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:self.searchText forKey:@"keys"];
    [params setValue:@"52" forKey:@"searchType"];
    [params setValue:_region forKey:@"region"];//区域
    [params setValue:_certiId forKey:@"roles"];//证书类别
    [params setValue:_majorId forKey:@"certCode"];//专业
    [params setValue:_date forKey:@"date"];//有效期
    [params setValue:_contactId forKey:@"contactWay"];//联系方式
    [params setValue:[NSString stringWithFormat:@"%ld",currentPage] forKey:@"page"];
    [params setValue:@"10" forKey:@"rows"];
    
    
    [[DDHttpManager sharedInstance]sendPostRequest:KHttpRequest_queryHighLightList params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
       NSLog(@"**********人员搜索结果数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        __weak __typeof(self) weakSelf = self;
        [_loadingView hiddenLoadingView];
        if (response.isSuccess) {
            if (![response isEmpty]) {
                //[_dataSourceArr removeAllObjects];
                [_loadingView hiddenLoadingView];
                _dict = responseObject[KData];
                pageCount = [_dict[@"totalCount"] integerValue];
                NSArray *listArr=_dict[@"list"];
                
                //给数量label赋值
                NSString *totlaNum=[NSString stringWithFormat:@"%@",_dict[@"totalCount"]];
                _numLabel.text=totlaNum;
                CGRect numberFrame = [totlaNum boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
                _numLabel.frame=CGRectMake(CGRectGetMaxX(_leftLab.frame)+2, 15, numberFrame.size.width, 15);
                _rightLab.frame=CGRectMake(CGRectGetMaxX(_numLabel.frame)+2, 15, 45, 15);
                
                if (listArr.count!=0) {
                    [_noResultView hiddenNoDataView];
                    [_dataSourceArr removeAllObjects];
                    for (NSDictionary *dic in listArr) {
                        DDSearchBuilderAndManagerListModel *model = [[DDSearchBuilderAndManagerListModel alloc]initWithDictionary:dic error:nil];
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
                    [_noResultView showNoResultViewWithTitle:@"人员信息" andImage:@"noResult_person"];
                }
            }
            else{
                [_noResultView showNoResultViewWithTitle:@"人员信息" andImage:@"noResult_person"];
            }
        }
        else{
            [_noResultView showNoResultViewWithTitle:@"人员信息" andImage:@"noResult_person"];
        }

        [self.tableView.mj_header endRefreshing];
        if (_dataSourceArr.count>0) {
            [_tableView reloadData];
            [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        }
        
    }  failure:^(NSURLSessionDataTask *operation, id responseObject)  {
        [DDUtils showToastWithMessage:kRequestFailed];
        [_loadingView failureLoadingView];
    }];
}

- (void)addData{
    currentPage++;
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [params setValue:self.searchText forKey:@"keys"];
    [params setValue:@"52" forKey:@"searchType"];
    [params setValue:_region forKey:@"region"];//区域
    [params setValue:_certiId forKey:@"roles"];//证书类别
    [params setValue:_majorId forKey:@"certCode"];//专业
    [params setValue:_date forKey:@"date"];//有效期
    [params setValue:_contactId forKey:@"contactWay"];//联系方式
    [params setValue:[NSString stringWithFormat:@"%ld",currentPage] forKey:@"page"];
    [params setValue:@"10" forKey:@"rows"];
    
    
    [[DDHttpManager sharedInstance]sendPostRequest:KHttpRequest_queryHighLightList params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        //NSLog(@"**********人员搜索结果数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        __weak __typeof(self) weakSelf = self;
        if (response.isSuccess) {
            if (![response isEmpty]) {
                _dict = responseObject[KData];
                NSArray *listArr = _dict[@"list"];
                for (NSDictionary *dic in listArr) {
                    DDSearchBuilderAndManagerListModel *model = [[DDSearchBuilderAndManagerListModel alloc]initWithDictionary:dic error:nil];
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
    //地区选择
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
        _label1.frame=CGRectMake(5, 12, (Screen_Width/4-5)-4, 15);
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
    if (middle1Width>=(Screen_Width/4-5)) {
        _label2.frame=CGRectMake(5, 12, (Screen_Width/4-5)-4, 15);
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
    if (middle2Width>=(Screen_Width/4-5)) {
        _label3.frame=CGRectMake(5, 12, (Screen_Width/4-5)-4, 15);
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
    if (rightWidth>=(Screen_Width/4-5)) {
        _label4.frame=CGRectMake(5, 12, (Screen_Width/4-5)-4, 15);
        _imgView4.frame=CGRectMake(CGRectGetMaxX(_label4.frame)+4, 12, 15, 15);
    }
    else{
        _label4.frame=CGRectMake((Screen_Width/4-rightWidth)/2, 12, rightWidth-4-15, 15);
        _imgView4.frame=CGRectMake(CGRectGetMaxX(_label4.frame)+4, 12, 15, 15);
    }
    
    [self.view addSubview:contactSelectBtn];
    
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
    
    _rightLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_numLabel.frame)+2, 15, 45, 15)];
    _rightLab.text=@"名人员";
    _rightLab.textColor=KColorGreySubTitle;
    _rightLab.font=kFontSize26;
    [summaryView addSubview:_rightLab];
    
    //创建地区选择View
    _areaSelectTableView=[[DDAreaSelectTableView alloc]initWithFrame:CGRectMake(0, 39, Screen_Width, Screen_Height-KNavigationBarHeight-39) ];
    _areaSelectTableView.attachHeight=@"60";
    _areaSelectTableView.isNeedArea = YES;
    __weak __typeof(self) weakSelf=self;
    _areaSelectTableView.hiddenBlock = ^{
        weakSelf.imgView1.image=[UIImage imageNamed:@"home_search_down"];

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
    _certiTypeSelectView.attachHeight=@"60";
    _certiTypeSelectView.hiddenBlock = ^{
        weakSelf.imgView2.image=[UIImage imageNamed:@"home_search_down"];

        //[weakSelf.certiTypeSelectView hiddenActionSheet];
        [weakSelf.certiTypeSelectView hidden];

        _isCertiTypeSelect=NO;
    };
    _certiTypeSelectView.delegate=self;
    [_certiTypeSelectView show];
}

#pragma mark 创建tableView
-(void)createTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 39+45, Screen_Width, Screen_Height-KNavigationBarHeight-39-45-60) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=kColorBackGroundColor;
    _tableView.showsVerticalScrollIndicator=YES;
    _tableView.separatorColor=KColorTableSeparator;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, KTableViewFooterViewHeight)];
    
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
        DDSearchBuilderAndManagerListModel *model=_dataSourceArr[indexPath.section];
        
        static NSString * cellID = @"DDSearchBossAndSafemanListCell";
        DDSearchBossAndSafemanListCell * cell = (DDSearchBossAndSafemanListCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
        }
        
        [cell loadDataWithModel:model];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    else{
        static NSString * cellID = @"DDSearchBossAndSafemanListCell";
        DDSearchBossAndSafemanListCell * cell = (DDSearchBossAndSafemanListCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
        }
        

        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _imgView1.image=[UIImage imageNamed:@"home_search_down"];
    [_areaSelectTableView hidden];
    _isCitySelected=NO;
    
    _imgView2.image=[UIImage imageNamed:@"home_search_down"];
    [_certiTypeSelectView hidden];
    _isCertiTypeSelect=NO;
    
    _imgView3.image=[UIImage imageNamed:@"home_search_down"];
    [_dateSelectView hiddenActionSheet];
    _isDateSelected=NO;
    
    _imgView3.image=[UIImage imageNamed:@"home_search_down"];
    [_contactWaySelectView hiddenActionSheet];
    _isContactSelected=NO;
    
    if ([DDUtils isEmptyString:[DDUserManager sharedInstance].userid]) {
        [self presentLoginVCWithIndexPath:indexPath];
    }
    else{
        DDSearchBuilderAndManagerListModel *model=_dataSourceArr[indexPath.section];
        //此时需要存数据库了
        //存最近搜索
        [DDSearchHistoryDAOAndDB insertRecentSearchByTypeId:@"9909" andSearchText:self.searchText];
        //存浏览历史
        [DDSearchHistoryDAOAndDB insertHistorySearchByTypeId:@"9909" andSearchResult:model.name andGlobalType:@"1" andTransId:model.staff_info_id];
        
        DDPeopleDetailVC *peopleDetail=[[DDPeopleDetailVC alloc]init];
        peopleDetail.staffInfoId=model.staff_info_id;
        [self.mainViewContoller.navigationController pushViewController:peopleDetail animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    DDSearchBuilderAndManagerListModel *model=_dataSourceArr[indexPath.section];
    if (model.roles.count) {
        return [DDSearchBossAndSafemanListCell heightWithModel:model]+60+20-20;
    }
    return 50;
    //return 60;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (_dataSourceArr.count>0) {
        DDSearchBuilderAndManagerListModel *model=_dataSourceArr[section];
        
        UIView *footerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 45)];
        footerView.backgroundColor=kColorWhite;
        
        //UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(12, 15, 15, 15)];
        //imgView.image=[UIImage imageNamed:@"home_com_link"];
        //[footerView addSubview:imgView];
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(12, 15, Screen_Width-24, 15)];
        label.text=model.enterprise_name;
        label.textColor=KColorBlackSecondTitle;
        label.font=kFontSize28;
        [footerView addSubview:label];
        
        UIButton *btn=[[UIButton alloc]initWithFrame:footerView.frame];
        [footerView addSubview:btn];
        btn.tag=150+section;
        [btn addTarget:self action:@selector(companyClick:) forControlEvents:UIControlEventTouchUpInside];
        
        return footerView;
    }
    else{
        return nil;
    }
}

//点击公司名称
-(void)companyClick:(UIButton *)sender{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:sender.tag - 150];
    [self tableView:_tableView didSelectRowAtIndexPath:indexPath];
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
    return 45;
}

#pragma mark 点击城市选择
-(void)areaSelectClick{
    if (_isCitySelected==NO) {
        //将证书类别筛选隐藏
        _imgView2.image=[UIImage imageNamed:@"home_search_down"];
        [_certiTypeSelectView hidden];
        _isCertiTypeSelect=NO;
        //将有效期筛选隐藏
        _imgView3.image=[UIImage imageNamed:@"home_search_down"];
        [_dateSelectView hiddenActionSheet];
        _isDateSelected=NO;
        //将联系方式筛选隐藏
        _imgView4.image=[UIImage imageNamed:@"home_search_down"];
        [_contactWaySelectView hiddenActionSheet];
        _isContactSelected=NO;
        
        _imgView1.image=[UIImage imageNamed:@"home_search_up"];
        
        [_areaSelectTableView noHidden];
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        
        _isCitySelected=YES;
    }
    else{
        _imgView1.image=[UIImage imageNamed:@"home_search_down"];
        
        //[_citySelectTableView hiddenActionSheet];
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

#pragma mark 点击证书类别选择
-(void)certiTypeClick{
    if (_isCertiTypeSelect==NO) {
        //将区域筛选隐藏
        _imgView1.image=[UIImage imageNamed:@"home_search_down"];
        //[_areaSelectTableView hiddenActionSheet];
        [_areaSelectTableView hidden];
        _isCitySelected=NO;
        //将有效期筛选隐藏
        _imgView3.image=[UIImage imageNamed:@"home_search_down"];
        [_dateSelectView hiddenActionSheet];
        _isDateSelected=NO;
        //将联系方式筛选隐藏
        _imgView4.image=[UIImage imageNamed:@"home_search_down"];
        [_contactWaySelectView hiddenActionSheet];
        _isContactSelected=NO;
        
        _imgView2.image=[UIImage imageNamed:@"home_search_up"];
        [_certiTypeSelectView noHidden];
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        
        _isCertiTypeSelect=YES;
    }
    else{
        _imgView2.image=[UIImage imageNamed:@"home_search_down"];
        
        [_certiTypeSelectView hidden];
        
        _isCertiTypeSelect=NO;
    }
}

#pragma mark DDFindingPeopleCertiTypeSelectViewDelegate代理回调
-(void)actionsheetDisappear:(DDFindingPeopleCertiTypeSelectView *)actionSheet andCertiStr:(NSString *)certiStr andCertiCode:(NSString *)certiCode andMajorStr:(NSString *)majorStr andMajorCode:(NSString *)majorCode{
    _certiId=certiCode;
    _majorId=majorCode;
    
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
        if (middle2Width>=(Screen_Width/4-10)) {
            _label3.frame=CGRectMake(2, 12, (Screen_Width/4-10)-15, 15);
            _imgView3.frame=CGRectMake(CGRectGetMaxX(_label3.frame)+4, 12, 15, 15);
        }
        else{
            _label3.frame=CGRectMake((Screen_Width/4-middle2Width)/2, 12, middle2Width-4-15, 15);
            _imgView3.frame=CGRectMake(CGRectGetMaxX(_label3.frame)+4, 12, 15, 15);
        }
        _label3.text=@"有效期";
    }
    
    [self requestData];
}

#pragma mark 点击有效期选择
-(void)dateSelectClick{
    if ([DDUtils isEmptyString:_certiId]) {
        [DDUtils showToastWithMessage:@"为了更精准地查找符合您要求的证书，建议您先选择证书类别"];
    }
    else{
        if (_isDateSelected==NO) {
            //将区域筛选隐藏
            _imgView1.image=[UIImage imageNamed:@"home_search_down"];
            //[_areaSelectTableView hiddenActionSheet];
            [_areaSelectTableView hidden];
            _isCitySelected=NO;
            //将证书类别筛选隐藏
            _imgView2.image=[UIImage imageNamed:@"home_search_down"];
            [_certiTypeSelectView hidden];
            _isCertiTypeSelect=NO;
            //将联系方式筛选隐藏
            _imgView4.image=[UIImage imageNamed:@"home_search_down"];
            [_contactWaySelectView hiddenActionSheet];
            _isContactSelected=NO;
            
            
            _imgView3.image=[UIImage imageNamed:@"home_search_up"];
            
            _dateSelectView=[[DDFindingPeopleDateSelectView alloc]initWithFrame:CGRectMake(0, 39+60, Screen_Width, Screen_Height-KNavigationBarHeight-39-60)];
            _dateSelectView.attachHeight=@"60";
            _dateSelectView.dateCode=_date;
            __weak __typeof(self) weakSelf=self;
            _dateSelectView.hiddenBlock = ^{
                weakSelf.imgView3.image=[UIImage imageNamed:@"home_search_down"];
                
                [weakSelf.dateSelectView hiddenActionSheet];
                
                _isDateSelected=NO;
            };
            _dateSelectView.delegate=self;
            [_dateSelectView show];
            [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
            
            _isDateSelected=YES;
        }
        else{
            _imgView3.image=[UIImage imageNamed:@"home_search_down"];
            
            [_dateSelectView hiddenActionSheet];
            
            _isDateSelected=NO;
        }
    }
}

#pragma mark DDFindingPeopleDateSelectViewDelegate代理回调
-(void)actionsheetDisappear:(DDFindingPeopleDateSelectView *)actionSheet andDateStr:(NSString *)dateStr andDateCode:(NSString *)dateCode{
    _date=dateCode;
    
    CGRect middle2TextFrame = [dateStr boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
    CGFloat middle2Width=middle2TextFrame.size.width+4+15;
    if (middle2Width>=(Screen_Width/4-5)) {
        _label3.frame=CGRectMake(5, 12, (Screen_Width/4-9)-15, 15);
        _imgView3.frame=CGRectMake(CGRectGetMaxX(_label3.frame)+4, 12, 15, 15);
    }
    else{
        _label3.frame=CGRectMake((Screen_Width/4-middle2Width)/2, 12, middle2Width-4-15, 15);
        _imgView3.frame=CGRectMake(CGRectGetMaxX(_label3.frame)+4, 12, 15, 15);
    }
    
    _label3.text=dateStr;
    
    [self requestData];
}

#pragma mark 点击联系方式选择
-(void)contactWayClick{
    if (_isContactSelected==NO) {
        //将区域筛选隐藏
        _imgView1.image=[UIImage imageNamed:@"home_search_down"];
        //[_areaSelectTableView hiddenActionSheet];
        [_areaSelectTableView hidden];
        _isCitySelected=NO;
        //将证书类别筛选隐藏
        _imgView2.image=[UIImage imageNamed:@"home_search_down"];
        [_certiTypeSelectView hidden];
        _isCertiTypeSelect=NO;
        //将有效期筛选隐藏
        _imgView3.image=[UIImage imageNamed:@"home_search_down"];
        [_dateSelectView hiddenActionSheet];
        _isDateSelected=NO;
        
        
        _imgView4.image=[UIImage imageNamed:@"home_search_up"];
        
        _contactWaySelectView=[[DDFindingPeopleContactWaySelectView alloc]initWithFrame:CGRectMake(0, 39+60, Screen_Width, Screen_Height-KNavigationBarHeight-39-60)];
        _contactWaySelectView.attachHeight=@"60";
        _contactWaySelectView.wayCode=_contactId;
        __weak __typeof(self) weakSelf=self;
        _contactWaySelectView.hiddenBlock = ^{
            weakSelf.imgView4.image=[UIImage imageNamed:@"home_search_down"];
            
            [weakSelf.contactWaySelectView hiddenActionSheet];
            
            _isContactSelected=NO;
        };
        _contactWaySelectView.delegate=self;
        [_contactWaySelectView show];
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        
        _isContactSelected=YES;
    }
    else{
        _imgView4.image=[UIImage imageNamed:@"home_search_down"];
        
        [_contactWaySelectView hiddenActionSheet];
        
        _isContactSelected=NO;
    }
}

#pragma mark DDFindingPeopleContactWaySelectViewDelegate代理回调
-(void)actionsheetDisappear:(DDFindingPeopleContactWaySelectView *)actionSheet andWayStr:(NSString *)wayStr andWayCode:(NSString *)wayCode{
    _contactId=wayCode;
    
    CGRect rightTextFrame = [wayStr boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize28} context:nil];
    CGFloat rightWidth=rightTextFrame.size.width+4+15;
    if (rightWidth>=(Screen_Width/4-5)) {
        _label4.frame=CGRectMake(5, 12, (Screen_Width/4-9)-15, 15);
        _imgView4.frame=CGRectMake(CGRectGetMaxX(_label4.frame)+4, 12, 15, 15);
    }
    else{
        _label4.frame=CGRectMake((Screen_Width/4-rightWidth)/2, 12, rightWidth-4-15, 15);
        _imgView4.frame=CGRectMake(CGRectGetMaxX(_label4.frame)+4, 12, 15, 15);
    }
    
    _label4.text=wayStr;
    
    [self requestData];
}
#pragma mark 弹出登录注册页面
- (void)presentLoginVCWithIndexPath:(NSIndexPath *)indexPath{
    DDLoginCheckVC * vc = [[DDLoginCheckVC alloc] init];
    vc.loginSuccessBlock = ^{
        //__weak __typeof(self) weakSelf=self;
        //[weakSelf requestTypesData];
        
        DDSearchBuilderAndManagerListModel *model=_dataSourceArr[indexPath.section];
        //此时需要存数据库了
        //存最近搜索
        [DDSearchHistoryDAOAndDB insertRecentSearchByTypeId:@"9909" andSearchText:self.searchText];
        //存浏览历史
        [DDSearchHistoryDAOAndDB insertHistorySearchByTypeId:@"9909" andSearchResult:model.name andGlobalType:@"1" andTransId:model.staff_info_id];
        
        DDPeopleDetailVC *peopleDetail=[[DDPeopleDetailVC alloc]init];
        peopleDetail.staffInfoId=model.staff_info_id;
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
