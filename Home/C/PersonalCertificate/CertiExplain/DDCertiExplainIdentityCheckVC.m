//
//  DDCertiExplainIdentityCheckVC.m
//  GongChengDD
//
//  Created by xzx on 2018/9/28.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDCertiExplainIdentityCheckVC.h"
#import "UIImage+extend.h"
#import "DDIdCardCheckFailureView.h"//身份证审核失败View
#import "IDLFaceSDK/IDLFaceSDK.h"
#import "FaceParameterConfig.h"
#import "LivingConfigModel.h"
#import "LivenessViewController.h"
#import "DDPersonalCheckSuccessVC.h"//认领成功页面
#import "DDProjectCheckOriginWebVC.h"//认领协议页面

@interface DDCertiExplainIdentityCheckVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,DDIdCardCheckFailureViewDelegate>

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

@implementation DDCertiExplainIdentityCheckVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"证书申诉";
    self.view.backgroundColor=kColorBackGroundColor;
    self.navigationItem.leftBarButtonItem = [DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
    [self createMainViews];
}

#pragma mark 返回
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 创建主体布局
-(void)createMainViews{
    UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(12, 20, 110, 15)];
    label1.text=@"上传证书原件  >";
    label1.textColor=kColorBlue;
    label1.font=kFontSize28;
    [self.view addSubview:label1];
    
    UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label1.frame)+10, 20, 100, 15)];
    label2.text=@"身份证扫描  >";
    label2.textColor=KColorBidApprovalingWait;
    label2.font=kFontSize28;
    [self.view addSubview:label2];
    
    UILabel *label_3=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label2.frame)+10, 20, 60, 15)];
    label_3.text=@"人脸识别";
    label_3.textColor=KColorBidApprovalingWait;
    label_3.font=kFontSize28;
    [self.view addSubview:label_3];
    
    
    UILabel *label3=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(label2.frame)+40, Screen_Width, 15)];
    label3.text=@"请扫描您的二代身份证";
    label3.textColor=KColorBlackSubTitle;
    label3.font=kFontSize28;
    label3.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:label3];
    
    _btn1=[[UIButton alloc]initWithFrame:CGRectMake((Screen_Width-205)/2, CGRectGetMaxY(label3.frame)+38, 205, 130)];
    [_btn1 setBackgroundImage:[UIImage imageNamed:@"home_conpany_positive"] forState:UIControlStateNormal];
    [_btn1 addTarget:self action:@selector(scanPositive) forControlEvents:UIControlEventTouchUpInside];
    _btn1.adjustsImageWhenHighlighted = NO;
    [self.view addSubview:_btn1];
    
    
//    _btn2=[[UIButton alloc]initWithFrame:CGRectMake((Screen_Width-205)/2, CGRectGetMaxY(_btn1.frame)+45, 205, 130)];
//    [_btn2 setBackgroundImage:[UIImage imageNamed:@"home_conpany_negative"] forState:UIControlStateNormal];
//    [_btn2 addTarget:self action:@selector(scanNegative) forControlEvents:UIControlEventTouchUpInside];
//    _btn2.adjustsImageWhenHighlighted = NO;
//    [self.view addSubview:_btn2];
    
    
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
    
    if (image) {
        if ([_selected isEqualToString:@"1"]) {//正面
            _positiveImg=image;
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
            [self uploadImage];
            
            [_btn1 setBackgroundImage:_positiveImg forState:UIControlStateNormal];
        }
        else{//反面
            _negativeImg=image;
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
            [self uploadImage];
            
            [_btn2 setBackgroundImage:_negativeImg forState:UIControlStateNormal];
        }
    }
    else{
        [DDUtils showToastWithMessage:@"图片获取失败！"];
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
    [params setValue:self.certType forKey:@"certType"];
    if ([_selected isEqualToString:@"1"]) {//正面
        [params setValue:_positiveImgId forKey:@"fileID"];
    }
    else{//反面
        [params setValue:_negativeImgId forKey:@"fileID"];
    }
    [params setValue:self.certId forKey:@"certId"];
    
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
            DDPersonalCheckSuccessVC *checkSuccess=[[DDPersonalCheckSuccessVC alloc]init];
            checkSuccess.type=@"1";
            checkSuccess.popbackBlock = ^{
                [weakSelf.navigationController popViewControllerAnimated:NO];
                weakSelf.popbackBlock();
            };
            [weakSelf.navigationController pushViewController:checkSuccess animated:YES];
        }
        else{
            hud.labelText = response.message;
            [hud hide:YES afterDelay:KHudShowTimeSecound];
            //[DDUtils showToastWithMessage:response.message];
        }
        
    }  failure:^(NSURLSessionDataTask *operation, id responseObject)  {
        hud.labelText = @"人脸识别失败";
        [hud hide:YES afterDelay:KHudShowTimeSecound];
        //[DDUtils showToastWithMessage:kRequestFailed];
    }];
}



@end
