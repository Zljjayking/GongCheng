//
//  DDSearchSafeCertiListVC.m
//  GongChengDD
//
//  Created by xzx on 2018/9/19.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDSearchSafeCertiListVC.h"
#import "MJRefresh.h"
#import "DDNavigationUtil.h"
#import "DDLoginVC.h"//登录注册页面
#import "DataLoadingView.h"//加载页面
#import "DDNoResultView.h"//无数据视图
#import "DDCompanyListCell.h"//cell
#import "DDCompanyList2Cell.h"//cell
#import "DDCompanyDetailVC.h"//公司详情页面
#import "CitySelectTableView.h"//城市选择
#import "DDCertiAndLevelVC.h"//资质类别及等级页面
#import "DDSearchCompanyListModel.h"//model
#import "DDSearchHistoryDAOAndDB.h"//搜索历史数据库操作类
#import "DDPeopleDetailVC.h"//人员详情页面
#import "DDUMengEventDefines.h"

@interface DDSearchSafeCertiListVC ()<UITableViewDelegate,UITableViewDataSource,CitySelectTableViewDelegate,DDCertiAndLevelVCDelagate,UITextFieldDelegate>

    {
        UIView *_topBgView;
        UITextField *_textField;
        
        NSInteger currentPage;
        NSInteger pageCount;
        NSMutableArray *_dataSourceArr;
        NSMutableDictionary *_dict;
        
        UILabel *_label1;//放左边那个城市选择文字
        //UIImageView *_imgView1;//放左边那个城市选择小箭头
        UILabel *_label2;//放右边那个资质等级选择文字
        UIImageView *_imgView2;//放右边那个资质等级选择小箭头
        
        UILabel *_leftLab;//"搜索到"三个字的label
        UILabel *_numLabel;//总计数量label
        UILabel *_rightLab;//"个公司"三个字的label
        
        BOOL _isCitySelected;//判断是否点开了城市选择视图
        //CitySelectTableView *_citySelectTableView;//区域筛选视图
        
        NSString *_certTypeLevels;//资质筛选等级
        NSString *_region;//地区筛选
    }
    @property (nonatomic,strong) DataLoadingView *loadingView;
    @property (nonatomic,strong) UITableView *tableView;
    @property (nonatomic,strong) DDNoResultView *noResultView;//无数据视图
    @property (nonatomic,strong) UIImageView *imgView1;//放左边那个城市选择小箭头
    @property (nonatomic,strong) CitySelectTableView *citySelectTableView;//区域筛选视图
    
@end

@implementation DDSearchSafeCertiListVC

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
    
    if ([self.menuId isEqualToString:@"6"]) {//查企业
        [MobClick event:main_chaqiye];
    }
    else if([self.menuId isEqualToString:@"16"]){//查资质
        [MobClick event:main_chaziyuan];
    }
    else{
        [MobClick event:main_anxuzheng];
    }
    self.view.backgroundColor=kColorBackGroundColor;
    _certTypeLevels=@"";
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
    [_citySelectTableView hiddenActionSheet];
    [self.navigationController popViewControllerAnimated:NO];
}
    
-(void)viewDidDisappear:(BOOL)animated{
    if (self.navigationController==NULL) {
        [_citySelectTableView hiddenActionSheet];
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
    [params setValue:_region forKey:@"region"];
    [params setValue:_certTypeLevels forKey:@"certTypeLevels"];
    [params setValue:[NSString stringWithFormat:@"%ld",currentPage] forKey:@"page"];
    [params setValue:@"10" forKey:@"rows"];
    
    
    [[DDHttpManager sharedInstance]sendPostRequest:KHttpRequest_queryHighLightList params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"**********公司搜索结果数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        __weak __typeof(self) weakSelf = self;
        if (response.isSuccess) {
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
                    DDSearchCompanyListModel *model = [[DDSearchCompanyListModel alloc]initWithDictionary:dic error:nil];
                    
                    
                    
                    
                    
                    
                    
                    if (![DDUtils isEmptyString:model.unitName]) {
                        NSString *titleStr=[NSString stringWithFormat:@"<font color='#111111'>%@</font>",model.unitName];
                        NSAttributedString *unitName = [[NSAttributedString alloc] initWithData:[titleStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
                        model.unitNameAttriStr=unitName;
                    }
                    
                    if (![DDUtils isEmptyString:model.usedNames]) {
                        NSString *titleStr=[NSString stringWithFormat:@"<font color='#888888'>曾用名：%@</font>",model.usedNames];
                        NSAttributedString *unitName = [[NSAttributedString alloc] initWithData:[titleStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
                        model.usedNamesAttriString=unitName;
                    }
                    
                    
                    if (![DDUtils isEmptyString:model.legalRepresentative]) {
                        NSString *nameStr=[NSString stringWithFormat:@"<font color='#25a5fe' size='4'>%@</font>",model.legalRepresentative];
                        NSAttributedString *peopleString = [[NSAttributedString alloc] initWithData:[nameStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
                        model.peopleAttriString=peopleString;
                    }
                    
                    if (![DDUtils isEmptyString:model.cert]) {
                        NSString *descStr=[NSString stringWithFormat:@"<font color='#888888'>%@</font>",model.cert];
                        NSMutableAttributedString *certString = [[NSMutableAttributedString alloc] initWithData:[descStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
                        model.certAttriString=certString;
                    }
                    
                    NSMutableString *areaStr=[[NSMutableString alloc]initWithString:@""];
                    if ([model.mergerName containsString:@","]) {
                        NSArray *array=[model.mergerName componentsSeparatedByString:@","];
                        if (array.count>1) {
                            for (int i=0; i<array.count; i++) {
                                [areaStr appendString:array[i]];
                            }
                        }
                    }
                    else{
                        if (![DDUtils isEmptyString:model.mergerName]) {
                            [areaStr appendString:model.mergerName];
                        }
                    }
                    [areaStr appendString:@"/"];
                    model.areaStr=areaStr;
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
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
                [_noResultView showNoResultViewWithTitle:@"公司信息" andImage:@"noResult_company"];
            }
            
        }
        else{
            
            [_loadingView failureLoadingView];
        }
        
        [self.tableView.mj_header endRefreshing];
        //[_tableView reloadData];
        
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
    [params setValue:_certTypeLevels forKey:@"certTypeLevels"];
    [params setValue:[NSString stringWithFormat:@"%ld",currentPage] forKey:@"page"];
    [params setValue:@"10" forKey:@"rows"];
    
    
    [[DDHttpManager sharedInstance]sendPostRequest:KHttpRequest_queryHighLightList params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"**********公司搜索结果数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        __weak __typeof(self) weakSelf = self;
        if (response.isSuccess) {
            
            _dict = responseObject[KData];
            NSArray *listArr = _dict[@"result"];
            for (NSDictionary *dic in listArr) {
                DDSearchCompanyListModel *model = [[DDSearchCompanyListModel alloc]initWithDictionary:dic error:nil];
                
                
                
                
                
                
                
                
                if (![DDUtils isEmptyString:model.unitName]) {
                    NSString *titleStr=[NSString stringWithFormat:@"<font color='#111111'>%@</font>",model.unitName];
                    NSAttributedString *unitName = [[NSAttributedString alloc] initWithData:[titleStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
                    model.unitNameAttriStr=unitName;
                }
                
                if (![DDUtils isEmptyString:model.usedNames]) {
                    NSString *titleStr=[NSString stringWithFormat:@"<font color='#888888'>曾用名：%@</font>",model.usedNames];
                    NSAttributedString *unitName = [[NSAttributedString alloc] initWithData:[titleStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
                    model.usedNamesAttriString=unitName;
                }
                
                if (![DDUtils isEmptyString:model.legalRepresentative]) {
                    NSString *nameStr=[NSString stringWithFormat:@"<font color='#25a5fe' size='4'>%@</font>",model.legalRepresentative];
                    NSAttributedString *peopleString = [[NSAttributedString alloc] initWithData:[nameStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
                    model.peopleAttriString=peopleString;
                }
                
                if (![DDUtils isEmptyString:model.cert]) {
                    NSString *descStr=[NSString stringWithFormat:@"<font color='#888888'>%@</font>",model.cert];
                    NSMutableAttributedString *certString = [[NSMutableAttributedString alloc] initWithData:[descStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
                    model.certAttriString=certString;
                }
                
                NSMutableString *areaStr=[[NSMutableString alloc]initWithString:@""];
                if ([model.mergerName containsString:@","]) {
                    NSArray *array=[model.mergerName componentsSeparatedByString:@","];
                    if (array.count>1) {
                        for (int i=0; i<array.count; i++) {
                            [areaStr appendString:array[i]];
                        }
                    }
                }
                else{
                    if (![DDUtils isEmptyString:model.mergerName]) {
                        [areaStr appendString:model.mergerName];
                    }
                }
                [areaStr appendString:@"/"];
                model.areaStr=areaStr;
                
                
                
                
                
                
                
                
                
                
                
                
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
    UIButton *areaSelectBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, Screen_Width/2, 39)];
    [areaSelectBtn setBackgroundColor:kColorNavBarGray];
    
    _label1=[[UILabel alloc]init];
    _label1.text=@"全国";
    _label1.textColor=KColorBlackSecondTitle;
    _label1.font=kFontSize30;
    [areaSelectBtn addSubview:_label1];
    
    _imgView1=[[UIImageView alloc]init];
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
    
    
    UIButton *typeAndLevelBtn=[[UIButton alloc]initWithFrame:CGRectMake(Screen_Width/2, 0, Screen_Width/2, 39)];
    [typeAndLevelBtn setBackgroundColor:kColorNavBarGray];
    
    _label2=[[UILabel alloc]init];
    _label2.text=@"资质类别及等级";
    _label2.textColor=KColorBlackSecondTitle;
    _label2.font=kFontSize30;
    [typeAndLevelBtn addSubview:_label2];
    
    _imgView2=[[UIImageView alloc]init];
    _imgView2.image=[UIImage imageNamed:@"home_search_down"];
    [typeAndLevelBtn addSubview:_imgView2];
    [typeAndLevelBtn addTarget:self action:@selector(typeAndLevelClick) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect rightTextFrame = [@"资质类别及等级" boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
    CGFloat rightWidth=rightTextFrame.size.width+4+15;
    if (rightWidth>=(Screen_Width/2-40)) {
        _label2.frame=CGRectMake(20, 12, (Screen_Width/2-40)-4-15, 15);
        _imgView2.frame=CGRectMake(CGRectGetMaxX(_label2.frame)+4, 12, 15, 15);
    }
    else{
        _label2.frame=CGRectMake((Screen_Width/2-rightWidth)/2, 12, rightWidth-4-15, 15);
        _imgView2.frame=CGRectMake(CGRectGetMaxX(_label2.frame)+4, 12, 15, 15);
    }
    
    [self.view addSubview:typeAndLevelBtn];
    
    
    UILabel *line=[[UILabel alloc]initWithFrame:CGRectMake(Screen_Width/2-0.5, 7, 1, 25)];
    line.backgroundColor=KColorTableSeparator;
    [self.view addSubview:line];
    
    
    UIView *summaryView=[[UIView alloc]initWithFrame:CGRectMake(0, 39, Screen_Width, 45)];
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
    _citySelectTableView.attachHeight=@"0";
    __weak __typeof(self) weakSelf=self;
    _citySelectTableView.hiddenBlock = ^{
        weakSelf.imgView1.image=[UIImage imageNamed:@"home_search_down"];
        
        //[weakSelf.citySelectTableView hiddenActionSheet];
        [weakSelf.citySelectTableView hidden];
        
        _isCitySelected=NO;
    };
    _citySelectTableView.delegate=self;
    [_citySelectTableView show];
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
        DDSearchCompanyListModel *model=_dataSourceArr[indexPath.section];
        
        if (![DDUtils isEmptyString:model.cert]) {
            static NSString * cellID = @"DDCompanyListCell";
            DDCompanyListCell * cell = (DDCompanyListCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
            }
            
            [cell loadDataWithModel:model];
            
            if (![DDUtils isEmptyString:model.legalRepresentative]) {
                cell.peopleBtn.userInteractionEnabled=YES;
                cell.peopleBtn.tag=indexPath.section;
                [cell.peopleBtn addTarget:self action:@selector(peopleBtnClick1:) forControlEvents:UIControlEventTouchUpInside];
            }
            else{
                cell.peopleBtn.userInteractionEnabled=NO;
            }
            
            //cell.peopleBtn.tag=indexPath.section;
            //[cell.peopleBtn addTarget:self action:@selector(peopleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
        else{
            static NSString * cellID = @"DDCompanyList2Cell";
            DDCompanyList2Cell * cell = (DDCompanyList2Cell*)[tableView dequeueReusableCellWithIdentifier:cellID];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
            }
            
            [cell loadDataWithModel:model];
            
            if (![DDUtils isEmptyString:model.legalRepresentative]) {
                cell.peopleBtn.userInteractionEnabled=YES;
                cell.peopleBtn.tag=indexPath.section;
                [cell.peopleBtn addTarget:self action:@selector(peopleBtnClick2:) forControlEvents:UIControlEventTouchUpInside];
            }
            else{
                cell.peopleBtn.userInteractionEnabled=NO;
            }
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    else{
        static NSString * cellID = @"DDCompanyList2Cell";
        DDCompanyList2Cell * cell = (DDCompanyList2Cell*)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
        }
        
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    
}
    
    //点击跳转到人员详情页面
-(void)peopleBtnClick1:(UIButton *)sender{
    if ([DDUtils isEmptyString:[DDUserManager sharedInstance].userid]) {
        [self presentLoginVCWithSender:sender];
    }
    else{
        DDSearchCompanyListModel *model=_dataSourceArr[sender.tag];
        
        DDPeopleDetailVC *peopleDetail=[[DDPeopleDetailVC alloc]init];
        peopleDetail.staffInfoId=model.staffInfoId;
        [self.navigationController pushViewController:peopleDetail animated:YES];
    }
}
    
    //点击跳转到人员详情页面
-(void)peopleBtnClick2:(UIButton *)sender{
    if ([DDUtils isEmptyString:[DDUserManager sharedInstance].userid]) {
        [self presentLoginVCWithSender:sender];
    }
    else{
        DDSearchCompanyListModel *model=_dataSourceArr[sender.tag];
        
        DDPeopleDetailVC *peopleDetail=[[DDPeopleDetailVC alloc]init];
        peopleDetail.staffInfoId=model.staffInfoId;
        [self.navigationController pushViewController:peopleDetail animated:YES];
    }
}
    
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DDSearchCompanyListModel *model=_dataSourceArr[indexPath.section];
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [params setValue:_searchText forKey:@"searchTitle"];
    [params setValue:model.unitName forKey:@"searchContent"];
    [params setValue:model.enterpriseId forKey:@"enterpriseId"];
    [params setValue:self.menuId forKey:@"searchType"];
    
    [[DDHttpManager sharedInstance]sendPostRequest:KHttpRequest_saveHotSearchWords params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        //NSLog(@"**********热词统计接口***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            
        }
        else{
            //[DDUtils showToastWithMessage:response.message];
        }
        
    } failure:^(NSURLSessionDataTask *operation, id responseObject) {
        //[DDUtils showToastWithMessage:kRequestFailed];
    }];
    
    
    
    if ([DDUtils isEmptyString:[DDUserManager sharedInstance].userid]) {
        [self presentLoginVCWithIndexPath:indexPath];
    }
    else{
        DDSearchCompanyListModel *model=_dataSourceArr[indexPath.section];
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
    
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //return 120;
    return UITableViewAutomaticDimension;
}
    
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
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
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [params setValue:_searchText forKey:@"searchTitle"];
    [params setValue:model.unitName forKey:@"searchContent"];
    [params setValue:model.enterpriseId forKey:@"enterpriseId"];
    [params setValue:self.menuId forKey:@"searchType"];
    
    [[DDHttpManager sharedInstance]sendPostRequest:KHttpRequest_saveHotSearchWords params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        //NSLog(@"**********热词统计接口***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            
        }
        else{
            //[DDUtils showToastWithMessage:response.message];
        }
        
    } failure:^(NSURLSessionDataTask *operation, id responseObject) {
        //[DDUtils showToastWithMessage:kRequestFailed];
    }];
    
    
    
    if ([DDUtils isEmptyString:[DDUserManager sharedInstance].userid]) {
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:sender.tag-150];
        [self presentLoginVCWithIndexPath:indexPath];
    }
    else{
        DDSearchCompanyListModel *model=_dataSourceArr[sender.tag-150];
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
    
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return CGFLOAT_MIN;
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
    
#pragma mark 点击城市选择
-(void)areaSelectClick{
    if (_isCitySelected==NO) {
        _imgView1.image=[UIImage imageNamed:@"home_search_up"];
        
        [_citySelectTableView noHidden];
        [_textField resignFirstResponder];
        
        _isCitySelected=YES;
    }
    else{
        _imgView1.image=[UIImage imageNamed:@"home_search_down"];
        
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
    
    
    CGRect leftTextFrame = [_region boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
    CGFloat leftWidth=leftTextFrame.size.width+4+15;
    if (leftWidth>=(Screen_Width/2-40)) {
        _label1.frame=CGRectMake(20, 12, (Screen_Width/2-40)-4-15, 15);
        _imgView1.frame=CGRectMake(CGRectGetMaxX(_label1.frame)+4, 12, 15, 15);
    }
    else{
        _label1.frame=CGRectMake((Screen_Width/2-leftWidth)/2, 12, leftWidth-4-15, 15);
        _imgView1.frame=CGRectMake(CGRectGetMaxX(_label1.frame)+4, 12, 15, 15);
    }
    
    
    _label1.text=_region;
    
    if ([areaStr isEqualToString:@"全国"]) {
        _region=@"";
    }
    
    if ([areaStr containsString:@"直辖"]) {
        NSRange range = [_region rangeOfString:@","];
        NSString *regionStr=[_region substringFromIndex:(range.location+1)];
        
        CGRect leftTextFrame = [regionStr boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
        CGFloat leftWidth=leftTextFrame.size.width+4+15;
        if (leftWidth>=(Screen_Width/2-40)) {
            _label1.frame=CGRectMake(20, 12, (Screen_Width/2-40)-4-15, 15);
            _imgView1.frame=CGRectMake(CGRectGetMaxX(_label1.frame)+4, 12, 15, 15);
        }
        else{
            _label1.frame=CGRectMake((Screen_Width/2-leftWidth)/2, 12, leftWidth-4-15, 15);
            _imgView1.frame=CGRectMake(CGRectGetMaxX(_label1.frame)+4, 12, 15, 15);
        }
        
        
        _label1.text=regionStr;
    }
    
    [self requestData];
}
    
#pragma mark 点击资质类别选择
-(void)typeAndLevelClick{
    _imgView1.image=[UIImage imageNamed:@"home_search_down"];
    //[_citySelectTableView hiddenActionSheet];
    [_citySelectTableView hidden];
    _isCitySelected=NO;
    
    DDCertiAndLevelVC *certiAndLevel= [[DDCertiAndLevelVC alloc] init];
    certiAndLevel.delegate = self;
    certiAndLevel.certiName=_certTypeLevels;
    [self.navigationController pushViewController:certiAndLevel animated:YES];
}
    
#pragma mark DDCertiAndLevelVCDelagate代理回调
    //选择到了,资质类别和等级
- (void)certiAndLevelVCClick:(DDCertiAndLevelVC *)certiAndLevelVC model:(DDCertiAndLevelModel *)model codeModel:(DDCodeModel *)codeModel{
    if (codeModel) {
        if ([codeModel.value isEqualToString:@"不限"]) {
            if ([model.name containsString:@"特种工程"]) {
                _certTypeLevels=@"特种工程";
            }
            else if ([model.name containsString:@"公路交通工程"]) {
                _certTypeLevels=@"公路交通工程";
            }
            else{
                _certTypeLevels=[NSString stringWithFormat:@"%@",model.name];
            }
        }
        else{
            if ([model.name containsString:@"特种工程"]) {
                _certTypeLevels=[NSString stringWithFormat:@"特种工程%@",codeModel.value];
            }
            else{
                _certTypeLevels=[NSString stringWithFormat:@"%@%@",model.name,codeModel.value];
            }
        }
    }
    else{
        if ([model.name containsString:@"特种工程"]) {
            _certTypeLevels=@"特种工程";
        }
        else{
            _certTypeLevels=model.name;
        }
    }
    
    
    
    CGRect rightTextFrame = [_certTypeLevels boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
    CGFloat rightWidth=rightTextFrame.size.width+4+15;
    if (rightWidth>=(Screen_Width/2-40)) {
        _label2.frame=CGRectMake(20, 12, (Screen_Width/2-40)-4-15, 15);
        _imgView2.frame=CGRectMake(CGRectGetMaxX(_label2.frame)+4, 12, 15, 15);
    }
    else{
        _label2.frame=CGRectMake((Screen_Width/2-rightWidth)/2, 12, rightWidth-4-15, 15);
        _imgView2.frame=CGRectMake(CGRectGetMaxX(_label2.frame)+4, 12, 15, 15);
    }
    
    _label2.text=_certTypeLevels;
    
    [self requestData];
}
    
    //选择了全部
- (void)certiAndLevelVCSelectAll:(DDCertiAndLevelVC *)certiAndLevelVC{
    _certTypeLevels=@"";
    
    CGRect rightTextFrame = [@"资质类别及等级" boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
    CGFloat rightWidth=rightTextFrame.size.width+4+15;
    if (rightWidth>=(Screen_Width/2-40)) {
        _label2.frame=CGRectMake(20, 12, (Screen_Width/2-40)-4-15, 15);
        _imgView2.frame=CGRectMake(CGRectGetMaxX(_label2.frame)+4, 12, 15, 15);
    }
    else{
        _label2.frame=CGRectMake((Screen_Width/2-rightWidth)/2, 12, rightWidth-4-15, 15);
        _imgView2.frame=CGRectMake(CGRectGetMaxX(_label2.frame)+4, 12, 15, 15);
    }
    
    _label2.text=@"资质类别及等级";
    
    [self requestData];
}
    
#pragma mark 弹出登录注册页面
- (void)presentLoginVCWithIndexPath:(NSIndexPath *)indexPath{
    DDLoginVC * vc = [[DDLoginVC alloc] init];
    vc.loginSuccessBlock = ^{
        //__weak __typeof(self) weakSelf=self;
        //[weakSelf requestData];
        
        DDSearchCompanyListModel *model=_dataSourceArr[indexPath.section];
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
    
#pragma mark 弹出登录注册页面
- (void)presentLoginVCWithSender:(UIButton *)sender{
    DDLoginVC * vc = [[DDLoginVC alloc] init];
    vc.loginSuccessBlock = ^{
        //__weak __typeof(self) weakSelf=self;
        //[weakSelf requestTypesData];
        
        DDSearchCompanyListModel *model=_dataSourceArr[sender.tag];
        
        DDPeopleDetailVC *peopleDetail=[[DDPeopleDetailVC alloc]init];
        peopleDetail.staffInfoId=model.staffInfoId;
        [self.navigationController pushViewController:peopleDetail animated:YES];
        
        //发出登录成功通知
        [[NSNotificationCenter defaultCenter] postNotificationName:KLoginSuccessNotification object:nil userInfo:nil];
    };
    
    
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [DDNavigationUtil setNavigationBottomLineNomalColor:nav];
    
    [self presentViewController:nav animated:YES completion:nil];
}
    
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [_textField resignFirstResponder];
}


@end
