//
//  DDSafeManMoreTrainVC.m
//  GongChengDD
//
//  Created by xzx on 2018/7/13.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDSafeManMoreTrainVC.h"
#import "MJRefresh.h"
#import "DataLoadingView.h"//加载页面
#import "DDNoResultView.h"//无数据视图
#import "DDBuilderMoreTrain1Cell.h"
#import "DDBuilderMoreTrain2Cell.h"
#import "DDSafeManMoreTrainModel.h"//model
//#import "DDSafeManTelInputVC.h"//本人手机号录入页面
#import "DDSafeManPerfectPeopleInfoVC.h"//人员信息完善页面
#import "DDSafeManAgencySelectVC.h"//机构选择页面
#import "DDAgencySelectViewController.h"
#import "DDExaminKnowView.h"//报考须知
#import "AppDelegate.h"
@interface DDSafeManMoreTrainVC ()<UITableViewDelegate,UITableViewDataSource,DDExaminKnowViewDelegate>

{
    NSInteger selectIndex;
    NSInteger currentPage;
    NSInteger pageCount;
    NSMutableArray *_dataSourceArr;
    NSMutableDictionary *_dict;
    
    UILabel *_leftLab;//"搜索到"三个字的label
    UILabel *_numLabel;//总计数量label
    UILabel *_rightLab;//"个公司"三个字的label
}
@property(nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) DataLoadingView *loadingView;
@property (nonatomic,strong) DDNoResultView *noResultView;//无数据视图
@property(nonatomic,strong) DDExaminKnowView *knowView;
@end

@implementation DDSafeManMoreTrainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataSourceArr=[[NSMutableArray alloc]init];
    self.view.backgroundColor=kColorBackGroundColor;
    self.title=@"安全员继续教育";
    self.navigationItem.leftBarButtonItem=[DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
    self.navigationItem.rightBarButtonItem=[DDUtils rightbuttonItemWithTitle:@"添加报名" target:self action:@selector(addAssignClick)];
    [self createChooseBtns];
    [self createTableView];
    [self createLoadView];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self requestData];
}

//返回上一页
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

//筛选按钮
#pragma mark 创建筛选按钮
-(void)createChooseBtns{
    //搜索结果统计
    UIView *summaryView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 45)];
    [self.view addSubview:summaryView];
    
    _leftLab=[[UILabel alloc]initWithFrame:CGRectMake(12, 15, 15, 15)];
    _leftLab.text=@"共";
    _leftLab.textColor=KColorGreySubTitle;
    _leftLab.font=kFontSize26;
    [summaryView addSubview:_leftLab];
    
    _numLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_leftLab.frame)+2, 15, 1, 15)];
    _numLabel.text=@"0";
    _numLabel.textColor=KColorGreySubTitle;
    _numLabel.font=kFontSize26;
    [summaryView addSubview:_numLabel];
    
    _rightLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_numLabel.frame)+2, 15, 180, 15)];
    _rightLab.text=@"个安全员符合报名条件";
    _rightLab.textColor=KColorGreySubTitle;
    _rightLab.font=kFontSize26;
    [summaryView addSubview:_rightLab];
}

#pragma mark 创建加载视图
-(void)createLoadView{
    __weak __typeof(self) weakSelf=self;
    _noResultView=[[DDNoResultView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-KNavigationBarHeight)];
    [self.view addSubview:_noResultView];
    
    _loadingView = [[DataLoadingView alloc] initWithController:self];
    _loadingView.loadingTitle = KLoading;
    _loadingView.failureTitle = KLoadingFailure;
    _loadingView.reloadHandle = ^(void){
        [weakSelf requestData];
    };
    [_loadingView showLoadingView];
}

//创建tableView
-(void)createTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 45, Screen_Width, Screen_Height-KNavigationBarHeight-45) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.showsVerticalScrollIndicator=YES;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,Screen_Width, KTableViewFooterViewHeight)];
    
    __weak __typeof(self) weakSelf=self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestData];
    }];
}

#pragma mark 请求数据
- (void)requestData{
    currentPage = 1;
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:[NSString stringWithFormat:@"%ld",currentPage] forKey:@"current"];
    [params setValue:@"10" forKey:@"size"];
    [params setValue:_companyID forKey:@"enterpriseId"];
    
    [[DDHttpManager sharedInstance]sendPostRequest:KHttpRequest_safeManMoreEduList params:params success:^(NSURLSessionDataTask *operation, id responseObject){
        NSLog(@"**********安全员继续教育列表数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        __weak __typeof(self) weakSelf = self;
        if (response.isSuccess) {
            [_dataSourceArr removeAllObjects];
            [_loadingView hiddenLoadingView];
            _dict = responseObject[KData];
            pageCount = [_dict[@"trainAbcList"][@"totalCount"] integerValue];
            NSArray *listArr=_dict[@"trainAbcList"][@"list"];
            
            //给数量label赋值
            NSString *totlaNum=[NSString stringWithFormat:@"%@",_dict[@"canRegistrationCount"]];
            _numLabel.text=totlaNum;
            CGRect numberFrame = [totlaNum boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
            _numLabel.frame=CGRectMake(CGRectGetMaxX(_leftLab.frame)+2, 15, numberFrame.size.width, 15);
            _rightLab.frame=CGRectMake(CGRectGetMaxX(_numLabel.frame)+2, 15, 180, 15);
            
            
            if (listArr.count!=0) {
                [_noResultView hiddenNoDataView];
                
                for (NSDictionary *dic in listArr) {
                    DDSafeManMoreTrainModel *model = [[DDSafeManMoreTrainModel alloc]initWithDictionary:dic error:nil];
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
                [_noResultView showNoResultViewWithTitle:@"暂无符合报名条件的人员" andMsg:@"点击添加报名看看~" andImage:@"noResult_content"];
            }
            
        }
        else{
            
            [_loadingView failureLoadingView];
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
    [params setValue:[NSString stringWithFormat:@"%ld",currentPage] forKey:@"current"];
    [params setValue:@"10" forKey:@"size"];
    [params setValue:_companyID forKey:@"enterpriseId"];
    [[DDHttpManager sharedInstance]sendPostRequest:KHttpRequest_safeManMoreEduList params:params success:^(NSURLSessionDataTask *operation, id responseObject){
        NSLog(@"**********安全员继续教育列表数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        __weak __typeof(self) weakSelf = self;
        if (response.isSuccess) {
            
            _dict = responseObject[KData];
            NSArray *listArr = _dict[@"trainAbcList"][@"list"];
            for (NSDictionary *dic in listArr) {
                DDSafeManMoreTrainModel *model = [[DDSafeManMoreTrainModel alloc]initWithDictionary:dic error:nil];
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
            [DDUtils showToastWithMessage:response.message];
        }
        
        //[self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
        
    }  failure:^(NSURLSessionDataTask *operation, id responseObject)  {
        [DDUtils showToastWithMessage:kRequestFailed];
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
    DDSafeManMoreTrainModel *model=_dataSourceArr[indexPath.section];
    
    if ([model.registration_status isEqualToString:@"2"]) {//直接置灰的那种，有已中标项目的那种
        static NSString * cellID = @"DDBuilderMoreTrain1Cell";
        DDBuilderMoreTrain1Cell * cell = (DDBuilderMoreTrain1Cell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
        }
        
        //临时标签隐藏
        cell.tempLab.hidden=YES;
        
        //中标项目标签
        cell.bidLab.hidden = NO;
        if ([DDUtils isEmptyString:model.project_count]) {
            cell.bidLab.text=[NSString stringWithFormat:@"已中标项目：0个"];
        }
        else{
            cell.bidLab.text=[NSString stringWithFormat:@"已中标项目：%@个",model.project_count];
        }
        if ([DDUtils isEmptyString:model.name]) {
            cell.nameLab.text=[NSString stringWithFormat:@"%ld.",indexPath.section];
        }
        else{
            cell.nameLab.text=[NSString stringWithFormat:@"%ld.%@",indexPath.section+1,model.name];
        }
        
        cell.majorLab1.text=@"证书类别:";
        cell.majorLab2.text=model.cert_type;
        
        cell.numberLab1.text=@"证书号:";
        cell.numberLab2.text=model.cert_no;
        
        cell.haveBLab1.text=@"状态:";
        cell.haveBLab2.text=model.cert_state;
        
        cell.timeLab2.text=model.validity_period_end;
        NSString *resultStr = [DDUtils newCompareTimeSpaceIn90:model.validity_period_end];
        if ([resultStr isEqualToString:@"2"]) {
            cell.timeLab2.textColor=kColorBlue;
        }else if ([resultStr isEqualToString:@"1"]){
            cell.timeLab2.textColor=KColorTextOrange;
        } else{
            cell.timeLab2.textColor=kColorRed;
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    else{
        static NSString * cellID = @"DDBuilderMoreTrain2Cell";
        DDBuilderMoreTrain2Cell * cell = (DDBuilderMoreTrain2Cell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
        }
        
        if ([model.registration_status isEqualToString:@"0"]) {//未报名
            //临时标签隐藏
            cell.tempLab.hidden=YES;
            
            if ([DDUtils isEmptyString:model.name]) {
                cell.nameLab.text=[NSString stringWithFormat:@"%ld.",indexPath.section];
            }
            else{
                cell.nameLab.text=[NSString stringWithFormat:@"%ld.%@",indexPath.section+1,model.name];
            }
            cell.nameLab.textColor=KColorBlackTitle;
            
            [cell.telBtn setTitle:@"在线报名" forState:UIControlStateNormal];
            cell.telBtn.tag=indexPath.section;
            cell.telBtn.userInteractionEnabled=YES;
            [cell.telBtn addTarget:self action:@selector(telNumberRecord:) forControlEvents:UIControlEventTouchUpInside];
            [cell.telBtn setTitleColor:kColorBlue forState:UIControlStateNormal];
            cell.telBtn.layer.borderColor=kColorBlue.CGColor;
            
            cell.telLab.text=model.tel_after;
            cell.telLab.textColor=KColorBlackSubTitle;

            cell.majorLab1.text=@"证书类别:";
            cell.majorLab1.textColor=KColorGreySubTitle;
            
            cell.majorLab2.text=model.cert_type;
            cell.majorLab2.textColor=KColorBlackSubTitle;
            
            cell.numberLab1.text=@"证书号:";
            cell.numberLab1.textColor=KColorGreySubTitle;
            
            cell.numberLab2.text=model.cert_no;
            cell.numberLab2.textColor=KColorBlackSubTitle;
            
            cell.haveBLab1.text=@"状态:";
            cell.haveBLab1.textColor=KColorGreySubTitle;
            
            if ([model.cert_state isEqualToString:@"有效"]) {
                cell.haveBLab2.text=model.cert_state;
                cell.haveBLab2.textColor=KColorBlackSubTitle;
            }
            else{
                cell.haveBLab2.text=model.cert_state;
                cell.haveBLab2.textColor=kColorRed;
            }
            
            cell.timeLab1.textColor=KColorGreySubTitle;
            
            cell.timeLab2.text=model.validity_period_end;
            NSString *resultStr = [DDUtils newCompareTimeSpaceIn90:model.validity_period_end];
            if ([resultStr isEqualToString:@"2"]) {
                cell.timeLab2.textColor=kColorBlue;
            }else if ([resultStr isEqualToString:@"1"]){
                cell.timeLab2.textColor=KColorTextOrange;
            } else{
                cell.timeLab2.textColor=kColorRed;
            }
        }
        else if([model.registration_status isEqualToString:@"1"] || [model.registration_status isEqualToString:@"3"]) {//已报名、正在报名
            //临时标签隐藏
            cell.tempLab.hidden=YES;
            
            if ([DDUtils isEmptyString:model.name]) {
                cell.nameLab.text=[NSString stringWithFormat:@"%ld.",indexPath.section];
            }
            else{
                cell.nameLab.text=[NSString stringWithFormat:@"%ld.%@",indexPath.section+1,model.name];
            }
            cell.nameLab.textColor=KColorBidApprovalingWait;
            
            if ([model.registration_status isEqualToString:@"3"]) { // 正在报名
                [cell.telBtn setTitle:@"正在报名" forState:UIControlStateNormal];
            } else {
                [cell.telBtn setTitle:@"已报名" forState:UIControlStateNormal];
            }
            cell.telBtn.userInteractionEnabled=NO;
            [cell.telBtn setTitleColor:KColorBidApprovalingWait forState:UIControlStateNormal];
            cell.telBtn.layer.borderColor=KColorBidApprovalingWait.CGColor;
            
            cell.telLab.text=model.tel_after;
            cell.telLab.textColor=KColorBidApprovalingWait;
            
            cell.majorLab1.textColor=KColorBidApprovalingWait;
            
            cell.majorLab2.text=model.cert_type;
            cell.majorLab2.textColor=KColorBidApprovalingWait;
            
            cell.numberLab1.text=@"证书号:";
            cell.numberLab1.textColor=KColorBidApprovalingWait;
            
            cell.numberLab2.text=model.cert_no;
            cell.numberLab2.textColor=KColorBidApprovalingWait;
            
            cell.haveBLab1.text=@"状态:";
            cell.haveBLab1.textColor=KColorBidApprovalingWait;
            
            cell.haveBLab2.text=model.cert_state;
            cell.haveBLab2.textColor=KColorBidApprovalingWait;
            
            cell.timeLab1.textColor=KColorBidApprovalingWait;
            
            cell.timeLab2.text=model.validity_period_end;
            NSString *resultStr = [DDUtils newCompareTimeSpaceIn90:model.validity_period_end];
            if ([resultStr isEqualToString:@"2"]) {
                cell.timeLab2.textColor=kColorBlue;
            }else if ([resultStr isEqualToString:@"1"]){
                cell.timeLab2.textColor=KColorTextOrange;
            } else{
                cell.timeLab2.textColor=kColorRed;
            }
            
        }
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
}
#pragma mark -- DDExaminKnowViewDelegate
-(void)closeViewWithAgree:(BOOL)isAgree{
    kWeakSelf
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.knowView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [weakSelf.knowView removeFromSuperview];
        weakSelf.knowView = nil;
    }];
    
    if(isAgree){
        DDSafeManMoreTrainModel *model=_dataSourceArr[selectIndex];
        
        DDSafeManPerfectPeopleInfoVC *safeManPerfectPeopleInfo=[[DDSafeManPerfectPeopleInfoVC alloc]init];
        safeManPerfectPeopleInfo.certType=model.cert_type_id;
        //safeManPerfectPeopleInfo.trainType=@"3";
        safeManPerfectPeopleInfo.staffInfoId=model.staff_info_id;
        
        safeManPerfectPeopleInfo.tel=model.tel;
        safeManPerfectPeopleInfo.peopleName=model.name;
        if ([DDUtils isEmptyString:model.cert_type]) {
            safeManPerfectPeopleInfo.majorName=@"";
        }
        else{
            safeManPerfectPeopleInfo.majorName=[NSString stringWithFormat:@"%@类",model.cert_type];
        }
        safeManPerfectPeopleInfo.certiNo=model.cert_no;
        safeManPerfectPeopleInfo.certiState=model.cert_state;
        safeManPerfectPeopleInfo.endTime=model.validity_period_end;
        safeManPerfectPeopleInfo.endDays=model.validity_period_end_days;
        
        safeManPerfectPeopleInfo.certiTypeId=model.cert_type_id;
        
        safeManPerfectPeopleInfo.telAfter=model.tel_after;
        safeManPerfectPeopleInfo.idCard=model.id_card;
        safeManPerfectPeopleInfo.companyName=model.employment_enterprise;
        
        [self.navigationController pushViewController:safeManPerfectPeopleInfo animated:YES];

    }
}
#pragma mark 本人手机号录入
-(void)telNumberRecord:(UIButton *)sender{
    _knowView = [[DDExaminKnowView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
    _knowView.delegate = self;
    selectIndex = sender.tag;
    AppDelegate *app =(AppDelegate *)[UIApplication sharedApplication].delegate;
    UIViewController *rootViewController1 = app.window.rootViewController;
    [rootViewController1.view addSubview:_knowView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 155;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
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
    return CGFLOAT_MIN;
}

#pragma mark 添加报名
-(void)addAssignClick{
    
    DDAgencySelectViewController *agencySelectVC = [[DDAgencySelectViewController alloc] init];
    agencySelectVC.trainType = DDTrainTypeSafetyOfficerContinue;
    agencySelectVC.isFromeAddApply = @"1";
    [self.navigationController pushViewController:agencySelectVC animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (_knowView) {
        [_knowView removeFromSuperview];
        _knowView = nil;
    }
}

@end
