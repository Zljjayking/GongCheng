//
//  DDSearchContractCopyVC.m
//  GongChengDD
//
//  Created by xzx on 2018/8/15.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDSearchContractCopyVC.h"
#import "DDLabelUtil.h"
#import "MJRefresh.h"
#import "DDNavigationUtil.h"
#import "DDLoginCheckVC.h"
#import "DDSearchHistoryDAOAndDB.h"
#import "DataLoadingView.h"//加载页面
#import "DDNoResult2View.h"//无数据视图
#import "DDProvinceSelectView.h"//省份选择
#import "DDPublishDateSelectView.h"//日期筛选的View
#import "DDCompanyContractCopyModel.h"//model
#import "DDExcutedPropleCell.h"//cell

#import "DDContractCopyDetailVC.h"//合同备案详情页面
#import "DDCompanyDetailVC.h"//企业详情页面
#import "DDUMengEventDefines.h"

@interface DDSearchContractCopyVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,ProvinceSelectViewDelegate,DateSelectViewDelegate>

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
    //UIImageView *_imgView2;//放右边那个资质等级选择小箭头
    
    UILabel *_leftLab;//"搜索到"三个字的label
    UILabel *_numLabel;//总计数量label
    UILabel *_rightLab;//"个公司"三个字的label
    
    BOOL _isProvinceSelected;//判断是否点开了省份选择视图
    BOOL _isDateSelected;//判断是否点开了日期筛选视图
    
    NSString *_region;//省份
    NSString *_date;//日期
}
@property (nonatomic,strong) DataLoadingView *loadingView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) DDNoResult2View *noResultView;//无数据视图
@property (nonatomic,strong) UIImageView *imgView1;//放左边那个城市选择小箭头
@property (nonatomic,strong) DDProvinceSelectView *provinceSelectView;//省份筛选视图
@property (nonatomic,strong) UIImageView *imgView2;//放右边那个资质等级选择小箭头
@property (nonatomic,strong) DDPublishDateSelectView *dateSelectView;//日期筛选视图

@end

@implementation DDSearchContractCopyVC

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
    
    [MobClick endEvent:main_hetongbeian];
    _region=@"";
    _date=@"0";
    _isProvinceSelected=NO;
    _isDateSelected=NO;
    _dataSourceArr=[[NSMutableArray alloc]init];
    [self editNavItem];
    [_textField becomeFirstResponder];
    [self createTableView];
    [self createChooseBtns];
    [self createLoadView];
    [self requestData];
}

-(void)editNavItem{
    self.view.backgroundColor=kColorBackGroundColor;
    self.navigationItem.leftBarButtonItem=[DDUtils leftButtonItemWithImage:@"Nav_back_blue" highlightedImage:@"Nav_back_blue" target:self action:@selector(leftButtonClick)];
    
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

//返回上一页面
- (void)leftButtonClick{
    [_provinceSelectView hiddenActionSheet];
    [_dateSelectView hiddenActionSheet];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidDisappear:(BOOL)animated{
    if (self.navigationController==NULL) {
        [_provinceSelectView hiddenActionSheet];
        [_dateSelectView hiddenActionSheet];
    }
    else{
        _imgView1.image=[UIImage imageNamed:@"home_search_down"];
        [_provinceSelectView hiddenActionSheet];
        _isProvinceSelected=NO;
        _imgView2.image=[UIImage imageNamed:@"home_search_down"];
        [_dateSelectView hiddenActionSheet];
        _isDateSelected=NO;
    }
}

#pragma mark 监听文本框文字的改变,此时要关联三个子页面的刷新
- (void)textFieldDidChange:(UITextField *)textField{
    UITextRange *rang = textField.markedTextRange; // 获取非=选中状态文字范围
    if (rang == nil) { // 没有非选中状态文字.就是确定的文字输入
        if ([textField.text isEqual:@""]) {
            [self leftButtonClick];
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
    [areaSelectBtn addTarget:self action:@selector(provinceSelectClick) forControlEvents:UIControlEventTouchUpInside];
    
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
    
    //日期筛选按钮
    UIButton *moneySelectBtn=[[UIButton alloc]initWithFrame:CGRectMake(Screen_Width/2, 0, Screen_Width/2, 39)];
    [moneySelectBtn setBackgroundColor:kColorWhite];
    
    _label2=[[UILabel alloc]init];
    _label2.text=@"签订日期";
    _label2.textColor=KColorBlackTitle;
    _label2.font=kFontSize30;
    [moneySelectBtn addSubview:_label2];
    
    _imgView2=[[UIImageView alloc]init];
    _imgView2.contentMode = UIViewContentModeScaleAspectFit;
    _imgView2.image=[UIImage imageNamed:@"home_search_down"];
    [moneySelectBtn addSubview:_imgView2];
    [moneySelectBtn addTarget:self action:@selector(dateSelectClick) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect rightTextFrame = [@"签订日期" boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
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
    _rightLab.text=@"个合同备案";
    _rightLab.textColor=KColorGreySubTitle;
    _rightLab.font=kFontSize26;
    [summaryView addSubview:_rightLab];
}

#pragma mark 创建加载视图
-(void)createLoadView{
    __weak __typeof(self) weakSelf=self;
    _noResultView=[[DDNoResult2View alloc]initWithFrame:CGRectMake(0, 39, Screen_Width, Screen_Height-KNavigationBarHeight-39)];
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
    [params setValue:_date forKey:@"timeScree"];
    [params setValue:_region forKey:@"region"];
    [params setValue:[NSString stringWithFormat:@"%ld",currentPage] forKey:@"current"];
    [params setValue:@"10" forKey:@"size"];
    
    [[DDHttpManager sharedInstance]sendPostRequest:KHttpRequest_searchContractCopyList params:params success:^(NSURLSessionDataTask *operation, id responseObject){
        NSLog(@"**********合同备案搜索结果数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        __weak __typeof(self) weakSelf = self;
        [_loadingView hiddenLoadingView];
        if (response.isSuccess) {
            if (![response isEmpty]) {
                //[_dataSourceArr removeAllObjects];
                [_loadingView hiddenLoadingView];
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
                    [_dataSourceArr removeAllObjects];
                    for (NSDictionary *dic in listArr) {
                        DDCompanyContractCopyModel *model = [[DDCompanyContractCopyModel alloc]initWithDictionary:dic error:nil];
                        
                        
                        if (![DDUtils isEmptyString:model.project_name]) {
                            NSString *titleStr=[NSString stringWithFormat:@"<font color='#222222'>%@</font>",model.project_name];
                            NSAttributedString *unitName = [[NSAttributedString alloc] initWithData:[titleStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
                            model.nameString=unitName;
                        }
                        
                        if (![DDUtils isEmptyString:model.enterprise_name]) {
                            NSString *titleStr=[NSString stringWithFormat:@"<font color='#666666'>%@</font>",model.enterprise_name];
                            NSAttributedString *unitName = [[NSAttributedString alloc] initWithData:[titleStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
                            model.enterpriseNameString=unitName;
                        }
                        
                        if ([DDUtils isEmptyString:model.contract_amount]) {
                            model.amountStr=@"";
                        }
                        else{
                            //cell.aimLab2.text=[NSString stringWithFormat:@"%.2f万",model.contract_amount.floatValue/10000];
                            model.amountStr=[NSString stringWithFormat:@"%@万",model.contract_amount];
                        }
                        
                        
                        [_dataSourceArr addObject:model];
                    }
                    
                    if (listArr.count<pageCount) {
                        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                            [weakSelf addData];
                        }];
                    }else{
                       [self.tableView.mj_footer removeFromSuperview];
                    }
                    
                }
                else{
                    [_noResultView showWithTitle:@"没有帮您找到想要的合同备案" subTitle:@"去其他地方看看~" image:@"noResult_info"];
                }
            }
            else{
                [_noResultView showWithTitle:@"没有帮您找到想要的合同备案" subTitle:@"去其他地方看看~" image:@"noResult_info"];
            }
        }
        else{
            [_noResultView showWithTitle:@"没有帮您找到想要的合同备案" subTitle:@"去其他地方看看~" image:@"noResult_info"];
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
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:self.searchText forKey:@"keys"];
    [params setValue:_date forKey:@"timeScree"];
    [params setValue:_region forKey:@"region"];
    [params setValue:[NSString stringWithFormat:@"%ld",currentPage] forKey:@"current"];
    [params setValue:@"10" forKey:@"size"];
    
    [[DDHttpManager sharedInstance]sendPostRequest:KHttpRequest_searchContractCopyList params:params success:^(NSURLSessionDataTask *operation, id responseObject){
        NSLog(@"**********合同备案搜索结果数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        __weak __typeof(self) weakSelf = self;
        if (response.isSuccess) {
            if (![response isEmpty]) {
                _dict = responseObject[KData];
                NSArray *listArr = _dict[@"list"];
                for (NSDictionary *dic in listArr) {
                    DDCompanyContractCopyModel *model = [[DDCompanyContractCopyModel alloc]initWithDictionary:dic error:nil];
                    
                    
                    if (![DDUtils isEmptyString:model.project_name]) {
                        NSString *titleStr=[NSString stringWithFormat:@"<font color='#222222'>%@</font>",model.project_name];
                        NSAttributedString *unitName = [[NSAttributedString alloc] initWithData:[titleStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
                        model.nameString=unitName;
                    }
                    
                    if (![DDUtils isEmptyString:model.enterprise_name]) {
                        NSString *titleStr=[NSString stringWithFormat:@"<font color='#666666'>%@</font>",model.enterprise_name];
                        NSAttributedString *unitName = [[NSAttributedString alloc] initWithData:[titleStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
                        model.enterpriseNameString=unitName;
                    }
                    
                    if ([DDUtils isEmptyString:model.contract_amount]) {
                        model.amountStr=@"";
                    }
                    else{
                        //cell.aimLab2.text=[NSString stringWithFormat:@"%.2f万",model.contract_amount.floatValue/10000];
                        model.amountStr=[NSString stringWithFormat:@"%@万",model.contract_amount];
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
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 45+39, Screen_Width, Screen_Height-KNavigationBarHeight-45-39) style:UITableViewStyleGrouped];
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
        DDCompanyContractCopyModel *model=_dataSourceArr[indexPath.section];
        
        static NSString * cellID = @"DDExcutedPropleCell";
        DDExcutedPropleCell * cell = (DDExcutedPropleCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
        }
        
        cell.nameLab.attributedText=model.nameString;
        cell.nameLab.font=kFontSize34;
        //cell.nameLab.text=model.project_name;
        
        cell.numLab1.text=@"类别:";
        cell.numLab2.text=model.project_classify;
        cell.aimLab1.text=@"金额:";
        
        cell.aimLab2.text=model.amountStr;
        
        cell.courtLab1.text=@"备案编号:";
        cell.courtLab2.text=model.record_number;
        cell.timeLab1.text=@"签订日期:";
        cell.timeLab2.text=model.contract_date;
        
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    else{
        static NSString * cellID = @"DDExcutedPropleCell";
        DDExcutedPropleCell * cell = (DDExcutedPropleCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
        }
        

        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _imgView1.image=[UIImage imageNamed:@"home_search_down"];
    [_provinceSelectView hiddenActionSheet];
    _isProvinceSelected=NO;
    _imgView2.image=[UIImage imageNamed:@"home_search_down"];
    [_dateSelectView hiddenActionSheet];
    _isDateSelected=NO;

    if ([DDUtils isEmptyString:[DDUserManager sharedInstance].userid]) {
        [self presentLoginVCWithIndexPath:indexPath];
    }
    else{
        DDCompanyContractCopyModel *model=_dataSourceArr[indexPath.section];
        //此时需要存数据库了
        //存最近搜索
        [DDSearchHistoryDAOAndDB insertRecentSearchByTypeId:self.menuId andSearchText:self.searchText];
        //存浏览历史
        //    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithData:[model.accident_title dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        //    [DDSearchHistoryDAOAndDB insertHistorySearchByTypeId:self.menuId andSearchResult:[DDUtils transformAttributedText:attributeStr] andGlobalType:nil andTransId:model.accident_id];
        
        DDContractCopyDetailVC *contractCopyDetail=[[DDContractCopyDetailVC alloc]init];
        contractCopyDetail.record_id=model.record_id;
        [self.navigationController pushViewController:contractCopyDetail animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //return 180;
    return UITableViewAutomaticDimension;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    DDCompanyContractCopyModel *model=_dataSourceArr[section];
    
    UIView *footerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 45)];
    footerView.backgroundColor=kColorWhite;
    
    UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(12, 15, 15, 15)];
    imgView.image=[UIImage imageNamed:@"home_com_link"];
    [footerView addSubview:imgView];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imgView.frame)+15, 15, Screen_Width-54, 15)];
    //label.text=model.enterprise_name;
    label.attributedText=model.enterpriseNameString;
    //label.textColor=KColorBlackSecondTitle;
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
//        DDCompanyContractCopyModel *model=_dataSourceArr[sender.tag-150];
//
//        DDCompanyDetailVC *companyDetailVC=[[DDCompanyDetailVC alloc]init];
//        companyDetailVC.enterpriseId=model.enterprise_id;
//        [self.navigationController pushViewController:companyDetailVC animated:YES];
//    }
    
    _imgView1.image=[UIImage imageNamed:@"home_search_down"];
    [_provinceSelectView hiddenActionSheet];
    _isProvinceSelected=NO;
    _imgView2.image=[UIImage imageNamed:@"home_search_down"];
    [_dateSelectView hiddenActionSheet];
    _isDateSelected=NO;
    DDCompanyContractCopyModel *model=_dataSourceArr[sender.tag-150];
    
    DDCompanyDetailVC *companyDetailVC=[[DDCompanyDetailVC alloc]init];
    companyDetailVC.enterpriseId=model.enterprise_id;
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
    DDCompanyContractCopyModel *model=_dataSourceArr[section];
    
    if ([DDUtils isEmptyString:model.enterprise_name]) {
        return CGFLOAT_MIN;
    }
    else{
        return 45;
    }
}

#pragma mark 点击城市选择
-(void)provinceSelectClick{
    if (_isProvinceSelected==NO) {
        //将日期筛选隐藏
        _imgView2.image=[UIImage imageNamed:@"home_search_down"];
        [_dateSelectView hiddenActionSheet];
        _isDateSelected=NO;
        
        _imgView1.image=[UIImage imageNamed:@"home_search_up"];
        
        _provinceSelectView=[[DDProvinceSelectView alloc]initWithFrame:CGRectMake(0, 39-60, Screen_Width, Screen_Height-KNavigationBarHeight-39-60)];
        _provinceSelectView.attachHeight=@"0";
        _provinceSelectView.province=_region;
        __weak __typeof(self) weakSelf=self;
        _provinceSelectView.hiddenBlock = ^{
            weakSelf.imgView1.image=[UIImage imageNamed:@"home_search_down"];
            
            [weakSelf.provinceSelectView hiddenActionSheet];
            
            _isProvinceSelected=NO;
        };
        _provinceSelectView.delegate=self;
        [_provinceSelectView show];
        [_textField resignFirstResponder];
        
        _isProvinceSelected=YES;
    }
    else{
        _imgView1.image=[UIImage imageNamed:@"home_search_down"];
        
        [_provinceSelectView hiddenActionSheet];
        
        _isProvinceSelected=NO;
    }
}

#pragma mark CitySelectPickerView代理回调
-(void)actionsheetDisappear:(DDProvinceSelectView *)actionSheet andProvinceInfo:(NSString *)province{
    _region=province;
    
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
    
    if ([province isEqualToString:@"全国"]) {
        _region=@"";
    }
    
    [self requestData];
}


#pragma mark 点击日期筛选
-(void)dateSelectClick{
    if (_isDateSelected==NO) {
        //将区域筛选隐藏
        _imgView1.image=[UIImage imageNamed:@"home_search_down"];
        [_provinceSelectView hiddenActionSheet];
        _isProvinceSelected=NO;
        
        
        _imgView2.image=[UIImage imageNamed:@"home_search_up"];
        
        _dateSelectView=[[DDPublishDateSelectView alloc]initWithFrame:CGRectMake(0, 39+60, Screen_Width, Screen_Height-KNavigationBarHeight-39-60)];
        _dateSelectView.attachHeight=@"0";
        _dateSelectView.dateCode=_date;
        __weak __typeof(self) weakSelf=self;
        _dateSelectView.hiddenBlock = ^{
            weakSelf.imgView2.image=[UIImage imageNamed:@"home_search_down"];
            
            [weakSelf.dateSelectView hiddenActionSheet];
            
            _isDateSelected=NO;
        };
        _dateSelectView.delegate=self;
        [_dateSelectView show];
        [_textField resignFirstResponder];
        
        _isDateSelected=YES;
    }
    else{
        _imgView2.image=[UIImage imageNamed:@"home_search_down"];
        
        [_dateSelectView hiddenActionSheet];
        
        _isDateSelected=NO;
    }
}

#pragma mark DateSelectViewDelegate代理回调
-(void)actionsheetDisappear:(DDPublishDateSelectView *)actionSheet andDateCode:(NSString *)dateCode andDateStr:(NSString *)dateStr{
    
    _date=dateCode;
    
    CGRect rightTextFrame = [dateStr boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
    CGFloat rightWidth=rightTextFrame.size.width+4+15;
    if (rightWidth>=(Screen_Width/2-40)) {
        _label2.frame=CGRectMake(20, 12, (Screen_Width/2-40)-4-15, 15);
        _imgView2.frame=CGRectMake(CGRectGetMaxX(_label2.frame)+4, 12, 15, 15);
    }
    else{
        _label2.frame=CGRectMake((Screen_Width/2-rightWidth)/2, 12, rightWidth-4-15, 15);
        _imgView2.frame=CGRectMake(CGRectGetMaxX(_label2.frame)+4, 12, 15, 15);
    }
    
    _label2.text=dateStr;
    
    [self requestData];
}


#pragma mark 弹出登录注册页面
- (void)presentLoginVCWithIndexPath:(NSIndexPath *)indexPath{
    DDLoginCheckVC * vc = [[DDLoginCheckVC alloc] init];
    vc.loginSuccessBlock = ^{
        //__weak __typeof(self) weakSelf=self;
        //[weakSelf requestTypesData];
        
        DDCompanyContractCopyModel *model=_dataSourceArr[indexPath.section];
        //此时需要存数据库了
        //存最近搜索
        [DDSearchHistoryDAOAndDB insertRecentSearchByTypeId:self.menuId andSearchText:self.searchText];
        //存浏览历史
        //    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithData:[model.accident_title dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        //    [DDSearchHistoryDAOAndDB insertHistorySearchByTypeId:self.menuId andSearchResult:[DDUtils transformAttributedText:attributeStr] andGlobalType:nil andTransId:model.accident_id];
        
        DDContractCopyDetailVC *contractCopyDetail=[[DDContractCopyDetailVC alloc]init];
        contractCopyDetail.record_id=model.record_id;
        [self.navigationController pushViewController:contractCopyDetail animated:YES];
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
        
        DDCompanyContractCopyModel *model=_dataSourceArr[sender.tag-150];
        
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


@end
