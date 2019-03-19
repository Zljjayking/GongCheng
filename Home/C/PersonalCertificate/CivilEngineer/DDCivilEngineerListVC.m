//
//  DDCivilEngineerListVC.m
//  GongChengDD
//
//  Created by xzx on 2018/9/25.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDCivilEngineerListVC.h"
#import "DataLoadingView.h"
#import "DDNoResult2View.h"//无数据视图
#import "MJRefresh.h"
#import "DDCivilEngineerModel.h"//model
#import "DDCivilEngineerCell.h"//cell
#import "DDCivilReceivedProjectsVC.h"//工程业绩列表页
#import "DDMajorSelectView.h"//专业筛选View
#import "DDPersonalClaimBenefitVC.h"//认领页面
#import "DDCivilEngineerDetailInfoVC.h"//土木工程师等人员详情页面

@interface DDCivilEngineerListVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,MajorSelectViewDelegate>

{
    NSInteger currentPage;
    NSInteger pageCount;
    NSMutableArray *_dataSourceArr;
    NSMutableDictionary *_dict;
    
    NSString *_staffName;
    NSString *_certType;
    NSString *_status;
    
    BOOL _isMajorSelect;
    
    UILabel *_leftLab;//"共"字的label
    UILabel *_numLabel;//总计数量label
    UILabel *_rightLab;//"个公司"三个字的label
    
    MBProgressHUD *_hud;
}
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) DataLoadingView *loadingView;
@property (nonatomic,strong) DDNoResult2View *noResultView;//无数据视图
@property (nonatomic,strong) UIImageView *arrowImg;//放右边那个专业选择小箭头
@property (strong,nonatomic) DDMajorSelectView *majorSelectView;
@property (nonatomic,strong) UILabel *majorLab;//放右边那个专业选择结果

@end

@implementation DDCivilEngineerListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _staffName=@"";
    _certType=@"";
    _status=@"";
    _isMajorSelect=NO;
    _dataSourceArr = [[NSMutableArray alloc]init];
    [self editNavItem];
    [self createTableView];
    [self createChooseBtns];
    [self setupDataLoadingView];
    [self requestData];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshData) name:KRefreshUI object:nil];//接收收到刷新页面的通知
}
-(void)refreshData{
    [self.tableView reloadData];
}
-(void)editNavItem{
    if ([self.type isEqualToString:@"1"]) {
        self.title=@"土木工程师";
    }
    else if ([self.type isEqualToString:@"2"]) {
        self.title=@"公用设备师";
    }
    else if ([self.type isEqualToString:@"3"]) {
        self.title=@"电气工程师";
    }
    else if ([self.type isEqualToString:@"4"]) {
        self.title=@"监理工程师";
    }
    else if ([self.type isEqualToString:@"5"]) {
        self.title=@"造价工程师";
    }
    self.view.backgroundColor=kColorBackGroundColor;
    self.navigationItem.leftBarButtonItem=[DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
}

//返回上一页面
- (void)leftButtonClick{
    [_majorSelectView hiddenActionSheet];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidDisappear:(BOOL)animated{
    if (self.navigationController==NULL) {
        [_majorSelectView hiddenActionSheet];
    }
}

//筛选按钮
-(void)createChooseBtns{
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 45)];
    bgView.backgroundColor=kColorWhite;
    [self.view addSubview:bgView];
    
    
    UIView *leftView=[[UIView alloc]initWithFrame:CGRectMake(12, 7.5, Screen_Width-24-80, 30)];
    leftView.backgroundColor=KColorSearchTextFieldGrey;
    leftView.layer.cornerRadius=3;
    leftView.clipsToBounds=YES;
    
    UIImageView *searchImg=[[UIImageView alloc]initWithFrame:CGRectMake(5, 7.5, 15, 15)];
    searchImg.image=[UIImage imageNamed:@"cm_Search_icon"];
    [leftView addSubview:searchImg];
    
    UITextField *textField=[[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(searchImg.frame)+5, 7.5, leftView.frame.size.width-15-10, 15)];
    textField.delegate=self;
    [textField addTarget:self action:@selector(textFieldDidChange:)forControlEvents:UIControlEventEditingChanged];
    textField.returnKeyType = UIReturnKeySearch;
    [textField setValue:KColorGreyLight forKeyPath:@"_placeholderLabel.textColor"];
    [textField setValue:kFontSize30 forKeyPath:@"_placeholderLabel.font"];
    textField.textColor=KColorBlackSubTitle;
    textField.font=kFontSize30;
    textField.placeholder=@"姓名、证书编号、注册编号";
    textField.clearButtonMode=UITextFieldViewModeAlways;
    [leftView addSubview:textField];
    
    [bgView addSubview:leftView];
    
    
    UIView *rightView=[[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(leftView.frame), 7.5, 80, 30)];
    
    UILabel *sepLine=[[UILabel alloc]initWithFrame:CGRectMake(12, 7.5, 1, 15)];
    sepLine.backgroundColor=KColorTableSeparator;
    [rightView addSubview:sepLine];
    
    _majorLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(sepLine.frame)+12, 7.5, rightView.frame.size.width-24-1-10-15, 15)];
    _majorLab.text=@"筛选";
    _majorLab.textColor=kColorBlue;
    _majorLab.font=kFontSize28;
    _majorLab.textAlignment=NSTextAlignmentCenter;
    [rightView addSubview:_majorLab];
    
    _arrowImg=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_majorLab.frame)+5, 7.5, 15, 15)];
    _arrowImg.image=[UIImage imageNamed:@"home_search_down"];
    _arrowImg.contentMode = UIViewContentModeScaleAspectFit;
    [rightView addSubview:_arrowImg];
    
    UIButton *rightBtn=[[UIButton alloc]initWithFrame:CGRectMake(12, 0, (Screen_Width-24)/3-12, 30)];
    [rightBtn addTarget:self action:@selector(majorSelectClick) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:rightBtn];
    
    [bgView addSubview:rightView];
    
    
    //    UILabel *line=[[UILabel alloc]initWithFrame:CGRectMake(0, 45, Screen_Width, 1)];
    //    line.backgroundColor=KColorTableSeparator;
    //    [self.view addSubview:line];
    
    //搜索结果统计
    UIView *summaryView=[[UIView alloc]initWithFrame:CGRectMake(0, 45, Screen_Width, 45)];
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
    
    _rightLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_numLabel.frame)+2, 15, 150, 15)];
    if ([self.type isEqualToString:@"1"]) {
        _rightLab.text=@"个土木工程师证书";
    }
    else if ([self.type isEqualToString:@"2"]) {
        _rightLab.text=@"个公用设备师证书";
    }
    else if ([self.type isEqualToString:@"3"]) {
        _rightLab.text=@"个电气工程师证书";
    }
    else if ([self.type isEqualToString:@"4"]) {
        _rightLab.text=@"个监理工程师证书";
    }
    else if ([self.type isEqualToString:@"5"]) {
        _rightLab.text=@"个造价工程师证书";
    }
    _rightLab.textColor=KColorGreySubTitle;
    _rightLab.font=kFontSize26;
    [summaryView addSubview:_rightLab];
}

- (void)setupDataLoadingView{
    __weak __typeof(self) weakSelf=self;
    _noResultView=[[DDNoResult2View alloc]initWithFrame:CGRectMake(0, 45, Screen_Width, Screen_Height-KNavigationBarHeight-45)];
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
    [params setValue:self.enterpriseId forKey:@"enterpriseId"];
    [params setValue:self.toAction forKey:@"toAction"];
    [params setValue:self.type forKey:@"type"];
    [params setValue:_staffName forKey:@"staffName"];
    [params setValue:_certType forKey:@"certType"];
    [params setValue:_status forKey:@"status"];
    [params setValue:[NSString stringWithFormat:@"%ld",currentPage] forKey:@"current"];
    [params setValue:@"10" forKey:@"size"];
    
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_companyCivilEngineerList params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"**********1土木工程师 2公用设备师 3电气工程师 4监理工程师 5造价工程师结果数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        __weak __typeof(self) weakSelf = self;
        if (response.isSuccess) {
            [_dataSourceArr removeAllObjects];
            [_loadingView hiddenLoadingView];
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
                [_noResultView hide];
                
                for (NSDictionary *dic in listArr) {
                    DDCivilEngineerModel *model = [[DDCivilEngineerModel alloc]initWithDictionary:dic error:nil];
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
                if ([self.type isEqualToString:@"1"]) {
                    [_noResultView showWithTitle:@"暂无相关土木工程师的信息" subTitle:@"去其他地方看看~" image:@"noResult_person"];
                }
                else if ([self.type isEqualToString:@"2"]){
                    [_noResultView showWithTitle:@"暂无相关公用设备师的信息" subTitle:@"去其他地方看看~" image:@"noResult_person"];
                }
                else if ([self.type isEqualToString:@"3"]){
                    [_noResultView showWithTitle:@"暂无相关电气工程师的信息" subTitle:@"去其他地方看看~" image:@"noResult_person"];
                }
                else if ([self.type isEqualToString:@"4"]){
                    [_noResultView showWithTitle:@"暂无相关监理工程师的信息" subTitle:@"去其他地方看看~" image:@"noResult_person"];
                }
                else if ([self.type isEqualToString:@"5"]){
                    [_noResultView showWithTitle:@"暂无相关造价工程师的信息" subTitle:@"去其他地方看看~" image:@"noResult_person"];
                }
            }
            
        }
        else{
            
            [_loadingView failureLoadingView];
        }
        
        [self.tableView.mj_header endRefreshing];
        [_hud hide:YES];
        [_tableView reloadData];
        if (_dataSourceArr.count>0) {
            [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }
        
    }  failure:^(NSURLSessionDataTask *operation, id responseObject)  {
        [_hud hide:YES];
        [DDUtils showToastWithMessage:kRequestFailed];
        [_loadingView failureLoadingView];
    }];
}

- (void)addData{
    currentPage++;
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:self.enterpriseId forKey:@"enterpriseId"];
    [params setValue:self.toAction forKey:@"toAction"];
    [params setValue:self.type forKey:@"type"];
    [params setValue:_staffName forKey:@"staffName"];
    [params setValue:_certType forKey:@"certType"];
    [params setValue:_status forKey:@"status"];
    [params setValue:[NSString stringWithFormat:@"%ld",currentPage] forKey:@"current"];
    [params setValue:@"10" forKey:@"size"];
    
    
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_companyCivilEngineerList params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"**********1土木工程师 2公用设备师 3电气工程师 4监理工程师 5造价工程师结果数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        __weak __typeof(self) weakSelf = self;
        if (response.isSuccess) {
            
            _dict = responseObject[KData];
            NSArray *listArr = _dict[@"list"];
            for (NSDictionary *dic in listArr) {
                DDCivilEngineerModel *model = [[DDCivilEngineerModel alloc]initWithDictionary:dic error:nil];
                [_dataSourceArr addObject:model];
            }
            
            if (_dataSourceArr.count<pageCount) {
                self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                    [weakSelf addData];
                }];
            }
            else{
              [_tableView.mj_footer removeFromSuperview];;
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
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 90, Screen_Width, Screen_Height-KNavigationBarHeight-45-45) style:UITableViewStyleGrouped];
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
    DDCivilEngineerModel *model=_dataSourceArr[indexPath.section];
    
    static NSString * cellID = @"DDCivilEngineerCell";
    DDCivilEngineerCell * cell = (DDCivilEngineerCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
    }
    
    [cell loadDataWithModel:model andIndex:indexPath.section+1];
    cell.checkBtn.tag=indexPath.section+200;
    [cell.checkBtn addTarget:self action:@selector(checkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark 认领点击事件
-(void)checkBtnClick:(UIButton *)sender{
    DDCivilEngineerModel *model=_dataSourceArr[sender.tag-200];
    DDPersonalClaimBenefitVC *vc=[[DDPersonalClaimBenefitVC alloc]init];
    vc.claimBenefitType = DDClaimBenefitTypeDefault;
    vc.peopleName = model.name;
    vc.peopleId = model.staff_info_id;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DDCivilEngineerModel *model=_dataSourceArr[indexPath.section];

    DDCivilEngineerDetailInfoVC *vc=[[DDCivilEngineerDetailInfoVC alloc]init];
    vc.staffInfoId=model.staff_info_id;
    //1土木工程师 2公用设备师 3电气工程师 4监理工程师 5造价工程师
    if ([self.type isEqualToString:@"1"]) {
        vc.type=@"8";
        vc.nameStr = @"other1";
    }
    else if ([self.type isEqualToString:@"2"]) {
        vc.type=@"9";
        vc.nameStr = @"other2";
    }
    else if ([self.type isEqualToString:@"3"]) {
        vc.type=@"10";
        vc.nameStr = @"other3";
    }
    else if ([self.type isEqualToString:@"4"]) {
        vc.type=@"11";
        vc.nameStr = @"other4";
    }
    else if ([self.type isEqualToString:@"5"]) {
        vc.type=@"12";
        vc.nameStr = @"other5";
    }
    vc.specialityCode=model.cert_type_id;
    vc.certStr = model.certId;
    vc.titleStr = [NSString stringWithFormat:@"%@%@的证书",self.title,model.name];
    [self.navigationController pushViewController:vc animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 155+30;
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

#pragma mark textField代理方法
-(void)textFieldDidChange:(UITextField *)textField{
    if ([DDUtils isEmptyString:textField.text]) {
        [textField resignFirstResponder];
        _staffName=textField.text;
        [self requestData];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    _staffName=textField.text;
    [self requestData];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (_isMajorSelect==NO) {
        
    }
    else{
        _arrowImg.image=[UIImage imageNamed:@"home_search_down"];
        
        [_majorSelectView hiddenActionSheet];
        
        _isMajorSelect=NO;
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    _staffName=textField.text;
    
    [self requestData];
}

#pragma mark 弹出专业筛选视图
-(void)majorSelectClick{
    if (_isMajorSelect==NO) {
        _arrowImg.image=[UIImage imageNamed:@"home_search_up"];
        
        _majorSelectView=[[DDMajorSelectView alloc]initWithFrame:CGRectMake(0, 45, Screen_Width, Screen_Height-KNavigationBarHeight-45)];
        _majorSelectView.ifFrom=@"1";
        _majorSelectView.type=self.type;
        _majorSelectView.certiType=_certType;
        _majorSelectView.status=_status;
        __weak __typeof(self) weakSelf=self;
        _majorSelectView.hiddenBlock = ^{
            weakSelf.arrowImg.image=[UIImage imageNamed:@"home_search_down"];
            
            [weakSelf.majorSelectView hiddenActionSheet];
            
            _isMajorSelect=NO;
        };
        _majorSelectView.delegate=self;
        [_majorSelectView show];
        
        _isMajorSelect=YES;
    }
    else{
        _arrowImg.image=[UIImage imageNamed:@"home_search_down"];
        
        [_majorSelectView hiddenActionSheet];
        
        _isMajorSelect=NO;
    }
}

-(void)actionsheetDisappear:(DDMajorSelectView *)actionSheet andCode:(NSString *)code andStatus:(NSString *)status{
    _certType=code;
    _status=status;
    //_majorLab.text=string;
    
    _hud=[DDUtils showHUDCustom:@""];
    [self requestData];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:KRefreshUI object:nil];
}


@end
