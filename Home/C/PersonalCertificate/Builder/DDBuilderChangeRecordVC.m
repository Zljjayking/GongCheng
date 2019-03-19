//
//  DDBuilderChangeRecordVC.m
//  GongChengDD
//
//  Created by xzx on 2018/9/28.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDBuilderChangeRecordVC.h"
#import "DataLoadingView.h"
#import "DDBusinessLicenseChangeRecordCell.h"
#import "DDBusinessLicenseChangeModel.h"
#import "DDBusinessLicenseChangeSectionView.h"
#import "MJRefresh.h"
#import "DDNoResult2View.h"

@interface DDBuilderChangeRecordVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) DataLoadingView * loadingView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,strong) UILabel * headerLabel;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,strong) DDNoResult2View *noResultView;//无数据视图

@end

@implementation DDBuilderChangeRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kColorBackGroundColor;
    if ([self.type isEqualToString:@"1"]) {
        self.navigationItem.title = @"一级建造师变更记录";
    }
    else{
        self.navigationItem.title = @"二级建造师变更记录";
    }
    self.navigationItem.leftBarButtonItem = [DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
    _dataArray = [[NSMutableArray alloc] initWithCapacity:10];
    
    [self setupTableView];
    [self setupDataLoadingView];
    [self requestData];
}

#pragma mark leftButtonClick
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupTableView{
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,0.5, Screen_Width, Screen_Height-KNavigationBarHeight-190-45) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor=[UIColor whiteColor];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    //    [self.tableView setSeparatorColor:KColorTableSeparator];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width,KTableViewFooterViewHeight)];
    [self.view addSubview:self.tableView];
    
    __weak __typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestData];
    }];
}

- (void)setupDataLoadingView{
    _noResultView=[[DDNoResult2View alloc]initWithFrame:CGRectMake(0,0, Screen_Width, Screen_Height-KNavigationBarHeight)];
    [self.tableView addSubview:_noResultView];
    __weak __typeof(self) weakSelf = self;
    
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
    _page = 1;
    NSMutableDictionary * params = [[NSMutableDictionary alloc]initWithCapacity:3];
    [params setValue:self.staffId forKey:@"staffId"];
    [params setValue:self.type forKey:@"type"];
    [params setValue:[NSString stringWithFormat:@"%ld",_page] forKey:@"current"];
    [params setValue:@"15" forKey:@"size"];
    
    MBProgressHUD * hud = [DDUtils showHUDCustom:@""];
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_builderEngineerChangeDetail
                                           params:params
                                          success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"建造师变更记录%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            [hud hide:YES];
            [_loadingView hiddenLoadingView];
            [_dataArray removeAllObjects];
            
            NSDictionary * dataDict = (NSDictionary*)response.data;
            NSArray * listArray = (NSArray*)dataDict[KList];
            
            for (NSDictionary * dict in listArray) {
                DDBusinessLicenseChangeModel * tempModel = [[DDBusinessLicenseChangeModel alloc] initWithDictionary:dict error:nil];
                [tempModel handelData];
                [_dataArray addObject:tempModel];
            }
            
            //加载更多
            if (_dataArray.count< [dataDict[KTotalCount] integerValue]) {
                //加载更多
                _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                    [self addData];
                }];
            }else{
                [_tableView.mj_footer removeFromSuperview];
            }
            
            //没有数据
            if (_dataArray.count == 0) {
                [_noResultView showWithTitle:@"暂无变更记录" subTitle:nil image:@"noResult_content"];
            }else{
                [_noResultView hide];
            }
            
        }else{
            [_loadingView failureLoadingView];
            //            [DDUtils showToastWithMessage:response.message];
            hud.labelText = response.message;
            
        }
        [hud hide:YES afterDelay:KHudShowTimeSecound];
        [_tableView reloadData];
        [_tableView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask *operation, id responseObject) {
        hud.labelText = kRequestFailed;
        [_loadingView failureLoadingView];
        [_tableView.mj_header endRefreshing];
        [hud hide:YES afterDelay:KHudShowTimeSecound];
    }];
}

- (void)addData{
    _page ++;
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc]initWithCapacity:3];
    [params setValue:self.staffId forKey:@"staffId"];
    [params setValue:self.type forKey:@"type"];
    [params setValue:[NSString stringWithFormat:@"%ld",_page] forKey:@"current"];
    [params setValue:@"15" forKey:@"size"];
    
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_builderEngineerChangeDetail params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"建造师变更记录%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            [_loadingView hiddenLoadingView];
            
            NSDictionary * dataDict = (NSDictionary*)response.data;
            NSMutableArray * tempArray = [DDBusinessLicenseChangeModel arrayOfModelsFromDictionaries:dataDict[KList] error:nil];
            [_dataArray addObjectsFromArray:tempArray];
            
            //加载更多
            if (_dataArray.count< [dataDict[KTotalCount] integerValue]) {
                //加载更多
                _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                    [self addData];
                }];
            }else{
                [_tableView.mj_footer removeFromSuperview];
            }
            
        }else{
            [_loadingView failureLoadingView];
            [DDUtils showToastWithMessage:response.message];
            
        }
        [_tableView reloadData];
        [_tableView.mj_footer endRefreshing];
    } failure:^(NSURLSessionDataTask *operation, id responseObject) {
        [DDUtils showToastWithMessage:kRequestFailed];
        [_loadingView failureLoadingView];
        [_tableView.mj_footer endRefreshing];
    }];
}

#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableVie{
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cellID = @"DDBusinessLicenseChangeRecordCell";
    DDBusinessLicenseChangeRecordCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    DDBusinessLicenseChangeModel * model = _dataArray[indexPath.section];
    [cell loadWithModel:model];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    DDBusinessLicenseChangeModel * model = _dataArray[indexPath.section];
    return [DDBusinessLicenseChangeRecordCell heightWithModel:model];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return [DDBusinessLicenseChangeSectionView height];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    DDBusinessLicenseChangeModel * model = _dataArray[section];
    //BOOL showAllContent = [model.showAllContent boolValue];
    BOOL showMoreButton = [model.showMoreButton boolValue];
    
    if (YES == showMoreButton) {
        //显示更多按钮
        return 40;
    }else{
        //不显示更多按钮
        return 0.01;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    DDBusinessLicenseChangeSectionView * header = [[[NSBundle mainBundle] loadNibNamed:@"DDBusinessLicenseChangeSectionView" owner:self options:nil] firstObject];
    header.backgroundColor = [UIColor clearColor];
    DDBusinessLicenseChangeModel * model = _dataArray[section];
    [header loadWithModel:model section:section];
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    DDBusinessLicenseChangeModel * model = _dataArray[section];
    BOOL showAllContent = [model.showAllContent boolValue];
    BOOL showMoreButton = [model.showMoreButton boolValue];
    
    if (YES == showMoreButton) {
        //显示更多按钮
        UIView * footBgView = [[UIView alloc] init];
        footBgView.frame = CGRectMake(0, 0, Screen_Width, 40);
        footBgView.backgroundColor = [UIColor clearColor];
        
        UIView * footView = [[UIView alloc] init];
        footView.frame= CGRectMake(10, 0,(Screen_Width-20), 40);
        footView.backgroundColor = kColorNavBarGray;
        [footBgView addSubview:footView];
        
        //部分圆角
        UIBezierPath * fieldPath = [UIBezierPath bezierPathWithRoundedRect:footView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5 , 5)];
        CAShapeLayer * fieldLayer = [[CAShapeLayer alloc] init];
        fieldLayer.frame = footView.bounds;
        fieldLayer.path = fieldPath.CGPath;
        footView.layer.mask = fieldLayer;
        
        //线
        UIView * line = [[UIView alloc] init];
        line.frame = CGRectMake(0, 0, WIDTH(footView), 0.5);
        line.backgroundColor = KColorTableSeparator;
        [footView addSubview:line];
        
        UIButton * moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        moreButton.frame = CGRectMake(((WIDTH(footView)/2)-30), 1, 60,40);
        [moreButton setTitleColor:kColorBlue forState:UIControlStateNormal];
        moreButton.titleLabel.font = kFontSize28;
        [moreButton addTarget:self action:@selector(moreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        moreButton.tag = section;//把区号当做tag
        [footView addSubview:moreButton];
        
        //判断按钮的名称
        if (NO == showAllContent) {
            [moreButton setTitle:@"查看更多" forState:UIControlStateNormal];
        }else{
            [moreButton setTitle:@"收起更多" forState:UIControlStateNormal];
        }
        return footBgView;
    }else{
        //不显示更多按钮
        return nil;
    }
    
}

#pragma mark scrollView 已经滑动
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    NSLog(@"---scrollViewDidScroll");
//}

#pragma mark   更多,收起
- (void)moreButtonClick:(UIButton *)button{
    if (_dataArray.count > 0) {
        //把区号当做tag
        DDBusinessLicenseChangeModel * model = _dataArray[button.tag];
        
        BOOL showAllContent = [model.showAllContent boolValue];
        showAllContent = !showAllContent;
        //改变模型
        NSNumber *  result = [NSNumber numberWithBool:showAllContent];
        model.showAllContent = result;
        
        //刷新表
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
        });
    }
}



@end
