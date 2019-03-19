//
//  DDTaxCreditVC.m
//  GongChengDD
//
//  Created by xzx on 2018/10/22.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDTaxCreditVC.h"
#import "DataLoadingView.h"
#import "DDNoResult2View.h"//无数据视图
#import "DDTaxCreditModel.h"//model
#import "DDTaxCreditCell.h"//cell
#import "MJRefresh.h"

@interface DDTaxCreditVC ()<UITableViewDelegate,UITableViewDataSource>

{
    NSMutableArray *_dataSourceArr;
    
    UILabel *_label1;
    CGRect _numFrame;
    UILabel *_totalNumLab;
    UILabel *_label2;
    CGRect _amountFrame;
    UILabel *_totalAmountLab;
    UILabel *_label3;
}
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) DataLoadingView *loadingView;
@property (nonatomic,strong) DDNoResult2View *noResultView;//无数据视图
@property (nonatomic,assign)NSInteger current;//当前页

@end

@implementation DDTaxCreditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kColorBackGroundColor;
    self.navigationItem.title = @"税务信用";
    self.navigationItem.leftBarButtonItem = [DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
    _dataSourceArr = [[NSMutableArray alloc]init];
    
    [self setupTableView];
    [self setupDataLoadingView];
    [self requestData];
}

#pragma mark 返回上一页
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupTableView{
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,0, Screen_Width, Screen_Height-KNavigationBarHeight) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor=[UIColor clearColor];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    _tableView.backgroundColor=kColorBackGroundColor;
    [self.tableView setSeparatorColor:KColorTableSeparator];
    self.tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width,KTableViewFooterViewHeight)];
    [self.view addSubview:self.tableView];
}

- (void)setupDataLoadingView{
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
    _current = 1;
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:self.enterpriseId forKey:@"entId"];
    [params setValue:[NSString stringWithFormat:@"%ld",_current] forKey:@"current"];
    [params setValue:@"10" forKey:@"size"];
    
//    http://192.168.1.137:8080/app/ectaxscore/?entId=40648&current=1&size=10
    
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_TaxCreditList params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"**********税务信用结果数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            
            [_dataSourceArr removeAllObjects];
            [_loadingView hiddenLoadingView];
            
             __weak __typeof(self) weakSelf=self;
            
            if ([response.data isKindOfClass:[NSDictionary class]]) {
                NSArray * list = response.data[KList];
                
                if (list.count>0) {
                    [_noResultView hide];
                    
                    NSArray * tempArray = [DDTaxCreditModel arrayOfModelsFromDictionaries:list error:nil];
                    [_dataSourceArr addObjectsFromArray:tempArray];
                    
                    //加载更多
                    if (list.count<10) {
                        [_tableView.mj_footer removeFromSuperview];
                    }else{
                        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                            [weakSelf addData];
                        }];
                    }
                    
                }else{
                    //数据为空
                    [_noResultView showWithTitle:@"暂无相关税务信用信息" subTitle:@"去其他地方看看~" image:@"noResult_content"];
                }
                
            }
            
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
- (void)addData{
    _current ++;
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:self.enterpriseId forKey:@"entId"];
    [params setValue:[NSString stringWithFormat:@"%ld",_current] forKey:@"current"];
    [params setValue:@"10" forKey:@"size"];
    
    
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_TaxCreditList params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"**********税务信用结果数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            
             __weak __typeof(self) weakSelf=self;
            
            if ([response.data isKindOfClass:[NSDictionary class]]) {
                NSArray * list = response.data[KList];
                
                if (list.count>0) {
                    [_noResultView hide];
                    
                    NSArray * tempArray = [DDTaxCreditModel arrayOfModelsFromDictionaries:list error:nil];
                    [_dataSourceArr addObjectsFromArray:tempArray];
                    
                    //加载更多
                    if (list.count<10) {
                        [_tableView.mj_footer removeFromSuperview];
                    }else{
                        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                            [weakSelf addData];
                        }];
                    }
                    
                }else{
                    //数据为空
                    [_noResultView showWithTitle:@"暂无相关税务信用信息" subTitle:@"去其他地方看看~" image:@"noResult_content"];
                }
                
            }
            
           
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
#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataSourceArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DDTaxCreditModel * model = _dataSourceArr[indexPath.section];
    
    static NSString * cellID = @"DDTaxCreditCell";
    DDTaxCreditCell * cell = (DDTaxCreditCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
    }
    
    
    [cell loadDataWithModel:model];
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 247;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}



@end
