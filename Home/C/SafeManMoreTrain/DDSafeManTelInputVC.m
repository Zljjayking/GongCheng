//
//  DDSafeManTelInputVC.m
//  GongChengDD
//
//  Created by xzx on 2018/7/14.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDSafeManTelInputVC.h"
#import "DDSafeManAgencySelectVC.h"//机构选择页面

@interface DDSafeManTelInputVC ()<UITextFieldDelegate>

@property (nonatomic,strong) UITextField *telTextField;
@property (nonatomic,strong) UITextField *codeTextField;
@property (nonatomic,strong)UIButton * sendCodeButton;//发送验证码按钮
@property (nonatomic, assign) NSInteger timerCount;
@property (nonatomic, strong) NSTimer *timer;


@end

@implementation DDSafeManTelInputVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=kColorBackGroundColor;
    self.title=@"本人手机号录入";
    self.navigationItem.leftBarButtonItem=[DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
    [self createSubView];
}

//返回上一页
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

//创建视图
-(void)createSubView{
    UILabel *topLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 36)];
    topLab.text=@"    报名考试的通知会及时发送给考生本人";
    topLab.backgroundColor=KColorTextOrange;
    topLab.font=kFontSize26;
    [self.view addSubview:topLab];
    
    
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 36+15, Screen_Width, Screen_Height-KNavigationBarHeight-36-15)];
    bgView.backgroundColor=kColorWhite;
    [self.view addSubview:bgView];
    
    CGRect nameFrame= [self.peopleName boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:KFontSize38} context:nil];
    UILabel *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(12, 48, nameFrame.size.width, 20)];
    nameLab.text=self.peopleName;
    nameLab.textColor=KColorBlackTitle;
    nameLab.font=KFontSize38;
    [bgView addSubview:nameLab];
    
    UILabel *majorLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(nameLab.frame)+5, 48+5, Screen_Width-24-nameFrame.size.width-5, 15)];
    majorLab.text=[NSString stringWithFormat:@"安全员（%@）",self.majorName];
    majorLab.textColor=KColorBlackTitle;
    majorLab.font=kFontSize28;
    [bgView addSubview:majorLab];
    
    
    UILabel *lab1=[[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(nameLab.frame)+48, 50, 20)];
    lab1.text=@"手机号";
    lab1.textColor=KColorBlackTitle;
    lab1.font=kFontSize32;
    [bgView addSubview:lab1];
    
    
    _telTextField=[[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lab1.frame)+20, CGRectGetMaxY(nameLab.frame)+48, Screen_Width-24-50-20, 20)];
    _telTextField.placeholder=@"请输入手机号";
    _telTextField.delegate = self;
    _telTextField.clearButtonMode=UITextFieldViewModeAlways;
    [_telTextField setValue:KColorBidApprovalingWait forKeyPath:@"_placeholderLabel.textColor"];
    [_telTextField setValue:kFontSize32 forKeyPath:@"_placeholderLabel.font"];
    _telTextField.font=kFontSize32;
    _telTextField.textColor=KColorBlackTitle;
    [bgView addSubview:_telTextField];
    
    UILabel *line1=[[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(lab1.frame)+17, Screen_Width-12, 1)];
    line1.backgroundColor=KColorTableSeparator;
    [bgView addSubview:line1];
    
    
    
    UILabel *lab2=[[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(line1.frame)+17, 50, 20)];
    lab2.text=@"验证码";
    lab2.textColor=KColorBlackTitle;
    lab2.font=kFontSize32;
    [bgView addSubview:lab2];
    
    
    _codeTextField=[[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lab2.frame)+20, CGRectGetMaxY(line1.frame)+17, Screen_Width-24-50-20-85-10, 20)];
    _codeTextField.placeholder=@"请输入验证码";
    _codeTextField.clearButtonMode=UITextFieldViewModeAlways;
    [_codeTextField setValue:KColorBidApprovalingWait forKeyPath:@"_placeholderLabel.textColor"];
    [_codeTextField setValue:kFontSize32 forKeyPath:@"_placeholderLabel.font"];
    _codeTextField.font=kFontSize32;
    _codeTextField.textColor=KColorBlackTitle;
    [bgView addSubview:_codeTextField];
    
    
    _sendCodeButton=[[UIButton alloc]initWithFrame:CGRectMake(Screen_Width-12-85, CGRectGetMaxY(line1.frame)+13, 85, 28)];
    [_sendCodeButton addTarget:self action:@selector(sendCodeAction) forControlEvents:UIControlEventTouchUpInside];
    [_sendCodeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
    [_sendCodeButton setBackgroundColor:kColorWhite];
    [_sendCodeButton setTitleColor:kColorBlue forState:UIControlStateNormal];
    _sendCodeButton.titleLabel.font=kFontSize28;
    _sendCodeButton.layer.borderWidth=0.5;
    _sendCodeButton.layer.borderColor=kColorBlue.CGColor;
    _sendCodeButton.layer.cornerRadius=3;
    _sendCodeButton.clipsToBounds=YES;
    [bgView addSubview:_sendCodeButton];
    
    
    UILabel *line2=[[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(lab2.frame)+17, Screen_Width-12, 1)];
    line2.backgroundColor=KColorTableSeparator;
    [bgView addSubview:line2];
    
    
    UIButton *nextBtn=[[UIButton alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(line2.frame)+48, Screen_Width-24, 40)];
    [nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [nextBtn setTitle:@"下一步，选择培训机构" forState:UIControlStateNormal];
    [nextBtn setBackgroundColor:kColorBlue];
    [nextBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
    nextBtn.titleLabel.font=kFontSize32;
    nextBtn.layer.cornerRadius=3;
    nextBtn.clipsToBounds=YES;
    [bgView addSubview:nextBtn];
}



#pragma mark 发送验证码
- (void)sendCodeAction{
    NSString *phoneString  = _telTextField.text;
    
    if ([DDUtils isValidMobilePhone:phoneString]) {//判断手机号是否规范
        [self requestCode:phoneString];
        
    }else{
        [DDUtils showToastWithMessage:KLoginWrongPhone];
    }
}

//发送验证码
- (void)requestCode:(NSString *)phoneString{
    __weak __typeof(self) weakSelf = self;
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setValue:phoneString forKey:@"mobile"];
    [params setObject:@"8" forKey:@"msgtype"];////1 登录密码 ， 2 注册密码 3 重置密码 4 绑定手机验证 5公司转让手机号更改 6我的更换手机号 7我的更换密码 8人员手机号录入
    
    MBProgressHUD * hud = [DDUtils showHUDCustom:@""];
    [[DDHttpManager sharedInstance] sendPostRequest:KHttpRequest_sendVerifyCode params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            hud.labelText = @"发送成功";
            
            weakSelf.timerCount = KCodeTimerCount;
            [weakSelf changeCodeButtonStatus:NO];
            
            weakSelf.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerHandle) userInfo:nil repeats:YES];
            [weakSelf.timer fire];
        }else{
            hud.labelText = response.message;
        }
        [hud hide:YES afterDelay:KHudShowTimeSecound];
    } failure:^(NSURLSessionDataTask *operation, id responseObject) {
        hud.labelText = kRequestFailed;
        [hud hide:YES afterDelay:KHudShowTimeSecound];
    }];
}

//验证码获取倒计时
-(void)timerHandle{
    if (self.timerCount<=0) {
        [self.sendCodeButton setTitle:kSendCode forState:UIControlStateNormal];
        [self changeCodeButtonStatus:YES];//可以重新再发了
        if (self.timer && [self.timer isValid]) {
            [self.timer invalidate];
            self.timer = nil;
        }
    }else {
        self.timerCount --;
        NSString *codeString = [NSString stringWithFormat:@"%ld%@",(long)self.timerCount,kSendCodeResend];
        [self.sendCodeButton setTitle:codeString forState:UIControlStateNormal];
    }
}

//更改发送验证码按钮状态
-(void)changeCodeButtonStatus:(BOOL)canUse{
    if (canUse == YES) {
        self.sendCodeButton.userInteractionEnabled = YES;
        [self.sendCodeButton setBackgroundImage:[UIImage imageNamed:@"sendCode_blue"] forState:UIControlStateNormal];
        [self.sendCodeButton setTitleColor:kColorBlue forState:UIControlStateNormal];
    }else{
        self.sendCodeButton.userInteractionEnabled = NO;
        [self.sendCodeButton setBackgroundImage:[UIImage imageNamed:@"sendCode_gray"] forState:UIControlStateNormal];
        [self.sendCodeButton setTitleColor:KColorBidApprovalingWait forState:UIControlStateNormal];
        
    }
    
}


#pragma mark 下一步点击事件
-(void)nextBtnClick{
    if (![DDUtils isEmptyString:_codeTextField.text]) {//判断验证码是否为空
        
        NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
        [params setValue:_telTextField.text forKey:@"mobile"];
        [params setValue:_codeTextField.text forKey:@"msgcode"];
        [params setValue:self.staffInfoId forKey:@"staffInfoId"];
        
        [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_registerPhoneNumber params:params success:^(NSURLSessionDataTask *operation, id responseObject){
            NSLog(@"**********获取人员的userId数据***************%@",responseObject);
            
            DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
            if (response.isSuccess) {
                
                
                DDSafeManAgencySelectVC *agencySelect=[[DDSafeManAgencySelectVC alloc]init];
                agencySelect.certType=self.certType;
                //agencySelect.trainType=self.trainType;
                
                
                agencySelect.peopleName=self.peopleName;
                agencySelect.majorName=self.majorName;
                agencySelect.certiNo=self.certiNo;
                agencySelect.certiState=self.certiState;
                agencySelect.endTime=self.endTime;
                agencySelect.endDays=self.endDays;
                agencySelect.tel=self.tel;
                
                agencySelect.userId=[NSString stringWithFormat:@"%@",responseObject[KData]];
                
                agencySelect.certiTypeId=self.certiTypeId;
                
                [self.navigationController pushViewController:agencySelect animated:YES];

            }
            else{
                [DDUtils showToastWithMessage:response.message];
            }
            
            
        }  failure:^(NSURLSessionDataTask *operation, id responseObject)  {
            [DDUtils showToastWithMessage:kRequestFailed];
        }];
        
    }else{
        [DDUtils showToastWithMessage:KLoginWrongPhone];
    }
    
    
}

#pragma mark UITextFieldDelegate代理方法
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //编辑过程中随时检测
    if (string.length == 0) {
        if (textField.text.length == 0) {
            return NO;
        }
        textField.text = [textField.text substringToIndex:textField.text.length-1];
    } else {
        textField.text = [textField.text stringByAppendingString:string];
        if (textField == _telTextField) {
            if (textField.text.length > 11) {
                textField.text = [textField.text substringToIndex:11];
            }
        }
    }
    return NO;
}


@end
