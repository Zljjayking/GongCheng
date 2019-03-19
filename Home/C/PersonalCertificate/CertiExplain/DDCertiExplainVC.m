//
//  DDCertiExplainVC.m
//  GongChengDD
//
//  Created by xzx on 2018/9/28.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDCertiExplainVC.h"
#import "UIImage+extend.h"
#import "DDIdCardCheckFailureView.h"//身份证审核失败View
#import "IDLFaceSDK/IDLFaceSDK.h"
#import "FaceParameterConfig.h"
#import "LivingConfigModel.h"
#import "LivenessViewController.h"
#import "DDCertiExplainIdentityCheckVC.h"//证书申诉的下一步身份证扫描页面
#import "DDProjectCheckOriginWebVC.h"//认领协议页面

@interface DDCertiExplainVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,DDIdCardCheckFailureViewDelegate>

{
    UIButton *_btn;
    UIButton *_nextBtn;
    UIImage *_certiImg;
    NSString *_certiImgId;
    
    NSString *_processId;//从身份证认证成功后获取
}

@end

@implementation DDCertiExplainVC

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
    label3.text=@"请扫描您的证书原件";
    label3.textColor=KColorBlackSubTitle;
    label3.font=kFontSize28;
    label3.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:label3];
    
    _btn=[[UIButton alloc]initWithFrame:CGRectMake((Screen_Width-245)/2, CGRectGetMaxY(label3.frame)+38, 245, 180.5)];
    [_btn setBackgroundImage:[UIImage imageNamed:@"home_conpany_scanCerti"] forState:UIControlStateNormal];
    [_btn addTarget:self action:@selector(scanCerti) forControlEvents:UIControlEventTouchUpInside];
    _btn.adjustsImageWhenHighlighted = NO;
    [self.view addSubview:_btn];
    
    
    
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

#pragma mark 扫描证书原件
-(void)scanCerti{
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
        _certiImg=image;
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        [self uploadImage];
        
        [_btn setBackgroundImage:_certiImg forState:UIControlStateNormal];
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
                
                _certiImgId=response.data[0][@"id"];
                
                //比对图片,获得比对结果
                [weakSelf comparePicture];
                
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
    NSData *compressData = [UIImage compressDataWithImage:_certiImg maxLength:kFileMaxSize];
    
    return compressData;
}

#pragma mark 调身份证识别的接口
-(void)comparePicture{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:self.peopleName forKey:@"certUserName"];
    [params setValue:self.certType forKey:@"certType"];
    [params setValue:_certiImgId forKey:@"fileID"];
    [params setValue:self.certId forKey:@"certId"];
    
    MBProgressHUD * hud = [DDUtils showHUDCustom:@""];
    hud.labelText = @"图片比对中...";
    __weak __typeof(self) weakSelf=self;
    [[DDHttpManager sharedInstance]sendPostRequest:KHttpRequest_scanCertiPaper params:params success:^(NSURLSessionDataTask *operation, id responseObject){
        NSLog(@"**********证书原件识别结果***************%@",responseObject);
        
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
    //sheetView.tipStr=@"证书编号和上传证书编号不匹配";
    sheetView.delegate = self;
    [sheetView show];
}

//DDIdCardCheckFailureViewDelegate
-(void)actionsheetDisappearAndReUploadImgClick:(DDIdCardCheckFailureView *)actionSheet{
    [actionSheet hiddenActionSheet];
    
    [self takePhoto];
}

#pragma mark 下一步，跳转到身份证扫描页面
-(void)nextClick{
    __weak __typeof(self) weakSelf=self;
    DDCertiExplainIdentityCheckVC *identityCheck=[[DDCertiExplainIdentityCheckVC alloc]init];
    identityCheck.popbackBlock = ^{
        [weakSelf.navigationController popViewControllerAnimated:NO];
    };
    [self.navigationController pushViewController:identityCheck animated:YES];
}





@end
