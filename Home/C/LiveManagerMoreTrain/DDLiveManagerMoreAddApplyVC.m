//
//  DDLiveManagerMoreAddApplyVC.m
//  GongChengDD
//
//  Created by xzx on 2018/7/23.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDLiveManagerMoreAddApplyVC.h"
#import "DDStudentTrainInfoInputCell.h"//cell
#import "DDStudentTrainInfoInputImgCell.h"//cell
#import "DDMajorsListModel.h"//专业类别model
#import "DDTrainInputPersonalInfoVC.h"//填写个人信息页面
#import "DDTrainInputCompanyNameVC.h"//填写单位名称页面
#import "DDActionSheetView.h"//弹出视图
#import "DDTrainTypeActionView.h"//弹出视图
#import "DDBuilderAddTelInputVC.h"//本人手机号录入页面
#import "DDLiveManagerMorePayEnsureVC.h"//确认订单页面
#import "DDProvinceSelectVC.h"//省份选择页面

#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "UIImage+extend.h"
#import "TZImagePickerController.h"
#import "ShowFullImageView.h"

@interface DDLiveManagerMoreAddApplyVC ()<UITableViewDelegate,UITableViewDataSource,DDActionSheetViewDelegate,DDTrainTypeActionViewDelegate,TZImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

{
    NSString *_userId;
    NSString *_tel;
    
    NSString *_idCard;
    
    NSString *_majorName;
    NSString *_majorId;
    
    NSString *_name;
    
    NSString *_certiNumber;
    
    NSString *_companyName;
    NSString *_companyId;
    
    NSString *_provinceId;
    NSString *_provinceName;
    
    NSString *_imageId;
    
    NSMutableArray *_dataSource;
    NSMutableArray *_typeArr;
    
    UILabel *_moneyLab;//培训费label
    NSString *_price;//培训费
    NSString *_goodsId;
    NSString *_certiTypeId;
    
    NSMutableArray *_selectedImageArr;
    
    UIImage *_image;
    
    NSString *_isCheckSuccess;//记录图片比对是否成功
}
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) DDTrainTypeActionView *typeSheetView;//报考专业View
@property(nonatomic,strong) DDActionSheetView *pictureSheetView;//选择获取截图方式View
@property(nonatomic,strong) UIButton *submitBtn;//提交报名按钮

@end

@implementation DDLiveManagerMoreAddApplyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //DDCurrentCompanyModel *currentCompanyModel = [DDUserManager sharedInstance].currentCompanyModel;
    //DDScAttestationEntityModel *scAttestationEntityModel = currentCompanyModel.scAttestationEntity;
    //_companyName=scAttestationEntityModel.entName;
    //_companyId=scAttestationEntityModel.entId;
    _companyName=@"";
    _companyId=@"";
    
    _selectedImageArr=[[NSMutableArray alloc]init];
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
    [params setValue:self.agencyId forKey:@"agencyId"];
    [params setValue:@"5" forKey:@"trainType"];
    
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_getBuilderMajorInfo params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"***********获取现场管理员专业信息***************%@",responseObject);
        
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
        cell.titleLab.text=@"报考类别";
        if ([DDUtils isEmptyString:_majorName]) {
            cell.detailLab.text=@"选择";
        }
        else{
            cell.detailLab.text=_majorName;
        }
    }
    else if(indexPath.section==4){
        cell.titleLab.text=@"证书编号";
        if ([DDUtils isEmptyString:_certiNumber]) {
            cell.detailLab.text=@"填写";
        }
        else{
            cell.detailLab.text=_certiNumber;
        }
    }
    else if(indexPath.section==5){
        cell.titleLab.text=@"发证省份";
        if ([DDUtils isEmptyString:_provinceName]) {
            cell.detailLab.text=@"选择";
        }
        else{
            cell.detailLab.text=_provinceName;
        }
    }
    else if(indexPath.section==6){
        if (_image) {
            static NSString * cellID = @"DDStudentTrainInfoInputImgCell";
            DDStudentTrainInfoInputImgCell * cell = (DDStudentTrainInfoInputImgCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
            }
            
            cell.titleLab.text=@"报名表扫描件";
            cell.detailLab.text=@"已上传";
            [cell.imgBtn setBackgroundImage:_image forState:UIControlStateNormal];
            [cell.imgBtn addTarget:self action:@selector(enlargePictureClick) forControlEvents:UIControlEventTouchUpInside];
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
        else{
            cell.titleLab.text=@"报名表扫描件";
            if ([DDUtils isEmptyString:_imageId]) {
                cell.detailLab.text=@"上传";
            }
            else{
                cell.detailLab.text=@"已上传";
            }
        }
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
    if (indexPath.section==0) {//单位名称
        DDTrainInputCompanyNameVC *companyName=[[DDTrainInputCompanyNameVC alloc]init];
        //companyName.companyName=_companyName;
        //companyName.companyId=_companyId;
        companyName.companyBlock = ^(NSString *companyName, NSString *companyId) {
            _companyName=companyName;
            _companyId=companyId;
            [_tableView reloadData];
            
            if (![DDUtils isEmptyString:_name] && ![DDUtils isEmptyString:_idCard] && ![DDUtils isEmptyString:_majorId] && ![DDUtils isEmptyString:_certiNumber] && ![DDUtils isEmptyString:_provinceId] && ![DDUtils isEmptyString:_tel]) {
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
            
            if (![DDUtils isEmptyString:_name] && ![DDUtils isEmptyString:_idCard] && ![DDUtils isEmptyString:_majorId] && ![DDUtils isEmptyString:_certiNumber] && ![DDUtils isEmptyString:_provinceId] && ![DDUtils isEmptyString:_tel]) {
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
        trainInputPersonalInfo.inputInfoBlock = ^(NSString *inputInfo) {
            _idCard=inputInfo;
            [_tableView reloadData];
            
            if (![DDUtils isEmptyString:_name] && ![DDUtils isEmptyString:_idCard] && ![DDUtils isEmptyString:_majorId] && ![DDUtils isEmptyString:_certiNumber] && ![DDUtils isEmptyString:_provinceId] && ![DDUtils isEmptyString:_tel]) {
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
    else if(indexPath.section==3){//报考类别
        _typeSheetView= [[DDTrainTypeActionView alloc]initWithFrame:self.view.window.frame];
        _typeSheetView.delegate = self;
        [_typeSheetView setTitle:_typeArr cancelTitle:@"取消"];
        [_typeSheetView show];
    }
    else if(indexPath.section==4){//证书编号
        DDTrainInputPersonalInfoVC *trainInputPersonalInfo=[[DDTrainInputPersonalInfoVC alloc]init];
        trainInputPersonalInfo.type=@"3";
        trainInputPersonalInfo.inputInfoBlock = ^(NSString *inputInfo) {
            _certiNumber=inputInfo;
            [_tableView reloadData];
            
            if (![DDUtils isEmptyString:_name] && ![DDUtils isEmptyString:_idCard] && ![DDUtils isEmptyString:_majorId] && ![DDUtils isEmptyString:_certiNumber] && ![DDUtils isEmptyString:_provinceId] && ![DDUtils isEmptyString:_tel]) {
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
    else if(indexPath.section==5){//发证省份
        DDProvinceSelectVC *provinceSelect=[[DDProvinceSelectVC alloc]init];
        provinceSelect.name=_provinceName;
        provinceSelect.provinceSelectBlock = ^(NSString *issuedDeptId, NSString *issuedDeptSource) {
            NSString *regionId;
            if (issuedDeptId) {
                regionId=[NSString stringWithFormat:@"%@",issuedDeptId];
            }
            else{
                regionId=@"";
            }
            _provinceId=regionId;
            _provinceName=issuedDeptSource;
            [self.tableView reloadData];
            
            if (![DDUtils isEmptyString:_name] && ![DDUtils isEmptyString:_idCard] && ![DDUtils isEmptyString:_majorId] && ![DDUtils isEmptyString:_certiNumber] && ![DDUtils isEmptyString:_provinceId] && ![DDUtils isEmptyString:_tel]) {
                [_submitBtn setBackgroundColor:kColorBlue];
                _submitBtn.userInteractionEnabled=YES;
            }
            else{
                [_submitBtn setBackgroundColor:kColor50PercentAlphaBlue];
                _submitBtn.userInteractionEnabled=NO;
            }
        };
        [self.navigationController pushViewController:provinceSelect animated:YES];
    }
    else if(indexPath.section==6){//报名表扫描件
        _pictureSheetView= [[DDActionSheetView alloc]initWithFrame:self.view.window.frame];
        _pictureSheetView.delegate = self;
        [_pictureSheetView setTitle:@[@"拍照",@"从相册选择"] cancelTitle:@"取消"];
        [_pictureSheetView show];
    }
    else if(indexPath.section==7){//填写手机号
        DDBuilderAddTelInputVC *builderAddTelInput=[[DDBuilderAddTelInputVC alloc]init];
        builderAddTelInput.userIdBlock = ^(NSString *userId, NSString *tel) {
            _userId=userId;
            _tel=tel;
            [_tableView reloadData];
            
            if (![DDUtils isEmptyString:_name] && ![DDUtils isEmptyString:_idCard] && ![DDUtils isEmptyString:_majorId] && ![DDUtils isEmptyString:_certiNumber] && ![DDUtils isEmptyString:_provinceId] && ![DDUtils isEmptyString:_tel]) {
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
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 47;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==7) {
        UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 40)];
        
        if ([_isCheckSuccess isEqualToString:@"0"]) {//表明比对失败
            UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(12, 12.5, 150, 15)];
            label1.text=@"图片比对失败";
            label1.textColor=kColorRed;
            label1.font=kFontSize28;
            [bgView addSubview:label1];
        }
        else{//表明比对成功
            UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(12, 12.5, 150, 15)];
            label1.text=@"上传报名成功的截图";
            label1.textColor=kColorBlue;
            label1.font=kFontSize28;
            [bgView addSubview:label1];
        }
        
//        UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(Screen_Width-12-70, 12.5, 70, 15)];
//        label2.text=@"查看示例";
//        label2.textColor=kColorBlue;
//        label2.font=kFontSize28;
//        [bgView addSubview:label2];
        
        UIButton *expBtn=[[UIButton alloc]initWithFrame:CGRectMake(Screen_Width-12-70, 12.5, 70, 15)];
        [expBtn setTitle:@"查看示例" forState:UIControlStateNormal];
        [expBtn setTitleColor:kColorBlue forState:UIControlStateNormal];
        expBtn.titleLabel.font=kFontSize28;
        [expBtn addTarget:self action:@selector(exampleClick) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:expBtn];
        
        return bgView;
    }
    else{
        return nil;
    }
}

#pragma mark 查看示例点击事件
-(void)exampleClick{
    [DDUtils showToastWithMessage:@"查看示例"];
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

#pragma mark DDTrainTypeActionViewDelegate
-(void)trainActionsheetSelectButton:(DDTrainTypeActionView *)actionSheet buttonIndex:(NSInteger)index{
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
    
    if (![DDUtils isEmptyString:_name] && ![DDUtils isEmptyString:_idCard] && ![DDUtils isEmptyString:_majorId] && ![DDUtils isEmptyString:_certiNumber] && ![DDUtils isEmptyString:_provinceId] && ![DDUtils isEmptyString:_tel]) {
        [_submitBtn setBackgroundColor:kColorBlue];
        _submitBtn.userInteractionEnabled=YES;
    }
    else{
        [_submitBtn setBackgroundColor:kColor50PercentAlphaBlue];
        _submitBtn.userInteractionEnabled=NO;
    }
    
    [_tableView reloadData];
}

#pragma mark DDActionSheetViewDelegate
-(void)actionsheetSelectButton:(DDActionSheetView *)actionSheet buttonIndex:(NSInteger)index{
    if (1 == index) {
        [self takePhoto];
        
    }
    else if (2 == index){
        [self showPhotoSelectViewController];
    }
    //[_tableView reloadData];
    
    //        if (![DDUtils isEmptyString:_companyName] && ![DDUtils isEmptyString:_name] && ![DDUtils isEmptyString:_idCard] && ![DDUtils isEmptyString:_majorId] && ![DDUtils isEmptyString:_certiNumber] && ![DDUtils isEmptyString:_provinceId] && ![DDUtils isEmptyString:_tel]) {
    //            [_submitBtn setBackgroundColor:kColorBlue];
    //            _submitBtn.userInteractionEnabled=YES;
    //        }
    //        else{
    //            [_submitBtn setBackgroundColor:kColor50PercentAlphaBlue];
    //            _submitBtn.userInteractionEnabled=NO;
    //        }
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
    //[params setValue:_validTime forKey:@"validityPeriodEnd"];
    [params setValue:_tel forKey:@"tel"];
    [params setValue:_agencyId forKey:@"agencyId"];
    [params setValue:_idCard forKey:@"card"];
    [params setValue:_provinceId forKey:@"certificateArea"];
    [params setValue:@"5" forKey:@"certType"];
    [params setValue:_imageId forKey:@"fileId"];
    
    [[DDHttpManager sharedInstance]sendPostRequest:KHttpRequest_builderAddApply params:params success:^(NSURLSessionDataTask *operation, id responseObject){
        NSLog(@"**********添加报名之提交报名数据,获取certiId***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            
            DDLiveManagerMorePayEnsureVC *liveManagerMorePayEnsure=[[DDLiveManagerMorePayEnsureVC alloc]init];
            liveManagerMorePayEnsure.userId=_userId;
            liveManagerMorePayEnsure.goodsId=_goodsId;
            liveManagerMorePayEnsure.trainId=self.agencyId;
            
            liveManagerMorePayEnsure.certiTypeId=_certiTypeId;
            liveManagerMorePayEnsure.certiId=[NSString stringWithFormat:@"%@",responseObject[KData]];
            
            liveManagerMorePayEnsure.peopleName=_name;
            liveManagerMorePayEnsure.majorName=_majorName;
            liveManagerMorePayEnsure.agencyName=self.agencyName;
            liveManagerMorePayEnsure.majorPrice=_price;
            [self.navigationController pushViewController:liveManagerMorePayEnsure animated:YES];
            
        }
        else{
            [DDUtils showToastWithMessage:response.message];
        }
        
    }  failure:^(NSURLSessionDataTask *operation, id responseObject)  {
        [DDUtils showToastWithMessage:kRequestFailed];
    }];
}

#pragma mark 相机现拍
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
#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImageWriteToSavedPhotosAlbum(image, nil,nil, nil);
    
    [_selectedImageArr addObject:image];
    
    // NSLog(@"拍照---");
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self uploadImage];
    
    _image=_selectedImageArr[0];
    [_tableView reloadData];
}

#pragma mark 从相册选择
- (void)showPhotoSelectViewController{
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    [imagePickerVc.navigationBar setBarTintColor:kColorBlue];
    imagePickerVc.allowPickingVideo = NO;//不能选择视频
    imagePickerVc.allowPickingOriginalPhoto = NO;//原图按钮将隐藏，用户不能选择发送原图
    imagePickerVc.showPhotoCannotSelectLayer = YES; //当照片选择张数达到maxImagesCount时，其它照片会显示浮层
    imagePickerVc.cannotSelectLayerColor = KColor70AlphaWhite;//当照片选择张数达到maxImagesCount时，其它照片的浮层颜色
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark  TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    
    [_selectedImageArr addObjectsFromArray:photos];
    
    [self uploadImage];
    
    _image=_selectedImageArr[0];
    [_tableView reloadData];
}


#pragma mark 上传图片到文件服务器
- (void)uploadImage{
    //时间
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *dateStr = [formatter stringFromDate:date];
    
    MBProgressHUD * hud = [DDUtils showHUDCustom:@""];
    
    //图片压缩下
    NSMutableArray *compressImageArr = [self compressImages];
    
    [[DDHttpManager sharedInstance] sendPostRequestWithFile:KHttpRequest_imgUpload params:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        for (int i = 0; i< compressImageArr.count; i++) {
            NSData * data = compressImageArr[i];
            NSString * fileNameString = [NSString stringWithFormat:@"%@%d.jpg",dateStr,i];
            [formData appendPartWithFileData:data name:@"file" fileName:fileNameString mimeType:@"jpg"];
            NSLog(@"___fileNameString:%@",fileNameString);
        }
        
    } success:^(NSURLSessionDataTask *operation, id responseObject) {
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        
        NSLog(@"照片上传结果,从中获取id***%@",responseObject);
        
        if (response.isSuccess) {
            [hud hide:YES];
            
            if ([response.data isKindOfClass:[NSArray class]]) {
                /*
                 上传图片,成功,返回值
                 {
                 code = 0;
                 data = [
                 {
                 id = "1764494061634560";
                 thumbUrl = "https://gcdd.koncendy.com/flib/fs/img/20180727/e8a7667fe8814342abcff11fb42cf48d_timg.jpg"
                 url = "https://gcdd.koncendy.com/flib/fs/img/20180727/e8a7667fe8814342abcff11fb42cf48d.jpg";
                 }
                 ];
                 extras = [
                 ];
                 msg = "success:1"
                 }
                 */
                
                _imageId=response.data[0][@"id"];
                
                //比对图片,获得比对结果
                [self comparePicture];
            }
            
        }
        else{
            hud.labelText = response.message;
            [hud hide:YES afterDelay:KHudShowTimeSecound];
        }
        
    } failure:^(NSURLSessionDataTask *operation, id responseObject) {
        hud.labelText = @"上传图片失败";
        [hud hide:YES afterDelay:KHudShowTimeSecound];
    }];
}

#pragma mark 将照片压缩
- (NSMutableArray *)compressImages{
    NSMutableArray * dataArr = [[NSMutableArray alloc] initWithCapacity:3];
    
        for (UIImage * image in _selectedImageArr) {
            //压缩
            NSData *compressData = [UIImage compressDataWithImage:image maxLength:kFileMaxSize];
            [dataArr addObject:compressData];
        }
    
    return dataArr;
}

#pragma mark 调图片比对的接口
-(void)comparePicture{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:@[@"卢开山三世",@"123456789"] forKey:@"data_list"];
    [params setValue:@"3" forKey:@"type"];
    [params setValue:_imageId forKey:@"file_id"];
    
    [[DDHttpManager sharedInstance]sendPostRequest:KHttpRequest_comparePictures params:params success:^(NSURLSessionDataTask *operation, id responseObject){
        NSLog(@"**********图片对比，获取对比结果***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            
            if ([response.data isEqual:@0]) {
                _isCheckSuccess=@"0";
                [_tableView reloadData];
                [DDUtils showToastWithMessage:@"如填写信息无误,请重新截图,截图内容区域与边角留有足够的距离,提高匹配成功率!"];
            }
            else{//比对成功
                _isCheckSuccess=@"1";
                [_tableView reloadData];
            }
            
        }
        else{
            [DDUtils showToastWithMessage:response.message];
        }
        
    }  failure:^(NSURLSessionDataTask *operation, id responseObject)  {
        [DDUtils showToastWithMessage:kRequestFailed];
    }];
}





@end
