//
//  DDPersonalIdentityCheckVC.m
//  GongChengDD
//
//  Created by xzx on 2018/9/26.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDPersonalIdentityCheckVC.h"
#import "UIImage+extend.h"
#import "DDIdCardCheckFailureView.h"//身份证审核失败View
#import "IDLFaceSDK/IDLFaceSDK.h"
#import "FaceParameterConfig.h"
#import "LivingConfigModel.h"
#import "LivenessViewController.h"
//#import "DDPersonalCheckSuccessVC.h"//认领成功页面
//#import "DDPersonalCheckIntroduceVC.h"//认领介绍页面
#import "DDProjectCheckOriginWebVC.h"//认领协议页面
#import "DDOpenContactWayVC.h"//公开联系方式设置页面
#import "DDPersonalClaimBenefitVC.h"
@interface DDPersonalIdentityCheckVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,DDIdCardCheckFailureViewDelegate>

{
    UIButton *_btn1;
    UIButton *_btn2;
    UIButton *_nextBtn;
    UIImage *_positiveImg;
    NSString *_positiveImgId;
    UIImage *_negativeImg;
    NSString *_negativeImgId;
    
    UIImage *_faceImg;
    
    NSString *_processId;//从身份证认证成功后获取
    
    NSString *_selected;//1表示当下传的是正面，2表示当下传的是反面,3表示下一步人脸识别
}

@end

@implementation DDPersonalIdentityCheckVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_identityCheckType == DDIdentityCheckTypeDefault) {
        self.title=_peopleName;
    }else{
        self.peopleName = _model.name;
        self.staffInfoId = _model.staff_info_id;
        self.title=@"身份确认";
    }
    self.view.backgroundColor=kColorBackGroundColor;
    self.navigationItem.leftBarButtonItem = [DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
//    self.navigationItem.rightBarButtonItem = [DDUtils rightbuttonItemWithTitle:@"认领介绍" target:self action:@selector(rightButtonClick)];
    [self createMainViews];
}

#pragma mark 返回
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 认领介绍
//- (void)rightButtonClick{
//    DDPersonalCheckIntroduceVC * vc= [[DDPersonalCheckIntroduceVC alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
//}

#pragma mark 创建主体布局
-(void)createHeader:(UIView *)view{
    UILabel *labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(18, 0, Screen_Width, 44)];
    labelTitle.text = _model.name;
    labelTitle.textColor = [UIColor colorWithWhite:60.0 / 255.0 alpha:1];
    labelTitle.font = [UIFont systemFontOfSize:20];
    [view addSubview:labelTitle];
    
    CGFloat X=18;//初始化X值
    CGFloat Y=52;//初始化Y值
    
//    [self.btnsView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //法人：1,项目经理：2,建造师：3,三类人员：4
    /*
     1 法人',
     2 项目经理',
     3 建造师等级 (0,1,2,3)',
     4 安全员等级',
     5 建筑师等级',
     6 结构师等级',
     7 土木工程师',
     8 公用设备师',
     9 电气工程师',
     10 化工工程师',
     11 监理工程师',
     12 造价工程师',
     13 消防工程师',
     */
    for (DDRolesListModel *rolesListModel in _model.roles) {
        
        CGRect frame_W = [rolesListModel.role boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
        
        CGFloat tempX=X+frame_W.size.width+16+10;
        
        if (tempX>Screen_Width-24) {
            X=18;
            Y=Y+20+10;
        }
        
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(X, Y, frame_W.size.width+16, 20)];
        label.text=rolesListModel.role;
        label.font=kFontSize24;
        label.textAlignment=NSTextAlignmentCenter;
        label.layer.cornerRadius=3;
        label.clipsToBounds=YES;
        label.layer.borderWidth=0.5;
        
        if ([rolesListModel.code isEqualToString:@"1"]) {//法人
            label.textColor=kColorBlue;
            label.layer.borderColor=kColorBlue.CGColor;
            label.backgroundColor=KColorBgBlue;
        }
        else if([rolesListModel.code isEqualToString:@"2"]){//项目经理
            label.textColor=KColorTextOrange;
            label.layer.borderColor=KColorTextOrange.CGColor;
            label.backgroundColor=KColorBGOrange;
        }
        else if([rolesListModel.code isEqualToString:@"3"]){//建造师
            label.textColor=KColorTextGreen;
            label.layer.borderColor=KColorTextGreen.CGColor;
            label.backgroundColor=KColorBGGreen;
        }
        else if([rolesListModel.code isEqualToString:@"4"]){//三类人员
            label.textColor=KColorBlackSecondTitle;
            label.layer.borderColor=KColorBlackSecondTitle.CGColor;
            label.backgroundColor=KColorLinkBackViewColor;
        }
        else if([rolesListModel.code isEqualToString:@"5"]){//建筑师
            label.textColor=KColorArchitect;
            label.layer.borderColor=KColorArchitect.CGColor;
            label.backgroundColor=KColorArchitectBg;
        }
        else if([rolesListModel.code isEqualToString:@"6"]){//结构师
            label.textColor=KColorConstruct;
            label.layer.borderColor=KColorConstruct.CGColor;
            label.backgroundColor=KColorConstructBg;
        }
        else if([rolesListModel.code isEqualToString:@"7"]){//土木工程师
            label.textColor=KColorCivil;
            label.layer.borderColor=KColorCivil.CGColor;
            label.backgroundColor=KColorCivilBg;
        }
        else if([rolesListModel.code isEqualToString:@"8"]){//共用设备师
            label.textColor=KColorDevice;
            label.layer.borderColor=KColorDevice.CGColor;
            label.backgroundColor=KColorDeviceBg;
        }
        else if([rolesListModel.code isEqualToString:@"9"]){//电气工程师
            label.textColor=KColorElectric;
            label.layer.borderColor=KColorElectric.CGColor;
            label.backgroundColor=KColorElectricBg;
        }
        else if([rolesListModel.code isEqualToString:@"10"]){//化工工程师
            label.textColor=KColorChemical;
            label.layer.borderColor=KColorChemical.CGColor;
            label.backgroundColor=KColorChemicalBg;
        }
        else if([rolesListModel.code isEqualToString:@"11"]){//监理工程师
            label.textColor=KColorSupervisor;
            label.layer.borderColor=KColorSupervisor.CGColor;
            label.backgroundColor=KColorSupervisorBg;
        }else if([rolesListModel.code isEqualToString:@"12"]){//造价工程师
            label.textColor=KColorCost;
            label.layer.borderColor=KColorCost.CGColor;
            label.backgroundColor=KColorCostBg;
        }
        else if([rolesListModel.code isEqualToString:@"13"]){//消防工程师
            label.textColor=KColorFire;
            label.layer.borderColor=KColorFire.CGColor;
            label.backgroundColor=KColorFireBg;
        }
        
        [view addSubview:label];
        
        X=X+frame_W.size.width+16+10;
    }
    
    CGRect frame = view.frame;
    frame.size.height += (Y - 38);
    [view setFrame:frame];
    
    UILabel *labelE = [[UILabel alloc]initWithFrame:CGRectMake(18, Y + 15 + 16 , Screen_Width, 36)];
    labelE.textColor = [UIColor colorWithWhite:90.0 / 255.0 alpha:1];
    labelE.text = _model.enterprise_name;
    labelE.font = [UIFont systemFontOfSize:14];
    [view addSubview:labelE];
}

-(void)createMainViews{
    UIView *viewHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 108)];
    viewHeader.backgroundColor = kColorWhite;
    if (_identityCheckType == DDIdentityCheckTypeHomeList) {
        [self.view addSubview:viewHeader];
        [self createHeader:viewHeader];
    }else{
        [viewHeader setFrameHeight:0];
        viewHeader.hidden = YES;
    }
    //头部内容
    UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(12, viewHeader.frame.size.height + 20, Screen_Width-24, 15)];
    label1.text=@"身份证扫描     >    人脸识别    >     公开联系方式设置";
    label1.textColor= KColorBidApprovalingWait;
    label1.font=kFontSize28;
    [self.view addSubview:label1];
    NSArray *arStr = [label1.text componentsSeparatedByString:@">"];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:label1.text];
    [attrStr setAttributes:@{NSForegroundColorAttributeName:kColorBlue} range:NSMakeRange(0, [NSString stringWithFormat:@"%@",arStr[0]].length)];
    label1.attributedText = [attrStr copy];
    
    _btn1=[[UIButton alloc]initWithFrame:CGRectMake((Screen_Width-265)/2, CGRectGetMaxY(label1.frame)+38, 265, 171)];
    [_btn1 setBackgroundImage:[UIImage imageNamed:@"home_conpany_positive"] forState:UIControlStateNormal];
    [_btn1 addTarget:self action:@selector(scanPositive) forControlEvents:UIControlEventTouchUpInside];
    _btn1.adjustsImageWhenHighlighted = NO;
    [self.view addSubview:_btn1];
    
    
    
    _nextBtn=[[UIButton alloc]initWithFrame:CGRectMake(12, Screen_Height-KNavigationBarHeight-30-15-10-15-20-40, Screen_Width-24, 40)];
    [_nextBtn addTarget:self action:@selector(nextClick) forControlEvents:UIControlEventTouchUpInside];
    [_nextBtn setTitle:@"同意协议并下一步" forState:UIControlStateNormal];
    [_nextBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
    [_nextBtn setBackgroundColor:kColorBlue];
    _nextBtn.layer.cornerRadius=3;
    _nextBtn.titleLabel.font=kFontSize32;
    _nextBtn.alpha=0.5;
    _nextBtn.userInteractionEnabled=NO;
    [self.view addSubview:_nextBtn];
    
    UILabel *label4=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_nextBtn.frame)+20, Screen_Width, 15)];
    label4.text=@"信息仅用于身份验证，工程点点保障您的信息安全";
    label4.textColor=KColorBidApprovalingWait;
    label4.font=kFontSize26;
    label4.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:label4];
    
    
    CGRect protocolFrame = [@"《证书认领服务协议》" boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize26} context:nil];
    UIButton *protocolBtn=[[UIButton alloc]initWithFrame:CGRectMake((Screen_Width-protocolFrame.size.width)/2, CGRectGetMaxY(label4.frame)+10, protocolFrame.size.width, 15)];
    [protocolBtn addTarget:self action:@selector(protocolClick) forControlEvents:UIControlEventTouchUpInside];
    [protocolBtn setTitle:@"《证书认领服务协议》" forState:UIControlStateNormal];
    [protocolBtn setTitleColor:kColorBlue forState:UIControlStateNormal];
    //[protocolBtn setBackgroundColor:kColorWhite];
    protocolBtn.titleLabel.font=kFontSize26;
    [self.view addSubview:protocolBtn];
}

#pragma mark 点击查看证书认领服务协议
-(void)protocolClick{
    DDProjectCheckOriginWebVC *protocol=[[DDProjectCheckOriginWebVC alloc]init];
    protocol.navigationItem.title = @"证书认领协议";
    protocol.hostUrl=[NSString stringWithFormat:@"%@/#/certificateClaimAgreement?hideTop=1",DDBaseUrl];
    [self.navigationController pushViewController:protocol animated:YES];
}

#pragma mark 扫描正面
-(void)scanPositive{
    _selected=@"1";
    [self takePhoto];
}

#pragma mark 扫描背面
-(void)scanNegative{
    _selected=@"2";
    [self takePhoto];
}

#pragma mark 相机现拍
- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS8Later) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:charOpenCarmeraTip delegate:self cancelButtonTitle:KMainOk otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
        __weak __typeof(self) weakSelf=self;
        
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            return;
        }
        UIImagePickerController* controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypeCamera;
        controller.showsCameraControls = YES;//是否显示拍照按钮
        controller.allowsEditing = NO;//是否允许编辑图片
        controller.delegate = self;
        [weakSelf presentViewController:controller animated:YES completion:^{
            
        }];
    }
}
#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImageWriteToSavedPhotosAlbum(image, nil,nil, nil);
    
    if (image) {
        if ([_selected isEqualToString:@"1"]) {//正面
            _positiveImg=image;
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
            [self uploadImage];
            
            [_btn1 setBackgroundImage: [self imageCompressForSize:_positiveImg targetSize:CGSizeMake(265, 171)] forState:UIControlStateNormal];
        }
        else{//反面
            _negativeImg=image;
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
            [self uploadImage];
            
            [_btn2 setBackgroundImage: [self imageCompressForSize:_negativeImg targetSize:CGSizeMake(265, 171)] forState:UIControlStateNormal];
        }
    }
    else{
        [DDUtils showToastWithMessage:@"图片获取失败！"];
        [picker dismissViewControllerAnimated:YES completion:nil];
        return;
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
    hud.labelText = @"图片上传中...";
    //图片压缩下
    NSData *compressData = [self compressImages];
    __weak __typeof(self) weakSelf=self;
    [[DDHttpManager sharedInstance] sendPostRequestWithFile:KHttpRequest_imgUpload params:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSString * fileNameString = [NSString stringWithFormat:@"%@%d.jpg",dateStr,0];
        [formData appendPartWithFileData:compressData name:@"file" fileName:fileNameString mimeType:@"jpg"];
        NSLog(@"___fileNameString:%@",fileNameString);
        
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
                
                if ([_selected isEqualToString:@"1"]) {//正面
                    _positiveImgId=response.data[0][@"id"];
                }
                else if ([_selected isEqualToString:@"2"]){//反面
                    _negativeImgId=response.data[0][@"id"];
                }
                else{
                    
                }
                
                if ([_selected isEqualToString:@"3"]) {
                    //对比人脸
                    [weakSelf checkFace];
                }
                else{
                    //比对图片,获得比对结果
                    [weakSelf comparePicture];
                }
                
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
- (NSData *)compressImages{
    if ([_selected isEqualToString:@"1"]) {//正面
        NSData *compressData = [UIImage compressDataWithImage:_positiveImg maxLength:kFileMaxSize];
        
        return compressData;
    }
    else if ([_selected isEqualToString:@"2"]) {//反面
        NSData *compressData = [UIImage compressDataWithImage:_negativeImg maxLength:kFileMaxSize];
        
        return compressData;
    }
    else{//人脸
        NSData *compressData = [UIImage compressDataWithImage:_faceImg maxLength:kFileMaxSize];
        
        return compressData;
    }
}

#pragma mark 调身份证识别的接口
-(void)comparePicture{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:self.peopleName forKey:@"certUserName"];
    if ([_selected isEqualToString:@"1"]) {//正面
        [params setValue:_positiveImgId forKey:@"fileID"];
    }
    else{//反面
        [params setValue:_negativeImgId forKey:@"fileID"];
    }
    [params setValue:self.staffInfoId forKey:@"staffInfoId"];
    
    MBProgressHUD * hud = [DDUtils showHUDCustom:@""];
    hud.labelText = @"图片比对中...";
    __weak __typeof(self) weakSelf=self;
    [[DDHttpManager sharedInstance]sendPostRequest:KHttpRequest_scanIdentityCard params:params success:^(NSURLSessionDataTask *operation, id responseObject){
        NSLog(@"**********身份证识别结果***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            
            _processId=responseObject[KData][@"processId"];
            _nextBtn.alpha=1;
            _nextBtn.userInteractionEnabled=YES;
            [hud hide:YES];
        }
        else{
            [hud hide:YES];
            //不成功，弹出t对话框
            [weakSelf showDialogue:response.message];
            //[DDUtils showToastWithMessage:response.message];
        }
        
    }  failure:^(NSURLSessionDataTask *operation, id responseObject)  {
        hud.labelText = @"图片比对失败";
        [hud hide:YES afterDelay:KHudShowTimeSecound];
        //[DDUtils showToastWithMessage:kRequestFailed];
    }];
}

//弹出对话框
-(void)showDialogue:(NSString *)message{
    DDIdCardCheckFailureView *sheetView= [[DDIdCardCheckFailureView alloc]initWithFrame:self.view.window.frame];
    sheetView.tipStr=message;
    //sheetView.tipStr=@"证书姓名和证件姓名不匹配";
    sheetView.delegate = self;
    [sheetView show];
}

//DDIdCardCheckFailureViewDelegate
-(void)actionsheetDisappearAndReUploadImgClick:(DDIdCardCheckFailureView *)actionSheet{
    [actionSheet hiddenActionSheet];
    
    [self takePhoto];
}

#pragma mark 下一步，人脸识别
-(void)nextClick{
    _selected=@"3";
    
    if ([[FaceSDKManager sharedInstance] canWork]) {
        NSString* licensePath = [[NSBundle mainBundle] pathForResource:FACE_LICENSE_NAME ofType:FACE_LICENSE_SUFFIX];
        [[FaceSDKManager sharedInstance] setLicenseID:FACE_LICENSE_ID andLocalLicenceFile:licensePath];
    }
    
    __weak __typeof(self) weakSelf=self;
    LivenessViewController* lvc = [[LivenessViewController alloc] init];
    lvc.getCaptureImgBlock = ^(UIImage *captureImg) {
        _faceImg=captureImg;
        [weakSelf uploadImage];
    };
    //LivingConfigModel* model = [LivingConfigModel sharedInstance];
    [lvc livenesswithList:@[@(FaceLivenessActionTypeLiveEye)] order:YES numberOfLiveness:1];
    //[lvc livenesswithList:model.liveActionArray order:model.isByOrder numberOfLiveness:model.numOfLiveness];
    //UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:lvc];
    //navi.navigationBarHidden = true;
    [self presentViewController:lvc animated:YES completion:nil];
}

#pragma mark 比对人脸图片
-(void)checkFace{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:_processId forKey:@"processID"];
    //[params setValue:_faceImgId forKey:@"fileID"];
    NSData *data = UIImageJPEGRepresentation(_faceImg, 1.0f);
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    [params setValue:encodedImageStr forKey:@"image"];
    
    MBProgressHUD * hud = [DDUtils showHUDCustom:@""];
    hud.labelText = @"人脸识别中...";
    __weak __typeof(self) weakSelf=self;
    [[DDHttpManager sharedInstance]sendPostRequest:KHttpRequest_scanPeopleFace params:params success:^(NSURLSessionDataTask *operation, id responseObject){
        NSLog(@"**********人脸识别结果***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            
            //            if ([response.data isEqual:@0]) {
            //                _isCheckSuccess=@"0";
            //                [_tableView reloadData];
            //                [DDUtils showToastWithMessage:@"没通过比对，比对失败！"];
            //            }
            //            else{//比对成功
            //                _isCheckSuccess=@"1";
            //                [_tableView reloadData];
            //            }
            
            [hud hide:YES];
            //跳转到认领成功页面
            //DDPersonalCheckSuccessVC *checkSuccess=[[DDPersonalCheckSuccessVC alloc]init];
            //checkSuccess.popbackBlock = ^{
                //[weakSelf.navigationController popViewControllerAnimated:NO];
            //};
            //[weakSelf.navigationController pushViewController:checkSuccess animated:YES];
            
             [[NSNotificationCenter defaultCenter] postNotificationName:KRefreshUI object:nil];
            NSMutableArray *array = self.navigationController.viewControllers.mutableCopy;
            
            for (UIViewController *vc in array) {
                if ([vc isKindOfClass:[DDPersonalClaimBenefitVC class]]) {
                    [array removeObject:vc];
                    break;
                }
            }
            
            NSMutableArray *detaiArray = [NSMutableArray array];
            for (UIViewController *vc in array) {
                if ([vc isKindOfClass:[self class]]) {
                    [detaiArray addObject:vc];
                }
            }
            if (detaiArray.count >= 1) {
                [array removeObject:detaiArray.firstObject];
            }
            [DDUserManager sharedInstance].staffClaim = @"1";
            DDOpenContactWayVC *vc=[[DDOpenContactWayVC alloc]init];
            vc.staffInfoId=self.staffInfoId;
            vc.phoneStr = @"";
            vc.hidesBottomBarWhenPushed = YES;
            [array addObject:vc];
            [self.navigationController setViewControllers:array animated:YES];
            
            
            
            //跳转到公开联系方式设置页面
//            DDOpenContactWayVC *vc=[[DDOpenContactWayVC alloc]init];
//            vc.staffInfoId=self.staffInfoId;
//            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
        else{
            hud.labelText = response.message;
            [hud hide:YES afterDelay:KHudShowTimeSecound];
            //不成功，弹出t对话框
            //[DDUtils showToastWithMessage:response.message];
        }
        
    }  failure:^(NSURLSessionDataTask *operation, id responseObject)  {
        hud.labelText = @"人脸识别失败";
        [hud hide:YES afterDelay:KHudShowTimeSecound];
        //[DDUtils showToastWithMessage:kRequestFailed];
    }];
}

-(UIImage *) imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if(CGSizeEqualToSize(imageSize, size) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) *0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) *0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    UIGraphicsEndImageContext();
    return newImage;
}


@end
