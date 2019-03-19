//
//  DDPersonalCertificateSummaryVC.m
//  GongChengDD
//
//  Created by csq on 2017/12/4.
//  Copyright © 2017年 Koncendy. All rights reserved.
//

#import "DDPersonalCertificateSummaryVC.h"
#import "DataLoadingView.h"
#import "MJRefresh.h"
#import "DDPeopleSummaryCell.h"//cell
#import "DDPeopleSummaryModel.h"//model
#import "DDValidityView.h"//有效期头视图
#import "DDActionSheetView.h"//有效期弹出视图
#import "DDNoResult2View.h"
#import "DDPeopleSummaryType1Cell.h"
#import "DDPeopleSummaryType2Cell.h"
#import "DDServiceWebViewVC.h"
@interface DDPersonalCertificateSummaryVC ()<UITableViewDelegate,UITableViewDataSource,DDValidityViewDelegate,DDActionSheetViewDelegate>

{
    DataLoadingView * _loadingView;
    NSInteger currentPage;

    NSMutableArray *_dataSourceArr;
    NSMutableDictionary *_dict;

    NSMutableArray *_majorArr;//存放专业筛选结果

    NSString *_daysNum;//天数
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, strong) DDValidityView *validityView;//"全部""已到期"...选择view
@property (nonatomic, strong) DDActionSheetView *sheetView;
@property (nonatomic,strong) DDNoResult2View *noResultView;

@end

@implementation DDPersonalCertificateSummaryVC

-(void)viewWillAppear:(BOOL)animated{
    [self requestData];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self editNavItem];
    [self createTableView];
    [self createLoadView];
    [self requestData];
}

//编辑导航条
-(void)editNavItem{
    self.view.backgroundColor=kColorBackGroundColor;
    self.navigationItem.leftBarButtonItem = [DDUtils leftButtonItemWithImage:@"Nav_back" highlightedImage:@"Nav_back" target:self action:@selector(leftButtonClick)];
   
    
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
    
    _noResultView=[[DDNoResult2View alloc]initWithFrame:CGRectMake(0, 60, Screen_Width, Screen_Height-KNavigationBarHeight)];
    [self.view addSubview:_noResultView];
    
    
    _loadingView = [[DataLoadingView alloc] initWithController:self];
    _loadingView.loadingTitle = KLoading;
    _loadingView.failureTitle = KLoadingFailure;
    _loadingView.reloadHandle = ^(void){
        [weakSelf requestData];
    };
    [_loadingView showLoadingView];
}

//创建tableView
-(void)createTableView{
    self.validityView = [[DDValidityView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 60)];
    self.validityView.delegate = self;
    //self.tableView.tableHeaderView = self.validityView;
    _daysNum=[self.validityView loadViewWithTimeType:@"1"];//默认全部
    [self.view addSubview:self.validityView];
    

    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 61, Screen_Width, Screen_Height-KNavigationBarHeight-KNavigationBarHeight-61) style:UITableViewStylePlain];
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
    [params setValue:[NSString stringWithFormat:@"%ld",(long)currentPage] forKey:@"current"];
    [params setValue:@"15" forKey:@"size"];
    [params setValue:_daysNum  forKey:@"dayNum"];
    [params setValue:_enterpriseId forKey:@"enterpriseId"];

    [[DDHttpManager sharedInstance] sendPostRequest:KHttpRequest_scenterpriseinfoQueryPCSummarize params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        __weak __typeof(self) weakSelf = self;
        if (response.isSuccess) {
            [_dataSourceArr removeAllObjects];
            [_loadingView hiddenLoadingView];
            
            _dict = responseObject[KData];
            NSArray *listArr=_dict[KList];
            
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
    [params setValue:_daysNum  forKey:@"dayNum"];
    [params setValue:_enterpriseId forKey:@"enterpriseId"];

    [[DDHttpManager sharedInstance] sendPostRequest:KHttpRequest_scenterpriseinfoQueryPCSummarize params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        
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

#pragma
#pragma mark -- DDValidityViewDelegate
-(void)validityViewButtonAction{
    NSArray *dateArr = @[@"全部",@"已到期",@"7日内",@"15日内",@"30日内",@"45日内",@"60日内",@"75日内",@"90日内",@"90日以上"];
    _sheetView= [[DDActionSheetView alloc]initWithFrame:self.view.window.frame];
    _sheetView.delegate = self;
    [_sheetView setTitle:dateArr cancelTitle:@"取消"];
    [_sheetView show];
}
#pragma
#pragma mark -- DDActionSheetViewDelegate
-(void)actionsheetSelectButton:(DDActionSheetView *)actionSheet buttonIndex:(NSInteger)index{
    NSString *timeType = [NSString stringWithFormat:@"%ld",(long)index];
    _daysNum = [self.validityView loadViewWithTimeType:timeType];
    //请求数据
    [self requestData];
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
        if ([model.formal isEqualToString:@"0"]) {
            buildCell.roleLabel.hidden=NO;
            buildCell.roleLabel.text=@"临时";
        }
        else{
            buildCell.roleLabel.hidden=YES;
        }
        cell.makeBtn.hidden = YES;
        buildCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [buildCell loadCellWithModel:model indexPath:indexPath];
        return buildCell;
 
    }else if ([model.type isEqualToString:@"3"]){
        //安全员
        [cell loadSafeManWithModel:model indexPath:indexPath];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
    return 15;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * header = [[UIView alloc]init];
    header.frame = CGRectMake(0, 0, Screen_Width, 15);
    header.backgroundColor = [UIColor clearColor];
    return header;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}




@end
