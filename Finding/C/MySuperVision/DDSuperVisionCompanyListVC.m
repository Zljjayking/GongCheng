//
//  DDSuperVisionCompanyListVC.m
//  GongChengDD
//
//  Created by xzx on 2018/11/26.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDSuperVisionCompanyListVC.h"
#import "DataLoadingView.h"
#import "DDCompanyFocusModel.h"
#import "MJRefresh.h"
#import "DDCompanyFocusCell.h"
#import "DDCompanyFocusModel.h"
#import "DDCompanyDetailVC.h"
#import "DDNoCompanyFocusDataView.h"
#import "DDAllSearchVC.h"
#import "DDdeleteCompanyView.h"
#import "AppDelegate.h"

@interface DDSuperVisionCompanyListVC ()<UITableViewDelegate,UITableViewDataSource,DDdeleteCompanyViewDelegate>

@property (strong,nonatomic)UITableView * tableView;
@property (assign,nonatomic)NSInteger current;//当前页
@property (assign,nonatomic)DataLoadingView * loadingView;
@property (strong,nonatomic)NSMutableArray * dataArray;//数据源
@property (strong,nonatomic)DDCompanyFocusModel * delectModel;//要删除的模型
@property (strong,nonatomic)DDNoCompanyFocusDataView *noDataView;

@end

@implementation DDSuperVisionCompanyListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColorBackGroundColor;
    self.navigationItem.title = @"公司中标监控";
    self.navigationItem.leftBarButtonItem = [DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"我的" target:self action:@selector(leftButtonClick)];
    [self setupTableView];
    [self setupDataLoadingView];
    [self requestData];
    [self setupNoDataView];
    
    //监听关注或取消关注
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addOrCancelAttention) name:KAddOrCancelAttention object:nil];
}

- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addOrCancelAttention{
    [self requestData];
}

#pragma mark 创建tableView
-(void)setupTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,0, Screen_Width, Screen_Height-KNavigationBarHeight) style:UITableViewStyleGrouped];//NBLScrollTabItem高度45
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //_tableView.separatorColor = KColorTableSeparator;
    //_tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, KTableViewFooterViewHeight)];
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
    __weak __typeof(self) weakSelf=self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestData];
    }];
}

- (void)setupDataLoadingView{
    __weak __typeof(self) weakSelf = self;
    _loadingView = [[DataLoadingView alloc] initWithController:self];
    _loadingView.loadingTitle = KLoading;
    _loadingView.failureTitle = KLoadingFailure;
    _loadingView.reloadHandle = ^(void){
        [weakSelf requestData];
    };
    [_loadingView showLoadingView];
}

- (void)setupNoDataView{
    __weak __typeof(self) weakSelf = self;
    _noDataView = [[DDNoCompanyFocusDataView alloc] initWithFrame:CGRectMake(0,0, Screen_Width, Screen_Height-KTabbarHeight)];
    _noDataView.actionBlock = ^(void){
        //去看看
        DDAllSearchVC *allSearch=[[DDAllSearchVC alloc]init];
        allSearch.type=@"2";
        allSearch.menuId=@"6";//找企业
        [weakSelf.navigationController pushViewController:allSearch animated:NO];
        
        //跳到tabbar企业列表
        //        weakSelf.mainViewContoller.tabBarController.selectedIndex = 1;
        //        [weakSelf.mainViewContoller.navigationController popToRootViewControllerAnimated:NO];
    };
    [self.tableView addSubview:_noDataView];
}

- (void)setupEmptyView{
    //空数据页面判断
    if (_dataArray.count !=0) {
        [_noDataView hide];
    }
    else{
        //[_noDataView showWithTitle:charNoFocusCompany subTitle:charFocusCompanyEffect buttonTitle:charGotoSee image:@"noResult_content"];
        [_noDataView showWithTitle:charNoFocusCompany subTitle:charFocusCompanyEffect buttonTitle:@"" image:@"noResult_content"];
        [_tableView addSubview:_noDataView];
    }
}

#pragma mark 请求数据
- (void)requestData{
    _current = 1;
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    DDUserManager * userManger = [DDUserManager sharedInstance];
    [params setValue:userManger.userid forKey:@"userId"];
    [params setValue:@"4" forKey:@"attentionType"];//1以上都关注   2企业证书  3人员证书   4中标业绩   5法律风险  6奖惩情况 7信用情况
    [params setValue:[NSString stringWithFormat:@"%ld",_current] forKey:@"current"];//当前页
    [params setValue:@"10" forKey:@"size"];//每页记录数
    
    [[DDHttpManager sharedInstance]sendGetRequest:KHtpRequest_myUaattentionList params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"公司中标监控（以前的公司关注）数据%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            [_loadingView hiddenLoadingView];
            [self.dataArray removeAllObjects];
            
            __weak __typeof(self) weakSelf = self;
            
            if ([response.data isKindOfClass:[NSDictionary class]]) {
                NSArray * list = [DDCompanyFocusModel arrayOfModelsFromDictionaries:response.data[KList] error:nil];
                [_dataArray addObjectsFromArray:list];
                
                
                if (list.count < 10) {
                    //移除"加载更多"
                    [self.tableView.mj_footer removeFromSuperview];
                }else{
                    //添加"加载更多"
                    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                        [weakSelf addData];
                    }];
                }
                
                //空数据页面判断
                [self setupEmptyView];
            }
            
        }
        else{
            [_loadingView failureLoadingView];
            [DDUtils showToastWithMessage:response.message];
        }
        
        [_tableView.mj_header endRefreshing];
        [_tableView reloadData];
    } failure:^(NSURLSessionDataTask *operation, id responseObject) {
        [_tableView.mj_header endRefreshing];
        [_loadingView failureLoadingView];
        [DDUtils showToastWithMessage:kRequestFailed];
    }];
}

- (void)addData{
    _current++;
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    DDUserManager * userManger = [DDUserManager sharedInstance];
    [params setValue:userManger.userid forKey:@"userId"];
    [params setValue:@"4" forKey:@"attentionType"];//1以上都关注   2企业证书  3人员证书   4中标业绩   5法律风险  6奖惩情况 7信用情况
    [params setValue:[NSString stringWithFormat:@"%ld",_current] forKey:@"current"];//当前页
    [params setValue:@"10" forKey:@"size"];//每页记录数
    
    [[DDHttpManager sharedInstance]sendGetRequest:KHtpRequest_myUaattentionList params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"公司中标监控（以前的公司关注）数据%@",responseObject);
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            __weak __typeof(self) weakSelf = self;
            if ([response.data isKindOfClass:[NSDictionary class]]) {
                NSArray * list = [DDCompanyFocusModel arrayOfModelsFromDictionaries:response.data[KList] error:nil];
                [_dataArray addObjectsFromArray:list];
                if (list.count < 10) {
                    //移除"加载更多"
                    [self.tableView.mj_footer removeFromSuperview];
                }else{
                    //添加"加载更多"
                    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                        [weakSelf addData];
                    }];
                }
            }
            
        }
        else{
            [DDUtils showToastWithMessage:response.message];
        }
        
        [_tableView.mj_footer endRefreshing];
        [_tableView reloadData];
    } failure:^(NSURLSessionDataTask *operation, id responseObject) {
        [_tableView.mj_footer endRefreshing];
        [DDUtils showToastWithMessage:kRequestFailed];
    }];
}

#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellID = @"DDCompanyFocusCell";
    DDCompanyFocusCell * cell = (DDCompanyFocusCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:cellID owner:self options:nil]firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    DDCompanyFocusModel * model = _dataArray[indexPath.section];
    [cell loadWithModel:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DDCompanyFocusModel * model = _dataArray[indexPath.section];
    DDCompanyDetailVC * vc = [[DDCompanyDetailVC alloc] init];
    vc.enterpriseId = model.enterpriseId;
    [self.navigationController pushViewController:vc animated:YES];
}

-(nullable NSArray<UITableViewRowAction *>*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    DDCompanyFocusModel * model = _dataArray[indexPath.section];
    _delectModel = model;
    //左滑操作
    UITableViewRowAction *delete=[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:charCancelFocusName handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        //给个确认提示
        DDdeleteCompanyView * deleteCompanyView = [[[NSBundle mainBundle] loadNibNamed:@"DDdeleteCompanyView" owner:self options:nil] firstObject];
        deleteCompanyView.titleLab1.text = charCancelFocusRemind;
        deleteCompanyView.delegate = self;
        [deleteCompanyView show];
    }];
    delete.backgroundColor = kColorRed;
    return @[delete];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;{
    return [DDCompanyFocusCell height];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 15)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

#pragma mark DDdeleteCompanyViewDelegate 取消关注代理
//点击了确定
- (void)deleteCompanyViewClickSure:(DDdeleteCompanyView*)deleteCompanyView{
    [deleteCompanyView hide];
    [self deleteCompanyFocusWithModel];
}

#pragma mark 取消关注
- (void)deleteCompanyFocusWithModel{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    DDUserManager * userManger = [DDUserManager sharedInstance];
    [params setValue:userManger.userid forKey:@"userId"];//用户id
    [params setValue:_delectModel.enterpriseId forKey:@"entId"];//企业id
    [params setValue:_delectModel.attentionType forKey:@"attentionType"];
    MBProgressHUD * hud = [DDUtils showHUDCustom:@""];
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_myUaattentionDelete params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            hud.mode = MBProgressHUDModeCustomView;
            hud.customView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"myinfo_saveSuccess"]];
            hud.detailsLabelText = @"已取消监控";
            [[NSNotificationCenter defaultCenter]postNotificationName:KAddOrCancelAttention object:nil];
            if (self.delegate && [self.delegate respondsToSelector:@selector(SuperVisionCompanyDeleteSucceed)])
            {
                [self.delegate SuperVisionCompanyDeleteSucceed];
            }
        }else{
             hud.labelText = response.message;
        }
        [hud hide:YES afterDelay:KHudShowTimeSecound];
        [_dataArray removeObject:_delectModel];
        [_tableView reloadData];
    } failure:^(NSURLSessionDataTask *operation, id responseObject) {
        hud.labelText = kRequestFailed;
        [hud hide:YES afterDelay:KHudShowTimeSecound];
    }];
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}
@end
