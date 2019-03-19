//
//  DDThreeACerVC.m
//  GongChengDD
//
//  Created by csq on 2018/9/19.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDThreeACerVC.h"
#import "MJRefresh.h"
#import "DataLoadingView.h"
#import "DDThreeACerModel.h"
#import "DDThreeACerCell.h"
#import "DDThreeACerDetailVC.h"
#import "DDNoResult2View.h"


@interface DDThreeACerVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)DDThreeACerModel * model;
@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic,assign)NSInteger current;//当前页
@property (nonatomic,strong)DataLoadingView * loadingView;
@property (nonatomic,strong)DDNoResult2View *noResultView;//无数据视图
@end

@implementation DDThreeACerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kColorBackGroundColor;
    self.navigationItem.title = @"AAA证书";
    self.navigationItem.leftBarButtonItem = [DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];

    _dataArray = [[NSMutableArray alloc] initWithCapacity:10];

    [self setupTableView];
    [self setupDataLoadingView];
    [self requestData];
}

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
    
    [[DDHttpManager sharedInstance] sendGetRequest:kHttpRequest_scenterpriseinfoaaaList params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            [_loadingView hiddenLoadingView];
            [_dataArray removeAllObjects];
            
            if ([response.data isKindOfClass:[NSDictionary class]]) {

               _model = [[DDThreeACerModel alloc] initWithDictionary:response.data error:nil];
                [_dataArray addObjectsFromArray:_model.list];
                
                if (_model.list.count >= 10) {
                    //加载更多
                    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                        [self addData];
                    }];
                }else{
                    [_tableView.mj_footer removeFromSuperview];
                }
                
                //没有数据
                if (_dataArray.count == 0) {
                    [_noResultView showWithTitle:@"暂无AAA证书" subTitle:nil image:@"noResult_content"];
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
    
    [[DDHttpManager sharedInstance] sendGetRequest:kHttpRequest_scenterpriseinfoaaaList params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            
            if ([response.data isKindOfClass:[NSDictionary class]]) {
                _model = [[DDThreeACerModel alloc] initWithDictionary:response.data error:nil];
                [_dataArray addObjectsFromArray:_model.list];
                
                if (_model.list.count >= 10) {
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
    static NSString * cellID = @"DDThreeACerCell";
    DDThreeACerCell * cell = (DDThreeACerCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:cellID owner:self options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    DDThreeACerListModel* model = _dataArray[indexPath.section];
    [cell loadWithModel:model];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellID = @"DDThreeACerCell";
    DDThreeACerCell * cell = (DDThreeACerCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:cellID owner:self options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    DDThreeACerListModel* model = _dataArray[indexPath.section];
    [cell loadWithModel:model];
    return [cell height];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DDThreeACerDetailVC * detail = [[DDThreeACerDetailVC alloc] init];
    DDThreeACerListModel* model = _dataArray[indexPath.section];
    detail.passValueID = model.id;
    [self.navigationController pushViewController:detail animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 44;
    }else{
        return 15;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView * header = [[UIView alloc] init];
        header.frame = CGRectMake(0, 0, Screen_Width, 44);
        
        UILabel * lab = [[UILabel alloc] init];
        lab.frame = CGRectMake(10, 0, 150, 44);
        lab.backgroundColor = [UIColor clearColor];
        lab.textColor = KColorGreySubTitle;
        lab.font = kFontSize28;
        [header addSubview:lab];
        
        NSString * numString = [NSString stringWithFormat:@"%ld",_model.list.count];
        NSString * totalString = [NSString stringWithFormat:@"共%@条AAA证书信息",numString];
        NSMutableAttributedString * attributedString = [DDUtils adjustTextColor:(NSString *)totalString rangeText:numString color:KColorBlackTitle];
        lab.attributedText = attributedString;
        
        return header;
    }else{
        UIView * header = [[UIView alloc] init];
        header.frame = CGRectMake(0, 0, Screen_Width, 15);
        return header;
    }
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
#pragma mark 返回上一页
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
