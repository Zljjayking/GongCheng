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
#import "DDLoginCheckVC.h"//登录注册页面
#import "DataLoadingView.h"//加载页面
#import "DDNoResultView.h"//无数据视图
#import "DDSearchSafeCertiListCell.h"//cell
#import "DDSafePermissionVC.h"//安许证详情页面
#import "CitySelectTableView.h"//城市选择
#import "DDSafeCertiStatusView.h"//安许证状态筛选页面
#import "DDSearchSafeCertiListModel.h"//model
#import "DDSearchHistoryDAOAndDB.h"//搜索历史数据库操作类
#import "DDPeopleDetailVC.h"//人员详情页面
#import "DDUMengEventDefines.h"

@interface DDSearchSafeCertiListVC ()<UITableViewDelegate,UITableViewDataSource,CitySelectTableViewDelegate,DDSafeCertiStatusViewDelegate,UITextFieldDelegate>

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
        BOOL _isStatusSelected;//判断是否点开了状态筛选视图
        
        NSString *_statusStr;//状态
        NSString *_region;//地区筛选
    }
    @property (nonatomic,strong) DataLoadingView *loadingView;
    @property (nonatomic,strong) UITableView *tableView;
    @property (nonatomic,strong) DDNoResultView *noResultView;//无数据视图
    @property (nonatomic,strong) UIImageView *imgView1;//放左边那个城市选择小箭头
    @property (nonatomic,strong) CitySelectTableView *citySelectTableView;//区域筛选视图
    @property (nonatomic,strong) UIImageView *imgView2;//放右边那个状态选择小箭头
    @property (nonatomic,strong) DDSafeCertiStatusView *safeCertiStatusView;//状态筛选视图
    
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
    
//    if ([self.menuId isEqualToString:@"6"]) {//查企业
//        [MobClick event:main_chaqiye];
//    }
//    else if([self.menuId isEqualToString:@"16"]){//查资质
//        [MobClick event:main_chaziyuan];
//    }
//    else{
//        [MobClick event:main_anxuzheng];
//    }
    self.view.backgroundColor=kColorBackGroundColor;
    _statusStr=@"";
    _region=@"";
    _isCitySelected=NO;
    _isStatusSelected=NO;
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
    [_safeCertiStatusView hiddenActionSheet];
    [self.navigationController popViewControllerAnimated:NO];
}
    
-(void)viewDidDisappear:(BOOL)animated{
    if (self.navigationController==NULL) {
        [_citySelectTableView hiddenActionSheet];
        [_safeCertiStatusView hiddenActionSheet];
    }
    else{
        _imgView1.image=[UIImage imageNamed:@"home_search_down"];
        [_citySelectTableView hidden];
        _isCitySelected=NO;
        _imgView2.image=[UIImage imageNamed:@"home_search_down"];
        [_safeCertiStatusView hiddenActionSheet];
        _isStatusSelected=NO;
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
    [params setValue:_statusStr forKey:@"status"];
    [params setValue:[NSString stringWithFormat:@"%ld",currentPage] forKey:@"page"];
    [params setValue:@"10" forKey:@"rows"];
    
    
    [[DDHttpManager sharedInstance]sendPostRequest:KHttpRequest_queryHighLightList params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"**********安许证搜索结果数据***************%@",responseObject);
        
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
                        DDSearchSafeCertiListModel *model = [[DDSearchSafeCertiListModel alloc]initWithDictionary:dic error:nil];
                        
                        
                        if (![DDUtils isEmptyString:model.unitName]) {
                            NSString *titleStr=[NSString stringWithFormat:@"<font color='#111111'>%@</font>",model.unitName];
                            NSAttributedString *unitName = [[NSAttributedString alloc] initWithData:[titleStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
                            model.unitNameAttriStr=unitName;
                        }
                        
                        
                        
                        if (![DDUtils isEmptyString:model.legalRepresentative]) {
                            NSString *nameStr=[NSString stringWithFormat:@"<font color='#3196fc' size='4'>%@</font>",model.legalRepresentative];
                            NSAttributedString *peopleString = [[NSAttributedString alloc] initWithData:[nameStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
                            model.peopleAttriString=peopleString;
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
                    [_noResultView showNoResultViewWithTitle:@"安许证信息" andImage:@"noResult_company"];
                }
            }
            else{
                [_noResultView showNoResultViewWithTitle:@"安许证信息" andImage:@"noResult_company"];
            }
        }
        else{
            [_noResultView showNoResultViewWithTitle:@"安许证信息" andImage:@"noResult_company"];
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
    [params setValue:_statusStr forKey:@"status"];
    [params setValue:[NSString stringWithFormat:@"%ld",currentPage] forKey:@"page"];
    [params setValue:@"10" forKey:@"rows"];
    
    
    [[DDHttpManager sharedInstance]sendPostRequest:KHttpRequest_queryHighLightList params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"**********安许证搜索结果数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        __weak __typeof(self) weakSelf = self;
        if (response.isSuccess) {
            if (![response isEmpty]) {
                _dict = responseObject[KData];
                NSArray *listArr = _dict[@"result"];
                for (NSDictionary *dic in listArr) {
                    DDSearchSafeCertiListModel *model = [[DDSearchSafeCertiListModel alloc]initWithDictionary:dic error:nil];
                    
                    
                    if (![DDUtils isEmptyString:model.unitName]) {
                        NSString *titleStr=[NSString stringWithFormat:@"<font color='#111111'>%@</font>",model.unitName];
                        NSAttributedString *unitName = [[NSAttributedString alloc] initWithData:[titleStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
                        model.unitNameAttriStr=unitName;
                    }
                    
                    if (![DDUtils isEmptyString:model.legalRepresentative]) {
                        NSString *nameStr=[NSString stringWithFormat:@"<font color='#3196fc' size='4'>%@</font>",model.legalRepresentative];
                        NSAttributedString *peopleString = [[NSAttributedString alloc] initWithData:[nameStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
                        model.peopleAttriString=peopleString;
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
    
    
    UIButton *typeAndLevelBtn=[[UIButton alloc]initWithFrame:CGRectMake(Screen_Width/2, 0, Screen_Width/2, 39)];
    [typeAndLevelBtn setBackgroundColor:kColorWhite];
    
    _label2=[[UILabel alloc]init];
    _label2.text=@"状态";
    _label2.textColor=KColorBlackTitle;
    _label2.font=kFontSize30;
    [typeAndLevelBtn addSubview:_label2];
    
    _imgView2=[[UIImageView alloc]init];
    _imgView2.contentMode = UIViewContentModeScaleAspectFit;
    _imgView2.image=[UIImage imageNamed:@"home_search_down"];
    [typeAndLevelBtn addSubview:_imgView2];
    [typeAndLevelBtn addTarget:self action:@selector(typeAndLevelClick) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect rightTextFrame = [@"状态" boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
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
    _numLabel.textColor=KColorBlackTitle;
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
        DDSearchSafeCertiListModel *model=_dataSourceArr[indexPath.section];
        
        static NSString * cellID = @"DDSearchSafeCertiListCell";
        DDSearchSafeCertiListCell * cell = (DDSearchSafeCertiListCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
        }
        
        [cell loadDataWithModel:model];
        
        if (![DDUtils isEmptyString:model.legalRepresentative]) {
            cell.peopleBtn.userInteractionEnabled=YES;
            cell.peopleBtn.tag=indexPath.section;
            [cell.peopleBtn addTarget:self action:@selector(peopleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        else{
            cell.peopleBtn.userInteractionEnabled=NO;
        }
        
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    else{
        static NSString * cellID = @"DDSearchSafeCertiListCell";
        DDSearchSafeCertiListCell * cell = (DDSearchSafeCertiListCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
        }
        
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    
}
    
    //点击跳转到人员详情页面
-(void)peopleBtnClick:(UIButton *)sender{
    _imgView1.image=[UIImage imageNamed:@"home_search_down"];
    [_citySelectTableView hidden];
    _isCitySelected=NO;
    _imgView2.image=[UIImage imageNamed:@"home_search_down"];
    [_safeCertiStatusView hiddenActionSheet];
    _isStatusSelected=NO;
    if ([DDUtils isEmptyString:[DDUserManager sharedInstance].userid]) {
        [self presentLoginVCWithSender:sender];
    }
    else{
        DDSearchSafeCertiListModel *model=_dataSourceArr[sender.tag];
        
        DDPeopleDetailVC *peopleDetail=[[DDPeopleDetailVC alloc]init];
        peopleDetail.staffInfoId=model.staffInfoId;
        [self.navigationController pushViewController:peopleDetail animated:YES];
    }
}
    
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _imgView1.image=[UIImage imageNamed:@"home_search_down"];
    [_citySelectTableView hidden];
    _isCitySelected=NO;
    _imgView2.image=[UIImage imageNamed:@"home_search_down"];
    [_safeCertiStatusView hiddenActionSheet];
    _isStatusSelected=NO;
    if ([DDUtils isEmptyString:[DDUserManager sharedInstance].userid]) {
        [self presentLoginVCWithIndexPath:indexPath];
    }
    else{
        DDSearchSafeCertiListModel *model=_dataSourceArr[indexPath.section];
        //此时需要存数据库了
        //存最近搜索
        [DDSearchHistoryDAOAndDB insertRecentSearchByTypeId:self.menuId andSearchText:self.searchText];
        //存浏览历史
        NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithData:[model.unitName dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        [DDSearchHistoryDAOAndDB insertHistorySearchByTypeId:self.menuId andSearchResult:[DDUtils transformAttributedText:attributeStr] andGlobalType:nil andTransId:model.enterpriseId];
        
        DDSafePermissionVC *safeCertiDetail=[[DDSafePermissionVC alloc]init];
        safeCertiDetail.enterpriseId=model.enterpriseId;
        [self.navigationController pushViewController:safeCertiDetail animated:YES];
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
        //将类别筛选隐藏
        _imgView2.image=[UIImage imageNamed:@"home_search_down"];
        [_safeCertiStatusView hiddenActionSheet];
        _isStatusSelected=NO;
        
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
    
#pragma mark 点击状态选择
-(void)typeAndLevelClick{
    if (_isStatusSelected==NO) {
        //将区域筛选隐藏
        _imgView1.image=[UIImage imageNamed:@"home_search_down"];
        [_citySelectTableView hidden];
        _isCitySelected=NO;
        
        
        _imgView2.image=[UIImage imageNamed:@"home_search_up"];
        
        _safeCertiStatusView=[[DDSafeCertiStatusView alloc]initWithFrame:CGRectMake(0, 39+60, Screen_Width, Screen_Height-KNavigationBarHeight-39-60)];
        _safeCertiStatusView.attachHeight=@"0";
        _safeCertiStatusView.statusStr=_statusStr;
        __weak __typeof(self) weakSelf=self;
        _safeCertiStatusView.hiddenBlock = ^{
            weakSelf.imgView2.image=[UIImage imageNamed:@"home_search_down"];
            
            [weakSelf.safeCertiStatusView hiddenActionSheet];
            
            _isStatusSelected=NO;
        };
        _safeCertiStatusView.delegate=self;
        [_safeCertiStatusView show];
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        
        _isStatusSelected=YES;
    }
    else{
        _imgView2.image=[UIImage imageNamed:@"home_search_down"];
        
        [_safeCertiStatusView hiddenActionSheet];
        
        _isStatusSelected=NO;
    }
}
    
#pragma mark DDSafeCertiStatusViewDelegate代理回调
- (void)actionsheetDisappear:(DDSafeCertiStatusView *)actionSheet andStatusStr:(NSString *)statusStr{
    _statusStr=statusStr;
    
    NSString *tempStr;
    if ([statusStr isEqualToString:@""]) {
        tempStr=@"全部";
    }
    else{
        tempStr=statusStr;
    }
    
    CGRect rightTextFrame = [tempStr boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
    CGFloat rightWidth=rightTextFrame.size.width+4+15;
    if (rightWidth>=(Screen_Width/2-40)) {
        _label2.frame=CGRectMake(20, 12, (Screen_Width/2-40)-4-15, 15);
        _imgView2.frame=CGRectMake(CGRectGetMaxX(_label2.frame)+4, 12, 15, 15);
    }
    else{
        _label2.frame=CGRectMake((Screen_Width/2-rightWidth)/2, 12, rightWidth-4-15, 15);
        _imgView2.frame=CGRectMake(CGRectGetMaxX(_label2.frame)+4, 12, 15, 15);
    }
    
    _label2.text=tempStr;

    [self requestData];
}
    
#pragma mark 弹出登录注册页面
- (void)presentLoginVCWithIndexPath:(NSIndexPath *)indexPath{
    DDLoginCheckVC * vc = [[DDLoginCheckVC alloc] init];
    vc.loginSuccessBlock = ^{
        //__weak __typeof(self) weakSelf=self;
        //[weakSelf requestData];
        
        DDSearchSafeCertiListModel *model=_dataSourceArr[indexPath.section];
        //此时需要存数据库了
        //存最近搜索
        [DDSearchHistoryDAOAndDB insertRecentSearchByTypeId:self.menuId andSearchText:self.searchText];
        //存浏览历史
        NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithData:[model.unitName dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        [DDSearchHistoryDAOAndDB insertHistorySearchByTypeId:self.menuId andSearchResult:[DDUtils transformAttributedText:attributeStr] andGlobalType:nil andTransId:model.enterpriseId];
        
        DDSafePermissionVC *safeCertiDetail=[[DDSafePermissionVC alloc]init];
        safeCertiDetail.enterpriseId=model.enterpriseId;
        [self.navigationController pushViewController:safeCertiDetail animated:YES];
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
        
        DDSearchSafeCertiListModel *model=_dataSourceArr[sender.tag];
        
        DDPeopleDetailVC *peopleDetail=[[DDPeopleDetailVC alloc]init];
        peopleDetail.staffInfoId=model.staffInfoId;
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
