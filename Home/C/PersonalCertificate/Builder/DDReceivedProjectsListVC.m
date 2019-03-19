//
//  DDReceivedProjectsListVC.m
//  GongChengDD
//
//  Created by xzx on 2018/6/5.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDReceivedProjectsListVC.h"
#import "MJRefresh.h"
#import "DDNavigationUtil.h"
#import "DataLoadingView.h"//加载页面
#import "DDNoResult2View.h"//无数据视图
#import "DDProjectListCell.h"//cell
#import "DDCompanyBuilderProjectModel.h"//model
#import "DDPersonalDetailInfoModel.h"//人员详情model
#import "DDGainBiddingDetailVC.h"//项目详情页面
#import "DDBuilderChangeRecordVC.h"//变更记录
#import "DDReceivedProjectsHeaderView.h"//顶部头视图
#import "DDPersonalIdentityCheckVC.h"//认领页面
#import "DDCertiExplainVC.h"//证书申述页面
#import "DDBusinessLicenseChangeRecordCell.h"
#import "DDBusinessLicenseChangeModel.h"
#import "DDBusinessLicenseChangeSectionView.h"

#import "DDNewFindingWinBiddingProjectCell.h"
#import "DDSearchProjectListModel.h"
#import "DDProjectDetailVC.h"
@interface DDReceivedProjectsListVC ()<UITableViewDelegate,UITableViewDataSource,DDReceivedProjectsHeaderViewDelegate>

{    
    NSInteger _currentPage;
    NSInteger pageCount;
    NSMutableArray *_dataSourceArr;
    NSMutableDictionary *_dict;
    
    UILabel *_leftLab;//"搜索到"三个字的label
    UILabel *_numLabel;//总计数量label
    UILabel *_rightLab;//"个公司"三个字的label
    
    UIView *_titleView;
}
@property (nonatomic,strong) DataLoadingView *loadingView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) DDNoResult2View *noResultView;//无数据视图
@property (nonatomic,strong) DDReceivedProjectsHeaderView *topView;//顶部视图
@property (nonatomic,strong) DDPersonalDetailInfoModel *detailInfoModel;//人员详情信息model
@property (nonatomic,strong) UILabel * headerLabel;//tabview头视图

@end

@implementation DDReceivedProjectsListVC

-(void)viewWillDisappear:(BOOL)animated{
    [_titleView removeFromSuperview];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar addSubview:_titleView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSourceArr=[[NSMutableArray alloc]init];
    self.view.backgroundColor = kColorBackGroundColor;
    [self createTableView];
    [self createLoadView];
    [self requestData];
}

//返回上一页面
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 创建加载视图
-(void)createLoadView{
    __weak __typeof(self) weakSelf=self;
    _noResultView=[[DDNoResult2View alloc]initWithFrame:CGRectMake(0,0, Screen_Width, Screen_Height-KNavigationBarHeight-175-15-45)];
    [self.view addSubview:_noResultView];
    
    _loadingView = [[DataLoadingView alloc] initWithController:self];
    _loadingView.loadingTitle = KLoading;
    _loadingView.failureTitle = KLoadingFailure;
    _loadingView.reloadHandle = ^(void){
        [weakSelf requestData];
    };
    [_loadingView showLoadingView];
}

#pragma mark 创建tableView
-(void)createTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0.5, Screen_Width, Screen_Height-KNavigationBarHeight-175-15-45) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.showsVerticalScrollIndicator=YES;
    _tableView.separatorColor=KColorTableSeparator;
    [_tableView registerClass:[DDNewFindingWinBiddingProjectCell class] forCellReuseIdentifier:@"DDNewFindingWinBiddingProjectCell"];
    __weak __typeof(self) weakSelf=self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestData];
    }];
}

#pragma mark 请求数据
- (void)requestData{
    _currentPage = 1;
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:self.staffInfoId forKey:@"staffInfoId"];
    [params setValue:[NSString stringWithFormat:@"%ld",_currentPage] forKey:@"current"];
    [params setValue:@"10" forKey:@"size"];
    
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_peoplestaffBids params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"**********建造师承接过的项目结果数据***************%@",responseObject);
        
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
            _rightLab.frame=CGRectMake(CGRectGetMaxX(_numLabel.frame)+2, 15, 45, 15);
            
            if (listArr.count!=0) {
                [_noResultView hide];
                
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
                    MJRefreshAutoStateFooter *footer=[MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
                        
                    }];
                    [footer endRefreshingWithNoMoreData];
                    [footer setTitle:kNoMoreData forState:MJRefreshStateNoMoreData];
                    footer.stateLabel.textColor=KColorBidApprovalingWait;
                    self.tableView.mj_footer = footer;
                }
            }
            else{
                [_noResultView showWithTitle:@"没有相关内容~" subTitle:nil image:@"noResult_content"];
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
    _currentPage++;
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [params setValue:self.staffInfoId forKey:@"staffInfoId"];
    [params setValue:[NSString stringWithFormat:@"%ld",(long)_currentPage] forKey:@"current"];
    [params setValue:@"10" forKey:@"size"];
    
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_peoplestaffBids params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"**********建造师承接过的项目结果数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        __weak __typeof(self) weakSelf = self;
        if (response.isSuccess) {
            
            _dict = responseObject[KData];
            NSArray *listArr = _dict[@"list"];
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
                MJRefreshAutoStateFooter *footer=[MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
                    
                }];
                [footer endRefreshingWithNoMoreData];
                [footer setTitle:kNoMoreData forState:MJRefreshStateNoMoreData];
                footer.stateLabel.textColor=KColorBidApprovalingWait;
                self.tableView.mj_footer = footer;
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

#pragma mark tableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataSourceArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DDSearchProjectListModel *model=_dataSourceArr[indexPath.section];
    DDNewFindingWinBiddingProjectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DDNewFindingWinBiddingProjectCell" forIndexPath:indexPath];
    if (![DDUtils isEmptyString:model.name]) {
        cell.titleLab.text=[NSString stringWithFormat:@"[%@]%@",model.name,model.title];
    }else{
        cell.titleLab.text=[NSString stringWithFormat:@"%@",model.title];
    }
    cell.winBiddingLab.textColor=KColorGreySubTitle;
    cell.winBiddingLab.text = model.enterprise_name;
    
    if (![DDUtils isEmptyString:model.money_type]) {
        if ([model.money_type integerValue] == 0) {
            if (model.win_bid_amount) {
                if (model.win_bid_amount.doubleValue>100000000 || model.win_bid_amount.doubleValue==100000000) {
                    cell.priceLab2.text=[NSString stringWithFormat:@"%@亿",[self handleAmount2:model.win_bid_amount]];
                }
                else{
                    cell.priceLab2.text=[NSString stringWithFormat:@"%@万",[self handleAmount:model.win_bid_amount]];
                }
            } else {
                cell.priceLab2.text=@"-";
            }
        }else{
            cell.priceLab2.text=model.win_bid_text;
        }
    }else{
        cell.priceLab2.text=@"-";
    }
    cell.timeLab2.text=model.publish_date;
    return cell;
}
-(NSString *)handleAmount:(NSString *)amount{
    //需要参与运算的两个数
    NSDecimalNumber *num = [NSDecimalNumber decimalNumberWithString:amount];
    NSDecimalNumber *w = [NSDecimalNumber decimalNumberWithString:@"10000"];
    
    //运算结果处理：小数精确到后2位，其余位无条件舍弃
    NSDecimalNumberHandler *handler = [NSDecimalNumberHandler
                                       decimalNumberHandlerWithRoundingMode:NSRoundDown//要使用的舍入模式
                                       scale:2             //结果保留几位小数
                                       raiseOnExactness:NO //发生精确错误时是否抛出异常，一般为NO
                                       raiseOnOverflow:NO  //发生溢出错误时是否抛出异常，一般为NO
                                       raiseOnUnderflow:NO //发生不足错误时是否抛出异常，一般为NO
                                       raiseOnDivideByZero:YES];//被0除时是否抛出异常，一般为YES
    
    //将两个数进行除法运算，并对结果加以处理(handler)
    num = [num decimalNumberByDividingBy:w withBehavior:handler];
    NSString *ret = [NSString stringWithFormat:@"%@", num];
    
    return ret;
    //return [self removeFloatAllZero:ret];
}
-(NSString *)handleAmount2:(NSString *)amount{
    //需要参与运算的两个数
    NSDecimalNumber *num = [NSDecimalNumber decimalNumberWithString:amount];
    NSDecimalNumber *w = [NSDecimalNumber decimalNumberWithString:@"100000000"];
    
    //运算结果处理：小数精确到后2位，其余位无条件舍弃
    NSDecimalNumberHandler *handler = [NSDecimalNumberHandler
                                       decimalNumberHandlerWithRoundingMode:NSRoundDown//要使用的舍入模式
                                       scale:2             //结果保留几位小数
                                       raiseOnExactness:NO //发生精确错误时是否抛出异常，一般为NO
                                       raiseOnOverflow:NO  //发生溢出错误时是否抛出异常，一般为NO
                                       raiseOnUnderflow:NO //发生不足错误时是否抛出异常，一般为NO
                                       raiseOnDivideByZero:YES];//被0除时是否抛出异常，一般为YES
    
    //将两个数进行除法运算，并对结果加以处理(handler)
    num = [num decimalNumberByDividingBy:w withBehavior:handler];
    NSString *ret = [NSString stringWithFormat:@"%@", num];
    
    return ret;
    //return [self removeFloatAllZero:ret];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DDSearchProjectListModel *model=_dataSourceArr[indexPath.section];
    DDProjectDetailVC *projectDetail=[[DDProjectDetailVC alloc]init];
    projectDetail.winCaseId=model.win_case_id;
    projectDetail.hidesBottomBarWhenPushed=YES;
    [self.mainViewContoller.navigationController pushViewController:projectDetail animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return CGFLOAT_MIN;
    }
    else{
        return 15;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    DDCompanyBuilderProjectModel *model=_dataSourceArr[section];
    
    if ([DDUtils isEmptyString:model.trading_center]) {
        return CGFLOAT_MIN;
    }
    else{
        return 40;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    DDCompanyBuilderProjectModel *model=_dataSourceArr[section];
    
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






@end
