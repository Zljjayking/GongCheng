//
//  DDAdminPunishCreditChinaVC.m
//  GongChengDD
//
//  Created by xzx on 2018/10/22.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDAdminPunishCreditChinaVC.h"
#import "DDLabelUtil.h"
#import "MJRefresh.h"
#import "DDNavigationUtil.h"
#import "DataLoadingView.h"//加载页面
#import "DDNoResult2View.h"//无数据视图
#import "DDAdminPunishCell.h"//cell
#import "DDSearchAdminPunishListModel.h"//model
#import "DDAdminPunishDetailVC.h"//行政处罚详情页面

@interface DDAdminPunishCreditChinaVC ()<UITableViewDelegate,UITableViewDataSource>

{
    NSInteger currentPage;
    NSInteger pageCount;
    NSMutableArray *_dataSourceArr;
    NSMutableDictionary *_dict;
    
    UILabel *_leftLab;//"搜索到"三个字的label
    UILabel *_numLabel;//总计数量label
    UILabel *_rightLab;//"个公司"三个字的label
}
@property (nonatomic,strong) DataLoadingView *loadingView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) DDNoResult2View *noResultView;//无数据视图

@end

@implementation DDAdminPunishCreditChinaVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataSourceArr=[[NSMutableArray alloc]init];
    [self editNavItem];
    [self createTableView];
    //[self createChooseBtns];
    [self createLoadView];
    [self requestData];
}

-(void)editNavItem{
    self.view.backgroundColor=kColorBackGroundColor;
    self.navigationItem.leftBarButtonItem=[DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
}

//返回上一页面
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

////筛选按钮
//#pragma mark 创建筛选按钮
//-(void)createChooseBtns{
//    //搜索结果统计
//    UIView *summaryView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 45)];
//    [self.view addSubview:summaryView];
//
//    _leftLab=[[UILabel alloc]initWithFrame:CGRectMake(12, 15, 15, 15)];
//    _leftLab.text=@"共";
//    _leftLab.textColor=KColorGreySubTitle;
//    _leftLab.font=kFontSize26;
//    [summaryView addSubview:_leftLab];
//
//    _numLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_leftLab.frame)+2, 15, 1, 15)];
//    _numLabel.text=@"";
//    _numLabel.textColor=KColorBlackTitle;
//    _numLabel.font=kFontSize26;
//    [summaryView addSubview:_numLabel];
//
//    _rightLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_numLabel.frame)+2, 15, 75, 15)];
//    _rightLab.text=@"个行政处罚";
//    _rightLab.textColor=KColorGreySubTitle;
//    _rightLab.font=kFontSize26;
//    [summaryView addSubview:_rightLab];
//}

#pragma mark 创建加载视图
-(void)createLoadView{
    __weak __typeof(self) weakSelf=self;
    _noResultView=[[DDNoResult2View alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-KNavigationBarHeight)];
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
    [params setValue:self.enterpriseId forKey:@"enterpriseId"];
    [params setValue:self.toAction forKey:@"toAction"];
    [params setValue:@"6" forKey:@"type"];
    [params setValue:[NSString stringWithFormat:@"%ld",currentPage] forKey:@"current"];
    [params setValue:@"10" forKey:@"size"];
    
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_companyAdminPunishList params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"**********行政处罚信用中国结果数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        __weak __typeof(self) weakSelf = self;
        if (response.isSuccess) {
            [_dataSourceArr removeAllObjects];
            [_loadingView hiddenLoadingView];
            _dict = responseObject[KData];
            pageCount = [_dict[@"totalCount"] integerValue];
            NSArray *listArr=_dict[@"list"];
            
            //给数量label赋值
            NSString *totlaNum=[NSString stringWithFormat:@"%@",_dict[@"totalCount"]];
            _numLabel.text=totlaNum;
            CGRect numberFrame = [totlaNum boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
            _numLabel.frame=CGRectMake(CGRectGetMaxX(_leftLab.frame)+2, 15, numberFrame.size.width, 15);
            _rightLab.frame=CGRectMake(CGRectGetMaxX(_numLabel.frame)+2, 15, 75, 15);
            
            if (listArr.count!=0) {
                [_noResultView hide];
                
                for (NSDictionary *dic in listArr) {
                    DDSearchAdminPunishListModel *model = [[DDSearchAdminPunishListModel alloc]initWithDictionary:dic error:nil];
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
//                [_noResultView showWithTitle:@"暂无相关行政处罚的信息" subTitle:@"去其他地方看看~" image:@"noResult_info"];
                [_noResultView showWithTitle:@"暂无相关信息" titleColor:kColorGrey subTitle:@"" subTitleColor:kColorGrey image:@"noResult_content"];
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
    [params setValue:self.enterpriseId forKey:@"enterpriseId"];
    [params setValue:self.toAction forKey:@"toAction"];
    [params setValue:@"6" forKey:@"type"];
    [params setValue:[NSString stringWithFormat:@"%ld",currentPage] forKey:@"current"];
    [params setValue:@"10" forKey:@"size"];
    
    
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_companyAdminPunishList params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"**********行政处罚信用中国结果数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        __weak __typeof(self) weakSelf = self;
        if (response.isSuccess) {
            
            _dict = responseObject[KData];
            NSArray *listArr = _dict[@"list"];
            for (NSDictionary *dic in listArr) {
                DDSearchAdminPunishListModel *model = [[DDSearchAdminPunishListModel alloc]initWithDictionary:dic error:nil];
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

//创建tableView
-(void)createTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-KNavigationBarHeight-45) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=kColorBackGroundColor;
    _tableView.showsVerticalScrollIndicator=YES;
    _tableView.estimatedRowHeight = 44;
    _tableView.separatorColor=KColorTableSeparator;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, KTableViewFooterViewHeight)];
    
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
    DDSearchAdminPunishListModel *model=_dataSourceArr[indexPath.section];
    
    static NSString * cellID = @"DDAdminPunishCell";
    DDAdminPunishCell * cell = (DDAdminPunishCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
         cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    cell.peopleBtn.hidden = YES;
    [cell loadDataWithContent:model.punish_name andDept:model.bulletin_department andTime:model.punish_time];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DDSearchAdminPunishListModel *model=_dataSourceArr[indexPath.section];
    
    DDAdminPunishDetailVC *adminPunishDetail=[[DDAdminPunishDetailVC alloc]init];
    adminPunishDetail.punish_id=model.punish_id;
    [self.mainViewContoller.navigationController pushViewController:adminPunishDetail animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //DDSearchAdminPunishListModel *model=_dataSourceArr[indexPath.section];
    //return [DDLabelUtil getSpaceLabelHeight:model.punish_name withFont:kFontSize32 withWidth:Screen_Width-34]+65;
    return UITableViewAutomaticDimension;
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
