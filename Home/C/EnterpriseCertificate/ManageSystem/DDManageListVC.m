//
//  DDManageListVC.m
//  GongChengDD
//
//  Created by csq on 2018/9/19.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDManageListVC.h"
#import "DDManageListModel.h"
#import "DDManageListCell.h"
#import "MJRefresh.h"
#import "DataLoadingView.h"
#import "UIButton+ImageFrame.h"
#import "DDManageTypeSelectView.h"
#import "DDManageDetailVC.h"
#import "DDNoResult2View.h"

#define kSelectButtonWidth 155

@interface DDManageListVC ()<UITableViewDelegate,UITableViewDataSource,DDManageTypeSelectViewDelegate>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic,assign)NSInteger current;//当前页
@property (nonatomic,strong)DataLoadingView * loadingView;
@property (nonatomic,strong) UIButton * selectButton;
@property (nonatomic,assign)BOOL showSelectView;//YES正在显示"选择类别"view   NO不显示
@property (nonatomic,strong)DDManageTypeSelectView * manageTypeSelectView;
@property (nonatomic,assign)NSUInteger  pointRow;//选择了哪个类别
@property (nonatomic,strong)DDNoResult2View *noResultView;//无数据视图
@end

@implementation DDManageListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kColorBackGroundColor;
    self.navigationItem.title = @"管理体系";
    self.navigationItem.leftBarButtonItem = [DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
    _pointRow = 0;//默认是第0行
    _dataArray = [[NSMutableArray alloc] initWithCapacity:10];
    
    [self setupTopSelectView];
    [self setupTableView];
    [self setupDataLoadingView];
    [self requestDataWithHUD:nil];
}
#pragma mark 设置顶部选择view
- (void)setupTopSelectView{    
    UIView * topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 44)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    
    _selectButton= [UIButton buttonWithType:UIButtonTypeCustom];
    _selectButton.frame = CGRectMake(((Screen_Width - kSelectButtonWidth)/2), 0,kSelectButtonWidth, 44);
    [_selectButton setTitle:@"体系类别" forState:UIControlStateNormal];
    _selectButton.titleLabel.font = kFontSize30;
    _selectButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [_selectButton setTitleColor:KColorBlackTitle forState:UIControlStateNormal];
    [_selectButton setImage:[UIImage imageNamed:@"home_search_down"] forState:UIControlStateNormal];
    [_selectButton layoutFixationWidthButtonWithEdgeInsetsStyle:YFButtonInsetsStyleRight imageTitleSpace:1 buttonWidth:kSelectButtonWidth];
    
    [_selectButton addTarget:self action:@selector(selectButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:_selectButton];
}
- (void)selectButtonClick{
    if (NO == _showSelectView) {
        //显示选择类别视图
        if (_manageTypeSelectView == nil) {
            _manageTypeSelectView = [[DDManageTypeSelectView alloc] init];
        }
        _manageTypeSelectView.delegate = self;
        _manageTypeSelectView.pointRow = _pointRow;
        [_manageTypeSelectView showInView:self.view];
        
        _showSelectView = YES;
        
        //改变选择按钮标题
         [_selectButton setImage:[UIImage imageNamed:@"home_search_up"] forState:UIControlStateNormal];
         [_selectButton layoutFixationWidthButtonWithEdgeInsetsStyle:YFButtonInsetsStyleRight imageTitleSpace:1 buttonWidth:kSelectButtonWidth];
      
    }else{
        //隐藏选择类别视图
        [_manageTypeSelectView hide];
        
         _showSelectView = NO;
        
         //改变选择按钮标题
        [_selectButton setImage:[UIImage imageNamed:@"home_search_down"] forState:UIControlStateNormal];
         [_selectButton layoutFixationWidthButtonWithEdgeInsetsStyle:YFButtonInsetsStyleRight imageTitleSpace:1 buttonWidth:kSelectButtonWidth];
    }
}

#pragma mark 选择类别view代理 DDManageTypeSelectViewDelegate
//选择类别view将要消失
- (void)manageTypeSelectViewWillDisappear:(DDManageTypeSelectView*)manageTypeSelectView{
    _showSelectView = NO;
  //处理下按钮箭头
  [_selectButton setImage:[UIImage imageNamed:@"home_search_down"] forState:UIControlStateNormal];
     [_selectButton layoutFixationWidthButtonWithEdgeInsetsStyle:YFButtonInsetsStyleRight imageTitleSpace:1 buttonWidth:kSelectButtonWidth];

}
//选择了哪个row
- (void)manageTypeSelectViewSelected:(DDManageTypeSelectView*)manageTypeSelectView pointRow:(NSUInteger)pointRow{
    _pointRow = pointRow;
    
     NSArray * titles = [[NSArray alloc] initWithObjects:@"全部",@"建筑施工行业质量管理体系认证(GB/T50430)",@"质量管理体系认证(ISO90001)",@"环境管理体系认证(ISO14001)",@"职业健康安全管理体系认证(OHSAS18001)", nil];
    NSString *titleStr = titles[pointRow];
    if (pointRow == 0) {
        titleStr = @"体系类别";
    }
    [_selectButton setTitle:titleStr forState:UIControlStateNormal];
    [_selectButton layoutFixationWidthButtonWithEdgeInsetsStyle:YFButtonInsetsStyleRight imageTitleSpace:1 buttonWidth:kSelectButtonWidth];
    
    //请求数据
    MBProgressHUD * hud = [DDUtils showHUDCustom:@""];
    [self requestDataWithHUD:hud];
}
#pragma mark 设置tableView
-(void)setupTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,44, Screen_Width, Screen_Height-KNavigationBarHeight-44) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.separatorColor = KColorTableSeparator;
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width,KTableViewFooterViewHeight)];
    [self.view addSubview:_tableView];
    
    __weak __typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestDataWithHUD:nil];
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
        [weakSelf requestDataWithHUD:nil];
    };
    [_loadingView showLoadingView];
}
#pragma mark 请求数据
- (void)requestDataWithHUD:(MBProgressHUD*)hud{
    _current = 1;
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:_enterpriseId forKey:@"enterpriseId"];
    [params setValue:_toAction forKey:@"toAction"];
    NSString * type = @"";
    if (_pointRow == 0) {
        
    }else if(_pointRow == 1){
        type = @"310001";
    }else if (_pointRow == 2){
        type = @"310002";
    }else if (_pointRow == 3){
        type = @"310003";
    }else{
        type = @"310004";
    }
    [params setValue:type forKey:@"type"];
    [params setValue:[NSString stringWithFormat:@"%ld",_current] forKey:@"current"];
    [params setValue:@"10" forKey:@"size"];
    
//    MBProgressHUD * hud = [DDUtils showHUDCustom:@""];
    [[DDHttpManager sharedInstance] sendGetRequest:KHttpRequest_scenterpriseinfoManageList params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            [_loadingView hiddenLoadingView];
            [_dataArray removeAllObjects];
            [hud hide:YES];
            
            if ([response.data isKindOfClass:[NSDictionary class]]) {
                NSDictionary * data = (NSDictionary*)response.data;
                NSArray * list = data[KList];
                NSMutableArray * tempArray = [DDManageListModel arrayOfModelsFromDictionaries:list error:nil];
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
                    [_noResultView showWithTitle:@"暂无管理体系" subTitle:nil image:@"noResult_content"];
                }else{
                    [_noResultView hide];
                }
            }
        } else {
            [_loadingView failureLoadingView];
            hud.labelText = response.message;
            [hud hide:YES afterDelay:KHudShowTimeSecound];
            
        }
        [_tableView.mj_header endRefreshing];
        [_tableView reloadData];
    } failure:^(NSURLSessionDataTask *operation, id responseObject) {
         [_tableView.mj_header endRefreshing];
        hud.labelText = kRequestFailed;
        [hud hide:YES afterDelay:KHudShowTimeSecound];;
        [_loadingView failureLoadingView];
    }];
}
- (void)addData{
    _current ++;
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:_enterpriseId forKey:@"enterpriseId"];
    [params setValue:_toAction forKey:@"toAction"];
    NSString * type = @"";
    if (_pointRow == 0) {
    }else if(_pointRow == 1){
        type = @"310000";
    }else if (_pointRow == 2){
        type = @"310001";
    }else if (_pointRow == 3){
        type = @"310002";
    }else{
        type = @"310003";
    }
    [params setValue:type forKey:@"type"];
    [params setValue:[NSString stringWithFormat:@"%ld",_current] forKey:@"current"];
    [params setValue:@"10" forKey:@"size"];
    
    [[DDHttpManager sharedInstance] sendGetRequest:KHttpRequest_scenterpriseinfoManageList params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            
            if ([response.data isKindOfClass:[NSDictionary class]]) {
                NSDictionary * data = (NSDictionary*)response.data;
                NSArray * list = data[KList];
                NSMutableArray * tempArray = [DDManageListModel arrayOfModelsFromDictionaries:list error:nil];
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
    static NSString * cellID = @"DDManageListCell";
    DDManageListCell * cell = (DDManageListCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:cellID owner:self options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    DDManageListModel* model = _dataArray[indexPath.section];
    [cell loadWithModel:model];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellID = @"DDManageListCell";
    DDManageListCell * cell = (DDManageListCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:cellID owner:self options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    DDManageListModel* model = _dataArray[indexPath.section];
    [cell loadWithModel:model];
    return [cell height];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DDManageDetailVC * detail = [[DDManageDetailVC alloc] init];
    DDManageListModel* model = _dataArray[indexPath.section];
    detail.urlid = model.urlId;
    [self.navigationController pushViewController:detail animated:YES];
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
