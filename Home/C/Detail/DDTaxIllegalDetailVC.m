//
//  DDTaxIllegalDetailVC.m
//  GongChengDD
//
//  Created by xzx on 2018/10/26.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDTaxIllegalDetailVC.h"
#import "MJRefresh.h"
#import "DataLoadingView.h"
#import "DDTaxIllegalDetailModel.h"//model
#import "DDTaxIllegalDetail1Cell.h"//cell1
#import "DDTaxIllegalDetail2Cell.h"//cell2
#import "DDLoseCreditDetailCell.h"//cell(可以换行)

@interface DDTaxIllegalDetailVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) DataLoadingView *loadingView;
@property (nonatomic,strong) DDTaxIllegalDetailModel *model;

@end

@implementation DDTaxIllegalDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kColorBackGroundColor;
    self.navigationItem.title = @"税收违法详情";
    self.navigationItem.leftBarButtonItem = [DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
    
    [self setupTableView];
    [self setupDataLoadingView];
    [self requestData];
}

#pragma mark 返回上一页
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 设置tableView
- (void)setupTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,0, Screen_Width, Screen_Height-KNavigationBarHeight) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.separatorColor = KColorTableSeparator;
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width,KTableViewFooterViewHeight)];
    _tableView.estimatedRowHeight=44;
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
    [params setValue:self.passValue forKey:@"illegalId"];
    
    [[DDHttpManager sharedInstance] sendGetRequest:KHttpRequest_taxIllegalDetailInfo params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"**********税收违法详情数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            [_loadingView hiddenLoadingView];
            
            if ([response.data isKindOfClass:[NSDictionary class]]) {
                _model = [[DDTaxIllegalDetailModel alloc] initWithDictionary:response.data error:nil];
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
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }
    else if (section == 1) {
        return 10;
    }
    else{
        return 4;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row==1) {
            static NSString * headerCellID = @"DDTaxIllegalDetail2Cell";
            DDTaxIllegalDetail2Cell *cell = (DDTaxIllegalDetail2Cell*)[tableView dequeueReusableCellWithIdentifier:headerCellID];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:headerCellID owner:self options:nil] firstObject];
            }
            
            cell.leftFirstLab.text=@"纳税人识别号";
            if (![DDUtils isEmptyString:_model.taxpayerNum]) {
                cell.leftSecondLab.text=_model.taxpayerNum;
            }
            else{
                cell.leftSecondLab.text=@"-";
            }
            cell.rightFirstLab.text=@"组织机构代码";
            if (![DDUtils isEmptyString:_model.organizationCode]) {
                cell.rightSecondLab.text=_model.organizationCode;
            }
            else{
                cell.rightSecondLab.text=@"-";
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else{
            static NSString * headerCellID = @"DDTaxIllegalDetail1Cell";
            DDTaxIllegalDetail1Cell *cell = (DDTaxIllegalDetail1Cell*)[tableView dequeueReusableCellWithIdentifier:headerCellID];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:headerCellID owner:self options:nil] firstObject];
            }
            
            if (indexPath.row==0) {
                cell.firstLab.text=@"纳税人名称";
                if (![DDUtils isEmptyString:_model.enterpriseName]) {
                    cell.secondLab.text=_model.enterpriseName;
                }
                else{
                    cell.secondLab.text=@"-";
                }
            }
            else{
                cell.firstLab.text=@"注册地址";
                if (![DDUtils isEmptyString:_model.address]) {
                    cell.secondLab.text=_model.address;
                }
                else{
                    cell.secondLab.text=@"-";
                }
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    else if(indexPath.section==1){
        if (indexPath.row==1 || indexPath.row==4 || indexPath.row==8) {
            static NSString * headerCellID = @"DDTaxIllegalDetail2Cell";
            DDTaxIllegalDetail2Cell *cell = (DDTaxIllegalDetail2Cell*)[tableView dequeueReusableCellWithIdentifier:headerCellID];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:headerCellID owner:self options:nil] firstObject];
            }
            
            if (indexPath.row==1) {
                cell.leftFirstLab.text=@"性别";
                if (![DDUtils isEmptyString:_model.legalSex]) {
                    cell.leftSecondLab.text=_model.legalSex;
                }
                else{
                    cell.leftSecondLab.text=@"-";
                }
                cell.rightFirstLab.text=@"证件名称";
                if (![DDUtils isEmptyString:_model.legalIdcardType]) {
                    cell.rightSecondLab.text=_model.legalIdcardType;
                }
                else{
                    cell.rightSecondLab.text=@"-";
                }
            }
            else if(indexPath.row==4){
                cell.leftFirstLab.text=@"性别";
                if (![DDUtils isEmptyString:_model.financeChiefSex]) {
                    cell.leftSecondLab.text=_model.financeChiefSex;
                }
                else{
                    cell.leftSecondLab.text=@"-";
                }
                cell.rightFirstLab.text=@"证件名称";
                if (![DDUtils isEmptyString:_model.financeChiefIdcardType]) {
                    cell.rightSecondLab.text=_model.financeChiefIdcardType;
                }
                else{
                    cell.rightSecondLab.text=@"-";
                }
            }
            else{
                cell.leftFirstLab.text=@"性别";
                if (![DDUtils isEmptyString:_model.agencySex]) {
                    cell.leftSecondLab.text=_model.agencySex;
                }
                else{
                    cell.leftSecondLab.text=@"-";
                }
                cell.rightFirstLab.text=@"证件名称";
                if (![DDUtils isEmptyString:_model.agencyIdcardType]) {
                    cell.rightSecondLab.text=_model.agencyIdcardType;
                }
                else{
                    cell.rightSecondLab.text=@"-";
                }
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else{
            static NSString * headerCellID = @"DDTaxIllegalDetail1Cell";
            DDTaxIllegalDetail1Cell *cell = (DDTaxIllegalDetail1Cell*)[tableView dequeueReusableCellWithIdentifier:headerCellID];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:headerCellID owner:self options:nil] firstObject];
            }
            
            if (indexPath.row==0) {
                cell.firstLab.text=@"法定代表人或者负责人";
                if (![DDUtils isEmptyString:_model.legalName]) {
                    cell.secondLab.text=_model.legalName;
                }
                else{
                    cell.secondLab.text=@"-";
                }
            }
            else if (indexPath.row==2) {
                cell.firstLab.text=@"证件号码";
                if (![DDUtils isEmptyString:_model.legalIdcard]) {
                    cell.secondLab.text=_model.legalIdcard;
                }
                else{
                    cell.secondLab.text=@"-";
                }
            }
            else if (indexPath.row==3) {
                cell.firstLab.text=@"负有直接责任的财务负责人";
                //cell.firstLab.text=@"证件号码";
                if (![DDUtils isEmptyString:_model.financeChiefName]) {
                    cell.secondLab.text=_model.financeChiefName;
                }
                else{
                    cell.secondLab.text=@"-";
                }
            }
            else if (indexPath.row==5) {
                cell.firstLab.text=@"证件号码";
                if (![DDUtils isEmptyString:_model.financeChiefIdcard]) {
                    cell.secondLab.text=_model.financeChiefIdcard;
                }
                else{
                    cell.secondLab.text=@"-";
                }
            }
            else if (indexPath.row==6) {
                cell.firstLab.text=@"负有直接责任的中介机构信息及其从业人员信息";
                if (![DDUtils isEmptyString:_model.agencyInfo]) {
                    cell.secondLab.text=_model.agencyInfo;
                }
                else{
                    cell.secondLab.text=@"-";
                }
            }
            else if (indexPath.row==7) {
                cell.firstLab.text=@"姓名";
                if (![DDUtils isEmptyString:_model.agencyName]) {
                    cell.secondLab.text=_model.agencyName;
                }
                else{
                    cell.secondLab.text=@"-";
                }
            }
            else if (indexPath.row==9) {
                cell.firstLab.text=@"证件号码";
                if (![DDUtils isEmptyString:_model.agencyIdcard]) {
                    cell.secondLab.text=_model.agencyIdcard;
                }
                else{
                    cell.secondLab.text=@"-";
                }
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    else{
        if (indexPath.row==3) {
            static NSString * headerCellID = @"DDLoseCreditDetailCell";
            DDLoseCreditDetailCell *cell = (DDLoseCreditDetailCell*)[tableView dequeueReusableCellWithIdentifier:headerCellID];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:headerCellID owner:self options:nil] firstObject];
            }
            
            cell.titleLab.text=@"主要违法事实、相关法律依据及税务处理处罚情况";
            if (![DDUtils isEmptyString:_model.content]) {
                cell.detailLab.text=_model.content;
            }
            else{
                cell.detailLab.text=@"-";
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else{
            static NSString * headerCellID = @"DDTaxIllegalDetail1Cell";
            DDTaxIllegalDetail1Cell *cell = (DDTaxIllegalDetail1Cell*)[tableView dequeueReusableCellWithIdentifier:headerCellID];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:headerCellID owner:self options:nil] firstObject];
            }
            
            if (indexPath.row==0) {
                cell.firstLab.text=@"发布日期";
                if (![DDUtils isEmptyString:_model.publishTime]) {
                    cell.secondLab.text=[DDUtils getDateLineByStandardTime:_model.publishTime];
                }
                else{
                    cell.secondLab.text=@"-";
                }
            }
            else if (indexPath.row==1) {
                cell.firstLab.text=@"所属税务机关";
                if (![DDUtils isEmptyString:_model.department]) {
                    cell.secondLab.text=_model.department;
                }
                else{
                    cell.secondLab.text=@"-";
                }
            }
            else if (indexPath.row==2) {
                cell.firstLab.text=@"案件性质";
                if (![DDUtils isEmptyString:_model.type]) {
                    cell.secondLab.text=_model.type;
                }
                else{
                    cell.secondLab.text=@"-";
                }
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==2 && indexPath.row==3) {
        return UITableViewAutomaticDimension;
    }
    else{
        return 82;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
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
