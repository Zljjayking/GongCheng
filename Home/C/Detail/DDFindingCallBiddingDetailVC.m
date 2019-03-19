//
//  DDFindingCallBiddingDetailVC.m
//  GongChengDD
//
//  Created by xzx on 2018/11/23.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDFindingCallBiddingDetailVC.h"
#import "DDLabelUtil.h"
#import "DDLoseCreditDetailCell.h"//cell1
#import "DataLoadingView.h"//加载页面
#import "DDFindingCallBiddingDetailModel.h"//model
#import "DDProjectCheckOriginWebVC.h"//查看原文页面
#import "DDServiceWebViewVC.h"
@interface DDFindingCallBiddingDetailVC ()<UITableViewDelegate,UITableViewDataSource>

{
    DDFindingCallBiddingDetailModel *_model;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) DataLoadingView *loadingView;

@end

@implementation DDFindingCallBiddingDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent=NO;
    [self editNavItem];
    [self createTableView];
    [self createBottomBtn];
    [self createLoadView];
    [self requestData];
}

//定制导航条
-(void)editNavItem{
    self.title=@"招标详情";
    self.view.backgroundColor=kColorBackGroundColor;
    self.navigationItem.leftBarButtonItem=[DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
}

//返回上一页
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

//创建查看原文按钮
-(void)createBottomBtn{
    UIView *bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, Screen_Height-KNavigationBarHeight-57.5, Screen_Width, 57.5)];
    bottomView.backgroundColor=kColorWhite;
    [self.view addSubview:bottomView];
    
    UIButton *checkPaperBtn=[[UIButton alloc]initWithFrame:CGRectMake(12, 8.75, Screen_Width-24, 40)];
    [bottomView addSubview:checkPaperBtn];
    
    [checkPaperBtn setTitle:@"买工程投标保证险" forState:UIControlStateNormal];
    [checkPaperBtn setBackgroundColor:KColorFindingPeopleBlue];
    checkPaperBtn.titleLabel.font=kFontSize32;
    [checkPaperBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
    checkPaperBtn.layer.cornerRadius=3;
    [checkPaperBtn addTarget:self action:@selector(checkPaperClick) forControlEvents:UIControlEventTouchUpInside];
}

//买工程投标保证险
-(void)checkPaperClick{
    //TODO买保险
    DDServiceWebViewVC * checkVC = [DDServiceWebViewVC new];
    checkVC.hostUrl = @"http://gcdd.koncendy.com/apphs/insuranceAndCompanyTrading/#/insuranceList";
    checkVC.hidesBottomBarWhenPushed=YES;
    checkVC.serviceWebViewType = DDServiceWebViewTypeOther;
    [self.navigationController pushViewController:checkVC animated:YES];
   
//    DDServiceWebViewVC * checkVC = [DDServiceWebViewVC new];
//    checkVC.hostUrl = [NSString stringWithFormat:@"http://gcdd.koncendy.com/apphs/insuranceAndCompanyTrading/#/myChooseInsurance?id=%@",_model.id];
//    checkVC.serviceWebViewType = DDServiceWebViewTypeOther;
//    checkVC.hidesBottomBarWhenPushed=YES;
//    [self.navigationController pushViewController:checkVC animated:YES];
    
}

#pragma mark 创建加载视图
-(void)createLoadView{
    __weak __typeof(self) weakSelf=self;
    
    _loadingView = [[DataLoadingView alloc] initWithController:self];
    _loadingView.loadingTitle = KLoading;
    _loadingView.failureTitle = KLoadingFailure;
    _loadingView.reloadHandle = ^(void){
        [weakSelf requestData];
    };
    [_loadingView showLoadingView];
}

#pragma mark 请求数据
-(void)requestData{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:self.passValueId forKey:@"inviteId"];
    
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_findingCallBiddingDetail params:params success:^(NSURLSessionDataTask *operation, id responseObject){
        NSLog(@"**********招标详情数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            [_loadingView hiddenLoadingView];
            _model=[[DDFindingCallBiddingDetailModel alloc]initWithDictionary:responseObject[KData] error:nil];
        }
        else{
            
            [_loadingView failureLoadingView];
        }
        
        [_tableView reloadData];
        
    }  failure:^(NSURLSessionDataTask *operation, id responseObject)  {
        [DDUtils showToastWithMessage:kRequestFailed];
        [_loadingView failureLoadingView];
    }];
}


//创建tableView
-(void)createTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-KNavigationBarHeight-57.5) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.backgroundColor=kColorBackGroundColor;
    _tableView.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.separatorColor=KColorTableSeparator;
    _tableView.estimatedRowHeight=44;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, KTableViewFooterViewHeight)];
}

#pragma mark tableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellID = @"DDLoseCreditDetailCell";
    DDLoseCreditDetailCell * cell = (DDLoseCreditDetailCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
    }
    
    if (indexPath.row==0) {
        cell.titleLab.textColor=KColorCompanyTitleBalck;
        cell.titleLab.font=KfontSize32Bold;
        cell.detailLab.textColor=KColorBlackTitle;
        cell.detailLab.font=kFontSize32;
        cell.titleLab.text=_model.name;
        cell.detailLab.text=_model.title;
    }
    else if(indexPath.row==1){
        cell.titleLab.textColor=KColorGreySubTitle;
        cell.titleLab.font=kFontSize30;
        cell.detailLab.textColor=KColorBlackTitle;
        cell.detailLab.font=kFontSize32;
        cell.titleLab.text=@"招标价";
        if (![DDUtils isEmptyString:_model.money_type]) {
            if ([_model.money_type integerValue] == 0) {
                if ([_model.invite_amount integerValue] <100) {
                    cell.detailLab.text=@"-";
                }else{
                    cell.detailLab.text=[NSString stringWithFormat:@"%@万",[self handleAmount:_model.invite_amount]];
                }
            }else{
                cell.detailLab.text=_model.invite_text;
            }
        }else{
            cell.detailLab.text=@"-";
        }
    }
    else if(indexPath.row==2){
        cell.titleLab.textColor=KColorGreySubTitle;
        cell.titleLab.font=kFontSize30;
        cell.detailLab.textColor=KColorBlackTitle;
        cell.detailLab.font=kFontSize32;
        cell.titleLab.text=@"招标单位";
        cell.detailLab.text=_model.bid_company;
    }
    else if(indexPath.row==3){
        cell.titleLab.textColor=KColorGreySubTitle;
        cell.titleLab.font=kFontSize30;
        cell.detailLab.textColor=KColorBlackTitle;
        cell.detailLab.font=kFontSize32;
        cell.titleLab.text=@"发布时间";
        cell.detailLab.text=_model.publish_date;
    }
    else if(indexPath.row==4){
        cell.titleLab.textColor=KColorGreySubTitle;
        cell.titleLab.font=kFontSize30;
        cell.detailLab.textColor=KColorFindingPeopleBlue;
        cell.detailLab.font=kFontSize32;
        cell.titleLab.text=@"原文链接";
        cell.detailLab.text=_model.host_url;
    }
    
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==4) {
        DDProjectCheckOriginWebVC *projectCheckOriginWebVC=[[DDProjectCheckOriginWebVC alloc]init];
        projectCheckOriginWebVC.hostUrl=_model.host_url;
        projectCheckOriginWebVC.hostTitle = _model.trading_center;
        [self.navigationController pushViewController:projectCheckOriginWebVC animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 15;
}

-(NSString *)handleAmount:(NSString *)amount{
    //需要参与运算的两个数
    NSDecimalNumber *num = [NSDecimalNumber decimalNumberWithString:amount];
    NSDecimalNumber *w = [NSDecimalNumber decimalNumberWithString:@"10000"];
    
    //运算结果处理：小数精确到后2位，其余位无条件舍弃
    NSDecimalNumberHandler *handler = [NSDecimalNumberHandler
                                       decimalNumberHandlerWithRoundingMode:NSRoundDown//要使用的舍入模式
                                       scale:8             //结果保留几位小数
                                       raiseOnExactness:NO //发生精确错误时是否抛出异常，一般为NO
                                       raiseOnOverflow:NO  //发生溢出错误时是否抛出异常，一般为NO
                                       raiseOnUnderflow:NO //发生不足错误时是否抛出异常，一般为NO
                                       raiseOnDivideByZero:YES];//被0除时是否抛出异常，一般为YES
    
    //将两个数进行除法运算，并对结果加以处理(handler)
    num = [num decimalNumberByDividingBy:w withBehavior:handler];
    NSString *ret = [NSString stringWithFormat:@"%@", num];
    
    return ret;
    //return [self removeFloatAllZero:ret];
}

//#pragma mark 去除小数点后多余的0
-(NSString *)removeFloatAllZero:(NSString *)string{
    NSString * testNumber = string;
    NSString * outNumber = [NSString stringWithFormat:@"%@",@(testNumber.floatValue)];
    //价格格式化显示
    NSNumberFormatter * formatter = [[NSNumberFormatter alloc]init];
    formatter.numberStyle = kCFNumberFormatterNoStyle;
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

@end
