//
//  DDBrandDetailVC.m
//  GongChengDD
//
//  Created by csq on 2018/9/21.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDBrandDetailVC.h"
#import "DDBrandDetailModel.h"
//#import "MJRefresh.h"
#import "DataLoadingView.h"
#import "DDBrandDetailHeaderCell.h"
#import "UIImageView+WebCache.h"
#import "DDBrandDetailNameCell.h"
#import "DDBrandDetailTwoTitleCell.h"
#import "DDBrandDetailFlowCell.h"
#import "DDBrandDetailSeversCell.h"
#import "DDCompanyDetailVC.h"
#import "DDServiceWebViewVC.h"
@interface DDBrandDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic,strong)DataLoadingView * loadingView;
@property (nonatomic,strong)DDBrandDetailModel * model;
@end

@implementation DDBrandDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kColorBackGroundColor;
    self.navigationItem.title = @"商标详情";
    self.navigationItem.leftBarButtonItem = [DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
    self.navigationItem.rightBarButtonItem=[DDUtils rightbuttonItemWithTitle:@"商标注册" target:self action:@selector(brandClick)];
    [self setupTableView];
    [self setupDataLoadingView];
    [self requestData];
}
-(void)brandClick{
    DDServiceWebViewVC *checkVC = [DDServiceWebViewVC new];
    checkVC.hostUrl = @"http://gcdd.koncendy.com/apphs/enterprise_service/pages/handle_list.html?groupId=10&typeId=48&_t=1545135570014";
    [self.navigationController pushViewController:checkVC animated:YES];
}
#pragma mark 设置tableView
- (void)setupTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,0, Screen_Width, Screen_Height-KNavigationBarHeight) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.separatorColor = KColorTableSeparator;
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width,KTableViewFooterViewHeight)];
    [self.view addSubview:_tableView];
    
//    __weak __typeof(self) weakSelf = self;
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [weakSelf requestData];
//    }];
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
#pragma mark 请求数据
- (void)requestData{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [params setValue:_urlid forKey:@"id"];
    
    [[DDHttpManager sharedInstance] sendGetRequest:KHttpRequest_branBrandInfo params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            [_loadingView hiddenLoadingView];
            
            if ([response.data isKindOfClass:[NSDictionary class]]) {
                _model = [[DDBrandDetailModel alloc] initWithDictionary:response.data error:nil];
            }
            
        }else{
            [_loadingView failureLoadingView];
            [DDUtils showToastWithMessage:response.message];
        }
        [_tableView reloadData];
    } failure:^(NSURLSessionDataTask *operation, id responseObject) {
        [_loadingView failureLoadingView];
        [DDUtils showToastWithMessage:kRequestFailed];
    }];
}
#pragma mark tableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }
    if (section == 1) {
        return _model.flows.count;
    }
    if (section == 2) {
        return _model.services.count;
    }
    if (section == 3) {
        return 4;
    }
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        static NSString * headerCellID = @"DDBrandDetailHeaderCell";
        DDBrandDetailHeaderCell * headerCell = (DDBrandDetailHeaderCell*)[tableView dequeueReusableCellWithIdentifier:headerCellID];
        if (headerCell == nil) {
            headerCell = [[[NSBundle mainBundle] loadNibNamed:headerCellID owner:self options:nil] firstObject];
        }
        headerCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [headerCell loadWithModel:_model];
        return headerCell;
    }
    
    static NSString * nameCellID = @"DDBrandDetailNameCell";
    DDBrandDetailNameCell * nameCell = (DDBrandDetailNameCell*)[tableView dequeueReusableCellWithIdentifier:nameCellID];
    if (nameCell == nil) {
        nameCell = [[[NSBundle mainBundle] loadNibNamed:nameCellID owner:self options:nil] firstObject];
    }
    nameCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0 && indexPath.row == 1) {
        [nameCell loadWithTitle:@"商标名称" content:_model.brandName];
        return nameCell;
    }
    if (indexPath.section == 0 && indexPath.row == 2) {
        [nameCell loadWithTitle:@"商标类型" content:_model.brandType];
        return nameCell;
    }
    if (indexPath.section == 0 && indexPath.row == 3) {
        [nameCell loadWithTitle:@"注册编号" content:_model.registerId];
        return nameCell;
    }
    if (indexPath.section == 0 && indexPath.row == 4) {
        [nameCell loadWithTitle:@"申请时间" content:[DDUtils getDateLineByStandardTime:_model.applicationDate]];
        return nameCell;
    }
    if (indexPath.section == 0 && indexPath.row == 5) {
        [nameCell loadWithTitle:@"状态" content:_model.brandStatus];
        return nameCell;
    }
    if (indexPath.section == 0 && indexPath.row == 6) {
        NSString * starTime = [DDUtils getDateDiagonalLineByStandardTime:_model.startUseTime];
        NSString * endTime = [DDUtils getDateDiagonalLineByStandardTime:_model.endUseTime];
        if (YES == [DDUtils isEmptyString:starTime]) {
            starTime = @" ";
        }
        if (YES == [DDUtils isEmptyString:endTime]) {
            endTime = @" ";
        }
        [nameCell loadWithTitle:@"使用期限" content:[NSString stringWithFormat:@"%@-%@",starTime,endTime]];
        return nameCell;
    }
    
    static NSString * twoTitleCellID = @"DDBrandDetailTwoTitleCell";
    DDBrandDetailTwoTitleCell * twoTitleCell = (DDBrandDetailTwoTitleCell*)[tableView dequeueReusableCellWithIdentifier:twoTitleCellID];
    if (twoTitleCell == nil) {
        twoTitleCell = [[[NSBundle mainBundle] loadNibNamed:twoTitleCellID owner:self options:nil] firstObject];
    }
    twoTitleCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    if (indexPath.section == 0 && indexPath.row == 7) {
        [twoTitleCell loadWithTitle:@"申请人" content:_model.enterpriseName];
        twoTitleCell.contentLab.textColor = kColorBlue;
        twoTitleCell.arrow.hidden = NO;
        return twoTitleCell;
    }
    if (indexPath.section == 0 && indexPath.row == 8) {
        [twoTitleCell loadWithTitle:@"申请地址" content:_model.address];
        twoTitleCell.contentLab.textColor = KColorBlackTitle;
        twoTitleCell.arrow.hidden = YES;
        return twoTitleCell;
    }
    if (indexPath.section == 0 && indexPath.row == 9) {
        [twoTitleCell loadWithTitle:@"代理机构" content:_model.proxyOrg];
        twoTitleCell.contentLab.textColor = KColorBlackTitle;
        twoTitleCell.arrow.hidden = YES;
        return twoTitleCell;
    }
    

    
    if (indexPath.section == 1) {
        static NSString * flowCellID  = @"DDBrandDetailFlowCell";
        DDBrandDetailFlowCell * flowCell = (DDBrandDetailFlowCell*)[tableView dequeueReusableCellWithIdentifier:flowCellID];
        if (flowCell == nil) {
            flowCell = [[[NSBundle mainBundle] loadNibNamed:flowCellID owner:self options:nil] firstObject];
        }
        flowCell.selectionStyle = UITableViewCellSelectionStyleNone;
        DDBrandDetailFlowsModel * flowsModel = _model.flows[indexPath.row];
        [flowCell loadWithModel:flowsModel indexPath:indexPath];
        return flowCell;
    }
    
    if (indexPath.section == 2) {
        static NSString *  seversCellID = @"DDBrandDetailSeversCell";
        DDBrandDetailSeversCell * seversCell = (DDBrandDetailSeversCell*)[tableView dequeueReusableCellWithIdentifier:seversCellID];
        if (seversCell == nil) {
            seversCell = [[[NSBundle mainBundle] loadNibNamed:seversCellID owner:self options:nil] firstObject];
        }
        seversCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [seversCell loadWithTitle:_model.services[indexPath.row]];
        return seversCell;
        
    }
    
    if (indexPath.section == 3 && indexPath.row == 0) {
        [nameCell loadWithTitle:@"初审公告号" content:_model.bulletinNumber];
        return nameCell;
    }
    if (indexPath.section == 3 && indexPath.row == 1) {
        [nameCell loadWithTitle:@"初审公告日期" content:[DDUtils getDateLineByStandardTime:_model.bulletinTime]];
        return nameCell;
    }
    if (indexPath.section == 3 && indexPath.row == 2) {
        [nameCell loadWithTitle:@"注册公告号" content:_model.registerNumber];
        return nameCell;
    }
    if (indexPath.section == 3 && indexPath.row == 3) {
        [nameCell loadWithTitle:@"注册公告日期" content:[DDUtils getDateLineByStandardTime:_model.registerTime]];
        return nameCell;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0  && indexPath.row == 0) {
        return [DDBrandDetailHeaderCell height];
    }
    if (indexPath.section == 0 && indexPath.row <=6) {
        return [DDBrandDetailNameCell height];
    }
    
    static NSString * twoTitleCellID = @"DDBrandDetailTwoTitleCell";
    DDBrandDetailTwoTitleCell * twoTitleCell = (DDBrandDetailTwoTitleCell*)[tableView dequeueReusableCellWithIdentifier:twoTitleCellID];
    if (twoTitleCell == nil) {
        twoTitleCell = [[[NSBundle mainBundle] loadNibNamed:twoTitleCellID owner:self options:nil] firstObject];
    }
    twoTitleCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0 && indexPath.row == 7) {
        [twoTitleCell loadWithTitle:@"申请人" content:_model.enterpriseName];
        return [twoTitleCell height];
    }
    if (indexPath.section == 0 && indexPath.row == 8) {
        [twoTitleCell loadWithTitle:@"申请地址" content:_model.address];
        return [twoTitleCell height];
    }
    if (indexPath.section == 0 && indexPath.row == 9) {
        [twoTitleCell loadWithTitle:@"代理机构" content:_model.proxyOrg];
         return [twoTitleCell height];
    }
    
    if (indexPath.section == 1) {
        return [DDBrandDetailFlowCell height];
    }
    if (indexPath.section == 2) {
       return [DDBrandDetailSeversCell height];
    }
    if (indexPath.section == 3) {
        return [DDBrandDetailNameCell height];
    }
    
    
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 7){
        //申请人,点击,去公司详情
        DDCompanyDetailVC * companyDetail = [[DDCompanyDetailVC alloc] init];
        companyDetail.enterpriseId = _model.enterpriseId;
        [self.navigationController pushViewController:companyDetail animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.01;
    }
    if (section == 1 || section ==2) {
        return (49+15);
    }
    
    return 15;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
 
    
    if (section == 0) {
        return nil;
    }
    if (section == 1 || section ==2) {
        UIView * header = [[UIView alloc] init];
        header.backgroundColor = [UIColor clearColor];
        header.frame = CGRectMake(0, 0, Screen_Width, (49+15));
        
        UIView * whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 15, Screen_Width, 49)];
        whiteView.backgroundColor = [UIColor whiteColor];
        [header addSubview:whiteView];
        
        UILabel * lab = [[UILabel alloc] init];
        lab.frame = CGRectMake(10, 0,(Screen_Width-20), 49);
        lab.textColor = KColorGreySubTitle;
        lab.font = kFontSize30;
        [whiteView addSubview:lab];
        
        UIView * bottomLine = [[UIView alloc] init];
        bottomLine.frame = CGRectMake(0, (49+14.5), Screen_Width, 0.5);
        bottomLine.backgroundColor = KColorTableSeparator;
        [header addSubview:bottomLine];
        
        NSArray * titles = [[NSArray alloc] initWithObjects:@"申请流程",@"商品服务列表", nil];
        lab.text = titles[section-1];
        return header;
    }
    
    UIView * header = [[UIView alloc] init];
    header.backgroundColor = [UIColor clearColor];
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
