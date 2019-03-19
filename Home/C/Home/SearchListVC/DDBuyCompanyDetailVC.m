//
//  DDBuyCompanyDetailVC.m
//  GongChengDD
//
//  Created by xzx on 2018/5/30.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDBuyCompanyDetailVC.h"
#import "DataLoadingView.h"
#import "DDBuyCompanyDetailModel.h"//model
#import "DDBuyCompanyDetail1Cell.h"
#import "DDBuyCompanyDetail2Cell.h"
#import "DDBuyCompanyDetail3Cell.h"
#import "HDChatViewController.h"//环信客服页面
#import "DDThirdPartyKeys.h"

@interface DDBuyCompanyDetailVC ()<UITableViewDelegate,UITableViewDataSource,DDBuyCompanyDetail2CellDelegate>

{
    NSString *_status;//0表示收起只显示5条，1表示展开有多少显示多少
    DDBuyCompanyDetailModel *_model;
    UIButton *_leftBtn;//收藏和已收藏按钮
}
@property (nonatomic,strong) UITableView *tableView;
@property (strong,nonatomic) DataLoadingView *loadingView;

@end

@implementation DDBuyCompanyDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _status=@"0";
    self.view.backgroundColor=kColorBackGroundColor;
    self.navigationItem.leftBarButtonItem=[DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
    //self.navigationItem.rightBarButtonItem=[DDUtils rightbuttonItemWithTitle:@"分享" target:self action:@selector(shareClick)];
    [self createTableView];
    [self createBottomBtns];
    [self setupDataLoadingView];
    [self requestBuyCompanyDetail];
}

//返回上一页
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

//分享
//-(void)shareClick{
//    [DDUtils showToastWithMessage:@"分享"];
//}

- (void)setupDataLoadingView{
    __weak __typeof(self) weakSelf=self;
    _loadingView = [[DataLoadingView alloc] initWithController:self];
    _loadingView.loadingTitle = KLoading;
    _loadingView.failureTitle = KLoadingFailure;
    _loadingView.reloadHandle = ^(void){
        [weakSelf requestBuyCompanyDetail];
    };
    [_loadingView showLoadingView];
}

#pragma mark 请求买公司详情数据
-(void)requestBuyCompanyDetail{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:_saleRegisterId forKey:@"Id"];
    
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_buyCompanyDetail params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"***********买公司详情请求数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {//请求成功
            [_loadingView hiddenLoadingView];
            _model=[[DDBuyCompanyDetailModel alloc]initWithDictionary:responseObject[KData] error:nil];
            if ([_model.isCollection isEqualToString:@"0"]) {
                [_leftBtn setTitle:@"收藏" forState:UIControlStateNormal];
                [_leftBtn addTarget:self action:@selector(focusClick) forControlEvents:UIControlEventTouchUpInside];
            }
            else{
                [_leftBtn setTitle:@"已收藏" forState:UIControlStateNormal];
                [_leftBtn addTarget:self action:@selector(cancelShareClick) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        else{//显示异常
            [DDUtils showToastWithMessage:response.message];
            [_loadingView failureLoadingView];
        }

        [_tableView reloadData];
        
    } failure:^(NSURLSessionDataTask *operation, id responseObject) {
        [DDUtils showToastWithMessage:kRequestFailed];
        [_loadingView failureLoadingView];
    }];
}

//创建底部三个按钮
-(void)createBottomBtns{
    CGFloat distanceToTop;
    if (iPhoneX==YES) {
        distanceToTop=Screen_Height-KNavigationBarHeight-KTabbarHeight-20;
    }
    else{
        distanceToTop=Screen_Height-KNavigationBarHeight-KTabbarHeight;
    }
    
    
    _leftBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, distanceToTop, Screen_Width/2, KTabbarHeight)];
    [_leftBtn setBackgroundColor:kColorWhite];
    //[_leftBtn setTitle:@"+收藏" forState:UIControlStateNormal];
    [_leftBtn setTitleColor:KColorBlackTitle forState:UIControlStateNormal];
    _leftBtn.titleLabel.font=kFontSize32;
    //[_leftBtn addTarget:self action:@selector(focusClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_leftBtn];
    
    UIButton *middleBtn=[[UIButton alloc]initWithFrame:CGRectMake(Screen_Width/2, distanceToTop, Screen_Width/2, KTabbarHeight)];
    [middleBtn setBackgroundColor:kColorWhite];
    [middleBtn setTitle:@"联系卖家" forState:UIControlStateNormal];
    [middleBtn setTitleColor:KColorBlackTitle forState:UIControlStateNormal];
    middleBtn.titleLabel.font=kFontSize32;
    [middleBtn addTarget:self action:@selector(telConsultClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:middleBtn];
    
//    UIButton *rightBtn=[[UIButton alloc]initWithFrame:CGRectMake(Screen_Width/3*2, distanceToTop, Screen_Width/3, KTabbarHeight)];
//    [rightBtn setBackgroundColor:kColorBlue];
//    [rightBtn setTitle:@"在线咨询" forState:UIControlStateNormal];
//    [rightBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
//    rightBtn.titleLabel.font=kFontSize32;
//    [rightBtn addTarget:self action:@selector(onlineConsultClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:rightBtn];
    
    
    UILabel *line1=[[UILabel alloc]initWithFrame:CGRectMake(Screen_Width/2-0.5, distanceToTop, 1, KTabbarHeight)];
    line1.backgroundColor=KColorTableSeparator;
    [self.view addSubview:line1];
    
//    UILabel *line2=[[UILabel alloc]initWithFrame:CGRectMake(Screen_Width/3*2-0.5, distanceToTop, 1, KTabbarHeight)];
//    line2.backgroundColor=KColorTableSeparator;
//    [self.view addSubview:line2];
    
    UILabel *line3=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMinY(_leftBtn.frame), Screen_Width, 1)];
    line3.backgroundColor=KColor10AlphaBlack;
    [self.view addSubview:line3];
}

//收藏
-(void)focusClick{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [params setValue:_saleRegisterId forKey:@"collectId"];
    [params setValue:@"2" forKey:@"collectType"];
    [params setValue:[self getCurrentTimes] forKey:@"createdTime"];
    [params setValue:[self getCurrentTimes] forKey:@"updatedTime"];
    
    MBProgressHUD * hud = [DDUtils showHUDCustom:@""];
    [[DDHttpManager sharedInstance]sendPostRequest:KHttpRequest_saveMyCollection params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"**********买公司详情的收藏***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            hud.mode = MBProgressHUDModeCustomView;
            hud.customView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cer_success"]];
            hud.labelText=@"已收藏";
            hud.completionBlock= ^(){

                [_leftBtn setTitle:@"已收藏" forState:UIControlStateNormal];
                [_leftBtn removeTarget:nil
                                   action:NULL
                         forControlEvents:UIControlEventAllEvents];
                [_leftBtn addTarget:self action:@selector(cancelShareClick) forControlEvents:UIControlEventTouchUpInside];
                
                //发个通知
                [[NSNotificationCenter defaultCenter] postNotificationName:KBuyCompanyOrCannel object:nil];
            };
        }else if (response.code == 150){//已在其他端收藏过
            hud.mode = MBProgressHUDModeCustomView;
            hud.customView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cer_success"]];
            hud.labelText= @"你已经收藏过该条转让信息";
            hud.completionBlock= ^(){
                
                [_leftBtn setTitle:@"已收藏" forState:UIControlStateNormal];
                [_leftBtn removeTarget:nil
                                action:NULL
                      forControlEvents:UIControlEventAllEvents];
                [_leftBtn addTarget:self action:@selector(cancelShareClick) forControlEvents:UIControlEventTouchUpInside];
                
                //发个通知
                [[NSNotificationCenter defaultCenter] postNotificationName:KBuyCompanyOrCannel object:nil];
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

//取消收藏
-(void)cancelShareClick{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [params setValue:_saleRegisterId forKey:@"collectId"];
    [params setValue:@"2" forKey:@"collectType"];
    
    MBProgressHUD * hud = [DDUtils showHUDCustom:@""];
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_cancelMyCollection params:params success:^(NSURLSessionDataTask *operation, id responseObject){
        NSLog(@"**********买公司详情的取消收藏***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            hud.mode = MBProgressHUDModeCustomView;
            hud.customView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cer_success"]];
            hud.labelText=@"已取消收藏";
            hud.completionBlock= ^(){
            
                [_leftBtn setTitle:@"收藏" forState:UIControlStateNormal];
                [_leftBtn removeTarget:nil
                                action:NULL
                      forControlEvents:UIControlEventAllEvents];
                [_leftBtn addTarget:self action:@selector(focusClick) forControlEvents:UIControlEventTouchUpInside];
                
                //发个通知,
                [[NSNotificationCenter defaultCenter] postNotificationName:KBuyCompanyOrCannel object:nil];
            };
        }else{
            [DDUtils showToastWithMessage:response.message];
        }
        
        [hud hide:YES afterDelay:KHudShowTimeSecound];
    } failure:^(NSURLSessionDataTask *operation, id responseObject) {
        hud.labelText = kRequestFailed;
        [hud hide:YES afterDelay:KHudShowTimeSecound];
    }];
}

//获取当前的时间
-(NSString*)getCurrentTimes{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    //设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    //现在时间,你可以输出来看下是什么格式
    NSDate *datenow = [NSDate date];
    
    //将nsdate按formatter格式转成nsstring
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    return currentTimeString;
}

//联系卖家
-(void)telConsultClick{
    if ([DDUtils isEmptyString:_model.contactNumber]) {
        [DDUtils showToastWithMessage:@"暂无联系电话！"];
    }
    else{
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_model.contactNumber]]];
    }
}

#pragma mark 在线咨询
//-(void)onlineConsultClick{
//    //[self enterChatVC:@"证书服务"];
//    //[self enterChatVC:@"公司买卖服务"];
//    //[self enterChatVC:@"保险服务"];
//
//    //判断是否已经登录
//    HChatClient *client = [HChatClient sharedClient];
//    if (client.isLoggedInBefore != YES){
//        [DDUtils showToastWithMessage:charCustomerServiceError];
//        return;
//    }else{
//        //进入客服视图控制器
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//
//            //初始化聊天视图控制器,
//            //Chatter:IM服务号
//            HDChatViewController * chatVC = [[HDChatViewController alloc] initWithConversationChatter:easemobIMSeverNum];
//
//            //指定技能组,initWithValue为技能组名称
////            HQueueIdentityInfo * queueIdentityInfo = [[HQueueIdentityInfo alloc] initWithValue:@"公司买卖服务"];
////            chatVC.queueInfo = queueIdentityInfo;
//
//            //指定客服,账号为客服的登录邮箱地址,暂时写死1795454716@qq.com
//            //        chatVC.agent = [[HAgentIdentityInfo alloc] initWithValue:@"1795454716@qq.com"];
//
//            //访客信息,
//            chatVC.visitorInfo = [self visitorInfo];
//
//            //商品信息
//            // chat.commodityInfo = (NSDictionary *)notification.object;
//
//            //设置标题,无效???
//            //            chatVC.title = @"客服";
//            chatVC.titleString =@"联系客服";
//
//            dispatch_async(dispatch_get_main_queue(), ^{
//                chatVC.hidesBottomBarWhenPushed = YES;
//                [self.navigationController pushViewController:chatVC animated:YES];
//            });
//        });
//    }
//}
//
//- (HVisitorInfo *)visitorInfo {
//    DDUserManager * userManger = [DDUserManager sharedInstance];
//
//    DDCurrentCompanyModel * currentCompanyModel = [DDUserManager sharedInstance].currentCompanyModel;
//    DDScAttestationEntityModel *  scAttestationEntityModel = currentCompanyModel.scAttestationEntity;
//
//    //在这里设置,用户信息
//    HVisitorInfo *visitor = [[HVisitorInfo alloc] init];
//    visitor.name = userManger.realName;
//    visitor.qq = @"";
//    visitor.phone = userManger.mobileNumber;
//    visitor.companyName = scAttestationEntityModel.entName;
//    visitor.nickName = userManger.nickName;
//    visitor.email = @"";
//    visitor.desc = @"";
//    return visitor;
//}

//创建tableView
-(void)createTableView{
    if (iPhoneX==YES) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-KNavigationBarHeight-KTabbarHeight-20) style:UITableViewStyleGrouped];
    }
    else{
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-KNavigationBarHeight-KTabbarHeight) style:UITableViewStyleGrouped];
    }
    
    [self.view addSubview:_tableView];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.backgroundColor=kColorBackGroundColor;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.separatorColor=KColorTableSeparator;
    
//    [_tableView registerNib:[UINib nibWithNibName:@"DDBuyCompanyDetail1Cell" bundle:nil] forCellReuseIdentifier:@"DDBuyCompanyDetail1Cell"];
//    [_tableView registerNib:[UINib nibWithNibName:@"DDBuyCompanyDetail2Cell" bundle:nil] forCellReuseIdentifier:@"DDBuyCompanyDetail2Cell"];
//    [_tableView registerNib:[UINib nibWithNibName:@"DDBuyCompanyDetail3Cell" bundle:nil] forCellReuseIdentifier:@"DDBuyCompanyDetail3Cell"];
}

#pragma mark tableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        static NSString * cellID = @"DDBuyCompanyDetail1Cell";
        DDBuyCompanyDetail1Cell * cell = (DDBuyCompanyDetail1Cell*)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
        }
        
        //DDBuyCompanyDetail1Cell *cell=[tableView dequeueReusableCellWithIdentifier:@"DDBuyCompanyDetail1Cell" forIndexPath:indexPath];
        
        cell.nameLab.text=_model.enterpriseName;
        cell.addressLab2.text=_model.mergerName;
        if (![DDUtils isEmptyString:_model.auditTime]) {
            cell.timeLab2.text=[DDUtils getDateChineseByStandardTime:_model.auditTime];
        }
        else{
            cell.timeLab2.text=@"";
        }
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if(indexPath.section==1){
        static NSString * cellID = @"DDBuyCompanyDetail2Cell";
        DDBuyCompanyDetail2Cell * cell = (DDBuyCompanyDetail2Cell*)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
        }
        
        //DDBuyCompanyDetail2Cell *cell=[tableView dequeueReusableCellWithIdentifier:@"DDBuyCompanyDetail2Cell" forIndexPath:indexPath];
        
        cell.delegate=self;
        cell.status=_status;
        [cell loadWithArray:_model.certTypeLevelList];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    else{
        static NSString * cellID = @"DDBuyCompanyDetail3Cell";
        DDBuyCompanyDetail3Cell * cell = (DDBuyCompanyDetail3Cell*)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
        }
        
        //DDBuyCompanyDetail3Cell *cell=[tableView dequeueReusableCellWithIdentifier:@"DDBuyCompanyDetail3Cell" forIndexPath:indexPath];
        
        cell.codeLab2.text=_model.socialCreditCode;//工商信用代码
        cell.addressLab2.text=_model.mergerName;//所在区域
        cell.typeLab2.text=_model.economicTypeSource;//企业类型
        
        if ([_model.creditDebt isEqualToString:@"1"]) {
            cell.debtLab2.text=@"有";//债权债务
        }
        else{
            cell.debtLab2.text=@"无";//债权债务
        }
        
        if ([_model.legalDispute isEqualToString:@"1"]) {
            cell.lawLab2.text=@"有";//法律纠纷
        }
        else{
            cell.lawLab2.text=@"无";//法律纠纷
        }
        
        if ([_model.loansQuestion isEqualToString:@"1"]) {
            cell.loanLab2.text=@"有";//贷款问题
        }
        else{
            cell.loanLab2.text=@"无";//贷款问题
        }
        
        if ([_model.processWork isEqualToString:@"1"]) {
            cell.projectLab2.text=@"有";//在建项目
        }
        else{
            cell.projectLab2.text=@"无";//在建项目
        }
        
        if ([_model.assure isEqualToString:@"1"]) {
            cell.assureLab2.text=@"有";//担保
        }
        else{
            cell.assureLab2.text=@"无";//担保
        }
        
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
}

//DDBuyCompanyDetail2CellDelegate代理方法
-(void)downOrUpBtnClick{
    if ([_status isEqualToString:@"0"]) {
        _status=@"1";
    }
    else{
        _status=@"0";
    }
    [_tableView reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 140;
    }
    else if (indexPath.section==1) {
        if (_model.certTypeLevelList.count<=5 && _model.certTypeLevelList.count>0) {
            return _model.certTypeLevelList.count*40;
        }
        else if(_model.certTypeLevelList.count>5){
            if ([_status isEqualToString:@"0"]) {
                return 5*40+46;
            }
            else{
                return _model.certTypeLevelList.count*40+46;
            }
        }
    }
    else{
        return 330;
    }
    return CGFLOAT_MIN;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return nil;
    }
    else if(section==1){
        UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 45)];
        headerView.backgroundColor=kColorWhite;
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(12, 20, 115, 15)];
        label.backgroundColor=kColorWhite;
        label.text=@"资质类别及等级:";
        label.textColor=KColorGreySubTitle;
        label.font=kFontSize30;
        [headerView addSubview:label];
        
        UILabel *unitLab=[[UILabel alloc]initWithFrame:CGRectMake(Screen_Width-12-35, 20, 35, 15)];
        unitLab.text=@"万元";
        unitLab.textColor=KColorGreySubTitle;
        unitLab.font=kFontSize30;
        [headerView addSubview:unitLab];
        
        CGRect frame;
        if (![DDUtils isEmptyString:_model.price] && ![_model.price isEqualToString:@"0"]) {
            frame = [[self removeFloatAllZero:[NSString stringWithFormat:@"%.2f",_model.price.doubleValue/10000]] boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:KFontSize42} context:nil];
        }
        else{
            frame = [@"面议" boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:KFontSize42} context:nil];
            unitLab.hidden=YES;
        }
        UILabel *moneyLab=[[UILabel alloc]initWithFrame:CGRectMake(Screen_Width-12-35-frame.size.width, 17.5, frame.size.width, 20)];
        if (![DDUtils isEmptyString:_model.price] && ![_model.price isEqualToString:@"0"]) {
            moneyLab.text=[self removeFloatAllZero:[NSString stringWithFormat:@"%.2f",_model.price.doubleValue/10000]];
        }
        else{
            moneyLab.text=@"面议";
        }
        moneyLab.textColor=kColorBlue;
        moneyLab.font=KFontSize42;
        [headerView addSubview:moneyLab];
        
        
        UILabel *transferLab=[[UILabel alloc]initWithFrame:CGRectMake(Screen_Width-12-35-frame.size.width-55, 20, 55, 15)];
        transferLab.text=@"转让价:";
        transferLab.textColor=KColorGreySubTitle;
        transferLab.font=kFontSize30;
        [headerView addSubview:transferLab];
        
        return headerView;
    }
    else{
        UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 45)];
        headerView.backgroundColor=kColorWhite;
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(12, 20, 70, 15)];
        label.backgroundColor=kColorWhite;
        label.text=@"详细信息:";
        label.textColor=KColorGreySubTitle;
        label.font=kFontSize30;
        [headerView addSubview:label];
        return headerView;
    }
}

#pragma mark 取出小数点后多余的0
-(NSString *)removeFloatAllZero:(NSString *)string{
    NSString * testNumber = string;
    NSString * outNumber = [NSString stringWithFormat:@"%@",@(testNumber.floatValue)];
    //价格格式化显示
    NSNumberFormatter * formatter = [[NSNumberFormatter alloc]init];
    formatter.numberStyle = kCFNumberFormatterDecimalStyle;
    NSString * formatterString = [formatter stringFromNumber:[NSNumber numberWithFloat:[outNumber doubleValue]]];
    //获取要截取的字符串位置
    NSRange range = [formatterString rangeOfString:@"."];
    if (range.length >0 ) {
        NSString * result = [formatterString substringFromIndex:range.location];
        if (result.length >= 4) {
            formatterString = [formatterString substringToIndex:formatterString.length - 1];
        }
    }
    
    return formatterString;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return CGFLOAT_MIN;
    }
    else{
        return 45;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 15;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y>40) {
        self.title=_model.enterpriseName;
    }
    else{
        self.title=@"";
    }
}

@end
