//
//  DDPersonalCertiClaimListVC.m
//  GongChengDD
//
//  Created by xzx on 2018/11/30.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDPersonalCertiClaimListVC.h"
#import "MJRefresh.h"
#import "DDNavigationUtil.h"
#import "DDLoginCheckVC.h"
#import "DataLoadingView.h"//加载页面
#import "DDNoResultView.h"//无数据视图
#import "DDPersonalCertiClaimListCell.h"//cell
#import "DDSearchBuilderAndManagerListModel.h"//model
#import "DDCompanyDetailVC.h"//公司详情页面
#import "DDPeopleDetailVC.h"//人员详情页面
#import "DDAreaSelectTableView.h"//市的选择View
#import "DDFindingPeopleCertiTypeSelectView.h"//证书类别选择页面
#import "DDFindingPeopleDateSelectView.h"//有效期选择页面
#import "DDFindingPeopleContactWaySelectView.h"//联系方式选择页面
#import "DDPersonalIdentityCheckVC.h"//认领页面

@interface DDPersonalCertiClaimListVC ()<UITableViewDelegate,UITableViewDataSource,AreaSelectTableViewDelegate,DDFindingPeopleCertiTypeSelectViewDelegate,DDFindingPeopleDateSelectViewDelegate,DDFindingPeopleContactWaySelectViewDelegate,UITextFieldDelegate>

{
    UIView *_topBgView;
    UITextField *_textField;
    
    NSInteger currentPage;
    NSInteger pageCount;
    NSMutableArray *_dataSourceArr;
    NSMutableDictionary *_dict;
    
    UILabel *_label1;//放左边那个城市选择文字
    UILabel *_label2;//放中间那个证书类别选择文字
    UILabel *_label3;//放中间那个有效期选择文字
    UILabel *_label4;//放右边那个联系方式选择文字
    
    BOOL _isCitySelected;//判断是否点开了城市选择视图
    BOOL _isCertiTypeSelect;//判断是否点开了证书类别选择视图
    BOOL _isDateSelected;//判断是否点开了有效期选择视图
    BOOL _isContactSelected;//判断是否点开了联系方式选择视图
    
    NSString *_region;//地区筛选
    NSString *_certiId;//证书类别之证书筛选
    NSString *_majorId;//证书类别之专业筛选
    NSString *_date;//有效期筛选
    NSString *_contactId;//联系方式筛选
    
    UILabel *_leftLab;//"搜索到"三个字的label
    UILabel *_numLabel;//总计数量label
    UILabel *_rightLab;//"个公司"三个字的label
}
@property (nonatomic,strong) NSString *searchText;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) DataLoadingView *loadingView;
@property (nonatomic,strong) DDNoResultView *noResultView;//无数据视图
@property (nonatomic,strong) UIImageView *imgView1;//放左边那个城市选择小箭头
@property (nonatomic,strong) DDAreaSelectTableView *areaSelectTableView;//区域筛选视图
@property (nonatomic,strong) UIImageView *imgView2;//放中间那个证书类别选择小箭头
@property (nonatomic,strong) DDFindingPeopleCertiTypeSelectView *certiTypeSelectView;//证书类别筛选视图
@property (nonatomic,strong) UIImageView *imgView3;//放中间那个有效期选择小箭头
@property (nonatomic,strong) DDFindingPeopleDateSelectView *dateSelectView;//有效期筛选视图
@property (nonatomic,strong) UIImageView *imgView4;//放右边那个联系方式选择小箭头
@property (nonatomic,strong) DDFindingPeopleContactWaySelectView *contactWaySelectView;//联系方式筛选视图

@end

@implementation DDPersonalCertiClaimListVC

-(void)viewWillDisappear:(BOOL)animated{
    [_topBgView removeFromSuperview];
    //还原导航底部线条颜色
    [DDNavigationUtil setNavigationBottomLineNomalColor:self.navigationController];
}

//-(void)viewDidAppear:(BOOL)animated{
//    [self.navigationController.navigationBar addSubview:_topBgView];
//    //导航底部线条设为透明
//    [DDNavigationUtil setNavigationBottomLineClearColor:self.navigationController];
//}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar addSubview:_topBgView];
    //导航底部线条设为透明
    [DDNavigationUtil setNavigationBottomLineClearColor:self.navigationController];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=kColorBackGroundColor;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshData) name:KRefreshUI object:nil];//接收收到刷新页面的通知
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status){
        //定位不能用
        _region=@"";
    }
    else{
        //定位功能可用
        //如果保存有定位到的省,首先使用保存的,没有的话,默认江苏省
        DDUserManager *manager=[DDUserManager sharedInstance];
        if (![DDUtils isEmptyString:manager.city]) {
            _region=manager.city;
        }
        else{
            _region=@"";
        }
    }
    
    _certiId=@"";
    _majorId=@"";
    _date=@"";
    _contactId=@"";
    _searchText=@"";
    _isCitySelected=NO;
    _isCertiTypeSelect=NO;
    _isDateSelected=NO;
    _isContactSelected=NO;
    _dataSourceArr=[[NSMutableArray alloc]init];
    [self editNavItem];
    //[_textField becomeFirstResponder];
    [self createChooseBtns];
    [self createTableView];
    [self createLoadView];
    [self requestData];
}
-(void)refreshData{
    [self.tableView reloadData];
}
//定制导航条
-(void)editNavItem{
    self.view.backgroundColor=kColorBackGroundColor;
    self.navigationItem.leftBarButtonItem=[DDUtils leftButtonItemWithImage:@"Nav_back_blue" highlightedImage:@"Nav_back_blue" target:self action:@selector(popBackClick)];
    
    _topBgView=[[UIView alloc]initWithFrame:CGRectMake(60, 4.5, Screen_Width-60-25, 35)];
    _topBgView.backgroundColor=KColorSearchTextFieldGrey;
    _topBgView.layer.cornerRadius=3;
    _topBgView.clipsToBounds=YES;
    [self.navigationController.navigationBar addSubview:_topBgView];
    
    
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 15, 15)];
    imageView.image=[UIImage imageNamed:@"cm_Search_icon"];
    [_topBgView addSubview:imageView];
    
    _textField=[[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+10, 0, _topBgView.frame.size.width-20-10-10, 35)];
    _textField.delegate=self;
    _textField.placeholder=@"请输入姓名";
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
    self.imgView1.image=[UIImage imageNamed:@"home_search_down"];
    _isCitySelected = NO;
    
    [_certiTypeSelectView hiddenActionSheet];
    self.imgView2.image=[UIImage imageNamed:@"home_search_down"];
    _isCertiTypeSelect = NO;
    
    [_dateSelectView hiddenActionSheet];
    self.imgView3.image=[UIImage imageNamed:@"home_search_down"];
    _isDateSelected = NO;
    
    [_contactWaySelectView hiddenActionSheet];
    self.imgView4.image=[UIImage imageNamed:@"home_search_down"];
    _isContactSelected = NO;
    
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)viewDidDisappear:(BOOL)animated{
    if (self.navigationController==NULL) {
        [_areaSelectTableView hiddenActionSheet];
        self.imgView1.image=[UIImage imageNamed:@"home_search_down"];
        _isCitySelected = NO;
        
        [_certiTypeSelectView hiddenActionSheet];
        self.imgView2.image=[UIImage imageNamed:@"home_search_down"];
        _isCertiTypeSelect = NO;
        
        [_dateSelectView hiddenActionSheet];
        self.imgView3.image=[UIImage imageNamed:@"home_search_down"];
        _isDateSelected = NO;
        
        [_contactWaySelectView hiddenActionSheet];
        self.imgView4.image=[UIImage imageNamed:@"home_search_down"];
        _isContactSelected = NO;
    }
    else{
        [_areaSelectTableView hidden];
        self.imgView1.image=[UIImage imageNamed:@"home_search_down"];
        _isCitySelected = NO;
        
        [_certiTypeSelectView hidden];
        self.imgView2.image=[UIImage imageNamed:@"home_search_down"];
        _isCertiTypeSelect = NO;
        
        [_dateSelectView hiddenActionSheet];
        self.imgView3.image=[UIImage imageNamed:@"home_search_down"];
        _isDateSelected = NO;
        
        [_contactWaySelectView hiddenActionSheet];
        self.imgView4.image=[UIImage imageNamed:@"home_search_down"];
        _isContactSelected = NO;
    }
}

#pragma mark 监听文本框文字的改变,此时要关联三个子页面的刷新
- (void)textFieldDidChange:(UITextField *)textField{
    UITextRange *rang = textField.markedTextRange; // 获取非=选中状态文字范围
    if (rang == nil) { // 没有非选中状态文字.就是确定的文字输入
//        if ([textField.text isEqual:@""]) {
//            [self popBackClick];
//        }
//        else{
//            if (textField.text.length<2) {
//                //[DDUtils showToastWithMessage:@"关键词长度不够！"];
//            }
//            else{
//                self.searchText=_textField.text;
//                
//                [NSObject cancelPreviousPerformRequestsWithTarget:self];
//                [self performSelector:@selector(requestData) withObject:nil afterDelay:0.5];
//                //[self requestData];
//            }
//        }
        
        if (textField.text.length<2) {
            
        }
        else{
            self.searchText=_textField.text;
            
            [NSObject cancelPreviousPerformRequestsWithTarget:self];
            [self performSelector:@selector(requestData) withObject:nil afterDelay:0.5];
            //[self requestData];
        }
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (_areaSelectTableView) {
        [_areaSelectTableView hidden];
        self.imgView1.image=[UIImage imageNamed:@"home_search_down"];
        _isCitySelected = NO;
    }
    if (_certiTypeSelectView) {
        [_certiTypeSelectView hidden];
        self.imgView2.image=[UIImage imageNamed:@"home_search_down"];
        _isCertiTypeSelect = NO;
    }
    if (_dateSelectView) {
        [_dateSelectView hiddenActionSheet];
        self.imgView3.image=[UIImage imageNamed:@"home_search_down"];
        _isDateSelected = NO;
    }
    if (_contactWaySelectView) {
        [_contactWaySelectView hiddenActionSheet];
        self.imgView4.image=[UIImage imageNamed:@"home_search_down"];
        _isContactSelected = NO;
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
    [params setValue:@"52" forKey:@"searchType"];
    [params setValue:_region forKey:@"region"];//区域
    [params setValue:_certiId forKey:@"roles"];//证书类别
    [params setValue:_majorId forKey:@"certCode"];//专业
    [params setValue:_date forKey:@"date"];//有效期
    [params setValue:_contactId forKey:@"contactWay"];//联系方式
    [params setValue:[NSString stringWithFormat:@"%ld",currentPage] forKey:@"page"];
    [params setValue:@"10" forKey:@"rows"];
    
    [[DDHttpManager sharedInstance]sendPostRequest:KHttpRequest_queryHighLightList params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"**********人员库查找结果数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        __weak __typeof(self) weakSelf = self;
        [_loadingView hiddenLoadingView];
        if (response.isSuccess) {
            if (![response isEmpty]) {
                //[_dataSourceArr removeAllObjects];
                _dict = responseObject[KData];
                pageCount = [_dict[@"totalCount"] integerValue];
                NSArray *listArr=_dict[@"list"];
                
                //给数量label赋值
                NSString *totlaNum=[NSString stringWithFormat:@"%@",_dict[@"totalCount"]];
                _numLabel.text=totlaNum;
                CGRect numberFrame = [totlaNum boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
                _numLabel.frame=CGRectMake(CGRectGetMaxX(_leftLab.frame)+2, 15, numberFrame.size.width, 15);
                _rightLab.frame=CGRectMake(CGRectGetMaxX(_numLabel.frame)+2, 15, 150, 15);
                
                if (listArr.count!=0) {
                    [_noResultView hiddenNoDataView];
                    [_dataSourceArr removeAllObjects];
                    
                    for (NSDictionary *dic in listArr) {
                        DDSearchBuilderAndManagerListModel *model = [[DDSearchBuilderAndManagerListModel alloc]initWithDictionary:dic error:nil];
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
                    [_noResultView showNoResultViewWithTitle:@"人员信息" andImage:@"noResult_person"];
                }
            }
            else{
                [_noResultView showNoResultViewWithTitle:@"人员信息" andImage:@"noResult_person"];
            }
        }
        else{
            [_noResultView showNoResultViewWithTitle:@"人员信息" andImage:@"noResult_person"];
        }
        
        [self.tableView.mj_header endRefreshing];
        
        if (_dataSourceArr.count>0) {
            [self.tableView reloadData];
            [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        }
        _tableView.scrollEnabled=YES;
        _tableView.userInteractionEnabled=YES;
        
    }  failure:^(NSURLSessionDataTask *operation, id responseObject)  {
        [self.tableView.mj_header endRefreshing];
        [DDUtils showToastWithMessage:kRequestFailed];
        [_loadingView failureLoadingView];
    }];
}

- (void)addData{
    currentPage++;
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [params setValue:self.searchText forKey:@"keys"];
    [params setValue:@"52" forKey:@"searchType"];
    [params setValue:_region forKey:@"region"];//区域
    [params setValue:_certiId forKey:@"roles"];//证书类别
    [params setValue:_majorId forKey:@"certCode"];//专业
    [params setValue:_date forKey:@"date"];//有效期
    [params setValue:_contactId forKey:@"contactWay"];//联系方式
    [params setValue:[NSString stringWithFormat:@"%ld",currentPage] forKey:@"page"];
    [params setValue:@"10" forKey:@"rows"];
    
    [[DDHttpManager sharedInstance]sendPostRequest:KHttpRequest_queryHighLightList params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"**********人员库查找结果数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        __weak __typeof(self) weakSelf = self;
        if (response.isSuccess) {
            if (![response isEmpty]) {
                _dict = responseObject[KData];
                NSArray *listArr = _dict[@"list"];
                
                for (NSDictionary *dic in listArr) {
                    DDSearchBuilderAndManagerListModel *model = [[DDSearchBuilderAndManagerListModel alloc]initWithDictionary:dic error:nil];
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
        [self.tableView.mj_footer endRefreshing];
        [DDUtils showToastWithMessage:kRequestFailed];
    }];
}


#pragma mark 创建筛选按钮
-(void)createChooseBtns{
    //地区选择
    UIButton *areaSelectBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, Screen_Width/4, 39)];
    [areaSelectBtn setBackgroundColor:kColorWhite];
    
    _label1=[[UILabel alloc]init];
    DDUserManager *manager=[DDUserManager sharedInstance];
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status){
        //定位不能用
        _label1.text=@"全国";
    }
    else{
        if (![DDUtils isEmptyString:manager.city]) {
            _label1.text=manager.city;
        }
        else{
            _label1.text=@"全国";
        }
    }
    
    _label1.textColor=KColorBlackTitle;
    _label1.font=kFontSize30;
    [areaSelectBtn addSubview:_label1];
    
    _imgView1=[[UIImageView alloc]init];
    _imgView1.contentMode = UIViewContentModeScaleAspectFit;
    _imgView1.image=[UIImage imageNamed:@"home_search_down"];
    [areaSelectBtn addSubview:_imgView1];
    [areaSelectBtn addTarget:self action:@selector(areaSelectClick) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect leftTextFrame;
    if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status){
        //定位不能用
        leftTextFrame = [@"全国" boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
    }
    else{
        if (![DDUtils isEmptyString:manager.city]) {
            leftTextFrame = [manager.city boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
        }
        else{
            leftTextFrame = [@"全国" boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
        }
    }
    
    CGFloat leftWidth=leftTextFrame.size.width+4+15;
    if (leftWidth>=(Screen_Width/4-5)) {
        _label1.frame=CGRectMake(5, 12, (Screen_Width/4-5)-4-15, 15);
        _imgView1.frame=CGRectMake(CGRectGetMaxX(_label1.frame)+4, 12, 15, 15);
    }
    else{
        _label1.frame=CGRectMake((Screen_Width/4-leftWidth)/2, 12, leftWidth-4-15, 15);
        _imgView1.frame=CGRectMake(CGRectGetMaxX(_label1.frame)+4, 12, 15, 15);
    }
    
    [self.view addSubview:areaSelectBtn];
    
    //证书类别按钮
    UIButton *certiTypeSelectBtn=[[UIButton alloc]initWithFrame:CGRectMake(Screen_Width/4, 0, Screen_Width/4, 39)];
    [certiTypeSelectBtn setBackgroundColor:kColorWhite];
    
    _label2=[[UILabel alloc]init];
    _label2.text=@"证书类别";
    _label2.textColor=KColorBlackTitle;
    _label2.font=kFontSize30;
    [certiTypeSelectBtn addSubview:_label2];
    
    _imgView2=[[UIImageView alloc]init];
    _imgView2.contentMode = UIViewContentModeScaleAspectFit;
    _imgView2.image=[UIImage imageNamed:@"home_search_down"];
    [certiTypeSelectBtn addSubview:_imgView2];
    [certiTypeSelectBtn addTarget:self action:@selector(certiTypeClick) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect middle1TextFrame = [@"证书类别" boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
    CGFloat middle1Width=middle1TextFrame.size.width+4+15;
    if (middle1Width>=(Screen_Width/4-5)) {
        _label2.frame=CGRectMake(5, 12, (Screen_Width/4-5)-4-15, 15);
        _imgView2.frame=CGRectMake(CGRectGetMaxX(_label2.frame)+4, 12, 15, 15);
    }
    else{
        _label2.frame=CGRectMake((Screen_Width/4-middle1Width)/2, 12, middle1Width-4-15, 15);
        _imgView2.frame=CGRectMake(CGRectGetMaxX(_label2.frame)+4, 12, 15, 15);
    }
    
    [self.view addSubview:certiTypeSelectBtn];
    
    //有效期筛选按钮
    UIButton *dateSelectBtn=[[UIButton alloc]initWithFrame:CGRectMake(Screen_Width/2, 0, Screen_Width/4, 39)];
    [dateSelectBtn setBackgroundColor:kColorWhite];
    
    _label3=[[UILabel alloc]init];
    _label3.text=@"有效期";
    _label3.textColor=KColorBlackTitle;
    _label3.font=kFontSize30;
    [dateSelectBtn addSubview:_label3];
    
    _imgView3=[[UIImageView alloc]init];
    _imgView3.contentMode = UIViewContentModeScaleAspectFit;
    _imgView3.image=[UIImage imageNamed:@"home_search_down"];
    [dateSelectBtn addSubview:_imgView3];
    [dateSelectBtn addTarget:self action:@selector(dateSelectClick) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect middle2TextFrame = [@"有效期" boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
    CGFloat middle2Width=middle2TextFrame.size.width+4+15;
    if (middle2Width>=(Screen_Width/4-5)) {
        _label3.frame=CGRectMake(5, 12, (Screen_Width/4-5)-4-15, 15);
        _imgView3.frame=CGRectMake(CGRectGetMaxX(_label3.frame)+4, 12, 15, 15);
    }
    else{
        _label3.frame=CGRectMake((Screen_Width/4-middle2Width)/2, 12, middle2Width-4-15, 15);
        _imgView3.frame=CGRectMake(CGRectGetMaxX(_label3.frame)+4, 12, 15, 15);
    }
    
    [self.view addSubview:dateSelectBtn];
    
    //联系方式筛选按钮
    UIButton *contactSelectBtn=[[UIButton alloc]initWithFrame:CGRectMake(Screen_Width/4*3, 0, Screen_Width/4, 39)];
    [contactSelectBtn setBackgroundColor:kColorWhite];
    
    _label4=[[UILabel alloc]init];
    _label4.text=@"联系方式";
    _label4.textColor=KColorBlackTitle;
    _label4.font=kFontSize30;
    [contactSelectBtn addSubview:_label4];
    
    _imgView4=[[UIImageView alloc]init];
    _imgView4.contentMode = UIViewContentModeScaleAspectFit;
    _imgView4.image=[UIImage imageNamed:@"home_search_down"];
    [contactSelectBtn addSubview:_imgView4];
    [contactSelectBtn addTarget:self action:@selector(contactWayClick) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect rightTextFrame = [@"联系方式" boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
    CGFloat rightWidth=rightTextFrame.size.width+4+15;
    if (rightWidth>=(Screen_Width/4-5)) {
        _label4.frame=CGRectMake(5, 12, (Screen_Width/4-5)-4-15, 15);
        _imgView4.frame=CGRectMake(CGRectGetMaxX(_label4.frame)+4, 12, 15, 15);
    }
    else{
        _label4.frame=CGRectMake((Screen_Width/4-rightWidth)/2, 12, rightWidth-4-15, 15);
        _imgView4.frame=CGRectMake(CGRectGetMaxX(_label4.frame)+4, 12, 15, 15);
    }
    
    [self.view addSubview:contactSelectBtn];
    
    
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
    
    _rightLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_numLabel.frame)+2, 15, 150, 15)];
    _rightLab.text=@"个人员";
    _rightLab.textColor=KColorGreySubTitle;
    _rightLab.font=kFontSize26;
    [summaryView addSubview:_rightLab];
    
    //创建地区选择View
    _areaSelectTableView=[[DDAreaSelectTableView alloc]initWithFrame:CGRectMake(0, 39, Screen_Width, Screen_Height-KNavigationBarHeight-39)];
    if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status){
        //定位不能用
        
    }
    else{
        if (![DDUtils isEmptyString:manager.city]) {
            _areaSelectTableView.type=@"1";
        }
    }
    _areaSelectTableView.attachHeight=@"0";
    __weak __typeof(self) weakSelf=self;
    _areaSelectTableView.hiddenBlock = ^{
        weakSelf.imgView1.image=[UIImage imageNamed:@"home_search_down"];
        
        //[weakSelf.citySelectTableView hiddenActionSheet];
        [weakSelf.areaSelectTableView hidden];
        
        _isCitySelected=NO;
    };
    _areaSelectTableView.delegate=self;
    [_areaSelectTableView show];
    
    //创建证书类别选择View
    _certiTypeSelectView=[[DDFindingPeopleCertiTypeSelectView alloc]initWithFrame:CGRectMake(0, 39, Screen_Width, Screen_Height-KNavigationBarHeight-39)];
    _certiTypeSelectView.certiId=_certiId;
    _certiTypeSelectView.majorId=_majorId;
    _certiTypeSelectView.attachHeight=@"0";
    _certiTypeSelectView.hiddenBlock = ^{
        weakSelf.imgView2.image=[UIImage imageNamed:@"home_search_down"];
        
        //[weakSelf.certiTypeSelectView hiddenActionSheet];
        [weakSelf.certiTypeSelectView hidden];
        
        _isCertiTypeSelect=NO;
    };
    _certiTypeSelectView.delegate=self;
    [_certiTypeSelectView show];
}

#pragma mark 创建tableView
-(void)createTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 45+39, Screen_Width, Screen_Height-KNavigationBarHeight-45-39) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=kColorBackGroundColor;
    _tableView.showsVerticalScrollIndicator=YES;
    _tableView.separatorColor=KColorTableSeparator;
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
        DDSearchBuilderAndManagerListModel *model=_dataSourceArr[indexPath.section];
        
        static NSString * cellID = @"DDPersonalCertiClaimListCell";
        DDPersonalCertiClaimListCell * cell = (DDPersonalCertiClaimListCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
        }
        
        [cell loadDataWithModel:model];
         cell.claimBtn.tag=indexPath.section;
        [cell.claimBtn addTarget:self action:@selector(claimBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    else{
        static NSString * cellID = @"DDPersonalCertiClaimListCell";
        DDPersonalCertiClaimListCell * cell = (DDPersonalCertiClaimListCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
        }
        
        
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_areaSelectTableView hidden];
    self.imgView1.image=[UIImage imageNamed:@"home_search_down"];
    _isCitySelected = NO;
    
    [_certiTypeSelectView hidden];
    self.imgView2.image=[UIImage imageNamed:@"home_search_down"];
    _isCertiTypeSelect = NO;
    
    [_dateSelectView hiddenActionSheet];
    self.imgView3.image=[UIImage imageNamed:@"home_search_down"];
    _isDateSelected = NO;
    
    [_contactWaySelectView hiddenActionSheet];
    self.imgView4.image=[UIImage imageNamed:@"home_search_down"];
    _isContactSelected = NO;
    
    if ([DDUtils isEmptyString:[DDUserManager sharedInstance].userid]) {
        [self presentLoginVCWithIndexPath:indexPath];
    }
    else{
        DDSearchBuilderAndManagerListModel *model=_dataSourceArr[indexPath.section];
        
        DDPeopleDetailVC *peopleDetail=[[DDPeopleDetailVC alloc]init];
        peopleDetail.staffInfoId=model.staff_info_id;
        peopleDetail.peopleModel = model;
        peopleDetail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:peopleDetail animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    DDSearchBuilderAndManagerListModel *model=_dataSourceArr[indexPath.section];
    return [DDPersonalCertiClaimListCell heightWithModel:model]+60;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    DDSearchBuilderAndManagerListModel *model=_dataSourceArr[section];
    
    UIView *footerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 45)];
    footerView.backgroundColor=kColorWhite;
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(12, 15, Screen_Width-24, 15)];
    label.text=model.enterprise_name;
    label.textColor=KColorBlackSecondTitle;
    label.font=kFontSize28;
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
    return 45;
}

#pragma mark 点击城市选择
-(void)areaSelectClick{
    if (_isCitySelected==NO) {
        //将证书类别筛选隐藏
        _imgView2.image=[UIImage imageNamed:@"home_search_down"];
        [_certiTypeSelectView hidden];
        _isCertiTypeSelect=NO;
        //将有效期筛选隐藏
        _imgView3.image=[UIImage imageNamed:@"home_search_down"];
        [_dateSelectView hiddenActionSheet];
        _isDateSelected=NO;
        //将联系方式筛选隐藏
        _imgView4.image=[UIImage imageNamed:@"home_search_down"];
        [_contactWaySelectView hiddenActionSheet];
        _isContactSelected=NO;
        
        _imgView1.image=[UIImage imageNamed:@"home_search_up"];
        
        [_areaSelectTableView noHidden];
        [_textField resignFirstResponder];
        
        _isCitySelected=YES;
    }
    else{
        _imgView1.image=[UIImage imageNamed:@"home_search_down"];
        
        //[_citySelectTableView hiddenActionSheet];
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

    [_label1 sizeToFit];
    CGFloat leftWidth=_label1.size.width+4+15;
    if (leftWidth>=(Screen_Width/4-5)) {
        _label1.frame=CGRectMake(5, 12, (Screen_Width/4-9)-15, 15);
        _imgView1.frame=CGRectMake(CGRectGetMaxX(_label1.frame)+4, 12, 15, 15);
    }
    else{
        _label1.frame=CGRectMake((Screen_Width/4-leftWidth)/2, 12, leftWidth-4-15, 15);
        _imgView1.frame=CGRectMake(CGRectGetMaxX(_label1.frame)+4, 12, 15, 15);
    }
    
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

#pragma mark 点击证书类别选择
-(void)certiTypeClick{
    if (_isCertiTypeSelect==NO) {
        //将区域筛选隐藏
        _imgView1.image=[UIImage imageNamed:@"home_search_down"];
        //[_areaSelectTableView hiddenActionSheet];
        [_areaSelectTableView hidden];
        _isCitySelected=NO;
        //将有效期筛选隐藏
        _imgView3.image=[UIImage imageNamed:@"home_search_down"];
        [_dateSelectView hiddenActionSheet];
        _isDateSelected=NO;
        //将联系方式筛选隐藏
        _imgView4.image=[UIImage imageNamed:@"home_search_down"];
        [_contactWaySelectView hiddenActionSheet];
        _isContactSelected=NO;
        
        _imgView2.image=[UIImage imageNamed:@"home_search_up"];
        [_certiTypeSelectView noHidden];
        [_textField resignFirstResponder];
        
        _isCertiTypeSelect=YES;
    }
    else{
        _imgView2.image=[UIImage imageNamed:@"home_search_down"];
        
        [_certiTypeSelectView hidden];
        
        _isCertiTypeSelect=NO;
    }
}

#pragma mark DDFindingPeopleCertiTypeSelectViewDelegate代理回调
-(void)actionsheetDisappear:(DDFindingPeopleCertiTypeSelectView *)actionSheet andCertiStr:(NSString *)certiStr andCertiCode:(NSString *)certiCode andMajorStr:(NSString *)majorStr andMajorCode:(NSString *)majorCode{
    _certiId=certiCode;
    _majorId=majorCode;
    
    CGRect middle1TextFrame = [certiStr boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
    CGFloat middle1Width=middle1TextFrame.size.width+4+15;
    if (middle1Width>=(Screen_Width/4-5)) {
        _label2.frame=CGRectMake(5, 12, (Screen_Width/4-5)-4-15, 15);
        _imgView2.frame=CGRectMake(CGRectGetMaxX(_label2.frame)+4, 12, 15, 15);
    }
    else{
        _label2.frame=CGRectMake((Screen_Width/4-middle1Width)/2, 12, middle1Width-4-15, 15);
        _imgView2.frame=CGRectMake(CGRectGetMaxX(_label2.frame)+4, 12, 15, 15);
    }
    
    _label2.text=certiStr;
    
    if ([DDUtils isEmptyString:_certiId]) {
        _date=@"";
        
        CGRect middle2TextFrame = [@"有效期" boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
        CGFloat middle2Width=middle2TextFrame.size.width+4+15;
        if (middle2Width>=(Screen_Width/4-5)) {
            _label3.frame=CGRectMake(5, 12, (Screen_Width/4-5)-4-15, 15);
            _imgView3.frame=CGRectMake(CGRectGetMaxX(_label3.frame)+4, 12, 15, 15);
        }
        else{
            _label3.frame=CGRectMake((Screen_Width/4-middle2Width)/2, 12, middle2Width-4-15, 15);
            _imgView3.frame=CGRectMake(CGRectGetMaxX(_label3.frame)+4, 12, 15, 15);
        }
        _label3.text=@"有效期";
    }
    
    [self requestData];
}

#pragma mark 点击有效期选择
-(void)dateSelectClick{
    if ([DDUtils isEmptyString:_certiId]) {
        [DDUtils showToastWithMessage:@"为了更精准地查找符合您要求的证书，建议您先选择证书类别"];
    }
    else{
        if (_isDateSelected==NO) {
            //将区域筛选隐藏
            _imgView1.image=[UIImage imageNamed:@"home_search_down"];
            //[_areaSelectTableView hiddenActionSheet];
            [_areaSelectTableView hidden];
            _isCitySelected=NO;
            //将证书类别筛选隐藏
            _imgView2.image=[UIImage imageNamed:@"home_search_down"];
            [_certiTypeSelectView hidden];
            _isCertiTypeSelect=NO;
            //将联系方式筛选隐藏
            _imgView4.image=[UIImage imageNamed:@"home_search_down"];
            [_contactWaySelectView hiddenActionSheet];
            _isContactSelected=NO;
            
            
            _imgView3.image=[UIImage imageNamed:@"home_search_up"];
            
            _dateSelectView=[[DDFindingPeopleDateSelectView alloc]initWithFrame:CGRectMake(0, 39+60, Screen_Width, Screen_Height-KNavigationBarHeight-39-60)];
            _dateSelectView.attachHeight=@"0";
            _dateSelectView.dateCode=_date;
            __weak __typeof(self) weakSelf=self;
            _dateSelectView.hiddenBlock = ^{
                weakSelf.imgView3.image=[UIImage imageNamed:@"home_search_down"];
                
                [weakSelf.dateSelectView hiddenActionSheet];
                
                _isDateSelected=NO;
            };
            _dateSelectView.delegate=self;
            [_dateSelectView show];
            [_textField resignFirstResponder];
            
            _isDateSelected=YES;
        }
        else{
            _imgView3.image=[UIImage imageNamed:@"home_search_down"];
            
            [_dateSelectView hiddenActionSheet];
            
            _isDateSelected=NO;
        }
    }
}

#pragma mark DDFindingPeopleDateSelectViewDelegate代理回调
-(void)actionsheetDisappear:(DDFindingPeopleDateSelectView *)actionSheet andDateStr:(NSString *)dateStr andDateCode:(NSString *)dateCode{
    _date=dateCode;
    
    CGRect middle2TextFrame = [dateStr boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
    CGFloat middle2Width=middle2TextFrame.size.width+4+15;
    if (middle2Width>=(Screen_Width/4-5)) {
        _label3.frame=CGRectMake(5, 12, (Screen_Width/4-5)-4-15, 15);
        _imgView3.frame=CGRectMake(CGRectGetMaxX(_label3.frame)+4, 12, 15, 15);
    }
    else{
        _label3.frame=CGRectMake((Screen_Width/4-middle2Width)/2, 12, middle2Width-4-15, 15);
        _imgView3.frame=CGRectMake(CGRectGetMaxX(_label3.frame)+4, 12, 15, 15);
    }
    
    _label3.text=dateStr;
    
    [self requestData];
}

#pragma mark 点击联系方式选择
-(void)contactWayClick{
    if (_isContactSelected==NO) {
        //将区域筛选隐藏
        _imgView1.image=[UIImage imageNamed:@"home_search_down"];
        //[_areaSelectTableView hiddenActionSheet];
        [_areaSelectTableView hidden];
        _isCitySelected=NO;
        //将证书类别筛选隐藏
        _imgView2.image=[UIImage imageNamed:@"home_search_down"];
        [_certiTypeSelectView hidden];
        _isCertiTypeSelect=NO;
        //将有效期筛选隐藏
        _imgView3.image=[UIImage imageNamed:@"home_search_down"];
        [_dateSelectView hiddenActionSheet];
        _isDateSelected=NO;
        
        
        _imgView4.image=[UIImage imageNamed:@"home_search_up"];
        
        _contactWaySelectView=[[DDFindingPeopleContactWaySelectView alloc]initWithFrame:CGRectMake(0, 39+60, Screen_Width, Screen_Height-KNavigationBarHeight-39-60)];
        _contactWaySelectView.attachHeight=@"0";
        _contactWaySelectView.wayCode=_contactId;
        __weak __typeof(self) weakSelf=self;
        _contactWaySelectView.hiddenBlock = ^{
            weakSelf.imgView4.image=[UIImage imageNamed:@"home_search_down"];
            
            [weakSelf.contactWaySelectView hiddenActionSheet];
            
            _isContactSelected=NO;
        };
        _contactWaySelectView.delegate=self;
        [_contactWaySelectView show];
        [_textField resignFirstResponder];
        
        _isContactSelected=YES;
    }
    else{
        _imgView4.image=[UIImage imageNamed:@"home_search_down"];
        
        [_contactWaySelectView hiddenActionSheet];
        
        _isContactSelected=NO;
    }
}

#pragma mark DDFindingPeopleContactWaySelectViewDelegate代理回调
-(void)actionsheetDisappear:(DDFindingPeopleContactWaySelectView *)actionSheet andWayStr:(NSString *)wayStr andWayCode:(NSString *)wayCode{
    _contactId=wayCode;
    
    CGRect rightTextFrame = [wayStr boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
    CGFloat rightWidth=rightTextFrame.size.width+4+15;
    if (rightWidth>=(Screen_Width/4-5)) {
        _label4.frame=CGRectMake(5, 12, (Screen_Width/4-5)-4-15, 15);
        _imgView4.frame=CGRectMake(CGRectGetMaxX(_label4.frame)+4, 12, 15, 15);
    }
    else{
        _label4.frame=CGRectMake((Screen_Width/4-rightWidth)/2, 12, rightWidth-4-15, 15);
        _imgView4.frame=CGRectMake(CGRectGetMaxX(_label4.frame)+4, 12, 15, 15);
    }
    
    _label4.text=wayStr;
    
    [self requestData];
}

#pragma mark 弹出登录注册页面
- (void)presentLoginVCWithIndexPath:(NSIndexPath *)indexPath{
    DDLoginCheckVC * vc = [[DDLoginCheckVC alloc] init];
    vc.loginSuccessBlock = ^{
        //__weak __typeof(self) weakSelf=self;
        //[weakSelf requestTypesData];
        
        DDSearchBuilderAndManagerListModel *model=_dataSourceArr[indexPath.section];
        
        DDPeopleDetailVC *peopleDetail=[[DDPeopleDetailVC alloc]init];
        peopleDetail.staffInfoId=model.staff_info_id;
        [self.navigationController pushViewController:peopleDetail animated:YES];
    };
    
    
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [DDNavigationUtil setNavigationAndBottomLineWhiteColor:nav];
    [self showViewController:nav sender:nil];
}

#pragma mark 弹出登录注册页面
- (void)presentLoginVCWithSender:(UIButton *)sender{
    DDLoginCheckVC * vc = [[DDLoginCheckVC alloc] init];
    vc.loginSuccessBlock = ^{
        DDSearchBuilderAndManagerListModel *model=_dataSourceArr[sender.tag-150];
        DDCompanyDetailVC *companyDetailVC=[[DDCompanyDetailVC alloc]init];
        companyDetailVC.enterpriseId=model.enterprise_id;
        [self.navigationController pushViewController:companyDetailVC animated:YES];
    };
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [DDNavigationUtil setNavigationAndBottomLineWhiteColor:nav];
    [self showViewController:nav sender:nil];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [_textField resignFirstResponder];
}

#pragma mark 认领点击事件
-(void)claimBtnClick:(UIButton *)sender{
    DDSearchBuilderAndManagerListModel *model=_dataSourceArr[sender.tag];
    DDPersonalIdentityCheckVC *check=[[DDPersonalIdentityCheckVC alloc]init];
    check.identityCheckType = DDIdentityCheckTypeHomeList;
    check.model = model;
    [self.navigationController pushViewController:check animated:YES];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:KRefreshUI object:nil];
}
@end
