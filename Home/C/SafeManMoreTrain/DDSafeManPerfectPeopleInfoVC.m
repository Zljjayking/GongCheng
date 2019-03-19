//
//  DDSafeManPerfectPeopleInfoVC.m
//  GongChengDD
//
//  Created by xzx on 2018/7/25.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDSafeManPerfectPeopleInfoVC.h"
#import "DDTrainInputCompanyNameVC.h"//单位名称选择页面
#import "DDSafeManAgencySelectVC.h"//机构选择页面
#import "DDAgencySelectViewController.h"
#import "DDAgencyPeopleModel.h"
@interface DDSafeManPerfectPeopleInfoVC ()<UITextFieldDelegate>

{
    NSString *_companyId;
    NSString *_newTel;
}
@property (nonatomic,strong) UITextField *cardTextField;
@property (nonatomic,strong) UITextField *telTextField;
@property (nonatomic, strong) UILabel *companyLab;//公司名称Label

@end

@implementation DDSafeManPerfectPeopleInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=kColorBackGroundColor;
    self.title=@"完善人员信息";
    _newTel = _tel;
    self.navigationItem.leftBarButtonItem=[DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
    [self createSubView];
}

//返回上一页
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

//创建视图
-(void)createSubView{
    //创建底层scrollView
    UIScrollView *scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-KNavigationBarHeight)];
    scrollView.backgroundColor=kColorWhite;
    scrollView.contentSize=CGSizeMake(Screen_Width, 15+59+15+301+48+40);
    scrollView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:scrollView];
    
    //背景灰色1
    UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 15)];
    view1.backgroundColor=kColorBackGroundColor;
    [scrollView addSubview:view1];
    
    //人名和专业
    UIView *nameView=[[UIView alloc]initWithFrame:CGRectMake(0, 15, Screen_Width, 59)];
    nameView.backgroundColor=kColorWhite;
    [scrollView addSubview:nameView];
    
    CGRect nameFrame= [self.peopleName boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:KFontSize40Bold} context:nil];
    UILabel *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(12, 19.5, nameFrame.size.width, 20)];
    nameLab.text=self.peopleName;
    nameLab.textColor=KColorBlackTitle;
    nameLab.font=KFontSize40Bold;
    [nameView addSubview:nameLab];
    
    UILabel *majorLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(nameLab.frame)+5, 24, Screen_Width-24-nameFrame.size.width-5, 15)];
    if ([DDUtils isEmptyString:self.majorName]) {
        majorLab.text=@"安全员";
    }
    else{
        majorLab.text=[NSString stringWithFormat:@"安全员（%@）",self.majorName];
    }
    majorLab.textColor=KColorBlackTitle;
    majorLab.font=kFontSize30;
    [nameView addSubview:majorLab];
    
    //背景灰色2
    UIView *view2=[[UIView alloc]initWithFrame:CGRectMake(0, 15+59, Screen_Width, 15)];
    view2.backgroundColor=kColorBackGroundColor;
    [scrollView addSubview:view2];
    
    
    //录入人员信息View
    UIView *peopleInfoView=[[UIView alloc]initWithFrame:CGRectMake(0, 15+59+15, Screen_Width, 244)];
    peopleInfoView.backgroundColor=kColorWhite;
    [self.view addSubview:peopleInfoView];
    
    ////单位名称
    UILabel *lab1=[[UILabel alloc]initWithFrame:CGRectMake(12, 40, 70, 20)];
    lab1.text=@"单位名称";
    lab1.textColor=KColorBlackTitle;
    lab1.font=kFontSize32;
    [peopleInfoView addSubview:lab1];
    
    DDCurrentCompanyModel *currentCompanyModel = [DDUserManager sharedInstance].currentCompanyModel;
    DDScAttestationEntityModel *scAttestationEntityModel = currentCompanyModel.scAttestationEntity;
    _companyLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lab1.frame)+20, 40, Screen_Width-24-70-20-15-10, 20)];
    if ([DDUtils isEmptyString:self.companyName]) {
        _companyLab.text=scAttestationEntityModel.entName;
        _companyName=scAttestationEntityModel.entName;
        _companyId=scAttestationEntityModel.entId;
    }
    else{
        _companyLab.text=self.companyName;
        _companyName=self.companyName;
        _companyId=@"";
    }
    _companyLab.textColor=KColorBlackTitle;
    _companyLab.font=kFontSize32;
    [peopleInfoView addSubview:_companyLab];
    
    UIImageView *arrowImg=[[UIImageView alloc]initWithFrame:CGRectMake(Screen_Width-12-15, 42.5, 15, 15)];
    arrowImg.image=[UIImage imageNamed:@"home_com_more"];
    [peopleInfoView addSubview:arrowImg];
    
    UIButton *companyBtn=[[UIButton alloc]initWithFrame:CGRectMake(12+70, 40, Screen_Width-24-70, 20)];
    [companyBtn addTarget:self action:@selector(companyNameClick) forControlEvents:UIControlEventTouchUpInside];
    [peopleInfoView addSubview:companyBtn];
    
    UILabel *line1=[[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(lab1.frame)+17, Screen_Width-12, 1)];
    line1.backgroundColor=KColorTableSeparator;
    [peopleInfoView addSubview:line1];
    
    ////身份证号
    UILabel *lab2=[[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(line1.frame)+40, 70, 20)];
    lab2.text=@"身份证号";
    lab2.textColor=KColorBlackTitle;
    lab2.font=kFontSize32;
    [peopleInfoView addSubview:lab2];
    
    _cardTextField=[[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lab2.frame)+20, CGRectGetMaxY(line1.frame)+40, Screen_Width-24-70-20, 20)];
    _cardTextField.placeholder=@"请输入考生身份证号码";
    _cardTextField.clearButtonMode=UITextFieldViewModeAlways;
    [_cardTextField setValue:KColorBidApprovalingWait forKeyPath:@"_placeholderLabel.textColor"];
    [_cardTextField setValue:kFontSize32 forKeyPath:@"_placeholderLabel.font"];
    _cardTextField.font=kFontSize32;
    _cardTextField.textColor=KColorBlackTitle;
    _cardTextField.delegate = self;
    _cardTextField.text=self.idCard;
    [peopleInfoView addSubview:_cardTextField];
    
    UILabel *line2=[[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(lab2.frame)+17, Screen_Width-12, 1)];
    line2.backgroundColor=KColorTableSeparator;
    [peopleInfoView addSubview:line2];
    
    ////手机号
    UILabel *lab3=[[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(line2.frame)+17, 70, 20)];
    lab3.text=@"手机号";
    lab3.textColor=KColorBlackTitle;
    lab3.font=kFontSize32;
    [peopleInfoView addSubview:lab3];
    
    _telTextField=[[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lab3.frame)+20, CGRectGetMaxY(line2.frame)+17, Screen_Width-24-70-20, 20)];
    _telTextField.placeholder=@"请输入手机号";
    _telTextField.delegate = self;
    _telTextField.keyboardType = UIKeyboardTypePhonePad;
    _telTextField.clearButtonMode=UITextFieldViewModeAlways;
    [_telTextField setValue:KColorBidApprovalingWait forKeyPath:@"_placeholderLabel.textColor"];
    [_telTextField setValue:kFontSize32 forKeyPath:@"_placeholderLabel.font"];
    _telTextField.font=kFontSize32;
    _telTextField.textColor=KColorBlackTitle;
    _telTextField.text=self.telAfter;
    [peopleInfoView addSubview:_telTextField];
    
    UILabel *line3=[[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(lab3.frame)+17, Screen_Width-12, 1)];
    line3.backgroundColor=KColorTableSeparator;
    [peopleInfoView addSubview:line3];
    
    //tipView
    UIView *tipView=[[UIView alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(line3.frame)+20, Screen_Width-24, 15)];
    UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 15, 15)];
    label1.text=@"*";
    label1.textColor=kColorRed;
    label1.font=kFontSize28;
    [tipView addSubview:label1];
    UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, Screen_Width-24-15, 15)];
    label2.text=@"报名考试的通知会及时发送给考生本人";
    label2.textColor=KColorGreySubTitle;
    label2.font=kFontSize28;
    [tipView addSubview:label2];
    [peopleInfoView addSubview:tipView];
    
    //下一步按钮
    UIView *nextView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(peopleInfoView.frame), Screen_Width, 40+48)];
    [self.view addSubview:nextView];
    
    UIButton *nextBtn=[[UIButton alloc]initWithFrame:CGRectMake(12, 48, Screen_Width-24, 40)];
    [nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [nextBtn setTitle:@"下一步，选择培训机构" forState:UIControlStateNormal];
    [nextBtn setBackgroundColor:kColorBlue];
    [nextBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
    nextBtn.titleLabel.font=kFontSize32;
    nextBtn.layer.cornerRadius=3;
    nextBtn.clipsToBounds=YES;
    [nextView addSubview:nextBtn];
}

#pragma mark 单位名称点击事件
-(void)companyNameClick{
    DDTrainInputCompanyNameVC *companyName=[[DDTrainInputCompanyNameVC alloc]init];
    companyName.contentStr = _companyName;
    companyName.companyBlock = ^(NSString *companyName, NSString *companyId) {
        _companyName=companyName;
        _companyId=companyId;
        _companyLab.text=companyName;
    };
    [self.navigationController pushViewController:companyName animated:YES];
}


#pragma mark 下一步点击事件
-(void)nextBtnClick{
    if(_cardTextField.text.length<18){
        [DDUtils showToastWithMessage:@"请输入正确的考生身份证号码"];
        return;
    }
    if ([DDUtils isEmptyString:_newTel]) {
        [DDUtils showToastWithMessage:@"请输入手机号"];
        return;
    }
    if (![DDUtils isValidMobilePhone:_newTel]) {
        [DDUtils showToastWithMessage:@"请输入正确的手机号"];
        return;
    }
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:_newTel forKey:@"mobile"];
    [params setValue:_cardTextField.text forKey:@"idCard"];
    [params setValue:_companyName forKey:@"employmentEnterprise"];
    [params setValue:self.staffInfoId forKey:@"staffInfoId"];
    
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_registerPhoneNumber params:params success:^(NSURLSessionDataTask *operation, id responseObject){
        NSLog(@"**********获取人员的userId数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            DDAgencySelectViewController *agencySelectVC = [[DDAgencySelectViewController alloc] init];
            agencySelectVC.trainType = DDTrainTypeSafetyOfficerContinue;
            agencySelectVC.userId=[NSString stringWithFormat:@"%@",responseObject[KData]];
            agencySelectVC.certType = self.certType;
            agencySelectVC.isFromeAddApply = @"0";
            DDAgencyPeopleModel *model = [[DDAgencyPeopleModel alloc]init];
            
            model.name=self.peopleName;
            model.speciality=self.majorName;
            model.cert_no=self.certiNo;
            model.cert_state=self.certiState;
            model.validity_period_end=self.endTime;
            model.validity_period_end_days=self.endDays;
            
            model.cert_type_id=self.certiTypeId;
            
            model.tel=_newTel;
            model.id_card=_cardTextField.text;
            model.employment_enterprise=_companyName;
            
            model.staff_info_id=self.staffInfoId;
            agencySelectVC.peopeleModel = model;
            [self.navigationController pushViewController:agencySelectVC animated:YES];
        }
        else{
            [DDUtils showToastWithMessage:response.message];
        }
        
    }  failure:^(NSURLSessionDataTask *operation, id responseObject)  {
        [DDUtils showToastWithMessage:kRequestFailed];
    }];
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
            _newTel = textField.text;
        } else if (textField == _cardTextField) {
            if (textField.text.length > 18) {
                textField.text = [textField.text substringToIndex:18];
            }
        }
    }
    return NO;
}

@end
