//
//  DDSafeManAndAgencyVC.m
//  GongChengDD
//
//  Created by xzx on 2018/7/14.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDSafeManAndAgencyVC.h"
#import "DDBuilderMoreTrain2Cell.h"//cell
#import "DDNewPeopleInfoCell.h"
#import "DDSafeManPayEnsureVC.h"//确认订单页面
#import "DDActionSheetView.h"//弹出视图

#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "UIImage+extend.h"
#import "TZImagePickerController.h"
#import "UIView+WhenTappedBlocks.h"
#import "DDNavigationManager.h"
#import "BDImagePicker.h"

@interface DDSafeManAndAgencyVC ()<UITableViewDelegate,UITableViewDataSource,DDActionSheetViewDelegate,UIImagePickerControllerDelegate,TZImagePickerControllerDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate>

{
    UIView *_titleView;
    NSMutableArray *_selectedImageArr;
    NSString *_imageId;
    UIImage *_image;
    NSString *_isCheckSuccess;//记录图片比对是否成功
    NSInteger imgSize;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *addressLabel;
@property (nonatomic,strong) UIImageView *addressImgV;
@property (nonatomic,strong) UIButton *commitBtn;
/// 导航软件
@property (nonatomic, strong) NSMutableArray *mapApps;
@end

@implementation DDSafeManAndAgencyVC

-(void)viewWillDisappear:(BOOL)animated{
    [_titleView removeFromSuperview];
    //还原导航底部线条颜色
    //[DDNavigationUtil setNavigationBottomLineNomalColor:self.navigationController];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar addSubview:_titleView];
    //[self.navigationController.navigationBar addSubview:_titleView];
    //导航底部线条设为透明
    //[DDNavigationUtil setNavigationBottomLineClearColor:self.navigationController];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self editNavItem];
    [self createBottomBtns];
    [self createTableView];
    _selectedImageArr = [[NSMutableArray alloc]init];
}

-(void)editNavItem{
    self.view.backgroundColor=kColorBackGroundColor;
    _titleView=[[UIView alloc]initWithFrame:CGRectMake(70, 4.5, Screen_Width-140, 35)];
    
    UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, Screen_Width-140, 20)];
    label1.text=@"安全员继续教育";
    label1.textColor=KColorCompanyTitleBalck;
    label1.font=kFontSize36Bold;
    label1.textAlignment=NSTextAlignmentCenter;
    [_titleView addSubview:label1];
    
    UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(0, 20, Screen_Width-140, 15)];
    label2.text=self.agencyName;
    label2.textColor=KColorGreySubTitle;
    label2.font=kFontSize24;
    label2.textAlignment=NSTextAlignmentCenter;
    [_titleView addSubview:label2];
    
    [self.navigationController.navigationBar addSubview:_titleView];
    self.navigationItem.leftBarButtonItem=[DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
}
-(void)uploadImgAction{
    [BDImagePicker showImagePickerFromViewController:self allowsEditing:YES finishAction:^(UIImage *image) {
        if(image){
            [_selectedImageArr removeAllObjects];
            [_selectedImageArr addObject:image];
            [self uploadImage];
            _image=image;
        }
    }];
}
//返回上一页
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

//创建底部四个按钮
-(void)createBottomBtns{

    CGFloat distanceToTop=Screen_Height-KNavigationBarHeight- KTabbarAndHomeIndicatorHeight;
    
    UIView *leftView=[[UIView alloc]initWithFrame:CGRectMake(0, distanceToTop, Screen_Width-130, KTabbarHeight)];
    leftView.backgroundColor=kColorWhite;
    
    NSString *moneyStr;
    if ([DDUtils isEmptyString:self.majorPrice]) {
        moneyStr=@"";
    }
    else{
        moneyStr=[NSString stringWithFormat:@"¥%ld",(long)[self.majorPrice integerValue]];
    }
    
    CGRect textFrame1= [@"考试培训费" boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize28} context:nil];
    
    CGRect textFrame2= [moneyStr boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:KFontSize38Bold} context:nil];
    
    if (textFrame1.size.width+textFrame2.size.width+7<Screen_Width-130) {
        UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake((Screen_Width-130-textFrame1.size.width-textFrame2.size.width-7)/2, 0, textFrame1.size.width, KTabbarHeight)];
        label1.text=@"考试培训费";
        label1.textColor=kColorGrey;
        label1.font=kFontSize28;
        [leftView addSubview:label1];
        
        UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label1.frame)+7, 0, textFrame2.size.width, KTabbarHeight)];
        label2.text=moneyStr;
        label2.textColor=kColorBlue;
        label2.font=KFontSize38Bold;
        [leftView addSubview:label2];
    }
    else{
        UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, Screen_Width-130-7-textFrame2.size.width, KTabbarHeight)];
        label1.text=@"考试培训费";
        label1.textColor=kColorGrey;
        label1.font=kFontSize28;
        [leftView addSubview:label1];
        
        UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label1.frame)+7, 0, textFrame2.size.width, KTabbarHeight)];
        label2.text=moneyStr;
        label2.textColor=kColorBlue;
        label2.font=KFontSize38Bold;
        [leftView addSubview:label2];
    }
    
    [self.view addSubview:leftView];
    
    
    _commitBtn=[[UIButton alloc]initWithFrame:CGRectMake(Screen_Width-130, distanceToTop, 130, KTabbarHeight)];
    [_commitBtn setTitle:@"提交报名" forState:UIControlStateNormal];
    [_commitBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
    [_commitBtn setBackgroundColor:KColorBidApprovalingWait];
    _commitBtn.titleLabel.font=kFontSize32;
    _commitBtn.userInteractionEnabled = NO;
    [_commitBtn addTarget:self action:@selector(sendAccountClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_commitBtn];
}

//创建tableView
-(void)createTableView{
   _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-KNavigationBarHeight-KTabbarAndHomeIndicatorHeight) style:UITableViewStyleGrouped];
    
    [self.view addSubview:_tableView];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.showsVerticalScrollIndicator=YES;
    _tableView.estimatedRowHeight=44;
    [_tableView registerClass:[DDNewPeopleInfoCell class] forCellReuseIdentifier:@"DDNewPeopleInfoCell"];
}

#pragma mark tableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DDNewPeopleInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DDNewPeopleInfoCell" forIndexPath:indexPath];
    cell.nameLab.text=self.peopleName;
    cell.majorLab1.text=@"证书类别：";
    cell.majorLab1.textColor=KColorGreySubTitle;
    cell.majorLab2.text=self.majorName;
    cell.numberLab1.text=@"证书号：";
    cell.numberLab2.text=self.certiNo;
    cell.haveBLab1.text=@"状态：";
    
    cell.timeLab1.text=@"有效期：";
    cell.timeLab2.text=self.endTime;
    
    NSString *resultStr = [DDUtils newCompareTimeSpaceIn90:self.endTime];
    if ([resultStr isEqualToString:@"2"]) {
        cell.timeLab2.textColor=kColorBlue;
    }else if ([resultStr isEqualToString:@"1"]){
        cell.timeLab2.textColor=KColorTextOrange;
    } else{
        cell.timeLab2.textColor=kColorRed;
    }
    
    if ([self.certiState isEqualToString:@"过期"]) {
        cell.haveBLab2.text=self.certiState;
        cell.haveBLab2.textColor=kColorRed;
    }
    else{
        cell.haveBLab2.text=self.certiState;
        cell.haveBLab2.textColor=KColorBlackSubTitle;
    }
    if (_image) {
        cell.uploadBtn.hidden = YES;
        cell.imgSizeLab.hidden = NO;
        cell.uploadImgV.hidden = NO;
        cell.uploadImgV.image = _image;
        cell.imgSizeLab.text = [NSString stringWithFormat:@"%ldkB",(long)imgSize];
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(uploadImgAction)];
        [cell.uploadImgV addGestureRecognizer:tap];
    }else{
        cell.uploadBtn.hidden = NO;
        cell.imgSizeLab.hidden = YES;
        cell.uploadImgV.hidden = YES;
       [cell.uploadBtn addTarget:self action:@selector(uploadImgAction) forControlEvents:UIControlEventTouchUpInside];

    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   return WidthByiPhone6(142);
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, WidthByiPhone6(51))];
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, WidthByiPhone6(36))];
    bgView.backgroundColor = KColorBindPhone;
    [headV addSubview:bgView];
    UILabel *infoL = [UILabel labelWithFont:kFontSize26 textString:@"请先上传报名截图！" textColor:KColorOrangeSubTitle textAlignment:NSTextAlignmentLeft numberOfLines:1];
    [bgView addSubview:infoL];
    if(_image){
        UIImageView *iconImgV = [[UIImageView alloc]initWithFrame:CGRectMake(WidthByiPhone6(12), WidthByiPhone6(10.5), WidthByiPhone6(15), WidthByiPhone6(15))];
        [bgView addSubview:iconImgV];
        infoL.frame = CGRectMake(WidthByiPhone6(33), 0, Screen_Width-WidthByiPhone6(40), WidthByiPhone6(36));
        
        if ([_isCheckSuccess isEqualToString:@"0"]) {//表明比对失败
            infoL.textColor = KColorFF4141;
            bgView.backgroundColor = [UIColor hexStringToColor:@"#FFE0E0"];
            iconImgV.image = DDIMAGE(@"shibai");
            infoL.text = @"上传的报名截图与证书信息不符，请核实后重新上传";
        }else if ([_isCheckSuccess isEqualToString:@"1"]){
            bgView.backgroundColor = KColorBillBtnBg;
            infoL.textColor = [UIColor hexStringToColor:@"#0ABD3D"];
            iconImgV.image = DDIMAGE(@"chenggong");
            infoL.text = @"上传的报名截图已确认成功！";
        }
    }else{
        infoL.frame = CGRectMake(WidthByiPhone6(12), 0, Screen_Width-WidthByiPhone6(20), WidthByiPhone6(36));
    }
    return headV;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, WidthByiPhone6(100))];
    footV.backgroundColor = kColorWhite;
    UIView *greyV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, WidthByiPhone6(15))];
    greyV.backgroundColor = kColorBackGroundColor;
    [footV addSubview:greyV];

    [footV addSubview:self.titleLabel];
    [footV addSubview:self.addressImgV];
    [footV addSubview:self.addressLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(greyV).offset(WidthByiPhone6(35));
        make.left.equalTo(footV).offset(WidthByiPhone6(12));
        make.right.equalTo(footV).offset(WidthByiPhone6(-12));
    }];
    [self.addressImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(WidthByiPhone6(15));
        make.left.equalTo(_titleLabel);
        make.width.height.mas_equalTo(WidthByiPhone6(15));
    }];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_addressImgV);
        make.left.equalTo(_addressImgV.mas_right).offset(WidthByiPhone6(12));
        make.right.equalTo(footV).offset(WidthByiPhone6(-12));
    }];
    _titleLabel.text=self.agencyName;
    _addressLabel.text=self.address;
    [_addressLabel whenTapped:^{
        DDActionSheetView *sheetView = [[DDActionSheetView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
        self.mapApps = [NSMutableArray array];
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://map/"]]){
            [self.mapApps addObject:charBaiDuMapNav];
        }
        
        if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
            
            [self.mapApps addObject:charGaoDeMapNav];
        }
        
        [self.mapApps addObject:charAppleMapNav];
        
        [sheetView setTitle:self.mapApps cancelTitle:KMainCancel];
        sheetView.delegate = self;
        [sheetView show];
    }];
    return footV;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  WidthByiPhone6(51);
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return WidthByiPhone6(100);
}

#pragma mark 提交订单点击事件
-(void)sendAccountClick{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:self.companyId forKey:@"enterpriseId"];
    [params setValue:self.companyName forKey:@"enterpriseName"];
    [params setValue:_peopleName forKey:@"name"];
    [params setValue:_certiNo forKey:@"certNo"];
    [params setValue:_certiTypeId forKey:@"certTypeId"];
    //[params setValue:_haveB forKey:@"hasBCertificate"];
    [params setValue:_endTime forKey:@"validityPeriodEnd"];
    [params setValue:_tel forKey:@"tel"];
    [params setValue:_trainId forKey:@"agencyId"];
    [params setValue:self.idCard forKey:@"card"];
    [params setValue:@"3" forKey:@"certType"];
    [params setValue:_imageId forKey:@"fileId"];
    [params setValue:self.staffId forKey:@"staffId"];
    MBProgressHUD * hud = [DDUtils showHUDCustom:@""];
    [[DDHttpManager sharedInstance]sendPostRequest:KHttpRequest_builderAddApply params:params success:^(NSURLSessionDataTask *operation, id responseObject){
        NSLog(@"**********安全员添加报名之提交报名数据,获取certiId***************%@",responseObject);

        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            [hud hide:NO];
            DDSafeManPayEnsureVC *safeManPayEnsure=[[DDSafeManPayEnsureVC alloc]init];
            safeManPayEnsure.userId=self.userId;
            safeManPayEnsure.goodsId=self.goodsId;
            safeManPayEnsure.trainId=self.trainId;

            safeManPayEnsure.certiTypeId=self.certiTypeId;
            safeManPayEnsure.certiId=[NSString stringWithFormat:@"%@",responseObject[KData]];

            safeManPayEnsure.peopleName=self.peopleName;
            safeManPayEnsure.majorName=self.majorName;
            safeManPayEnsure.agencyName=self.agencyName;
            safeManPayEnsure.majorPrice=self.majorPrice;
            safeManPayEnsure.companyName=self.companyName;
            safeManPayEnsure.certType = @"3";
            safeManPayEnsure.isFromeAddApply = _isFromeAddApply;
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


#pragma mark DDActionSheetViewDelegate
-(void)actionsheetSelectButton:(DDActionSheetView *)actionSheet buttonIndex:(NSInteger)index{

        DDNavigationManager * navManger = [DDNavigationManager sharedInstance];
        navManger.endName = self.address;
        NSString *mapString = self.mapApps[index - 1];
        if ([mapString isEqualToString:charAppleMapNav]) {
            [navManger openAppleMapNavigation];
            
        }else if ([mapString isEqualToString:charBaiDuMapNav]){
            [navManger openBaiDuMapNavigation];
            
        }else if ([mapString isEqualToString:charGaoDeMapNav]){
            [navManger openGaoDeMapNavigation];
        }
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


#pragma mark 上传图片到文件服务器
- (void)uploadImage{
    //时间
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *dateStr = [formatter stringFromDate:date];
    
    MBProgressHUD * hud = [DDUtils showHUDCustom:@""];
    
    //图片压缩下
//    NSMutableArray *compressImageArr = [self compressImages];
    
    [[DDHttpManager sharedInstance] sendPostRequestWithFile:KHttpRequest_imgUpload params:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (int i = 0; i< _selectedImageArr.count; i++) {
            UIImage *img = _selectedImageArr[i];
            NSData *data = UIImagePNGRepresentation(img);
            NSString * fileNameString = [NSString stringWithFormat:@"%@%d.jpg",dateStr,i];
            [formData appendPartWithFileData:data name:@"file" fileName:fileNameString mimeType:@"jpg"];
//            NSData * data = compressImageArr[i];
//            NSString * fileNameString = [NSString stringWithFormat:@"%@%d.jpg",dateStr,i];
//            [formData appendPartWithFileData:data name:@"file" fileName:fileNameString mimeType:@"jpg"];
            NSLog(@"___fileNameString:%@",fileNameString);
        }
        
    } success:^(NSURLSessionDataTask *operation, id responseObject) {
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        NSLog(@"照片上传结果,从中获取id***%@",responseObject);
        if (response.isSuccess) {
            [hud hide:YES];
            if ([response.data isKindOfClass:[NSArray class]]) {
                _imageId=response.data[0][@"id"];
                //比对图片,获得比对结果
                [self comparePicture];
                
                UIImage *img = _selectedImageArr[0];
                NSData *data = UIImagePNGRepresentation(img);
                imgSize = [data length]/1024;
            }
            [_tableView reloadData];
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

#pragma mark 调图片比对的接口
-(void)comparePicture{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:@[_idCard,_certiNo] forKey:@"data_list"];
    [params setValue:@"2" forKey:@"type"];
    [params setValue:_imageId forKey:@"file_id"];
    MBProgressHUD * hud = [DDUtils showHUDCustom:@""];
    [[DDHttpManager sharedInstance]sendPostRequest:KHttpRequest_comparePictures params:params success:^(NSURLSessionDataTask *operation, id responseObject){
        NSLog(@"**********图片对比，获取对比结果***************%@",responseObject);
        [hud hide:YES];
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            if ([response.data isEqual:@0]) {
                _isCheckSuccess=@"0";
                [DDUtils showToastWithMessage:@"如填写信息无误,请重新截图,截图内容区域与边角留有足够的距离,提高匹配成功率!"];
                _commitBtn.userInteractionEnabled = NO;
                [_commitBtn setBackgroundColor:KColorBidApprovalingWait];
            }
            else{//比对成功
                _isCheckSuccess=@"1";
                _commitBtn.userInteractionEnabled = YES;
                [_commitBtn setBackgroundColor:kColorBlue];
                
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

-(UILabel *)titleLabel{
    if(!_titleLabel){
        _titleLabel = [UILabel labelWithFont:kFontSize34 textColor:KColorBlackTitle textAlignment:NSTextAlignmentLeft numberOfLines:1];
    }
    return _titleLabel;
}
-(UILabel *)addressLabel{
    if(!_addressLabel){
        _addressLabel = [UILabel labelWithFont:kFontSize28 textColor:kColorBlue textAlignment:NSTextAlignmentLeft numberOfLines:2];
    }
    return _addressLabel;
}
-(UIImageView *)addressImgV{
    if(!_addressImgV){
        _addressImgV = [[UIImageView alloc]initWithImage:DDIMAGE(@"home_select_address")];
    }
    return _addressImgV;
}

@end
