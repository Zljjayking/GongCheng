//
//  DDConditionQueryVC.m
//  GongChengDD
//
//  Created by csq on 2018/11/7.
//  Copyright © 2018 Koncendy. All rights reserved.
//

#import "DDConditionQueryVC.h"
#import "MJRefresh.h"
#import "DDNavigationUtil.h"
#import "DDLoginCheckVC.h"//登录注册页面
#import "DataLoadingView.h"//加载页面
#import "DDNoResultView.h"//无数据视图
#import "DDSearchCompanyListModel.h"
#import "DDCompanyList2Cell.h"
#import "DDPeopleDetailVC.h"
#import "DDCompanyDetailVC.h"


@interface DDConditionQueryVC ()<UITableViewDelegate,UITableViewDataSource>{
     NSMutableArray *_dataSourceArr;
}
@property (nonatomic,assign)NSInteger currentPage;
@property (nonatomic,strong) DataLoadingView *loadingView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) DDNoResultView *noResultView;//无数据视图
@property (nonatomic,copy)NSString * totalNum;
@property (nonatomic, strong) UIView * header ;

@end

@implementation DDConditionQueryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kColorBackGroundColor;
    self.navigationItem.title = @"组合查找";
    self.navigationItem.leftBarButtonItem=[DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
    
    _dataSourceArr = [[NSMutableArray alloc] init];
    [self createTableView];
    [self requestData];
    [self createLoadView];
}

#pragma mark 创建tableView
-(void)createTableView{
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,0, Screen_Width, Screen_Height-KNavigationBarHeight) style:UITableViewStyleGrouped];
    _tableView.backgroundColor=kColorBackGroundColor;
    [self.view addSubview:_tableView];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.showsVerticalScrollIndicator=YES;
    _tableView.estimatedRowHeight = 162;
    _tableView.separatorColor=KColorTableSeparator;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, KTableViewFooterViewHeight)];
    
    __weak __typeof(self) weakSelf=self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestData];
    }];
}
#pragma mark 创建加载视图
-(void)createLoadView{
    __weak __typeof(self) weakSelf=self;
    _noResultView=[[DDNoResultView alloc]initWithFrame:CGRectMake(0,0, Screen_Width, Screen_Height-KNavigationBarHeight)];
    [self.view addSubview:_noResultView];
    _loadingView = [[DataLoadingView alloc] initWithController:self];
    _loadingView.loadingTitle = KLoading;
//    _loadingView.failureTitle = KLoadingFailure;
    _loadingView.reloadHandle = ^(void){
        [weakSelf requestData];
    };
    [_loadingView showLoadingView];
}
#pragma mark 请求数据
- (void)requestData{
    _currentPage = 1;
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:_passValueModel.region forKey:@"region"];
    [params setValue:_passValueModel.certTypeId forKey:@"certTypeId"];
    [params setValue:_passValueModel.certTypeLevel forKey:@"certTypeLevel"];
    [params setValue:_passValueModel.certType forKey:@"certType"];
    [params setValue:_passValueModel.certCode forKey:@"certCode"];
    [params setValue:_passValueModel.bidTime forKey:@"bidTime"];
    [params setValue:_passValueModel.bidRegion forKey:@"bidRegion"];
    [params setValue:_passValueModel.minMoney forKey:@"minMoney"];
    [params setValue:_passValueModel.maxMoney forKey:@"maxMoney"];
    [params setValue:_passValueModel.title forKey:@"title"];
    [params setValue:[NSString stringWithFormat:@"%ld",(long)_currentPage] forKey:@"current"];
    [params setValue:@"10" forKey:@"size"];
    [[DDHttpManager sharedInstance] sendPostRequest:KHttpRequest_scsolrcompanyConditionalQuery params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"查找结果  %@",responseObject);
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            [_loadingView hiddenLoadingView];
            [_dataSourceArr removeAllObjects];
            if ([response.data isKindOfClass:[NSDictionary class]]) {
                NSArray * list = (NSArray*)response.data[KList];
                if ([response.data[@"totalCount"] integerValue]>0) {
                    _totalNum = [NSString stringWithFormat:@"%@",response.data[@"totalCount"]];
                }
                for (NSDictionary *dic in list) {
                    DDSearchCompanyListModel *model = [[DDSearchCompanyListModel alloc]initWithDictionary:dic error:nil];
                    [model handle];
                    [_dataSourceArr addObject:model];
                }
                __weak __typeof(self) weakSelf = self;
                if (list.count<10) {
                    [self.tableView.mj_footer removeFromSuperview];
                }else{
                    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                        [weakSelf addData];
                    }];
                }
                if (_dataSourceArr.count>0) {
                    [_noResultView hiddenNoDataView];
                }else{
                    [_noResultView showNoResultViewWithTitle:@"企业信息" andImage:@"noResult_company"];
                }
            }
        }else{
            [DDUtils showToastWithMessage:response.message];
            [_loadingView failureLoadingView];
        }
        [_tableView.mj_header endRefreshing];
        [_tableView reloadData];
    } failure:^(NSURLSessionDataTask *operation, id responseObject) {
         [_tableView.mj_header endRefreshing];
        [DDUtils showToastWithMessage:kRequestFailed];
        [_loadingView failureLoadingView];
    }];
}
- (void)addData{
    _currentPage  ++;
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:_passValueModel.region forKey:@"region"];
    [params setValue:_passValueModel.certTypeId forKey:@"certTypeId"];
    [params setValue:_passValueModel.certTypeLevel forKey:@"certTypeLevel"];
    [params setValue:_passValueModel.certType forKey:@"certType"];
    [params setValue:_passValueModel.certCode forKey:@"certCode"];
    [params setValue:_passValueModel.bidTime forKey:@"bidTime"];
    [params setValue:_passValueModel.bidRegion forKey:@"bidRegion"];
    [params setValue:_passValueModel.minMoney forKey:@"minMoney"];
    [params setValue:_passValueModel.maxMoney forKey:@"maxMoney"];
    [params setValue:_passValueModel.title forKey:@"title"];
    [params setValue:[NSString stringWithFormat:@"%ld",_currentPage] forKey:@"current"];
    [params setValue:@"10" forKey:@"size"];
    
    [[DDHttpManager sharedInstance] sendPostRequest:KHttpRequest_scsolrcompanyConditionalQuery params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"查找结果  %@",responseObject);
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            [_loadingView hiddenLoadingView];
            if ([response.data isKindOfClass:[NSDictionary class]]) {
                NSArray * list = (NSArray*)response.data[KList];
                
                for (NSDictionary *dic in list) {
                    DDSearchCompanyListModel *model = [[DDSearchCompanyListModel alloc]initWithDictionary:dic error:nil];
                    [model handle];
                    [_dataSourceArr addObject:model];
                }
                
                __weak __typeof(self) weakSelf = self;
                
                if (list.count<10) {
                    [self.tableView.mj_footer removeFromSuperview];
                }else{
                    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                        [weakSelf addData];
                    }];
                }
                
            
            }
        }else{
            [DDUtils showToastWithMessage:response.message];
            [_loadingView failureLoadingView];
        }
         [_tableView.mj_footer endRefreshing];
         [_tableView reloadData];
    } failure:^(NSURLSessionDataTask *operation, id responseObject) {
        [_tableView.mj_footer endRefreshing];
        [DDUtils showToastWithMessage:kRequestFailed];
        [_loadingView failureLoadingView];
    }];
    
}
#pragma mark UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataSourceArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DDSearchCompanyListModel * model = _dataSourceArr[indexPath.section];
    
    static NSString * cellID = @"DDCompanyList2Cell";
    DDCompanyList2Cell * cell = (DDCompanyList2Cell*)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
    }
    
    [cell loadDataWithModel3:model];
    
    if (![DDUtils isEmptyString:model.legalRepresentative]) {
        cell.peopleBtn.userInteractionEnabled=NO;
        cell.peopleBtn.tag=indexPath.section;
        [cell.peopleBtn addTarget:self action:@selector(peopleBtnClick2:) forControlEvents:UIControlEventTouchUpInside];
    }
    else{
        cell.peopleBtn.userInteractionEnabled=NO;
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}


//点击跳转到人员详情页面
-(void)peopleBtnClick2:(UIButton *)sender{
    if ([DDUtils isEmptyString:[DDUserManager sharedInstance].userid]) {
//        [self presentLoginVCWithSender:sender];
    }
    else{
        DDSearchCompanyListModel *model=_dataSourceArr[sender.tag];
        
        DDPeopleDetailVC *peopleDetail=[[DDPeopleDetailVC alloc]init];
        peopleDetail.staffInfoId=model.staffInfoId;
        peopleDetail.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:peopleDetail animated:YES];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DDSearchCompanyListModel *model=_dataSourceArr[indexPath.section];

    DDCompanyDetailVC *companyDetail=[[DDCompanyDetailVC alloc]init];
    companyDetail.enterpriseId=model.enterpriseId;
    companyDetail.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:companyDetail animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //return 120;
    //    return UITableViewAutomaticDimension;
    DDSearchCompanyListModel * model = _dataSourceArr[indexPath.section];
    if(![DDUtils isEmptyString:model.unitName]){
        CGSize labelSize = [[NSString stringWithFormat:@"%@",model.unitName] boundingRectWithSize:CGSizeMake(Screen_Width-66, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:kFontSize34} context:nil].size;
        return labelSize.height+142;
    }
    return 162;;
    
    
    return [DDCompanyList2Cell height];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, WidthByiPhone6(44))];
        headView.backgroundColor = kColorNavBarGray;
        UILabel * lab = [UILabel labelWithFont:kFontSize26 textColor:KColorGreySubTitle textAlignment:NSTextAlignmentLeft numberOfLines:1];
        lab.frame = CGRectMake(WidthByiPhone6(12), 0, Screen_Width-WidthByiPhone6(20), WidthByiPhone6(44));
       
        NSString * totalStr = [NSString stringWithFormat:@"查询到%@家符合条件的公司",_totalNum];
        NSMutableAttributedString * attributedString =  [DDUtils adjustTextColor:totalStr rangeText:_totalNum color:KColorBlackTitle];
        lab.attributedText = attributedString;
        [headView addSubview:lab];
        return headView;
    }
        return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    DDSearchCompanyListModel *model=_dataSourceArr[section];
    
    if ([DDUtils isEmptyString:model.usedNames]) {
        return nil;
    }
    else{
        UIView *footerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 40)];
        footerView.backgroundColor=kColorWhite;
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(12, 12.5, Screen_Width-54, 15)];
        label.attributedText=model.usedNamesAttriString;
        label.font=kFontSize28;
        label.lineBreakMode = NSLineBreakByTruncatingTail;
        [footerView addSubview:label];
        
        UIButton *btn=[[UIButton alloc]initWithFrame:footerView.frame];
        [footerView addSubview:btn];
        btn.tag=150+section;
        [btn addTarget:self action:@selector(companyClick:) forControlEvents:UIControlEventTouchUpInside];
        
        return footerView;
    }
}

//点击公司名称
-(void)companyClick:(UIButton *)sender{
    DDSearchCompanyListModel *model=_dataSourceArr[sender.tag-150];
    DDCompanyDetailVC *companyDetail=[[DDCompanyDetailVC alloc]init];
    companyDetail.enterpriseId=model.enterpriseId;
    companyDetail.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:companyDetail animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return WidthByiPhone6(44);
    }
    else{
        return 15;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    DDSearchCompanyListModel *model=_dataSourceArr[section];
    
    if ([DDUtils isEmptyString:model.usedNames]) {
        return CGFLOAT_MIN;
    }
    else{
        return 40;
    }
}
#pragma mark 返回上一级
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//    [_textField resignFirstResponder];
}

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    _myOffset=scrollView.contentOffset.y;
//    if (_backClick==0 && _isOther==0) {
//        if (_myOffset>(Screen_Height-KNavigationBarHeight-KTabbarHeight-39-45)*2+80) {
//            self.tabBarItem=_item2;
//        }
//        else{
//            self.tabBarItem=_item1;
//        }
//    }
//    else{
//        //self.tabBarItem=_item1;
//    }
//}
@end
