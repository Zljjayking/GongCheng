//
//  DDWinTheBiddingVC.m
//  GongChengDD
//
//  Created by csq on 2018/5/30.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDWinTheBiddingVC.h"

#import "MJRefresh.h"
#import "DDNavigationUtil.h"
#import "DataLoadingView.h"//加载页面
#import "DDNoResultView.h"//无数据视图
#import "DDSearchProjectListModel.h"//model
#import "DDNewFindingWinBiddingProjectCell.h"

#import "DDProjectDetailVC.h"//项目详情页面

#import "DDAreaSelectTableView.h"//市的选择View
#import "DDFindingCallBiddingMoneySelectView.h"//金额选择页面
#import "DDFindingCallBiddingProjectTypeSelectView.h"//工程类别选择视图
#import "DDFindingWinBiddingDateSelectView.h"//中标时间选择视图
#import "DDServiceWebViewVC.h"
@interface DDWinTheBiddingVC ()<UITableViewDelegate,UITableViewDataSource,AreaSelectTableViewDelegate,UITabBarControllerDelegate,DDFindingCallBiddingProjectTypeSelectViewDelegate,DDFindingWinBiddingDateSelectViewDelegate,DDFindingCallBiddingMoneySelectViewDelegate>{
    UIView *_topBgView;
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
    UILabel *_rightLab2;
    
    BOOL _isCitySelected;//判断是否点开了城市选择视图
    BOOL _isProjectTypeSelected;//判断是否点开了工程类别选择视图
    BOOL _isMoneySelected;//判断是否点开了金额筛选视图
    BOOL _isDateSelected;//判断是否点开了中标时间筛选视图
    
    NSString *_regionId;//地区筛选
    NSInteger projectSelect;
    NSString *_projectTypeId;//工程类别筛选
    NSString *_projectTypeStr;//工程类别筛选
    NSString *_amount;//金额筛选
    NSString *_date;//中标时间筛选
    NSString *_moneyId;//用来金额高亮显示用
    
    NSInteger _isOther;//0表示没有去过其他tab，1表示去过其他tab
    CGFloat _myOffset;//记录滑动了多少
    NSInteger _backClick;//0表示未点击返回顶端，1表示点击了返回顶端
    UITabBarItem *_item1;//企业tab
    UITabBarItem *_item2;//返回顶部tab
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

@implementation DDWinTheBiddingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=kColorBackGroundColor;
    self.title=@"中标信息";
    self.navigationItem.leftBarButtonItem = [DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
//    self.navigationItem.rightBarButtonItem=[DDUtils rightbuttonItemWithTitle:@"买保险" target:self action:@selector(buyAction)];
    
    _amount=@"";//金额筛选
    _projectTypeId=@"";
    _projectTypeStr=@"";
    _date=@"";
    _moneyId=@"0";
    _regionId=@"0";
    _isCitySelected=NO;
    _isProjectTypeSelected=NO;
    _isMoneySelected=NO;
    _isDateSelected=NO;
    _dataSourceArr=[[NSMutableArray alloc]init];
    [self createChooseBtns];
    [self createTableView];
    [self createLoadView];
    [self requestData];
    _isOther=0;
    _myOffset=0;
    _backClick=0;
}
//-(void)buyAction{
//    DDServiceWebViewVC * checkVC = [DDServiceWebViewVC new];
//    checkVC.hostUrl = @"http://gcdd.koncendy.com/apphs/insuranceAndCompanyTrading/#/insuranceList";
//    checkVC.serviceWebViewType = DDServiceWebViewTypeOther;
//    [self.navigationController pushViewController:checkVC animated:YES];
//}

#pragma mark 返回上一页
- (void)leftButtonClick{
    //将工程类别筛选隐藏
    [_projectTypeSelectView hiddenActionSheet];
    //将区域筛选隐藏
    [_areaSelectTableView hidden];
    //将金额筛选隐藏
    [_moneySelectView hiddenActionSheet];
    //将中标时间筛选隐藏
    [_dateSelectView hiddenActionSheet];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark 创建加载视图
-(void)createLoadView{
    __weak __typeof(self) weakSelf=self;
    _noResultView=[[DDNoResultView alloc]initWithFrame:CGRectMake(0, 39, Screen_Width, Screen_Height-KNavigationBarHeight-39)];
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
    currentPage = 1;
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:self.enterpriseId forKey:@"enterpriseId"];
    [params setValue:self.toAction forKey:@"toAction"];
    [params setValue:_regionId forKey:@"regionId"];
    [params setValue:_projectTypeId forKey:@"projectType"];
    [params setValue:_amount forKey:@"amount"];
    [params setValue:_date forKey:@"bidTime"];
    [params setValue:[NSString stringWithFormat:@"%ld",currentPage] forKey:@"current"];
    [params setValue:@"10" forKey:@"size"];
    
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_bidwincaseWinCaseList params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"**********中标情况数据***************%@",responseObject);
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        __weak __typeof(self) weakSelf = self;
        if (response.isSuccess) {
            if (![response isEmpty]) {
                //[_dataSourceArr removeAllObjects];
                [_loadingView hiddenLoadingView];
                _dict = responseObject[KData];
                pageCount = [_dict[@"records"][@"totalPage"] integerValue];
                NSArray *listArr=_dict[@"records"][@"list"];
                
                //给数量label赋值
                NSString *totlaNum=[NSString stringWithFormat:@"%@",_dict[@"records"][@"totalCount"]];
                _numLabel.text=totlaNum;
                CGRect numberFrame = [totlaNum boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
                _numLabel.frame=CGRectMake(CGRectGetMaxX(_leftLab.frame)+2, 15, numberFrame.size.width, 15);
                _rightLab2.frame=CGRectMake(CGRectGetMaxX(_numLabel.frame), 15, 45, 15);

                if (listArr.count!=0) {
                    [_noResultView hiddenNoDataView];
                    [_dataSourceArr removeAllObjects];
                    for (NSDictionary *dic in listArr) {
                        DDSearchProjectListModel *model = [[DDSearchProjectListModel alloc]initWithDictionary:dic error:nil];
                        [model handle];
                        [_dataSourceArr addObject:model];
                    }
                    if ([_dict[@"records"][@"currPage"] integerValue]<pageCount) {
                        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                            [weakSelf addData];
                        }];
                    }else{
                        [_tableView.mj_footer removeFromSuperview];
                    }
                }
                else{
                    [_noResultView showNoResultViewWithText:@"没有相关内容" ];
                }
            }
            else{
                [_noResultView showNoResultViewWithText:@"没有相关内容"];
            }
        }
        else{
            [_noResultView showNoResultViewWithText:@"没有相关内容"];
        }
        [self.tableView.mj_header endRefreshing];
        if (_dataSourceArr.count>0) {
            [_tableView reloadData];
            [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        }
        _backClick=0;
    }  failure:^(NSURLSessionDataTask *operation, id responseObject)  {
        [DDUtils showToastWithMessage:kRequestFailed];
        [_loadingView failureLoadingView];
        _backClick=0;
    }];
}

- (void)addData{
    currentPage++;
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [params setValue:self.enterpriseId forKey:@"enterpriseId"];
    [params setValue:self.toAction forKey:@"toAction"];
    [params setValue:_regionId forKey:@"regionId"];
    [params setValue:_projectTypeId forKey:@"projectType"];
    [params setValue:_amount forKey:@"amount"];
    [params setValue:_date forKey:@"bidTime"];
    [params setValue:[NSString stringWithFormat:@"%ld",currentPage] forKey:@"current"];
    [params setValue:@"10" forKey:@"size"];
    
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_bidwincaseWinCaseList params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"**********中标库查找结果数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        __weak __typeof(self) weakSelf = self;
        if (response.isSuccess) {
            if (![response isEmpty]) {
                _dict = responseObject[KData];
                NSArray *listArr = _dict[@"records"][@"list"];
                for (NSDictionary *dic in listArr) {
                    DDSearchProjectListModel *model = [[DDSearchProjectListModel alloc]initWithDictionary:dic error:nil];
                    [model handle];
                    [_dataSourceArr addObject:model];
                }
                
                if ([_dict[@"records"][@"currPage"] integerValue]<pageCount) {
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
    
    CGRect leftTextFrame;
    leftTextFrame = [@"全国" boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize28} context:nil];
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
    _label3.text=@"金额";
    _label3.textColor=KColorBlackTitle;
    _label3.font=kFontSize28;
    [moneySelectBtn addSubview:_label3];
    
    _imgView3=[[UIImageView alloc]init];
    _imgView3.contentMode = UIViewContentModeScaleAspectFit;
    _imgView3.image=[UIImage imageNamed:@"home_search_down"];
    [moneySelectBtn addSubview:_imgView3];
    [moneySelectBtn addTarget:self action:@selector(moneySelectClick) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect middle2TextFrame = [@"金额" boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize28} context:nil];
    CGFloat middle2Width=middle2TextFrame.size.width+4+15;
    if (middle2Width>=(Screen_Width/4-5)) {
        _label3.frame=CGRectMake(5, 12, (Screen_Width/4-19)-4, 15);
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
        _label4.frame=CGRectMake(5, 12, (Screen_Width/4-19)-4, 15);
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
    
    _leftLab=[[UILabel alloc]initWithFrame:CGRectMake(12, 15, 60, 15)];
    _leftLab.text=@"共计中标";
    _leftLab.textColor=KColorGreySubTitle;
    _leftLab.font=kFontSize26;
    [summaryView addSubview:_leftLab];
    
    _numLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_leftLab.frame)+2, 15, 1, 15)];
    _numLabel.text=@"";
    _numLabel.textColor=KColorBlackTitle;
    _numLabel.font=kFontSize26;
    [summaryView addSubview:_numLabel];
    
    _rightLab2=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_numLabel.frame)+2, 15, 45, 15)];
    _rightLab2.text=@"个";
    _rightLab2.textColor=KColorGreySubTitle;
    _rightLab2.font=kFontSize26;
    [summaryView addSubview:_rightLab2];
    
    
    _areaSelectTableView=[[DDAreaSelectTableView alloc]initWithFrame:CGRectMake(0, 39, Screen_Width, Screen_Height-KNavigationBarHeight-39)];
//    _areaSelectTableView.type=@"1";
    __weak __typeof(self) weakSelf=self;
    _areaSelectTableView.hiddenBlock = ^{
        weakSelf.imgView1.image=[UIImage imageNamed:@"home_search_down"];
        [weakSelf.areaSelectTableView hidden];
        _isCitySelected=NO;
    };
    _areaSelectTableView.delegate=self;
    [_areaSelectTableView show];
}

#pragma mark 创建tableView
-(void)createTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 39+45, Screen_Width, Screen_Height-KNavigationBarHeight-39-45) style:UITableViewStyleGrouped];
    _tableView.backgroundColor=kColorBackGroundColor;
    [self.view addSubview:_tableView];
    _tableView.delegate=self;
    _tableView.dataSource=self;
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
    DDSearchProjectListModel *model=_dataSourceArr[indexPath.section];
    DDNewFindingWinBiddingProjectCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDNewFindingWinBiddingProjectCell"];
    [cell loadDataWithModel5:model];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _imgView1.image=[UIImage imageNamed:@"home_search_down"];
    [_areaSelectTableView hidden];
    _isCitySelected=NO;
    _imgView3.image=[UIImage imageNamed:@"home_search_down"];
    [_moneySelectView hiddenActionSheet];
    _isMoneySelected=NO;
   
    DDSearchProjectListModel *model=_dataSourceArr[indexPath.section];
    DDProjectDetailVC *projectDetail=[[DDProjectDetailVC alloc]init];
    projectDetail.winCaseId=model.win_case_id;
    [self.navigationController pushViewController:projectDetail animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    DDSearchProjectListModel *model=_dataSourceArr[indexPath.section];
    NSString *nameStr = model.title;
    if (![DDUtils isEmptyString:model.name]) {
      nameStr=[NSString stringWithFormat:@"[%@]%@",model.name,model.title];
    }
     CGFloat cellHeight = 0.0;
    if(![DDUtils isEmptyString:[NSString stringWithFormat:@"%@",nameStr]]){
        CGSize labelSize = [[NSString stringWithFormat:@"%@",nameStr] boundingRectWithSize:CGSizeMake(Screen_Width-WidthByiPhone6(24), 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:kFontSize34} context:nil].size;
        cellHeight = labelSize.height;
    }else{
        cellHeight = WidthByiPhone6(20);
    }
    
    if (![DDUtils isEmptyString:model.money_type]) {
        if ([model.money_type integerValue] != 0) {
            NSString *timeStr = model.win_bid_text;
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
        if ([DDUtils isEmptyString:model.trading_center]) {
            label.text=@"-";
        }
        else{
            label.text=model.trading_center;
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
        
        if ([DDUtils isEmptyString:model.trading_center]) {
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
        
        _isCitySelected=YES;
    }
    else{
        _imgView1.image=[UIImage imageNamed:@"home_search_down"];
        [_areaSelectTableView hidden];
        _isCitySelected=NO;
    }
}

#pragma mark CitySelectPickerView代理回调
-(void)actionsheetDisappear:(DDAreaSelectTableView *)actionSheet andAreaStr:(NSString *)areaStr andRegionId:(NSString *)regionId{
    _label1.text=areaStr;
    if ([areaStr isEqualToString:@"全国"]) {
        _regionId=@"0";
    }else{
        _regionId=regionId;
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
        _projectTypeSelectView=[[DDFindingCallBiddingProjectTypeSelectView alloc]initWithFrame:CGRectMake(0, 39, Screen_Width, Screen_Height-KNavigationBarHeight-39)];
        _projectTypeSelectView.typeId=_projectTypeId;
        _projectTypeSelectView.selectIndex = projectSelect;
        __weak __typeof(self) weakSelf=self;
        _projectTypeSelectView.hiddenBlock = ^{
            weakSelf.imgView2.image=[UIImage imageNamed:@"home_search_down"];
            
            [weakSelf.projectTypeSelectView hiddenActionSheet];
            
            _isProjectTypeSelected=NO;
        };
        _projectTypeSelectView.delegate=self;
        [_projectTypeSelectView show];
        
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
    projectSelect = select;
    CGRect middle1TextFrame = [typeStr boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize28} context:nil];
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
        
        _moneySelectView=[[DDFindingCallBiddingMoneySelectView alloc]initWithFrame:CGRectMake(0, 39, Screen_Width, Screen_Height-KNavigationBarHeight-39)];
        _moneySelectView.moneyId=_moneyId;
        __weak __typeof(self) weakSelf=self;
        _moneySelectView.hiddenBlock = ^{
            weakSelf.imgView3.image=[UIImage imageNamed:@"home_search_down"];
            
            [weakSelf.moneySelectView hiddenActionSheet];
            
            _isMoneySelected=NO;
        };
        _moneySelectView.delegate=self;
        [_moneySelectView show];
        
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
    
    [self requestData];
}

#pragma mark 点击中标时间筛选
-(void)dateSelectClick{
    if (_isDateSelected==NO) {
        //将区域筛选隐藏
        _imgView1.image=[UIImage imageNamed:@"home_search_down"];
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
        
        _dateSelectView=[[DDFindingWinBiddingDateSelectView alloc]initWithFrame:CGRectMake(0, 39, Screen_Width, Screen_Height-KNavigationBarHeight-39)];
        _dateSelectView.dateCode=_date;
        __weak __typeof(self) weakSelf=self;
        _dateSelectView.hiddenBlock = ^{
            weakSelf.imgView4.image=[UIImage imageNamed:@"home_search_down"];
            
            [weakSelf.dateSelectView hiddenActionSheet];
            
            _isDateSelected=NO;
        };
        _dateSelectView.delegate=self;
        [_dateSelectView show];
        
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
    
    [self requestData];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    _myOffset=scrollView.contentOffset.y;
    if (_backClick==0 && _isOther==0) {
        if (_myOffset>(Screen_Height-KNavigationBarHeight-KTabbarHeight-39-45)*2+80) {
            self.tabBarItem=_item2;
        }
        else{
            self.tabBarItem=_item1;
        }
    }
    else{
        //self.tabBarItem=_item1;
    }
}

@end


