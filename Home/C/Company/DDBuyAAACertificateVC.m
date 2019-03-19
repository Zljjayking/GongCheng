//
//  DDBuyAAACertificateVC.m
//  GongChengDD
//
//  Created by csq on 2019/2/25.
//  Copyright © 2019 Koncendy. All rights reserved.
//

#import "DDBuyAAACertificateVC.h"
#import "DDFindingCondition2Cell.h"//cell
#import "DDDownloadReportCell.h"
#import "DDBuyReportCell.h"
#import "DDBuyMethodCell.h"
#import "PlaceholdTextView.h"
#import "DDAddressManagerModel.h"
#import "DDInvoiceInfoModel.h"
#import <ContactsUI/ContactsUI.h>
#import "DDAddressManagerVC.h"
#import "DDCitySelectPickerView.h"
#import "DDBuyCreditReportSuccessVC.h"
#import <AlipaySDK/AlipaySDK.h>
#import <WXApi.h>
#import "DDNoResult2View.h"
@interface DDBuyAAACertificateVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,PlaceholdTextViewDelegate,CNContactPickerDelegate,DDCitySelectPickerViewDelegate>
{
    NSString *_myEmail;
    UILabel *_areaLab;
    NSString *_mergerName;
    NSString *_area;
    NSString *_city;
    NSString *_province;
    NSString *_receiver;
    NSString *_tel;
    NSString *_detail;
    UIButton *_payBtn;
    NSInteger _sectionNumber;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger payMethod;//支付方式 1支付宝 2微信支付
@property (nonatomic,strong) UITextField *nameTextField;
@property (nonatomic,strong) UITextField *telTextField;
@property (nonatomic, strong) UIButton *buyBtn;//支付按钮
@property (nonatomic,strong) PlaceholdTextView *addressTextField;
@property (nonatomic,strong)DDInvoiceInfoModel * invoiceInfModel;//发票所需信息model;
@property (nonatomic,strong) DDCitySelectPickerView *citySelectPickerView;
@property (nonatomic,assign) BOOL isPaySuccess;//是否支付成功
@property (nonatomic,strong) DataLoadingView *loadingView;
@property (nonatomic,strong) DDNoResult2View *noResultView;//无数据视图
///
@property (nonatomic, assign) BOOL isCitySelect;

@end

@implementation DDBuyAAACertificateVC
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(createPaySuccessView) name:KPaySuccessful object:nil];
    //监听支付取消
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payCancelAction) name:KPayNoSuccess object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _myEmail=self.email;
    self.isPaySuccess = NO;
    if (![DDUtils isEmptyString:[DDUserManager sharedInstance].email]){
        _myEmail = [DDUserManager sharedInstance].email;
    }
    else if([[NSUserDefaults standardUserDefaults]objectForKey:[DDUserManager sharedInstance].mobileNumber]){
        _myEmail = [[NSUserDefaults standardUserDefaults]objectForKey:[DDUserManager sharedInstance].mobileNumber];
    }
    
    self.view.backgroundColor=kColorBackGroundColor;
    self.title=@"购买证书";
    self.navigationItem.leftBarButtonItem=[DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
    self.payMethod = 1;
    
    [self createUI];
    [self setupDataLoadingView];
}

- (void)createUI {
    
    UIView *bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, Screen_Height-KNavigationBarHeight-49-KHomeIndicatorHeight, Screen_Width, 49)];
    bottomView.backgroundColor=kColorWhite;
    UIButton *buyBtn=[[UIButton alloc]initWithFrame:CGRectMake(Screen_Width-130*Scale, 0, 130*Scale, 49)];
    [buyBtn setBackgroundColor:KColorFindingPeopleBlue];
    buyBtn.titleLabel.font=kFontSize32;
    [buyBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
    [buyBtn setTitle:@"确认支付" forState:UIControlStateNormal];
    [buyBtn addTarget:self action:@selector(buyClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:buyBtn];
    buyBtn.alpha = 0.5;
    buyBtn.enabled = NO;
    self.buyBtn = buyBtn;
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(12, 15, 60, 19)];
    lab.text = @"支付金额";
    lab.font = kFontSize28;
    lab.textColor = UIColorFromRGB(0x999999);
    [bottomView addSubview:lab];
    
    UILabel *priceLb = [[UILabel alloc] initWithFrame:CGRectMake(72, 15, Screen_Width-84-130*Scale, 19)];
    priceLb.textColor = KColorFindingPeopleBlue;
    priceLb.font = kFontSize36;
    priceLb.text = [NSString stringWithFormat:@"¥%@",self.price];
    [bottomView addSubview:priceLb];
    
    [self.view addSubview:bottomView];
    
    _citySelectPickerView=[[DDCitySelectPickerView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
    _citySelectPickerView.delegate=self;
    kWeakSelf
    _citySelectPickerView.hiddenBlock = ^{
        [weakSelf.citySelectPickerView hidden];
        weakSelf.isCitySelect=NO;
    };
    [_citySelectPickerView show];
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-KNavigationBarHeight-49-KHomeIndicatorHeight) style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.separatorColor=KColorTableSeparator;
    _tableView.backgroundColor = kColorBackGroundColor;
    _tableView.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
    
    
    
    [self requestDefaultAreaData];
}
- (void)setupDataLoadingView{
    _noResultView=[[DDNoResult2View alloc]initWithFrame:CGRectMake(0,0, Screen_Width, Screen_Height-KNavigationBarHeight)];
    [self.tableView addSubview:_noResultView];
    
    __weak __typeof(self) weakSelf = self;
    _loadingView = [[DataLoadingView alloc] initWithController:self];
    _loadingView.loadingTitle = KLoading;
    _loadingView.failureTitle = KLoadingFailure;
    _loadingView.reloadHandle = ^(void){
        [weakSelf requestDefaultAreaData];
    };
    [_loadingView showLoadingView];
}
- (void)leftButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark tableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 1;
            break;
        default:
            return 3;
            break;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            return 47;
        }
        return 60;
    }else if (indexPath.section == 1){
        return 47*4+4;
    }
    return 47;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 47)];
        headerView.backgroundColor=[UIColor clearColor];
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(12,((47-20)/2), 120, 20)];
        label.text=@"接收方式";
        label.textColor=KColorGreySubTitle;
        label.font=kFontSize28;
        [headerView addSubview:label];
        
        UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(Screen_Width-12-15, ((47-15)/2), 15, 15)];
        imgView.image=[UIImage imageNamed:@"home_com_more"];
        [headerView addSubview:imgView];
        
        CGRect textFrame= [@"选择/设置默认地址" boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize26} context:nil];
        UIButton *addressBtn=[[UIButton alloc]initWithFrame:CGRectMake(Screen_Width-12-15-5-textFrame.size.width, 0, textFrame.size.width, 47)];
        [addressBtn addTarget:self action:@selector(selectAddressClick) forControlEvents:UIControlEventTouchUpInside];
        [addressBtn setTitle:@"选择/设置默认地址" forState:UIControlStateNormal];
        [addressBtn setTitleColor:kColorBlue forState:UIControlStateNormal];
        addressBtn.titleLabel.font=kFontSize26;
        [headerView addSubview:addressBtn];
        if (self.type == 2) {
            addressBtn.enabled = NO;
        }
        return headerView;
    }
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 47;
    }
    return 15;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

//-(void)textFieldDidEndEditing:(UITextField *)textField{
//    _myEmail=textField.text;
//    [[NSUserDefaults standardUserDefaults]setObject:_myEmail forKey:[DDUserManager sharedInstance].mobileNumber];
//}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString * actionCellID = @"DDDownloadReportCell";
        DDDownloadReportCell *cell = (DDDownloadReportCell*)[tableView dequeueReusableCellWithIdentifier:actionCellID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:actionCellID owner:self options:nil] firstObject];
        }
        
        if (indexPath.row==0) {
            cell.textLab.text=@"企业信用等级证书";
            cell.textLab.textColor=KColorBlackTitle;
            cell.textLab.font=kFontSize34;
            
            cell.imgView.hidden=YES;
            cell.detailTextLab.hidden=YES;
        }else{
            cell.textLab.text=self.enterpriseName;
            cell.textLab.textColor=KColorGreySubTitle;
            cell.textLab.font=kFontSize30;
            
            cell.imgView.hidden=YES;
            cell.detailTextLab.hidden=YES;
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 1){
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        
        [cell.contentView addSubview:[self createAddressInfoView]];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
        
    }else {
        if (indexPath.row == 0) {
            static NSString * actionCellID = @"DDDownloadReportCell";
            DDDownloadReportCell *cell = (DDDownloadReportCell*)[tableView dequeueReusableCellWithIdentifier:actionCellID];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle]loadNibNamed:actionCellID owner:self options:nil] firstObject];
            }
            cell.textLab.text=@"支付方式";
            cell.textLab.textColor=KColorBlackTitle;
            cell.textLab.font=kFontSize34;
            
            cell.imgView.hidden=YES;
            cell.detailTextLab.hidden=YES;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else {
            static NSString * actionCellID = @"DDBuyMethodCell";
            DDBuyMethodCell *cell = (DDBuyMethodCell*)[tableView dequeueReusableCellWithIdentifier:actionCellID];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle]loadNibNamed:actionCellID owner:self options:nil] firstObject];
            }
            
            cell.methodTitle.font = kFontSize32;
            cell.isSelectImage.image = [UIImage imageNamed:@"completeOrder_notSelected"];
            if (self.payMethod == 1) {
                if (indexPath.row == 1) {
                    cell.isSelectImage.image = [UIImage imageNamed:@"completeOrder_selected"];
                }else if (indexPath.row == 2) {
                    cell.isSelectImage.image = [UIImage imageNamed:@"completeOrder_notSelected"];
                }
            }else if(self.payMethod == 2){
                if (indexPath.row == 1) {
                    cell.isSelectImage.image = [UIImage imageNamed:@"completeOrder_notSelected"];
                }else if (indexPath.row == 2) {
                    cell.isSelectImage.image = [UIImage imageNamed:@"completeOrder_selected"];
                }
            }
            
            if (indexPath.row == 1) {
                cell.methodImage.image = [UIImage imageNamed:@"home_pay_alipay"];
                cell.methodTitle.text = @"支付宝";
                
            }else {
                cell.methodImage.image = [UIImage imageNamed:@"home_pay_weichat"];
                cell.methodTitle.text = @"微信支付";
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2 && indexPath.row != 0) {
        self.payMethod = indexPath.row;
        NSIndexPath *indexp = [NSIndexPath indexPathForRow:1 inSection:indexPath.section];
        NSIndexPath *indexp2 = [NSIndexPath indexPathForRow:2 inSection:indexPath.section];
        [tableView reloadRowsAtIndexPaths:@[indexp,indexp2] withRowAnimation:UITableViewRowAnimationNone];
    }
}
//- (void)textChanged:(UITextField *)textField {
//    
//}


#pragma mark 创建地址View
-(UIView *)createAddressInfoView{
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 47*4+4)];
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
    UILabel *menuLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(menuImg.frame)+8, 0, 70, 47)];
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
    
    UILabel *line1=[[UILabel alloc]initWithFrame:CGRectMake(0, 47, Screen_Width, 0.7)];
    line1.backgroundColor=UIColorFromRGB(0xEFF0FA);
    [bgView addSubview:line1];
    
    //联系方式
    UILabel *nameLab2=[[UILabel alloc]initWithFrame:CGRectMake(12, 47+1, 70, 47)];
    nameLab2.text=@"联系方式";
    nameLab2.textColor=KColorBlackTitle;
    nameLab2.font=kFontSize32;
    [bgView addSubview:nameLab2];
    
    _telTextField=[[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(nameLab2.frame)+20, 47+3, Screen_Width-24-20-70, 47)];
    _telTextField.placeholder=@"填写手机号";
    _telTextField.delegate = self;
    _telTextField.clearButtonMode=UITextFieldViewModeAlways;
    [_telTextField setValue:KColorBidApprovalingWait forKeyPath:@"_placeholderLabel.textColor"];
    [_telTextField setValue:kFontSize30 forKeyPath:@"_placeholderLabel.font"];
    _telTextField.font=kFontSize30;
    _telTextField.textColor=KColorBlackSubTitle;
    [_telTextField addTarget:self action:@selector(observeTelChange:) forControlEvents:UIControlEventEditingChanged];
    
    [bgView addSubview:_telTextField];
    
    UILabel *line2=[[UILabel alloc]initWithFrame:CGRectMake(0, 47*2+1, Screen_Width-0, 0.7)];
    line2.backgroundColor=UIColorFromRGB(0xEFF0FA);
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
    
    UILabel *line3=[[UILabel alloc]initWithFrame:CGRectMake(0, 47*3+1*2, Screen_Width-0, 0.7)];
    line3.backgroundColor=UIColorFromRGB(0xEFF0FA);
    [bgView addSubview:line3];
    
    
    //详细地址
    UILabel *nameLab4=[[UILabel alloc]initWithFrame:CGRectMake(12, 47*3+1*3, 70, 47)];
    nameLab4.text=@"详细地址";
    nameLab4.textColor=KColorBlackTitle;
    nameLab4.font=kFontSize32;
    [bgView addSubview:nameLab4];
    
    _addressTextField=[[PlaceholdTextView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(nameLab2.frame)+16, 47*3+1*3+3+2, Screen_Width-24-20-70, 45)];
    _addressTextField.backgroundColor = [UIColor clearColor];
    _addressTextField.textViewPlacehold=@"填写详细地址";
    _addressTextField.isAddDelegate = YES;
    _addressTextField.maxLength = 30;
    _addressTextField.dele = self;
    //    [_addressTextField setValue:KColorBidApprovalingWait forKeyPath:@"_placeholderLabel.textColor"];
    //    [_addressTextField setValue:kFontSize30 forKeyPath:@"_placeholderLabel.font"];
    _addressTextField.font=kFontSize30;
    _addressTextField.textColor=KColorBlackTitle;
    [bgView addSubview:_addressTextField];
    
    if (self.type == 2) {
        _nameTextField.text=self.orderModel.consignee;
        _telTextField.text = self.orderModel.contact;
        _areaLab.text = self.orderModel.address;
        _addressTextField.text = self.orderModel.detail_address;
        _addressTextField.holdLabel.hidden = YES;
        _areaLab.textColor = kColorBlack;
        self.buyBtn.alpha = 1;
        self.buyBtn.enabled = YES;
        
        _nameTextField.userInteractionEnabled = NO;
        _telTextField.userInteractionEnabled = NO;
        areaSelectBtn.enabled = NO;
        _addressTextField.editable = NO;
        menuBtn.userInteractionEnabled = NO;
    }
    //赋值下
//    [self setupReceiveViewContent];
    
    return bgView;
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
    
//    [self checkSumitStatesWithPageInvoice];
}

#pragma mark 请求默认地址数据
- (void)requestDefaultAreaData{
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:@"1" forKey:@"current"];
    [params setValue:@"10" forKey:@"size"];
    
    
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_addressManagerList params:params success:^(NSURLSessionDataTask *operation, id responseObject){
        NSLog(@"**********地址列表结果数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
//        __weak __typeof(self) weakSelf = self;
        if (response.isSuccess) {
            
            [_loadingView hiddenLoadingView];
            _noResultView.hidden = YES;
            NSDictionary *dataDic = responseObject[KData];
//            NSInteger pageCount = [dataDic[@"totalCount"] integerValue];
            NSArray *listArr=dataDic[@"list"];
            
            
            if (listArr.count!=0) {
                
                NSDictionary *dic = listArr[0];
                DDAddressManagerModel *model = [[DDAddressManagerModel alloc]initWithDictionary:dic error:nil];
                if ([model.is_default isEqualToString:@"1"]) {
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
                    _addressTextField.holdLabel.hidden = YES;
                    if (![DDUtils isEmptyString:_receiver] && ![DDUtils isEmptyString:_tel] && ![DDUtils isEmptyString:_detail] && ![DDUtils isEmptyString:_area] && ![DDUtils isEmptyString:_city] && ![DDUtils isEmptyString:_province] ) {
                        self.buyBtn.alpha = 1;
                        self.buyBtn.enabled = YES;
                    }
                }
                
            }
            
        }
        else{
            [_loadingView failureLoadingView];
        }
        
//        [_tableView reloadData];
        
    }  failure:^(NSURLSessionDataTask *operation, id responseObject)  {
        [DDUtils showToastWithMessage:kRequestFailed];
        [_loadingView failureLoadingView];
    }];
}

#pragma mark 选择/设置默认地址
-(void)selectAddressClick{
    [self.view endEditing:YES];
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
        _addressTextField.holdLabel.hidden = YES;
        if (![DDUtils isEmptyString:_receiver] && ![DDUtils isEmptyString:_tel] && ![DDUtils isEmptyString:_detail] && ![DDUtils isEmptyString:_area] && ![DDUtils isEmptyString:_city] && ![DDUtils isEmptyString:_province] ) {
            self.buyBtn.alpha = 1;
            self.buyBtn.enabled = YES;
        }
    };
    [self.navigationController pushViewController:addressManage animated:YES];
}
#pragma mark 监测联系方式输入框的变化
-(void)observeTelChange:(UITextField *)textField{
    
    if (textField.text.length > 11) {
        textField.text = [textField.text substringToIndex:11];
    }
    _tel=textField.text;
    if (![DDUtils isEmptyString:_receiver] && ![DDUtils isEmptyString:_tel] && ![DDUtils isEmptyString:_detail] && ![DDUtils isEmptyString:_area] && ![DDUtils isEmptyString:_city] && ![DDUtils isEmptyString:_province] ) {
        self.buyBtn.alpha = 1;
        self.buyBtn.enabled = YES;
    }else {
        if (self.type != 2) {
            self.buyBtn.alpha = 0.5;
            self.buyBtn.enabled = NO;
        }
        
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
    if (![DDUtils isEmptyString:_receiver] && ![DDUtils isEmptyString:_tel] && ![DDUtils isEmptyString:_detail] && ![DDUtils isEmptyString:_area] && ![DDUtils isEmptyString:_city] && ![DDUtils isEmptyString:_province] ) {
        self.buyBtn.alpha = 1;
        self.buyBtn.enabled = YES;
    }else {
        if (self.type != 2) {
            self.buyBtn.alpha = 0.5;
            self.buyBtn.enabled = NO;
        }
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
#pragma mark DDCitySelectPickerViewDelegate 代理回调
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
    
    if (![DDUtils isEmptyString:_receiver] && ![DDUtils isEmptyString:_tel] && ![DDUtils isEmptyString:_detail] && ![DDUtils isEmptyString:_mergerName]) {
        self.buyBtn.alpha = 1;
        self.buyBtn.enabled = YES;
    }
    else{
        self.buyBtn.alpha = 0.5;
        self.buyBtn.enabled = NO;
    }
}
-(void)hasInputText:(NSString *)str{
    _detail=str;
    if (str.length > 0) {
        _addressTextField.holdLabel.hidden = YES;
    }else {
        _addressTextField.holdLabel.hidden = NO;
    }
    if (![DDUtils isEmptyString:_receiver] && ![DDUtils isEmptyString:_tel] && ![DDUtils isEmptyString:_detail] && ![DDUtils isEmptyString:_area] && ![DDUtils isEmptyString:_city] && ![DDUtils isEmptyString:_province] ) {
        self.buyBtn.alpha = 1;
        self.buyBtn.enabled = YES;
    }else {
        if (self.type != 2) {
            self.buyBtn.alpha = 0.5;
            self.buyBtn.enabled = NO;
        }
    }
}

#pragma mark 根据省查邮费
-(void)requsetPostageByProvince{
    if ([DDUtils isEmptyString:_province]) {
        return;
    }
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [params setValue:_province forKey:@"province"];
    [params setValue:@"1" forKey:@"type"];
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_getPostageByRegionId params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"***********根据省查邮费请求数据***************%@",responseObject);
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {//请求成功
            _invoiceInfModel.invoice_postage=[NSString stringWithFormat:@"%@",responseObject[KData]];
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:2];
            [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        else{//显示异常
            [DDUtils showToastWithMessage:response.message];
        }
        
    } failure:^(NSURLSessionDataTask *operation, id responseObject) {
        [DDUtils showToastWithMessage:kRequestFailed];
    }];
}
#pragma mark 支付购买AAA证书
- (void)buyClick {
    NSString *channelId = @"ALIPAY_MOBILE";
    
    if (self.payMethod == 2) {
        channelId = @"WX_APP";
    }
    NSDictionary *parameter = @{@"enterpriseId":self.enterpriseId,@"entName":self.enterpriseName,@"buyingPrice":self.price,@"oldPrice":@"3990",@"shareNumber":self.invitedCount,@"receiver":_receiver,@"tel":_tel,@"province":_province,@"city":_city,@"area":_area,@"detail":_detail,@"channelId":channelId};
    
    if (![DDUtils isValidSpecialWithDictionary:parameter]) {
        return;
    }
    
    MBProgressHUD * hud = [DDUtils showHUDCustom:@""];
    [[DDHttpManager sharedInstance] sendPostRequest:KHttpRequest_payCredit params:parameter success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"**********请求购买AAA证书数据***************\n%@",responseObject);
        [hud hide:YES];
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            DDUserManager *userManager=[DDUserManager sharedInstance];
            userManager.payOrderId=responseObject[KData][@"payOrderId"];
            userManager.orderId=responseObject[KData][@"orderId"];
            self.orderID = responseObject[KData][@"orderId"];
            if (self.payMethod == 1) {
                //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
                NSString *appScheme = @"aliPayGCDD";
                // NOTE: 调用支付结果开始支付
                [[AlipaySDK defaultService] payOrder:responseObject[KData][@"alipay"] fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                    NSLog(@"支付成功的信息***===reslut = %@",resultDic);
                    if ([resultDic[@"resultStatus"] integerValue] == 9000) {
                        [self createPaySuccessView];
                    }else{
                        [self payCancelAction];
                    }
                }];
            }else {
                NSDictionary *dic=responseObject[KData][@"payParams"];
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
                });
            }
        }
        else{
            [DDUtils showToastWithMessage:response.message];
        }
    } failure:^(NSURLSessionDataTask *operation, id responseObject) {
        [hud hide:YES];
        [DDUtils showToastWithMessage:kRequestFailed];
    }];
}
#pragma mark 支付成功
- (void)createPaySuccessView {
    self.isPaySuccess = YES;
    if (self.refreshChoose) {
        self.refreshChoose();
    }
    DDBuyCreditReportSuccessVC *vc = [[DDBuyCreditReportSuccessVC alloc] init];
    if (self.type == 2) {
        vc.type = 3;
    }else if (self.type == 3){
        vc.type = 8;
    }else {
        vc.type = 2;
    }
    vc.orderID = self.orderID;
    [self.navigationController pushViewController:vc animated:YES];
}
//支付取消
- (void)payCancelAction{
    if (self.refreshChoose) {
        self.refreshChoose();
    }
    if (self.payMethod == 1) {
        
        [DDUtils showToastWithMessage:@"支付宝支付已取消"];
    }else {
        
        [DDUtils showToastWithMessage:@"微信支付已取消"];
    }
}
//支付失败
//- (void)payFailAction{
//    //支付成功,有多个,区分下
////    DDUserManager * userManger = [DDUserManager sharedInstance];
//
//    MBProgressHUD * hud = [DDUtils showHUDCustom:@""];
//    hud.mode = MBProgressHUDModeCustomView;
//    hud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"myinfo_saveSuccess"]];
//    hud.labelText = @"支付失败";
//    [hud hide:YES afterDelay:KHudShowTimeSecound];
//    //    if ([_payResultOrderid isEqualToString:userManger.orderId]) {
//    //是当前页面的支付
//    //         [self submmitPageInvicoeAction:@"-1"];
//    //    }
//}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.isPaySuccess) {
        if (self.type == 2) {
            if (self.refreshBlock) {
                self.refreshBlock();
            }
        }
    }
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KPaySuccessful object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KPayNoSuccess object:nil];
}
- (void)dealloc {
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
