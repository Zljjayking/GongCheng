//
//  DDLiveManagerNewAddApplyVC.m
//  GongChengDD
//
//  Created by xzx on 2018/7/23.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDLiveManagerNewAddApplyVC.h"
#import "DDStudentTrainInfoInputCell.h"//cell
#import "DDMajorsListModel.h"//专业类别model
#import "DDTrainInputPersonalInfoVC.h"//填写个人信息页面
#import "DDTrainInputCompanyNameVC.h"//填写单位名称页面
#import "DDTrainTypeActionView.h"//弹出视图
#import "DDBuilderAddTelInputVC.h"//本人手机号录入页面
#import "DDLiveManagerNewPayEnsureVC.h"//确认订单页面

@interface DDLiveManagerNewAddApplyVC ()<UITableViewDelegate,UITableViewDataSource,DDTrainTypeActionViewDelegate>

{
    NSString *_userId;
    NSString *_tel;
    
    NSString *_majorName;
    NSString *_majorId;
    
    NSString *_name;
    
    NSString *_companyName;
    NSString *_companyId;
    
    NSString *_idCard;
    
    NSMutableArray *_dataSource;
    NSMutableArray *_typeArr;
    NSArray *_projectArr; //科目数组
    
    UILabel *_moneyLab;//培训费label
    //UIButton *_submitBtn;//提交报名按钮
    
    NSString *_price;//培训费
    NSString *_goodsId;
    NSString *_certiTypeId;
}
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) DDTrainTypeActionView *typeSheetView;//报考专业View
@property(nonatomic,strong) UIButton *submitBtn;//提交报名按钮

@end

@implementation DDLiveManagerNewAddApplyVC

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
}

//返回上一页
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 请求报考专业信息
-(void)requestMajorData{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:_agencyId forKey:@"agencyId"];
    [params setValue:_examinType forKey:@"trainType"];
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_getBuilderMajorInfo params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"***********获取专业信息***************%@",responseObject);
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            NSArray *list=responseObject[KData];
            for (NSDictionary *dic in list) {
                DDMajorsListModel *mode=[[DDMajorsListModel alloc]initWithDictionary:dic error:nil];
                [_dataSource addObject:mode];
                if ([DDUtils isEmptyString:mode.name]) {
                    [_typeArr addObject:@""];
                }
                else{
                    [_typeArr addObject:mode.name];
                }
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

   CGFloat distanceToTop=Screen_Height-KNavigationBarHeight-KTabbarAndHomeIndicatorHeight;
    
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
    return 5;
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
        cell.titleLab.text=@"报考类别";
        if ([DDUtils isEmptyString:_majorName]) {
            cell.detailLab.text=@"选择";
        }
        else{
            cell.detailLab.text=_majorName;
        }
    }
    else if(indexPath.section==4){
        cell.titleLab.text=@"本人手机号";
        if ([DDUtils isEmptyString:_tel]) {
            cell.detailLab.text=@"填写";
        }
        else{
            cell.detailLab.text=_tel;
        }
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {//单位名称
        DDTrainInputCompanyNameVC *companyName=[[DDTrainInputCompanyNameVC alloc]init];
        //companyName.companyName=_companyName;
        //companyName.companyId=_companyId;
        companyName.companyBlock = ^(NSString *companyName, NSString *companyId) {
            _companyName=companyName;
            _companyId=companyId;
            [_tableView reloadData];
            
            if (![DDUtils isEmptyString:_companyName] && ![DDUtils isEmptyString:_name] && ![DDUtils isEmptyString:_majorId] && ![DDUtils isEmptyString:_tel] && ![DDUtils isEmptyString:_idCard]) {
                [_submitBtn setBackgroundColor:kColorBlue];
                _submitBtn.userInteractionEnabled=YES;
            }
            else{
                [_submitBtn setBackgroundColor:kColor50PercentAlphaBlue];
                _submitBtn.userInteractionEnabled=NO;
            }
            
        };
        [self.navigationController pushViewController:companyName animated:YES];
    }
    else if (indexPath.section==1) {//填写姓名
        DDTrainInputPersonalInfoVC *trainInputPersonalInfo=[[DDTrainInputPersonalInfoVC alloc]init];
        trainInputPersonalInfo.type=@"1";
        trainInputPersonalInfo.inputInfoBlock = ^(NSString *inputInfo) {
            _name=inputInfo;
            [_tableView reloadData];
            
            if (![DDUtils isEmptyString:_companyName] && ![DDUtils isEmptyString:_name] && ![DDUtils isEmptyString:_majorId] && ![DDUtils isEmptyString:_tel] && ![DDUtils isEmptyString:_idCard]) {
                [_submitBtn setBackgroundColor:kColorBlue];
                _submitBtn.userInteractionEnabled=YES;
            }
            else{
                [_submitBtn setBackgroundColor:kColor50PercentAlphaBlue];
                _submitBtn.userInteractionEnabled=NO;
            }
            
        };
        [self.navigationController pushViewController:trainInputPersonalInfo animated:YES];
    }
    else if (indexPath.section==2) {//身份证号
        DDTrainInputPersonalInfoVC *trainInputPersonalInfo=[[DDTrainInputPersonalInfoVC alloc]init];
        trainInputPersonalInfo.type=@"2";
        trainInputPersonalInfo.inputInfoBlock = ^(NSString *inputInfo) {
            _idCard=inputInfo;
            [_tableView reloadData];
            
            if (![DDUtils isEmptyString:_companyName] && ![DDUtils isEmptyString:_name] && ![DDUtils isEmptyString:_majorId] && ![DDUtils isEmptyString:_tel] && ![DDUtils isEmptyString:_idCard]) {
                [_submitBtn setBackgroundColor:kColorBlue];
                _submitBtn.userInteractionEnabled=YES;
            }
            else{
                [_submitBtn setBackgroundColor:kColor50PercentAlphaBlue];
                _submitBtn.userInteractionEnabled=NO;
            }
            
        };
        [self.navigationController pushViewController:trainInputPersonalInfo animated:YES];
    }
    else if(indexPath.section==4){//填写手机号
        DDBuilderAddTelInputVC *builderAddTelInput=[[DDBuilderAddTelInputVC alloc]init];
        builderAddTelInput.userIdBlock = ^(NSString *userId, NSString *tel) {
            _userId=userId;
            _tel=tel;
            [_tableView reloadData];
            
            if (![DDUtils isEmptyString:_companyName] && ![DDUtils isEmptyString:_name] && ![DDUtils isEmptyString:_majorId] && ![DDUtils isEmptyString:_tel] && ![DDUtils isEmptyString:_idCard])  {
                [_submitBtn setBackgroundColor:kColorBlue];
                _submitBtn.userInteractionEnabled=YES;
            }
            else{
                [_submitBtn setBackgroundColor:kColor50PercentAlphaBlue];
                _submitBtn.userInteractionEnabled=NO;
            }
            
        };
        [self.navigationController pushViewController:builderAddTelInput animated:YES];
    }
    else if(indexPath.section==3){//报考专业
        _typeSheetView= [[DDTrainTypeActionView alloc]initWithFrame:self.view.window.frame];
        _typeSheetView.delegate = self;
        [_typeSheetView setTitle:_typeArr cancelTitle:@"取消"];
        [_typeSheetView show];
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 47;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 3) {
        if(_projectArr.count>0){
            CGFloat height = (_projectArr.count+1)*WidthByiPhone6(45);
            UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, height)];
            footView.backgroundColor = kColorWhite;
        
            UILabel *titleL = [UILabel labelWithFont:kFontSize32 textString:@"报考科目" textColor:KColorBlackTitle textAlignment:NSTextAlignmentLeft numberOfLines:1];
            titleL.frame = CGRectMake(WidthByiPhone6(12), WidthByiPhone6(7), Screen_Width-WidthByiPhone6(20), WidthByiPhone6(33));
            [footView addSubview:titleL];
            
            for (int i=0; i<_projectArr.count; i++) {
                NSDictionary *dict = [_projectArr objectAtIndex:i];
                UILabel *nameL = [UILabel labelWithFont:kFontSize30 textString:dict[@"subject_name"] textColor:KColorGreySubTitle textAlignment:NSTextAlignmentLeft numberOfLines:2];
                nameL.frame = CGRectMake(WidthByiPhone6(12), WidthByiPhone6(33)+WidthByiPhone6(48)*i, Screen_Width-WidthByiPhone6(86), WidthByiPhone6(48));
                [footView addSubview:nameL];
                
                UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                selectBtn.frame = CGRectMake(Screen_Width-WidthByiPhone6(67), WidthByiPhone6(33)+WidthByiPhone6(48)*i, WidthByiPhone6(48), WidthByiPhone6(48));
                [selectBtn setImage:DDIMAGE(@"project_unselect") forState:UIControlStateNormal];
                [selectBtn setImage:DDIMAGE(@"project_selected") forState:UIControlStateSelected];
                selectBtn.tag = 1000+i;
                [selectBtn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
                [footView addSubview:selectBtn];
            }
            return footView;
        }
    }
    return nil;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == 3){
        if (_projectArr.count>0) {
            return (_projectArr.count+1)*WidthByiPhone6(48);
        }
    }
    return CGFLOAT_MIN;
}

-(void)selectAction:(UIButton *)sender{
    sender.selected = !sender.selected;
}

#pragma mark DDActionSheetViewDelegate
-(void)trainActionsheetSelectButton:(DDTrainTypeActionView *)actionSheet buttonIndex:(NSInteger)index{
    if (actionSheet==_typeSheetView) {
        DDMajorsListModel *model=_dataSource[index-1];
        
        _majorId=model.cert_type_id;
        _majorName=model.name;
        
        _price=model.price;
        _goodsId=model.agency_major_id;
        _certiTypeId=model.cert_type_id;
        
        if (![DDUtils isEmptyString:model.price]) {
            _moneyLab.text=[NSString stringWithFormat:@"¥%@",model.price];
        }
        else{
            _moneyLab.text=@"";
        }
        
        if (![DDUtils isEmptyString:_companyName] && ![DDUtils isEmptyString:_name] && ![DDUtils isEmptyString:_majorId] && ![DDUtils isEmptyString:_tel] && ![DDUtils isEmptyString:_idCard])  {
            [_submitBtn setBackgroundColor:kColorBlue];
            _submitBtn.userInteractionEnabled=YES;
        }
        else{
            [_submitBtn setBackgroundColor:kColor50PercentAlphaBlue];
            _submitBtn.userInteractionEnabled=NO;
        }
        _projectArr = model.subjectList;
        
        [_tableView reloadData];
    }
}

#pragma mark 提交报名
-(void)submitClick{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:_companyId forKey:@"enterpriseId"];
    [params setValue:_companyName forKey:@"enterpriseName"];
    [params setValue:_name forKey:@"name"];
    //[params setValue:_certiNumber forKey:@"certNo"];
    [params setValue:_majorId forKey:@"certTypeId"];
    //[params setValue:_hasB forKey:@"hasBCertificate"];
    //[params setValue:_validTime forKey:@"validityPeriodEnd"];
    [params setValue:_tel forKey:@"tel"];
    [params setValue:_agencyId forKey:@"agencyId"];
    [params setValue:_idCard forKey:@"card"];
    [params setValue:@"4" forKey:@"certType"];
    //[params setValue:@"" forKey:@"fileId"];
    
    [[DDHttpManager sharedInstance]sendPostRequest:KHttpRequest_builderAddApply params:params success:^(NSURLSessionDataTask *operation, id responseObject){
        NSLog(@"**********添加报名之提交报名数据,获取certiId***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            
            DDLiveManagerNewPayEnsureVC *builderPayEnsure=[[DDLiveManagerNewPayEnsureVC alloc]init];
            builderPayEnsure.userId=_userId;
            builderPayEnsure.goodsId=_goodsId;
            builderPayEnsure.trainId=self.agencyId;
            
            builderPayEnsure.certiTypeId=_certiTypeId;
            builderPayEnsure.certiId=[NSString stringWithFormat:@"%@",responseObject[KData]];
            
            builderPayEnsure.peopleName=_name;
            builderPayEnsure.majorName=_majorName;
            builderPayEnsure.agencyName=self.agencyName;
            builderPayEnsure.majorPrice=_price;
            [self.navigationController pushViewController:builderPayEnsure animated:YES];
            
        }
        else{
            [DDUtils showToastWithMessage:response.message];
        }
        
    }  failure:^(NSURLSessionDataTask *operation, id responseObject)  {
        [DDUtils showToastWithMessage:kRequestFailed];
    }];
}



@end
