//
//  DDSearchBiddingListVC.m
//  GongChengDD
//
//  Created by xzx on 2018/5/31.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDSearchBiddingListVC.h"
#import "MJRefresh.h"
#import "DDNavigationUtil.h"
#import "DDLoginCheckVC.h"
#import "DataLoadingView.h"//加载页面
#import "DDNoResultView.h"//无数据视图
#import "DDProjectListCell.h"//cell
#import "DDAreaSelectTableView.h"//市的选择View
#import "DDMoneySelectView.h"//金额筛选View
#import "DDSearchProjectListModel.h"//model
#import "DDSearchHistoryDAOAndDB.h"//搜索历史数据库操作类
#import "DDGainBiddingDetailVC.h"//中标详情页面
#import "DDCompanyDetailVC.h"//公司详情页面
#import "DDPeopleDetailVC.h"//人员详情页面
#import "DDUMengEventDefines.h"

@interface DDSearchBiddingListVC ()<UITableViewDelegate,UITableViewDataSource,AreaSelectTableViewDelegate,MoneySelectViewDelegate,UITextFieldDelegate>

{
    UIView *_topBgView;
    UITextField *_textField;
    
    NSInteger currentPage;
    NSInteger pageCount;
    NSMutableArray *_dataSourceArr;
    NSMutableDictionary *_dict;
    
    UILabel *_label1;//放左边那个城市选择文字
    UILabel *_label2;//放右边那个金额选择文字
    
    UILabel *_leftLab;//"搜索到"三个字的label
    UILabel *_numLabel;//总计数量label
    UILabel *_rightLab;//"个公司"三个字的label
    
    BOOL _isCitySelected;//判断是否点开了城市选择视图
    BOOL _isMoneySelected;//判断是否点开了金额筛选视图
    
    NSString *_amount;//金额筛选
    NSString *_region;//地区筛选
    NSString *_amountRecord;//用来金额高亮显示用
}
@property (nonatomic,strong) DataLoadingView *loadingView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) DDNoResultView *noResultView;//无数据视图
@property (nonatomic,strong) UIImageView *imgView1;//放左边那个城市选择小箭头
@property (nonatomic,strong) DDAreaSelectTableView *areaSelectTableView;//区域筛选视图
@property (nonatomic,strong) UIImageView *imgView2;//放右边那个金额选择小箭头
@property (nonatomic,strong) DDMoneySelectView *moneySelectView;//金额筛选视图

@end

@implementation DDSearchBiddingListVC

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
    
    [MobClick event:main_chazhongbiao];
    self.view.backgroundColor=kColorBackGroundColor;
    _amount=@"";//金额筛选
    _region=@"";//地区筛选
    _amountRecord=@"";
    _isCitySelected=NO;
    _isMoneySelected=NO;
    _dataSourceArr=[[NSMutableArray alloc]init];
    [self editNavItem];
    [_textField becomeFirstResponder];
    
    [self createChooseBtns];
    [self createTableView];
    [self createLoadView];
    [self requestData];
}

//定制导航条
-(void)editNavItem{
    self.view.backgroundColor=kColorBackGroundColor;
    self.navigationItem.leftBarButtonItem=[DDUtils leftButtonItemWithImage:@"Nav_back_blue" highlightedImage:@"Nav_back_blue" target:self action:@selector(popBackClick)];
    
    _topBgView=[[UIView alloc]initWithFrame:CGRectMake(60, 4.5, Screen_Width-80, 35)];
    _topBgView.backgroundColor=KColorSearchTextFieldGrey;
    _topBgView.layer.cornerRadius=3;
    _topBgView.clipsToBounds=YES;
    [self.navigationController.navigationBar addSubview:_topBgView];
    
    
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 15, 15)];
    imageView.image=[UIImage imageNamed:@"cm_Search_icon"];
    [_topBgView addSubview:imageView];
    
    _textField=[[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+10, 0, Screen_Width-80-10-20-10, 35)];
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
    [_moneySelectView hiddenActionSheet];
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)viewDidDisappear:(BOOL)animated{
    if (self.navigationController==NULL) {
        [_areaSelectTableView hiddenActionSheet];
        [_moneySelectView hiddenActionSheet];
    }
    else{
        _imgView1.image=[UIImage imageNamed:@"home_search_down"];
        [_areaSelectTableView hidden];
        _isCitySelected=NO;
        _imgView2.image=[UIImage imageNamed:@"home_search_down"];
        [_moneySelectView hiddenActionSheet];
        _isMoneySelected=NO;
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

#pragma mark 创建加载视图
-(void)createLoadView{
    __weak __typeof(self) weakSelf=self;
    _noResultView=[[DDNoResultView alloc]initWithFrame:CGRectMake(0, 39, Screen_Width, Screen_Height-KNavigationBarHeight-39)];
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
    [params setValue:@"2" forKey:@"type"];
    [params setValue:_region forKey:@"region"];
    [params setValue:_amount forKey:@"amount"];
    [params setValue:[NSString stringWithFormat:@"%ld",currentPage] forKey:@"page"];
    [params setValue:@"10" forKey:@"rows"];
    
    
    [[DDHttpManager sharedInstance]sendPostRequest:KHttpRequest_queryHighLightList params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"**********PPP查中标搜索结果数据***************%@",responseObject);
        
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
                        DDSearchProjectListModel *model = [[DDSearchProjectListModel alloc]initWithDictionary:dic error:nil];
                        [model handle];
                    
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
                    [_noResultView showNoResultViewWithTitle:@"中标信息" andImage:@"noResult_project"];
                }
            }
            else{
                [_noResultView showNoResultViewWithTitle:@"中标信息" andImage:@"noResult_project"];
            }
        }
        else{
            [_noResultView showNoResultViewWithTitle:@"中标信息" andImage:@"noResult_project"];
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
    [params setValue:@"2" forKey:@"type"];
    [params setValue:_region forKey:@"region"];
    [params setValue:_amount forKey:@"amount"];
    [params setValue:[NSString stringWithFormat:@"%ld",currentPage] forKey:@"page"];
    [params setValue:@"10" forKey:@"rows"];
    
    
    [[DDHttpManager sharedInstance]sendPostRequest:KHttpRequest_queryHighLightList params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"**********PPP查中标搜索结果数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        __weak __typeof(self) weakSelf = self;
        if (response.isSuccess) {
            if (![response isEmpty]) {
                _dict = responseObject[KData];
                NSArray *listArr = _dict[@"result"];
                for (NSDictionary *dic in listArr) {
                    DDSearchProjectListModel *model = [[DDSearchProjectListModel alloc]initWithDictionary:dic error:nil];
                    [model handle];
                    
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


#pragma mark 创建筛选按钮
-(void)createChooseBtns{
    //地区选择按钮
    UIButton *areaSelectBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, Screen_Width/2, 39)];
    [areaSelectBtn setBackgroundColor:kColorWhite];
    
    _label1=[[UILabel alloc]init];
    _label1.text=@"全国";
    _label1.textColor=KColorBlackTitle;
    _label1.font=kFontSize30;
    [areaSelectBtn addSubview:_label1];
    
    _imgView1=[[UIImageView alloc]init];
    _imgView1.contentMode = UIViewContentModeScaleAspectFit;
    _imgView1.image=[UIImage imageNamed:@"home_search_down"];
    [areaSelectBtn addSubview:_imgView1];
    [areaSelectBtn addTarget:self action:@selector(areaSelectClick) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect leftTextFrame = [@"全国" boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
    CGFloat leftWidth=leftTextFrame.size.width+4+15;
    if (leftWidth>=(Screen_Width/2-40)) {
        _label1.frame=CGRectMake(20, 12, (Screen_Width/2-40)-4-15, 15);
        _imgView1.frame=CGRectMake(CGRectGetMaxX(_label1.frame)+4, 12, 15, 15);
    }
    else{
        _label1.frame=CGRectMake((Screen_Width/2-leftWidth)/2, 12, leftWidth-4-15, 15);
        _imgView1.frame=CGRectMake(CGRectGetMaxX(_label1.frame)+4, 12, 15, 15);
    }
    
    [self.view addSubview:areaSelectBtn];
    
    //金额筛选按钮
    UIButton *moneySelectBtn=[[UIButton alloc]initWithFrame:CGRectMake(Screen_Width/2, 0, Screen_Width/2, 39)];
    [moneySelectBtn setBackgroundColor:kColorWhite];
    
    _label2=[[UILabel alloc]init];
    _label2.text=@"金额筛选";
    _label2.textColor=KColorBlackTitle;
    _label2.font=kFontSize30;
    [moneySelectBtn addSubview:_label2];
    
    _imgView2=[[UIImageView alloc]init];
    _imgView2.contentMode = UIViewContentModeScaleAspectFit;
    _imgView2.image=[UIImage imageNamed:@"home_search_down"];
    [moneySelectBtn addSubview:_imgView2];
    [moneySelectBtn addTarget:self action:@selector(moneySelectClick) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect rightTextFrame = [@"金额筛选" boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
    CGFloat rightWidth=rightTextFrame.size.width+4+15;
    if (rightWidth>=(Screen_Width/2-40)) {
        _label2.frame=CGRectMake(20, 12, (Screen_Width/2-40)-4-15, 15);
        _imgView2.frame=CGRectMake(CGRectGetMaxX(_label2.frame)+4, 12, 15, 15);
    }
    else{
        _label2.frame=CGRectMake((Screen_Width/2-rightWidth)/2, 12, rightWidth-4-15, 15);
        _imgView2.frame=CGRectMake(CGRectGetMaxX(_label2.frame)+4, 12, 15, 15);
    }
    
    [self.view addSubview:moneySelectBtn];

    
    //搜索结果统计
    UIView *summaryView=[[UIView alloc]initWithFrame:CGRectMake(0, 39, Screen_Width, 45)];
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
    
    _rightLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_numLabel.frame)+2, 15, 60, 15)];
    if ([_menuId isEqualToString:@"22"]) {
         _rightLab.text=@"个项目";
    }else{
         _rightLab.text=@"个PPP项目";
    }
   
    _rightLab.textColor=KColorGreySubTitle;
    _rightLab.font=kFontSize26;
    [summaryView addSubview:_rightLab];
    
    _areaSelectTableView=[[DDAreaSelectTableView alloc]initWithFrame:CGRectMake(0, 39+60, Screen_Width, Screen_Height-KNavigationBarHeight-39-60)];
    _areaSelectTableView.attachHeight=@"0";
    __weak __typeof(self) weakSelf=self;
    _areaSelectTableView.hiddenBlock = ^{
        weakSelf.imgView1.image=[UIImage imageNamed:@"home_search_down"];
        
        //[weakSelf.areaSelectTableView hiddenActionSheet];
        [weakSelf.areaSelectTableView hidden];
        
        _isCitySelected=NO;
    };
    _areaSelectTableView.delegate=self;
    [_areaSelectTableView show];
}

#pragma mark 创建tableView
-(void)createTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 39+45, Screen_Width, Screen_Height-KNavigationBarHeight-39-45) style:UITableViewStyleGrouped];
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
        DDSearchProjectListModel *model=_dataSourceArr[indexPath.section];
        
        static NSString * cellID = @"DDProjectListCell";
        DDProjectListCell * cell = (DDProjectListCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
        }
        
        
        [cell loadDataWithModel:model];
        if ([model.type isEqualToString:@"1"] || [model.type isEqualToString:@"3"]) {//中标人
            cell.winLab.text=@"中标人:";
        }
        else{//第一候选人
            cell.winLab.text=@"第一候选人:";
        }
        
        if ([model.type isEqualToString:@"1"] || [model.type isEqualToString:@"3"]) {//中标价
            cell.biddingPriceLab.text=@"中标价";
        }
        else{//第一候选人
            cell.biddingPriceLab.text=@"投标报价";
        }
        
        if ([model.type isEqualToString:@"1"] || [model.type isEqualToString:@"3"]) {//中标时间
            cell.launchLab.text=@"中标时间";
        }
        else{//中标时间
            cell.launchLab.text=@"中标时间";
        }
        
        if (![DDUtils isEmptyString:model.winBidOrg]) {
            cell.winBiddingBtn.userInteractionEnabled=YES;
            cell.winBiddingBtn.tag=indexPath.section;
            [cell.winBiddingBtn addTarget:self action:@selector(companyDetailClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        else{
            cell.winBiddingBtn.userInteractionEnabled=NO;
        }
        
        if (![DDUtils isEmptyString:model.projectManager]) {
            cell.nameBtn.userInteractionEnabled=YES;
            cell.nameBtn.tag=indexPath.section;
            [cell.nameBtn addTarget:self action:@selector(peopleDetailClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        else{
            cell.nameBtn.userInteractionEnabled=NO;
        }
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    else{        
        static NSString * cellID = @"DDProjectListCell";
        DDProjectListCell * cell = (DDProjectListCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
        }
        
        

        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    
}

#pragma mark 点击跳转到公司详情
-(void)companyDetailClick:(UIButton *)sender{
//    if ([DDUtils isEmptyString:[DDUserManager sharedInstance].userid]) {
//        [self presentLoginVCWithSender1:sender];
//    }
//    else{
//        DDSearchProjectListModel *model=_dataSourceArr[sender.tag];
//        
//        DDCompanyDetailVC *companyDetailVC=[[DDCompanyDetailVC alloc]init];
//        companyDetailVC.enterpriseId=model.enterpriseId;
//        companyDetailVC.hidesBottomBarWhenPushed=YES;
//        [self.navigationController pushViewController:companyDetailVC animated:YES];
//    }
    
    _imgView1.image=[UIImage imageNamed:@"home_search_down"];
    [_areaSelectTableView hidden];
    _isCitySelected=NO;
    _imgView2.image=[UIImage imageNamed:@"home_search_down"];
    [_moneySelectView hiddenActionSheet];
    _isMoneySelected=NO;
    DDSearchProjectListModel *model=_dataSourceArr[sender.tag];
    
    DDCompanyDetailVC *companyDetailVC=[[DDCompanyDetailVC alloc]init];
    companyDetailVC.enterpriseId=model.enterpriseId;
    companyDetailVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:companyDetailVC animated:YES];
}

#pragma mark 点击跳转到人员详情
-(void)peopleDetailClick:(UIButton *)sender{
    _imgView1.image=[UIImage imageNamed:@"home_search_down"];
    [_areaSelectTableView hidden];
    _isCitySelected=NO;
    _imgView2.image=[UIImage imageNamed:@"home_search_down"];
    [_moneySelectView hiddenActionSheet];
    _isMoneySelected=NO;
    if ([DDUtils isEmptyString:[DDUserManager sharedInstance].userid]) {
        [self presentLoginVCWithSender2:sender];
    }
    else{
        DDSearchProjectListModel *model=_dataSourceArr[sender.tag];
        
        DDPeopleDetailVC *peopleDetail=[[DDPeopleDetailVC alloc]init];
        peopleDetail.staffInfoId=model.staffInfoId;
        peopleDetail.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:peopleDetail animated:YES];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _imgView1.image=[UIImage imageNamed:@"home_search_down"];
    [_areaSelectTableView hidden];
    _isCitySelected=NO;
    _imgView2.image=[UIImage imageNamed:@"home_search_down"];
    [_moneySelectView hiddenActionSheet];
    _isMoneySelected=NO;
    if ([DDUtils isEmptyString:[DDUserManager sharedInstance].userid]) {
        [self presentLoginVCWithIndexPath:indexPath];
    }
    else{
        DDSearchProjectListModel *model=_dataSourceArr[indexPath.section];
        //此时需要存数据库了
        //存最近搜索
        [DDSearchHistoryDAOAndDB insertRecentSearchByTypeId:self.menuId andSearchText:self.searchText];
        //存浏览历史
        NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithData:[model.title dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        [DDSearchHistoryDAOAndDB insertHistorySearchByTypeId:self.menuId andSearchResult:[DDUtils transformAttributedText:attributeStr] andGlobalType:nil andTransId:model.winCaseId];
        
        DDGainBiddingDetailVC *winBiddingDetail=[[DDGainBiddingDetailVC alloc]init];
        winBiddingDetail.winCaseId=model.winCaseId;
        [self.navigationController pushViewController:winBiddingDetail animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //return 160;
    return UITableViewAutomaticDimension;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    DDSearchProjectListModel *model=_dataSourceArr[section];

    UIView *footerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 40)];
    footerView.backgroundColor=kColorWhite;

    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(12, 12.5, Screen_Width-54, 15)];
    if ([DDUtils isEmptyString:model.tradingCenter]) {
        label.text=@"-";
    }
    else{
        label.text=model.tradingCenter;
    }
    label.textColor=KColorGreySubTitle;
    label.font=kFontSize24;
    [footerView addSubview:label];

    return footerView;
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
    DDSearchProjectListModel *model=_dataSourceArr[section];
    
    if ([DDUtils isEmptyString:model.tradingCenter]) {
        return CGFLOAT_MIN;
    }
    else{
        return 40;
    }
}

#pragma mark 点击城市选择
-(void)areaSelectClick{
    if (_isCitySelected==NO) {
        //将金额筛选隐藏
        _imgView2.image=[UIImage imageNamed:@"home_search_down"];
        [_moneySelectView hiddenActionSheet];
        _isMoneySelected=NO;
        
        
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

#pragma mark CitySelectPickerView代理回调
-(void)actionsheetDisappear:(DDAreaSelectTableView *)actionSheet andAreaInfo:(NSString *)area{
    _label1.text=area;
    
    if ([area containsString:@"直辖县"]) {
        NSRange range = [area rangeOfString:@","];
        NSString *regionStr=[area substringFromIndex:(range.location+1)];
        _label1.text=regionStr;
    }
    
    _label1.frame=CGRectMake(0, 12, Screen_Width/2-4-15, 15);
    _label1.textAlignment = NSTextAlignmentCenter;
    _imgView1.frame=CGRectMake(CGRectGetMaxX(_label1.frame)+4, 12, 15, 15);
    
    //    _label1.text=_region;
    
    NSString *areaStr=area;
    if ([areaStr containsString:@"全省"]) {
        areaStr=[areaStr stringByReplacingOccurrencesOfString:@"全省" withString:@""];
    }
    else if ([areaStr containsString:@"全市"]) {
        areaStr=[areaStr stringByReplacingOccurrencesOfString:@"全市" withString:@""];
    }
    else if ([areaStr containsString:@"全区"]) {
        areaStr=[areaStr stringByReplacingOccurrencesOfString:@"全区" withString:@""];
    }else if ([areaStr isEqualToString:@"全国"]) {
        areaStr=@"";
    }
    _region=areaStr;
    [self requestData];
}

#pragma mark 点击金额筛选
-(void)moneySelectClick{
    if (_isMoneySelected==NO) {
        //将区域筛选隐藏
        _imgView1.image=[UIImage imageNamed:@"home_search_down"];
        //[_areaSelectTableView hiddenActionSheet];
        [_areaSelectTableView hidden];
        _isCitySelected=NO;
        
        
        _imgView2.image=[UIImage imageNamed:@"home_search_up"];
        
        _moneySelectView=[[DDMoneySelectView alloc]initWithFrame:CGRectMake(0, 39+60, Screen_Width, Screen_Height-KNavigationBarHeight-39-60)];
        _moneySelectView.attachHeight=@"0";
        _moneySelectView.isFromPPP=@"1";//表示从PPP项目过去的
        _moneySelectView.amountRecord=_amountRecord;
        __weak __typeof(self) weakSelf=self;
        _moneySelectView.hiddenBlock = ^{
            weakSelf.imgView2.image=[UIImage imageNamed:@"home_search_down"];
            
            [weakSelf.moneySelectView hiddenActionSheet];
            
            _isMoneySelected=NO;
        };
        _moneySelectView.delegate=self;
        [_moneySelectView show];
        [_textField resignFirstResponder];
        
        _isMoneySelected=YES;
    }
    else{
        _imgView2.image=[UIImage imageNamed:@"home_search_down"];
        
        [_moneySelectView hiddenActionSheet];
        
        _isMoneySelected=NO;
    }
}

#pragma mark MoneySelectViewDelegate代理回调
-(void)actionsheetDisappear:(DDMoneySelectView *)actionSheet andMoney:(NSString *)money andMin:(NSString *)min andMax:(NSString *)max{
    
    _amount=money;
    
    CGRect rightTextFrame = [_amount boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
    CGFloat rightWidth=rightTextFrame.size.width+4+15;
    if (rightWidth>=(Screen_Width/2-40)) {
        _label2.frame=CGRectMake(20, 12, (Screen_Width/2-40)-4-15, 15);
        _imgView2.frame=CGRectMake(CGRectGetMaxX(_label2.frame)+4, 12, 15, 15);
    }
    else{
        _label2.frame=CGRectMake((Screen_Width/2-rightWidth)/2, 12, rightWidth-4-15, 15);
        _imgView2.frame=CGRectMake(CGRectGetMaxX(_label2.frame)+4, 12, 15, 15);
    }
    
    _label2.text=_amount;
    _amountRecord=_amount;
    
    _amount=[NSString stringWithFormat:@"%@-%@",min,max];
    
    if ([money isEqualToString:@"全部"]) {
        _amount=@"";
        _amountRecord=@"";
    }
    
    [self requestData];
}

#pragma mark 弹出登录注册页面
- (void)presentLoginVCWithIndexPath:(NSIndexPath *)indexPath{
    DDLoginCheckVC * vc = [[DDLoginCheckVC alloc] init];
    vc.loginSuccessBlock = ^{
        //__weak __typeof(self) weakSelf=self;
        //[weakSelf requestTypesData];
        
        DDSearchProjectListModel *model=_dataSourceArr[indexPath.section];
        //此时需要存数据库了
        //存最近搜索
        [DDSearchHistoryDAOAndDB insertRecentSearchByTypeId:self.menuId andSearchText:self.searchText];
        //存浏览历史
        NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithData:[model.title dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        [DDSearchHistoryDAOAndDB insertHistorySearchByTypeId:self.menuId andSearchResult:[DDUtils transformAttributedText:attributeStr] andGlobalType:nil andTransId:model.winCaseId];
        
        DDGainBiddingDetailVC *winBiddingDetail=[[DDGainBiddingDetailVC alloc]init];
        winBiddingDetail.winCaseId=model.winCaseId;
        [self.navigationController pushViewController:winBiddingDetail animated:YES];
    };
    
    
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [DDNavigationUtil setNavigationAndBottomLineWhiteColor:nav];
    [self showViewController:nav sender:nil];
}

#pragma mark 弹出登录注册页面
- (void)presentLoginVCWithSender1:(UIButton *)sender{
    DDLoginCheckVC * vc = [[DDLoginCheckVC alloc] init];
    vc.loginSuccessBlock = ^{
        //__weak __typeof(self) weakSelf=self;
        //[weakSelf requestTypesData];
        
        DDSearchProjectListModel *model=_dataSourceArr[sender.tag];
        
        DDCompanyDetailVC *companyDetailVC=[[DDCompanyDetailVC alloc]init];
        companyDetailVC.enterpriseId=model.enterpriseId;
        companyDetailVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:companyDetailVC animated:YES];
    };
    
    
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [DDNavigationUtil setNavigationAndBottomLineWhiteColor:nav];
    [self showViewController:nav sender:nil];
}

#pragma mark 弹出登录注册页面
- (void)presentLoginVCWithSender2:(UIButton *)sender{
    DDLoginCheckVC * vc = [[DDLoginCheckVC alloc] init];
    vc.loginSuccessBlock = ^{
        //__weak __typeof(self) weakSelf=self;
        //[weakSelf requestTypesData];
        
        DDSearchProjectListModel *model=_dataSourceArr[sender.tag];
        
        DDPeopleDetailVC *peopleDetail=[[DDPeopleDetailVC alloc]init];
        peopleDetail.staffInfoId=model.staffInfoId;
        peopleDetail.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:peopleDetail animated:YES];
    };
    
    
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [DDNavigationUtil setNavigationAndBottomLineWhiteColor:nav];
    [self showViewController:nav sender:nil];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [_textField resignFirstResponder];
}


@end
