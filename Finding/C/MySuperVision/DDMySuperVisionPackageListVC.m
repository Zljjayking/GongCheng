//
//  DDMySuperVisionPackageListVC.m
//  GongChengDD
//
//  Created by xzx on 2018/12/10.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDMySuperVisionPackageListVC.h"
#import "DataLoadingView.h"
#import "MJRefresh.h"
#import "DDPeopleSummaryCell.h"//cell
#import "DDPeopleSummaryModel.h"//model
//#import "DDValidityView.h"//有效期头视图
#import "DDActionSheetView.h"//有效期弹出视图
#import "DDNoResult2View.h"
#import "DDPeopleSummaryType1Cell.h"
#import "DDPeopleSummaryType2Cell.h"
#import "DDExamineTrainingVC.h"

@interface DDMySuperVisionPackageListVC ()<UITableViewDelegate,UITableViewDataSource,DDActionSheetViewDelegate>

{
    DataLoadingView * _loadingView;
    NSInteger currentPage;
    
    NSMutableArray *_dataSourceArr;
    NSMutableDictionary *_dict;
    
    NSMutableArray *_majorArr;//存放专业筛选结果
    
    NSString *_daysNum;//天数
    
    UILabel *_timeLab;//时间
    UILabel *_leftLab;//"搜索到"三个字的label
    UILabel *_numLabel;//总计数量label
    UILabel *_rightLab;//"个公司"三个字的label
}
@property (nonatomic,strong) UITableView *tableView;
//@property (nonatomic, strong) DDValidityView *validityView;//"全部""已到期"...选择view
@property (nonatomic, strong) DDActionSheetView *sheetView;
@property (nonatomic,strong) DDNoResult2View *noResultView;

@end

@implementation DDMySuperVisionPackageListVC

-(void)viewWillAppear:(BOOL)animated{
    [self requestData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=self.enterpriseName;
    [self editNavItem];
    [self createChooseBtns];
    [self createTableView];
    [self createLoadView];
    [self requestData];
}

//编辑导航条
-(void)editNavItem{
    self.view.backgroundColor=kColorBackGroundColor;
    self.navigationItem.leftBarButtonItem=[DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
    _dataSourceArr=[[NSMutableArray alloc]init];
    _dict=[NSMutableDictionary dictionary];
    _majorArr=[[NSMutableArray alloc]init];
}

//返回上一页面
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

//创建加载视图
-(void)createLoadView{
    __weak __typeof(self) weakSelf=self;
    _noResultView=[[DDNoResult2View alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-KNavigationBarHeight)];
    [self.view addSubview:_noResultView];
    
    _loadingView = [[DataLoadingView alloc] initWithController:self];
    _loadingView.loadingTitle = KLoading;
    _loadingView.failureTitle = KLoadingFailure;
    _loadingView.reloadHandle = ^(void){
        [weakSelf requestData];
    };
    [_loadingView showLoadingView];
}

#pragma mark 创建筛选按钮
-(void)createChooseBtns{
    //搜索结果统计
    UIView *summaryView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 42)];
    summaryView.backgroundColor=kColorBackGroundColor;
    [self.view addSubview:summaryView];
    _timeLab = [[UILabel alloc]initWithFrame:CGRectMake(12, 13, 100, 16)];
    _timeLab.textColor=KColorBlackTitle;
    _timeLab.font=kFontSize26;
    _timeLab.text=[_timeStr substringToIndex:_timeStr.length-3];
    [_timeLab sizeToFit];
    [summaryView addSubview:_timeLab];
    
    _leftLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_timeLab.frame)+2, 13, 15, 16)];
    _leftLab.text=@"共";
    _leftLab.textColor=KColorGreySubTitle;
    _leftLab.font=kFontSize26;
    [summaryView addSubview:_leftLab];
    
    _numLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_leftLab.frame)+2, 13, 1, 16)];
    _numLabel.text=@"";
    _numLabel.textColor=KColorBlackTitle;
    _numLabel.font=kFontSize26;
    [summaryView addSubview:_numLabel];
    
    _rightLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_numLabel.frame)+2, 13, 100, 16)];
    _rightLab.text=@"条到期提醒";
    _rightLab.textColor=KColorGreySubTitle;
    _rightLab.font=kFontSize26;
    [summaryView addSubview:_rightLab];
}

//创建tableView
-(void)createTableView{
//    self.validityView = [[DDValidityView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 60)];
//    self.validityView.delegate = self;
//    //self.tableView.tableHeaderView = self.validityView;
//    _daysNum=[self.validityView loadViewWithTimeType:@"1"];//默认全部
//    [self.view addSubview:self.validityView];
    
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 42, Screen_Width, Screen_Height-KNavigationBarHeight-42) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor=[UIColor clearColor];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.scrollsToTop=YES;
    self.tableView.showsVerticalScrollIndicator=YES;
    self.tableView.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
    [self.tableView setSeparatorColor:KColorTableSeparator];
    self.tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width,KTableViewFooterViewHeight)];
    [self.view addSubview:self.tableView];
    
    __weak __typeof(self) weakSelf=self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestData];
    }];
}

#pragma mark 请求数据
-(void)requestData{
    currentPage = 1;
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [params setValue:[NSString stringWithFormat:@"%ld",currentPage] forKey:@"current"];
    [params setValue:@"15" forKey:@"size"];
    [params setValue:_enterpriseId forKey:@"id"];
    
    [[DDHttpManager sharedInstance] sendPostRequest:KHttpRequest_appPackMessageList params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        __weak __typeof(self) weakSelf = self;
        if (response.isSuccess) {
            [_dataSourceArr removeAllObjects];
            [_loadingView hiddenLoadingView];
            
            _dict = responseObject[KData];
            NSArray *listArr=_dict[KList];
            
            //给数量label赋值
            NSString *totlaNum=[NSString stringWithFormat:@"%@",_dict[@"totalCount"]];
            _numLabel.text=totlaNum;
            CGRect numberFrame = [totlaNum boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize26} context:nil];
            _numLabel.frame=CGRectMake(CGRectGetMaxX(_leftLab.frame)+2, 13, numberFrame.size.width, 16);
            _rightLab.frame=CGRectMake(CGRectGetMaxX(_numLabel.frame)+2, 13, 100, 16);
            
            if (listArr.count!=0) {
                [_noResultView hide];
                _tableView.scrollEnabled=YES;
                
                _dataSourceArr = [DDPeopleSummaryModel arrayOfModelsFromDictionaries:_dict[KList] error:nil];
                
                if (_dataSourceArr.count< [_dict[KTotalCount] integerValue]) {
                    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                        [weakSelf addData];
                    }];
                }else{
                    [self.tableView.mj_footer removeFromSuperview];
                }
            }
            else{
                [_noResultView showWithTitle:@"暂无人员证书相关信息" subTitle:nil image:@"noResult_content"];
                _tableView.scrollEnabled=NO;
            }
            
        }
        else{
            [_loadingView failureLoadingView];
            [DDUtils showToastWithMessage:response.message];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
        //tableView回到顶部
        if (_dataSourceArr.count>0) {
            NSIndexPath* indexPat = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView scrollToRowAtIndexPath:indexPat atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    } failure:^(NSURLSessionDataTask *operation, id responseObject) {
        [self.tableView.mj_header endRefreshing];
        [_loadingView failureLoadingView];
        [DDUtils showToastWithMessage:kRequestFailed];
    }];
}

- (void)addData{
    currentPage++;

    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [params setValue:[NSString stringWithFormat:@"%ld",currentPage] forKey:@"current"];
    [params setValue:@"15" forKey:@"size"];
    [params setValue:_enterpriseId forKey:@"id"];
    
    [[DDHttpManager sharedInstance] sendPostRequest:KHttpRequest_appPackMessageList params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        __weak __typeof(self) weakSelf = self;
        
        if (response.isSuccess) {
            
            _dict = responseObject[KData];
            
            NSArray * tempArray =  [DDPeopleSummaryModel arrayOfModelsFromDictionaries:_dict[KList] error:nil];
            [_dataSourceArr addObjectsFromArray:tempArray];
            
            if (_dataSourceArr.count<[_dict[KTotalCount] integerValue]) {
                self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                    [weakSelf addData];
                }];
            }
            else{
                [self.tableView.mj_footer removeFromSuperview];
            }
        }
        else{
            [DDUtils showToastWithMessage:response.message];
        }
        
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *operation, id responseObject) {
        [self.tableView.mj_footer endRefreshing];
        [DDUtils showToastWithMessage:kRequestFailed];
    }];
}

-(void)hasClickMakeAction:(UIButton *)sender{
//    DDPeopleSummaryModel *model=_dataSourceArr[sender.tag-1000];
    DDExamineTrainingVC *trainVC = [DDExamineTrainingVC new];
    trainVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:trainVC animated:YES];
}
#pragma mark tableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataSourceArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DDPeopleSummaryModel *model=_dataSourceArr[indexPath.section];
    
    static NSString * cellID = @"DDPeopleSummaryCell";
    DDPeopleSummaryCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:cellID owner:self options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    static NSString * architectureCellID = @"DDPeopleSummaryType2Cell";
    DDPeopleSummaryType2Cell * architectureCell = (DDPeopleSummaryType2Cell*)[tableView dequeueReusableCellWithIdentifier:architectureCellID];
    if (architectureCell == nil) {
        architectureCell = [[[NSBundle mainBundle] loadNibNamed:architectureCellID owner:self options:nil] firstObject];
    }
    architectureCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    
    if ([model.type isEqualToString:@"1"] || [model.type isEqualToString:@"2"]) {
        //2一级建造师  2二级建造师
        static NSString * buildCellID = @"DDPeopleSummaryType1Cell";
        DDPeopleSummaryType1Cell * buildCell = (DDPeopleSummaryType1Cell*)[tableView dequeueReusableCellWithIdentifier:buildCellID];
        if (buildCell == nil) {
            buildCell = [[[NSBundle mainBundle]loadNibNamed:buildCellID owner:self options:nil] firstObject];
        }
        buildCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [buildCell loadCellWithModel:model indexPath:indexPath];
        buildCell.makeBtn.tag = 1000+indexPath.section;
        [buildCell.makeBtn addTarget:self action:@selector(hasClickMakeAction:) forControlEvents:UIControlEventTouchUpInside];
        return buildCell;
        
    }else if ([model.type isEqualToString:@"3"]){
        //安全员
        [cell loadSafeManWithModel:model indexPath:indexPath];
        cell.makeBtn.tag = 1000+indexPath.section;
        [cell.makeBtn addTarget:self action:@selector(hasClickMakeAction:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
        
    }else if ([model.type  isEqualToString:@"9"] || [model.type isEqualToString:@"10"] ||[model.type isEqualToString:@"11"] ||[model.type isEqualToString:@"12"] || [model.type isEqualToString:@"13"]){
        //9土木工程师   10公用设备师  11电气工程师   12监理工程师  13造价工程师
        [cell loadOtherManWithModel:model indexPath:indexPath];
        return cell;
        
    }else if ([model.type isEqualToString:@"14"]){
        //消防工程师
        [architectureCell loadFireControlWithModel:model indexPath:indexPath];
        return architectureCell;
    }
    else{
        //其它类型人员
        [architectureCell loadWithModel:model indexPath:indexPath];
        return architectureCell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    DDPeopleSummaryModel *model=_dataSourceArr[indexPath.section];
    
    if ([model.type isEqualToString:@"1"] || [model.type isEqualToString:@"2"]) {
        //建造师
        return [DDPeopleSummaryType1Cell height];
        
    }else if ([model.type isEqualToString:@"3"]){
        //安全员
        return [DDPeopleSummaryCell height];
        
    }else if ([model.type  isEqualToString:@"9"] || [model.type isEqualToString:@"10"] ||[model.type isEqualToString:@"11"] ||[model.type isEqualToString:@"12"] || [model.type isEqualToString:@"13"]){
        ///9土木工程师   10公用设备师  11电气工程师   12监理工程师  13造价工程师
        return [DDPeopleSummaryCell height];
        
    }else if ([model.type isEqualToString:@"14"]){
        //消防工程师
        return [DDPeopleSummaryType2Cell height];
    }
    else{
        //其它
        return [DDPeopleSummaryType2Cell height];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 15;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}



@end
