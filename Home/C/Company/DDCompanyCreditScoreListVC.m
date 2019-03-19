//
//  DDCompanyCreditScoreListVC.m
//  GongChengDD
//
//  Created by xzx on 2018/9/19.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDCompanyCreditScoreListVC.h"
#import "DataLoadingView.h"
#import "DDNoResult2View.h"//无数据视图
#import "MJRefresh.h"
#import "DDCompanyCreditScoreListModel.h"//model
#import "DDCompanyCreditScoreListCell.h"//cell
#import "DDGainBiddingDetailVC.h"//中标详情页面
#import "DDPeopleDetailVC.h"//人员详情页面
#import "DDServiceWebViewVC.h"
@interface DDCompanyCreditScoreListVC ()<UITableViewDelegate,UITableViewDataSource>

{
    NSInteger currentPage;
    NSInteger pageCount;
    NSMutableArray *_dataSourceArr;
    NSMutableDictionary *_dict;
        
    UILabel *_label1;
    CGRect _numFrame;
    UILabel *_totalNumLab;
    UILabel *_label2;
    CGRect _amountFrame;
    UILabel *_totalAmountLab;
    UILabel *_label3;
}
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) DataLoadingView *loadingView;
@property (nonatomic,strong) DDNoResult2View *noResultView;//无数据视图
    
@end

@implementation DDCompanyCreditScoreListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kColorBackGroundColor;
    self.navigationItem.title = @"信用评价";
    self.navigationItem.leftBarButtonItem = [DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
//    self.navigationItem.rightBarButtonItem=[DDUtils rightbuttonItemWithTitle:@"资质办理" target:self action:@selector(rightButtonClick)];
    _dataSourceArr = [[NSMutableArray alloc]init];
    
    [self createChooseBtns];
    [self setupTableView];
    [self setupDataLoadingView];
    [self requestData];
}
//-(void)rightButtonClick{
//    DDServiceWebViewVC *checkVC = [DDServiceWebViewVC new];
//    checkVC.hostUrl = @"http://gcdd.koncendy.com/apphs/enterprise_service/pages/handle_list.html?groupId=1";
//    checkVC.hidesBottomBarWhenPushed=YES;
//    [self.navigationController pushViewController:checkVC animated:YES];
//}
#pragma mark 返回上一页
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}
    
-(void)createChooseBtns{
    UIView *summaryView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 45)];
    [self.view addSubview:summaryView];
    
//    _label1=[[UILabel alloc]initWithFrame:CGRectMake(12, 15, 45, 15)];
//    _label1.text=@"信用分";
//    _label1.textColor=KColorGreySubTitle;
//    _label1.font=kFontSize28;
//    [summaryView addSubview:_label1];
//
//
//    _totalNumLab=[[UILabel alloc]init];
//    _numFrame= [@"0" boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize28} context:nil];
//    _totalNumLab.frame=CGRectMake(CGRectGetMaxX(_label1.frame)+2, 15, _numFrame.size.width, 15);
//    _totalNumLab.text=@"0";
//    _totalNumLab.textColor=kColorBlue;
//    _totalNumLab.font=kFontSize28;
//    [summaryView addSubview:_totalNumLab];
    
    
    _label2=[[UILabel alloc]initWithFrame:CGRectMake(12, 15, 15, 15)];
    _label2.text=@"共";
    _label2.textColor=KColorGreySubTitle;
    _label2.font=kFontSize28;
    [summaryView addSubview:_label2];
    
    
    _amountFrame= [@"0" boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize28} context:nil];
    _totalAmountLab=[[UILabel alloc]init];
    _totalAmountLab.frame=CGRectMake(CGRectGetMaxX(_label2.frame)+2, 15, _amountFrame.size.width, 15);
    _totalAmountLab.text=@"0";
    _totalAmountLab.textColor=KColorBlackTitle;
    _totalAmountLab.font=kFontSize28;
    [summaryView addSubview:_totalAmountLab];
    
    
    _label3=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_totalAmountLab.frame)+2, 15, 110, 15)];
    _label3.text=@"个主管部门评价";
    _label3.textColor=KColorGreySubTitle;
    _label3.font=kFontSize28;
    [summaryView addSubview:_label3];
}
    

- (void)setupTableView{
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,45, Screen_Width, Screen_Height-KNavigationBarHeight-45) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor=[UIColor clearColor];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    _tableView.backgroundColor=kColorBackGroundColor;
    [self.tableView setSeparatorColor:KColorTableSeparator];
    self.tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width,KTableViewFooterViewHeight)];
    [self.view addSubview:self.tableView];
    _tableView.estimatedRowHeight = 44;
    
    __weak __typeof(self) weakSelf=self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestData];
    }];
}
    
- (void)setupDataLoadingView{
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
    [params setValue:[NSString stringWithFormat:@"%ld",currentPage] forKey:@"current"];
    [params setValue:@"10" forKey:@"size"];
    
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_creditScoreList params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"**********信用评分结果数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        __weak __typeof(self) weakSelf = self;
        if (response.isSuccess) {
            [_dataSourceArr removeAllObjects];
            [_loadingView hiddenLoadingView];
            _dict = responseObject[KData][@"crediscore"];
            pageCount = [_dict[@"totalCount"] integerValue];
            NSArray *listArr=_dict[@"list"];
            
            if (listArr.count!=0) {//有数据
                [_noResultView hide];
                
                for (NSDictionary *dic in listArr) {
                    DDCompanyCreditScoreListModel *model = [[DDCompanyCreditScoreListModel alloc]initWithDictionary:dic error:nil];
                    [_dataSourceArr addObject:model];
                }
                
//                NSString *totlaNum=[NSString stringWithFormat:@"%@",responseObject[KData][@"totalScore"][@"score"]];
//                _numFrame= [totlaNum boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
//                _totalNumLab.frame=CGRectMake(CGRectGetMaxX(_label1.frame)+2, 15, _numFrame.size.width, 15);
//                _totalNumLab.text=totlaNum;
//
//                _label2.frame=CGRectMake(CGRectGetMaxX(_totalNumLab.frame)+2, 15, 45, 15);

                NSString *totalAmount=[NSString stringWithFormat:@"%@",responseObject[KData][@"totalScore"][@"num"]];
                _amountFrame= [totalAmount boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
                _totalAmountLab.frame=CGRectMake(CGRectGetMaxX(_label2.frame)+2, 15, _amountFrame.size.width, 15);
                _totalAmountLab.text=totalAmount;

                _label3.frame=CGRectMake(CGRectGetMaxX(_totalAmountLab.frame)+2, 15, 110, 15);
                
                
                if (listArr.count<pageCount) {
                    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                        [weakSelf addData];
                    }];
                }
                else{
                  [_tableView.mj_footer removeFromSuperview];
                }
            }
            else{//数据为空
                [_noResultView showWithTitle:@"暂无相关信用评分信息" subTitle:@"去其他地方看看~" image:@"noResult_content"];
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
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:self.enterpriseId forKey:@"enterpriseId"];
    [params setValue:[NSString stringWithFormat:@"%ld",currentPage] forKey:@"current"];
    [params setValue:@"10" forKey:@"size"];
    
    
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_creditScoreList params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"**********信用评分结果数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        __weak __typeof(self) weakSelf = self;
        if (response.isSuccess) {
            
            _dict = responseObject[KData][@"crediscore"];
            NSArray *listArr = _dict[@"list"];
            for (NSDictionary *dic in listArr) {
                DDCompanyCreditScoreListModel *model = [[DDCompanyCreditScoreListModel alloc]initWithDictionary:dic error:nil];
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
    
    
#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataSourceArr.count;
}
    
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
    
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellID = @"DDCompanyCreditScoreListCell";
    DDCompanyCreditScoreListCell * cell = (DDCompanyCreditScoreListCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
    }
    
    DDCompanyCreditScoreListModel * model = _dataSourceArr[indexPath.section];
    [cell loadDataWithModel:model];

    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
    
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    DDWinTheBiddModel * model = _dataSourceArr[indexPath.section];
//
//    DDGainBiddingDetailVC *winBiddingDetail=[[DDGainBiddingDetailVC alloc]init];
//    winBiddingDetail.winCaseId=model.win_case_id;
//    [self.navigationController pushViewController:winBiddingDetail animated:YES];
//}
    
    //#pragma mark 点击跳转到公司详情
    //-(void)companyDetailClick:(UIButton *)sender{
    //    if ([DDUtils isEmptyString:[DDUserManager sharedInstance].userid]) {
    //        [self presentLoginVCWithSender1:sender];
    //    }
    //    else{
    //        DDSearchProjectListModel *model=_dataSourceArr[sender.tag];
    //
    //        DDCompanyDetailVC *companyDetailVC=[[DDCompanyDetailVC alloc]init];
    //        companyDetailVC.enterpriseId=model.enterpriseId;
    //        companyDetailVC.hidesBottomBarWhenPushed=YES;
    //        [self.navigationController pushViewController:companyDetailVC animated:YES];
    //    }
    //}
    
//#pragma mark 点击跳转到人员详情
//-(void)peopleDetailClick:(UIButton *)sender{
//    DDWinTheBiddModel * model =_dataSourceArr[sender.tag];
//
//    DDPeopleDetailVC *peopleDetail=[[DDPeopleDetailVC alloc]init];
//    peopleDetail.staffInfoId=model.staff_info_id;
//    peopleDetail.hidesBottomBarWhenPushed=YES;
//    [self.navigationController pushViewController:peopleDetail animated:YES];
//}
    
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 305;
}
    
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGFLOAT_MIN;
    }
    return 15;
}
    
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
    
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
    
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}


@end
