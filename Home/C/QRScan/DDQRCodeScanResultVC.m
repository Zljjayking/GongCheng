//
//  DDQRCodeScanResultVC.m
//  GongChengDD
//
//  Created by xzx on 2018/7/31.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDQRCodeScanResultVC.h"
#import "DDQRCodeScanModel.h"//model

@interface DDQRCodeScanResultVC ()

{
    DDQRCodeScanModel *_model;
}

@end

@implementation DDQRCodeScanResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=kColorBackGroundColor;
    _model=[[DDQRCodeScanModel alloc]initWithDictionary:[self dictionaryWithUrlString:self.stringValue] error:nil];
    self.navigationItem.title = @"扫码登录";
    self.navigationItem.leftBarButtonItem = [DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
    [self createSubView];
    [self notifyPC];
}

-(NSDictionary *)dictionaryWithUrlString:(NSString *)urlStr{
    if (urlStr && urlStr.length && [urlStr rangeOfString:@"?"].length == 1) {
        NSArray *array = [urlStr componentsSeparatedByString:@"?"];
        if (array && array.count == 2) {
            NSString *paramsStr = array[1];
            if (paramsStr.length) {
                NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
                NSArray *paramArray = [paramsStr componentsSeparatedByString:@"&"];
                for (NSString *param in paramArray) {
                    if (param && param.length) {
                        NSArray *parArr = [param componentsSeparatedByString:@"="];
                        if (parArr.count == 2) {
                            [paramsDict setObject:parArr[1] forKey:parArr[0]];
                        }
                    }
                }
                return paramsDict;
            }else{
                return nil;
            }
        }else{
            return nil;
        }
    }else{
        return nil;
    }
}

#pragma mark --返回上一页
- (void)leftButtonClick{
    self.cancelBlock();
    [self.navigationController popViewControllerAnimated:YES];
}

//确认登录
-(void)notifyPC{
    //调扫码登录接口
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [params setValue:_model.ticket forKey:@"ticket"];
    //[params setValue:_model.cdt forKey:@"cdt"];
    //[params setValue:_model.expire forKey:@"expire"];
    
    //MBProgressHUD * hud = [DDUtils showHUDCustom:@""];
    [[DDHttpManager sharedInstance]sendPostRequest:KHttpRequest_logInByQRNotifyPC params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"**********通知PC端***************%@",responseObject);

        //__weak __typeof(self) weakSelf=self;
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
//            hud.mode = MBProgressHUDModeCustomView;
//            hud.customView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cer_success"]];
//            hud.labelText=@"扫码登录成功";
//            hud.completionBlock= ^(){
//
//                weakSelf.scanSuccessBlock();
//                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
//
//            };
        }
        else{
            [DDUtils showToastWithMessage:response.message];
        }
        
        //[hud hide:YES afterDelay:KHudShowTimeSecound];
    } failure:^(NSURLSessionDataTask *operation, id responseObject) {
        //hud.labelText = kRequestFailed;
        //[hud hide:YES afterDelay:KHudShowTimeSecound];
        [DDUtils showToastWithMessage:kRequestFailed];
    }];
}

-(void)createSubView{
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-KNavigationBarHeight)];
    bgView.backgroundColor=kColorWhite;
    [self.view addSubview:bgView];
    
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake((Screen_Width-207.5)/2, 60, 207.5, 69)];
    [bgView addSubview:view];
    
    UIImageView *image1=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 42.5, 69)];
    image1.image=[UIImage imageNamed:@"home_codeScan1"];
    [view addSubview:image1];
    
    UIImageView *image2=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(image1.frame)+24, 28.5, 30, 12)];
    image2.image=[UIImage imageNamed:@"home_codeScan2"];
    [view addSubview:image2];
    
    UIImageView *image3=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(image2.frame)+24, 0, 87, 69)];
    image3.image=[UIImage imageNamed:@"home_codeScan3"];
    [view addSubview:image3];
    
    UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(view.frame)+30, Screen_Width, 20)];
    DDUserManager *manager=[DDUserManager sharedInstance];
    NSString *phoneNumber=[manager.mobileNumber stringByReplacingCharactersInRange:NSMakeRange(3, 6) withString:@"******"];
    label1.text=[NSString stringWithFormat:@"即将使用%@登录",phoneNumber];
    label1.textColor=KColorBlackTitle;
    label1.font=kFontSize36;
    label1.textAlignment=NSTextAlignmentCenter;
    [bgView addSubview:label1];
    
    UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(label1.frame)+15, Screen_Width, 15)];
    label2.text=@"请确认是否是本人操作";
    label2.textColor=KColorBlackTitle;
    label2.font=kFontSize32;
    label2.textAlignment=NSTextAlignmentCenter;
    [bgView addSubview:label2];
    
    UIButton *sureBtn=[[UIButton alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(label2.frame)+60, Screen_Width-24, 40)];
    [sureBtn addTarget:self action:@selector(makeSureLogin) forControlEvents:UIControlEventTouchUpInside];
    [sureBtn setBackgroundColor:kColorBlue];
    [sureBtn setTitle:@"确认登录" forState:UIControlStateNormal];
    [sureBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
    sureBtn.titleLabel.font=kFontSize32;
    sureBtn.layer.cornerRadius=3;
    sureBtn.clipsToBounds=YES;
    [bgView addSubview:sureBtn];
    
    
    UIButton *canelBtn=[[UIButton alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(sureBtn.frame)+25, Screen_Width-24, 40)];
    [canelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [canelBtn setBackgroundColor:kColorWhite];
    [canelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [canelBtn setTitleColor:kColorBlue forState:UIControlStateNormal];
    canelBtn.titleLabel.font=kFontSize32;
    canelBtn.layer.borderColor=kColorBlue.CGColor;
    canelBtn.layer.borderWidth=1;
    canelBtn.layer.cornerRadius=3;
    canelBtn.clipsToBounds=YES;
    [bgView addSubview:canelBtn];
}

//确认登录
-(void)makeSureLogin{
    
    //调扫码登录接口
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [params setValue:_model.ticket forKey:@"ticket"];
    [params setValue:_model.cdt forKey:@"cdt"];
    [params setValue:_model.expire forKey:@"expire"];

    MBProgressHUD * hud = [DDUtils showHUDCustom:@""];
    [[DDHttpManager sharedInstance]sendPostRequest:KHttpRequest_logInByQR params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"**********扫码登录接口***************%@",responseObject);

                    __weak __typeof(self) weakSelf=self;
                    DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
                    if (response.isSuccess) {
                        hud.mode = MBProgressHUDModeCustomView;
                        hud.customView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cer_success"]];
                        hud.labelText=@"扫码登录成功";
                        hud.completionBlock= ^(){
        
                            weakSelf.scanSuccessBlock();
                            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        
                        };
                    }
                    else{
                        [DDUtils showToastWithMessage:response.message];
                    }

        [hud hide:YES afterDelay:KHudShowTimeSecound];
    } failure:^(NSURLSessionDataTask *operation, id responseObject) {
        hud.labelText = kRequestFailed;
        [hud hide:YES afterDelay:KHudShowTimeSecound];
    }];
}

//取消
-(void)cancelClick{
    self.cancelBlock();
    [self.navigationController popViewControllerAnimated:YES];
}




@end
