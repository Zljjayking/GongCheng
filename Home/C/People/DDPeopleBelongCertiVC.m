//
//  DDPeopleBelongCertiVC.m
//  GongChengDD
//
//  Created by xzx on 2018/5/25.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDPeopleBelongCertiVC.h"
#import "MJRefresh.h"
#import "DataLoadingView.h"//加载页面
#import "DDNoResult2View.h"//无数据视图
#import "DDPeopleBelongCertiCell.h"//cell,安全员和土木工程师等专用
#import "DDPeopleBelongCerti2Cell.h"//建造师专用cell
#import "DDPeopleBelongCerti3Cell.h"//消防员，结构师等专用
#import "DDPeopleBelongCertiModel.h"//model
#import "DDCompanyDetailVC.h"//公司详情页面
#import "DDPersonalClaimBenefitVC.h"
#import "DDSafeManDetailVC.h"
#import "DDArchitectReceivedProjectsVC.h"
#import "DDCivilReceivedProjectsVC.h"



@interface DDPeopleBelongCertiVC ()<UITableViewDelegate,UITableViewDataSource,DDPeopleBelongCerti2CellDelegate,DDPeopleBelongCerti3CellDelegate,DDPeopleBelongCertiCellDelegate>

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

@implementation DDPeopleBelongCertiVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshData) name:KRefreshUI object:nil];//接收收到刷新页面的通知
    _dataSourceArr=[[NSMutableArray alloc]init];
    [self createTableView];
    [self createLoadView];
    [self requestData];
}
-(void)refreshData{
    [self.tableView reloadData];
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
    
    
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_peopleDetailCerti params:params success:^(NSURLSessionDataTask *operation, id responseObject){
        NSLog(@"**********人员证书信息数据***************%@",responseObject);
        
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
                        DDPeopleBelongCertiModel *model = [[DDPeopleBelongCertiModel alloc]initWithDictionary:dic error:nil];
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
                    [_noResultView showWithTitle:@"暂无相关证书信息" subTitle:@"去其他地方看看~" image:@"noResult_content"];
                }
            }
            else{
                [_noResultView showWithTitle:@"暂无相关证书信息" subTitle:@"去其他地方看看~" image:@"noResult_content"];
            }
        }
        else{
            [_noResultView showWithTitle:@"暂无相关证书信息" subTitle:@"去其他地方看看~" image:@"noResult_content"];
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
    
    
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_peopleDetailCerti params:params success:^(NSURLSessionDataTask *operation, id responseObject){
        NSLog(@"**********人员证书信息数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        __weak __typeof(self) weakSelf = self;
        if (response.isSuccess) {
            if (![response isEmpty]) {
                _dict = responseObject[KData];
                NSArray *listArr = _dict[@"list"];
                for (NSDictionary *dic in listArr) {
                    DDPeopleBelongCertiModel *model = [[DDPeopleBelongCertiModel alloc]initWithDictionary:dic error:nil];
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
    _tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, KTableViewFooterViewHeight)];
    
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
    DDPeopleBelongCertiModel *model=_dataSourceArr[indexPath.section];
    
    //date_type:  1  一级二级建造师   2安全员  3一级结构师  4二级结构师  5化工工程师 6一级建筑师   7二级建筑师  8土木工程师   9公用设备师  10电气工程师   11监理工程师  12造价工程师
    
    if ([model.data_type isEqualToString:@"1"]) {//建造师（5行）
        static NSString * cellID = @"DDPeopleBelongCerti2Cell";
        DDPeopleBelongCerti2Cell * cell = (DDPeopleBelongCerti2Cell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
        }
        cell.delegate = self;
        [cell loadDataWithModel:model];
        cell.claimButton.hidden=YES;
        
        cell.arrow.hidden=YES;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if([model.data_type isEqualToString:@"2"] || [model.data_type isEqualToString:@"8"] || [model.data_type isEqualToString:@"9"] || [model.data_type isEqualToString:@"10"] || [model.data_type isEqualToString:@"11"] || [model.data_type isEqualToString:@"12"]){//安全员和土木工程师等（4行）//土木工程师8 公用设备师9 电气工程师10 监理工程师11 造价工程师12
        static NSString * cellID = @"DDPeopleBelongCertiCell";
        DDPeopleBelongCertiCell * cell = (DDPeopleBelongCertiCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
        }
        
        cell.delegate = self;
        [cell loadDataWithModel:model];
        cell.claimButton.hidden=YES;
        
        cell.arrow.hidden=YES;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if([model.data_type isEqualToString:@"3"] || [model.data_type isEqualToString:@"4"] || [model.data_type isEqualToString:@"5"] || [model.data_type isEqualToString:@"6"] || [model.data_type isEqualToString:@"7"]){//建筑师等（3行）//一级结构师3  二级结构师4  化工工程师5 一级建筑师6  二级建筑师7
        static NSString * cellID = @"DDPeopleBelongCerti3Cell";
        DDPeopleBelongCerti3Cell * cell = (DDPeopleBelongCerti3Cell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
        }
        
        [cell loadDataWithModel:model];
        cell.delegate = self;
        cell.claimButton.hidden=YES;
        
        cell.arrow.hidden=YES;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    else{//消防工程师（3行）
        static NSString * cellID = @"DDPeopleBelongCerti3Cell";
        DDPeopleBelongCerti3Cell * cell = (DDPeopleBelongCerti3Cell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
        }
         cell.delegate = self;
        
        cell.nameLab.text=model.name;
        
        cell.roleLab.text=model.cert_type_name;
        CGRect frame_W = [model.cert_type_name boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize24} context:nil];
        cell.roleLab.textColor=KColorFire;
        cell.roleLab.layer.borderColor=KColorFire.CGColor;
        cell.roleLab.backgroundColor=KColorFireBg;
        cell.roleLabWidth.constant = frame_W.size.width+16;
        
        cell.numLab1.text=@"注册编号：";
        cell.numLab2.text=model.registered_no;
        
        cell.registerLab1.text=@"注册级别：";
        cell.registerLab2.text=model.cert_level;
        
        cell.timeLab2.text=model.validity_period_end;
        
        NSString *resultStr = [DDUtils newCompareTimeSpaceIn90:model.validity_period_end];
        if ([resultStr isEqualToString:@"2"]) {
            cell.timeLab2.textColor=kColorBlue;
        }else if ([resultStr isEqualToString:@"1"]){
            cell.timeLab2.textColor=KColorTextOrange;
        } else{
            cell.timeLab2.textColor=kColorRed;
        }
        
        cell.arrow.hidden=YES;
        cell.claimButton.hidden=YES;
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    DDPeopleBelongCertiModel *model=_dataSourceArr[indexPath.section];
    //date_type:  1  一级二级建造师   2安全员  3一级结构师  4二级结构师  5化工工程师6一级建筑师   7二级建筑师  8土木工程师   9公用设备师  10电气工程师   11监理工程师  12造价工程师
    
    if ([model.data_type isEqualToString:@"1"]) {//建造师（5行）
        return [DDPeopleBelongCerti2Cell height];
    }
    else if([model.data_type isEqualToString:@"2"] || [model.data_type isEqualToString:@"8"] || [model.data_type isEqualToString:@"9"] || [model.data_type isEqualToString:@"10"] || [model.data_type isEqualToString:@"11"] || [model.data_type isEqualToString:@"12"]){//安全员和土木工程师等(4行)//土木工程师 公用设备师 电气工程师 监理工程师 造价工程师
        return [DDPeopleBelongCertiCell height];
    }
    else if([model.data_type isEqualToString:@"3"] || [model.data_type isEqualToString:@"4"] || [model.data_type isEqualToString:@"5"] || [model.data_type isEqualToString:@"6"] || [model.data_type isEqualToString:@"7"]){//建筑师等（3行）//一级结构师  二级结构师  化工工程师 一级建筑师  二级建筑师
        return [DDPeopleBelongCerti3Cell height];
    }
    else{//消防工程师（3行）
        return [DDPeopleBelongCerti3Cell height];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

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

#pragma mark 点击认领
#pragma mark DDPeopleBelongCerti2CellDelegate 代理
//点击认领
- (void)peopleBelongCerti2CellClaimClick:(DDPeopleBelongCerti2Cell*)cell{
    NSIndexPath * index = [_tableView indexPathForCell:cell];
    [self gotoPersonalIdentityCheckVC:index];
}
#pragma mark DDPeopleBelongCerti3CellDelegate 代理
- (void)peopleBelongCerti3CellClaimClick:(DDPeopleBelongCerti3Cell*)cell{
    NSIndexPath * index = [_tableView indexPathForCell:cell];
    [self gotoPersonalIdentityCheckVC:index];
}

#pragma mark DDPeopleBelongCertiCellDelegate 代理
//点击认领
- (void)peopleBelongCertiCellClaimClick:(DDPeopleBelongCertiCell*)cell{
    NSIndexPath * index = [_tableView indexPathForCell:cell];
    [self gotoPersonalIdentityCheckVC:index];
}

- (void)gotoPersonalIdentityCheckVC:(NSIndexPath*)index{
    DDPeopleBelongCertiModel *model=_dataSourceArr[index.section];
    DDPersonalClaimBenefitVC *vc=[[DDPersonalClaimBenefitVC alloc]init];
    vc.claimBenefitType = DDClaimBenefitTypeDefault;
    vc.peopleName = model.name;
    vc.peopleId = model.staff_info_id;
    [self.mainViewContoller.navigationController pushViewController:vc animated:YES];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:KRefreshUI object:nil];
}
@end
