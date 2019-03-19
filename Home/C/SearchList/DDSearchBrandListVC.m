//
//  DDSearchBrandListVC.m
//  GongChengDD
//
//  Created by xzx on 2018/9/25.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDSearchBrandListVC.h"
#import "MJRefresh.h"
#import "DDNavigationUtil.h"
#import "DDLoginCheckVC.h"
#import "DataLoadingView.h"//加载页面
#import "DDNoResultView.h"//无数据视图
#import "DDSearchBrandListModel.h"//model
#import "DDSearchBrandListCell.h"//cell

#import "DDBrandTypeSelectView.h"//商标类型选择
#import "DDBrandStatusSelectView.h"//商标状态选择
#import "DDBrandTimeSelectView.h"//商标时间选择

#import "DDSearchHistoryDAOAndDB.h"//搜索历史数据库操作类
#import "DDThirdPartyKeys.h"
#import "DDUMengEventDefines.h"
#import "DDBrandDetailVC.h"//商标详情页面
#import "DDCompanyDetailVC.h"//公司详情页面

@interface DDSearchBrandListVC ()<UITableViewDelegate,UITableViewDataSource,DDBrandTypeSelectViewDelegate,DDBrandStatusSelectViewDelegate,DDBrandTimeSelectViewDelegate,UITextFieldDelegate>

{
    UIView *_topBgView;
    UITextField *_textField;
    
    NSInteger currentPage;
    NSInteger pageCount;
    NSMutableArray *_dataSourceArr;
    NSMutableDictionary *_dict;
    
    UILabel *_label1;//放左边那个城市选择文字
    UILabel *_label2;//放中间那个状态选择文字
    UILabel *_label3;//放右边那个时间选择文字
    
    UILabel *_leftLab;//"搜索到"三个字的label
    UILabel *_numLabel;//总计数量label
    UILabel *_rightLab;//"个公司"三个字的label
    
    BOOL _isTypeSelected;//判断是否点开了类型选择视图
    BOOL _isStatusSelected;//判断是否点开了状态选择视图
    BOOL _isTimeSelected;//判断是否点开了时间筛选视图
    
    NSString *_type;//类型
    NSString *_status;//状态
    NSString *_timeStr;//时间
}
@property (nonatomic,strong) DataLoadingView *loadingView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) DDNoResultView *noResultView;//无数据视图

@property (nonatomic,strong) UIImageView *imgView1;//放左边那个城市选择小箭头
@property (nonatomic,strong) DDBrandTypeSelectView *typeSelectView;//类型筛选视图

@property (nonatomic,strong) UIImageView *imgView2;//放中间那个状态选择小箭头
@property (nonatomic,strong) DDBrandStatusSelectView *statusSelectView;//状态筛选视图

@property (nonatomic,strong) UIImageView *imgView3;//放右边那个时间选择小箭头
@property (nonatomic,strong) DDBrandTimeSelectView *timeSelectView;//时间筛选视图

@end

@implementation DDSearchBrandListVC

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
    
    [MobClick event:main_maigongsi];
    self.view.backgroundColor=kColorBackGroundColor;
    _type=@"";
    _status=@"";
    _timeStr=@"";
    _isTypeSelected=NO;
    _isStatusSelected=NO;
    _isTimeSelected=NO;
    _dataSourceArr=[[NSMutableArray alloc]init];
    [self editNavItem];
    [self createChooseBtns];
    [self createTableView];
    [self createLoadView];
    [self requestData];
}

//定制导航条
-(void)editNavItem{
    self.view.backgroundColor=kColorBackGroundColor;
    self.navigationItem.leftBarButtonItem=[DDUtils leftButtonItemWithImage:@"Nav_back_blue" highlightedImage:@"Nav_back_blue" target:self action:@selector(popBackClick)];
    
    //_topBgView=[[UIView alloc]initWithFrame:CGRectMake(60, 4.5, Screen_Width-60-40-16-20, 35)];
    _topBgView=[[UIView alloc]initWithFrame:CGRectMake(60, 4.5, Screen_Width-80, 35)];
    _topBgView.backgroundColor=KColorSearchTextFieldGrey;
    _topBgView.layer.cornerRadius=3;
    _topBgView.clipsToBounds=YES;
    [self.navigationController.navigationBar addSubview:_topBgView];
    
    
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 15, 15)];
    imageView.image=[UIImage imageNamed:@"cm_Search_icon"];
    [_topBgView addSubview:imageView];
    
    //_textField=[[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+10, 0, Screen_Width-60-40-10-20-10-16-20, 35)];
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
    [_typeSelectView hiddenActionSheet];
    [_statusSelectView hiddenActionSheet];
    [_timeSelectView hiddenActionSheet];
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)viewDidDisappear:(BOOL)animated{
    if (self.navigationController==NULL) {
        [_typeSelectView hiddenActionSheet];
        [_statusSelectView hiddenActionSheet];
        [_timeSelectView hiddenActionSheet];
    }
    else{
        _imgView1.image=[UIImage imageNamed:@"home_search_down"];
        [_typeSelectView hiddenActionSheet];
        _isTypeSelected=NO;
        _imgView2.image=[UIImage imageNamed:@"home_search_down"];
        [_statusSelectView hiddenActionSheet];
        _isStatusSelected=NO;
        _imgView3.image=[UIImage imageNamed:@"home_search_down"];
        [_timeSelectView hiddenActionSheet];
        _isTimeSelected=NO;
    }
}

#pragma mark 监听文本框文字的改变,此时要关联三个子页面的刷新
- (void)textFieldDidChange:(UITextField *)textField{
    UITextRange *rang = textField.markedTextRange; // 获取非=选中状态文字范围
    if (rang == nil) { // 没有非选中状态文字.就是确定的文字输入
        if ([textField.text isEqual:@""]) {
            [self popBackClick];
            //self.searchText=textField.text;
            //[self requestData];
        }
        else{
            if (textField.text.length<2) {
                //[DDUtils showToastWithMessage:@"关键词长度不够！"];
            }
            else{
                self.searchText=textField.text;
                
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
    [params setValue:_status forKey:@"status"];
    [params setValue:_type forKey:@"type"];
    [params setValue:_timeStr forKey:@"date"];
    [params setValue:[NSString stringWithFormat:@"%ld",currentPage] forKey:@"page"];
    [params setValue:@"10" forKey:@"rows"];
    
    
    [[DDHttpManager sharedInstance]sendPostRequest:KHttpRequest_queryHighLightList params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"**********查商标搜索结果数据***************%@",responseObject);
        
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
                _rightLab.frame=CGRectMake(CGRectGetMaxX(_numLabel.frame)+2, 15, 90, 15);
                
                if (listArr.count!=0) {
                    [_noResultView hiddenNoDataView];
                    [_dataSourceArr removeAllObjects];
                    for (NSDictionary *dic in listArr) {
                        DDSearchBrandListModel *model = [[DDSearchBrandListModel alloc]initWithDictionary:dic error:nil];
                        
                        
                        if (![DDUtils isEmptyString:model.brandName]) {
                            NSString *titleStr=[NSString stringWithFormat:@"<font color='#222222'>%@</font>",model.brandName];
                            NSAttributedString *title = [[NSAttributedString alloc] initWithData:[titleStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
                            model.titleAttrStr=title;
                        }
                        
                        if (![DDUtils isEmptyString:model.registerId]) {
                            NSString *titleStr=[NSString stringWithFormat:@"<font color='#888888'>%@</font>",model.registerId];
                            NSAttributedString *title = [[NSAttributedString alloc] initWithData:[titleStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
                            model.registerIdAttrStr=title;
                        }
                        
                        if (![DDUtils isEmptyString:model.enterpriseName]) {
                            NSString *titleStr=[NSString stringWithFormat:@"<font color='#444444'>%@</font>",model.enterpriseName];
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
                    [_noResultView showNoResultViewWithTitle:@"商标信息" andImage:@"noResult_company"];
                }
            }
            else{
                [_noResultView showNoResultViewWithTitle:@"商标信息" andImage:@"noResult_company"];
            }
        }
        else{
            [_noResultView showNoResultViewWithTitle:@"商标信息" andImage:@"noResult_company"];
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
    [params setValue:_status forKey:@"status"];
    [params setValue:_type forKey:@"type"];
    [params setValue:_timeStr forKey:@"date"];
    [params setValue:[NSString stringWithFormat:@"%ld",currentPage] forKey:@"page"];
    [params setValue:@"10" forKey:@"rows"];
    
    
    [[DDHttpManager sharedInstance]sendPostRequest:KHttpRequest_queryHighLightList params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"**********查商标搜索结果数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        __weak __typeof(self) weakSelf = self;
        if (response.isSuccess) {
            if (![response isEmpty]) {
                _dict = responseObject[KData];
                NSArray *listArr = _dict[@"result"];
                for (NSDictionary *dic in listArr) {
                    DDSearchBrandListModel *model = [[DDSearchBrandListModel alloc]initWithDictionary:dic error:nil];
                    
                    
                    if (![DDUtils isEmptyString:model.brandName]) {
                        NSString *titleStr=[NSString stringWithFormat:@"<font color='#222222'>%@</font>",model.brandName];
                        NSAttributedString *title = [[NSAttributedString alloc] initWithData:[titleStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
                        model.titleAttrStr=title;
                    }
                    
                    if (![DDUtils isEmptyString:model.registerId]) {
                        NSString *titleStr=[NSString stringWithFormat:@"<font color='#888888'>%@</font>",model.registerId];
                        NSAttributedString *title = [[NSAttributedString alloc] initWithData:[titleStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
                        model.registerIdAttrStr=title;
                    }
                    
                    if (![DDUtils isEmptyString:model.enterpriseName]) {
                        NSString *titleStr=[NSString stringWithFormat:@"<font color='#444444'>%@</font>",model.enterpriseName];
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


#pragma mark 创建筛选按钮
-(void)createChooseBtns{
    //类型选择按钮
    UIButton *areaSelectBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, Screen_Width/3, 39)];
    [areaSelectBtn setBackgroundColor:kColorWhite];
    
    _label1=[[UILabel alloc]init];
    _label1.text=@"全部类型";
    _label1.textColor=KColorBlackTitle;
    _label1.font=kFontSize30;
    [areaSelectBtn addSubview:_label1];
    
    _imgView1=[[UIImageView alloc]init];
    _imgView1.contentMode = UIViewContentModeScaleAspectFit;
    _imgView1.image=[UIImage imageNamed:@"home_search_down"];
    [areaSelectBtn addSubview:_imgView1];
    [areaSelectBtn addTarget:self action:@selector(areaSelectClick) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect leftTextFrame = [@"全部类型" boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
    CGFloat leftWidth=leftTextFrame.size.width+4+15;
    if (leftWidth>=(Screen_Width/3-40)) {
        _label1.frame=CGRectMake(20, 12, (Screen_Width/3-40)-4-15, 15);
        _imgView1.frame=CGRectMake(CGRectGetMaxX(_label1.frame)+4, 12, 15, 15);
    }
    else{
        _label1.frame=CGRectMake((Screen_Width/3-leftWidth)/2, 12, leftWidth-4-15, 15);
        _imgView1.frame=CGRectMake(CGRectGetMaxX(_label1.frame)+4, 12, 15, 15);
    }
    
    [self.view addSubview:areaSelectBtn];
    
    
    //状态选择按钮
    UIButton *typeAndLevelBtn=[[UIButton alloc]initWithFrame:CGRectMake(Screen_Width/3, 0, Screen_Width/3, 39)];
    [typeAndLevelBtn setBackgroundColor:kColorWhite];
    
    _label2=[[UILabel alloc]init];
    _label2.text=@"全部状态";
    _label2.textColor=KColorBlackTitle;
    _label2.font=kFontSize30;
    [typeAndLevelBtn addSubview:_label2];
    
    _imgView2=[[UIImageView alloc]init];
    _imgView2.contentMode = UIViewContentModeScaleAspectFit;
    _imgView2.image=[UIImage imageNamed:@"home_search_down"];
    [typeAndLevelBtn addSubview:_imgView2];
    [typeAndLevelBtn addTarget:self action:@selector(typeAndLevelClick) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect rightTextFrame = [@"全部状态" boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
    CGFloat rightWidth=rightTextFrame.size.width+4+15;
    if (rightWidth>=(Screen_Width/3-40)) {
        _label2.frame=CGRectMake(20, 12, (Screen_Width/3-40)-4-15, 15);
        _imgView2.frame=CGRectMake(CGRectGetMaxX(_label2.frame)+4, 12, 15, 15);
    }
    else{
        _label2.frame=CGRectMake((Screen_Width/3-rightWidth)/2, 12, rightWidth-4-15, 15);
        _imgView2.frame=CGRectMake(CGRectGetMaxX(_label2.frame)+4, 12, 15, 15);
    }
    
    [self.view addSubview:typeAndLevelBtn];
    
    
    
    //时间筛选按钮
    UIButton *moneySelectBtn=[[UIButton alloc]initWithFrame:CGRectMake(Screen_Width/3*2, 0, Screen_Width/3, 39)];
    [moneySelectBtn setBackgroundColor:kColorWhite];
    
    _label3=[[UILabel alloc]init];
    _label3.text=@"不限";
    _label3.textColor=KColorBlackTitle;
    _label3.font=kFontSize30;
    [moneySelectBtn addSubview:_label3];
    
    _imgView3=[[UIImageView alloc]init];
    _imgView3.contentMode = UIViewContentModeScaleAspectFit;
    _imgView3.image=[UIImage imageNamed:@"home_search_down"];
    [moneySelectBtn addSubview:_imgView3];
    [moneySelectBtn addTarget:self action:@selector(moneySelectClick) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect moneyTextFrame = [@"不限" boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
    CGFloat moneyWidth=moneyTextFrame.size.width+4+15;
    if (moneyWidth>=(Screen_Width/3-40)) {
        _label3.frame=CGRectMake(20, 12, (Screen_Width/3-40)-4-15, 15);
        _imgView3.frame=CGRectMake(CGRectGetMaxX(_label3.frame)+4, 12, 15, 15);
    }
    else{
        _label3.frame=CGRectMake((Screen_Width/3-moneyWidth)/2, 12, moneyWidth-4-15, 15);
        _imgView3.frame=CGRectMake(CGRectGetMaxX(_label3.frame)+4, 12, 15, 15);
    }
    
    [self.view addSubview:moneySelectBtn];
    
    
    //搜索结果数量统计
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
    
    _rightLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_numLabel.frame)+2, 15, 90, 15)];
    _rightLab.text=@"个商标";
    _rightLab.textColor=KColorGreySubTitle;
    _rightLab.font=kFontSize26;
    [summaryView addSubview:_rightLab];
}

#pragma mark 创建tableView
-(void)createTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 39+45, Screen_Width, Screen_Height-KNavigationBarHeight-39-45) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=kColorBackGroundColor;
    _tableView.showsVerticalScrollIndicator=YES;
    _tableView.separatorColor=KColorTableSeparator;
    _tableView.estimatedRowHeight=44;
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
    if (_dataSourceArr.count>0) {
        DDSearchBrandListModel *model=_dataSourceArr[indexPath.section];
        
        static NSString * cellID = @"DDSearchBrandListCell";
        DDSearchBrandListCell * cell = (DDSearchBrandListCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
        }
        
        [cell loadDataWithModel:model];
        
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    else{
        static NSString * cellID = @"DDSearchBrandListCell";
        DDSearchBrandListCell * cell = (DDSearchBrandListCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
        }
        
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _imgView1.image=[UIImage imageNamed:@"home_search_down"];
    [_typeSelectView hiddenActionSheet];
    _isTypeSelected=NO;
    _imgView2.image=[UIImage imageNamed:@"home_search_down"];
    [_statusSelectView hiddenActionSheet];
    _isStatusSelected=NO;
    _imgView3.image=[UIImage imageNamed:@"home_search_down"];
    [_timeSelectView hiddenActionSheet];
    _isTimeSelected=NO;
    if ([DDUtils isEmptyString:[DDUserManager sharedInstance].userid]) {
        [self presentLoginVCWithIndexPath:indexPath];
    }
    else{
        DDSearchBrandListModel *model=_dataSourceArr[indexPath.section];
        //此时需要存数据库了
        //存最近搜索
        [DDSearchHistoryDAOAndDB insertRecentSearchByTypeId:self.menuId andSearchText:self.searchText];
        //存浏览历史
        NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithData:[model.brandName dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        [DDSearchHistoryDAOAndDB insertHistorySearchByTypeId:self.menuId andSearchResult:[DDUtils transformAttributedText:attributeStr] andGlobalType:nil andTransId:model.id];
        
        DDBrandDetailVC *brandDetail=[[DDBrandDetailVC alloc]init];
        brandDetail.urlid = model.id;
        [self.navigationController pushViewController:brandDetail animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    DDSearchBrandListModel *model=_dataSourceArr[section];
    
    UIView *footerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 45)];
    footerView.backgroundColor=kColorWhite;
    
    UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(12, 15, 15, 15)];
    imgView.image=[UIImage imageNamed:@"home_com_link"];
    [footerView addSubview:imgView];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imgView.frame)+15, 15, Screen_Width-54, 15)];
    
    
    
    label.attributedText = model.enterpriseNameAttrStr;
    label.font=kFontSize28;
    
    
    [footerView addSubview:label];
    
    UIButton *btn=[[UIButton alloc]initWithFrame:footerView.frame];
    [footerView addSubview:btn];
    btn.tag=150+section;
    [btn addTarget:self action:@selector(companyClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return footerView;
}

//点击公司名称
-(void)companyClick:(UIButton *)sender{
//    if ([DDUtils isEmptyString:[DDUserManager sharedInstance].userid]) {
//        [self presentLoginVCWithSender:sender];
//    }
//    else{
//        DDSearchBrandListModel *model=_dataSourceArr[sender.tag-150];
//        
//        DDCompanyDetailVC *companyDetailVC=[[DDCompanyDetailVC alloc]init];
//        companyDetailVC.enterpriseId=model.enterpriseId;
//        [self.navigationController pushViewController:companyDetailVC animated:YES];
//    }
    
    _imgView1.image=[UIImage imageNamed:@"home_search_down"];
    [_typeSelectView hiddenActionSheet];
    _isTypeSelected=NO;
    _imgView2.image=[UIImage imageNamed:@"home_search_down"];
    [_statusSelectView hiddenActionSheet];
    _isStatusSelected=NO;
    _imgView3.image=[UIImage imageNamed:@"home_search_down"];
    [_timeSelectView hiddenActionSheet];
    _isTimeSelected=NO;
    DDSearchBrandListModel *model=_dataSourceArr[sender.tag-150];
    
    DDCompanyDetailVC *companyDetailVC=[[DDCompanyDetailVC alloc]init];
    companyDetailVC.enterpriseId=model.enterpriseId;
    [self.navigationController pushViewController:companyDetailVC animated:YES];
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
    return 45;
}

#pragma mark 点击商标类型选择
-(void)areaSelectClick{
    if (_isTypeSelected==NO) {
        _imgView2.image=[UIImage imageNamed:@"home_search_down"];
        [_statusSelectView hiddenActionSheet];
        _isStatusSelected=NO;
        
        _imgView3.image=[UIImage imageNamed:@"home_search_down"];
        [_timeSelectView hiddenActionSheet];
        _isTimeSelected=NO;
        
        _imgView1.image=[UIImage imageNamed:@"home_search_up"];
        
        _typeSelectView=[[DDBrandTypeSelectView alloc]initWithFrame:CGRectMake(0, 39, Screen_Width, Screen_Height-KNavigationBarHeight-39)];
        _typeSelectView.attachHeight=@"0";
        _typeSelectView.typeStr=_type;
        __weak __typeof(self) weakSelf=self;
        _typeSelectView.hiddenBlock = ^{
            weakSelf.imgView1.image=[UIImage imageNamed:@"home_search_down"];
            
            [weakSelf.typeSelectView hiddenActionSheet];
            
            _isTypeSelected=NO;
        };
        _typeSelectView.delegate=self;
        [_typeSelectView show];
        [_textField resignFirstResponder];
        
        _isTypeSelected=YES;
    }
    else{
        _imgView1.image=[UIImage imageNamed:@"home_search_down"];
        
        [_typeSelectView hiddenActionSheet];
        
        _isTypeSelected=NO;
    }
}

#pragma mark DDBrandTypeSelectViewDelegate代理回调
-(void)actionsheetDisappear:(DDBrandTypeSelectView *)actionSheet andTypeStr:(NSString *)typeStr andTypeCode:(NSString *)typeCode{
    
    if ([typeCode isEqualToString:@""]) {
        _type=@"";
    }
    else{
//        _type=[NSString stringWithFormat:@"%@-%@",typeCode,typeStr];
        _type = typeStr;
    }
    
    CGRect leftTextFrame = [typeStr boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
    CGFloat leftWidth=leftTextFrame.size.width+4+15;
    if (leftWidth>=(Screen_Width/3-40)) {
        _label1.frame=CGRectMake(20, 12, (Screen_Width/3-40)-4-15, 15);
        _imgView1.frame=CGRectMake(CGRectGetMaxX(_label1.frame)+4, 12, 15, 15);
    }
    else{
        _label1.frame=CGRectMake((Screen_Width/3-leftWidth)/2, 12, leftWidth-4-15, 15);
        _imgView1.frame=CGRectMake(CGRectGetMaxX(_label1.frame)+4, 12, 15, 15);
    }
    
    _label1.text=typeStr;

    [self requestData];
}

#pragma mark 点击状态选择
-(void)typeAndLevelClick{
    if (_isStatusSelected==NO) {
        _imgView1.image=[UIImage imageNamed:@"home_search_down"];
        [_typeSelectView hiddenActionSheet];
        _isTypeSelected=NO;
        
        _imgView3.image=[UIImage imageNamed:@"home_search_down"];
        [_timeSelectView hiddenActionSheet];
        _isTimeSelected=NO;
        
        
        _imgView2.image=[UIImage imageNamed:@"home_search_up"];
        
        _statusSelectView=[[DDBrandStatusSelectView alloc]initWithFrame:CGRectMake(0, 39+60, Screen_Width, Screen_Height-KNavigationBarHeight-39-60)];
        _statusSelectView.attachHeight=@"0";
        _statusSelectView.statusStr=_status;
        __weak __typeof(self) weakSelf=self;
        _statusSelectView.hiddenBlock = ^{
            weakSelf.imgView2.image=[UIImage imageNamed:@"home_search_down"];
            
            [weakSelf.statusSelectView hiddenActionSheet];
            
            _isStatusSelected=NO;
        };
        _statusSelectView.delegate=self;
        [_statusSelectView show];
        [_textField resignFirstResponder];
        
        _isStatusSelected=YES;
    }
    else{
        _imgView2.image=[UIImage imageNamed:@"home_search_down"];
        
        [_statusSelectView hiddenActionSheet];
        
        _isStatusSelected=NO;
    }

}

#pragma mark DDBrandStatusSelectViewDelegate代理回调
-(void)actionsheetDisappear:(DDBrandStatusSelectView *)actionSheet andStatusStr:(NSString *)statusStr{
    _status=statusStr;
    
    NSString *tempStr;
    if ([statusStr isEqualToString:@""]) {
        tempStr=@"全部状态";
    }
    else{
        tempStr=statusStr;
    }
    CGRect rightTextFrame = [tempStr boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
    CGFloat rightWidth=rightTextFrame.size.width+4+15;
    if (rightWidth>=(Screen_Width/3-40)) {
        _label2.frame=CGRectMake(20, 12, (Screen_Width/3-40)-4-15, 15);
        _imgView2.frame=CGRectMake(CGRectGetMaxX(_label2.frame)+4, 12, 15, 15);
    }
    else{
        _label2.frame=CGRectMake((Screen_Width/3-rightWidth)/2, 12, rightWidth-4-15, 15);
        _imgView2.frame=CGRectMake(CGRectGetMaxX(_label2.frame)+4, 12, 15, 15);
    }
    
    _label2.text=tempStr;
    
    [self requestData];
}


#pragma mark 点击时间筛选
-(void)moneySelectClick{
    if (_isTimeSelected==NO) {
        _imgView1.image=[UIImage imageNamed:@"home_search_down"];
        [_typeSelectView hiddenActionSheet];
        _isTypeSelected=NO;
        
        _imgView2.image=[UIImage imageNamed:@"home_search_down"];
        [_statusSelectView hiddenActionSheet];
        _isStatusSelected=NO;
        
        _imgView3.image=[UIImage imageNamed:@"home_search_up"];
        
        _timeSelectView=[[DDBrandTimeSelectView alloc]initWithFrame:CGRectMake(0, 39+60, Screen_Width, Screen_Height-KNavigationBarHeight-39-60)];
        _timeSelectView.attachHeight=@"0";
        _timeSelectView.timeStr=_timeStr;
        __weak __typeof(self) weakSelf=self;
        _timeSelectView.hiddenBlock = ^{
            weakSelf.imgView3.image=[UIImage imageNamed:@"home_search_down"];
            
            [weakSelf.timeSelectView hiddenActionSheet];
            
            _isTimeSelected=NO;
        };
        _timeSelectView.delegate=self;
        [_timeSelectView show];
        [_textField resignFirstResponder];
        
        _isTimeSelected=YES;
    }
    else{
        _imgView3.image=[UIImage imageNamed:@"home_search_down"];
        
        [_timeSelectView hiddenActionSheet];
        
        _isTimeSelected=NO;
    }
}

#pragma mark DDBrandTimeSelectViewDelegate代理回调
-(void)actionsheetDisappear:(DDBrandTimeSelectView *)actionSheet andTimeStr:(NSString *)timeStr{
    _timeStr=timeStr;
    
    NSString *tempStr;
    if ([timeStr isEqualToString:@""]) {
        tempStr=@"不限";
    }
    else{
        tempStr=timeStr;
    }
    CGRect rightTextFrame = [tempStr boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
    CGFloat rightWidth=rightTextFrame.size.width+4+15;
    if (rightWidth>=(Screen_Width/3-40)) {
        _label3.frame=CGRectMake(20, 12, (Screen_Width/3-40)-4-15, 15);
        _imgView3.frame=CGRectMake(CGRectGetMaxX(_label3.frame)+4, 12, 15, 15);
    }
    else{
        _label3.frame=CGRectMake((Screen_Width/3-rightWidth)/2, 12, rightWidth-4-15, 15);
        _imgView3.frame=CGRectMake(CGRectGetMaxX(_label3.frame)+4, 12, 15, 15);
    }
    
    _label3.text=tempStr;
    
    [self requestData];
}






#pragma mark 弹出登录注册页面
- (void)presentLoginVCWithIndexPath:(NSIndexPath *)indexPath{
    DDLoginCheckVC * vc = [[DDLoginCheckVC alloc] init];
    vc.loginSuccessBlock = ^{
        //__weak __typeof(self) weakSelf=self;
        //[weakSelf requestTypesData];
        
        DDSearchBrandListModel *model=_dataSourceArr[indexPath.section];
        //此时需要存数据库了
        //存最近搜索
        [DDSearchHistoryDAOAndDB insertRecentSearchByTypeId:self.menuId andSearchText:self.searchText];
        //存浏览历史
        NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithData:[model.brandName dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        [DDSearchHistoryDAOAndDB insertHistorySearchByTypeId:self.menuId andSearchResult:[DDUtils transformAttributedText:attributeStr] andGlobalType:nil andTransId:model.id];
        
        
        DDBrandDetailVC *brandDetail=[[DDBrandDetailVC alloc]init];
        brandDetail.urlid = model.id;
        [self.navigationController pushViewController:brandDetail animated:YES];
    };
    
    
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [DDNavigationUtil setNavigationAndBottomLineWhiteColor:nav];
    [self showViewController:nav sender:nil];
}

#pragma mark 弹出登录注册页面
- (void)presentLoginVCWithSender:(UIButton *)sender{
    DDLoginCheckVC * vc = [[DDLoginCheckVC alloc] init];
    vc.loginSuccessBlock = ^{
        //__weak __typeof(self) weakSelf=self;
        //[weakSelf requestTypesData];
        
        DDSearchBrandListModel *model=_dataSourceArr[sender.tag-150];
        
        DDCompanyDetailVC *companyDetailVC=[[DDCompanyDetailVC alloc]init];
        companyDetailVC.enterpriseId=model.enterpriseId;
        [self.navigationController pushViewController:companyDetailVC animated:YES];
    };
    
    
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [DDNavigationUtil setNavigationAndBottomLineWhiteColor:nav];
    [self showViewController:nav sender:nil];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [_textField resignFirstResponder];
}



@end
