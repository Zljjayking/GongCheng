//
//  DDSafeManAddApplyRecordVC.m
//  GongChengDD
//
//  Created by xzx on 2018/7/20.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDSafeManAddApplyRecordVC.h"
#import "MJRefresh.h"
#import "DataLoadingView.h"//加载页面
#import "DDNoResultView.h"//无数据视图
#import "DDBuilderAddApplyRecordModel.h"//model
#import "DDBuilderAddApplyRecordCell.h"//cell
#import "DDSafeManNewAddApplyVC.h"//安全员新培添加人员页面
#import "DDSafeManMoreAddApplyRecordDetailVC.h"//安全员添加报名记录详情页面
#import "DDBuilderAddApplyRecordDetailVC.h"
#import "DDSafeManAddApplyVC.h"//安全员继续教育添加人员页面

#import "DDNewRecordListCell.h"//cell
@interface DDSafeManAddApplyRecordVC ()<UITableViewDelegate,UITableViewDataSource>

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

@implementation DDSafeManAddApplyRecordVC

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
    if([_certType isEqualToString:@"3"]){
        //继续教育
        DDSafeManAddApplyVC *safeManNewAddApply=[[DDSafeManAddApplyVC alloc]init];
        safeManNewAddApply.agencyId=self.agencyId;
        safeManNewAddApply.agencyName=self.agencyName;
        safeManNewAddApply.certType = _certType;
        [self.navigationController pushViewController:safeManNewAddApply animated:YES];
    }else{
        //新培
        DDSafeManNewAddApplyVC *safeManAddApply=[[DDSafeManNewAddApplyVC alloc]init];
        safeManAddApply.agencyId=self.agencyId;
        safeManAddApply.agencyName=self.agencyName;
        [self.navigationController pushViewController:safeManAddApply animated:YES];
    }
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
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, KTableViewFooterViewHeight)];
    [self.view addSubview:_tableView];
    [_tableView registerClass:[DDNewRecordListCell class] forCellReuseIdentifier:@"DDNewRecordListCell"];
    
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
    [params setValue:self.certType forKey:@"trainType"];
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
    [params setValue:_certType forKey:@"trainType"];
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
    
    DDNewRecordListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DDNewRecordListCell" forIndexPath:indexPath];
    
    cell.companyLab.text=model.enterprise_name;
    cell.peopleLab.text=model.name;
    if([_certType isEqualToString:@"2"]){
        cell.numberLab.text=[NSString stringWithFormat:@"(%@)",model.id_card];
    }else{
        cell.numberLab.text=[NSString stringWithFormat:@"(%@)",model.cert_no];
    }
    if ((model.cert_no.length*10+model.name.length*15) > Screen_Width-24) {
        CGFloat width = (Screen_Width-24 - model.name.length*15);
        int index = (width/10)-3;
        
        NSString *numberStr = [[model.cert_no substringToIndex:index] stringByAppendingString:@"..."];
        
        cell.numberLab.text = [NSString stringWithFormat:@"(%@",numberStr];
    }
    cell.majorLab.text=@"报名截图已上传";
    cell.statusLab.text=@"确认成功";
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DDBuilderAddApplyRecordModel *recordModel=_dataSourceArr[indexPath.section];
    if([_certType isEqualToString:@"3"]){
        //继续教育
        DDSafeManAddApplyVC *safeManNewAddApply=[[DDSafeManAddApplyVC alloc]init];
        safeManNewAddApply.model = recordModel;
        safeManNewAddApply.agencyName = self.agencyName;
        [self.navigationController pushViewController:safeManNewAddApply animated:YES];
    }else{
        //新培
        DDSafeManNewAddApplyVC *safeManAddApply=[[DDSafeManNewAddApplyVC alloc]init];
        safeManAddApply.model = recordModel;
        safeManAddApply.agencyName = self.agencyName;
        [self.navigationController pushViewController:safeManAddApply animated:YES];
    }
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
