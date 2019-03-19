//
//  DDMySuperVisionListVC.m
//  GongChengDD
//
//  Created by xzx on 2018/11/22.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDMySuperVisionListVC.h"
#import "DDFireEngineerDetail2Cell.h"//cell
#import "DDSuperVisionReportListVC.h"//半日报页面
#import "DDSuperVisionCompanyListVC.h"//公司中标监控页面
#import "DDTalentSubscribeBenefitVC.h"//人才订阅的好处介绍页面
#import "DDTalentSubscribeVC.h"//人才订阅页面
#import "DDProjectSubscribeBenefitVC.h"//中标监控好处页面
#import "DDProjectSubscribeVC.h"//中标监控页面
#import "DDTalentSubscribeDetailModel.h"//人才订阅详情信息model

@interface DDMySuperVisionListVC ()<UITableViewDelegate,UITableViewDataSource,SuperVisionCompanyDelete>

{
    NSString *_number;
}
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation DDMySuperVisionListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _number=@"0";
    self.view.backgroundColor=kColorBackGroundColor;
    [self createTableView];
    [self requestNumber];
}
-(void)SuperVisionCompanyDeleteSucceed{
    [self requestNumber];
}
#pragma mark 请求公司中标监控的数量
-(void)requestNumber{
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_uaattentionListCount params:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"***********公司中标监控数量请求数据***************%@",responseObject);
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {//请求成功
            _number= [NSString stringWithFormat:@"%@",responseObject[KData]];
            [self.tableView reloadData];
        }
        else{//显示异常
            [DDUtils showToastWithMessage:response.message];
        }
        
        [_tableView reloadData];
        
    } failure:^(NSURLSessionDataTask *operation, id responseObject) {
        [DDUtils showToastWithMessage:kRequestFailed];
    }];
}

//创建tableView
-(void)createTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-KNavigationBarHeight-45) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = kColorBackGroundColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:_tableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellID = @"DDFireEngineerDetail2Cell";
    DDFireEngineerDetail2Cell * cell = (DDFireEngineerDetail2Cell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
    }
    
    if (indexPath.section==0) {
        cell.titleLab.text=[NSString stringWithFormat:@"公司中标监控（%@）",_number];
    }
    else if(indexPath.section==1){
        cell.titleLab.text=@"中标区域、工程类别监控";
    }
    else if(indexPath.section==2){
        cell.titleLab.text=@"人员公开联系方式监控";
    }
    else if(indexPath.section==3){
        cell.titleLab.text=@"招标监控";
    }
    cell.titleLab.font=kFontSize34;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        DDSuperVisionCompanyListVC *vc=[[DDSuperVisionCompanyListVC alloc]init];
        vc.delegate = self;
        [self.mainViewContoller.navigationController pushViewController:vc animated:YES];
    }
    else if(indexPath.section==1){
        [self winBiddingClick];
        //DDSuperVisionReportListVC *vc=[[DDSuperVisionReportListVC alloc]init];
        //vc.passValue=@"2";
        //[self.mainViewContoller.navigationController pushViewController:vc animated:YES];
    }
    else if(indexPath.section==2){
        [self talentSubscribe];
        //DDSuperVisionReportListVC *vc=[[DDSuperVisionReportListVC alloc]init];
        //vc.passValue=@"1";
        //[self.mainViewContoller.navigationController pushViewController:vc animated:YES];
    }
    else if(indexPath.section==3){
        [self callBiddingClick];
        //DDSuperVisionReportListVC *vc=[[DDSuperVisionReportListVC alloc]init];
        //vc.passValue=@"3";
        //[self.mainViewContoller.navigationController pushViewController:vc animated:YES];
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

#pragma mark 人员监控点击
-(void)talentSubscribe{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [params setValue:@"1" forKey:@"monitorType"];
    
    __weak __typeof(self) weakSelf=self;
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_monitorDetailInfo params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"***********监控详情请求数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {//请求成功
            NSArray *listArr= responseObject[KData];
            if (listArr.count==0) {
                DDTalentSubscribeBenefitVC *talentSubscribe=[[DDTalentSubscribeBenefitVC alloc]init];
                talentSubscribe.hidesBottomBarWhenPushed=YES;
                [weakSelf.mainViewContoller.navigationController pushViewController:talentSubscribe animated:YES];
            }
            else{
                NSMutableArray *passRegionIds=[[NSMutableArray alloc]init];
                NSMutableArray *dataSource=[[NSMutableArray alloc]init];
                for (NSDictionary *dic in listArr) {
                    DDTalentSubscribeDetailModel *model=[[DDTalentSubscribeDetailModel alloc]initWithDictionary:dic error:nil];
                    [passRegionIds addObject:model.regionId];
                    [dataSource addObject:model];
                }
                DDTalentSubscribeDetailModel *model=dataSource[0];
                NSArray *passCertiTypes=[model.projectCertType componentsSeparatedByString:@","];
                
                DDTalentSubscribeVC *talentSubscribe=[[DDTalentSubscribeVC alloc]init];
                talentSubscribe.type=@"1";
                talentSubscribe.passRegionIds=passRegionIds;
                talentSubscribe.passCertiTypes=passCertiTypes;
                talentSubscribe.passDate=model.validityType;
                talentSubscribe.hidesBottomBarWhenPushed=YES;
                [weakSelf.mainViewContoller.navigationController pushViewController:talentSubscribe animated:YES];
            }
        }
        else{//显示异常
            [DDUtils showToastWithMessage:response.message];
        }
        
    } failure:^(NSURLSessionDataTask *operation, id responseObject) {
        [DDUtils showToastWithMessage:kRequestFailed];
    }];
}

#pragma mark 中标监控点击事件
-(void)winBiddingClick{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [params setValue:@"2" forKey:@"monitorType"];
    
    __weak __typeof(self) weakSelf=self;
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_monitorDetailInfo params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"***********中标监控详情请求数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {//请求成功
            NSArray *listArr= responseObject[KData];
            if (listArr.count==0) {
                DDProjectSubscribeBenefitVC *benefit=[[DDProjectSubscribeBenefitVC alloc]init];
                benefit.hidesBottomBarWhenPushed=YES;
                [weakSelf.mainViewContoller.navigationController pushViewController:benefit animated:YES];
            }
            else{
                NSMutableArray *passRegionIds=[[NSMutableArray alloc]init];
                NSMutableArray *passRegionStrs=[[NSMutableArray alloc]init];
                NSMutableArray *dataSource=[[NSMutableArray alloc]init];
                for (NSDictionary *dic in listArr) {
                    DDTalentSubscribeDetailModel *model=[[DDTalentSubscribeDetailModel alloc]initWithDictionary:dic error:nil];
                    [passRegionIds addObject:model.regionId];
                    [passRegionStrs addObject:model.name];
                    [dataSource addObject:model];
                }
                DDTalentSubscribeDetailModel *model=dataSource[0];
                NSArray *passCertiTypes=[model.projectCertType componentsSeparatedByString:@","];
                
                DDProjectSubscribeVC *projectSubscribe=[[DDProjectSubscribeVC alloc]init];
                projectSubscribe.type=@"1";
                projectSubscribe.passRegionIds=passRegionIds;
                projectSubscribe.passRegionStrs=passRegionStrs;
                projectSubscribe.passProjectTypes=passCertiTypes;
                projectSubscribe.hidesBottomBarWhenPushed=YES;
                [weakSelf.mainViewContoller.navigationController pushViewController:projectSubscribe animated:YES];
            }
        }
        else{//显示异常
            [DDUtils showToastWithMessage:response.message];
        }
        
    } failure:^(NSURLSessionDataTask *operation, id responseObject) {
        [DDUtils showToastWithMessage:kRequestFailed];
    }];
}

#pragma mark 招标监控点击事件
-(void)callBiddingClick{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [params setValue:@"3" forKey:@"monitorType"];
    __weak __typeof(self) weakSelf=self;
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_monitorDetailInfo params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"***********招标监控详情请求数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {//请求成功
            NSArray *listArr= responseObject[KData];
            if (listArr.count==0) {
                DDProjectSubscribeBenefitVC *benefit=[[DDProjectSubscribeBenefitVC alloc]init];
                benefit.isCallBidding=@"1";
                benefit.hidesBottomBarWhenPushed=YES;
                [weakSelf.mainViewContoller.navigationController pushViewController:benefit animated:YES];
            }
            else{
                NSMutableArray *passRegionIds=[[NSMutableArray alloc]init];
                NSMutableArray *passRegionStrs=[[NSMutableArray alloc]init];
                NSMutableArray *dataSource=[[NSMutableArray alloc]init];
                for (NSDictionary *dic in listArr) {
                    DDTalentSubscribeDetailModel *model=[[DDTalentSubscribeDetailModel alloc]initWithDictionary:dic error:nil];
                    [passRegionIds addObject:model.regionId];
                    [passRegionStrs addObject:model.name];
                    [dataSource addObject:model];
                }
                DDTalentSubscribeDetailModel *model=dataSource[0];
                NSArray *passCertiTypes=[model.projectCertType componentsSeparatedByString:@","];
                
                DDProjectSubscribeVC *projectSubscribe=[[DDProjectSubscribeVC alloc]init];
                projectSubscribe.isCallBidding=@"1";
                projectSubscribe.type=@"1";
                projectSubscribe.passRegionIds=passRegionIds;
                projectSubscribe.passRegionStrs=passRegionStrs;
                projectSubscribe.passProjectTypes=passCertiTypes;
                projectSubscribe.hidesBottomBarWhenPushed=YES;
                [weakSelf.mainViewContoller.navigationController pushViewController:projectSubscribe animated:YES];
            }
        }
        else{//显示异常
            [DDUtils showToastWithMessage:response.message];
        }
        
    } failure:^(NSURLSessionDataTask *operation, id responseObject) {
        [DDUtils showToastWithMessage:kRequestFailed];
    }];
}




@end
