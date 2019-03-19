//
//  DDSearchBuyCompanyListVC.m
//  GongChengDD
//
//  Created by xzx on 2018/5/30.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDSearchBuyCompanyListVC.h"
#import "MJRefresh.h"
#import "DDNavigationUtil.h"
#import "DDLoginVC.h"
#import "DataLoadingView.h"//加载页面
#import "DDNoResultView.h"//无数据视图
#import "DDBuyCompanyList1Cell.h"//cell
#import "DDBuyCompanyList2Cell.h"//cell
#import "DDBuyCompanyDetailVC.h"//买公司详情页面
#import "CitySelectTableView.h"//城市选择
#import "DDCertiAndLevelVC.h"//资质类别及等级页面
#import "DDMoneySelectView.h"//金额筛选View
#import "DDSearchBuyCompanyListModel.h"//model
#import "DDSearchHistoryDAOAndDB.h"//搜索历史数据库操作类
//#import "HDChatViewController.h"//环信客服页面
#import "DDThirdPartyKeys.h"
#import "DDUMengEventDefines.h"

@interface DDSearchBuyCompanyListVC ()<UITableViewDelegate,UITableViewDataSource,CitySelectTableViewDelegate,MoneySelectViewDelegate,DDCertiAndLevelVCDelagate,UITextFieldDelegate>

{
    UIView *_topBgView;
    UITextField *_textField;
    
    NSInteger currentPage;
    NSInteger pageCount;
    NSMutableArray *_dataSourceArr;
    NSMutableDictionary *_dict;
    
    UILabel *_label1;//放左边那个城市选择文字
    
    UILabel *_moneyLabel;//放中间那个金额选择文字
    
    UILabel *_label2;//放右边那个资质等级选择文字
    UIImageView *_imgView2;//放右边那个资质等级选择小箭头
    
    UILabel *_leftLab;//"搜索到"三个字的label
    UILabel *_numLabel;//总计数量label
    UILabel *_rightLab;//"个公司"三个字的label
    
    BOOL _isCitySelected;//判断是否点开了城市选择视图
    BOOL _isMoneySelected;//判断是否点开了金额筛选视图
    
    NSString *_certTypeLevels;//资质筛选等级
    NSString *_region;//地区筛选
    NSString *_amount;//金额筛选
    NSString *_amountRecord;//用来金额高亮显示用
}
@property (nonatomic,strong) DataLoadingView *loadingView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) DDNoResultView *noResultView;//无数据视图
@property (nonatomic,strong) UIImageView *imgView1;//放左边那个城市选择小箭头
@property (nonatomic,strong) CitySelectTableView *citySelectTableView;//区域筛选视图
@property (nonatomic,strong) UIImageView *moneyImgView;//放中间那个金额选择小箭头
@property (nonatomic,strong) DDMoneySelectView *moneySelectView;//金额筛选视图

@end

@implementation DDSearchBuyCompanyListVC

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
    _amount=@"";//金额筛选
    _certTypeLevels=@"";
    _region=@"";
    _amountRecord=@"";
    _isCitySelected=NO;
    _isMoneySelected=NO;
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
    //self.navigationItem.rightBarButtonItem=[DDUtils rightCustomViewWithImage:@"home_guestService" title:nil target:self action:@selector(guestServiceClick)];
    
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
    //_textField.text=self.searchText;
    _textField.placeholder=@"资质类别、区域";
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
    [_moneySelectView hiddenActionSheet];
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)viewDidDisappear:(BOOL)animated{
    if (self.navigationController==NULL) {
        [_citySelectTableView hiddenActionSheet];
        [_moneySelectView hiddenActionSheet];
    }
}

#pragma mark 客服按钮点击事件
//-(void)guestServiceClick{
//    [_citySelectTableView hidden];
//    [_moneySelectView hiddenActionSheet];
//    
//    if ([DDUtils isEmptyString:[DDUserManager sharedInstance].userid]) {
//        [self presentLoginVC];
//    }
//    else{
//        //[self enterChatVC:@"证书服务"];
//        //[self enterChatVC:@"公司买卖服务"];
//        //[self enterChatVC:@"保险服务"];
//        
//        //判断是否已经登录
//        HChatClient *client = [HChatClient sharedClient];
//        if (client.isLoggedInBefore != YES){
//            [DDUtils showToastWithMessage:charCustomerServiceError];
//            return;
//        }else{
//            //进入客服视图控制器
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                
//                //初始化聊天视图控制器,
//                //Chatter:IM服务号
//                HDChatViewController * chatVC = [[HDChatViewController alloc] initWithConversationChatter:easemobIMSeverNum];
//                
//                //指定技能组,initWithValue为技能组名称
////                HQueueIdentityInfo * queueIdentityInfo = [[HQueueIdentityInfo alloc] initWithValue:@"公司买卖服务"];
////                chatVC.queueInfo = queueIdentityInfo;
//                
//                //指定客服,账号为客服的登录邮箱地址,暂时写死1795454716@qq.com
//                //        chatVC.agent = [[HAgentIdentityInfo alloc] initWithValue:@"1795454716@qq.com"];
//                
//                //访客信息,
//                chatVC.visitorInfo = [self visitorInfo];
//                
//                //商品信息
//                // chat.commodityInfo = (NSDictionary *)notification.object;
//                
//                //设置标题,无效???
//                //            chatVC.title = @"客服";
//                chatVC.titleString =@"联系客服";
//                
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    chatVC.hidesBottomBarWhenPushed = YES;
//                    [self.navigationController pushViewController:chatVC animated:YES];
//                });
//            });
//        }
//    }
//}
//
//- (HVisitorInfo *)visitorInfo {
//    DDUserManager * userManger = [DDUserManager sharedInstance];
//    
//    DDCurrentCompanyModel * currentCompanyModel = [DDUserManager sharedInstance].currentCompanyModel;
//    DDScAttestationEntityModel *  scAttestationEntityModel = currentCompanyModel.scAttestationEntity;
//    
//    //在这里设置,用户信息
//    HVisitorInfo *visitor = [[HVisitorInfo alloc] init];
//    visitor.name = userManger.realName;
//    visitor.qq = @"";
//    visitor.phone = userManger.mobileNumber;
//    visitor.companyName = scAttestationEntityModel.entName;
//    visitor.nickName = userManger.nickName;
//    visitor.email = @"";
//    visitor.desc = @"";
//    return visitor;
//}

#pragma mark 监听文本框文字的改变,此时要关联三个子页面的刷新
- (void)textFieldDidChange:(UITextField *)textField{
    UITextRange *rang = textField.markedTextRange; // 获取非=选中状态文字范围
    if (rang == nil) { // 没有非选中状态文字.就是确定的文字输入
        if ([textField.text isEqual:@""]) {
            //[self popBackClick];
            self.searchText=textField.text;
            [self requestData];
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
    if (_dataSourceArr.count>0) {
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    }
    
    currentPage = 1;
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:self.searchText forKey:@"keys"];
    [params setValue:self.menuId forKey:@"searchType"];
    [params setValue:self.menuId forKey:@"flag"];
    [params setValue:_region forKey:@"region"];
    [params setValue:_amount forKey:@"amount"];
    [params setValue:_certTypeLevels forKey:@"certTypeLevels"];
    [params setValue:[NSString stringWithFormat:@"%ld",currentPage] forKey:@"page"];
    [params setValue:@"10" forKey:@"rows"];
    
    
    [[DDHttpManager sharedInstance]sendPostRequest:KHttpRequest_queryHighLightList params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"**********买公司搜索结果数据***************%@",responseObject);
        
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
            _rightLab.frame=CGRectMake(CGRectGetMaxX(_numLabel.frame)+2, 15, 90, 15);
            
            if (listArr.count!=0) {
                [_noResultView hiddenNoDataView];
                [_dataSourceArr removeAllObjects];
                for (NSDictionary *dic in listArr) {
                    DDSearchBuyCompanyListModel *model = [[DDSearchBuyCompanyListModel alloc]initWithDictionary:dic error:nil];
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
                [_noResultView showNoResultViewWithTitle:@"买公司信息" andImage:@"noResult_company"];
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
    [params setValue:self.menuId forKey:@"flag"];
    [params setValue:_region forKey:@"region"];
    [params setValue:_amount forKey:@"amount"];
    [params setValue:_certTypeLevels forKey:@"certTypeLevels"];
    [params setValue:[NSString stringWithFormat:@"%ld",currentPage] forKey:@"page"];
    [params setValue:@"10" forKey:@"rows"];
    
    
    [[DDHttpManager sharedInstance]sendPostRequest:KHttpRequest_queryHighLightList params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"**********买公司搜索结果数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        __weak __typeof(self) weakSelf = self;
        if (response.isSuccess) {
            
            _dict = responseObject[KData];
            NSArray *listArr = _dict[@"result"];
            for (NSDictionary *dic in listArr) {
                DDSearchBuyCompanyListModel *model = [[DDSearchBuyCompanyListModel alloc]initWithDictionary:dic error:nil];
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
    //地区选择按钮
    UIButton *areaSelectBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, Screen_Width/5*1.5, 39)];
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
    if (leftWidth>=(Screen_Width/5*1.5-40)) {
        _label1.frame=CGRectMake(20, 12, (Screen_Width/5*1.5-40)-4-15, 15);
        _imgView1.frame=CGRectMake(CGRectGetMaxX(_label1.frame)+4, 12, 15, 15);
    }
    else{
        _label1.frame=CGRectMake((Screen_Width/5*1.5-leftWidth)/2, 12, leftWidth-4-15, 15);
        _imgView1.frame=CGRectMake(CGRectGetMaxX(_label1.frame)+4, 12, 15, 15);
    }
    
    [self.view addSubview:areaSelectBtn];
    
    
    
    
    
    
    //资质类别及等级选择按钮
    UIButton *typeAndLevelBtn=[[UIButton alloc]initWithFrame:CGRectMake(Screen_Width/5*1.5, 0, Screen_Width/5*2, 39)];
    [typeAndLevelBtn setBackgroundColor:kColorNavBarGray];
    
    _label2=[[UILabel alloc]init];
    _label2.text=@"资质类别";
    _label2.textColor=KColorBlackSecondTitle;
    _label2.font=kFontSize30;
    [typeAndLevelBtn addSubview:_label2];
    
    _imgView2=[[UIImageView alloc]init];
    _imgView2.image=[UIImage imageNamed:@"home_search_down"];
    [typeAndLevelBtn addSubview:_imgView2];
    [typeAndLevelBtn addTarget:self action:@selector(typeAndLevelClick) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect rightTextFrame = [@"资质类别" boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
    CGFloat rightWidth=rightTextFrame.size.width+4+15;
    if (rightWidth>=(Screen_Width/5*2-40)) {
        _label2.frame=CGRectMake(20, 12, (Screen_Width/5*2-40)-4-15, 15);
        _imgView2.frame=CGRectMake(CGRectGetMaxX(_label2.frame)+4, 12, 15, 15);
    }
    else{
        _label2.frame=CGRectMake((Screen_Width/5*2-rightWidth)/2, 12, rightWidth-4-15, 15);
        _imgView2.frame=CGRectMake(CGRectGetMaxX(_label2.frame)+4, 12, 15, 15);
    }
    
    [self.view addSubview:typeAndLevelBtn];
    
    
    
    //金额筛选按钮
    UIButton *moneySelectBtn=[[UIButton alloc]initWithFrame:CGRectMake(Screen_Width/5*1.5+Screen_Width/5*2, 0, Screen_Width/5*1.5, 39)];
    [moneySelectBtn setBackgroundColor:kColorNavBarGray];
    
    _moneyLabel=[[UILabel alloc]init];
    _moneyLabel.text=@"金额";
    _moneyLabel.textColor=KColorBlackSecondTitle;
    _moneyLabel.font=kFontSize30;
    [moneySelectBtn addSubview:_moneyLabel];
    
    _moneyImgView=[[UIImageView alloc]init];
    _moneyImgView.image=[UIImage imageNamed:@"home_search_down"];
    [moneySelectBtn addSubview:_moneyImgView];
    [moneySelectBtn addTarget:self action:@selector(moneySelectClick) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect moneyTextFrame = [@"金额" boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
    CGFloat moneyWidth=moneyTextFrame.size.width+4+15;
    if (moneyWidth>=(Screen_Width/5*1.5-40)) {
        _moneyLabel.frame=CGRectMake(20, 12, (Screen_Width/5*1.5-40)-4-15, 15);
        _moneyImgView.frame=CGRectMake(CGRectGetMaxX(_moneyLabel.frame)+4, 12, 15, 15);
    }
    else{
        _moneyLabel.frame=CGRectMake((Screen_Width/5*1.5-moneyWidth)/2, 12, moneyWidth-4-15, 15);
        _moneyImgView.frame=CGRectMake(CGRectGetMaxX(_moneyLabel.frame)+4, 12, 15, 15);
    }
    
    [self.view addSubview:moneySelectBtn];
    
    
    
    
    UILabel *line1=[[UILabel alloc]initWithFrame:CGRectMake(Screen_Width/5*1.5-0.5, 7, 1, 25)];
    line1.backgroundColor=KColorTableSeparator;
    [self.view addSubview:line1];
    
    UILabel *line2=[[UILabel alloc]initWithFrame:CGRectMake(Screen_Width/5*1.5+Screen_Width/5*2-0.5, 7, 1, 25)];
    line2.backgroundColor=KColorTableSeparator;
    [self.view addSubview:line2];
    
    //搜索结果数量统计
    UIView *summaryView=[[UIView alloc]initWithFrame:CGRectMake(0, 39, Screen_Width, 45)];
    [self.view addSubview:summaryView];
    
    _leftLab=[[UILabel alloc]initWithFrame:CGRectMake(12, 15, 45, 15)];
    _leftLab.text=@"当前有";
    _leftLab.textColor=KColorGreySubTitle;
    _leftLab.font=kFontSize26;
    [summaryView addSubview:_leftLab];
    
    _numLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_leftLab.frame)+2, 15, 1, 15)];
    _numLabel.text=@"";
    _numLabel.textColor=kColorBlue;
    _numLabel.font=kFontSize26;
    [summaryView addSubview:_numLabel];
    
    _rightLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_numLabel.frame)+2, 15, 90, 15)];
    _rightLab.text=@"个公司要转让";
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
    if (_dataSourceArr.count>0) {
        DDSearchBuyCompanyListModel *model=_dataSourceArr[indexPath.section];
        
        if ([model.dealState isEqualToString:@"0"]) {//未成交
            static NSString * cellID = @"DDBuyCompanyList1Cell";
            DDBuyCompanyList1Cell * cell = (DDBuyCompanyList1Cell *)[tableView dequeueReusableCellWithIdentifier:cellID];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
            }
            
            cell.nameLab.text=model.enterpriseName;
            cell.descLab.text=model.certTypeLevel;
            if ([model.mergerName containsString:@","]) {
                cell.addressLab.text=[model.mergerName stringByReplacingOccurrencesOfString:@"," withString:@""];
            }
            else{
                cell.addressLab.text=model.mergerName;
            }
            
            
            if (![DDUtils isEmptyString:model.auditTime]) {
                cell.timeLab.text=[NSString stringWithFormat:@"%@发布",[DDUtils getDateChineseByStandardTime:model.auditTime]];
            }
            
            if (![DDUtils isEmptyString:model.price] && ![model.price isEqualToString:@"0"]) {
                cell.moneyLab.text=[self removeFloatAllZero:[NSString stringWithFormat:@"%.2f",model.price.doubleValue/10000]];
                cell.unitLab.hidden=NO;
                cell.unitLabWidth.constant=35;
            }
            else{
                cell.moneyLab.text=@"面议";
                cell.unitLab.hidden=YES;
                cell.unitLabWidth.constant=0;
            }
            
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
        else{//已成交
            static NSString * cellID = @"DDBuyCompanyList2Cell";
            DDBuyCompanyList2Cell * cell = (DDBuyCompanyList2Cell *)[tableView dequeueReusableCellWithIdentifier:cellID];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
            }
            
            cell.nameLab.text=model.enterpriseName;
            cell.descLab.text=model.certTypeLevel;
            if ([model.mergerName containsString:@","]) {
                cell.addressLab.text=[model.mergerName stringByReplacingOccurrencesOfString:@"," withString:@""];
            }
            else{
                cell.addressLab.text=model.mergerName;
            }
            
            if (![DDUtils isEmptyString:model.auditTime]) {
                cell.timeLab.text=[NSString stringWithFormat:@"%@发布",[DDUtils getDateChineseByStandardTime:model.auditTime]];
            }
            
            if (![DDUtils isEmptyString:model.price] && ![model.price isEqualToString:@"0"]) {
                cell.moneyLab.text=[self removeFloatAllZero:[NSString stringWithFormat:@"%.2f",model.price.doubleValue/10000]];
                cell.unitLab.hidden=NO;
                cell.unitLabWidth.constant=35;
            }
            else{
                cell.moneyLab.text=@"面议";
                cell.unitLab.hidden=YES;
                cell.unitLabWidth.constant=0;
            }
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    else{
        static NSString * cellID = @"DDBuyCompanyList1Cell";
        DDBuyCompanyList1Cell * cell = (DDBuyCompanyList1Cell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
        }
        
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    
}

#pragma mark 取出小数点后多余的0
-(NSString *)removeFloatAllZero:(NSString *)string{
    NSString * testNumber = string;
    NSString * outNumber = [NSString stringWithFormat:@"%@",@(testNumber.floatValue)];
    //价格格式化显示
    NSNumberFormatter * formatter = [[NSNumberFormatter alloc]init];
    formatter.numberStyle = kCFNumberFormatterDecimalStyle;
    NSString * formatterString = [formatter stringFromNumber:[NSNumber numberWithFloat:[outNumber doubleValue]]];
    //获取要截取的字符串位置
    NSRange range = [formatterString rangeOfString:@"."];
    if (range.length >0 ) {
        NSString * result = [formatterString substringFromIndex:range.location];
        if (result.length >= 4) {
            formatterString = [formatterString substringToIndex:formatterString.length - 1];
        }
    }
    
    return formatterString;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([DDUtils isEmptyString:[DDUserManager sharedInstance].userid]) {
        [self presentLoginVCWithIndexPath:indexPath];
    }
    else{
        DDSearchBuyCompanyListModel *model=_dataSourceArr[indexPath.section];
        //    //此时需要存数据库了
        //    //存最近搜索
        //    [DDSearchHistoryDAOAndDB insertRecentSearchByTypeId:self.menuId andSearchText:self.searchText];
        //    //存浏览历史
        //    [DDSearchHistoryDAOAndDB insertHistorySearchByTypeId:self.menuId andSearchResult:model.enterpriseName andGlobalType:nil andTransId:model.entId];
        
        
        DDBuyCompanyDetailVC *buyCompanyDetail=[[DDBuyCompanyDetailVC alloc]init];
        buyCompanyDetail.enterpriseId = model.entId;
        buyCompanyDetail.saleRegisterId = model.saleRegisterId;
        [self.navigationController pushViewController:buyCompanyDetail animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 125;
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
        //将金额筛选隐藏
        _moneyImgView.image=[UIImage imageNamed:@"home_search_down"];
        [_moneySelectView hiddenActionSheet];
        _isMoneySelected=NO;
        
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
    if (leftWidth>=(Screen_Width/5*1.5-40)) {
        _label1.frame=CGRectMake(20, 12, (Screen_Width/5*1.5-40)-4-15, 15);
        _imgView1.frame=CGRectMake(CGRectGetMaxX(_label1.frame)+4, 12, 15, 15);
    }
    else{
        _label1.frame=CGRectMake((Screen_Width/5*1.5-leftWidth)/2, 12, leftWidth-4-15, 15);
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
        if (leftWidth>=(Screen_Width/5*1.5-40)) {
            _label1.frame=CGRectMake(20, 12, (Screen_Width/5*1.5-40)-4-15, 15);
            _imgView1.frame=CGRectMake(CGRectGetMaxX(_label1.frame)+4, 12, 15, 15);
        }
        else{
            _label1.frame=CGRectMake((Screen_Width/5*1.5-leftWidth)/2, 12, leftWidth-4-15, 15);
            _imgView1.frame=CGRectMake(CGRectGetMaxX(_label1.frame)+4, 12, 15, 15);
        }
        
        
        _label1.text=regionStr;
    }
    
    [self requestData];
}




#pragma mark 点击金额筛选
-(void)moneySelectClick{
    if (_isMoneySelected==NO) {
        //将区域筛选隐藏
        _imgView1.image=[UIImage imageNamed:@"home_search_down"];
        //[_citySelectTableView hiddenActionSheet];
        [_citySelectTableView hidden];
        _isCitySelected=NO;
        
        
        _moneyImgView.image=[UIImage imageNamed:@"home_search_up"];
        
        _moneySelectView=[[DDMoneySelectView alloc]initWithFrame:CGRectMake(0, 39+60, Screen_Width, Screen_Height-KNavigationBarHeight-39-60)];
        _moneySelectView.attachHeight=@"0";
        _moneySelectView.amountRecord=_amountRecord;
        __weak __typeof(self) weakSelf=self;
        _moneySelectView.hiddenBlock = ^{
            weakSelf.moneyImgView.image=[UIImage imageNamed:@"home_search_down"];
            
            [weakSelf.moneySelectView hiddenActionSheet];
            
            _isMoneySelected=NO;
        };
        _moneySelectView.delegate=self;
        [_moneySelectView show];
        [_textField resignFirstResponder];
        
        _isMoneySelected=YES;
    }
    else{
        _moneyImgView.image=[UIImage imageNamed:@"home_search_down"];
        
        [_moneySelectView hiddenActionSheet];
        
        _isMoneySelected=NO;
    }
}

#pragma mark MoneySelectViewDelegate代理回调
-(void)actionsheetDisappear:(DDMoneySelectView *)actionSheet andMoney:(NSString *)money andMin:(NSString *)min andMax:(NSString *)max{
    
    _amount=money;
    
    CGRect rightTextFrame = [_amount boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
    CGFloat rightWidth=rightTextFrame.size.width+4+15;
    if (rightWidth>=(Screen_Width/5*1.5-40)) {
        _moneyLabel.frame=CGRectMake(20, 12, (Screen_Width/5*1.5-40)-4-15, 15);
        _moneyImgView.frame=CGRectMake(CGRectGetMaxX(_moneyLabel.frame)+4, 12, 15, 15);
    }
    else{
        _moneyLabel.frame=CGRectMake((Screen_Width/5*1.5-rightWidth)/2, 12, rightWidth-4-15, 15);
        _moneyImgView.frame=CGRectMake(CGRectGetMaxX(_moneyLabel.frame)+4, 12, 15, 15);
    }
    
    _moneyLabel.text=_amount;
    _amountRecord=_amount;
    
    _amount=[NSString stringWithFormat:@"%@-%@",min,max];
    
    if ([money isEqualToString:@"全部"]) {
        _amount=@"";
        _amountRecord=@"";
    }
    
    [self requestData];
}


#pragma mark 点击资质类别选择
-(void)typeAndLevelClick{
    _imgView1.image=[UIImage imageNamed:@"home_search_down"];
    //[_citySelectTableView hiddenActionSheet];
    [_citySelectTableView hidden];
    _isCitySelected=NO;
    
    _moneyImgView.image=[UIImage imageNamed:@"home_search_down"];
    [_moneySelectView hiddenActionSheet];
    _isMoneySelected=NO;
    
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
    if (rightWidth>=(Screen_Width/5*2-40)) {
        _label2.frame=CGRectMake(20, 12, (Screen_Width/5*2-40)-4-15, 15);
        _imgView2.frame=CGRectMake(CGRectGetMaxX(_label2.frame)+4, 12, 15, 15);
    }
    else{
        _label2.frame=CGRectMake((Screen_Width/5*2-rightWidth)/2, 12, rightWidth-4-15, 15);
        _imgView2.frame=CGRectMake(CGRectGetMaxX(_label2.frame)+4, 12, 15, 15);
    }
    
    _label2.text=_certTypeLevels;
    
    [self requestData];
}

//选择了全部
- (void)certiAndLevelVCSelectAll:(DDCertiAndLevelVC *)certiAndLevelVC{
    _certTypeLevels=@"";
    
    CGRect rightTextFrame = [@"资质类别" boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
    CGFloat rightWidth=rightTextFrame.size.width+4+15;
    if (rightWidth>=(Screen_Width/5*2-40)) {
        _label2.frame=CGRectMake(20, 12, (Screen_Width/5*2-40)-4-15, 15);
        _imgView2.frame=CGRectMake(CGRectGetMaxX(_label2.frame)+4, 12, 15, 15);
    }
    else{
        _label2.frame=CGRectMake((Screen_Width/5*2-rightWidth)/2, 12, rightWidth-4-15, 15);
        _imgView2.frame=CGRectMake(CGRectGetMaxX(_label2.frame)+4, 12, 15, 15);
    }
    
    _label2.text=@"资质类别";
    
    [self requestData];
}

#pragma mark 弹出登录注册页面
- (void)presentLoginVCWithIndexPath:(NSIndexPath *)indexPath{
    DDLoginVC * vc = [[DDLoginVC alloc] init];
    vc.loginSuccessBlock = ^{
        //__weak __typeof(self) weakSelf=self;
        //[weakSelf requestTypesData];
        
        DDSearchBuyCompanyListModel *model=_dataSourceArr[indexPath.section];
        //    //此时需要存数据库了
        //    //存最近搜索
        //    [DDSearchHistoryDAOAndDB insertRecentSearchByTypeId:self.menuId andSearchText:self.searchText];
        //    //存浏览历史
        //    [DDSearchHistoryDAOAndDB insertHistorySearchByTypeId:self.menuId andSearchResult:model.enterpriseName andGlobalType:nil andTransId:model.entId];
        
        
        DDBuyCompanyDetailVC *buyCompanyDetail=[[DDBuyCompanyDetailVC alloc]init];
        buyCompanyDetail.enterpriseId = model.entId;
        buyCompanyDetail.saleRegisterId = model.saleRegisterId;
        [self.navigationController pushViewController:buyCompanyDetail animated:YES];
        
        //发出登录成功通知
        [[NSNotificationCenter defaultCenter] postNotificationName:KLoginSuccessNotification object:nil userInfo:nil];
    };
    
    
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [DDNavigationUtil setNavigationBottomLineNomalColor:nav];
    
    [self presentViewController:nav animated:YES completion:nil];
}

//#pragma mark 弹出登录注册页面
//- (void)presentLoginVC{
//    DDLoginVC * vc = [[DDLoginVC alloc] init];
//    vc.loginSuccessBlock = ^{
//        //__weak __typeof(self) weakSelf=self;
//        //[weakSelf requestTypesData];
//        
//        //发出登录成功通知
//        [[NSNotificationCenter defaultCenter] postNotificationName:KLoginSuccessNotification object:nil userInfo:nil];
//        
//        //[self enterChatVC:@"证书服务"];
//        //[self enterChatVC:@"公司买卖服务"];
//        //[self enterChatVC:@"保险服务"];
//        
//        //判断是否已经登录
//        HChatClient *client = [HChatClient sharedClient];
//        if (client.isLoggedInBefore != YES){
//            [DDUtils showToastWithMessage:charCustomerServiceError];
//            return;
//        }else{
//            //进入客服视图控制器
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                
//                //初始化聊天视图控制器,
//                //Chatter:IM服务号
//                HDChatViewController * chatVC = [[HDChatViewController alloc] initWithConversationChatter:easemobIMSeverNum];
//                
//                //指定技能组,initWithValue为技能组名称
//                HQueueIdentityInfo * queueIdentityInfo = [[HQueueIdentityInfo alloc] initWithValue:@"公司买卖服务"];
//                chatVC.queueInfo = queueIdentityInfo;
//                
//                //指定客服,账号为客服的登录邮箱地址,暂时写死1795454716@qq.com
//                //        chatVC.agent = [[HAgentIdentityInfo alloc] initWithValue:@"1795454716@qq.com"];
//                
//                //访客信息,
//                chatVC.visitorInfo = [self visitorInfo];
//                
//                //商品信息
//                // chat.commodityInfo = (NSDictionary *)notification.object;
//                
//                //设置标题,无效???
//                //            chatVC.title = @"客服";
//                chatVC.titleString =@"公司买卖服务";
//                
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    chatVC.hidesBottomBarWhenPushed = YES;
//                    [self.navigationController pushViewController:chatVC animated:YES];
//                });
//            });
//        }
//
//    };
//    
//    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
//    [DDNavigationUtil setNavigationBottomLineNomalColor:nav];
//    
//    [self presentViewController:nav animated:YES completion:nil];
//}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [_textField resignFirstResponder];
}



@end
