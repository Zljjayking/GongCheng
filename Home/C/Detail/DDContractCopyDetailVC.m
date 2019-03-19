//
//  DDContractCopyDetailVC.m
//  GongChengDD
//
//  Created by xzx on 2018/6/6.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDContractCopyDetailVC.h"
#import "DDLabelUtil.h"
#import "DataLoadingView.h"//加载页面
#import "DDContractCopyDetailModel.h"//model
#import "DDContractCopyInfo1Cell.h"//cell1
#import "DDContractCopyInfo2Cell.h"//cell2

#import "DDCompanyDetailVC.h"//企业详情页面

@interface DDContractCopyDetailVC ()<UITableViewDelegate,UITableViewDataSource>

{
    DDContractCopyDetailModel *_model;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) DataLoadingView *loadingView;

@end

@implementation DDContractCopyDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self editNavItem];
    [self createTableView];
    [self createLoadView];
    [self requestData];
}


//定制导航条
-(void)editNavItem{
    self.view.backgroundColor=kColorBackGroundColor;
    self.navigationItem.leftBarButtonItem=[DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
}

//返回上一页
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 创建加载视图
-(void)createLoadView{
    __weak __typeof(self) weakSelf=self;
    
    _loadingView = [[DataLoadingView alloc] initWithController:self];
    _loadingView.loadingTitle = KLoading;
    _loadingView.failureTitle = KLoadingFailure;
    _loadingView.reloadHandle = ^(void){
        [weakSelf requestData];
    };
    [_loadingView showLoadingView];
}

#pragma mark 请求数据
-(void)requestData{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:self.record_id forKey:@"recordId"];
    
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_contractCopyDetailByID params:params success:^(NSURLSessionDataTask *operation, id responseObject){
        NSLog(@"**********合同备案详情数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            [_loadingView hiddenLoadingView];
            _model=[[DDContractCopyDetailModel alloc]initWithDictionary:responseObject[KData] error:nil];
        }
        else{
            
            [_loadingView failureLoadingView];
        }
        
        [_tableView reloadData];
        
    }  failure:^(NSURLSessionDataTask *operation, id responseObject)  {
        [DDUtils showToastWithMessage:kRequestFailed];
        [_loadingView failureLoadingView];
    }];
}


//创建tableView
-(void)createTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-KNavigationBarHeight) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.backgroundColor=kColorBackGroundColor;
    _tableView.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.estimatedRowHeight = 44;
    _tableView.separatorColor=KColorTableSeparator;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, KTableViewFooterViewHeight)];
    
    [_tableView registerNib:[UINib nibWithNibName:@"DDContractCopyInfo1Cell" bundle:nil] forCellReuseIdentifier:@"DDContractCopyInfo1Cell"];
    [_tableView registerNib:[UINib nibWithNibName:@"DDContractCopyInfo2Cell" bundle:nil] forCellReuseIdentifier:@"DDContractCopyInfo2Cell"];
}

#pragma mark tableView代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 15;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.row==0) {
        DDContractCopyInfo1Cell *cell=[tableView dequeueReusableCellWithIdentifier:@"DDContractCopyInfo1Cell" forIndexPath:indexPath];
        
        if (![DDUtils isEmptyString:_model.project_name]) {
            [DDLabelUtil setLabelSpaceWithLabel:cell.titleLab string:_model.project_name font:KFontSize38Bold];
        }
        else{
            cell.titleLab.text=@"";
        }
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    else{
        DDContractCopyInfo2Cell *cell=[tableView dequeueReusableCellWithIdentifier:@"DDContractCopyInfo2Cell" forIndexPath:indexPath];
        
        cell.attachLab.hidden=YES;
        
        if (indexPath.row==1) {
            cell.leftLab1.text=@"项目编号:";
            if (![DDUtils isEmptyString:_model.project_number]) {
                cell.rightLab1.text=_model.project_number;
            }
            else{
                cell.rightLab1.text=@"-";
            }
            
            cell.leftLab2.text=@"省级项目编号:";
            if (![DDUtils isEmptyString:_model.project_province_number]) {
                cell.rightLab2.text=_model.project_province_number;
            }
            else{
                cell.rightLab2.text=@"-";
            }
        }
        else if(indexPath.row==2){
            cell.leftLab1.text=@"建设单位:";
            if (![DDUtils isEmptyString:_model.builder_enterprise_name]) {
                cell.rightLab1.text=_model.builder_enterprise_name;
            }
            else{
                cell.rightLab1.text=@"-";
            }
            
            cell.leftLab2.text=@"建设单位组织机构代码(统一社会信用代码):";
            if (![DDUtils isEmptyString:_model.builder_enterprise_code]) {
                cell.attachLab.hidden=NO;
                cell.rightLab2.text=@"";
                cell.attachLab.text=_model.builder_enterprise_code;
            }
            else{
                cell.rightLab2.text=@"-";
                cell.attachLab.text=@"";
            }
        }
        else if(indexPath.row==3){
            cell.leftLab1.text=@"项目分类:";
            if (![DDUtils isEmptyString:_model.project_classify]) {
                cell.rightLab1.text=_model.project_classify;
            }
            else{
                cell.rightLab1.text=@"-";
            }
            
            cell.leftLab2.text=@"项目属地:";
            if (![DDUtils isEmptyString:_model.project_region]) {
                cell.rightLab2.text=_model.project_region;
            }
            else{
                cell.rightLab2.text=@"-";
            }
            
        }
        else if(indexPath.row==4){
            cell.leftLab1.text=@"立案文号:";
            if (![DDUtils isEmptyString:_model.item_number]) {
                cell.rightLab1.text=_model.item_number;
            }
            else{
                cell.rightLab1.text=@"-";
            }
            
            cell.leftLab2.text=@"立项级别:";
            if (![DDUtils isEmptyString:_model.item_level]) {
                cell.rightLab2.text=_model.item_level;
            }
            else{
                cell.rightLab2.text=@"-";
            }
        }
        else if(indexPath.row==5){
            cell.leftLab1.text=@"总投资(万元):";
            if (![DDUtils isEmptyString:_model.total_investment] && [_model.total_investment floatValue]>0) {
                cell.rightLab1.text=_model.total_investment;
            }
            else{
                cell.rightLab1.text=@"-";
            }
            
            cell.leftLab2.text=@"总面积(平方米):";
            if (![DDUtils isEmptyString:_model.total_area] && [_model.total_area floatValue]>0) {
                cell.rightLab2.text=_model.total_area;
            }
            else{
                cell.rightLab2.text=@"-";
            }
        }
        else if(indexPath.row==6){
            cell.leftLab1.text=@"建设性质:";
            if (![DDUtils isEmptyString:_model.build_nature]) {
                cell.rightLab1.text=_model.build_nature;
            }
            else{
                cell.rightLab1.text=@"-";
            }
            
            cell.leftLab2.text=@"工程用途:";
            if (![DDUtils isEmptyString:_model.engineering_purpose]) {
                cell.rightLab2.text=_model.engineering_purpose;
            }
            else{
                cell.rightLab2.text=@"-";
            }
        }
        else if(indexPath.row==7){
            cell.leftLab1.text=@"合同备案编号:";
            if (![DDUtils isEmptyString:_model.record_number]) {
                cell.rightLab1.text=_model.record_number;
            }
            else{
                cell.rightLab1.text=@"-";
            }
            
            cell.leftLab2.text=@"省级合同备案编号:";
            if (![DDUtils isEmptyString:_model.record_province_number]) {
                cell.rightLab2.text=_model.record_province_number;
            }
            else{
                cell.rightLab2.text=@"-";
            }
        }
        else if(indexPath.row==8){
            cell.leftLab1.text=@"合同编号:";
            if (![DDUtils isEmptyString:_model.contract_number]) {
                cell.rightLab1.text=_model.contract_number;
            }
            else{
                cell.rightLab1.text=@"-";
            }
            
            cell.leftLab2.text=@"合同分类:";
            if (![DDUtils isEmptyString:_model.contract_classify]) {
                cell.rightLab2.text=_model.contract_classify;
            }
            else{
                cell.rightLab2.text=@"-";
            }
        }
        else if(indexPath.row==9){
            cell.leftLab1.text=@"合同类别:";
            if (![DDUtils isEmptyString:_model.contract_type]) {
                cell.rightLab1.text=_model.contract_type;
            }
            else{
                cell.rightLab1.text=@"-";
            }
            
            cell.leftLab2.text=@"合同金额(万元):";
            if (![DDUtils isEmptyString:_model.contract_amount]&& [_model.contract_amount floatValue]>0) {
                cell.rightLab2.text= [DDContractCopyDetailVC reviseString:_model.contract_amount];
            }
            else{
                cell.rightLab2.text=@"-";
            }
        }
        else if(indexPath.row==10){
            cell.leftLab1.text=@"建设规模:";
            if (![DDUtils isEmptyString:_model.build_scale]) {
                cell.rightLab1.text=_model.build_scale;
            }
            else{
                cell.rightLab1.text=@"-";
            }
            
            cell.leftLab2.text=@"合同签订日期:";
            if (![DDUtils isEmptyString:_model.contract_date]) {
                cell.rightLab2.text=_model.contract_date;
            }
            else{
                cell.rightLab2.text=@"-";
            }
        }
        else if(indexPath.row==11){
            cell.leftLab1.text=@"发包单位名称:";
            if (![DDUtils isEmptyString:_model.out_contracting_company_name]) {
                cell.rightLab1.text=_model.out_contracting_company_name;
            }
            else{
                cell.rightLab1.text=@"-";
            }
            
            cell.leftLab2.text=@"发包单位组织机构代码:";
            if (![DDUtils isEmptyString:_model.out_contracting_company_code]) {
                cell.rightLab2.text=_model.out_contracting_company_code;
            }
            else{
                cell.rightLab2.text=@"-";
            }
        }
        else if(indexPath.row==12){
            cell.leftLab1.text=@"承包单位名称:";
            if (![DDUtils isEmptyString:_model.contractor_company_name]) {
                cell.rightLab1.text=_model.contractor_company_name;
            }
            else{
                cell.rightLab1.text=@"-";
            }
            
            cell.leftLab2.text=@"承包单位组织机构代码:";
            if (![DDUtils isEmptyString:_model.contractor_company_code]) {
                cell.rightLab2.text=_model.contractor_company_code;
            }
            else{
                cell.rightLab2.text=@"-";
            }
        }
        else if(indexPath.row==13){
            cell.leftLab1.text=@"联合体承包单位名称:";
            if (![DDUtils isEmptyString:_model.union_contractor_company_name]) {
                cell.rightLab1.text=_model.union_contractor_company_name;
            }
            else{
                cell.rightLab1.text=@"-";
            }
            
            cell.leftLab2.text=@"联合体承包单位组织机构代码:";
            if (![DDUtils isEmptyString:_model.union_contractor_company_code]) {
                cell.rightLab2.text=_model.union_contractor_company_code;
            }
            else{
                cell.rightLab2.text=@"-";
            }
        }
        else if(indexPath.row==14){
            cell.leftLab1.text=@"记录登记时间:";
            if (![DDUtils isEmptyString:_model.record_date]) {
                cell.rightLab1.text=_model.record_date;
            }
            else{
                cell.rightLab1.text=@"-";
            }
            
            cell.leftLab2.text=@"";
            cell.rightLab2.text=@"";
        }

        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return UITableViewAutomaticDimension;
    }
    else if(indexPath.row==2){
        return 115;
    }
    else if(indexPath.row==14){
        return 55;
    }
    else{
        return 85;
    }
}

//上滑改变标题
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y>50) {
        self.title=_model.project_name;
    }
    else{
        self.title=@"";
    }
}

+(NSString *)reviseString:(NSString *)str
{
    //直接传入精度丢失有问题的Double类型
    double conversionValue = [str doubleValue];
    NSString *doubleString = [NSString stringWithFormat:@"%lf", conversionValue];
    NSDecimalNumber *decNumber = [NSDecimalNumber decimalNumberWithString:doubleString];
    return [decNumber stringValue];
}

@end
