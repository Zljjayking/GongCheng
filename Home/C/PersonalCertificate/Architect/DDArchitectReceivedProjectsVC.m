//
//  DDArchitectReceivedProjectsVC.m
//  GongChengDD
//
//  Created by xzx on 2018/9/28.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDArchitectReceivedProjectsVC.h"
#import "MJRefresh.h"
#import "DDNavigationUtil.h"
#import "DataLoadingView.h"//加载页面
#import "DDNoResult2View.h"//无数据视图
#import "DDArchitectReceivedProjectsCell.h"//cell
#import "DDArchitectReceivedProjectsModel.h"//model
#import "DDPersonalDetailInfoModel.h"//人员详情model
//#import "DDProjectDetailVC.h"//项目详情页面
#import "DDGainBiddingDetailVC.h"//项目详情页面
//#import "DDCompanyDetailVC.h"//公司详情页面
//#import "DDPeopleDetailVC.h"//人员详情页面
#import "DDArchitectChangeRecordVC.h"//变更记录
#import "DDArchitectProjectsHeaderView.h"//顶部头视图
#import "DDPersonalIdentityCheckVC.h"//认领页面
#import "DDCertiExplainVC.h"//申述页面
#import "DDBusinessLicenseChangeRecordCell.h"
#import "DDBusinessLicenseChangeModel.h"
#import "DDBusinessLicenseChangeSectionView.h"


@interface DDArchitectReceivedProjectsVC ()<UITableViewDelegate,UITableViewDataSource,DDArchitectProjectsHeaderViewDelegate>

{
    NSInteger _currentPage;
    NSInteger _pageCount;
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
//@property (nonatomic,strong) UILabel * headerLabel;//tabview头视图

@end

@implementation DDArchitectReceivedProjectsVC

-(void)viewWillDisappear:(BOOL)animated{
    [_titleView removeFromSuperview];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar addSubview:_titleView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataSourceArr=[[NSMutableArray alloc]init];
    self.view.backgroundColor=kColorBackGroundColor;
//    [self createChooseBtns];
    [self createTableView];
    [self createLoadView];
    [self requestData];
}

#pragma mark 创建加载视图
-(void)createLoadView{
    __weak __typeof(self) weakSelf=self;
    _noResultView=[[DDNoResult2View alloc]initWithFrame:CGRectMake(0,0, Screen_Width, Screen_Height-KNavigationBarHeight-105-15-45)];
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
    UIView *summaryView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 45)];
    summaryView.backgroundColor=kColorBackGroundColor;
    [self.view addSubview:summaryView];
    
    _leftLab=[[UILabel alloc]initWithFrame:CGRectMake(12, 15, 60, 15)];
    _leftLab.text=@"共承接过";
    _leftLab.textColor=KColorGreySubTitle;
    _leftLab.font=kFontSize26;
    [summaryView addSubview:_leftLab];
    
    _numLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_leftLab.frame)+2, 15, 1, 15)];
    _numLabel.text=@"";
    _numLabel.textColor=KColorBlackTitle;
    _numLabel.font=kFontSize26;
    [summaryView addSubview:_numLabel];
    
    _rightLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_numLabel.frame)+2, 15, 45, 15)];
    _rightLab.text=@"个项目";
    _rightLab.textColor=KColorGreySubTitle;
    _rightLab.font=kFontSize26;
    [summaryView addSubview:_rightLab];
}

#pragma mark 创建tableView
-(void)createTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-KNavigationBarHeight-15-105-45) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.showsVerticalScrollIndicator=YES;
    _tableView.separatorColor=KColorTableSeparator;
    
    
//    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,Screen_Width, 47)];
//    _tableView.tableHeaderView = headerView;
//    
//    UILabel * nameLab = [[UILabel alloc] init];
//    NSString * change = @"变更记录";
//    CGFloat width = [DDUtils widthForText:change withTextHeigh:20 withFont:kFontSize32];
//    nameLab.frame = CGRectMake(12, 0, width, 47);
//    nameLab.text = change;
//    nameLab.textColor = KColorBlackTitle;
//    nameLab.font = kFontSize32;
//    [headerView addSubview:nameLab];
//    
//    _headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(12+width, 0,30, 47)];
//    _headerLabel.textColor = KColorGreySubTitle;
//    _headerLabel.font = kFontSize28;
//    _headerLabel.textAlignment = NSTextAlignmentCenter;
//    [headerView addSubview:_headerLabel];
//    
//    UIView * bottomLine = [[UIView alloc] init];
//    bottomLine.frame = CGRectMake(0, 46.5,Screen_Width, 0.5);
//    bottomLine.backgroundColor = KColorTableSeparator;
//    [headerView addSubview:bottomLine];
    
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
    
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_peopleProjectResult params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"**********工程业绩结果数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        __weak __typeof(self) weakSelf = self;
        if (response.isSuccess) {
            [_dataSourceArr removeAllObjects];
            [_loadingView hiddenLoadingView];
            _dict = responseObject[KData];
            _pageCount = [_dict[@"totalCount"] integerValue];
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
                    DDArchitectReceivedProjectsModel *model = [[DDArchitectReceivedProjectsModel alloc]initWithDictionary:dic error:nil];
                    [_dataSourceArr addObject:model];
                }
                
                if (listArr.count<_pageCount) {
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
    [params setValue:[NSString stringWithFormat:@"%ld",_currentPage] forKey:@"current"];
    [params setValue:@"10" forKey:@"size"];
    
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_peopleProjectResult params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"**********工程业绩结果数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        __weak __typeof(self) weakSelf = self;
        if (response.isSuccess) {
            
            _dict = responseObject[KData];
            NSArray *listArr = _dict[@"list"];
            for (NSDictionary *dic in listArr) {
                DDArchitectReceivedProjectsModel *model = [[DDArchitectReceivedProjectsModel alloc]initWithDictionary:dic error:nil];
                [_dataSourceArr addObject:model];
            }
            
            if (_dataSourceArr.count<_pageCount) {
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

#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableVie{
    return _dataSourceArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DDArchitectReceivedProjectsModel *model=_dataSourceArr[indexPath.section];
    
    static NSString * cellID = @"DDArchitectReceivedProjectsCell";
    DDArchitectReceivedProjectsCell * cell = (DDArchitectReceivedProjectsCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
    }
    
    [cell loadDataWithModel:model];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //不能点击
//    DDArchitectReceivedProjectsModel *model=_dataSourceArr[indexPath.section];
//
//    DDGainBiddingDetailVC *projectDetail=[[DDGainBiddingDetailVC alloc]init];
//    projectDetail.winCaseId=model.id;
//    [self.navigationController pushViewController:projectDetail animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
    //return 160;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    //    DDArchitectReceivedProjectsModel *model=_dataSourceArr[section];
    //
    //    UIView *footerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 40)];
    //    footerView.backgroundColor=kColorWhite;
    //
    ////    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(12, 12.5, Screen_Width-54, 15)];
    ////    if ([DDUtils isEmptyString:model.trading_center]) {
    ////        label.text=@"-";
    ////    }
    ////    else{
    ////        label.text=model.trading_center;
    ////    }
    ////    label.textColor=KColorGreySubTitle;
    ////    label.font=kFontSize24;
    ////    [footerView addSubview:label];
    //
    //    return footerView;
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    //    if (section==0) {
    //        return CGFLOAT_MIN;
    //    }
    //    else{
    //        return 15;
    //    }
    
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    //    DDArchitectReceivedProjectsModel *model=_dataSourceArr[section];
    //
    //    if ([DDUtils isEmptyString:model.trading_center]) {
    //        return CGFLOAT_MIN;
    //    }
    //    else{
    //        return 40;
    //    }
    
    return 15;
}




@end
