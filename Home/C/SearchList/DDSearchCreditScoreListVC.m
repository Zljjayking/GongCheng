//
//  DDSearchCreditScoreListVC.m
//  GongChengDD
//
//  Created by xzx on 2018/9/20.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDSearchCreditScoreListVC.h"
#import "MJRefresh.h"
#import "DDNavigationUtil.h"
#import "DDLoginCheckVC.h"
#import "DataLoadingView.h"//加载页面
#import "DDNoResultView.h"//无数据视图

#import "DDAreaSelectTableView.h"//市的选择View
#import "DDScoreSelectView.h"//分数筛选的View

#import "DDSearchCreditScoreListCell.h"//cell
#import "DDSearchCreditScoreListModel.h"//model

#import "DDSearchHistoryDAOAndDB.h"//搜索历史数据库操作类

#import "DDCompanyCreditScoreListVC.h"//信用评分详情页面
#import "DDUMengEventDefines.h"

@interface DDSearchCreditScoreListVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,AreaSelectTableViewDelegate,DDScoreSelectViewDelegate>

{
    UIView *_topBgView;
    UITextField *_textField;
    
    NSInteger currentPage;
    NSInteger pageCount;
    NSMutableArray *_dataSourceArr;
    NSMutableDictionary *_dict;
    
    UILabel *_label1;//放左边那个城市选择文字

    UILabel *_label2;//放右边那个资质等级选择文字
    
    UILabel *_leftLab;//"搜索到"三个字的label
    UILabel *_numLabel;//总计数量label
    UILabel *_rightLab;//"个公司"三个字的label
    
    BOOL _isCitySelected;//判断是否点开了城市选择视图
    BOOL _isScoreSelected;//判断是否点开了分数筛选视图
    
    NSString *_region;//地区筛选
    NSString *_min;//最小分数
    NSString *_max;//最大分数
}
@property (nonatomic,strong) DataLoadingView *loadingView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) DDNoResultView *noResultView;//无数据视图
@property (nonatomic,strong) UIImageView *imgView1;//放左边那个城市选择小箭头
@property (nonatomic,strong) DDAreaSelectTableView *areaSelectTableView;//区域筛选视图
@property (nonatomic,strong) UIImageView *imgView2;//放右边那个资质等级选择小箭头
@property (nonatomic,strong) DDScoreSelectView *scoreSelectView;//分数筛选视图

@end

@implementation DDSearchCreditScoreListVC

-(void)viewWillDisappear:(BOOL)animated{
    [_topBgView removeFromSuperview];
    //还原导航底部线条颜色
    //[DDNavigationUtil setNavigationBottomLineNomalColor:self.navigationController];
}

//-(void)viewDidAppear:(BOOL)animated{
//    [self.navigationController.navigationBar addSubview:_topBgView];
//    //导航底部线条设为透明
//    [DDNavigationUtil setNavigationBottomLineClearColor:self.navigationController];
//}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar addSubview:_topBgView];
    //导航底部线条设为透明
    //[DDNavigationUtil setNavigationBottomLineClearColor:self.navigationController];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [MobClick event:main_huojiangrongyu];
    _region=@"";//地区筛选
    _min=@"";
    _max=@"";
    _isCitySelected=NO;
    _isScoreSelected=NO;
    _dataSourceArr=[[NSMutableArray alloc]init];
    [self editNavItem];
    [_textField becomeFirstResponder];
    [self createTableView];
    [self createChooseBtns];
    [self createLoadView];
    [self requestData];
}

//定制导航条
-(void)editNavItem{
    self.view.backgroundColor=kColorBackGroundColor;
    self.navigationItem.leftBarButtonItem=[DDUtils leftButtonItemWithImage:@"Nav_back_blue" highlightedImage:@"Nav_back_blue" target:self action:@selector(popBackClick)];
    self.navigationItem.rightBarButtonItem=[DDUtils rightbuttonItemWithTitle:@"筛选" target:self action:@selector(areaSelectClick)];
    
    _topBgView=[[UIView alloc]initWithFrame:CGRectMake(60, 4.5, Screen_Width-60-60-10, 35)];
    _topBgView.backgroundColor=KColorSearchTextFieldGrey;
    _topBgView.layer.cornerRadius=3;
    _topBgView.clipsToBounds=YES;
    [self.navigationController.navigationBar addSubview:_topBgView];
    
    
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 15, 15)];
    imageView.image=[UIImage imageNamed:@"cm_Search_icon"];
    [_topBgView addSubview:imageView];
    
    _textField=[[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+10, 0, _topBgView.frame.size.width-20-10-10, 35)];
    _textField.delegate=self;
    _textField.text=self.searchText;
    [_textField setValue:KColorGreyLight forKeyPath:@"_placeholderLabel.textColor"];
    [_textField setValue:kFontSize30 forKeyPath:@"_placeholderLabel.font"];
    _textField.clearButtonMode=UITextFieldViewModeAlways;
    [_topBgView addSubview:_textField];
    _textField.returnKeyType = UIReturnKeySearch;
    //添加观察文本框的改变
    [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

//返回上一页
-(void)popBackClick{
    //先发通知收弹出视图
    [_areaSelectTableView hiddenActionSheet];
    [_scoreSelectView hiddenActionSheet];
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)viewDidDisappear:(BOOL)animated{
    if (self.navigationController==NULL) {
        [_areaSelectTableView hiddenActionSheet];
        [_scoreSelectView hiddenActionSheet];
    }
    else{
        _imgView1.image=[UIImage imageNamed:@"home_search_down"];
        [_areaSelectTableView hidden];
        _isCitySelected=NO;
    }
}

#pragma mark 监听文本框文字的改变,此时要关联三个子页面的刷新
- (void)textFieldDidChange:(UITextField *)textField{
    UITextRange *rang = textField.markedTextRange; // 获取非=选中状态文字范围
    if (rang == nil) { // 没有非选中状态文字.就是确定的文字输入
        if ([textField.text isEqual:@""]) {
            [self popBackClick];
        }
        else{
            if (textField.text.length<2) {
                //[DDUtils showToastWithMessage:@"关键词长度不够！"];
            }
            else{
                self.searchText=_textField.text;
                
                [NSObject cancelPreviousPerformRequestsWithTarget:self];
                [self performSelector:@selector(requestData) withObject:nil afterDelay:0.5];
                //[self requestData];
            }
        }
    }
}
//筛选按钮
#pragma mark 创建筛选按钮
-(void)createChooseBtns{
    //搜索结果统计
    UIView *summaryView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 45)];
    [self.view addSubview:summaryView];
    
    _leftLab=[[UILabel alloc]initWithFrame:CGRectMake(12, 15, 45, 15)];
    _leftLab.text=@"搜索到";
    _leftLab.textColor=KColorGreySubTitle;
    _leftLab.font=kFontSize26;
    [summaryView addSubview:_leftLab];
    
    _numLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_leftLab.frame)+2, 15, 1, 15)];
    _numLabel.text=@"";
    _numLabel.textColor=KColorBlackTitle;
    _numLabel.font=kFontSize26;
    [summaryView addSubview:_numLabel];
    
    _rightLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_numLabel.frame)+2, 15, 45, 15)];
    _rightLab.text=@"家公司";
    _rightLab.textColor=KColorGreySubTitle;
    _rightLab.font=kFontSize26;
    [summaryView addSubview:_rightLab];
    
    _areaSelectTableView=[[DDAreaSelectTableView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-KNavigationBarHeight)];
    _areaSelectTableView.attachHeight=@"-45";
    __weak __typeof(self) weakSelf=self;
    _areaSelectTableView.hiddenBlock = ^{
        weakSelf.imgView1.image=[UIImage imageNamed:@"home_search_down"];
        [weakSelf.areaSelectTableView hidden];
        
        _isCitySelected=NO;
    };
    _areaSelectTableView.delegate=self;
    [_areaSelectTableView show];
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

#pragma mark 请求数据
- (void)requestData{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    _tableView.scrollEnabled=NO;
    _tableView.userInteractionEnabled=NO;
    
    if (_dataSourceArr.count>0) {
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    }
    
    currentPage = 1;
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:self.searchText forKey:@"keys"];
    [params setValue:self.menuId forKey:@"searchType"];
    [params setValue:_min forKey:@"minScore"];
    [params setValue:_max forKey:@"maxScore"];
    [params setValue:_region forKey:@"region"];
    [params setValue:[NSString stringWithFormat:@"%ld",currentPage] forKey:@"page"];
    [params setValue:@"10" forKey:@"rows"];
    
    [[DDHttpManager sharedInstance]sendPostRequest:KHttpRequest_creditScoreSearchList params:params success:^(NSURLSessionDataTask *operation, id responseObject){
        NSLog(@"**********信用评分搜索结果数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        __weak __typeof(self) weakSelf = self;
        [_loadingView hiddenLoadingView];
        if (response.isSuccess) {
            if (![response isEmpty]) {
                //[_dataSourceArr removeAllObjects];
                [_loadingView hiddenLoadingView];
                _dict = responseObject[KData];
                pageCount = [_dict[@"numFound"] integerValue];
                NSArray *listArr=_dict[@"result"];
                
                //给数量label赋值
                NSString *totlaNum=[NSString stringWithFormat:@"%@",_dict[@"numFound"]];
                _numLabel.text=totlaNum;
                CGRect numberFrame = [totlaNum boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
                _numLabel.frame=CGRectMake(CGRectGetMaxX(_leftLab.frame)+2, 15, numberFrame.size.width, 15);
                _rightLab.frame=CGRectMake(CGRectGetMaxX(_numLabel.frame)+2, 15, 45, 15);
                
                if (listArr.count!=0) {
                    [_noResultView hiddenNoDataView];
                    [_dataSourceArr removeAllObjects];
                    for (NSDictionary *dic in listArr) {
                        DDSearchCreditScoreListModel *model = [[DDSearchCreditScoreListModel alloc]initWithDictionary:dic error:nil];
                        
                        
                        if (![DDUtils isEmptyString:model.enterpriseName]) {
                            NSString *titleStr=[NSString stringWithFormat:@"<font color='#222222'>%@</font>",model.enterpriseName];
                            NSAttributedString *title = [[NSAttributedString alloc] initWithData:[titleStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
                            model.enterpriseNameAttrStr=title;
                        }
                        
                        
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
                    [_noResultView showNoResultViewWithTitle:@"信用评分信息" andImage:@"noResult_info"];
                }
            }
            else{
                [_noResultView showNoResultViewWithTitle:@"信用评分信息" andImage:@"noResult_info"];
            }
        }
        else{
            [_noResultView showNoResultViewWithTitle:@"信用评分信息" andImage:@"noResult_info"];
        }
        
        [self.tableView.mj_header endRefreshing];
        
        if (_dataSourceArr.count>0) {
            [_tableView reloadData];
            [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        }
        _tableView.scrollEnabled=YES;
        _tableView.userInteractionEnabled=YES;
        
    }  failure:^(NSURLSessionDataTask *operation, id responseObject)  {
        [DDUtils showToastWithMessage:kRequestFailed];
        [_loadingView failureLoadingView];
    }];
}

- (void)addData{
    currentPage++;
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [params setValue:self.searchText forKey:@"keys"];
    [params setValue:self.menuId forKey:@"searchType"];
    [params setValue:_region forKey:@"region"];
    [params setValue:_min forKey:@"minScore"];
    [params setValue:_max forKey:@"maxScore"];
    [params setValue:[NSString stringWithFormat:@"%ld",currentPage] forKey:@"page"];
    [params setValue:@"10" forKey:@"rows"];
    
    [[DDHttpManager sharedInstance]sendPostRequest:KHttpRequest_creditScoreSearchList params:params success:^(NSURLSessionDataTask *operation, id responseObject){
        NSLog(@"**********信用评分搜索结果数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        __weak __typeof(self) weakSelf = self;
        if (response.isSuccess) {
            if (![response isEmpty]) {
                _dict = responseObject[KData];
                NSArray *listArr = _dict[@"result"];
                for (NSDictionary *dic in listArr) {
                    DDSearchCreditScoreListModel *model = [[DDSearchCreditScoreListModel alloc]initWithDictionary:dic error:nil];
                    
                    
                    if (![DDUtils isEmptyString:model.enterpriseName]) {
                        NSString *titleStr=[NSString stringWithFormat:@"<font color='#222222'>%@</font>",model.enterpriseName];
                        NSAttributedString *title = [[NSAttributedString alloc] initWithData:[titleStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
                        model.enterpriseNameAttrStr=title;
                    }
                    
                    
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
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 45, Screen_Width, Screen_Height-KNavigationBarHeight-45) style:UITableViewStyleGrouped];
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
        //        _tableView.scrollEnabled=NO;
        //        _tableView.userInteractionEnabled=NO;
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
    if (_dataSourceArr.count>0) {
        DDSearchCreditScoreListModel *model=_dataSourceArr[indexPath.section];
        
        static NSString * cellID = @"DDSearchCreditScoreListCell";
        DDSearchCreditScoreListCell * cell = (DDSearchCreditScoreListCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
        }
        
        [cell loadDataWithModel:model];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    else{
        static NSString * cellID = @"DDSearchCreditScoreListCell";
        DDSearchCreditScoreListCell * cell = (DDSearchCreditScoreListCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
        }
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _imgView1.image=[UIImage imageNamed:@"home_search_down"];
    [_areaSelectTableView hidden];
    _isCitySelected=NO;
    if ([DDUtils isEmptyString:[DDUserManager sharedInstance].userid]) {
        [self presentLoginVCWithIndexPath:indexPath];
    }
    else{
        DDSearchCreditScoreListModel *model=_dataSourceArr[indexPath.section];
        //此时需要存数据库了
        //存最近搜索
        [DDSearchHistoryDAOAndDB insertRecentSearchByTypeId:self.menuId andSearchText:self.searchText];
        //存浏览历史
        NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithData:[model.enterpriseName dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        [DDSearchHistoryDAOAndDB insertHistorySearchByTypeId:self.menuId andSearchResult:[DDUtils transformAttributedText:attributeStr] andGlobalType:nil andTransId:model.enterpriseId];
        
        DDCompanyCreditScoreListVC *rewardGloryDetail=[[DDCompanyCreditScoreListVC alloc]init];
        rewardGloryDetail.enterpriseId=model.enterpriseId;
        [self.navigationController pushViewController:rewardGloryDetail animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //return 150;
    return UITableViewAutomaticDimension;
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

#pragma mark 点击城市选择
-(void)areaSelectClick{
    if (_isCitySelected==NO) {
        //将日期筛选隐藏
        _imgView2.image=[UIImage imageNamed:@"home_search_down"];
        [_scoreSelectView hiddenActionSheet];
        _isScoreSelected=NO;
        
        
        _imgView1.image=[UIImage imageNamed:@"home_search_up"];
        
        [_areaSelectTableView noHidden];
        [_textField resignFirstResponder];
        
        _isCitySelected=YES;
    }
    else{
        _imgView1.image=[UIImage imageNamed:@"home_search_down"];
        
        //[_areaSelectTableView hiddenActionSheet];
        [_areaSelectTableView hidden];
        
        _isCitySelected=NO;
    }
}

#pragma mark AreaSelectTableViewDelegate代理回调
-(void)actionsheetDisappear:(DDAreaSelectTableView *)actionSheet andAreaStr:(NSString *)areaStr andRegionId:(NSString *)regionId{
    _region=regionId;
    [self requestData];
}

#pragma mark 点击日期筛选
-(void)moneySelectClick{
    if (_isScoreSelected==NO) {
        //将区域筛选隐藏
        _imgView1.image=[UIImage imageNamed:@"home_search_down"];
        //[_areaSelectTableView hiddenActionSheet];
        [_areaSelectTableView hidden];
        _isCitySelected=NO;
        
        
        _imgView2.image=[UIImage imageNamed:@"home_search_up"];
        
        _scoreSelectView=[[DDScoreSelectView alloc]initWithFrame:CGRectMake(0, 39+60, Screen_Width, Screen_Height-KNavigationBarHeight-39-60)];
        _scoreSelectView.attachHeight=@"0";
        _scoreSelectView.min=_min;
        _scoreSelectView.max=_max;
        __weak __typeof(self) weakSelf=self;
        _scoreSelectView.hiddenBlock = ^{
            weakSelf.imgView2.image=[UIImage imageNamed:@"home_search_down"];
            
            [weakSelf.scoreSelectView hiddenActionSheet];
            
            _isScoreSelected=NO;
        };
        _scoreSelectView.delegate=self;
        [_scoreSelectView show];
        [_textField resignFirstResponder];
        
        _isScoreSelected=YES;
    }
    else{
        _imgView2.image=[UIImage imageNamed:@"home_search_down"];
        
        [_scoreSelectView hiddenActionSheet];
        
        _isScoreSelected=NO;
    }
}

#pragma mark DDScoreSelectViewDelegate代理回调
-(void)actionsheetDisappear:(DDScoreSelectView *)actionSheet andMin:(NSString *)min andMax:(NSString *)max andScoreStr:(NSString *)scoreStr{
    _min=min;
    _max=max;
    
    CGRect rightTextFrame = [scoreStr boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
    CGFloat rightWidth=rightTextFrame.size.width+4+15;
    if (rightWidth>=(Screen_Width/2-40)) {
        _label2.frame=CGRectMake(20, 12, (Screen_Width/2-40)-4-15, 15);
        _imgView2.frame=CGRectMake(CGRectGetMaxX(_label2.frame)+4, 12, 15, 15);
    }
    else{
        _label2.frame=CGRectMake((Screen_Width/2-rightWidth)/2, 12, rightWidth-4-15, 15);
        _imgView2.frame=CGRectMake(CGRectGetMaxX(_label2.frame)+4, 12, 15, 15);
    }
    
    _label2.text=scoreStr;
    
    [self requestData];
}

#pragma mark 弹出登录注册页面
- (void)presentLoginVCWithIndexPath:(NSIndexPath *)indexPath{
    DDLoginCheckVC * vc = [[DDLoginCheckVC alloc] init];
    vc.loginSuccessBlock = ^{
        //__weak __typeof(self) weakSelf=self;
        //[weakSelf requestTypesData];
        
        DDSearchCreditScoreListModel *model=_dataSourceArr[indexPath.section];
        //此时需要存数据库了
        //存最近搜索
        [DDSearchHistoryDAOAndDB insertRecentSearchByTypeId:self.menuId andSearchText:self.searchText];
        //存浏览历史
        NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithData:[model.enterpriseName dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        [DDSearchHistoryDAOAndDB insertHistorySearchByTypeId:self.menuId andSearchResult:[DDUtils transformAttributedText:attributeStr] andGlobalType:nil andTransId:model.enterpriseId];
        
        DDCompanyCreditScoreListVC *rewardGloryDetail=[[DDCompanyCreditScoreListVC alloc]init];
        rewardGloryDetail.enterpriseId=model.enterpriseId;
        [self.navigationController pushViewController:rewardGloryDetail animated:YES];
    };
    
    
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [DDNavigationUtil setNavigationAndBottomLineWhiteColor:nav];
    [self showViewController:nav sender:nil];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [_textField resignFirstResponder];
}


@end
