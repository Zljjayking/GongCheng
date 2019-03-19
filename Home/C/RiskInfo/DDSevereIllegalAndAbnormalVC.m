//
//  DDSevereIllegalAndAbnormalVC.m
//  GongChengDD
//
//  Created by xzx on 2018/10/22.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDSevereIllegalAndAbnormalVC.h"
#import "DDLabelUtil.h"
#import "MJRefresh.h"
#import "DDNavigationUtil.h"
#import "DataLoadingView.h"//加载页面
#import "DDNoResult2View.h"//无数据视图
#import "DDSevereIllegalAndAbnormal1Cell.h"//cell1
#import "DDSevereIllegalAndAbnormal2Cell.h"//cell2
#import "DDSevereIllegalAndAbnormalModel.h"//model

@interface DDSevereIllegalAndAbnormalVC ()<UITableViewDelegate,UITableViewDataSource>

{
    NSInteger currentPage;
    NSInteger pageCount;
    NSMutableArray *_dataSourceArr;
    NSMutableDictionary *_dict;
    
    UILabel *_leftLab;//"搜索到"三个字的label
    UILabel *_numLabel;//总计数量label
    UILabel *_rightLab;//"个公司"三个字的label
}
@property (nonatomic,strong) DataLoadingView *loadingView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) DDNoResult2View *noResultView;//无数据视图


@end

@implementation DDSevereIllegalAndAbnormalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataSourceArr=[[NSMutableArray alloc]init];
    [self editNavItem];
    [self createTableView];
//    [self createChooseBtns];
    [self createLoadView];
    [self requestData];
}

-(void)editNavItem{
    if ([self.illegalType isEqualToString:@"1"]) {
        self.title=@"严重违法";
    }
    else{
        self.title=@"经营异常";
    }
    self.view.backgroundColor=kColorBackGroundColor;
    self.navigationItem.leftBarButtonItem=[DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
}

//返回上一页面
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}
/*
//筛选按钮
#pragma mark 创建筛选按钮
-(void)createChooseBtns{
    //搜索结果统计
    UIView *summaryView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 45)];
    [self.view addSubview:summaryView];
    
    _leftLab=[[UILabel alloc]initWithFrame:CGRectMake(12, 15, 15, 15)];
    _leftLab.text=@"共";
    _leftLab.textColor=KColorGreySubTitle;
    _leftLab.font=kFontSize26;
    [summaryView addSubview:_leftLab];
    
    _numLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_leftLab.frame)+2, 15, 1, 15)];
    _numLabel.text=@"";
    _numLabel.textColor=KColorBlackTitle;
    _numLabel.font=kFontSize26;
    [summaryView addSubview:_numLabel];
    
    _rightLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_numLabel.frame)+2, 15, 75, 15)];
    if ([self.illegalType isEqualToString:@"1"]) {
        _rightLab.text=@"个严重违法";
    }
    else{
        _rightLab.text=@"个经营异常";
    }
    _rightLab.textColor=KColorGreySubTitle;
    _rightLab.font=kFontSize26;
    [summaryView addSubview:_rightLab];
}
*/
#pragma mark 创建加载视图
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


#pragma mark 请求数据
- (void)requestData{
    currentPage = 1;
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:self.enterpriseId forKey:@"enterpriseId"];
    [params setValue:self.toAction forKey:@"toAction"];
    if ([self.illegalType isEqualToString:@"1"]) {
        [params setValue:@"1" forKey:@"type"];
    }
    else{
        [params setValue:@"2" forKey:@"type"];
    }
    [params setValue:[NSString stringWithFormat:@"%ld",currentPage] forKey:@"current"];
    [params setValue:@"10" forKey:@"size"];
    
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_illigalAndAbnormalList params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"**********严重违法或经营异常结果数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        __weak __typeof(self) weakSelf = self;
        if (response.isSuccess) {
            [_dataSourceArr removeAllObjects];
            [_loadingView hiddenLoadingView];
            _dict = responseObject[KData];
            pageCount = [_dict[@"totalCount"] integerValue];
            NSArray *listArr=_dict[@"list"];
            
            //给数量label赋值
            NSString *totlaNum=[NSString stringWithFormat:@"%@",_dict[@"totalCount"]];
            _numLabel.text=totlaNum;
            CGRect numberFrame = [totlaNum boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
            _numLabel.frame=CGRectMake(CGRectGetMaxX(_leftLab.frame)+2, 15, numberFrame.size.width, 15);
            _rightLab.frame=CGRectMake(CGRectGetMaxX(_numLabel.frame)+2, 15, 75, 15);
            
            if (listArr.count!=0) {
                [_noResultView hide];
                
                for (NSDictionary *dic in listArr) {
                    DDSevereIllegalAndAbnormalModel *model = [[DDSevereIllegalAndAbnormalModel alloc]initWithDictionary:dic error:nil];
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
                if ([self.illegalType isEqualToString:@"1"]) {
                    [_noResultView showWithTitle:@"暂无相关严重违法的信息" subTitle:@"去其他地方看看~" image:@"noResult_info"];
                }
                else{
                    [_noResultView showWithTitle:@"暂无相关经营异常的信息" subTitle:@"去其他地方看看~" image:@"noResult_info"];
                }
            }
            
        }
        else{
            
            [_loadingView failureLoadingView];
        }
        
        [self.tableView.mj_header endRefreshing];
        [_tableView reloadData];
        
    }  failure:^(NSURLSessionDataTask *operation, id responseObject)  {
        [DDUtils showToastWithMessage:kRequestFailed];
        [_loadingView failureLoadingView];
    }];
}

- (void)addData{
    currentPage++;
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [params setValue:self.enterpriseId forKey:@"enterpriseId"];
    [params setValue:self.toAction forKey:@"toAction"];
    if ([self.illegalType isEqualToString:@"1"]) {
        [params setValue:@"1" forKey:@"type"];
    }
    else{
        [params setValue:@"2" forKey:@"type"];
    }
    [params setValue:[NSString stringWithFormat:@"%ld",currentPage] forKey:@"current"];
    [params setValue:@"10" forKey:@"size"];
    
    
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_illigalAndAbnormalList params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"**********严重违法或经营异常结果数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        __weak __typeof(self) weakSelf = self;
        if (response.isSuccess) {
            
            _dict = responseObject[KData];
            NSArray *listArr = _dict[@"list"];
            for (NSDictionary *dic in listArr) {
                DDSevereIllegalAndAbnormalModel *model = [[DDSevereIllegalAndAbnormalModel alloc]initWithDictionary:dic error:nil];
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
            [DDUtils showToastWithMessage:response.message];
        }
        
        //[self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
        
    }  failure:^(NSURLSessionDataTask *operation, id responseObject)  {
        [DDUtils showToastWithMessage:kRequestFailed];
    }];
}

//创建tableView
-(void)createTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,0, Screen_Width, Screen_Height-KNavigationBarHeight) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=kColorBackGroundColor;
    _tableView.showsVerticalScrollIndicator=YES;
    _tableView.estimatedRowHeight = 44;
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
    DDSevereIllegalAndAbnormalModel *model=_dataSourceArr[section];
    
    if ([DDUtils isEmptyString:model.delReason]) {//表示移除的信息没有，移除两行不用显示,只显示列入两行
        return 2;
    }
    else{//移除和列入都有，显示四行
        return 4;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DDSevereIllegalAndAbnormalModel *model=_dataSourceArr[indexPath.section];
    
    if ([DDUtils isEmptyString:model.delReason]) {//表示移除的信息没有，移除两行不用显示,只显示列入两行
        if (indexPath.row==0) {
            static NSString * cellID = @"DDSevereIllegalAndAbnormal1Cell";
            DDSevereIllegalAndAbnormal1Cell * cell = (DDSevereIllegalAndAbnormal1Cell *)[tableView dequeueReusableCellWithIdentifier:cellID];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
            }
            
            if ([self.illegalType isEqualToString:@"1"]) {//严重违法
                cell.tipLab.text=@"列入原因";
            }
            else{//经营异常
                cell.tipLab.text=@"列入经营异常名录原因";
            }
            cell.timeLab.text=model.addTime;
            cell.statusLab.hidden=NO;
            cell.statusLab.text=@"列入";
            cell.statusLab.textColor=kColorRed;
            cell.statusLab.layer.borderColor=kColorRed.CGColor;
            cell.titleLab.text=model.addReason;
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
        else{
            static NSString * cellID = @"DDSevereIllegalAndAbnormal2Cell";
            DDSevereIllegalAndAbnormal2Cell * cell = (DDSevereIllegalAndAbnormal2Cell *)[tableView dequeueReusableCellWithIdentifier:cellID];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
            }
            
            cell.tipLab.text=@"做出决定机关";
            cell.titleLab.text=model.addDepartment;
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    else{//移除和列入都有，显示四行
        if (indexPath.row==0) {
            static NSString * cellID = @"DDSevereIllegalAndAbnormal1Cell";
            DDSevereIllegalAndAbnormal1Cell * cell = (DDSevereIllegalAndAbnormal1Cell *)[tableView dequeueReusableCellWithIdentifier:cellID];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
            }
            
            if ([self.illegalType isEqualToString:@"1"]) {//严重违法
                cell.tipLab.text=@"移出原因";
            }
            else{//经营异常
                cell.tipLab.text=@"移出经营异常名录原因";
            }
            cell.timeLab.text=model.delTime;
            cell.statusLab.hidden=NO;
            cell.statusLab.text=@"移出";
            cell.statusLab.textColor=kColorBlue;
            cell.statusLab.layer.borderColor=kColorBlue.CGColor;
            cell.titleLab.text=model.delReason;
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
        else if(indexPath.row==1){
            static NSString * cellID = @"DDSevereIllegalAndAbnormal2Cell";
            DDSevereIllegalAndAbnormal2Cell * cell = (DDSevereIllegalAndAbnormal2Cell *)[tableView dequeueReusableCellWithIdentifier:cellID];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
            }
            
            cell.tipLab.text=@"作出决定机关";
            cell.titleLab.text=model.delDepartment;
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
        else if (indexPath.row==2) {
            static NSString * cellID = @"DDSevereIllegalAndAbnormal1Cell";
            DDSevereIllegalAndAbnormal1Cell * cell = (DDSevereIllegalAndAbnormal1Cell *)[tableView dequeueReusableCellWithIdentifier:cellID];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
            }
            
            if ([self.illegalType isEqualToString:@"1"]) {//严重违法
                cell.tipLab.text=@"列入原因";
            }
            else{//经营异常
                cell.tipLab.text=@"列入经营异常名录原因";
            }
            cell.timeLab.text=model.addTime;
//            cell.statusLab.text=@"列入";
//            cell.statusLab.textColor=kColorRed;
//            cell.statusLab.layer.borderColor=kColorRed.CGColor;
            cell.statusLab.hidden=YES;
            cell.titleLab.text=model.addReason;
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
        else{
            static NSString * cellID = @"DDSevereIllegalAndAbnormal2Cell";
            DDSevereIllegalAndAbnormal2Cell * cell = (DDSevereIllegalAndAbnormal2Cell *)[tableView dequeueReusableCellWithIdentifier:cellID];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
            }
            
            cell.tipLab.text=@"作出决定机关";
            cell.titleLab.text=model.addDepartment;
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
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
    return CGFLOAT_MIN;
}


@end
