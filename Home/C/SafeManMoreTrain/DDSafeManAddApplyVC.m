//
//  DDSafeManAddApplyVC.m
//  GongChengDD
//
//  Created by xzx on 2018/7/18.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDSafeManAddApplyVC.h"
#import "DDStudentTrainInfoInputCell.h"//cell
#import "DDStudentTrainInfoInputImgCell.h"//cell
#import "DDMajorsListModel.h"//专业类别model
#import "DDTrainInputPersonalInfoVC.h"//填写个人信息页面
#import "DDTrainInputCompanyNameVC.h"//填写单位名称页面
#import "DDActionSheetView.h"//弹出视图
#import "HcdDateTimePickerView.h"//日期选择View
#import "ZHG_ToolBarDatePickerView.h"//日期选择View

#import "DDBuilderAddTelInputVC.h"//本人手机号录入页面
#import "DDSafeManPayEnsureVC.h"//确认订单页面

#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "UIImage+extend.h"
#import "ShowFullImageView.h"
#import "BDImagePicker.h"
@interface DDSafeManAddApplyVC ()<UITableViewDelegate,UITableViewDataSource,DDActionSheetViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

{
    NSString *_userId;
    NSString *_tel;
    
    //NSString *_hasB;
    
    NSString *_majorName;
    NSString *_majorId;
    
    NSString *_name;
    
    NSString *_certiNumber; //证书编号
    
    NSString *_companyName;
    NSString *_companyId;
    
    NSString *_validTime;
    
    NSString *_idCard; //身份证号
    
    NSString *_imageId;
    
    NSMutableArray *_dataSource;
    NSMutableArray *_typeArr;
    HcdDateTimePickerView * _dateTimePickerView;
    
    NSMutableArray *_selectedImageArr;
    
    UILabel *_moneyLab;//培训费label
    //UIButton *_submitBtn;//提交报名按钮
    
    NSString *_price;//培训费
    NSString *_goodsId;
    NSString *_certiTypeId;
    
    UIImage *_image;
    
    NSString *_isCheckSuccess;//记录图片比对是否成功
    NSString *_maxTime;
}
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) DDActionSheetView *typeSheetView;//报考专业View
@property(nonatomic,strong) UIButton *submitBtn;//提交报名按钮
@property(nonatomic,strong) UIImageView *resultImgV;
@property(nonatomic,strong) UILabel *resultLabel;
@property(nonatomic,strong) UIButton *expBtn;
@end

@implementation DDSafeManAddApplyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _isCheckSuccess = @"";
    DDCurrentCompanyModel *currentCompanyModel = [DDUserManager sharedInstance].currentCompanyModel;
    DDScAttestationEntityModel *scAttestationEntityModel = currentCompanyModel.scAttestationEntity;
    _companyName=scAttestationEntityModel.entName;
    _companyId=scAttestationEntityModel.entId;
    
    _selectedImageArr=[[NSMutableArray alloc]init];
    _dataSource=[[NSMutableArray alloc]init];
    _typeArr=[[NSMutableArray alloc]init];
    self.view.backgroundColor=kColorBackGroundColor;
    self.title=self.agencyName;
    self.navigationItem.leftBarButtonItem=[DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
    [self createTableView];
    if (!_model) {
        [self createBottomView];
        [self requestMajorData];
        [self getMastTime];
    }else{
        _companyName = _model.enterprise_name;
        _name = _model.name;
        _idCard = _model.id_card;
        _certiNumber = _model.cert_no;
        _majorName = _model.major;
        _validTime = _model.validity_period_end;
        _tel = _model.tel;
        _isCheckSuccess = @"1";
        NSString *urlString = [NSString stringWithFormat:@"%@%@",DD_Http_Image_Server,_model.file_id];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL  URLWithString:urlString]];
        _image= [UIImage imageWithData:data];
        [_selectedImageArr addObject:_image];
    }
}
-(void)getMastTime{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:self.agencyId forKey:@"agencyId"];
    [params setValue:@"3" forKey:@"trainType"];
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
    [params setValue:self.agencyId forKey:@"agencyId"];
    [params setValue:@"3" forKey:@"trainType"];
    
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_getBuilderMajorInfo params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"***********获取安全员专业信息***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            
            NSArray *list=responseObject[KData];
            for (NSDictionary *dic in list) {
                DDMajorsListModel *mode=[[DDMajorsListModel alloc]initWithDictionary:dic error:nil];
                [_dataSource addObject:mode];
                if ([mode.major_id isEqualToString:@"170001"]) {
                    
                    [_typeArr addObject:[NSString stringWithFormat:@"%@（主要负责人）", mode.name]];
                } else if ([mode.major_id isEqualToString:@"170002"]) {
                    [_typeArr addObject:[NSString stringWithFormat:@"%@（项目负责人）", mode.name]];
                } else if ([mode.major_id isEqualToString:@"170003"] || [mode.major_id isEqualToString:@"170004"] || [mode.major_id isEqualToString:@"170005"] || [mode.major_id isEqualToString:@"170006"]) {
                    [_typeArr addObject:[NSString stringWithFormat:@"%@（专职安全员）", mode.name]];
                } else {
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
    return 8;
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
        cell.titleLab.text=@"证书编号";
        if ([DDUtils isEmptyString:_certiNumber]) {
            cell.detailLab.text=@"填写";
        }
        else{
            cell.detailLab.text=_certiNumber;
        }
    }
    else if(indexPath.section==4){
        cell.titleLab.text=@"报考类别";
        if ([DDUtils isEmptyString:_majorName]) {
            cell.detailLab.text=@"选择";
        }
        else{
            cell.detailLab.text=_majorName;
        }
    }
    else if(indexPath.section==5){
        cell.titleLab.text=@"证书有效期";
        if ([DDUtils isEmptyString:_validTime]) {
            cell.detailLab.text=@"选择";
        }
        else{
            cell.detailLab.text=_validTime;
        }
    }
    else if(indexPath.section==6){
        if (_image) {
            static NSString * cellID = @"DDStudentTrainInfoInputImgCell";
            DDStudentTrainInfoInputImgCell * cell = (DDStudentTrainInfoInputImgCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
            }
            
            cell.titleLab.text=@"报名成功的截图";
            cell.detailLab.text=@"已上传";
            [cell.imgBtn setBackgroundImage:_image forState:UIControlStateNormal];
            [cell.imgBtn addTarget:self action:@selector(enlargePictureClick) forControlEvents:UIControlEventTouchUpInside];
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
        else{
            cell.titleLab.text=@"报名成功的截图";
            if ([DDUtils isEmptyString:_imageId]) {
                cell.detailLab.text=@"上传";
            }
            else{
                cell.detailLab.text=@"已上传";
            }
        }
        
//        cell.titleLab.text=@"报名成功截图";
//        if ([DDUtils isEmptyString:_imageId]) {
//            cell.detailLab.text=@"上传";
//        }
//        else{
//            cell.detailLab.text=@"已上传";
//        }
    }
    else if(indexPath.section==7){
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

#pragma mark 点击缩略图看大图
-(void)enlargePictureClick{
    ShowFullImageView *showFullImage=[[ShowFullImageView alloc]initWithLocalImageArray:_selectedImageArr];
    [showFullImage show];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_model) {
        return;
    }
    if (indexPath.section==0) {//单位名称
        DDTrainInputCompanyNameVC *companyName=[[DDTrainInputCompanyNameVC alloc]init];
        companyName.contentStr=_companyName;
        companyName.companyBlock = ^(NSString *companyName, NSString *companyId) {
            _companyName=companyName;
            _companyId=companyId;
            [_tableView reloadData];
            
            if (![DDUtils isEmptyString:_companyName] && ![DDUtils isEmptyString:_name] && ![DDUtils isEmptyString:_certiNumber] && ![DDUtils isEmptyString:_majorId] && ![DDUtils isEmptyString:_idCard] && ![DDUtils isEmptyString:_validTime] && ![DDUtils isEmptyString:_tel]&&[_isCheckSuccess isEqualToString:@"1"]) {
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
        trainInputPersonalInfo.contentStr = _name;
        trainInputPersonalInfo.inputInfoBlock = ^(NSString *inputInfo) {
            _name=inputInfo;
            [_tableView reloadData];
            
            if (![DDUtils isEmptyString:_companyName] && ![DDUtils isEmptyString:_name] && ![DDUtils isEmptyString:_certiNumber] && ![DDUtils isEmptyString:_majorId] && ![DDUtils isEmptyString:_idCard] && ![DDUtils isEmptyString:_validTime] && ![DDUtils isEmptyString:_tel]&&[_isCheckSuccess isEqualToString:@"1"]) {
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
    else if(indexPath.section==2){//身份证号
        DDTrainInputPersonalInfoVC *trainInputPersonalInfo=[[DDTrainInputPersonalInfoVC alloc]init];
        trainInputPersonalInfo.type=@"2";
        trainInputPersonalInfo.contentStr = _idCard;
        trainInputPersonalInfo.inputInfoBlock = ^(NSString *inputInfo) {
            _idCard=inputInfo;
            [_tableView reloadData];
            
            if (![DDUtils isEmptyString:_companyName] && ![DDUtils isEmptyString:_name] && ![DDUtils isEmptyString:_certiNumber] && ![DDUtils isEmptyString:_majorId] && ![DDUtils isEmptyString:_idCard] && ![DDUtils isEmptyString:_validTime] && ![DDUtils isEmptyString:_tel]&&[_isCheckSuccess isEqualToString:@"1"]) {
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
    else if(indexPath.section==3){//证书编号
        DDTrainInputPersonalInfoVC *trainInputPersonalInfo=[[DDTrainInputPersonalInfoVC alloc]init];
        trainInputPersonalInfo.type=@"3";
        trainInputPersonalInfo.contentStr = _certiNumber;
        trainInputPersonalInfo.inputInfoBlock = ^(NSString *inputInfo) {
            _certiNumber=inputInfo;
            [_tableView reloadData];
            
            if (![DDUtils isEmptyString:_companyName] && ![DDUtils isEmptyString:_name] && ![DDUtils isEmptyString:_certiNumber] && ![DDUtils isEmptyString:_majorId] && ![DDUtils isEmptyString:_idCard] && ![DDUtils isEmptyString:_validTime] && ![DDUtils isEmptyString:_tel]&&[_isCheckSuccess isEqualToString:@"1"]) {
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
    else if(indexPath.section==7){//填写手机号
        DDBuilderAddTelInputVC *builderAddTelInput=[[DDBuilderAddTelInputVC alloc]init];
        builderAddTelInput.userIdBlock = ^(NSString *userId, NSString *tel) {
            _userId=userId;
            _tel=tel;
            [_tableView reloadData];
            
            if (![DDUtils isEmptyString:_companyName] && ![DDUtils isEmptyString:_name] && ![DDUtils isEmptyString:_certiNumber] && ![DDUtils isEmptyString:_majorId] && ![DDUtils isEmptyString:_idCard] && ![DDUtils isEmptyString:_validTime] && ![DDUtils isEmptyString:_tel]&&[_isCheckSuccess isEqualToString:@"1"]) {
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
    else if(indexPath.section==4){//报考类别
        _typeSheetView= [[DDActionSheetView alloc]initWithFrame:self.view.window.frame];
        _typeSheetView.delegate = self;
        [_typeSheetView setTitle:_typeArr cancelTitle:@"取消"];
        [_typeSheetView show];
    }
    else if(indexPath.section==6){//报名成功截图
        if ([DDUtils isEmptyString:_idCard] || [DDUtils isEmptyString:_certiNumber]) {
            [DDUtils showToastWithMessage:@"请先填写身份证号和证书编号"];
            return;
        }
        if (@available(iOS 11, *)) {
            UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
        }
        [BDImagePicker showImagePickerFromViewController:self allowsEditing:YES finishAction:^(UIImage *image) {
            if(image){
                [_selectedImageArr removeAllObjects];
                [_selectedImageArr addObject:image];
                [self uploadImage];
                _image=image;
            }
        }];
    }
    else if(indexPath.section==5){//证书有效期
        ZHG_ToolBarDatePickerView *datePickerView = [[ZHG_ToolBarDatePickerView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        datePickerView.datePickerType = ZHG_CustomDatePickerView_Type_YearMonthDay;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        datePickerView.maxDate = [dateFormatter dateFromString:_maxTime];
        kWeakSelf
        datePickerView.DatePickerSelectedBlock = ^(NSString *selectString, NSDate *selectedDate) {
            _validTime = selectString;
            [weakSelf.tableView reloadData];
            if (![DDUtils isEmptyString:_companyName] && ![DDUtils isEmptyString:_name] && ![DDUtils isEmptyString:_certiNumber] && ![DDUtils isEmptyString:_majorId] && ![DDUtils isEmptyString:_idCard] && ![DDUtils isEmptyString:_validTime] && ![DDUtils isEmptyString:_tel]&&[_isCheckSuccess isEqualToString:@"1"]) {
                [weakSelf.submitBtn setBackgroundColor:kColorBlue];
                weakSelf.submitBtn.userInteractionEnabled=YES;
            }
            else{
                [weakSelf.submitBtn setBackgroundColor:kColor50PercentAlphaBlue];
                weakSelf.submitBtn.userInteractionEnabled=NO;
            }
        };
        [datePickerView show];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 47;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==7) {
        UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 40)];
        [bgView addSubview:self.resultImgV];
        [bgView addSubview:self.resultLabel];
        [bgView addSubview:self.expBtn];
        [self.resultImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView).offset(12);
            make.centerY.equalTo(bgView);
            make.width.height.mas_equalTo(15);
        }];
        [self.resultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_resultImgV.mas_right).offset(5);
            make.centerY.equalTo(bgView);
        }];
        [self.expBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(bgView).offset(-12);
            make.height.mas_equalTo(15);
            make.width.mas_equalTo(70);
            make.centerY.equalTo(bgView);
        }];
        if (![DDUtils isEmptyString:_isCheckSuccess]) {
            _resultImgV.hidden = NO;
            if ([_isCheckSuccess isEqualToString:@"0"]) {//表明比对失败
                _resultImgV.image = [UIImage imageNamed:@"shibai"];
                _resultLabel.text=@"未确认成功,请核实信息后修改!";
                _resultLabel.textColor=kColorRed;
            }else if ([_isCheckSuccess isEqualToString:@"1"]){
                //表明比对成功
                _resultImgV.image = [UIImage imageNamed:@"completeOrder_selected"];
                _resultLabel.text=@"确认成功!";
                _resultLabel.textColor=kColorBlue;
            }
        }else{
            _resultImgV.hidden = YES;
            [self.resultLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(bgView).offset(12);
                make.centerY.equalTo(bgView);
            }];
            _resultLabel.text=@"上传报名成功的截图";
            _resultLabel.textColor=KColorBidApprovalingWait;
        }
        return bgView;
    }
    else{
        return nil;
    }
}

#pragma mark 查看示例点击事件
-(void)exampleClick{
    NSMutableArray *imageArr=[[NSMutableArray alloc]init];
    UIImage *img = [UIImage imageNamed:@"sanlei_jixu"];
    [imageArr addObject:img];
    ShowFullImageView *showFullImage=[[ShowFullImageView alloc]initWithLocalImageArray:imageArr];
    [showFullImage show];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==7) {
        return 40;
    }
    else{
        return 15;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

#pragma mark DDActionSheetViewDelegate
-(void)actionsheetSelectButton:(DDActionSheetView *)actionSheet buttonIndex:(NSInteger)index{
    if (actionSheet==_typeSheetView) {
        DDMajorsListModel *model=_dataSource[index-1];
        _majorId=model.cert_type_id;
        _majorName=_typeArr[index - 1];

        _price=model.price;
        _goodsId=model.agency_major_id;
        _certiTypeId=model.cert_type_id;
        
        if (![DDUtils isEmptyString:model.price]) {
            _moneyLab.text=[NSString stringWithFormat:@"¥%ld",(long)[model.price integerValue]];
        }
        else{
            _moneyLab.text=@"";
        }
        
        if (![DDUtils isEmptyString:_companyName] && ![DDUtils isEmptyString:_name] && ![DDUtils isEmptyString:_certiNumber] && ![DDUtils isEmptyString:_majorId] && ![DDUtils isEmptyString:_idCard] && ![DDUtils isEmptyString:_validTime] && ![DDUtils isEmptyString:_tel]&&[_isCheckSuccess isEqualToString:@"1"]) {
            [_submitBtn setBackgroundColor:kColorBlue];
            _submitBtn.userInteractionEnabled=YES;
        }
        else{
            [_submitBtn setBackgroundColor:kColor50PercentAlphaBlue];
            _submitBtn.userInteractionEnabled=NO;
        }
        
        [_tableView reloadData];
    }
}

#pragma mark 提交报名
-(void)submitClick{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:_companyId forKey:@"enterpriseId"];
    [params setValue:_companyName forKey:@"enterpriseName"];
    [params setValue:_name forKey:@"name"];
    [params setValue:_certiNumber forKey:@"certNo"];
    [params setValue:_majorId forKey:@"certTypeId"];
    //[params setValue:_hasB forKey:@"hasBCertificate"];
    [params setValue:_validTime forKey:@"validityPeriodEnd"];
    [params setValue:_tel forKey:@"tel"];
    [params setValue:_agencyId forKey:@"agencyId"];
    [params setValue:_idCard forKey:@"card"];
    [params setValue:_certType forKey:@"certType"];
    [params setValue:_imageId forKey:@"fileId"];
    MBProgressHUD * hud = [DDUtils showHUDCustom:@""];
    [[DDHttpManager sharedInstance]sendPostRequest:KHttpRequest_builderAddApply params:params success:^(NSURLSessionDataTask *operation, id responseObject){
        NSLog(@"**********添加报名之提交报名数据,获取certiId***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            [hud hide:NO];
            DDSafeManPayEnsureVC *safeManPayEnsure=[[DDSafeManPayEnsureVC alloc]init];
            safeManPayEnsure.userId=_userId;
            safeManPayEnsure.goodsId=_goodsId;
            safeManPayEnsure.trainId=self.agencyId;
            
            safeManPayEnsure.certiTypeId=_certiTypeId;
            safeManPayEnsure.certiId=[NSString stringWithFormat:@"%@",responseObject[KData]];
            
            safeManPayEnsure.peopleName=_name;
            safeManPayEnsure.majorName=_majorName;
            safeManPayEnsure.agencyName=self.agencyName;
            safeManPayEnsure.majorPrice=_price;
            safeManPayEnsure.companyName = _companyName;
            safeManPayEnsure.vcName=@"DDSafeManAgencySelectVC_DDSafeManAddApplyRecordVC";
            safeManPayEnsure.certType =_certType;
            if ([_certType isEqualToString:@"3"]) {
                safeManPayEnsure.isFromeAddApply = _isFromeAddApply;
            }
            [self.navigationController pushViewController:safeManPayEnsure animated:YES];
            
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

#pragma mark 拍照
- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS8Later) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:charOpenCarmeraTip delegate:self cancelButtonTitle:KMainOk otherButtonTitles:nil, nil];
        [alert show];
    } else {
        __weak __typeof(self) weakSelf=self;
        
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            return;
        }
        UIImagePickerController* controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypeCamera;
        controller.allowsEditing = YES;
        controller.delegate = self;
        [weakSelf presentViewController:controller animated:YES completion:^{
            
        }];
    }
}

//上传图片
- (void)uploadImage{
    //时间
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *dateStr = [formatter stringFromDate:date];
    MBProgressHUD * hud = [DDUtils showHUDCustom:@""];
    [[DDHttpManager sharedInstance] sendPostRequestWithFile:KHttpRequest_imgUpload params:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (int i = 0; i< _selectedImageArr.count; i++) {
            UIImage *img = _selectedImageArr[i];
            NSData *data = UIImagePNGRepresentation(img);
             NSString * fileNameString = [NSString stringWithFormat:@"%@%d.jpg",dateStr,i];
            [formData appendPartWithFileData:data name:@"file" fileName:fileNameString mimeType:@"jpg"];
            NSLog(@"___fileNameString:%@",fileNameString);
        }
    } success:^(NSURLSessionDataTask *operation, id responseObject) {
        
        NSLog(@"照片上传结果,从中获取id***%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        
        if (response.isSuccess) {
            [hud hide:YES];
            if ([response.data isKindOfClass:[NSArray class]]) {
                _imageId=response.data[0][@"id"];
                [_tableView reloadData];
                //比对图片,获得比对结果
                [self comparePicture];
            }
        }else{
            hud.labelText = response.message;
            [hud hide:YES afterDelay:KHudShowTimeSecound];
        }
        
    } failure:^(NSURLSessionDataTask *operation, id responseObject) {
        hud.labelText = @"上传图片失败";
        [hud hide:YES afterDelay:KHudShowTimeSecound];
    }];
}
//#pragma mark 将照片压缩
//- (NSMutableArray *)compressImages{
//    NSMutableArray * dataArr = [[NSMutableArray alloc] initWithCapacity:3];
//
//        for (UIImage * image in _selectedImageArr) {
//            //压缩
//            NSData *compressData = [UIImage compressDataWithImage:image maxLength:kFileMaxSize];
//            [dataArr addObject:compressData];
//        }
//
//    return dataArr;
//}

#pragma mark 调图片比对的接口
-(void)comparePicture{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:@[_idCard,_certiNumber] forKey:@"data_list"];
    [params setValue:@"2" forKey:@"type"];
    [params setValue:_imageId forKey:@"file_id"];
     MBProgressHUD * hud = [DDUtils showHUDCustom:@""];
    [[DDHttpManager sharedInstance]sendPostRequest:KHttpRequest_comparePictures params:params success:^(NSURLSessionDataTask *operation, id responseObject){
        NSLog(@"**********图片对比，获取对比结果***************%@",responseObject);
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        [hud hide:YES];
        if (response.isSuccess) {
            if ([response.data isEqual:@0]) {
                _isCheckSuccess=@"0";
                [DDUtils showToastWithMessage:@"如填写信息无误,请重新截图,截图内容区域与边角留有足够的距离,提高匹配成功率!"];
            }
            else{//比对成功
                _isCheckSuccess=@"1";
              
            }
            if (![DDUtils isEmptyString:_companyName] && ![DDUtils isEmptyString:_name] && ![DDUtils isEmptyString:_certiNumber] && ![DDUtils isEmptyString:_majorId] && ![DDUtils isEmptyString:_idCard] && ![DDUtils isEmptyString:_validTime] && ![DDUtils isEmptyString:_tel]&&[_isCheckSuccess isEqualToString:@"1"]) {
                [_submitBtn setBackgroundColor:kColorBlue];
                _submitBtn.userInteractionEnabled=YES;
            }
            else{
                [_submitBtn setBackgroundColor:kColor50PercentAlphaBlue];
                _submitBtn.userInteractionEnabled=NO;
            }
             [_tableView reloadData];
        }
        else{
            [DDUtils showToastWithMessage:response.message];
        }
    }  failure:^(NSURLSessionDataTask *operation, id responseObject)  {
        [hud hide:YES];
        [DDUtils showToastWithMessage:kRequestFailed];
    }];
}


#pragma mark -- lazyload
-(UIImageView *)resultImgV{
    if(!_resultImgV){
        _resultImgV = [[UIImageView alloc]init];
    }
    return _resultImgV;
}
-(UILabel *)resultLabel{
    if(!_resultLabel){
        _resultLabel = [[UILabel alloc]init];
        _resultLabel.font=kFontSize28;
    }
    return _resultLabel;
}
-(UIButton *)expBtn{
    if (!_expBtn) {
        _expBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_expBtn setTitle:@"查看示例" forState:UIControlStateNormal];
        [_expBtn setTitleColor:kColorBlue forState:UIControlStateNormal];
        _expBtn.titleLabel.font=kFontSize28;
        [_expBtn addTarget:self action:@selector(exampleClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _expBtn;
}

@end
