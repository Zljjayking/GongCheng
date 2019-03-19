//
//  DDCompanyListVC.m
//  GongChengDD
//
//  Created by xzx on 2018/5/17.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDCompanyListVC.h"
#import "MJRefresh.h"
#import "DDNavigationUtil.h"
#import "DDLoginCheckVC.h"//登录注册页面
#import "DataLoadingView.h"//加载页面
#import "DDNoResultView.h"//无数据视图
#import "DDCompanyList2Cell.h"//cell
#import "DDCompanyDetailVC.h"//公司详情页面
#import "DDAreaSelectTableView.h"//市的选择View
#import "DDCertiTypeSelectVC.h"//资质类别及等级页面
#import "DDSearchCompanyListModel.h"//model
#import "DDSearchHistoryDAOAndDB.h"//搜索历史数据库操作类
#import "DDPeopleDetailVC.h"//人员详情页面
#import "DDUMengEventDefines.h"

@interface DDCompanyListVC ()<UITableViewDelegate,UITableViewDataSource,AreaSelectTableViewDelegate,DDCertiTypeSelectDelegate>

{
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
    
    NSString *_certTypeLevels;//资质筛选等级
    NSString *_region;//地区筛选
    
    NSInteger _section;//组数，记录资质等级筛选
    NSInteger _rows;//行数，记录资质等级筛选
}
@property (nonatomic,strong) DataLoadingView *loadingView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) DDNoResultView *noResultView;//无数据视图
@property (nonatomic,strong) UIImageView *imgView1;//放左边那个城市选择小箭头
@property (nonatomic,strong) DDAreaSelectTableView *citySelectTableView;//区域筛选视图
@property (nonatomic,copy) NSString *certTypeId;//资质id
@property (nonatomic,copy) NSString *certTypeCode;//资质级别code
@property (nonatomic,strong)DDCertiAndLevelModel * selectCertiModel;//记录选择到的资质,用来传值让子页面高亮,

@end

@implementation DDCompanyListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [MobClick event:search_company];
    self.view.backgroundColor=kColorWhite;
    _certTypeLevels=@"";
    _region=@"";
    _isCitySelected=NO;
    _dataSourceArr=[[NSMutableArray alloc]init];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveNotice:) name:@"globalSearchNotice" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveHiddenActionView) name:@"hiddenActionView" object:nil];
    [self createChooseBtns];
    [self createTableView];
    [self createLoadView];
}

//收到全局搜索文字的改变
-(void)receiveNotice:(NSNotification *)notice{
    _imgView1.image=[UIImage imageNamed:@"home_search_down"];
    [_citySelectTableView hidden];
    _isCitySelected=NO;
}

//收弹出视图
-(void)receiveHiddenActionView{
    _imgView1.image=[UIImage imageNamed:@"home_search_down"];
    [_citySelectTableView hidden];
    _isCitySelected=NO;
}

#pragma mark 创建加载视图
-(void)createLoadView{
    __weak __typeof(self) weakSelf=self;
    _noResultView=[[DDNoResultView alloc]initWithFrame:CGRectMake(0, 39, Screen_Width, Screen_Height-KNavigationBarHeight-39-60)];
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
    [params setValue:@"51" forKey:@"searchType"];
    [params setValue:_region forKey:@"region"];
    [params setValue:_certTypeId forKey:@"certTypeLevels"];//资质ID
    [params setValue:_certTypeCode forKey:@"level"];//资质等级code
    [params setValue:[NSString stringWithFormat:@"%ld",currentPage] forKey:@"page"];
    [params setValue:@"10" forKey:@"rows"];
    
    [[DDHttpManager sharedInstance]sendPostRequest:KHttpRequest_queryHighLightList params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"**********公司搜索结果数据***************%@",responseObject);

        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        __weak __typeof(self) weakSelf = self;
        [_loadingView hiddenLoadingView];
        if (response.isSuccess) {
            if (![response isEmpty]) {
                //[_dataSourceArr removeAllObjects];
                [_loadingView hiddenLoadingView];
                _dict = responseObject[KData];
                pageCount = [_dict[@"numFound"] integerValue];
                if (pageCount>0) {
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
                    }else{
                        [_noResultView showNoResultViewWithTitle:@"企业" andImage:@"noResult_company"];
                    }
                }
                else{
                    [_noResultView showNoResultViewWithTitle:@"企业" andImage:@"noResult_company"];
                }
            }
            else{
                [_noResultView showNoResultViewWithTitle:@"企业" andImage:@"noResult_company"];
            }
        }
        else{
           [_noResultView showNoResultViewWithTitle:@"企业" andImage:@"noResult_company"];
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
    [params setValue:@"51" forKey:@"searchType"];
    [params setValue:_region forKey:@"region"];
    [params setValue:_certTypeId forKey:@"certTypeLevels"];//资质ID
    [params setValue:_certTypeCode forKey:@"level"];//资质等级code
    [params setValue:[NSString stringWithFormat:@"%ld",currentPage] forKey:@"page"];
    [params setValue:@"10" forKey:@"rows"];
    
    
    [[DDHttpManager sharedInstance]sendPostRequest:KHttpRequest_queryHighLightList params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        //NSLog(@"**********公司搜索结果数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        __weak __typeof(self) weakSelf = self;
        if (response.isSuccess) {
            if (![response isEmpty]) {
                _dict = responseObject[KData];
                NSArray *listArr = _dict[@"result"];
                for (NSDictionary *dic in listArr) {
                    DDSearchCompanyListModel *model = [[DDSearchCompanyListModel alloc]initWithDictionary:dic error:nil];
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
    if (leftWidth>=(Screen_Width/2-5)) {
        _label1.frame=CGRectMake(5, 12, (Screen_Width/2-5)-4-15, 15);
        _imgView1.frame=CGRectMake(CGRectGetMaxX(_label1.frame)+4, 12, 15, 15);
    }
    else{
        _label1.frame=CGRectMake((Screen_Width/2-leftWidth)/2, 12, leftWidth-4-15, 15);
        _imgView1.frame=CGRectMake(CGRectGetMaxX(_label1.frame)+4, 12, 15, 15);
    }
    
    [self.view addSubview:areaSelectBtn];
    
    UILabel *lineL = [[UILabel alloc]initWithFrame:CGRectMake(Screen_Width/2, 12, 0.5, 15)];
    lineL.backgroundColor = KColorGreyLight;
    [self.view addSubview:lineL];
    
    UIButton *typeAndLevelBtn=[[UIButton alloc]initWithFrame:CGRectMake(Screen_Width/2+0.5, 0, Screen_Width/2-0.5, 39)];
    [typeAndLevelBtn setBackgroundColor:kColorWhite];
    
    _label2=[[UILabel alloc]init];
    _label2.text=@"资质类别";
    _label2.textColor=KColorBlackTitle;
    _label2.font=kFontSize30;
    [typeAndLevelBtn addSubview:_label2];
    
    _imgView2=[[UIImageView alloc]init];
    _imgView2.contentMode = UIViewContentModeScaleAspectFit;
    _imgView2.image=[UIImage imageNamed:@"home_search_down"];
    [typeAndLevelBtn addSubview:_imgView2];
    [typeAndLevelBtn addTarget:self action:@selector(typeAndLevelClick) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect rightTextFrame = [@"资质类别" boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
    CGFloat rightWidth=rightTextFrame.size.width+4+15;
    if (rightWidth>=(Screen_Width/2-5)) {
        _label2.frame=CGRectMake(5, 12, (Screen_Width/2-5)-4-15, 15);
        _imgView2.frame=CGRectMake(CGRectGetMaxX(_label2.frame)+4, 12, 15, 15);
    }
    else{
        _label2.frame=CGRectMake((Screen_Width/2-rightWidth)/2, 12, rightWidth-4-15, 15);
        _imgView2.frame=CGRectMake(CGRectGetMaxX(_label2.frame)+4, 12, 15, 15);
    }
    
    [self.view addSubview:typeAndLevelBtn];
    
    
    UIView *summaryView=[[UIView alloc]initWithFrame:CGRectMake(0, 39, Screen_Width, 45)];
    summaryView.backgroundColor = kColorBackGroundColor;
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
    _rightLab.text=@"家企业";
    _rightLab.textColor=KColorGreySubTitle;
    _rightLab.font=kFontSize26;
    [summaryView addSubview:_rightLab];
    
}

#pragma mark 创建tableView
-(void)createTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 39+45, Screen_Width, Screen_Height-KNavigationBarHeight-39-45-60) style:UITableViewStyleGrouped];
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
        [weakSelf requestData];
    }];
    
    _citySelectTableView=[[DDAreaSelectTableView alloc]initWithFrame:CGRectMake(0, 39*2, Screen_Width, Screen_Height-KNavigationBarHeight-39) AndInSubViews:self.view];
    _citySelectTableView.isNeedArea = YES;
    _citySelectTableView.attachHeight=@"60";
    _citySelectTableView.hiddenBlock = ^{
        weakSelf.imgView1.image=[UIImage imageNamed:@"home_search_down"];
        [weakSelf.citySelectTableView hidden];
        _isCitySelected=NO;
    };
    _citySelectTableView.delegate=self;
    [_citySelectTableView showInTableView];
}

#pragma mark tableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataSourceArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DDSearchCompanyListModel *model=_dataSourceArr[indexPath.section];
    
    static NSString * cellID = @"DDCompanyList2Cell";
    DDCompanyList2Cell * cell = (DDCompanyList2Cell*)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
    }
    
    [cell loadDataWithModel:model];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _imgView1.image=[UIImage imageNamed:@"home_search_down"];
    [_citySelectTableView hidden];
    _isCitySelected=NO;
    DDSearchCompanyListModel *model=_dataSourceArr[indexPath.section];
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [params setValue:_searchText forKey:@"searchTitle"];
    [params setValue:model.unitName forKey:@"searchContent"];
    [params setValue:model.enterpriseId forKey:@"enterpriseId"];
    [params setValue:@"51" forKey:@"searchType"];
    
    NSString *provice;
    NSString *city;
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status){
        //定位不能用
        provice=@"江苏省";
        city=@"南京市";
    }
    else{
        //定位功能可用
        //如果保存有定位到的省,首先使用保存的,没有的话,默认江苏省
        DDUserManager *manager=[DDUserManager sharedInstance];
        if (![DDUtils isEmptyString:manager.province]) {
            provice=manager.province;
            city=manager.city;
        }
        else{
            provice=@"江苏省";
            city=@"南京市";
        }
    }
    NSString *regionName=[NSString stringWithFormat:@"%@,%@",provice,city];
    [params setValue:regionName forKey:@"regionName"];
    
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
    
    //此时需要存数据库了
    //存最近搜索
    [DDSearchHistoryDAOAndDB insertRecentSearchByTypeId:@"9909" andSearchText:self.searchText];
    //存浏览历史
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithData:[model.unitName dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    [DDSearchHistoryDAOAndDB insertHistorySearchByTypeId:@"9909" andSearchResult:[DDUtils transformAttributedText:attributeStr] andGlobalType:@"0" andTransId:model.enterpriseId];
    
    DDCompanyDetailVC *companyDetail=[[DDCompanyDetailVC alloc]init];
    companyDetail.enterpriseId=model.enterpriseId;
    [self.mainViewContoller.navigationController pushViewController:companyDetail animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    DDSearchCompanyListModel *model=_dataSourceArr[indexPath.section];
    NSAttributedString *attributedString=model.unitNameAttriStr;
    NSString *nameStr=[attributedString string];
    if(![DDUtils isEmptyString:[NSString stringWithFormat:@"%@",nameStr]]){
        CGSize labelSize = [[NSString stringWithFormat:@"%@",nameStr] boundingRectWithSize:CGSizeMake(Screen_Width-66, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:kFontSize34} context:nil].size;
            return  labelSize.height+141;
    }else{
        return 162;
    }
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
    _imgView1.image=[UIImage imageNamed:@"home_search_down"];
    [_citySelectTableView hidden];
    _isCitySelected=NO;
    DDSearchCompanyListModel *model=_dataSourceArr[sender.tag-150];
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [params setValue:_searchText forKey:@"searchTitle"];
    [params setValue:model.unitName forKey:@"searchContent"];
    [params setValue:model.enterpriseId forKey:@"enterpriseId"];
    [params setValue:@"51" forKey:@"searchType"];
    
    NSString *provice;
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status){
        //定位不能用
        provice=@"江苏省";
    }
    else{
        //定位功能可用
        //如果保存有定位到的省,首先使用保存的,没有的话,默认江苏省
        DDUserManager *manager=[DDUserManager sharedInstance];
        if (![DDUtils isEmptyString:manager.province]) {
            provice=manager.province;
        }
        else{
            provice=@"江苏省";
        }
    }
    [params setValue:provice forKey:@"regionName"];
    
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
    
    //此时需要存数据库了
    //存最近搜索
    [DDSearchHistoryDAOAndDB insertRecentSearchByTypeId:@"9909" andSearchText:self.searchText];
    //存浏览历史
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithData:[model.unitName dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    [DDSearchHistoryDAOAndDB insertHistorySearchByTypeId:@"9909" andSearchResult:[DDUtils transformAttributedText:attributeStr] andGlobalType:@"0" andTransId:model.enterpriseId];
    
    DDCompanyDetailVC *companyDetail=[[DDCompanyDetailVC alloc]init];
    companyDetail.enterpriseId=model.enterpriseId;
    [self.mainViewContoller.navigationController pushViewController:companyDetail animated:YES];
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
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        _isCitySelected=YES;
        [self.view bringSubviewToFront:_citySelectTableView];
    }
    else{
        _imgView1.image=[UIImage imageNamed:@"home_search_down"];
        [_citySelectTableView hidden];
        _isCitySelected=NO;
    }
}

#pragma mark AreaSelectTableViewDelegate代理回调
-(void)actionsheetDisappear:(DDAreaSelectTableView *)actionSheet andAreaInfo:(NSString *)area{
    _label1.text=area;
    if ([area containsString:@"直辖县"]) {
        NSRange range = [area rangeOfString:@","];
        NSString *regionStr=[area substringFromIndex:(range.location+1)];
        _label1.text=regionStr;
    }
    [_label1 sizeToFit];
    if (_label1.frameWidth>130) {
        _label1.frameWidth = 130;
    }
    _label1.frame=CGRectMake(Screen_Width/4-_label1.frameWidth/2-9.5, 12, _label1.frameWidth, 15);
    _label1.textAlignment = NSTextAlignmentCenter;
    _imgView1.frame=CGRectMake(CGRectGetMaxX(_label1.frame)+4, 12, 15, 15);
    
    NSString *areaStr=area;
    if ([areaStr containsString:@"全省"]) {
        areaStr=[areaStr stringByReplacingOccurrencesOfString:@"全省" withString:@""];
    }
    else if ([areaStr containsString:@"市全市"]) {
        areaStr=[areaStr stringByReplacingOccurrencesOfString:@"市全市" withString:@""];
    }
    else if ([areaStr containsString:@"全区"]) {
        areaStr=[areaStr stringByReplacingOccurrencesOfString:@"全区" withString:@""];
    }else if ([areaStr containsString:@"北京市"] || [areaStr containsString:@"天津市"] || [areaStr containsString:@"上海市"]) {
        areaStr=[areaStr stringByReplacingOccurrencesOfString:@"市" withString:@""];
    }else if ([areaStr isEqualToString:@"全国"]) {
        areaStr=@"";
    }
    _region=areaStr;
    [self requestData];
}

#pragma mark 点击资质类别选择
-(void)typeAndLevelClick{
    _imgView1.image=[UIImage imageNamed:@"home_search_down"];
    [_citySelectTableView hidden];
    _isCitySelected=NO;
    
    DDCertiTypeSelectVC *certiAndLevel= [[DDCertiTypeSelectVC alloc] init];
    certiAndLevel.delegate = self;
    certiAndLevel.certiType=_certTypeLevels;
    certiAndLevel.section=_section;
    certiAndLevel.rows=_rows;
    certiAndLevel.passValueModel = _selectCertiModel;
    certiAndLevel.hidesBottomBarWhenPushed=YES;
    [self.mainViewContoller.navigationController pushViewController:certiAndLevel animated:YES];
}

#pragma mark DDCertiTypeSelectDelegate代理回调
//选择了资质类别和等级(带模型)
-(void)certiAndLevelSelect:(DDCertiTypeSelectVC *)certiSelectVC andCertiStr:(NSString *)certiStr andSection:(NSInteger)section andRows:(NSInteger)rows certiAndLevelModel:(DDCertiAndLevelModel *)certiAndLevelModel codeModel:(DDCodeModel *)codeModel{
    NSLog(@"选择资质类别及等级 %@  %ld  %ld ",certiStr,section,rows);
    
    _certTypeLevels=certiStr;
    _section=section;
    _rows=rows;
    
    NSString *tempStr = certiStr;
    //建筑业资质  22 ；  电力承装承修  23；勘察资质  24；设计资质 25；监理资质  26；招标代理 27；造价咨询 28；
    if ([tempStr isEqualToString:@"22"]) {
        tempStr = @"建筑业资质";
    }
    else if([tempStr isEqualToString:@"23"]){
        tempStr = @"承装(修、试)电力设施许可证";
    }
    else if([tempStr isEqualToString:@"24"]){
        tempStr = @"勘察资质";
    }
    else if([tempStr isEqualToString:@"25"]){
        tempStr = @"设计资质";
    }
    else if([tempStr isEqualToString:@"26"]){
        tempStr = @"监理资质";
    }
    else if([tempStr isEqualToString:@"27"]){
        tempStr = @"招标代理机构";
    }
    else if([tempStr isEqualToString:@"28"]){
        tempStr = @"造价咨询企业";
    }
    else if([tempStr isEqualToString:@"29"]){
        tempStr = @"设计与施工一体化";
    }
    else if([tempStr isEqualToString:@"21"]){
        tempStr = @"消防技术服务机构";
    }else if([tempStr isEqualToString:@"51"]){
        tempStr = @"信息系统集成及服务资质";
    }else if([tempStr isEqualToString:@"52"]){
        tempStr = @"安防工程相关资质";
    }else if([tempStr isEqualToString:@"53"]){
        tempStr = @"信息通信建设服务能力资质";
    }else if([tempStr isEqualToString:@"54"]){
        tempStr = @"园林绿化资质";
    }
    else if([tempStr isEqualToString:@""]){
        tempStr = @"全部";
    }
    
    CGRect rightTextFrame = [tempStr boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
    CGFloat rightWidth=rightTextFrame.size.width+4+15;
    if (rightWidth>=(Screen_Width/2-5)) {
        _label2.frame=CGRectMake(5, 12, (Screen_Width/2-5)-4-15, 15);
        _imgView2.frame=CGRectMake(CGRectGetMaxX(_label2.frame)+4, 12, 15, 15);
    }
    else{
        _label2.frame=CGRectMake((Screen_Width/2-rightWidth)/2, 12, rightWidth-4-15, 15);
        _imgView2.frame=CGRectMake(CGRectGetMaxX(_label2.frame)+4, 12, 15, 15);
    }
    
    _label2.text=tempStr;
    
    
    if (certiAndLevelModel == nil) {
        _certTypeId=_certTypeLevels;
        _certTypeCode = @"";
    }
    else{
        _certTypeId = certiAndLevelModel.certTypeId;
        _certTypeCode = codeModel.code;
    }
    _selectCertiModel = certiAndLevelModel;
    NSLog(@"++++ %@ %@",certiAndLevelModel.certTypeId,codeModel.code);
    [self requestData];
}
#pragma mark 弹出登录注册页面
- (void)presentLoginVCWithIndexPath:(NSIndexPath *)indexPath{
    DDLoginCheckVC * vc = [[DDLoginCheckVC alloc] init];
    vc.loginSuccessBlock = ^{
        DDSearchCompanyListModel *model=_dataSourceArr[indexPath.section];
        //此时需要存数据库了
        //存最近搜索
        [DDSearchHistoryDAOAndDB insertRecentSearchByTypeId:@"9909" andSearchText:self.searchText];
        //存浏览历史
        NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithData:[model.unitName dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        [DDSearchHistoryDAOAndDB insertHistorySearchByTypeId:@"9909" andSearchResult:[DDUtils transformAttributedText:attributeStr] andGlobalType:@"0" andTransId:model.enterpriseId];
        
        DDCompanyDetailVC *companyDetail=[[DDCompanyDetailVC alloc]init];
        companyDetail.enterpriseId=model.enterpriseId;
        [self.mainViewContoller.navigationController pushViewController:companyDetail animated:YES];
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
        
        DDSearchCompanyListModel *model=_dataSourceArr[sender.tag];
        
        DDPeopleDetailVC *peopleDetail=[[DDPeopleDetailVC alloc]init];
        peopleDetail.staffInfoId=model.staffInfoId;
        [self.mainViewContoller.navigationController pushViewController:peopleDetail animated:YES];
    };
    
    
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [DDNavigationUtil setNavigationAndBottomLineWhiteColor:nav];
    [self showViewController:nav sender:nil];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}


@end
