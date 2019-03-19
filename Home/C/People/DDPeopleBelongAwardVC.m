//
//  DDPeopleBelongAwardVC.m
//  GongChengDD
//
//  Created by xzx on 2018/5/28.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDPeopleBelongAwardVC.h"
#import "DDLabelUtil.h"
#import "MJRefresh.h"
#import "DataLoadingView.h"//加载页面
#import "DDNoResult2View.h"//无数据视图
#import "DDCourtNoticeCell.h"//cell
#import "DDPeopleBelongAwardModel.h"//model

#import "DDRewardGloryDetailVC.h"//获奖情况详情页面

@interface DDPeopleBelongAwardVC ()<UITableViewDelegate,UITableViewDataSource>

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

@implementation DDPeopleBelongAwardVC

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
    
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_peopleDetailReward params:params success:^(NSURLSessionDataTask *operation, id responseObject){
        NSLog(@"**********人员获奖荣誉信息数据***************%@",responseObject);
        
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
                        DDPeopleBelongAwardModel *model = [[DDPeopleBelongAwardModel alloc]initWithDictionary:dic error:nil];
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
                    [_noResultView showWithTitle:@"暂无相关获奖荣誉的信息" subTitle:@"去其他地方看看~" image:@"noResult_content"];
                }
            }
            else{
                [_noResultView showWithTitle:@"暂无相关获奖荣誉的信息" subTitle:@"去其他地方看看~" image:@"noResult_content"];
            }
        }
        else{
            [_noResultView showWithTitle:@"暂无相关获奖荣誉的信息" subTitle:@"去其他地方看看~" image:@"noResult_content"];
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
    
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_peopleDetailReward params:params success:^(NSURLSessionDataTask *operation, id responseObject){
        NSLog(@"**********人员获奖荣誉信息数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        __weak __typeof(self) weakSelf = self;
        if (response.isSuccess) {
            if (![response isEmpty]) {
                _dict = responseObject[KData];
                NSArray *listArr = _dict[@"list"];
                for (NSDictionary *dic in listArr) {
                    DDPeopleBelongAwardModel *model = [[DDPeopleBelongAwardModel alloc]initWithDictionary:dic error:nil];
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
    DDPeopleBelongAwardModel *model=_dataSourceArr[indexPath.section];
    
    static NSString * cellID = @"DDCourtNoticeCell";
    DDCourtNoticeCell * cell = (DDCourtNoticeCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    cell.titleLab.text=model.enterprise_name;
    cell.typeLab1.text=@"获得奖项:";
    cell.typeLab2.text=model.reward_type;
    cell.peopleLab1.text=@"实施部门:";
    cell.peopleLab2.text=model.executor_defendant;
    cell.timeLab1.text=@"发布时间:";
    cell.timeLab2.text=model.reward_issue_time;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DDPeopleBelongAwardModel *model=_dataSourceArr[indexPath.section];
    
    DDRewardGloryDetailVC *rewardGloryDetail=[[DDRewardGloryDetailVC alloc]init];
    rewardGloryDetail.reward_id=model.reward_id;
    rewardGloryDetail.reward_group=model.reward_group;
    [self.mainViewContoller.navigationController pushViewController:rewardGloryDetail animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //return 145;
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




@end
