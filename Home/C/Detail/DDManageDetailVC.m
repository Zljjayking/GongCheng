//
//  DDManageDetailVC.m
//  GongChengDD
//
//  Created by csq on 2018/9/19.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDManageDetailVC.h"
#import "DDManageDetailModel.h"
#import "DataLoadingView.h"
#import "DDManageDetailSingleTitleCell.h"//只有1个标题的cell
#import "DDBusinesslicenseTitleCell.h"//1个标题的cell,有内容
#import "DDBusinesslicenseTwoTitleCell.h"//2个标题的cell,有内容
#import "DDLabelUtil.h"
#import "DDDateUtil.h"
#import "DDServiceWebViewVC.h"

@interface DDManageDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)DataLoadingView * loadingView;
@property (nonatomic,strong)DDManageDetailModel * model;
@end

@implementation DDManageDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kColorBackGroundColor;
    self.navigationItem.title = @"管理体系详情";
    self.navigationItem.leftBarButtonItem = [DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
    [self setupTableView];
    [self setupDataLoadingView];
    [self requestData];
}
//-(void)brandClick{
//    DDServiceWebViewVC *checkVC = [DDServiceWebViewVC new];
//    if([_model.type isEqualToString:@"310001"]|| [_model.type isEqualToString:@"310002"]){
//        //质量
//       checkVC.hostUrl = @"http://gcdd.koncendy.com/apphs/enterprise_service/pages/handle_list.html?groupId=10&typeId=49&_t=1545220849913";
//    }else if([_model.type isEqualToString:@"310003"]){
//        //环境
//       checkVC.hostUrl = @"http://gcdd.koncendy.com/apphs/enterprise_service/pages/handle_list.html?groupId=10&typeId=51&_t=1545221059379";
//    }else {
//        //安全
//       checkVC.hostUrl = @"http://gcdd.koncendy.com/apphs/enterprise_service/pages/handle_list.html?groupId=10&typeId=50&_t=1545221024982";
//    }
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
     NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:_urlid forKey:@"id"];
    
    [[DDHttpManager sharedInstance] sendGetRequest:KHttpRequest_scenterpriseinfoManageInfo params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            [_loadingView hiddenLoadingView];
            
            if ([response.data isKindOfClass:[NSDictionary class]]) {
                _model = [[DDManageDetailModel alloc] initWithDictionary:response.data error:nil];
                if([_model.type isEqualToString:@"310001"]|| [_model.type isEqualToString:@"310002"]){
//                    self.navigationItem.rightBarButtonItem=[DDUtils rightbuttonItemWithTitle:@"质量管理体系认证" target:self action:@selector(brandClick)];
                }else if([_model.type isEqualToString:@"310003"]){
//                    self.navigationItem.rightBarButtonItem=[DDUtils rightbuttonItemWithTitle:@"环境管理体系认证" target:self action:@selector(brandClick)];
                }else {
//                    self.navigationItem.rightBarButtonItem=[DDUtils rightbuttonItemWithTitle:@"职业健康安全管理体系认证" target:self action:@selector(brandClick)];
                }
            }
        }else{
            [_loadingView failureLoadingView];
            [DDUtils showToastWithMessage:response.message];
        }
        [_tableView reloadData];
    } failure:^(NSURLSessionDataTask *operation, id responseObject) {
        [DDUtils showToastWithMessage:kRequestFailed];
        [_loadingView failureLoadingView];
    }];
}
#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }
    if (section == 1) {
        return 11;
    }
    if (section == 2) {
        return 8;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   //只有1个标题的cell
    static NSString * singleTitleCellID = @"DDManageDetailSingleTitleCell";
    DDManageDetailSingleTitleCell * singleTitleCell = (DDManageDetailSingleTitleCell*)[tableView dequeueReusableCellWithIdentifier:singleTitleCellID];
    if (singleTitleCell == nil) {
        singleTitleCell = [[[NSBundle mainBundle] loadNibNamed:singleTitleCellID owner:self options:nil] firstObject];
    }
    singleTitleCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //1个标题的cell 有内容
    static NSString * titleCellID = @"DDBusinesslicenseTitleCell";
    DDBusinesslicenseTitleCell * titleCell = (DDBusinesslicenseTitleCell*)[tableView dequeueReusableCellWithIdentifier:titleCellID];
    if (titleCell == nil) {
        titleCell = [[[NSBundle mainBundle]loadNibNamed:titleCellID owner:self options:nil] firstObject];
    }
    titleCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //2个标题的cell 有内容
    static NSString * twoTitleCellID = @"DDBusinesslicenseTwoTitleCell";
    DDBusinesslicenseTwoTitleCell * twoTitleCell = (DDBusinesslicenseTwoTitleCell*)[tableView dequeueReusableCellWithIdentifier:twoTitleCellID];
    if (twoTitleCell == nil) {
        twoTitleCell = [[[NSBundle mainBundle]loadNibNamed:twoTitleCellID owner:self options:nil] firstObject];
    }
    twoTitleCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        titleCell.titleLab.text = @"证书名称";
        if ([DDUtils isEmptyString:_model.authProject]) {
            titleCell.contentLab.text = @"-";
        }else{
            titleCell.contentLab.text = _model.authProject;
        }
        titleCell.topLine.hidden = YES;
        titleCell.bottomLine.hidden = NO;
        return titleCell;
    }
    if (indexPath.section == 0 && indexPath.row == 1) {
        titleCell.titleLab.text = @"获奖组织名称";
        if ([DDUtils isEmptyString:_model.entName]) {
            titleCell.contentLab.text = @"-";
        }else{
            titleCell.contentLab.text = _model.entName;
        }
        titleCell.topLine.hidden = YES;
        titleCell.bottomLine.hidden = NO;
        return titleCell;
    }
    if (indexPath.section == 0 && indexPath.row == 2) {
        titleCell.titleLab.text = @"本证书体系覆盖人数";
        if ([DDUtils isEmptyString:_model.employeeNums]) {
            titleCell.contentLab.text = @"-";
        }else{
            titleCell.contentLab.text = _model.employeeNums;
        }
        titleCell.topLine.hidden = YES;
        titleCell.bottomLine.hidden = NO;
        return titleCell;
    }
    if (indexPath.section == 1 && indexPath.row == 0) {
        [singleTitleCell loadWithName:@"证书信息"];
        return singleTitleCell;
    }
    if (indexPath.section == 1 && indexPath.row == 1) {
        twoTitleCell.leftTitleLab.text = @"证书标编号";
        twoTitleCell.leftContentLab.text = _model.certNum;
        if ([DDUtils isEmptyString:_model.certNum]) {
            twoTitleCell.leftContentLab.text = @"-";
        }else{
            twoTitleCell.leftContentLab.text = _model.certNum;
        }
        twoTitleCell.rightLab.text = @"证书状态";
        if ([DDUtils isEmptyString:_model.certStatus]) {
            twoTitleCell.rightContentLab.text = @"-";
        }else{
            twoTitleCell.rightContentLab.text = _model.certStatus;
        }
        return twoTitleCell;
    }
    if (indexPath.section == 1 && indexPath.row == 2) {
        twoTitleCell.leftTitleLab.text = @"颁证日期";
        if ([DDUtils isEmptyString:_model.postCertDate]) {
            twoTitleCell.leftContentLab.text = @"-";
        }else{
            twoTitleCell.leftContentLab.text = _model.postCertDate;
        }
        twoTitleCell.rightLab.text = @"证书到期日期";
        if ([DDUtils isEmptyString:_model.certEndDate]) {
            twoTitleCell.rightContentLab.text = @"-";
        }else{
            twoTitleCell.rightContentLab.text = _model.certEndDate;
        }
        //如果后台返回的时间,不是标准时间,处理下
        NSString * tempDateString = [NSString stringWithFormat:@"%@",_model.certEndDate];
        if (![DDUtils isEmptyString:tempDateString]){
            NSString *resultStr = [DDUtils newCompareTimeSpaceIn180:tempDateString];
            if ([resultStr isEqualToString:@"2"]) {
                twoTitleCell.rightContentLab.textColor = KColorFindingPeopleBlue;
            }
            else if([resultStr isEqualToString:@"1"]){
                twoTitleCell.rightContentLab.textColor = KColorTextOrange;
            }
            else{
                twoTitleCell.rightContentLab.textColor = kColorRed;
            }
        }
        return twoTitleCell;
    }
    if (indexPath.section == 1 && indexPath.row == 3) {
        twoTitleCell.leftTitleLab.text = @"初次获证日期";
        if ([DDUtils isEmptyString:_model.firstGetCertDate]) {
            twoTitleCell.leftContentLab.text = @"-";
        }else{
            twoTitleCell.leftContentLab.text = _model.firstGetCertDate;
        }
        twoTitleCell.rightLab.text = @"信息上报日期";
        if ([DDUtils isEmptyString:_model.infoPostDate]) {
            twoTitleCell.rightContentLab.text = @"-";
        }else{
            twoTitleCell.rightContentLab.text = _model.infoPostDate;
        }
        return twoTitleCell;
    }
    if (indexPath.section == 1 && indexPath.row == 4) {
        twoTitleCell.leftTitleLab.text = @"监督次数";
        if ([DDUtils isEmptyString:_model.superviseTime]) {
            twoTitleCell.leftContentLab.text = @"-";
        }else{
            twoTitleCell.leftContentLab.text = _model.superviseTime;
        }
        twoTitleCell.rightLab.text = @"再认证次数";
        if ([DDUtils isEmptyString:_model.authAgainTimes]) {
            twoTitleCell.rightContentLab.text = @"-";
        }else{
            twoTitleCell.rightContentLab.text = _model.authAgainTimes;
        }
        return twoTitleCell;
    }
    if (indexPath.section == 1 && indexPath.row == 5) {
        titleCell.titleLab.text = @"认证覆盖的业务范围";
        if ([DDUtils isEmptyString:_model.authRange]) {
            titleCell.contentLab.text = @"-";
        }else{
            titleCell.contentLab.text = _model.authRange;
        }
        titleCell.topLine.hidden = NO;
        titleCell.bottomLine.hidden = YES;
        return titleCell;
    }
    if (indexPath.section == 1 && indexPath.row ==6) {
        titleCell.titleLab.text = @"EC9000证书,建筑施工企业质量管理体系认证对应的QMS覆盖范围";
        titleCell.topLine.hidden = NO;
        titleCell.bottomLine.hidden = YES;
        [titleCell loadWithContent:_model.ec];
        return titleCell;
    }
    if (indexPath.section == 1 && indexPath.row ==7){
        titleCell.titleLab.text = @"是否覆盖多场所";
        if ([DDUtils isEmptyString:_model.haveCoverMoreAddress]) {
            titleCell.contentLab.text = @"-";
        }else{
            titleCell.contentLab.text = _model.haveCoverMoreAddress;
        }
        titleCell.topLine.hidden = NO;
        titleCell.bottomLine.hidden = YES;
        return titleCell;
    }
    if (indexPath.section == 1 && indexPath.row ==8){
        titleCell.titleLab.text = @"认证覆盖的场所名称及地址";
        if ([DDUtils isEmptyString:_model.authCoverAddressName]) {
            titleCell.contentLab.text = @"-";
        }else{
            titleCell.contentLab.text = _model.authCoverAddressName;
        }
        
        titleCell.topLine.hidden = NO;
        titleCell.bottomLine.hidden = YES;
        return titleCell;
    }
    if (indexPath.section == 1 && indexPath.row ==9){
        titleCell.titleLab.text = @"证书使用的认可标识";
        if ([DDUtils isEmptyString:_model.certMark]) {
            titleCell.contentLab.text = @"-";
        }else{
            titleCell.contentLab.text = _model.certMark;
        }
        titleCell.topLine.hidden = NO;
        titleCell.bottomLine.hidden = YES;
        return titleCell;
    }
    if (indexPath.section == 1 && indexPath.row ==10){
        titleCell.titleLab.text = @"换证日期";
        if ([DDUtils isEmptyString:_model.changeCertDate]) {
            titleCell.contentLab.text = @"-";
        }else{
            titleCell.contentLab.text = _model.changeCertDate;
        }
        titleCell.topLine.hidden = NO;
        titleCell.bottomLine.hidden = YES;
        return titleCell;
    }
    if (indexPath.section == 2 && indexPath.row == 0) {
        [singleTitleCell loadWithName:@"发证机构信息"];
        return singleTitleCell;
    }
    if (indexPath.section == 2 && indexPath.row == 1){
        titleCell.titleLab.text = @"机构名称";
        if ([DDUtils isEmptyString:_model.orgName]) {
            titleCell.contentLab.text = @"-";
        }else{
            titleCell.contentLab.text = _model.orgName;
        }
        titleCell.topLine.hidden = YES;
        titleCell.bottomLine.hidden = NO;
        return titleCell;
    }
    if (indexPath.section == 2 && indexPath.row == 2){
        titleCell.titleLab.text = @"机构批准号";
        if ([DDUtils isEmptyString:_model.orgApprove]) {
            titleCell.contentLab.text = @"-";
        }else{
            titleCell.contentLab.text = _model.orgApprove;
        }
        titleCell.topLine.hidden = YES;
        titleCell.bottomLine.hidden = NO;
        return titleCell;
    }
    if (indexPath.section == 2 && indexPath.row == 3){
        titleCell.titleLab.text = @"有效期";
        if ([DDUtils isEmptyString:_model.validDate]) {
            titleCell.contentLab.text = @"-";
        }else{
            titleCell.contentLab.text = _model.validDate;
        }
        titleCell.topLine.hidden = YES;
        titleCell.bottomLine.hidden = NO;
        return titleCell;
    }
    if (indexPath.section == 2 && indexPath.row == 4){
        titleCell.titleLab.text = @"电话";
        if ([DDUtils isEmptyString:_model.phoneNums]) {
            titleCell.contentLab.text = @"-";
        }else{
            titleCell.contentLab.text = _model.phoneNums;
        }
        titleCell.topLine.hidden = YES;
        titleCell.bottomLine.hidden = NO;
        return titleCell;
    }
    if (indexPath.section == 2 && indexPath.row == 5){
        titleCell.titleLab.text = @"地址";
        titleCell.contentLab.text = _model.orgAddress;
        if ([DDUtils isEmptyString:_model.orgAddress]) {
            titleCell.contentLab.text = @"-";
        }else{
            titleCell.contentLab.text = _model.orgAddress;
        }
        titleCell.topLine.hidden = YES;
        titleCell.bottomLine.hidden = NO;
        return titleCell;
    }
    if (indexPath.section == 2 && indexPath.row == 6){
        titleCell.titleLab.text = @"业务范围";
        titleCell.contentLab.text = _model.sphereOfBusiness;
        if (![DDUtils isEmptyString:_model.sphereOfBusiness]) {
            [DDLabelUtil setLabelSpaceWithLabel:titleCell.contentLab string:_model.sphereOfBusiness font:kFontSize32];
        }else{
            titleCell.contentLab.text = @"-";
        }
      
        titleCell.topLine.hidden = YES;
        titleCell.bottomLine.hidden = NO;
        return titleCell;
    }
    if (indexPath.section == 2 && indexPath.row == 7){
        titleCell.titleLab.text = @"机构状态";
        titleCell.contentLab.text = _model.orgStatus;
        if ([DDUtils isEmptyString:_model.orgStatus]) {
            titleCell.contentLab.text = @"-";
        }else{
            titleCell.contentLab.text = _model.orgStatus;
        }
        titleCell.topLine.hidden = YES;
        titleCell.bottomLine.hidden = NO;
        return titleCell;
    }
    
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //只有1个标题的cell
    static NSString * singleTitleCellID = @"DDManageDetailSingleTitleCell";
    DDManageDetailSingleTitleCell * singleTitleCell = (DDManageDetailSingleTitleCell*)[tableView dequeueReusableCellWithIdentifier:singleTitleCellID];
    if (singleTitleCell == nil) {
        singleTitleCell = [[[NSBundle mainBundle] loadNibNamed:singleTitleCellID owner:self options:nil] firstObject];
    }
    singleTitleCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        return [DDBusinesslicenseTitleCell heightWithContent:nil];
    }
    if (indexPath.section == 1 && indexPath.row == 0) {
       [singleTitleCell loadWithName:@"证书信息"];
        return [singleTitleCell height];
    }
    if (indexPath.section == 1 && indexPath.row == 1) {
        return [DDBusinesslicenseTwoTitleCell height];
    }
    if (indexPath.section == 1 && indexPath.row == 2){
        return [DDBusinesslicenseTwoTitleCell height];
    }
    if (indexPath.section == 1 && indexPath.row == 3){
        return [DDBusinesslicenseTwoTitleCell height];
    }
    if (indexPath.section == 1 && indexPath.row == 4) {
       return [DDBusinesslicenseTwoTitleCell height];
    }
    if (indexPath.section == 1 && indexPath.row == 5){
        return [DDBusinesslicenseTitleCell heightWithContent:_model.authRange];
    }
    if (indexPath.section == 1 && indexPath.row ==6){
        //1个标题的cell 有内容
        static NSString * titleCellID = @"DDBusinesslicenseTitleCell";
        DDBusinesslicenseTitleCell * titleCell = (DDBusinesslicenseTitleCell*)[tableView dequeueReusableCellWithIdentifier:titleCellID];
        if (titleCell == nil) {
            titleCell = [[[NSBundle mainBundle]loadNibNamed:titleCellID owner:self options:nil] firstObject];
        }
        titleCell.selectionStyle = UITableViewCellSelectionStyleNone;

        titleCell.titleLab.text = @"EC9000证书,建筑施工企业质量管理体系认证对应的QMS覆盖范围";
        titleCell.topLine.hidden = NO;
        titleCell.bottomLine.hidden = YES;
        [titleCell loadWithContent:_model.ec];
        return [titleCell height];
      
    }
    if (indexPath.section == 1 && indexPath.row ==7){
        
        return [DDBusinesslicenseTitleCell heightWithContent:nil];
    }
    if (indexPath.section == 1 && indexPath.row ==8){
        NSString *content = @"";
        if ([DDUtils isEmptyString:_model.authCoverAddressName]) {
            content = @"-";
        }else{
            content = _model.authCoverAddressName;
        }
        return [DDBusinesslicenseTitleCell heightWithContent:content];
    }
    if (indexPath.section == 1 && indexPath.row ==9){
         return [DDBusinesslicenseTitleCell heightWithContent:nil];
    }
    if (indexPath.section == 1 && indexPath.row ==10){
         return [DDBusinesslicenseTitleCell heightWithContent:nil];
    }
    if (indexPath.section == 2 && indexPath.row == 0){
        [singleTitleCell loadWithName:@"发证机构信息"];
        return [singleTitleCell height];
    }
    if (indexPath.section == 2 && indexPath.row == 1){
        return [DDBusinesslicenseTitleCell heightWithContent:nil];
    }
    if (indexPath.section == 2 && indexPath.row == 2){
        return [DDBusinesslicenseTitleCell heightWithContent:nil];
    }
    if (indexPath.section == 2 && indexPath.row == 3){
        return [DDBusinesslicenseTitleCell heightWithContent:nil];
    }
    if (indexPath.section == 2 && indexPath.row == 4){
        return [DDBusinesslicenseTitleCell heightWithContent:nil];
    }
    if (indexPath.section == 2 && indexPath.row == 5){
         return [DDBusinesslicenseTitleCell heightWithContent:nil];
    }
    if (indexPath.section == 2 && indexPath.row == 6){
//        return [DDBusinesslicenseTitleCell heightWithContent:_model.sphereOfBusiness];
        if (NO == [DDUtils isEmptyString:_model.sphereOfBusiness]) {
         CGFloat  labelHeight =  [DDLabelUtil getSpaceLabelHeightWithString:_model.sphereOfBusiness font:kFontSize32 width:(Screen_Width - 24)];
            return labelHeight+68;
        }else{
            return 88;
        }
        
    }
    if (indexPath.section == 2 && indexPath.row == 7){
        return [DDBusinesslicenseTitleCell heightWithContent:nil];
    }
    
    return 44;
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
