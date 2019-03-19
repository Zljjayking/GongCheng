//
//  DDBuyCreditReportVC.m
//  GongChengDD
//
//  Created by csq on 2019/2/22.
//  Copyright © 2019 Koncendy. All rights reserved.
//

#import "DDBuyCreditReportVC.h"
#import "DDFindingCondition2Cell.h"//cell
#import "DDDownloadReportCell.h"
#import "DDBuyReportCell.h"
#import "DDBuyMethodCell.h"

#import "DDBuyCreditReportSuccessVC.h"
#import <AlipaySDK/AlipaySDK.h>
#import <WXApi.h>
@interface DDBuyCreditReportVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    NSString *_myEmail;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger payMethod;//支付方式 1支付宝 2微信支付
@property (nonatomic, strong) UIButton *buyBtn;
@property (nonatomic,assign) BOOL isPaySuccess;//是否支付成功
@end

@implementation DDBuyCreditReportVC
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(createPaySuccessView) name:KPaySuccessful object:nil];
    //监听支付取消
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payCancelAction) name:KPayCancel object:nil];
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
    self.title=@"购买报告";
    self.navigationItem.leftBarButtonItem=[DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
    self.payMethod = 1;
    if (self.type == 2) {
        _myEmail = self.orderModel.rechargeNum;
        _orderID = self.orderModel.orderId;
        _enterpriseName = self.orderModel.cardname;
        _price = [@"¥" stringByAppendingString:self.orderModel.amount];
    }
    [self createUI];
}

- (void)createUI {
    
    UIView *bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, Screen_Height-KNavigationBarHeight-49-KHomeIndicatorHeight, Screen_Width, 49)];
    bottomView.backgroundColor=kColorWhite;
    UIButton *setBtn=[[UIButton alloc]initWithFrame:CGRectMake(Screen_Width-130*Scale, 0, 130*Scale, 49)];
    [setBtn setBackgroundColor:KColorFindingPeopleBlue];
    setBtn.titleLabel.font=kFontSize32;
    [setBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
    [setBtn setTitle:@"确认支付" forState:UIControlStateNormal];
    if ([DDUtils isEmptyString:_myEmail]) {
        setBtn.alpha = 0.5;
        setBtn.enabled = NO;
    }
    
    [setBtn addTarget:self action:@selector(buyClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:setBtn];
    self.buyBtn = setBtn;
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(12, 15, 60, 19)];
    lab.text = @"支付金额";
    lab.font = kFontSize28;
    lab.textColor = UIColorFromRGB(0x999999);
    [bottomView addSubview:lab];
    
    UILabel *priceLb = [[UILabel alloc] initWithFrame:CGRectMake(72, 15, Screen_Width-84-130*Scale, 19)];
    priceLb.textColor = KColorFindingPeopleBlue;
    priceLb.font = kFontSize36;
    priceLb.text = self.price;
    [bottomView addSubview:priceLb];
    
    [self.view addSubview:bottomView];
    
    
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-KNavigationBarHeight-57.5-KHomeIndicatorHeight) style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=kColorBackGroundColor;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.separatorColor=KColorTableSeparator;
    _tableView.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
}
- (void)leftButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)buyClick {
    if ([DDUtils isValidEmail:_myEmail]) {
        NSString *channelId = @"ALIPAY_MOBILE";
        
        if (self.payMethod == 2) {
            channelId = @"WX_APP";
        }
        if (self.type == 2) {
            NSDictionary *parameter = @{@"orderId":self.orderID,@"channelId":channelId};
            MBProgressHUD * hud = [DDUtils showHUDCustom:@""];
            NSString *request;
            if (self.payMethod == 1) {
                request = KHttpRequrest_payGoodsorderToAliPrePay;
            }else {
                request = KhttpRequest_payGgoodsorderQrAppPrePay;
            }
            [[DDHttpManager sharedInstance] sendPostRequest:request params:parameter success:^(NSURLSessionDataTask *operation, id responseObject) {
                [hud hide:YES];
                DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
                if (response.isSuccess) {
                    DDUserManager *userManager=[DDUserManager sharedInstance];
                    userManager.payOrderId=responseObject[KData][@"payOrderId"];
                    userManager.orderId=responseObject[KData][@"orderId"];
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
                            //                _hud=[DDUtils showHUDCustom:@""];
                        });
                        
                    }
                }else{
                    [DDUtils showToastWithMessage:response.message];
                }
            } failure:^(NSURLSessionDataTask *operation, id responseObject) {
                [hud hide:YES];
                [DDUtils showToastWithMessage:kRequestFailed];
            }];
            return ;
        }
        NSDictionary *parameter = @{@"enterpriseId":self.enterpriseId,@"acceptEmail":_myEmail,@"channelId":channelId};
        MBProgressHUD * hud = [DDUtils showHUDCustom:@""];
        [[DDHttpManager sharedInstance] sendPostRequest:KHttpRequest_payReport params:parameter success:^(NSURLSessionDataTask *operation, id responseObject) {
            [hud hide:YES];
            DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
            if (response.isSuccess) {
                DDUserManager *userManager=[DDUserManager sharedInstance];
                userManager.payOrderId=responseObject[KData][@"payOrderId"];
                userManager.orderId=responseObject[KData][@"orderId"];
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
                        //                _hud=[DDUtils showHUDCustom:@""];
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
    }else {
        [DDUtils showToastWithMessage:@"请输入正确的邮箱"];
    }
}

#pragma mark tableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
        case 1:
            return 2;
            break;
        case 2:
            return 1;
            break;
        default:
            return 3;
            break;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            return 47;
        }
        return 60;
    }
    return 47;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    _myEmail=textField.text;
    [[NSUserDefaults standardUserDefaults]setObject:_myEmail forKey:[DDUserManager sharedInstance].mobileNumber];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString * actionCellID = @"DDDownloadReportCell";
        DDDownloadReportCell *cell = (DDDownloadReportCell*)[tableView dequeueReusableCellWithIdentifier:actionCellID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:actionCellID owner:self options:nil] firstObject];
        }
        
        if (indexPath.row==0) {
            cell.textLab.text=@"企业信用报告";
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
        if (indexPath.row == 0) {
            static NSString * actionCellID = @"DDDownloadReportCell";
            DDDownloadReportCell *cell = (DDDownloadReportCell*)[tableView dequeueReusableCellWithIdentifier:actionCellID];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle]loadNibNamed:actionCellID owner:self options:nil] firstObject];
            }
            cell.textLab.text=@"报告格式";
            cell.textLab.textColor=KColorBlackTitle;
            cell.textLab.font=kFontSize34;
            
            cell.imgView.hidden=YES;
            cell.detailTextLab.hidden=YES;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else {
            static NSString * actionCellID = @"DDBuyReportCell";
            DDBuyReportCell *cell = (DDBuyReportCell*)[tableView dequeueReusableCellWithIdentifier:actionCellID];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle]loadNibNamed:actionCellID owner:self options:nil] firstObject];
            }
            
            cell.titleLb.text = @"PDF";
            cell.titleLb.font = kFontSize30;
            
            cell.priceLab.text = self.price;
            cell.priceLab.font = kFontSize36;
            cell.priceLab.textColor = KColorFindingPeopleBlue;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
    }else if (indexPath.section == 2) {
        
        static NSString * actionCellID = @"DDFindingCondition2Cell";
        DDFindingCondition2Cell *cell = (DDFindingCondition2Cell*)[tableView dequeueReusableCellWithIdentifier:actionCellID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:actionCellID owner:self options:nil] firstObject];
        }
        
        cell.textLab.text=@"接收邮箱";
        cell.textLab.font=kFontSize30;
        
        cell.inputField.delegate=self;
        cell.tag = 12333;
        //        cell.inputField.textAlignment=NSTextAlignmentRight;
        cell.inputField.placeholder=@"请输入您的邮箱地址";
        cell.inputField.text = _myEmail;
        if (self.type == 2) {
            cell.inputField.userInteractionEnabled = NO;
        }   
        [cell.inputField addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
        //        cell.inputField.clearButtonMode=UITextFieldViewModeAlways;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
                cell.methodTitle.text = @"支付宝支付";
                
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
    if (indexPath.section == 3 && indexPath.row != 0) {
        self.payMethod = indexPath.row;
        NSIndexPath *indexp = [NSIndexPath indexPathForRow:1 inSection:3];
        NSIndexPath *indexp2 = [NSIndexPath indexPathForRow:2 inSection:3];
        [tableView reloadRowsAtIndexPaths:@[indexp,indexp2] withRowAnimation:UITableViewRowAnimationNone];
    }
}
- (void)textChanged:(UITextField *)textField {
    _myEmail = textField.text;
    if (textField.text.length) {
        self.buyBtn.alpha = 1;
        self.buyBtn.enabled = YES;
    }else {
        self.buyBtn.alpha = 0.5;
        self.buyBtn.enabled = NO;
    }
}

- (void)createPaySuccessView {
    self.isPaySuccess = YES;
    DDBuyCreditReportSuccessVC *vc = [[DDBuyCreditReportSuccessVC alloc] init];
    
    if (self.type == 2) {
        vc.type = 4;
    }else {
        vc.type = 1;
    }
    [self.navigationController pushViewController:vc animated:YES];
}
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
//支付取消
- (void)payCancelAction{
    if (self.payMethod == 1) {
        [DDUtils showToastWithMessage:@"支付宝支付已取消"];
    }else {
        [DDUtils showToastWithMessage:@"微信支付已取消"];
    }
}
//支付失败
//- (void)payFailAction{
//    //支付成功,有多个,区分下
//    //    DDUserManager * userManger = [DDUserManager sharedInstance];
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
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KPaySuccessful object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KPayCancel object:nil];
}
- (void)dealloc {
    
}
@end
