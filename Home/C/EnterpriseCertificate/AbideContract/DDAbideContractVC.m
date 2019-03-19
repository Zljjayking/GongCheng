//
//  DDAbideContractVC.m
//  GongChengDD
//
//  Created by csq on 2018/9/19.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDAbideContractVC.h"
#import "MJRefresh.h"
#import "DataLoadingView.h"
#import "DDDAbideContractModel.h"
#import "DDAbideContractCell.h"
#import "DDNoResult2View.h"
#import "DDServiceWebViewVC.h"

@interface DDAbideContractVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic,assign)NSInteger current;//当前页
@property (nonatomic,strong)DataLoadingView * loadingView;
@property (nonatomic,strong)DDNoResult2View *noResultView;//无数据视图

@end

@implementation DDAbideContractVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kColorBackGroundColor;
    self.navigationItem.title = @"守合同重信用";
    self.navigationItem.leftBarButtonItem = [DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
//    self.navigationItem.rightBarButtonItem=[DDUtils rightbuttonItemWithTitle:@"守重" target:self action:@selector(rightClick)];
    
    _dataArray = [[NSMutableArray alloc] initWithCapacity:10];
    
    [self setupTableView];
    [self setupDataLoadingView];
    [self requestData];
}
//-(void)rightClick{
//    DDServiceWebViewVC *checkVC = [DDServiceWebViewVC new];
//    checkVC.hostUrl = @"http://gcdd.koncendy.com/apphs/enterprise_service/pages/handle_list.html?groupId=10&typeId=53&_t=1545222141753";
//    [self.navigationController pushViewController:checkVC animated:YES];
//}
#pragma mark 设置tableView
-(void)setupTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,0, Screen_Width, Screen_Height-KNavigationBarHeight) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.separatorColor = KColorTableSeparator;
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width,KTableViewFooterViewHeight)];
    [self.view addSubview:_tableView];
    
    __weak __typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestData];
    }];
}
- (void)setupDataLoadingView{
    _noResultView=[[DDNoResult2View alloc]initWithFrame:CGRectMake(0,0, Screen_Width, Screen_Height-KNavigationBarHeight)];
    [self.tableView addSubview:_noResultView];
    
    __weak __typeof(self) weakSelf = self;
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
    _current = 1;
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:_enterpriseId forKey:@"enterpriseId"];
    [params setValue:_toAction forKey:@"toAction"];
    [params setValue:[NSString stringWithFormat:@"%ld",_current] forKey:@"current"];
    [params setValue:@"10" forKey:@"size"];
    
    [[DDHttpManager sharedInstance] sendGetRequest:KHttpRequest_scenterpriseinfoContractCreditList params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"**********守合同重信用详情数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            [_loadingView hiddenLoadingView];
            [_dataArray removeAllObjects];
            
            if ([response.data isKindOfClass:[NSDictionary class]]) {
                NSDictionary * data = (NSDictionary*)response.data;
                NSArray * list = data[KList];
                NSMutableArray * tempArray = [DDDAbideContractModel arrayOfModelsFromDictionaries:list error:nil];
                [_dataArray addObjectsFromArray:tempArray];
                
                if (list.count >= 10) {
                    //加载更多
                    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                        [self addData];
                    }];
                }else{
                    [_tableView.mj_footer removeFromSuperview];
                }
                
                //没有数据
                if (_dataArray.count == 0) {
                    [_noResultView showWithTitle:@"暂无守合同重信用" subTitle:nil image:@"noResult_content"];
                }else{
                    [_noResultView hide];
                }
            }
        } else {
            [_loadingView failureLoadingView];
            [DDUtils showToastWithMessage:response.message];
        }
        [_tableView.mj_header endRefreshing];
        [_tableView reloadData];
    } failure:^(NSURLSessionDataTask *operation, id responseObject) {
        [_tableView.mj_header endRefreshing];
        [DDUtils showToastWithMessage:kRequestFailed];
        [_loadingView failureLoadingView];
    }];
}
- (void)addData{
    _current ++;
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:_enterpriseId forKey:@"enterpriseId"];
    [params setValue:_toAction forKey:@"toAction"];
    [params setValue:[NSString stringWithFormat:@"%ld",_current] forKey:@"current"];
    [params setValue:@"10" forKey:@"size"];
    
    [[DDHttpManager sharedInstance] sendGetRequest:KHttpRequest_scenterpriseinfoContractCreditList params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            
            if ([response.data isKindOfClass:[NSDictionary class]]) {
                NSDictionary * data = (NSDictionary*)response.data;
                NSArray * list = data[KList];
                NSMutableArray * tempArray = [DDDAbideContractModel arrayOfModelsFromDictionaries:list error:nil];
                [_dataArray addObjectsFromArray:tempArray];
                
                if (list.count >= 10) {
                    //加载更多
                    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                        [self addData];
                    }];
                }else{
                    [_tableView.mj_footer removeFromSuperview];
                }
            }
        } else {
            [DDUtils showToastWithMessage:response.message];
        }
        [_tableView.mj_footer endRefreshing];
        [_tableView reloadData];
    } failure:^(NSURLSessionDataTask *operation, id responseObject) {
        [DDUtils showToastWithMessage:kRequestFailed];
        [_tableView.mj_footer endRefreshing];
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
    static NSString * cellID = @"DDAbideContractCell";
    DDAbideContractCell * cell = (DDAbideContractCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:cellID owner:self options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    DDDAbideContractModel* model = _dataArray[indexPath.section];
    [cell loadWithModel:model];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellID = @"DDAbideContractCell";
    DDAbideContractCell * cell = (DDAbideContractCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:cellID owner:self options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    DDDAbideContractModel* model = _dataArray[indexPath.section];
    [cell loadWithModel:model];
    return [cell height];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * header = [[UIView alloc] init];
    header.frame = CGRectMake(0, 0, Screen_Width, 15);
    return header;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
#pragma mark 返回上一页
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
