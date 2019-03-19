//
//  DDPeopleBelongProjectVC.m
//  GongChengDD
//
//  Created by xzx on 2018/5/26.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDPeopleBelongProjectVC.h"
#import "MJRefresh.h"
#import "DataLoadingView.h"//加载页面
#import "DDNoResult2View.h"//无数据视图
#import "DDProjectListCell.h"//cell

#import "DDNewFindingWinBiddingProjectCell.h"

#import "DDArchitectReceivedProjectsCell.h"//cell，土木工程师等承接项目
#import "DDFireEngineerExperienceCell.h"//cell，消防工程师承接项目

#import "DDPeopleBelongProjectModel.h"//model
#import "DDProjectDetailVC.h"//项目详情页面

@interface DDPeopleBelongProjectVC ()<UITableViewDelegate,UITableViewDataSource>

{
    NSInteger currentPage;
    NSInteger pageCount;
    NSMutableArray *_dataSourceArr;
    NSMutableDictionary *_dict;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) DataLoadingView *loadingView;
@property (nonatomic,strong) DDNoResult2View *noResultView;//无数据视图

@end

@implementation DDPeopleBelongProjectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataSourceArr=[[NSMutableArray alloc]init];
    [self createTableView];
    [self createLoadView];
    [self requestData];
}

#pragma mark 创建加载视图
-(void)createLoadView{
    __weak __typeof(self) weakSelf=self;
    _noResultView=[[DDNoResult2View alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-KNavigationBarHeight-_height-15-45-_bottomHeight)];
    [self.view addSubview:_noResultView];
    
    _loadingView = [[DataLoadingView alloc] initWithController:self];
    _loadingView.loadingTitle = KLoading;
    _loadingView.failureTitle = KLoadingFailure;
    _loadingView.reloadHandle = ^(void){
        [weakSelf requestData];
    };
    [_loadingView showLoadingView];
}

#pragma mark 请求数据
- (void)requestData{
    currentPage = 1;
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:self.staffInfoId forKey:@"staffInfoId"];
    [params setValue:[NSString stringWithFormat:@"%ld",currentPage] forKey:@"current"];
    [params setValue:@"10" forKey:@"size"];
    
    
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_peopleDetailProject params:params success:^(NSURLSessionDataTask *operation, id responseObject){
        NSLog(@"**********个人工程业绩信息数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        __weak __typeof(self) weakSelf = self;
        [_loadingView hiddenLoadingView];
        if (response.isSuccess) {
            if (![response isEmpty]) {
                [_dataSourceArr removeAllObjects];
                [_loadingView hiddenLoadingView];
                _dict = responseObject[KData];
                pageCount = [_dict[@"totalCount"] integerValue];
                NSArray *listArr=_dict[@"list"];
                
                if (listArr.count!=0) {
                    [_noResultView hide];
                    
                    for (NSDictionary *dic in listArr) {
                        DDPeopleBelongProjectModel *model = [[DDPeopleBelongProjectModel alloc]initWithDictionary:dic error:nil];
                        [_dataSourceArr addObject:model];
                    }
                    
                    if (listArr.count<pageCount) {
                        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                            [weakSelf addData];
                        }];
                    }else{
                        [_tableView.mj_footer removeFromSuperview];
                    }
                }
                else{
                    [_noResultView showWithTitle:@"暂无相关个人工程业绩信息" subTitle:@"去其他地方看看~" image:@"noResult_content"];
                }
            }
            else{
                [_noResultView showWithTitle:@"暂无相关个人工程业绩信息" subTitle:@"去其他地方看看~" image:@"noResult_content"];
            }
        }
        else{
            [_noResultView showWithTitle:@"暂无相关个人工程业绩信息" subTitle:@"去其他地方看看~" image:@"noResult_content"];
        }

        [self.tableView.mj_header endRefreshing];
        [_tableView reloadData];
        
    }  failure:^(NSURLSessionDataTask *operation, id responseObject)  {
        [DDUtils showToastWithMessage:kRequestFailed];
        [_loadingView failureLoadingView];
    }];
}

- (void)addData{
    currentPage++;
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [params setValue:self.staffInfoId forKey:@"staffInfoId"];
    [params setValue:[NSString stringWithFormat:@"%ld",currentPage] forKey:@"current"];
    [params setValue:@"10" forKey:@"size"];
    
    
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_peopleDetailProject params:params success:^(NSURLSessionDataTask *operation, id responseObject){
        NSLog(@"**********个人工程业绩信息数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        __weak __typeof(self) weakSelf = self;
        if (response.isSuccess) {
            if (![response isEmpty]) {
                _dict = responseObject[KData];
                NSArray *listArr = _dict[@"list"];
                for (NSDictionary *dic in listArr) {
                    DDPeopleBelongProjectModel *model = [[DDPeopleBelongProjectModel alloc]initWithDictionary:dic error:nil];
                    [_dataSourceArr addObject:model];
                }
                
                if (_dataSourceArr.count<pageCount) {
                    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                        [weakSelf addData];
                    }];
                }
                else{
                   [_tableView.mj_footer removeFromSuperview];
                }
            }
            else{
                [self.tableView.mj_footer removeFromSuperview];
            }
        }
        else{
            [DDUtils showToastWithMessage:response.message];
        }
        
        //[self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
        
    }  failure:^(NSURLSessionDataTask *operation, id responseObject)  {
        [DDUtils showToastWithMessage:kRequestFailed];
    }];
}

#pragma mark 创建tableView
-(void)createTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-KNavigationBarHeight-_height-15-45-_bottomHeight) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.backgroundColor=kColorBackGroundColor;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.showsVerticalScrollIndicator=YES;
    _tableView.separatorColor=KColorTableSeparator;
    _tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, KTableViewFooterViewHeight)];
    _tableView.estimatedRowHeight=44;
    [_tableView registerClass:[DDNewFindingWinBiddingProjectCell class] forCellReuseIdentifier:@"DDNewFindingWinBiddingProjectCell"];
    __weak __typeof(self) weakSelf=self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestData];
    }];
}

#pragma mark tableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataSourceArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DDPeopleBelongProjectModel *model=_dataSourceArr[indexPath.section];
    
    if ([model.level isEqualToString:@"1"]) {//建造师的
        DDNewFindingWinBiddingProjectCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDNewFindingWinBiddingProjectCell" forIndexPath:indexPath];
        if (![DDUtils isEmptyString:model.name]) {
            cell.titleLab.text=[NSString stringWithFormat:@"[%@]%@",model.name,model.title];
        }else{
            cell.titleLab.text=[NSString stringWithFormat:@"%@",model.title];
        }
        cell.winBiddingBtn.hidden = YES;
        cell.winBiddingLab.textColor=KColorBlackSubTitle;
        cell.winBiddingLab.text = model.enterprise_name;
        if (![DDUtils isEmptyString:model.money_type]) {
            if ([model.money_type integerValue] == 0) {
                
                if (![DDUtils isEmptyString:model.win_bid_amount]) {
                    if([model.win_bid_amount isEqualToString:@"0.00"]){
                        cell.priceLab2.text=@"-";
                    }
                    else if([model.win_bid_amount isEqualToString:@"0"]){
                        cell.priceLab2.text=@"-";
                    }
                    else{
                        if (model.win_bid_amount.doubleValue>100000000 || model.win_bid_amount.doubleValue==100000000) {
                            cell.priceLab2.text=[NSString stringWithFormat:@"%@亿",[self handleAmount2:model.win_bid_amount]];
                        }
                        else{
                            cell.priceLab2.text=[NSString stringWithFormat:@"%@万",[self handleAmount:model.win_bid_amount]];
                        }
                    }
                }
                else{
                    cell.priceLab2.text=@"-";
                }
            }else{
                cell.priceLab2.text=model.win_bid_text;
            }
        }else{
            cell.priceLab2.text=@"-";
        }
        cell.timeLab2.text=model.publish_date;
        return cell;
    }
    else if ([model.level isEqualToString:@"2"]) {//其他工程师的
        static NSString * cellID = @"DDArchitectReceivedProjectsCell";
        DDArchitectReceivedProjectsCell * cell = (DDArchitectReceivedProjectsCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
        }

        cell.tilteLab.text=model.title;
        cell.codeLab2.text=model.project_id;
        cell.typeLab2.text=model.type;
        cell.regionLab2.text=model.address;
        cell.deptLab2.text=model.enterprise_name;

        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    else{//消防工程师的
        static NSString * cellID = @"DDFireEngineerExperienceCell";
        DDFireEngineerExperienceCell * cell = (DDFireEngineerExperienceCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
        }
        cell.titleLab.text=model.title;
        cell.dutyLab2.text=model.duty;
        if (![DDUtils isEmptyString:model.publish_date]) {
            cell.dateLab2.text=model.publish_date;
        }
        else{
            cell.dateLab2.text=@"";
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DDPeopleBelongProjectModel *model=_dataSourceArr[indexPath.section];

    if ([model.level isEqualToString:@"1"]) {//建造师的
        DDProjectDetailVC *projectDetail=[[DDProjectDetailVC alloc]init];
        projectDetail.winCaseId=model.win_case_id;
        [self.mainViewContoller.navigationController pushViewController:projectDetail animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     DDPeopleBelongProjectModel *model=_dataSourceArr[indexPath.section];
    if ([model.level isEqualToString:@"1"]) {
        NSString *nameStr = model.title;
        if (![DDUtils isEmptyString:model.name]) {
            nameStr=[NSString stringWithFormat:@"[%@]%@",model.name,model.title];
        }
        CGFloat cellHeight = 0.0;
        if(![DDUtils isEmptyString:[NSString stringWithFormat:@"%@",nameStr]]){
            CGSize labelSize = [[NSString stringWithFormat:@"%@",nameStr] boundingRectWithSize:CGSizeMake(Screen_Width-WidthByiPhone6(24), 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:kFontSize34} context:nil].size;
            cellHeight = labelSize.height;
        }else{
            cellHeight = WidthByiPhone6(20);
        }
        
        if (![DDUtils isEmptyString:model.money_type]) {
            if ([model.money_type integerValue] != 0) {
                NSString *timeStr = model.win_bid_text;
                CGSize labelSize = [[NSString stringWithFormat:@"%@",timeStr] boundingRectWithSize:CGSizeMake(Screen_Width-WidthByiPhone6(73), 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:kFontSize28} context:nil].size;
                return labelSize.height+cellHeight + WidthByiPhone6(110);
            }else{
                return cellHeight+WidthByiPhone6(130);
            }
        }else{
            return cellHeight+WidthByiPhone6(130);
        }
    }
    return UITableViewAutomaticDimension;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    DDPeopleBelongProjectModel *model=_dataSourceArr[section];
    
    UIView *footerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 45)];
    footerView.backgroundColor=kColorWhite;
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(12, 15, Screen_Width-54, 15)];
    label.text=model.trading_center;
    label.textColor=KColorGreySubTitle;
    label.font=kFontSize24;
    [footerView addSubview:label];
    
    return footerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return CGFLOAT_MIN;
    }
    else{
        return 15;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    DDPeopleBelongProjectModel *model=_dataSourceArr[section];
    
    if ([DDUtils isEmptyString:model.trading_center]) {
        return CGFLOAT_MIN;
    }
    else{
        return 45;
    }
}
-(NSString *)handleAmount:(NSString *)amount{
    //需要参与运算的两个数
    NSDecimalNumber *num = [NSDecimalNumber decimalNumberWithString:amount];
    NSDecimalNumber *w = [NSDecimalNumber decimalNumberWithString:@"10000"];
    
    //运算结果处理：小数精确到后2位，其余位无条件舍弃
    NSDecimalNumberHandler *handler = [NSDecimalNumberHandler
                                       decimalNumberHandlerWithRoundingMode:NSRoundDown//要使用的舍入模式
                                       scale:2             //结果保留几位小数
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

-(NSString *)handleAmount2:(NSString *)amount{
    //需要参与运算的两个数
    NSDecimalNumber *num = [NSDecimalNumber decimalNumberWithString:amount];
    NSDecimalNumber *w = [NSDecimalNumber decimalNumberWithString:@"100000000"];
    
    //运算结果处理：小数精确到后2位，其余位无条件舍弃
    NSDecimalNumberHandler *handler = [NSDecimalNumberHandler
                                       decimalNumberHandlerWithRoundingMode:NSRoundDown//要使用的舍入模式
                                       scale:2             //结果保留几位小数
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


@end
