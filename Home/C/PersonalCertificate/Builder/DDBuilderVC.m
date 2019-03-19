//
//  DDBuilderVC.m
//  GongChengDD
//
//  Created by xzx on 2018/5/17.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDBuilderVC.h"
#import "DataLoadingView.h"
#import "DDNoResult2View.h"//无数据视图
#import "MJRefresh.h"
#import "DDBuilderCell.h"//cell
#import "DDCompanyBuilderModel.h"//model
#import "DDMajorSelectView.h"//专业筛选View
#import "DDBuilderDetailInfoVC.h"//建造师详情页面
#import "DDPersonalClaimBenefitVC.h"
#import "DDBuilderMoreTrainVC.h"//报名列表
#import "DDMyEnterpriseVC.h"//认领公司列表
#import "DDAlertView.h"
#import "DDAffirmEnterpriseVC.h"//认领公司

@interface DDBuilderVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,MajorSelectViewDelegate>

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
@property (nonatomic, assign) BOOL isAllSearch;//是否是全部筛选

@end

@implementation DDBuilderVC


- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshData) name:KRefreshUI object:nil];//接收收到刷新页面的通知
    _staffName=@"";
    _certType=@"";
    _status=@"";
    _isMajorSelect=NO;
    self.isAllSearch = YES;
    _dataSourceArr = [[NSMutableArray alloc]init];
    [self editNavItem];
    [self createTableView];
    [self createChooseBtns];
    [self setupDataLoadingView];
    [self requestData];
}
-(void)refreshData{
    [self.tableView reloadData];
}
-(void)editNavItem{
    if ([self.certLevel isEqualToString:@"1"]) {
        self.title=@"一级建造师";
    }
    else{
        self.title=@"二级建造师";
        if ([_isOpen integerValue]!=0) {
            self.navigationItem.rightBarButtonItem=[DDUtils rightbuttonItemWithTitle:@"考试培训" target:self action:@selector(rightButtonClick)];
        }
    }
    self.view.backgroundColor=kColorBackGroundColor;
    self.navigationItem.leftBarButtonItem=[DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
}
-(void)rightButtonClick{
    //attestation -1（认领企业已经5家，跳认领公司列表）  1（通过，跳报名列表） 2（认领中，提示语“当前公司正在认领中”）  3，其他（认领失败，弹框去认领）
    if([_attestation integerValue] == -1){
        DDMyEnterpriseVC * vc = [[DDMyEnterpriseVC alloc] init];
        vc.isFromMyInfo = NO;
        vc.myEnterpriseType = MyEnterpriseTypeCompany;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if([_attestation integerValue] == 1){
        DDBuilderMoreTrainVC *trainVC = [[DDBuilderMoreTrainVC alloc]init];
        trainVC.companyID = _enterpriseId;
        [self.navigationController pushViewController:trainVC animated:YES];
    }else if([_attestation integerValue] == 2){
        [DDUtils showToastWithMessage:@"当前公司正在认领中"];
    }else{
        DDAlertView *alertView = [[DDAlertView alloc]initWithFrame:CGRectMake(WidthByiPhone6(60), (Screen_Height-WidthByiPhone6(140))*0.5, Screen_Width-WidthByiPhone6(60), WidthByiPhone6(140)) withTitle:@"请先认领您的公司,再进行培训考试报名" withLeft:@"取消" withRight:@"去认领" alertMessage:@"" confrimBolck:^{
            DDAffirmEnterpriseVC * vc = [[DDAffirmEnterpriseVC alloc] init];
            vc.companyid = _enterpriseId;
            vc.companyName = _enterpriseName;
            vc.affirmEnterpriseType = AffirmEnterpriseTypeCompany;
            [self.navigationController pushViewController:vc animated:YES];
        } cancelBlock:^{
        
        }];
        [alertView show];
    }
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
    [textField setValue:KColorGreyLight forKeyPath:@"_placeholderLabel.textColor"];
    [textField setValue:kFontSize30 forKeyPath:@"_placeholderLabel.font"];
    textField.textColor=KColorBlackSubTitle;
    textField.font=kFontSize30;
    textField.placeholder=@"姓名、证书编号、注册编号";
    textField.clearButtonMode=UITextFieldViewModeAlways;
    textField.returnKeyType = UIReturnKeySearch;
    [leftView addSubview:textField];
    
    [bgView addSubview:leftView];
    
    
    UIView *rightView=[[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(leftView.frame), 7.5, 80+12, 30)];
    
    UILabel *sepLine=[[UILabel alloc]initWithFrame:CGRectMake(12, 7.5, 1, 15)];
    sepLine.backgroundColor=KColorTableSeparator;
//    [rightView addSubview:sepLine];
    
    _majorLab=[[UILabel alloc]initWithFrame:CGRectMake(19, 7.5, 32, 15)];
    _majorLab.text=@"筛选";
    _majorLab.textColor=KColorBlackTitle;
    _majorLab.font=kFontSize28;
    _majorLab.textAlignment=NSTextAlignmentCenter;
    [rightView addSubview:_majorLab];
    
    _arrowImg=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_majorLab.frame)+2, 7.5, 15, 15)];
    _arrowImg.contentMode = UIViewContentModeScaleAspectFit;
    _arrowImg.image=[UIImage imageNamed:@"home_search_down"];
    [rightView addSubview:_arrowImg];
    
    UIButton *rightBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 30)];
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
    if ([self.certLevel isEqualToString:@"1"]) {
        _rightLab.text=@"个一级建造师证书";
    }
    else{
        _rightLab.text=@"个二级建造师证书";
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

#pragma mark 请求数据
- (void)requestData{
    currentPage = 1;
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:self.enterpriseId forKey:@"enterpriseId"];
    [params setValue:self.toAction forKey:@"toAction"];
    [params setValue:self.certLevel forKey:@"certLevel"];
    [params setValue:_staffName forKey:@"staffName"];
    [params setValue:_certType forKey:@"certType"];
    [params setValue:_status forKey:@"status"];
    [params setValue:[NSString stringWithFormat:@"%ld",currentPage] forKey:@"current"];
    [params setValue:@"10" forKey:@"size"];
    
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_companyBuilderList params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"**********建造师结果数据***************%@",responseObject);
        
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
                    DDCompanyBuilderModel *model = [[DDCompanyBuilderModel alloc]initWithDictionary:dic error:nil];
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
                if ([self.certLevel isEqualToString:@"1"]) {
                    [_noResultView showWithTitle:@"暂无一级建造师证书信息" subTitle:nil image:@"noResult_content"];
                }
                else{
                    [_noResultView showWithTitle:@"暂无二级建造师证书信息" subTitle:nil image:@"noResult_content"];
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
    [params setValue:self.certLevel forKey:@"certLevel"];
    [params setValue:_staffName forKey:@"staffName"];
    [params setValue:_certType forKey:@"certType"];
    [params setValue:_status forKey:@"status"];
    [params setValue:[NSString stringWithFormat:@"%ld",currentPage] forKey:@"current"];
    [params setValue:@"10" forKey:@"size"];
    
    
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_companyBuilderList params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"**********建造师结果数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        __weak __typeof(self) weakSelf = self;
        if (response.isSuccess) {
            
            _dict = responseObject[KData];
            NSArray *listArr = _dict[@"list"];
            for (NSDictionary *dic in listArr) {
                DDCompanyBuilderModel *model = [[DDCompanyBuilderModel alloc]initWithDictionary:dic error:nil];
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
    DDCompanyBuilderModel *model=_dataSourceArr[indexPath.section];
    
    static NSString * cellID = @"DDBuilderCell";
    DDBuilderCell * cell = (DDBuilderCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
    }
    
    if ([self.certLevel isEqualToString:@"1"]) {//一级建造师
        cell.roleLab.hidden=NO;
        if ([model.formal isEqualToString:@"0"]) {
            cell.roleLab.text=@"临时";
        }
        else{
            cell.roleLab.hidden=YES;
        }
    }
    else{
        cell.roleLab.hidden=NO;
        if ([model.formal isEqualToString:@"0"]) {
            cell.roleLab.text=@"临时";
        }
        else{
            cell.roleLab.hidden=YES;
        }
    }
    [cell loadDataWithModel:model andIndex:indexPath.section+1];
    cell.checkBtn.tag=indexPath.section+200;
    [cell.checkBtn addTarget:self action:@selector(checkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark 认领或申诉点击事件
-(void)checkBtnClick:(UIButton *)sender{
    DDCompanyBuilderModel *model=_dataSourceArr[sender.tag-200];
    DDPersonalClaimBenefitVC *vc=[[DDPersonalClaimBenefitVC alloc]init];
    vc.claimBenefitType = DDClaimBenefitTypeDefault;
    vc.peopleName = model.name;
    vc.peopleId = model.staff_info_id;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DDCompanyBuilderModel *model=_dataSourceArr[indexPath.section];

    DDBuilderDetailInfoVC *vc=[[DDBuilderDetailInfoVC alloc]init];
    vc.staffInfoId=model.staff_info_id;
    if ([self.certLevel isEqualToString:@"1"]) {
        vc.type=@"0";
        vc.nameStr = @"build1";
    }
    else{
        vc.type=@"1";
        vc.nameStr = @"build2";
    }
    vc.specialityCode=model.cert_type_id;
    vc.titleStr = [NSString stringWithFormat:@"%@%@的证书",model.cert_level,model.name];
    [self.navigationController pushViewController:vc animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 155+30+30;
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
        if (self.isAllSearch) {
            _arrowImg.image=[UIImage imageNamed:@"home_search_up"];
        }else {
            _arrowImg.image=[UIImage imageNamed:@"jiantou_h"];
        }
        
        _majorSelectView=[[DDMajorSelectView alloc]initWithFrame:CGRectMake(0, 45, Screen_Width, Screen_Height-KNavigationBarHeight-45)];
        _majorSelectView.type=self.certLevel;
        _majorSelectView.certiType=_certType;
        _majorSelectView.status=_status;
        __weak __typeof(self) weakSelf=self;
        _majorSelectView.hiddenBlock = ^{
            
            if (weakSelf.isAllSearch) {
                weakSelf.arrowImg.image=[UIImage imageNamed:@"home_search_down"];
                weakSelf.majorLab.textColor = KColorBlackTitle;
            }else {
                weakSelf.arrowImg.image=[UIImage imageNamed:@"jiantou"];
                weakSelf.majorLab.textColor = kColorBlue;
            }
            [weakSelf.majorSelectView hiddenActionSheet];
            
            _isMajorSelect=NO;
        };
        _majorSelectView.delegate=self;
        [_majorSelectView show];
        
        _isMajorSelect=YES;
    }
    else{
        
        if (self.isAllSearch) {
            _arrowImg.image=[UIImage imageNamed:@"home_search_down"];
        }else {
            _arrowImg.image=[UIImage imageNamed:@"jiantou"];
        }
        [_majorSelectView hiddenActionSheet];
        
        _isMajorSelect=NO;
    }
}

-(void)actionsheetDisappear:(DDMajorSelectView *)actionSheet andCode:(NSString *)code andStatus:(NSString *)status{
    _certType=code;
    _status=status;
    //_majorLab.text=string;
    if ([DDUtils isEmptyString:code] && [DDUtils isEmptyString:status]) {
        self.isAllSearch = YES;
    }else {
        self.isAllSearch = NO;
    }
    _hud=[DDUtils showHUDCustom:@""];
    [self requestData];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:KRefreshUI object:nil];
}

@end
