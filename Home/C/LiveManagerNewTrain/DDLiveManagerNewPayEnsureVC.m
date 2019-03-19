//
//  DDLiveManagerNewPayEnsureVC.m
//  GongChengDD
//
//  Created by xzx on 2018/7/26.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDLiveManagerNewPayEnsureVC.h"
#import <ContactsUI/ContactsUI.h>
#import "DDCitySelectPickerView.h"//城市选择View
#import "DDBuildersPayEnsure1Cell.h"//cell
#import "DDBuildersPayEnsure2Cell.h"//cell
#import "DDBuildersPayEnsure3Cell.h"//cell
#import "DDGetPayAddressInfoModel.h"//获取确认订单信息model
#import "DDAddressManagerVC.h"//地址管理页面
#import "DDPayMethodView.h"//支付选择View
#import <AlipaySDK/AlipaySDK.h>
#import "WXApiObject.h"
#import "WXApi.h"
//#import "DDUnInvoiceVC.h"//开发票页面
#import "DDMyTrainVC.h"
#import "NSDictionary+Expanded.h"
#import "DDBuilderPaySucceedVC.h"
@interface DDLiveManagerNewPayEnsureVC ()<UITableViewDelegate,UITableViewDataSource,CNContactPickerDelegate,DDCitySelectPickerViewDelegate,DDPayMethodViewDelegate,UITextFieldDelegate,UITextViewDelegate>

{
    UILabel *_areaLab;
    
    NSString *_mergerName;
    
    NSString *_area;
    NSString *_city;
    NSString *_province;
    NSString *_receiver;
    NSString *_tel;
    NSString *_detail;
    
    UIButton *_payBtn;
    
    DDGetPayAddressInfoModel *_model;
    
    NSInteger _sectionNumber;
    
    MBProgressHUD *_hud;
    
    NSString *_postage;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UITextField *nameTextField;
@property (nonatomic,strong) UITextField *telTextField;
@property (nonatomic,strong) UITextView *addressTextField;
@property (nonatomic,strong) DDCitySelectPickerView *citySelectPickerView;
@property (nonatomic, assign) BOOL isCitySelect;

@end

@implementation DDLiveManagerNewPayEnsureVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _postage=@"";
    _sectionNumber=3;
    self.view.backgroundColor=kColorBackGroundColor;
    self.title=@"确认订单";
    self.navigationItem.leftBarButtonItem=[DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
    [self createTableView];
    [self createPayBtn];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(createPaySuccessView) name:KPaySuccessful object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(jumpToWaitPay) name:KPayNoSuccess object:nil];
    [self getMenuInfoData];
}

//返回上一页
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 获取确认订单信息
-(void)getMenuInfoData{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:self.goodsId forKey:@"agencyMajorId"];
    
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_getPayAddressInfo params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"***********获取确认订单信息***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            _model=[[DDGetPayAddressInfoModel alloc]initWithDictionary:responseObject[KData] error:nil];
            
            if ([DDUtils isEmptyString:_model.postage]) {
                _sectionNumber=1;
                [_tableView reloadData];
                _payBtn.userInteractionEnabled=YES;
                [_payBtn setBackgroundColor:kColorBlue];
            }
            else{
                _postage=_model.postage;
                NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
                [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
                
                _area=_model.area;
                _city=_model.city;
                _province=_model.province;
                _receiver=_model.receiver;
                _tel=_model.tel;
                _detail=_model.detail;
                _mergerName=[NSString stringWithFormat:@"%@%@%@",_model.province,_model.city,_model.area];
                
                _nameTextField.text=_model.receiver;
                _telTextField.text=_model.tel;
                if (![DDUtils isEmptyString:_model.province]) {
                    _areaLab.text=[NSString stringWithFormat:@"%@,%@,%@",_model.province,_model.city,_model.area];
                    _areaLab.textColor=KColorBlackSubTitle;
                }
                _addressTextField.text=_model.detail;
                
                [self requsetPostageByProvince];
                
                if (![DDUtils isEmptyString:_receiver] && ![DDUtils isEmptyString:_tel] && ![DDUtils isEmptyString:_detail] && ![DDUtils isEmptyString:_mergerName]) {
                    _payBtn.userInteractionEnabled=YES;
                    [_payBtn setBackgroundColor:kColorBlue];
                }
                else{
                    _payBtn.userInteractionEnabled=NO;
                    [_payBtn setBackgroundColor:kColor50PercentAlphaBlue];
                }
                if (![DDUtils isEmptyString:self.majorPrice] && ![DDUtils isEmptyString:_postage]) {
                    [_payBtn setTitle:[NSString stringWithFormat:@"确认支付    ¥%ld",self.majorPrice.integerValue+_postage.integerValue] forState:UIControlStateNormal];
                }
                else if ([DDUtils isEmptyString:self.majorPrice] && ![DDUtils isEmptyString:_postage]) {
                    [_payBtn setTitle:[NSString stringWithFormat:@"确认支付    ¥%ld",_postage.integerValue] forState:UIControlStateNormal];
                }
                else if (![DDUtils isEmptyString:self.majorPrice] && [DDUtils isEmptyString:_postage]) {
                    [_payBtn setTitle:[NSString stringWithFormat:@"确认支付    ¥%ld",self.majorPrice.integerValue] forState:UIControlStateNormal];
                }
                else{
                    [_payBtn setTitle:@"确认支付    ¥" forState:UIControlStateNormal];
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

#pragma mark 确认支付按钮
-(void)createPayBtn{
 
    CGFloat  distanceToTop=Screen_Height-KNavigationBarHeight-KTabbarAndHomeIndicatorHeight;
    
    UIView *bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, distanceToTop, Screen_Width, KTabbarHeight)];
    bottomView.backgroundColor=kColorWhite;
    [self.view addSubview:bottomView];
    
    _payBtn=[[UIButton alloc]initWithFrame:CGRectMake(12, 4.5, Screen_Width-24, 40)];
    [_payBtn addTarget:self action:@selector(payClick) forControlEvents:UIControlEventTouchUpInside];
    if (![DDUtils isEmptyString:self.majorPrice]) {
        [_payBtn setTitle:[NSString stringWithFormat:@"确认支付    ¥%ld",(long)[self.majorPrice integerValue]] forState:UIControlStateNormal];
    }
    else{
        [_payBtn setTitle:@"确认支付    ¥" forState:UIControlStateNormal];
    }
    [_payBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
    _payBtn.titleLabel.font=kFontSize32;
    _payBtn.userInteractionEnabled=NO;
    [_payBtn setBackgroundColor:kColor50PercentAlphaBlue];
    _payBtn.layer.cornerRadius=3;
    _payBtn.clipsToBounds=YES;
    [bottomView addSubview:_payBtn];
    
    _citySelectPickerView=[[DDCitySelectPickerView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
    _citySelectPickerView.delegate=self;
    __weak __typeof(self) weakSelf=self;
    _citySelectPickerView.hiddenBlock = ^{
        [weakSelf.citySelectPickerView hidden];
        weakSelf.isCitySelect=NO;
    };
    [_citySelectPickerView show];
}

//创建tableView
-(void)createTableView{
  _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-KNavigationBarHeight-KTabbarAndHomeIndicatorHeight) style:UITableViewStyleGrouped];
    
    [self.view addSubview:_tableView];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle=UITableViewCellSelectionStyleNone;
    _tableView.showsVerticalScrollIndicator=YES;
}

#pragma mark tableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _sectionNumber;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 4;
    }
    else if(section==1){
        return 1;
    }
    else{
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        static NSString * cellID = @"DDBuildersPayEnsure1Cell";
        DDBuildersPayEnsure1Cell * cell = (DDBuildersPayEnsure1Cell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
        }
        
        if (indexPath.row==0) {
            cell.titleLab1.text=@"订单名称";
            cell.titleLab2.text=@"现场施工管理人员新培";
        }
        else if(indexPath.row==1){
            cell.titleLab1.text=@"费用金额";
            if (![DDUtils isEmptyString:self.majorPrice]) {
                cell.titleLab2.text=[NSString stringWithFormat:@"¥%@",self.majorPrice];
            }
            else{
                cell.titleLab2.text=@"";
            }
            cell.titleLab2.textColor=kColorBlue;
        }
        else if(indexPath.row==2){
            cell.titleLab1.text=@"培训机构";
            cell.titleLab2.text=self.agencyName;
        }
        else if(indexPath.row==3){
            cell.titleLab1.text=@"培训人员";
            if ([DDUtils isEmptyString:self.peopleName] && [DDUtils isEmptyString:self.majorName]) {
                cell.titleLab2.text=@"";
            }
            else if(![DDUtils isEmptyString:self.peopleName] && [DDUtils isEmptyString:self.majorName]){
                cell.titleLab2.text=[NSString stringWithFormat:@"%@",self.peopleName];
            }
            else if([DDUtils isEmptyString:self.peopleName] && ![DDUtils isEmptyString:self.majorName]){
                cell.titleLab2.text=[NSString stringWithFormat:@"（%@）",self.majorName];
            }
            else{
                cell.titleLab2.text=[NSString stringWithFormat:@"%@（%@）",self.peopleName,self.majorName];
            }
        }
        
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if(indexPath.section==1){
        static NSString * cellID = @"DDBuildersPayEnsure2Cell";
        DDBuildersPayEnsure2Cell * cell = (DDBuildersPayEnsure2Cell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
        }
        
        if ([DDUtils isEmptyString:_postage]) {
            cell.moneyLab.text=@"";
        }
        else{
            cell.moneyLab.text=[NSString stringWithFormat:@"¥%@",_postage];
        }
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    else{
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        
        [cell.contentView addSubview:[self createAddressInfoView]];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
}

#pragma mark 创建地址View
-(UIView *)createAddressInfoView{
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 47*4+3)];
    bgView.backgroundColor=kColorWhite;
    
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
    _telTextField.delegate = self;
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
    
    _addressTextField=[[UITextView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(nameLab2.frame)+20, 47*3+1*3+3, Screen_Width-24-20-70, 60)];
    _addressTextField.text=@"填写详细地址";
    _addressTextField.delegate = self;
    [_addressTextField setValue:KColorBidApprovalingWait forKeyPath:@"_placeholderLabel.textColor"];
    [_addressTextField setValue:kFontSize30 forKeyPath:@"_placeholderLabel.font"];
    _addressTextField.font=kFontSize30;
    _addressTextField.textColor=KColorSearchPlaceholder;
    
    return bgView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 40;
    }
    else if(indexPath.section==1){
        return 60;
    }
    else{
        return 47*4+3;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==2) {
        UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 47+15)];
        headerView.backgroundColor=[UIColor clearColor];
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(12, 15, 100, 47)];
        label.text=@"接收方式";
        label.textColor=KColorGreySubTitle;
        label.font=kFontSize32;
        [headerView addSubview:label];
        
        UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(Screen_Width-12-15, 16+15, 15, 15)];
        imgView.image=[UIImage imageNamed:@"home_com_more"];
        [headerView addSubview:imgView];
        
        CGRect textFrame= [@"选择/设置默认地址" boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize26} context:nil];
        UIButton *addressBtn=[[UIButton alloc]initWithFrame:CGRectMake(Screen_Width-12-15-5-textFrame.size.width, 15, textFrame.size.width, 47)];
        [addressBtn addTarget:self action:@selector(selectAddressClick) forControlEvents:UIControlEventTouchUpInside];
        [addressBtn setTitle:@"选择/设置默认地址" forState:UIControlStateNormal];
        [addressBtn setTitleColor:kColorBlue forState:UIControlStateNormal];
        addressBtn.titleLabel.font=kFontSize26;
        [headerView addSubview:addressBtn];
        
        return headerView;
    }
    else{
        return nil;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section==0) {
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 20)];
        view.backgroundColor=kColorWhite;
        return view;
    }
    else{
        return nil;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==2) {
        return 47+15;
    }
    else{
        return 15;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0) {
        return 20;
    }
    else{
        return CGFLOAT_MIN;
    }
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
        _payBtn.userInteractionEnabled=YES;
        [_payBtn setBackgroundColor:kColorBlue];
    }
    else{
        _payBtn.userInteractionEnabled=NO;
        [_payBtn setBackgroundColor:kColor50PercentAlphaBlue];
    }
}

#pragma mark 监测联系方式输入框的变化
-(void)observeTelChange:(UITextField *)textField{
    _tel=textField.text;
    
    if (![DDUtils isEmptyString:_receiver] && ![DDUtils isEmptyString:_tel] && ![DDUtils isEmptyString:_detail] && ![DDUtils isEmptyString:_mergerName]) {
        _payBtn.userInteractionEnabled=YES;
        [_payBtn setBackgroundColor:kColorBlue];
    }
    else{
        _payBtn.userInteractionEnabled=NO;
        [_payBtn setBackgroundColor:kColor50PercentAlphaBlue];
    }
}

#pragma mark 监测详细地址输入框的变化
-(void)observeAddressChange:(UITextField *)textField{
    _detail=textField.text;
    
    if (![DDUtils isEmptyString:_receiver] && ![DDUtils isEmptyString:_tel] && ![DDUtils isEmptyString:_detail] && ![DDUtils isEmptyString:_mergerName]) {
        _payBtn.userInteractionEnabled=YES;
        [_payBtn setBackgroundColor:kColorBlue];
    }
    else{
        _payBtn.userInteractionEnabled=NO;
        [_payBtn setBackgroundColor:kColor50PercentAlphaBlue];
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
                [DDUtils showToastWithMessage:@"需要去设置中心设置授权"];
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
        NSLog(@"您未开启通讯录权限,请前往设置中心开启");
        [DDUtils showToastWithMessage:@"您未开启通讯录权限,请前往设置中心开启"];
    }
    
}
#pragma mark CNContactPickerDelegate 代理回调
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty {
    CNContact *contact = contactProperty.contact;
    NSLog(@"%@",contactProperty);
    NSLog(@"givenName: %@, familyName: %@", contact.givenName, contact.familyName);
    
    self.nameTextField.text = [NSString stringWithFormat:@"%@%@",contact.familyName,contact.givenName];
    
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
    
    
    
    _receiver=[NSString stringWithFormat:@"%@%@",contact.familyName,contact.givenName];
    _tel=formatPhoneNumString;
    
    if (![DDUtils isEmptyString:_receiver] && ![DDUtils isEmptyString:_tel] && ![DDUtils isEmptyString:_detail] && ![DDUtils isEmptyString:_mergerName]) {
        _payBtn.userInteractionEnabled=YES;
        [_payBtn setBackgroundColor:kColorBlue];
    }
    else{
        _payBtn.userInteractionEnabled=NO;
        [_payBtn setBackgroundColor:kColor50PercentAlphaBlue];
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
    
    _mergerName=[NSString stringWithFormat:@"%@%@%@",_province,_city,_area];
    
    [self requsetPostageByProvince];
    
    if (![DDUtils isEmptyString:_receiver] && ![DDUtils isEmptyString:_tel] && ![DDUtils isEmptyString:_detail] && ![DDUtils isEmptyString:_mergerName]) {
        _payBtn.userInteractionEnabled=YES;
        [_payBtn setBackgroundColor:kColorBlue];
    }
    else{
        _payBtn.userInteractionEnabled=NO;
        [_payBtn setBackgroundColor:kColor50PercentAlphaBlue];
    }
}

#pragma mark 根据省查邮费
-(void)requsetPostageByProvince{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [params setValue:_province forKey:@"province"];
    [params setValue:@"1" forKey:@"type"];
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_getPostageByRegionId params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"***********根据省查邮费请求数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {//请求成功
            _postage=[NSString stringWithFormat:@"%@",responseObject[KData]];
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
            [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            
            if (![DDUtils isEmptyString:_receiver] && ![DDUtils isEmptyString:_tel] && ![DDUtils isEmptyString:_detail] && ![DDUtils isEmptyString:_mergerName]) {
                _payBtn.userInteractionEnabled=YES;
                [_payBtn setBackgroundColor:kColorBlue];
            }
            else{
                _payBtn.userInteractionEnabled=NO;
                [_payBtn setBackgroundColor:kColor50PercentAlphaBlue];
            }
            if (![DDUtils isEmptyString:self.majorPrice] && ![DDUtils isEmptyString:_postage]) {
                [_payBtn setTitle:[NSString stringWithFormat:@"确认支付    ¥%ld",self.majorPrice.integerValue+_postage.integerValue] forState:UIControlStateNormal];
            }
            else if ([DDUtils isEmptyString:self.majorPrice] && ![DDUtils isEmptyString:_postage]) {
                [_payBtn setTitle:[NSString stringWithFormat:@"确认支付    ¥%ld",_postage.integerValue] forState:UIControlStateNormal];
            }
            else if (![DDUtils isEmptyString:self.majorPrice] && [DDUtils isEmptyString:_postage]) {
                [_payBtn setTitle:[NSString stringWithFormat:@"确认支付    ¥%ld",self.majorPrice.integerValue] forState:UIControlStateNormal];
            }
            else{
                [_payBtn setTitle:@"确认支付    ¥" forState:UIControlStateNormal];
            }
        }
        else{//显示异常
            [DDUtils showToastWithMessage:response.message];
        }
        
    } failure:^(NSURLSessionDataTask *operation, id responseObject) {
        [DDUtils showToastWithMessage:kRequestFailed];
    }];
}

#pragma mark 确认支付
-(void)payClick{
    DDPayMethodView *payMethodView= [[DDPayMethodView alloc]initWithFrame:self.view.window.frame];
    payMethodView.delegate = self;
    
    if (![DDUtils isEmptyString:self.majorPrice] && ![DDUtils isEmptyString:_postage]) {
        payMethodView.money = [NSString stringWithFormat:@"%ld",self.majorPrice.integerValue+_postage.integerValue];
    }
    else if ([DDUtils isEmptyString:self.majorPrice] && ![DDUtils isEmptyString:_postage]) {
        payMethodView.money = [NSString stringWithFormat:@"%ld",_postage.integerValue];
    }
    else if (![DDUtils isEmptyString:self.majorPrice] && [DDUtils isEmptyString:_postage]) {
        payMethodView.money = [NSString stringWithFormat:@"%ld",self.majorPrice.integerValue];
    }
    else{
        payMethodView.money = self.majorPrice;
    }
    [payMethodView show];
}

#pragma mark DDPayMethodViewDelegate代理方法
#pragma mark 选择支付宝
-(void)actionsheetDisappearAliPay:(DDPayMethodView *)actionSheet{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:self.userId forKey:@"userId"];
    [params setValue:@"ALIPAY_MOBILE" forKey:@"channelId"];
    [params setValue:self.goodsId forKey:@"goodsId"];
    [params setValue:@"现场施工管理人员新培" forKey:@"goodsName"];
    
    [params setValue:@"4" forKey:@"goodsType"];
    [params setValue:@"0" forKey:@"billId"];
    [params setValue:self.trainId forKey:@"trainId"];
    [params setValue:self.agencyName forKey:@"trainAgency"];
    
    if ([_model.postage isEqualToString:@"0"] || [DDUtils isEmptyString:_model.postage]) {
        [params setValue:@"0" forKey:@"postage"];
    }
    else{
        [params setValue:@"1" forKey:@"postage"];
    }
    [params setValue:_receiver forKey:@"consignee"];
    [params setValue:_tel forKey:@"contact"];
    [params setValue:_mergerName forKey:@"area"];
    [params setValue:_detail forKey:@"detailedAdd"];
    
    [params setValue:self.certiId forKey:@"certId"];
    [params setValue:self.certiTypeId forKey:@"type"];
    [params setValue:@"" forKey:@"orderDetailType"];
    [params setValue:self.peopleName forKey:@"staffName"];

    if (![DDUtils isValidSpecialWithDictionary:params]) {
        return;
    }
    
    MBProgressHUD * hud = [DDUtils showHUDCustom:@""];
    [[DDHttpManager sharedInstance]sendPostRequest:KHttpRequest_getAliPayInfo params:params success:^(NSURLSessionDataTask *operation, id responseObject){
        NSLog(@"**********获取支付宝支付数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            
            DDUserManager *userManager=[DDUserManager sharedInstance];
            userManager.payOrderId=responseObject[KData][@"payOrderId"];
            userManager.orderId=responseObject[KData][@"orderId"];
            
            //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
            NSString *appScheme = @"aliPayGCDD";
            // NOTE: 调用支付结果开始支付
            [[AlipaySDK defaultService] payOrder:responseObject[KData][@"alipay"] fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                NSLog(@"reslut = %@",resultDic);
                NSInteger resultStatus = [[resultDic stringWithFilted:@"resultStatus"] integerValue];
                if (resultStatus == 9000)
                {
                    
//                    [self allPaySuccess];
                }else{
//                    hud =[DDUtils showHUDCustom:@"支付未完成"];
//                    [hud hide:YES afterDelay:KHudShowTimeSecound];
                    NSLog(@"支付未完成");
                }
                
            }];
        }
        else{
            [DDUtils showToastWithMessage:response.message];
        }
        
        [hud hide:YES afterDelay:KHudShowTimeSecound];
    }  failure:^(NSURLSessionDataTask *operation, id responseObject)  {
        [DDUtils showToastWithMessage:kRequestFailed];
        [hud hide:YES afterDelay:KHudShowTimeSecound];
    }];
}

#pragma mark 选择微信支付
-(void)actionsheetDisappearWeiChatPay:(DDPayMethodView *)actionSheet{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:self.userId forKey:@"userId"];
    [params setValue:@"WX_APP" forKey:@"channelId"];
    [params setValue:self.goodsId forKey:@"goodsId"];
    //[params setValue:@"二级建造师继续教育" forKey:@"goodsName"];
    
    [params setValue:@"4" forKey:@"goodsType"];
    //[params setValue:@"0" forKey:@"billId"];
    [params setValue:self.trainId forKey:@"trainId"];
    //[params setValue:self.agencyName forKey:@"trainAgency"];
    
    if ([_model.postage isEqualToString:@"0"] || [DDUtils isEmptyString:_model.postage]) {
        [params setValue:@"0" forKey:@"postage"];
    }
    else{
        [params setValue:@"1" forKey:@"postage"];
    }
    [params setValue:_receiver forKey:@"consignee"];
    [params setValue:_tel forKey:@"contact"];
    [params setValue:_mergerName forKey:@"area"];
    [params setValue:_detail forKey:@"detailedAdd"];
    
    [params setValue:self.certiId forKey:@"certId"];
    [params setValue:self.certiTypeId forKey:@"type"];
    [params setValue:@"" forKey:@"orderDetailType"];
    [params setValue:self.peopleName forKey:@"staffName"];

    MBProgressHUD * hud = [DDUtils showHUDCustom:@""];
    [[DDHttpManager sharedInstance]sendPostRequest:KHttpRequest_getWeiChatPayInfo params:params success:^(NSURLSessionDataTask *operation, id responseObject){
        NSLog(@"**********请求微信接口***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            
            NSDictionary *dic=responseObject[KData][@"payParams"];
            
            DDUserManager *userManager=[DDUserManager sharedInstance];
            userManager.payOrderId=responseObject[KData][@"payOrderId"];
            userManager.orderId=responseObject[KData][@"orderId"];
            
            //调起微信支付
            PayReq* req= [[PayReq alloc] init];
            req.partnerId=dic[@"partnerid"];
            req.prepayId=dic[@"prepayid"];
            req.nonceStr=dic[@"noncestr"];
            req.timeStamp=[dic[@"timestamp"] intValue];
            req.package=dic[@"package"];
            req.sign=dic[@"sign"];
            
            //通知主线程刷新
            dispatch_async(dispatch_get_main_queue(), ^{
                //回调或者说是通知主线程刷新，
                [WXApi sendReq:req];
                _hud=[DDUtils showHUDCustom:@""];
            });
            
        }
        else{
            [DDUtils showToastWithMessage:response.message];
        }
        
        [hud hide:YES afterDelay:KHudShowTimeSecound];
    }  failure:^(NSURLSessionDataTask *operation, id responseObject)  {
        [DDUtils showToastWithMessage:kRequestFailed];
        [hud hide:YES afterDelay:KHudShowTimeSecound];
    }];
}


#pragma mark 创建支付成功视图
-(void)createPaySuccessView{
    
    [_hud hide:YES];
    DDBuilderPaySucceedVC *succeedVC = [[DDBuilderPaySucceedVC alloc]init];
    DDUserManager *userManager=[DDUserManager sharedInstance];
    succeedVC.orderId=userManager.orderId;
    succeedVC.vcName=@"DDLiveManagerNewAgencySelectVC_DDLiveManagerNewAddApplyRecordVC";
    [self.navigationController pushViewController:succeedVC animated:YES];
    
    
    
//    [_hud hide:YES];
//    UIView *successView=[[UIView alloc]initWithFrame:CGRectMake(0, 15, Screen_Width, Screen_Height-KNavigationBarHeight-15)];
//
//    UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake((Screen_Width-72)/2, 100, 72, 72)];
//    imgView.image=[UIImage imageNamed:@"home_paySuccess"];
//    imgView.layer.cornerRadius=36;
//    imgView.clipsToBounds=YES;
//    [successView addSubview:imgView];
//
//    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imgView.frame)+30, Screen_Width, 20)];
//    label.text=@"支付成功";
//    label.textColor=kColorBlue;
//    label.font=KFontSize42;
//    label.textAlignment=NSTextAlignmentCenter;
//    [successView addSubview:label];
//
//    successView.backgroundColor=kColorWhite;
//    [self.view addSubview:successView];
//
//
//    [self performSelector:@selector(jumpAfterDelay) withObject:self afterDelay:2];
}

//#pragma mark 暂停2秒钟后跳转
//-(void)jumpAfterDelay{
//    DDUserManager *userManager=[DDUserManager sharedInstance];
//    DDUnInvoiceVC *bill=[[DDUnInvoiceVC alloc]init];
//    bill.orderId=userManager.orderId;
//    bill.type=@"1";
//    bill.vcName=@"DDLiveManagerNewAgencySelectVC_DDLiveManagerNewAddApplyRecordVC";
//    [self.navigationController pushViewController:bill animated:YES];
//}

#pragma mark 选择/设置默认地址
-(void)selectAddressClick{
    DDAddressManagerVC *addressManage=[[DDAddressManagerVC alloc]init];
    addressManage.addressSelectBlock = ^(DDAddressManagerModel *model) {
        _area=model.area;
        _city=model.city;
        _province=model.province;
        _receiver=model.receiver;
        _tel=model.tel;
        _detail=model.detail;
        _mergerName=[NSString stringWithFormat:@"%@%@%@",model.province,model.city,model.area];
        
        _nameTextField.text=model.receiver;
        _telTextField.text=model.tel;
        if (![DDUtils isEmptyString:model.province]) {
            _areaLab.text=[NSString stringWithFormat:@"%@,%@,%@",model.province,model.city,model.area];
            _areaLab.textColor=KColorBlackSubTitle;
        }
        _addressTextField.text=model.detail;
        
        
        if (![DDUtils isEmptyString:_receiver] && ![DDUtils isEmptyString:_tel] && ![DDUtils isEmptyString:_detail] && ![DDUtils isEmptyString:_mergerName]) {
            _payBtn.userInteractionEnabled=YES;
            [_payBtn setBackgroundColor:kColorBlue];
        }
        else{
            _payBtn.userInteractionEnabled=NO;
            [_payBtn setBackgroundColor:kColor50PercentAlphaBlue];
        }
    };
    [self.navigationController pushViewController:addressManage animated:YES];
}

#pragma mark 无论是取消支付了还是支付失败了，都跳转到待支付页面
-(void)jumpToWaitPay{
    [_hud hide:YES];
//    DDMyTrainVC *myTrain=[[DDMyTrainVC alloc]init];
//    myTrain.type=@"1";
//    myTrain.vcName=@"DDLiveManagerNewAgencySelectVC_DDLiveManagerNewAddApplyRecordVC";
//    [self.navigationController pushViewController:myTrain animated:YES];
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

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (text.length == 0) {
        if (textView.text.length == 0) {
            textView.text = @"填写详细地址";
            textView.textColor = KColorSearchPlaceholder;
            return NO;
        }
    } else {
        textView.textColor = kColorBlack;
        return YES;
    }
    return YES;
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:KPaySuccessful object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:KPayNoSuccess object:nil];
}


@end
