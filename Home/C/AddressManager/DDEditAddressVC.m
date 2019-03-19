//
//  DDEditAddressVC.m
//  GongChengDD
//
//  Created by xzx on 2018/7/3.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDEditAddressVC.h"
#import <ContactsUI/ContactsUI.h>
#import "DDCitySelectPickerView.h"
#import "DDAddressInfoModel.h"//model
#import "PlaceholdTextView.h"
@interface DDEditAddressVC ()<CNContactPickerDelegate,DDCitySelectPickerViewDelegate,UITextFieldDelegate,PlaceholdTextViewDelegate>

{
    UILabel *_areaLab;
    
    NSString *_mergerName;
    
    NSString *_area;
    NSString *_city;
    NSString *_province;
    NSString *_receiver;
    NSString *_tel;
    NSString *_detail;
    
    UIButton *_saveBtn;
}
@property (nonatomic,strong) UITextField *nameTextField;
@property (nonatomic,strong) UITextField *telTextField;
@property (nonatomic,strong) PlaceholdTextView *addressTextField;
@property (nonatomic,strong) DDCitySelectPickerView *citySelectPickerView;
@property (nonatomic, assign) BOOL isCitySelect;

@end

@implementation DDEditAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isCitySelect=NO;
    self.view.backgroundColor=kColorBackGroundColor;
    self.title=@"编辑地址";
    self.navigationItem.leftBarButtonItem=[DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
    [self createSubviews];
    [self requestData];
}

//返回上一页
- (void)leftButtonClick{
    [_citySelectPickerView hiddenActionSheet];
    [self.navigationController popViewControllerAnimated:YES];
}

//请求地址信息
-(void)requestData{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:self.historyAddressId forKey:@"historyAddressId"];
    
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_addressInfo params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"***********地址详情请求***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            DDAddressInfoModel *model=[[DDAddressInfoModel alloc]initWithDictionary:responseObject[KData] error:nil];
            
            _area=model.area;
            _city=model.city;
            _province=model.province;
            _receiver=model.receiver;
            _tel=model.tel;
            _detail=model.detail;
            _mergerName=[NSString stringWithFormat:@"%@,%@,%@",model.province,model.city,model.area];
            
            _nameTextField.text=model.receiver;
            _telTextField.text=model.tel;
            _areaLab.text=[NSString stringWithFormat:@"%@,%@,%@",model.province,model.city,model.area];
            if (model.detail.length > 0) {
                _addressTextField.textColor = kColorBlack;
            }
            _addressTextField.text=model.detail;
            [_addressTextField setNeedsDisplay];
            _areaLab.textColor=KColorBlackSubTitle;
            if (![DDUtils isEmptyString:_receiver] && ![DDUtils isEmptyString:_tel] && ![DDUtils isEmptyString:_detail] && ![DDUtils isEmptyString:_mergerName]) {
                _saveBtn.userInteractionEnabled=YES;
                [_saveBtn setBackgroundColor:kColorBlue];
            }
            else{
                _saveBtn.userInteractionEnabled=NO;
                [_saveBtn setBackgroundColor:kColor50PercentAlphaBlue];
            }
        }
        else{
            [DDUtils showToastWithMessage:response.message];
        }
        
        
    } failure:^(NSURLSessionDataTask *operation, id responseObject) {
        [DDUtils showToastWithMessage:kRequestFailed];
    }];
}

-(void)createSubviews{
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 15, Screen_Width, 47*4+20)];
    bgView.backgroundColor=kColorWhite;
    [self.view addSubview:bgView];
    
    //收货人
    UILabel *nameLab1=[[UILabel alloc]initWithFrame:CGRectMake(12, 0, 70, 47)];
    nameLab1.text=@"收货人";
    nameLab1.textColor=KColorBlackTitle;
    nameLab1.font=kFontSize32;
    [bgView addSubview:nameLab1];
    
    UIButton *menuBtn=[[UIButton alloc]initWithFrame:CGRectMake(Screen_Width-12-70-5-18, 0, 18+5+70, 47)];
    [menuBtn addTarget:self action:@selector(choosePeopleClick) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *menuImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 14.5, 18, 18)];
    menuImg.image=[UIImage imageNamed:@"home_address_people"];
    [menuBtn addSubview:menuImg];
    UILabel *menuLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(menuImg.frame)+5, 0, 70, 47)];
    menuLab.text=@"选联系人";
    menuLab.textColor=kColorBlue;
    menuLab.font=kFontSize30;
    [menuBtn addSubview:menuLab];
    [bgView addSubview:menuBtn];
    
    _nameTextField=[[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(nameLab1.frame)+20, 0, Screen_Width-24-70-20-10-menuBtn.frame.size.width, 47)];
    _nameTextField.placeholder=@"填写收件人";
    _nameTextField.clearButtonMode=UITextFieldViewModeAlways;
    [_nameTextField setValue:KColorBidApprovalingWait forKeyPath:@"_placeholderLabel.textColor"];
    [_nameTextField setValue:kFontSize30 forKeyPath:@"_placeholderLabel.font"];
    _nameTextField.font=kFontSize30;
    _nameTextField.textColor=KColorBlackSubTitle;
    [_nameTextField addTarget:self action:@selector(observeNameChange:) forControlEvents:UIControlEventEditingChanged];
    
    [bgView addSubview:_nameTextField];
    
    UILabel *line1=[[UILabel alloc]initWithFrame:CGRectMake(12, 47, Screen_Width-12, 1)];
    line1.backgroundColor=KColorTableSeparator;
    [bgView addSubview:line1];
    
    //联系方式
    UILabel *nameLab2=[[UILabel alloc]initWithFrame:CGRectMake(12, 47+1, 70, 47)];
    nameLab2.text=@"联系方式";
    nameLab2.textColor=KColorBlackTitle;
    nameLab2.font=kFontSize32;
    [bgView addSubview:nameLab2];
    
    _telTextField=[[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(nameLab2.frame)+20, 47+1, Screen_Width-24-20-70, 47)];
    _telTextField.placeholder=@"填写手机号";
    _telTextField.clearButtonMode=UITextFieldViewModeAlways;
    [_telTextField setValue:KColorBidApprovalingWait forKeyPath:@"_placeholderLabel.textColor"];
    [_telTextField setValue:kFontSize30 forKeyPath:@"_placeholderLabel.font"];
    _telTextField.font=kFontSize30;
    _telTextField.textColor=KColorBlackSubTitle;
    [_telTextField addTarget:self action:@selector(observeTelChange:) forControlEvents:UIControlEventEditingChanged];
    
    [bgView addSubview:_telTextField];
    
    UILabel *line2=[[UILabel alloc]initWithFrame:CGRectMake(12, 47*2+1, Screen_Width-12, 1)];
    line2.backgroundColor=KColorTableSeparator;
    [bgView addSubview:line2];
    
    
    //所在地区
    UILabel *nameLab3=[[UILabel alloc]initWithFrame:CGRectMake(12, 47*2+1*2, 70, 47)];
    nameLab3.text=@"所在地区";
    nameLab3.textColor=KColorBlackTitle;
    nameLab3.font=kFontSize32;
    [bgView addSubview:nameLab3];
    
    UIButton *areaSelectBtn=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(nameLab3.frame)+20, 47*2+1*2, Screen_Width-24-20-70, 47)];
    [areaSelectBtn addTarget:self action:@selector(areaSelectClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *arrowImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 16, 15, 15)];
    arrowImg.image=[UIImage imageNamed:@"home_search_down"];
    arrowImg.contentMode = UIViewContentModeScaleAspectFit;
    [areaSelectBtn addSubview:arrowImg];
    
    _areaLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(arrowImg.frame)+10, 0, areaSelectBtn.frame.size.width-15-10, 47)];
    _areaLab.text=@"选择地区";
    _areaLab.textColor=KColorBidApprovalingWait;
    _areaLab.font=kFontSize30;
    [areaSelectBtn addSubview:_areaLab];
    
    [bgView addSubview:areaSelectBtn];
    
    UILabel *line3=[[UILabel alloc]initWithFrame:CGRectMake(12, 47*3+1*2, Screen_Width-12, 1)];
    line3.backgroundColor=KColorTableSeparator;
    [bgView addSubview:line3];
    
    
    //详细地址
    UILabel *nameLab4=[[UILabel alloc]initWithFrame:CGRectMake(12, 47*3+1*3, 70, 40)];
    nameLab4.text=@"详细地址";
    nameLab4.textColor=KColorBlackTitle;
    nameLab4.font=kFontSize32;
    [bgView addSubview:nameLab4];
    
    
    
    _addressTextField=[[PlaceholdTextView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(nameLab2.frame)+20, 47*3+1*3+3, Screen_Width-24-20-70, 60)];
    _addressTextField.textViewPlacehold=@"填写详细地址";
    _addressTextField.maxLength = 30;
    _addressTextField.isAddDelegate = YES;
    _addressTextField.dele = self;
    _addressTextField.font=kFontSize30;
    _addressTextField.textColor=KColorBlackTitle;
    [bgView addSubview:_addressTextField];
    
    //保存按钮
    _saveBtn=[[UIButton alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(bgView.frame)+50, Screen_Width-24, 40)];
    _saveBtn.userInteractionEnabled=NO;
    [_saveBtn addTarget:self action:@selector(saveClick) forControlEvents:UIControlEventTouchUpInside];
    [_saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [_saveBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
    [_saveBtn setBackgroundColor:kColor50PercentAlphaBlue];
    _saveBtn.titleLabel.font=kFontSize32;
    _saveBtn.layer.cornerRadius=3;
    _saveBtn.clipsToBounds=YES;
    [self.view addSubview:_saveBtn];
    
    _citySelectPickerView=[[DDCitySelectPickerView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
    _citySelectPickerView.delegate=self;
    __weak __typeof(self) weakSelf=self;
    _citySelectPickerView.hiddenBlock = ^{
        [weakSelf.citySelectPickerView hidden];
        weakSelf.isCitySelect=NO;
    };
    [_citySelectPickerView show];
}

#pragma mark 监测收货人输入框的变化
-(void)observeNameChange:(UITextField *)textField{
    
    UITextRange *selectedRange = textField.markedTextRange;
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    if (position) {
        // 有高亮选择的字 不做任何操作
        return;
    }
    
    if (textField.text.length>8) {
        textField.text = [textField.text substringToIndex:8];
    }
    
    _receiver=textField.text;
    
    if (![DDUtils isEmptyString:_receiver] && ![DDUtils isEmptyString:_tel] && ![DDUtils isEmptyString:_detail] && ![DDUtils isEmptyString:_mergerName]) {
        _saveBtn.userInteractionEnabled=YES;
        [_saveBtn setBackgroundColor:kColorBlue];
    }
    else{
        _saveBtn.userInteractionEnabled=NO;
        [_saveBtn setBackgroundColor:kColor50PercentAlphaBlue];
    }
}

#pragma mark 监测联系方式输入框的变化
-(void)observeTelChange:(UITextField *)textField{
    if(textField.text.length>11){
        textField.text = [textField.text substringToIndex:11];
    }
    _tel=textField.text;
    
    if (![DDUtils isEmptyString:_receiver] && ![DDUtils isEmptyString:_tel] && ![DDUtils isEmptyString:_detail] && ![DDUtils isEmptyString:_mergerName]) {
        _saveBtn.userInteractionEnabled=YES;
        [_saveBtn setBackgroundColor:kColorBlue];
    }
    else{
        _saveBtn.userInteractionEnabled=NO;
        [_saveBtn setBackgroundColor:kColor50PercentAlphaBlue];
    }
}

#pragma mark 监测详细地址输入框的变化
-(void)hasInputText:(NSString *)str{
    _detail=str;
    if (![DDUtils isEmptyString:_receiver] && ![DDUtils isEmptyString:_tel] && ![DDUtils isEmptyString:_detail] && ![DDUtils isEmptyString:_mergerName]) {
        _saveBtn.userInteractionEnabled=YES;
        [_saveBtn setBackgroundColor:kColorBlue];
    }else{
        _saveBtn.userInteractionEnabled=NO;
        [_saveBtn setBackgroundColor:kColor50PercentAlphaBlue];
    }
}

#pragma mark 选联系人
-(void)choosePeopleClick{
    //让用户给权限,没有的话会被拒的各位
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (status == CNAuthorizationStatusNotDetermined) {
        CNContactStore *store = [[CNContactStore alloc] init];
        [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (error) {
                NSLog(@"没有授权, 需要去设置中心设置授权");
            }
            else{
                NSLog(@"用户已授权限");
                CNContactPickerViewController * picker = [CNContactPickerViewController new];
                picker.delegate = self;
                // 加载手机号
                picker.displayedPropertyKeys = @[CNContactPhoneNumbersKey];
                [self presentViewController: picker  animated:YES completion:nil];
            }
        }];
    }
    
    if (status == CNAuthorizationStatusAuthorized) {
        //有权限时
        CNContactPickerViewController * picker = [CNContactPickerViewController new];
        picker.delegate = self;
        picker.displayedPropertyKeys = @[CNContactPhoneNumbersKey];
        [self presentViewController: picker  animated:YES completion:nil];
    }
    else{
        [DDUtils showToastWithMessage:@"您未开启通讯录权限,请前往设置中心开启"];
    }
    
    
}
#pragma mark CNContactPickerDelegate 代理回调
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty {
    CNContact *contact = contactProperty.contact;
    NSLog(@"%@",contactProperty);
    NSLog(@"givenName: %@, familyName: %@", contact.givenName, contact.familyName);
    self.nameTextField.text = [NSString stringWithFormat:@"%@%@",contact.familyName,contact.givenName];
    if (self.nameTextField.text.length>8) {
        self.nameTextField.text = [self.nameTextField.text substringToIndex:8];
    }
    if (![contactProperty.value isKindOfClass:[CNPhoneNumber class]]) {
        NSLog(@"提示用户选择11位的手机号");
        return;
    }
    CNPhoneNumber *phoneNumber = contactProperty.value;
    NSString * Str = phoneNumber.stringValue;
    NSCharacterSet *setToRemove = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"]invertedSet];
    NSString *phoneStr = [[Str componentsSeparatedByCharactersInSet:setToRemove]componentsJoinedByString:@""];
    if (phoneStr.length != 11) {
        NSLog(@"提示用户选择11位的手机号");
    }
    
    NSLog(@"手机号是:%@",phoneStr);
    //处理下手机号里的86,+86
    NSString * formatPhoneNumString = [DDUtils formatPhoneNum:phoneStr];
    self.telTextField.text = formatPhoneNumString;
    
    
    
    _receiver=self.nameTextField.text;
    _tel=formatPhoneNumString;
    
    if (![DDUtils isEmptyString:_receiver] && ![DDUtils isEmptyString:_tel] && ![DDUtils isEmptyString:_detail] && ![DDUtils isEmptyString:_mergerName]) {
        _saveBtn.userInteractionEnabled=YES;
        [_saveBtn setBackgroundColor:kColorBlue];
    }
    else{
        _saveBtn.userInteractionEnabled=NO;
        [_saveBtn setBackgroundColor:kColor50PercentAlphaBlue];
    }
}

#pragma mark 选择地区
-(void)areaSelectClick{
    [self.view endEditing:YES];
    if (_isCitySelect==NO) {
        [_citySelectPickerView noHidden];
        _isCitySelect=YES;
    }
    else{
        [_citySelectPickerView hidden];
        _isCitySelect=NO;
    }
}

#pragma mark CitySelectPickerView代理回调
-(void)actionsheetDisappear:(DDCitySelectPickerView *)actionSheet andAreaInfoDict:(NSDictionary *)dict{
    //NSLog(@"我选中的地区信息是：%@",dict);
    _areaLab.textColor=KColorBlackSubTitle;
    
    _mergerName=dict[@"mergerName"];
    
    _areaLab.text=dict[@"mergerName"];
    _area=dict[@"name"];
    
    NSString *mergerName=dict[@"mergerName"];
    
    if (![DDUtils isEmptyString:mergerName]) {
        if ([mergerName containsString:@","]) {
            NSArray *array=[mergerName componentsSeparatedByString:@","];
            if (array.count>2) {
                _city=array[1];
                _province=array[0];
            }
        }
    }
    
    if (![DDUtils isEmptyString:_receiver] && ![DDUtils isEmptyString:_tel] && ![DDUtils isEmptyString:_detail] && ![DDUtils isEmptyString:_mergerName]) {
        _saveBtn.userInteractionEnabled=YES;
        [_saveBtn setBackgroundColor:kColorBlue];
    }
    else{
        _saveBtn.userInteractionEnabled=NO;
        [_saveBtn setBackgroundColor:kColor50PercentAlphaBlue];
    }
}

#pragma mark 保存点击事件
-(void)saveClick{
    
    _receiver=_nameTextField.text;
    _tel=_telTextField.text;
    _detail=_addressTextField.text;
    
    if (![DDUtils isValidMobilePhone:_tel]) {
        [DDUtils showToastWithMessage:@"请输入正确的手机号！"];
        return;
    }
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    
    [params setValue:_area forKey:@"area"];
    [params setValue:_city forKey:@"city"];
    [params setValue:_province forKey:@"province"];
    [params setValue:_receiver forKey:@"receiver"];
    [params setValue:_tel forKey:@"tel"];
    [params setValue:_detail forKey:@"detail"];
    [params setValue:self.isDefault forKey:@"isDefault"];
    [params setValue:self.historyAddressId forKey:@"historyAddressId"];
    
    MBProgressHUD * hud = [DDUtils showHUDCustom:@""];
    [[DDHttpManager sharedInstance]sendPostRequest:KHttpRequest_editAddress params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"**********编辑地址接口***************%@",responseObject);
        
        __weak __typeof(self) weakSelf=self;
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            hud.mode = MBProgressHUDModeCustomView;
            hud.customView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cer_success"]];
            hud.labelText=@"编辑地址成功";
            hud.completionBlock= ^(){
                
                weakSelf.addBlock();
                [weakSelf.navigationController popViewControllerAnimated:YES];
                
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

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"填写详细地址"]) {
        textView.text = @"";
    }
    return YES;
}


@end
