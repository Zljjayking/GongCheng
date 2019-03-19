//
//  DDBuilderAddApplyVC.m
//  GongChengDD
//
//  Created by xzx on 2018/7/17.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDBuilderAddApplyVC.h"
#import "DDStudentTrainInfoInputCell.h"//cell
#import "DDMajorsListModel.h"//专业类别model
#import "DDTrainInputPersonalInfoVC.h"//填写个人信息页面
#import "DDTrainInputCompanyNameVC.h"//填写单位名称页面
#import "DDActionSheetView.h"//弹出视图
#import "HcdDateTimePickerView.h"//日期选择View
#import "DDBuilderAddTelInputVC.h"//本人手机号录入页面
#import "DDBuildersPayEnsureVC.h"//确认订单页面
#import "ZHG_ToolBarDatePickerView.h"
@interface DDBuilderAddApplyVC ()<UITableViewDelegate,UITableViewDataSource,DDActionSheetViewDelegate>

{
    NSString *_userId;
    NSString *_tel;
    
    NSString *_hasB;
    
    NSString *_majorName;
    NSString *_majorId;
    
    NSString *_majorType;
    
    NSString *_name;
    
    NSString *_certiNumber;
    
    NSString *_companyName;
    NSString *_companyId;
    
    NSString *_validTime;
    
    NSMutableArray *_dataSource;
    NSMutableArray *_typeArr;
    HcdDateTimePickerView * _dateTimePickerView;
    
    UILabel *_moneyLab;//培训费label
    //UIButton *_submitBtn;//提交报名按钮
    
    NSString *_idCard;
    
    NSString *_price;//培训费 主项
    NSString *_addPrice;//培训费 增项
    NSString *_goodsId;
    NSString *_certiTypeId;
    NSString *_maxTime;
    
}
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) DDActionSheetView *typeSheetView;//报考专业View
@property(nonatomic,strong) DDActionSheetView *majorTypeSheetView;//所报专业类型View
@property(nonatomic,strong) DDActionSheetView *hasBSheetView;//是否持有B类证View
@property(nonatomic,strong) UIButton *submitBtn;//提交报名按钮

@end

@implementation DDBuilderAddApplyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    DDCurrentCompanyModel *currentCompanyModel = [DDUserManager sharedInstance].currentCompanyModel;
    DDScAttestationEntityModel *scAttestationEntityModel = currentCompanyModel.scAttestationEntity;
    _companyName=scAttestationEntityModel.entName;
    _companyId=scAttestationEntityModel.entId;
    
    _dataSource=[[NSMutableArray alloc]init];
    _typeArr=[[NSMutableArray alloc]init];
    self.view.backgroundColor=kColorBackGroundColor;
    self.title=self.agencyName;
    self.navigationItem.leftBarButtonItem=[DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
    [self createBottomView];
    [self createTableView];
    [self requestMajorData];
    [self getMastTime];
}
-(void)getMastTime{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:self.agencyId forKey:@"agencyId"];
    [params setValue:@"1" forKey:@"trainType"];
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_getMastTime params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"***********获取报名证书有效期最大时间***************%@",responseObject);
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            NSDictionary *dict = responseObject[KData];
            _maxTime = [dict[@"registrationTerm"] substringToIndex:10];
        }
        else{
            [DDUtils showToastWithMessage:response.message];
        }
    } failure:^(NSURLSessionDataTask *operation, id responseObject) {
        [DDUtils showToastWithMessage:kRequestFailed];
    }];
}
//返回上一页
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 请求报考专业信息
-(void)requestMajorData{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:_agencyId forKey:@"agencyId"];
    [params setValue:@"1" forKey:@"trainType"];
    
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_getBuilderMajorInfo params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"***********获取二建专业信息***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            NSArray *list=responseObject[KData];
            for (NSDictionary *dic in list) {
                DDMajorsListModel *mode=[[DDMajorsListModel alloc]initWithDictionary:dic error:nil];
                [_dataSource addObject:mode];
                [_typeArr addObject:mode.name];
            }
        }
        else{
            [DDUtils showToastWithMessage:response.message];
        }
        
    } failure:^(NSURLSessionDataTask *operation, id responseObject) {
        [DDUtils showToastWithMessage:kRequestFailed];
    }];
}

//创建底部视图
-(void)createBottomView{
    CGFloat  distanceToTop=Screen_Height-KNavigationBarHeight-KTabbarAndHomeIndicatorHeight;
    
    UIView *bottomBgView=[[UIView alloc]initWithFrame:CGRectMake(0, distanceToTop, Screen_Width, 49)];
    bottomBgView.backgroundColor=kColorWhite;
    [self.view addSubview:bottomBgView];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(12, 0, 75, 49)];
    label.text=@"考试培训费";
    label.textColor=kColorGrey;
    label.font=kFontSize28;
    [bottomBgView addSubview:label];
    
    _moneyLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label.frame)+5, 0, 150, 49)];
    _moneyLab.text=@"";
    _moneyLab.textColor=kColorBlue;
    _moneyLab.font=KFontSize38;
    [bottomBgView addSubview:_moneyLab];
    
    _submitBtn=[[UIButton alloc]initWithFrame:CGRectMake(Screen_Width-130, 0, 130, 49)];
    [_submitBtn setBackgroundColor:kColor50PercentAlphaBlue];
    _submitBtn.userInteractionEnabled=NO;
    //[_submitBtn setBackgroundColor:kColorBlue];
    [_submitBtn addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    [_submitBtn setTitle:@"提交报名" forState:UIControlStateNormal];
    [_submitBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
    _submitBtn.titleLabel.font=kFontSize32;
    [bottomBgView addSubview:_submitBtn];
}

//创建tableView
-(void)createTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-KNavigationBarHeight-KTabbarAndHomeIndicatorHeight) style:UITableViewStyleGrouped];
    
    [self.view addSubview:_tableView];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.showsVerticalScrollIndicator=NO;
}

#pragma mark tableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 9;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellID = @"DDStudentTrainInfoInputCell";
    DDStudentTrainInfoInputCell * cell = (DDStudentTrainInfoInputCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
    }
    
    if (indexPath.section==0) {
        cell.titleLab.text=@"单位名称";
        if ([DDUtils isEmptyString:_companyName]) {
            cell.detailLab.text=@"填写";
        }
        else{
            cell.detailLab.text=_companyName;
        }
    }
    else if(indexPath.section==1){
        cell.titleLab.text=@"姓名";
        if ([DDUtils isEmptyString:_name]) {
            cell.detailLab.text=@"填写";
        }
        else{
            cell.detailLab.text=_name;
        }
    }
    else if(indexPath.section==2){
        cell.titleLab.text=@"身份证号";
        if ([DDUtils isEmptyString:_idCard]) {
            cell.detailLab.text=@"填写";
        }
        else{
            cell.detailLab.text=_idCard;
        }
    }
    else if(indexPath.section==3){
        cell.titleLab.text=@"注册编号";
        if ([DDUtils isEmptyString:_certiNumber]) {
            cell.detailLab.text=@"填写";
        }
        else{
            cell.detailLab.text=_certiNumber;
        }
    }
    else if(indexPath.section==4){
        cell.titleLab.text=@"报考专业";
        if ([DDUtils isEmptyString:_majorName]) {
            cell.detailLab.text=@"选择";
        }
        else{
            cell.detailLab.text=_majorName;
        }
    }else if(indexPath.section==5){
        cell.titleLab.text=@"所报专业类型";
        if ([DDUtils isEmptyString:_majorType]) {
            cell.detailLab.text=@"选择";
        }
        else{
            cell.detailLab.text=_majorType;
        }
    }
    else if(indexPath.section==6){
        cell.titleLab.text=@"是否持有B类证";
        if ([DDUtils isEmptyString:_hasB]) {
            cell.detailLab.text=@"选择";
        }
        else{
            if ([_hasB isEqualToString:@"0"]) {
                cell.detailLab.text=@"否";
            }
            else{
                cell.detailLab.text=@"是";
            }
        }
    }
    else if(indexPath.section==7){
        cell.titleLab.text=@"证书有效期";
        if ([DDUtils isEmptyString:_validTime]) {
            cell.detailLab.text=@"选择";
        }
        else{
            cell.detailLab.text=_validTime;
        }
    }
    else if(indexPath.section==8){
        cell.titleLab.text=@"本人手机号";
        if ([DDUtils isEmptyString:_tel]) {
            cell.detailLab.text=@"填写";
        }
        else{
            cell.detailLab.text=_tel;
        }
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (![DDUtils isEmptyString:_companyName] && ![DDUtils isEmptyString:_name] && ![DDUtils isEmptyString:_certiNumber] && ![DDUtils isEmptyString:_majorId] && ![DDUtils isEmptyString:_hasB] && ![DDUtils isEmptyString:_validTime] && ![DDUtils isEmptyString:_tel] && ![DDUtils isEmptyString:_idCard] && ![DDUtils isEmptyString:_majorType]) {
        [self.submitBtn setBackgroundColor:kColorBlue];
        self.submitBtn.userInteractionEnabled=YES;
    }
    else{
        [self.submitBtn setBackgroundColor:kColor50PercentAlphaBlue];
        self.submitBtn.userInteractionEnabled=NO;
    }
    if (![DDUtils isEmptyString:_majorId] && ![DDUtils isEmptyString:_majorType]) {
        if ([_majorType isEqualToString:@"主项"]) {
            _moneyLab.text=[NSString stringWithFormat:@"¥%@",_price];
        }
        else{
            _moneyLab.text=[NSString stringWithFormat:@"¥%@",_addPrice];

        }
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {//单位名称
        DDTrainInputCompanyNameVC *companyName=[[DDTrainInputCompanyNameVC alloc]init];
        companyName.contentStr=_companyName;
        //companyName.companyId=_companyId;
        companyName.companyBlock = ^(NSString *companyName, NSString *companyId) {
            _companyName=companyName;
            _companyId=companyId;
            [_tableView reloadData];
        };
        [self.navigationController pushViewController:companyName animated:YES];
    }
    else if (indexPath.section==1) {//填写姓名
        DDTrainInputPersonalInfoVC *trainInputPersonalInfo=[[DDTrainInputPersonalInfoVC alloc]init];
        trainInputPersonalInfo.type=@"1";
        trainInputPersonalInfo.contentStr = _name;
        trainInputPersonalInfo.inputInfoBlock = ^(NSString *inputInfo) {
            _name=inputInfo;
            [_tableView reloadData];
        };
        [self.navigationController pushViewController:trainInputPersonalInfo animated:YES];
    }
    else if(indexPath.section==2){//身份证号
        DDTrainInputPersonalInfoVC *trainInputPersonalInfo=[[DDTrainInputPersonalInfoVC alloc]init];
        trainInputPersonalInfo.type=@"2";
        trainInputPersonalInfo.contentStr = _idCard;
        trainInputPersonalInfo.inputInfoBlock = ^(NSString *inputInfo) {
            _idCard=inputInfo;
            [_tableView reloadData];
        };
        [self.navigationController pushViewController:trainInputPersonalInfo animated:YES];
    }
    else if(indexPath.section==3){//证书编号
        DDTrainInputPersonalInfoVC *trainInputPersonalInfo=[[DDTrainInputPersonalInfoVC alloc]init];
        trainInputPersonalInfo.type=@"3";
        trainInputPersonalInfo.contentStr = _certiNumber;
        trainInputPersonalInfo.inputInfoBlock = ^(NSString *inputInfo) {
            _certiNumber=inputInfo;
            [_tableView reloadData];
        };
        [self.navigationController pushViewController:trainInputPersonalInfo animated:YES];
    }
    else if(indexPath.section==8){//填写手机号
        DDBuilderAddTelInputVC *builderAddTelInput=[[DDBuilderAddTelInputVC alloc]init];
        builderAddTelInput.userIdBlock = ^(NSString *userId, NSString *tel) {
            _userId=userId;
            _tel=tel;
            [_tableView reloadData];
        };
        [self.navigationController pushViewController:builderAddTelInput animated:YES];
    }
    else if(indexPath.section==4){//报考专业
        _typeSheetView= [[DDActionSheetView alloc]initWithFrame:self.view.window.frame];
        _typeSheetView.delegate = self;
        [_typeSheetView setTitle:_typeArr cancelTitle:@"取消"];
        [_typeSheetView show];
    }else if(indexPath.section==5){//所报专业类型
        NSArray *dateArr = @[@"主项",@"增项"];
        _majorTypeSheetView= [[DDActionSheetView alloc]initWithFrame:self.view.window.frame];
        _majorTypeSheetView.delegate = self;
        [_majorTypeSheetView setTitle:dateArr cancelTitle:@"取消"];
        [_majorTypeSheetView show];
    }
    else if(indexPath.section==6){//B类证情况
        NSArray *dateArr = @[@"是",@"否"];
        _hasBSheetView= [[DDActionSheetView alloc]initWithFrame:self.view.window.frame];
        _hasBSheetView.delegate = self;
        [_hasBSheetView setTitle:dateArr cancelTitle:@"取消"];
        [_hasBSheetView show];
    }
    else if(indexPath.section==7){//证书有效期
        ZHG_ToolBarDatePickerView *datePickerView = [[ZHG_ToolBarDatePickerView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        datePickerView.datePickerType = ZHG_CustomDatePickerView_Type_YearMonthDay;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        datePickerView.maxDate = [dateFormatter dateFromString:_maxTime];
        kWeakSelf
        datePickerView.DatePickerSelectedBlock = ^(NSString *selectString, NSDate *selectedDate) {
            _validTime = selectString;
            [weakSelf.tableView reloadData];
        };
        [datePickerView show];
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 47;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

#pragma mark DDActionSheetViewDelegate
-(void)actionsheetSelectButton:(DDActionSheetView *)actionSheet buttonIndex:(NSInteger)index{
    if (actionSheet==_typeSheetView) {
        DDMajorsListModel *model=_dataSource[index-1];
        _majorId=model.cert_type_id;
        _majorName=model.name;
        _price=model.price;
        _addPrice=model.price_ext;
        _goodsId=model.agency_major_id;
        _certiTypeId=model.cert_type_id;
        [_tableView reloadData];
    }else if(actionSheet==_majorTypeSheetView){
        if (index==1) {
            _majorType = @"主项";
        }
        else{
            _majorType = @"增项";
        }
        [_tableView reloadData];
    }
    else if(actionSheet==_hasBSheetView){
        if (index==1) {
            _hasB=@"1";
        }
        else{
            _hasB=@"0";
        }
        [_tableView reloadData];
    }
}

#pragma mark 提交报名
-(void)submitClick{
    
    if ([DDUtils isEmptyString:_tel]) {
        [DDUtils showToastWithMessage:@"请输入手机号"];
        return;
    }
    
    if ([DDUtils isEmptyString:_name]) {
        [DDUtils showToastWithMessage:@"请输入姓名"];
        return;
    }
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:_companyId forKey:@"enterpriseId"];
    [params setValue:_companyName forKey:@"enterpriseName"];
    [params setValue:_name forKey:@"name"];
    [params setValue:_certiNumber forKey:@"certNo"];
    [params setValue:_majorId forKey:@"certTypeId"];
    [params setValue:_hasB forKey:@"hasBCertificate"];
    [params setValue:_validTime forKey:@"validityPeriodEnd"];
    [params setValue:_tel forKey:@"tel"];
    [params setValue:_agencyId forKey:@"agencyId"];
    [params setValue:_idCard forKey:@"card"];
    [params setValue:@"1" forKey:@"certType"];
    if([_majorType isEqualToString:@"主项"]){
        [params setValue:@"1" forKey:@"major_type"];
    }else{
        [params setValue:@"2" forKey:@"major_type"];
    }
    
    //[params setValue:@"" forKey:@"fileId"];
    MBProgressHUD *hud = [DDUtils showHUDCustom:@""];
    [[DDHttpManager sharedInstance]sendPostRequest:KHttpRequest_builderAddApply params:params success:^(NSURLSessionDataTask *operation, id responseObject){
        NSLog(@"**********添加报名之提交报名数据,获取certiId***************%@",responseObject);
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            [hud hide:YES];
            DDBuildersPayEnsureVC *builderPayEnsure=[[DDBuildersPayEnsureVC alloc]init];
            builderPayEnsure.userId=_userId;
            builderPayEnsure.goodsId=_goodsId;
            builderPayEnsure.trainId=self.agencyId;
            
            builderPayEnsure.certiTypeId=_certiTypeId;
            builderPayEnsure.certiId=[NSString stringWithFormat:@"%@",responseObject[KData]];
            
            builderPayEnsure.peopleName=_name;
            builderPayEnsure.majorName=_majorName;
            builderPayEnsure.agencyName=self.agencyName;
            builderPayEnsure.companyName = _companyName;
            builderPayEnsure.majorPrice=_price;
            builderPayEnsure.isFromeAddApply = _isFromeAddApply;
            if([_majorType isEqualToString:@"主项"]){
                builderPayEnsure.buildType = @"主项";
            }else{
                builderPayEnsure.buildType = @"增项";
            }
            builderPayEnsure.vcName=@"DDBuilderAgencySelectVC_DDBuilderAddApplyRecordVC";
            
            [self.navigationController pushViewController:builderPayEnsure animated:YES];
            
        }
        else{
             hud.labelText = response.message;
            [hud hide:YES afterDelay:KHudShowTimeSecound];
        }
        
    }  failure:^(NSURLSessionDataTask *operation, id responseObject)  {
        hud.labelText = kRequestFailed;
        [hud hide:YES afterDelay:KHudShowTimeSecound];
    }];
}




@end
