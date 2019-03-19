//
//  DDFireEngineerMoreEduDetailVC.m
//  GongChengDD
//
//  Created by xzx on 2018/9/26.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDFireEngineerMoreEduDetailVC.h"
#import "DataLoadingView.h"
#import "DDNoResult2View.h"//无数据视图
#import "MJRefresh.h"
#import "DDFireEngineerMoreEduCell.h"//cell
#import "DDFireEngineerMoreEduModel.h"//model

@interface DDFireEngineerMoreEduDetailVC ()<UITableViewDelegate,UITableViewDataSource>

{
    BOOL isLastData;
    NSInteger currentPage;
    NSInteger pageCount;
    NSMutableArray *_dataSourceArr;
    NSMutableDictionary *_dict;
}
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) DataLoadingView *loadingView;
@end

@implementation DDFireEngineerMoreEduDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColorBackGroundColor;
    _dataSourceArr = [[NSMutableArray alloc]init];
    self.navigationItem.title = @"继续教育情况";
    self.navigationItem.leftBarButtonItem = [DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
    [self.view addSubview:self.tableView];
    [self setupDataLoadingView];
    [self requestData:YES];
}

#pragma mark 返回上一页
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupDataLoadingView{
    __weak __typeof(self) weakSelf=self;
    _loadingView = [[DataLoadingView alloc] initWithController:self];
    _loadingView.loadingTitle = KLoading;
    _loadingView.failureTitle = KLoadingFailure;
    _loadingView.reloadHandle = ^(void){
        [weakSelf requestData:YES];
    };
    [_loadingView showLoadingView];
}

#pragma mark 请求数据
- (void)requestData:(BOOL)isRefresh{
    
    if (isRefresh) {
        currentPage = 1;
    }
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:self.staffId forKey:@"id"];
    [params setValue:[NSString stringWithFormat:@"%ld",currentPage] forKey:@"current"];
    [params setValue:@"10" forKey:@"size"];
    
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_fireEngineerMoreEduDetail params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"**********消防工程师继续教育数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            currentPage += 1;
            if (isRefresh) {
                 [_dataSourceArr removeAllObjects];
                if (self.tableView.mj_footer) {
                    [self.tableView.mj_footer resetNoMoreData];
                }
            }
           [_loadingView hiddenLoadingView];
            _dict = responseObject[KData];
            pageCount = [_dict[@"totalCount"] integerValue];
            
            NSArray *orderArr = [[NSArray alloc]init];
            NSArray *listArr=_dict[@"list"];
            orderArr = [DDFireEngineerMoreEduModel mj_objectArrayWithKeyValuesArray:listArr];
            [_dataSourceArr addObjectsFromArray:orderArr];
            if (_dataSourceArr.count<pageCount) {
                isLastData = NO;
            }else{
                isLastData = YES;
            }
            [self.tableView reloadData];
            [self endRefrshing:YES];
        }
        else{
            [self endRefrshing:NO];
            [_loadingView failureLoadingView];
        }
    }  failure:^(NSURLSessionDataTask *operation, id responseObject)  {
        [self endRefrshing:NO];
        [DDUtils showToastWithMessage:kRequestFailed];
        [_loadingView failureLoadingView];
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
                    [self requestData:NO];
                }];
            }
            else if (isLastData == YES && !self.tableView.mj_footer)
            {
                return;
            }
            else if(isLastData == YES && self.tableView.mj_footer)
            {
                
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
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

#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_dataSourceArr.count == 0) {
        return 1;
    }
    return _dataSourceArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_dataSourceArr.count==0) {
        static  NSString *reuseId = @"UITableViewCell";
        UITableViewCell  *noDataCell =[tableView dequeueReusableCellWithIdentifier:reuseId];
        if (!noDataCell) {
            noDataCell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
            noDataCell.selectionStyle=UITableViewCellSelectionStyleNone;
            DDNoResult2View *noResultView=[[DDNoResult2View alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frameWidth, self.tableView.frameHeight)];
            [noResultView showWithTitle:@"没有相关内容~" subTitle:nil image:@"noResult_content"];
            [noDataCell.contentView addSubview:noResultView];
            
        }
        return noDataCell;
    }
    
    DDFireEngineerMoreEduModel *model=_dataSourceArr[indexPath.section];
    static NSString * cellID = @"DDFireEngineerMoreEduCell";
    DDFireEngineerMoreEduCell * cell = (DDFireEngineerMoreEduCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
    }
    
    
    [cell loadDataWithModel:model];
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_dataSourceArr.count==0) {
        return self.tableView.frameHeight;
    }
    return 150;
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
#pragma mark -- lazy
-(UITableView *)tableView{
    if(!_tableView){
        _tableView = [UITableView tableViewWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-KNavigationBarHeight-KHomeIndicatorHeight) tstyle:UITableViewStyleGrouped tdelegate:self tdatasource:self backgroundColor:kColorBackGroundColor sepratorStyle:UITableViewCellSeparatorStyleNone];
        kWeakSelf
        _tableView.mj_header=[MJRefreshStateHeader  headerWithRefreshingBlock:^{
            [weakSelf requestData:YES];
        }];
    }
    return _tableView;
}


@end
