//
//  DDEnterpriseCertificateSummaryVC.m
//  GongChengDD
//
//  Created by csq on 2017/12/4.
//  Copyright © 2017年 Koncendy. All rights reserved.
//

#import "DDEnterpriseCertificateSummaryVC.h"
#import "DataLoadingView.h"
#import "DDEnterpriseCertificateSummaryModel.h"
#import "DDECSummaryContentCell.h"
#import "DDBusinesslicenseVC.h"
#import "DDSafePermissionVC.h"
#import "DDECSummaryHeaderView.h"
#import "DDAptitudeCertificateVC.h"
#import "DDAptitudeCerCell.h"

@interface DDEnterpriseCertificateSummaryVC ()<UITableViewDelegate,UITableViewDataSource,DDECSummaryHeaderViewDelagate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong)DataLoadingView * loadingView;
@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic,strong)DDEnterpriseCertificateSummaryModel * model;

@end

@implementation DDEnterpriseCertificateSummaryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArray = [[NSMutableArray alloc] initWithCapacity:3];
//    _dataDic = [[NSMutableDictionary alloc]initWithCapacity:3];
    
    [self setupTableView];
    [self setupDataLoadingView];
    [self requestData];
}
- (void)setupTableView{
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,0, Screen_Width, Screen_Height-KNavigationBarHeight-60) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor=[UIColor clearColor];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.tableView setSeparatorColor:KColorTableSeparator];
    self.tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width,KTableViewFooterViewHeight)];
    [self.view addSubview:self.tableView];
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
    NSMutableDictionary * params = [[NSMutableDictionary alloc]initWithCapacity:3];
    [params setValue:_enterpriseId forKey:@"enterpriseId"];
    
    [[DDHttpManager sharedInstance] sendPostRequest:KHttpRequest_scenterpriseinfoQueryECSummarize params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            [_loadingView hiddenLoadingView];
            
            if ([response.data isKindOfClass:[NSDictionary class]]) {
             _model = [[DDEnterpriseCertificateSummaryModel alloc] initWithDictionary:response.data error:nil];

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
    if (0 == section) {
        if (_model.businessLicense) {
            return 1;
        }else{
            return 0;
        }
    }
   if (1 == section){
       if (_model.QualificationValidity.count > 0) {
           NSArray * arr = _model.QualificationValidity;
           return arr.count;
       }else{
           return 0;
       }
      
   }
 
    
   if (2 == section) {
       if (_model.safetyLicence) {
            return 1;
       }else{
           return 0;
       }
   }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //内容cell
    static  NSString * contentCellID = @"DDECSummaryContentCell";
    DDECSummaryContentCell * contentCell = (DDECSummaryContentCell*)[tableView dequeueReusableCellWithIdentifier:contentCellID];
    if (contentCell == nil) {
        contentCell = [[[NSBundle mainBundle] loadNibNamed:contentCellID owner:self options:nil] firstObject];
    }
    contentCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
  
    if (indexPath.section == 0 && _model.businessLicense) {
        //如果有营业执照,
        [contentCell loadeCellWithBusinessTimeString:_model.inspectionDate];
        contentCell.arrow.hidden = YES;
        return contentCell;
        
    }
    if (indexPath.section == 1 && _model.QualificationValidity.count>0){
        //如果有资质证书
        static NSString * aptitudeCerCellID = @"DDAptitudeCerCell";
        DDAptitudeCerCell * aptitudeCerCell = (DDAptitudeCerCell*)[tableView dequeueReusableCellWithIdentifier:aptitudeCerCellID];
        if (aptitudeCerCell == nil) {
            aptitudeCerCell = [[[NSBundle mainBundle] loadNibNamed:aptitudeCerCellID owner:self options:nil] firstObject];
        }
        aptitudeCerCell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSArray * arr = _model.QualificationValidity;
        QualificationValidityModel * model = arr[indexPath.row];
        [aptitudeCerCell loadCellWithQualificationValidityModel:model];
        return aptitudeCerCell;
    }
    if (indexPath.section == 2 && _model.safetyLicence) {
      //如果有安许证
        DDSafetyLicenceModel * model = _model.safetyLicence;
        [contentCell loadWithSafetyLicenceModel:model];
        contentCell.arrow.hidden = YES;
        return contentCell;
    }


    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && _model.businessLicense) {
     //如果有营业执照,
        return 44;
    }
    if (indexPath.section == 1 && _model.QualificationValidity.count>0){
        //如果有资质证书
        return [DDAptitudeCerCell height];
    }
    if (indexPath.section == 2 && _model.safetyLicence) {
        //如果有安许证
        return 44;
    }
    
    return 0.01;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        //营业执照
        DDBusinesslicenseVC * vc = [[DDBusinesslicenseVC alloc] init];
        vc.enterpriseId = _enterpriseId;
        [self.mainViewContoller.navigationController pushViewController:vc animated:YES];
    }
    
    if (indexPath.section == 1) {
        //资质证书
        DDAptitudeCertificateVC * vc = [[DDAptitudeCertificateVC alloc] init];
        vc.enterpriseId =  _enterpriseId;
        [self.mainViewContoller.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.section == 2) {
        //安许证
        DDSafePermissionVC * vc = [[DDSafePermissionVC alloc] init];
        vc.enterpriseId = _enterpriseId;
        [self.mainViewContoller.navigationController pushViewController:vc animated:YES];
    }

}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    DDECSummaryHeaderView * headerView = [[[NSBundle mainBundle]loadNibNamed:@"DDECSummaryHeaderView" owner:self options:nil] firstObject];
    headerView.delegate = self;

    if (section == 0 && _model.businessLicense) {
        //如果有营业执照,
        NSArray * titles = [[NSArray alloc] initWithObjects:@"工商年报",@"资质证书",@"安全生产许可证", nil];
        [headerView loadWithTitle:titles[section] mark:@"倒计时" section:section];
        return headerView;
    }
    if (section == 1 && _model.QualificationValidity.count>0){
        //如果有资质证书
        NSArray * titles = [[NSArray alloc] initWithObjects:@"工商年报",@"资质证书",@"安全生产许可证", nil];
        [headerView loadWithTitle:titles[section] mark:@"倒计时" section:section];
        return headerView;
    }
    if (section == 2 && _model.safetyLicence) {
        //如果有安许证
        NSArray * titles = [[NSArray alloc] initWithObjects:@"工商年报",@"资质证书",@"安全生产许可证", nil];
        [headerView loadWithTitle:titles[section] mark:@"倒计时" section:section];
        return headerView;
    }
    
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        if (_model.businessLicense) {
            //如果有营业执照,
             return (15+44);
        }else{
            return 0.01;
        }
        
    }
    if (section == 1){
        if (_model.QualificationValidity.count>0) {
            //如果有资质证书
            return (15+44);
        }else{
            return 0.01;
        }
    }
    if (section == 2) {
        if (_model.safetyLicence) {
           //如果有安许证
            return (15+44);
        }else{
            return 0.01;
        }
    }
   
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
#pragma mark DDECSummaryHeaderViewDelagate 区头点击代理
- (void)summaryHeaderViewClick:(DDECSummaryHeaderView*)headview section:(NSInteger)section{
    if (0 == section) {
        //营业执照
        DDBusinesslicenseVC * vc = [[DDBusinesslicenseVC alloc] init];
        vc.enterpriseId = _enterpriseId;
        [self.mainViewContoller.navigationController pushViewController:vc animated:YES];
    }
    if (1 == section) {
        //资质证书
        DDAptitudeCertificateVC * vc = [[DDAptitudeCertificateVC alloc] init];
        vc.enterpriseId =  _enterpriseId;
        [self.mainViewContoller.navigationController pushViewController:vc animated:YES];
    }
    if (2 == section) {
        //安许证
        DDSafePermissionVC * vc = [[DDSafePermissionVC alloc] init];
        vc.enterpriseId = _enterpriseId;
        [self.mainViewContoller.navigationController pushViewController:vc animated:YES];
    }
}

@end
