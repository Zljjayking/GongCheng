//
//  DDSearchTelephoneListVC.m
//  GongChengDD
//
//  Created by xzx on 2018/6/13.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDSearchTelephoneListVC.h"
#import "MJRefresh.h"
#import "DDNavigationUtil.h"
#import "DDLoginVC.h"//登录注册页面
#import "DataLoadingView.h"//加载页面
#import "DDNoResultView.h"//无数据视图
#import "DDTelephoneListCell.h"//cell
#import "DDCompanyDetailVC.h"//公司详情页面
#import "CitySelectTableView.h"//城市选择
#import "DDSearchTelephoneListModel.h"//model
#import "DDSearchHistoryDAOAndDB.h"//搜索历史数据库操作类

@interface DDSearchTelephoneListVC ()<UITableViewDelegate,UITableViewDataSource,CitySelectTableViewDelegate,UITextFieldDelegate>

{
    UIView *_topBgView;
    UITextField *_textField;
    
    NSInteger currentPage;
    NSInteger pageCount;
    NSMutableArray *_dataSourceArr;
    NSMutableDictionary *_dict;
    
//    UIButton *_areaSelectBtn;
//    UILabel *_label1;//放左边那个城市选择文字
    
    UILabel *_leftLab;//"搜索到"三个字的label
    UILabel *_numLabel;//总计数量label
    UILabel *_rightLab;//"个公司"三个字的label
    
    BOOL _isCitySelected;//判断是否点开了城市选择视图
    
    NSString *_region;//地区筛选
}
@property (nonatomic,strong) DataLoadingView *loadingView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) DDNoResultView *noResultView;//无数据视图
//@property (nonatomic,strong) UIImageView *imgView1;//放左边那个城市选择小箭头
@property (nonatomic,strong) CitySelectTableView *citySelectTableView;//区域筛选视图

@end

@implementation DDSearchTelephoneListVC

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
    
    self.view.backgroundColor=kColorBackGroundColor;
    _region=@"";
    _isCitySelected=NO;
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
    //_textField.returnKeyType = UIReturnKeySearch;
    //添加观察文本框的改变
    [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

//返回上一页
-(void)popBackClick{
    //先发通知收弹出视图
    [_citySelectTableView hiddenActionSheet];
    [self.navigationController popViewControllerAnimated:NO];
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
                [self performSelector:@selector(requestData) withObject:nil afterDelay:0.4];
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
    currentPage = 1;
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:self.searchText forKey:@"keys"];
    [params setValue:self.menuId forKey:@"searchType"];
    [params setValue:_region forKey:@"region"];
    [params setValue:[NSString stringWithFormat:@"%ld",currentPage] forKey:@"page"];
    [params setValue:@"10" forKey:@"rows"];
    
    
    [[DDHttpManager sharedInstance]sendPostRequest:KHttpRequest_queryHighLightList params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"**********找电话搜索结果数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        __weak __typeof(self) weakSelf = self;
        if (response.isSuccess) {
            [_dataSourceArr removeAllObjects];
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
                
                for (NSDictionary *dic in listArr) {
                    DDSearchTelephoneListModel *model = [[DDSearchTelephoneListModel alloc]initWithDictionary:dic error:nil];
                    [_dataSourceArr addObject:model];
                }
                
                if (listArr.count<pageCount) {
                    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                        [weakSelf addData];
                    }];
                }else{
                    MJRefreshAutoStateFooter *footer=[MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
                        
                    }];
                    [footer endRefreshingWithNoMoreData];
                    [footer setTitle:kNoMoreData forState:MJRefreshStateNoMoreData];
                    footer.stateLabel.textColor=KColorBidApprovalingWait;
                    self.tableView.mj_footer = footer;
                }
            }
            else{
                [_noResultView showNoResultViewWithTitle:@"电话信息" andImage:@"noResult_info"];
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
    [params setValue:self.searchText forKey:@"keys"];
    [params setValue:self.menuId forKey:@"searchType"];
    [params setValue:_region forKey:@"region"];
    [params setValue:[NSString stringWithFormat:@"%ld",currentPage] forKey:@"page"];
    [params setValue:@"10" forKey:@"rows"];
    
    
    [[DDHttpManager sharedInstance]sendPostRequest:KHttpRequest_queryHighLightList params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"**********找电话搜索结果数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        __weak __typeof(self) weakSelf = self;
        if (response.isSuccess) {
            
            _dict = responseObject[KData];
            NSArray *listArr = _dict[@"result"];
            for (NSDictionary *dic in listArr) {
                DDSearchTelephoneListModel *model = [[DDSearchTelephoneListModel alloc]initWithDictionary:dic error:nil];
                [_dataSourceArr addObject:model];
            }
            
            if (_dataSourceArr.count<pageCount) {
                self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                    [weakSelf addData];
                }];
            }
            else{
                MJRefreshAutoStateFooter *footer=[MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
                    
                }];
                [footer endRefreshingWithNoMoreData];
                [footer setTitle:kNoMoreData forState:MJRefreshStateNoMoreData];
                footer.stateLabel.textColor=KColorBidApprovalingWait;
                self.tableView.mj_footer = footer;
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
//    UIView *regionSelectBgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 39)];
//    regionSelectBgView.backgroundColor=kColorNavBarGray;
//    [self.view addSubview:regionSelectBgView];
    
//    CGRect regionTextFrame = [@"全国" boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
//
//    _areaSelectBtn=[[UIButton alloc]initWithFrame:CGRectMake(15, 0, regionTextFrame.size.width+4+15, 39)];
//
//    _label1=[[UILabel alloc]initWithFrame:CGRectMake(0, 12, regionTextFrame.size.width, 15)];
//    _label1.text=@"全国";
//    _label1.textColor=KColorBlackSecondTitle;
//    _label1.font=kFontSize30;
//    [_areaSelectBtn addSubview:_label1];
//
//    _imgView1=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_label1.frame)+4, 12, 15, 15)];
//    _imgView1.image=[UIImage imageNamed:@"home_search_down"];
//    [_areaSelectBtn addSubview:_imgView1];
//    [_areaSelectBtn addTarget:self action:@selector(areaSelectClick) forControlEvents:UIControlEventTouchUpInside];
//
//    [regionSelectBgView addSubview:_areaSelectBtn];
    
    
    UIView *summaryView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 45)];
    [self.view addSubview:summaryView];
    
    _leftLab=[[UILabel alloc]initWithFrame:CGRectMake(12, 15, 45, 15)];
    _leftLab.text=@"搜索到";
    _leftLab.textColor=KColorGreySubTitle;
    _leftLab.font=kFontSize26;
    [summaryView addSubview:_leftLab];
    
    _numLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_leftLab.frame)+2, 15, 1, 15)];
    _numLabel.text=@"";
    _numLabel.textColor=kColorBlue;
    _numLabel.font=kFontSize26;
    [summaryView addSubview:_numLabel];
    
    _rightLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_numLabel.frame)+2, 15, 45, 15)];
    _rightLab.text=@"个公司";
    _rightLab.textColor=KColorGreySubTitle;
    _rightLab.font=kFontSize26;
    [summaryView addSubview:_rightLab];
    
    _citySelectTableView=[[CitySelectTableView alloc]initWithFrame:CGRectMake(0, 39, Screen_Width, Screen_Height-KNavigationBarHeight-39)];
    _citySelectTableView.attachHeight=@"-39";
    __weak __typeof(self) weakSelf=self;
    _citySelectTableView.hiddenBlock = ^{
        //weakSelf.imgView1.image=[UIImage imageNamed:@"home_search_down"];
        
        //[weakSelf.citySelectTableView hiddenActionSheet];
        [weakSelf.citySelectTableView hidden];
        
        _isCitySelected=NO;
    };
    _citySelectTableView.delegate=self;
    [_citySelectTableView show];
}

#pragma mark 创建tableView
-(void)createTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 45, Screen_Width, Screen_Height-KNavigationBarHeight-45) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=kColorBackGroundColor;
    _tableView.showsVerticalScrollIndicator=YES;
    _tableView.estimatedRowHeight = 44;
    _tableView.separatorColor=KColorTableSeparator;
    
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
    DDSearchTelephoneListModel *model=_dataSourceArr[indexPath.section];
    
    static NSString * cellID = @"DDTelephoneListCell";
    DDTelephoneListCell * cell = (DDTelephoneListCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
    }
    
    [cell loadDataWithModel:model];
    cell.telBtn.tag=indexPath.section+300;
    [cell.telBtn addTarget:self action:@selector(telBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([DDUtils isEmptyString:[DDUserManager sharedInstance].userid]) {
        [self presentLoginVCWithIndexPath:indexPath];
    }
    else{
        DDSearchTelephoneListModel *model=_dataSourceArr[indexPath.section];
        //此时需要存数据库了
        //存最近搜索
        [DDSearchHistoryDAOAndDB insertRecentSearchByTypeId:self.menuId andSearchText:self.searchText];
        //存浏览历史
        NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithData:[model.unitName dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        [DDSearchHistoryDAOAndDB insertHistorySearchByTypeId:self.menuId andSearchResult:[DDUtils transformAttributedText:attributeStr] andGlobalType:nil andTransId:model.enterpriseId];
        
        DDCompanyDetailVC *companyDetail=[[DDCompanyDetailVC alloc]init];
        companyDetail.enterpriseId=model.enterpriseId;
        [self.navigationController pushViewController:companyDetail animated:YES];
    }
}

//打电话按钮点击事件
-(void)telBtnClick:(UIButton *)sender{
    DDSearchTelephoneListModel *model=_dataSourceArr[sender.tag-300];
    
    if ([DDUtils isEmptyString:model.tel]) {
        [DDUtils showToastWithMessage:@"暂无联系电话！"];
    }
    else{
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",model.tel]]];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //return 130;
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
        //_imgView1.image=[UIImage imageNamed:@"home_search_up"];
        
        [_citySelectTableView noHidden];
        
        _isCitySelected=YES;
    }
    else{
        //_imgView1.image=[UIImage imageNamed:@"home_search_down"];
        
        //[_citySelectTableView hiddenActionSheet];
        [_citySelectTableView hidden];
        
        _isCitySelected=NO;
    }
}

#pragma mark CitySelectPickerView代理回调
-(void)actionsheetDisappear:(CitySelectTableView *)actionSheet andAreaInfoDict:(NSString *)area{
    NSString *areaStr=area;
    if ([areaStr containsString:@"全省"]) {
        areaStr=[areaStr stringByReplacingOccurrencesOfString:@"全省" withString:@""];
    }
    else if ([areaStr containsString:@"全市"]) {
        areaStr=[areaStr stringByReplacingOccurrencesOfString:@"全市" withString:@""];
    }
    else if ([areaStr containsString:@"全区"]) {
        areaStr=[areaStr stringByReplacingOccurrencesOfString:@"全区" withString:@""];
    }
    else if ([areaStr containsString:@"全州"]) {
        areaStr=[areaStr stringByReplacingOccurrencesOfString:@"全州" withString:@""];
    }
    else if ([areaStr containsString:@"全级"]) {
        areaStr=[areaStr stringByReplacingOccurrencesOfString:@"全级" withString:@""];
    }
    else if ([areaStr containsString:@"全盟"]) {
        areaStr=[areaStr stringByReplacingOccurrencesOfString:@"全盟" withString:@""];
    }
    
    
    _region=areaStr;
    
    
//    CGRect regionTextFrame = [_region boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
//
//    _areaSelectBtn.frame=CGRectMake(15, 0, regionTextFrame.size.width+4+15, 39);
//    _label1.frame=CGRectMake(0, 12, regionTextFrame.size.width, 15);
//    _imgView1.frame=CGRectMake(CGRectGetMaxX(_label1.frame)+4, 12, 15, 15);
//
//
//    _label1.text=_region;
    
    if ([areaStr isEqualToString:@"全国"]) {
        _region=@"";
    }
    
    [self requestData];
}


#pragma mark 弹出登录注册页面
- (void)presentLoginVCWithIndexPath:(NSIndexPath *)indexPath{
    DDLoginVC * vc = [[DDLoginVC alloc] init];
    vc.loginSuccessBlock = ^{
        //__weak __typeof(self) weakSelf=self;
        //[weakSelf requestData];
        
        DDSearchTelephoneListModel *model=_dataSourceArr[indexPath.section];
        //此时需要存数据库了
        //存最近搜索
        [DDSearchHistoryDAOAndDB insertRecentSearchByTypeId:self.menuId andSearchText:self.searchText];
        //存浏览历史
        NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithData:[model.unitName dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        [DDSearchHistoryDAOAndDB insertHistorySearchByTypeId:self.menuId andSearchResult:[DDUtils transformAttributedText:attributeStr] andGlobalType:nil andTransId:model.enterpriseId];
        
        DDCompanyDetailVC *companyDetail=[[DDCompanyDetailVC alloc]init];
        companyDetail.enterpriseId=model.enterpriseId;
        [self.navigationController pushViewController:companyDetail animated:YES];
        
        //发出登录成功通知
        [[NSNotificationCenter defaultCenter] postNotificationName:KLoginSuccessNotification object:nil userInfo:nil];
    };
    
    
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [DDNavigationUtil setNavigationBottomLineNomalColor:nav];
    
    [self presentViewController:nav animated:YES completion:nil];
}



@end
