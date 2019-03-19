//
//  DDBuilderAddApplyRecordVC.m
//  GongChengDD
//
//  Created by xzx on 2018/7/20.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDBuilderAddApplyRecordVC.h"
#import "MJRefresh.h"
#import "DataLoadingView.h"//加载页面
#import "DDNoResultView.h"//无数据视图
#import "DDBuilderAddApplyRecordModel.h"//model
#import "DDBuilderAddApplyRecordCell.h"//cell
#import "DDBuilderAddApplyVC.h"//添加人员页面
#import "DDBuilderAddApplyRecordDetailVC.h"//添加报名记录详情页面

@interface DDBuilderAddApplyRecordVC ()<UITableViewDelegate,UITableViewDataSource>

{
    NSInteger currentPage;
    NSInteger pageCount;
    NSMutableArray *_dataSourceArr;
    NSMutableDictionary *_dict;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) DataLoadingView *loadingView;
@property (nonatomic,strong) DDNoResultView *noResultView;//无数据视图

@end

@implementation DDBuilderAddApplyRecordVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataSourceArr=[[NSMutableArray alloc]init];
    self.view.backgroundColor=kColorBackGroundColor;
    self.title=self.agencyName;
    self.navigationItem.leftBarButtonItem=[DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
    self.navigationItem.rightBarButtonItem=[DDUtils rightbuttonItemWithTitle:@"添加人员" target:self action:@selector(newAddApplyClick)];
    [self createTableView];
    [self createLoadView];
}

//返回上一页
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

//添加人员
-(void)newAddApplyClick{
    DDBuilderAddApplyVC *builderAddApply=[[DDBuilderAddApplyVC alloc]init];
    builderAddApply.agencyId=self.agencyId;
    builderAddApply.agencyName=self.agencyName;
    [self.navigationController pushViewController:builderAddApply animated:YES];
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
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-KNavigationBarHeight) style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, KTableViewFooterViewHeight)];
    
    __weak __typeof(self) weakSelf=self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestData];
    }];
}

#pragma mark 请求数据
- (void)requestData{
    currentPage = 1;
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:self.agencyId forKey:@"agencyId"];
    [params setValue:@"1" forKey:@"trainType"];
    [params setValue:[NSString stringWithFormat:@"%ld",currentPage] forKey:@"current"];
    [params setValue:@"10" forKey:@"size"];
    
    
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_signUpPeopleList params:params success:^(NSURLSessionDataTask *operation, id responseObject){
        NSLog(@"**********报名记录结果数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        __weak __typeof(self) weakSelf = self;
        if (response.isSuccess) {
            [_dataSourceArr removeAllObjects];
            [_loadingView hiddenLoadingView];
            _dict = responseObject[KData];
            pageCount = [_dict[@"totalCount"] integerValue];
            NSArray *listArr=_dict[@"list"];
            
            
            if (listArr.count!=0) {
                [_noResultView hiddenNoDataView];
                
                for (NSDictionary *dic in listArr) {
                    DDBuilderAddApplyRecordModel *model = [[DDBuilderAddApplyRecordModel alloc]initWithDictionary:dic error:nil];
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
                [_noResultView showNoResultViewWithTitle:@"暂无符合报名条件的人员" andMsg:@"点击添加人员看看~" andImage:@"noResult_content"];
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
    [params setValue:self.agencyId forKey:@"agencyId"];
    [params setValue:@"1" forKey:@"trainType"];
    [params setValue:[NSString stringWithFormat:@"%ld",currentPage] forKey:@"current"];
    [params setValue:@"10" forKey:@"size"];
    
    
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_signUpPeopleList params:params success:^(NSURLSessionDataTask *operation, id responseObject){
        NSLog(@"**********报名记录结果数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        __weak __typeof(self) weakSelf = self;
        if (response.isSuccess) {
            
            _dict = responseObject[KData];
            NSArray *listArr = _dict[@"list"];
            for (NSDictionary *dic in listArr) {
                DDBuilderAddApplyRecordModel *model = [[DDBuilderAddApplyRecordModel alloc]initWithDictionary:dic error:nil];
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
    DDBuilderAddApplyRecordModel *model=_dataSourceArr[indexPath.section];
    
    static NSString * cellID = @"DDBuilderAddApplyRecordCell";
    DDBuilderAddApplyRecordCell * cell = (DDBuilderAddApplyRecordCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
    }
    
    cell.companyLab.text=model.enterprise_name;
    cell.peopleLab.text=model.name;
    if (![DDUtils isEmptyString:model.cert_no]) {
        cell.numberLab.text=[NSString stringWithFormat:@"(%@)",model.cert_no];
    }
    else{
        cell.numberLab.text=@"";
    }
    if ((model.cert_no.length*10+model.name.length*15) > Screen_Width-24) {
        CGFloat width = (Screen_Width-24 - model.name.length*15);
        int index = (width/10)-3;
        
        NSString *numberStr = [[model.cert_no substringToIndex:index] stringByAppendingString:@"..."];
        
        cell.numberLab.text = [NSString stringWithFormat:@"(%@",numberStr];
    }
    cell.majorLab.text=model.major;
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DDBuilderAddApplyRecordModel *model=_dataSourceArr[indexPath.section];
    
    DDBuilderAddApplyRecordDetailVC *recordDetail=[[DDBuilderAddApplyRecordDetailVC alloc]init];
    recordDetail.agencyName=self.agencyName;
    recordDetail.companyName=model.enterprise_name;
    recordDetail.peopleName=model.name;
    recordDetail.certiNo=model.cert_no;
    recordDetail.majorName=model.major;
    recordDetail.hasB=model.has_b_certificate;
    recordDetail.validTime=model.validity_period_end;
    recordDetail.tel=model.tel;
    recordDetail.idCard=model.id_card;
    recordDetail.majorType = model.major_type;
    [self.navigationController pushViewController:recordDetail animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85;
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



@end
