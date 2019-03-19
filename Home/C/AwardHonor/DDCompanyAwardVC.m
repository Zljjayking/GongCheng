//
//  DDCompanyAwardVC.m
//  GongChengDD
//
//  Created by csq on 2018/5/29.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDCompanyAwardVC.h"
#import "MJRefresh.h"
#import "DDNavigationUtil.h"
#import "DataLoadingView.h"//加载页面
#import "DDNoResult2View.h"//无数据视图
#import "DDRewardGloryCell.h"//cell
#import "DDNewRewardGloryCell.h"
#import "DDSearchRewardGloryListModel.h"//model
#import "DDRewardGloryDetailVC.h"//获奖荣誉详情页面
#import "DDServiceWebViewVC.h"
@interface DDCompanyAwardVC ()<UITableViewDelegate,UITableViewDataSource>

{
    NSInteger currentPage;
    NSInteger pageCount;
    
    NSMutableDictionary *_dict;
    
    UILabel *_leftLab;//"搜索到"三个字的label
    UILabel *_numLabel;//总计数量label
    UILabel *_rightLab;//"个公司"三个字的label
    
    BOOL isLastData;
}
@property (nonatomic,strong) DataLoadingView *loadingView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) DDNoResult2View *noResultView;//无数据视图
@property (nonatomic,strong)NSMutableArray *dataSourceArr;

@end

@implementation DDCompanyAwardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self editNavItem];
    [self createTableView];
    [self createChooseBtns];
    [self createLoadView];
    [self requestData:YES];
}

-(void)editNavItem{
    self.title=@"获奖荣誉";
    self.view.backgroundColor=kColorBackGroundColor;
    self.navigationItem.leftBarButtonItem=[DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
    
    self.navigationItem.rightBarButtonItem=[DDUtils rightbuttonItemWithTitle:@"辅助证书" target:self action:@selector(rightButtonClick)];
}

//返回上一页面
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightButtonClick{
    DDServiceWebViewVC *checkVC = [DDServiceWebViewVC new];
    checkVC.hostUrl = [NSString stringWithFormat:@"%@enterprise_service/pages/handle_list.html?groupId=10",DD_baseService_Server];
    [self.navigationController pushViewController:checkVC animated:YES];
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
    _numLabel.text=@"";
    _numLabel.textColor=KColorBlackTitle;
    _numLabel.font=kFontSize26;
    [summaryView addSubview:_numLabel];
    
    _rightLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_numLabel.frame)+2, 15, 75, 15)];
    _rightLab.text=@"个获奖荣誉";
    _rightLab.textColor=KColorGreySubTitle;
    _rightLab.font=kFontSize26;
    [summaryView addSubview:_rightLab];
}

#pragma mark 创建加载视图
-(void)createLoadView{
    __weak __typeof(self) weakSelf=self;
    _noResultView=[[DDNoResult2View alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-KNavigationBarHeight)];
    [self.view addSubview:_noResultView];
    
    _loadingView = [[DataLoadingView alloc] initWithController:self];
    _loadingView.loadingTitle = KLoading;
    _loadingView.failureTitle = KLoadingFailure;
    _loadingView.reloadHandle = ^(void){
        [weakSelf requestData:YES];
    };
}

#pragma mark 请求数据
- (void)requestData:(BOOL)isRefresh{
    if (isRefresh) {
        [_loadingView showLoadingView];
        currentPage = 1;
    }
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:self.enterpriseId forKey:@"enterpriseId"];
    [params setValue:self.toAction forKey:@"toAction"];
    [params setValue:@"0" forKey:@"type"];
    [params setValue:[NSString stringWithFormat:@"%ld",(long)currentPage] forKey:@"current"];
    [params setValue:@"10" forKey:@"size"];
    
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_companyRewardGloryList params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
//        NSLog(@"**********获奖荣誉结果数据***************%@",responseObject)
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            currentPage+=1;
            if (isRefresh) {
                [_loadingView hiddenLoadingView];
                [self.dataSourceArr  removeAllObjects];
                if (self.tableView.mj_footer) {
                    [self.tableView.mj_footer  resetNoMoreData];
                }
            }
           
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
                NSArray *modelArr = [DDSearchRewardGloryListModel mj_objectArrayWithKeyValuesArray:listArr];
                [_dataSourceArr addObjectsFromArray:modelArr];
                if (_dataSourceArr.count<pageCount) {
                    isLastData = NO;
                }else{
                    isLastData = YES;
                }
                
            }
            else{
                
                [_noResultView showWithTitle:@"暂无相关获奖荣誉的信息" subTitle:@"去其他地方看看~" image:@"noResult_info"];
            }
            [self.tableView reloadData];
            [self  endRefrshing:YES];
        }
        else{
            [self  endRefrshing:NO];
            [_loadingView failureLoadingView];
        }
    }  failure:^(NSURLSessionDataTask *operation, id responseObject)  {
        [DDUtils showToastWithMessage:kRequestFailed];
        [_loadingView failureLoadingView];
    }];
}
-(void)endRefrshing:(BOOL)requestSucceed
{
    if (self.tableView) {
        if (self.tableView.mj_header.isRefreshing) {
            [self.tableView.mj_header  endRefreshing];
        }
        if (requestSucceed) {
            if (isLastData==NO && !self.tableView.mj_footer) {
                //如果不是最后一条数据 设置footer
                self.tableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                    [self requestData:NO];
                }];
            }
            else if (isLastData==YES && !self.tableView.mj_footer)
            {
                return;
            }
            else if(isLastData==YES && self.tableView.mj_footer)
            {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            else
            {
                if (self.tableView.mj_footer.isRefreshing) {
                    [self.tableView.mj_footer  endRefreshing];
                }
            }
        }
        else
        {
            if (self.tableView.mj_footer.isRefreshing) {
                [self.tableView.mj_footer  endRefreshing];
            }
            
        }
    }
}

//创建tableView
-(void)createTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 45, Screen_Width, Screen_Height-KNavigationBarHeight-45) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=kColorBackGroundColor;
    _tableView.showsVerticalScrollIndicator=YES;
    _tableView.estimatedRowHeight = 180;
    _tableView.separatorColor=KColorTableSeparator;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, KTableViewFooterViewHeight)];
    [_tableView registerClass:[DDNewRewardGloryCell class] forCellReuseIdentifier:@"DDNewRewardGloryCell"];
    
    __weak __typeof(self) weakSelf=self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestData:YES];
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
    DDSearchRewardGloryListModel *model=_dataSourceArr[indexPath.section];
    DDNewRewardGloryCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDNewRewardGloryCell" forIndexPath:indexPath];
    [cell loadDataWithModel:model];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DDSearchRewardGloryListModel *model=_dataSourceArr[indexPath.section];
    DDRewardGloryDetailVC *rewardGloryDetail=[[DDRewardGloryDetailVC alloc]init];
    rewardGloryDetail.reward_id=model.reward_id;
    rewardGloryDetail.reward_group=@"0";
    [self.navigationController pushViewController:rewardGloryDetail animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    DDSearchRewardGloryListModel *model=_dataSourceArr[indexPath.section];
    CGFloat cellHeight = 0.0;
    if (![DDUtils isEmptyString:model.enterprise_name]) {
        NSString *titleStr=[NSString stringWithFormat:@"<font color='#222222'>%@</font>",model.enterprise_name];
        NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithData:[titleStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        CGSize labelSize = [[NSString stringWithFormat:@"%@",[attributeStr string]] boundingRectWithSize:CGSizeMake(Screen_Width-WidthByiPhone6(24), 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:kFontSize34} context:nil].size;
        cellHeight = labelSize.height;
    }else{
        cellHeight = WidthByiPhone6(20);
    }
    if(![DDUtils isEmptyString:model.reward_type]){
        CGSize labelSize = [[NSString stringWithFormat:@"%@",model.reward_type] boundingRectWithSize:CGSizeMake(Screen_Width-WidthByiPhone6(115), 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:kFontSize28} context:nil].size;
        cellHeight += labelSize.height;
    }else{
        cellHeight += WidthByiPhone6(15);
    }
    if(![DDUtils isEmptyString:model.executor_defendant]){
        CGSize labelSize = [[NSString stringWithFormat:@"%@",model.executor_defendant] boundingRectWithSize:CGSizeMake(Screen_Width-WidthByiPhone6(115), 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:kFontSize28} context:nil].size;
        cellHeight += labelSize.height;
    }else{
        cellHeight += WidthByiPhone6(15);
    }
    return cellHeight+WidthByiPhone6(105);
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

-(NSMutableArray *)dataSourceArr{
    if (!_dataSourceArr) {
        _dataSourceArr = [[NSMutableArray alloc]init];
    }
    return _dataSourceArr;
}


@end
