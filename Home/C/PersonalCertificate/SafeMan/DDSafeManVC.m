//
//  DDSafeManVC.m
//  GongChengDD
//
//  Created by xzx on 2018/6/5.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDSafeManVC.h"
#import "DataLoadingView.h"
#import "DDNoResult2View.h"//无数据视图
#import "MJRefresh.h"
#import "DDSafeManCell.h"//cell
#import "DDCompanySafemanModel.h"//model
#import "DDSafeLevelSelectView.h"//类别筛选View"
#import "DDPersonalClaimBenefitVC.h"//认领页面
#import "DDSafeManDetailVC.h"//安全员详情页面
#import "DDCertiExplainVC.h"//申述页面
#import "DDPeopleDetailVC.h"
#import "DDSafeManMoreTrainVC.h"//安全员报名列表
#import "DDMyEnterpriseVC.h"//认领公司列表
#import "DDAlertView.h"
#import "DDAffirmEnterpriseVC.h"//认领公司
@interface DDSafeManVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,SafeLevelSelectViewDelegate>

{    
    NSInteger currentPage;
    NSInteger pageCount;
    NSMutableArray *_dataSourceArr;
    NSMutableDictionary *_dict;
    
    NSString *_staffName;
    NSString *_certType;
    NSString *_status;
    
    BOOL _isSafeLevelSelect;
    
    UILabel *_leftLab;//"搜索到"三个字的label
    UILabel *_numLabel;//总计数量label
    UILabel *_rightLab;//"个公司"三个字的label
    
    MBProgressHUD *_hud;
}
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) DataLoadingView *loadingView;
@property (nonatomic,strong) DDNoResult2View *noResultView;//无数据视图
@property (nonatomic,strong) UIImageView *arrowImg;//放右边那个专业选择小箭头
@property (strong,nonatomic) DDSafeLevelSelectView *safeLevelSelectView;
@property (nonatomic,strong) UILabel *majorLab;//放右边那个专业选择结果

@end

@implementation DDSafeManVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _staffName=@"";
    _certType=@"";
    _status=@"";
    _isSafeLevelSelect=NO;
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
    self.title=@"安全员";
    self.view.backgroundColor=kColorBackGroundColor;
    self.navigationItem.leftBarButtonItem=[DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
    if([_isOpen integerValue] != 0){
        self.navigationItem.rightBarButtonItem=[DDUtils rightbuttonItemWithTitle:@"考试培训" target:self action:@selector(rightButtonClick)];
    }
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
        DDSafeManMoreTrainVC *safeManMoreTrain=[[DDSafeManMoreTrainVC alloc]init];
        safeManMoreTrain.companyID = _enterpriseId;
        [self.navigationController pushViewController:safeManMoreTrain animated:YES];
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
    [_safeLevelSelectView hiddenActionSheet];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidDisappear:(BOOL)animated{
    if (self.navigationController==NULL) {
        [_safeLevelSelectView hiddenActionSheet];
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
    [textField setValue:KColorGreyLight forKeyPath:@"_placeholderLabel.textColor"];
    [textField setValue:kFontSize30 forKeyPath:@"_placeholderLabel.font"];
    textField.textColor=KColorBlackSubTitle;
    textField.font=kFontSize30;
    textField.placeholder=@"姓名、证书号";
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
    
    _rightLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_numLabel.frame)+2, 15, 100, 15)];
    _rightLab.text=@"个安全员证书";
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
    [params setValue:_staffName forKey:@"staffName"];
    [params setValue:_certType forKey:@"certType"];
    [params setValue:_status forKey:@"status"];
    [params setValue:[NSString stringWithFormat:@"%ld",currentPage] forKey:@"current"];
    [params setValue:@"10" forKey:@"size"];
    
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_companySafemanList params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"**********安全员结果数据***************%@",responseObject);
        
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
            _rightLab.frame=CGRectMake(CGRectGetMaxX(_numLabel.frame)+2, 15, 100, 15);
            
            if (listArr.count!=0) {
                [_noResultView hide];
                
                for (NSDictionary *dic in listArr) {
                    DDCompanySafemanModel *model = [[DDCompanySafemanModel alloc]initWithDictionary:dic error:nil];
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
                [_noResultView showWithTitle:@"暂无相关安全员的信息" subTitle:@"去其他地方看看~" image:@"noResult_person"];
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
    [params setValue:_staffName forKey:@"staffName"];
    [params setValue:_certType forKey:@"certType"];
    [params setValue:_status forKey:@"status"];
    [params setValue:[NSString stringWithFormat:@"%ld",currentPage] forKey:@"current"];
    [params setValue:@"10" forKey:@"size"];
    
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_companySafemanList params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"**********安全员结果数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        __weak __typeof(self) weakSelf = self;
        if (response.isSuccess) {
            
            _dict = responseObject[KData];
            NSArray *listArr = _dict[@"list"];
            for (NSDictionary *dic in listArr) {
                DDCompanySafemanModel *model = [[DDCompanySafemanModel alloc]initWithDictionary:dic error:nil];
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
    DDCompanySafemanModel *model=_dataSourceArr[indexPath.section];
    
    static NSString * cellID = @"DDSafeManCell";
    DDSafeManCell * cell = (DDSafeManCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
    }
    
    [cell loadDataWithModel:model andIndex:indexPath.section];
    cell.checkBtn.tag=indexPath.section+200;
    [cell.checkBtn addTarget:self action:@selector(checkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark 认领点击事件
-(void)checkBtnClick:(UIButton *)sender{
    DDCompanySafemanModel *model=_dataSourceArr[sender.tag-200];
    DDPersonalClaimBenefitVC *vc=[[DDPersonalClaimBenefitVC alloc]init];
    vc.claimBenefitType = DDClaimBenefitTypeDefault;
    vc.peopleName = model.name;
    vc.peopleId = model.staff_info_id;
    [self.navigationController pushViewController:vc animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 155+30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DDCompanySafemanModel *model=_dataSourceArr[indexPath.section];
    DDSafeManDetailVC *detail=[[DDSafeManDetailVC alloc]init];
    detail.staffInfoId=model.staff_info_id;
    detail.certiId=model.certId;
    detail.titleStr = [NSString stringWithFormat:@"安全员%@的证书",model.name];
    [self.navigationController pushViewController:detail animated:YES];
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
    if (_isSafeLevelSelect==NO) {
        
    }
    else{
        _arrowImg.image=[UIImage imageNamed:@"home_search_down"];
        
        [_safeLevelSelectView hiddenActionSheet];
        
        _isSafeLevelSelect=NO;
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    _staffName=textField.text;

    [self requestData];
}

#pragma mark 弹出专业筛选视图
-(void)majorSelectClick{
    if (_isSafeLevelSelect==NO) {
        _arrowImg.image=[UIImage imageNamed:@"home_search_up"];
        
        _safeLevelSelectView=[[DDSafeLevelSelectView alloc]initWithFrame:CGRectMake(0, 45, Screen_Width, Screen_Height-KNavigationBarHeight-45)];
        _safeLevelSelectView.certiType=_certType;
        _safeLevelSelectView.status=_status;
        __weak __typeof(self) weakSelf=self;
        _safeLevelSelectView.hiddenBlock = ^{
            weakSelf.arrowImg.image=[UIImage imageNamed:@"home_search_down"];
            
            [weakSelf.safeLevelSelectView hiddenActionSheet];
            
            _isSafeLevelSelect=NO;
        };
        _safeLevelSelectView.delegate=self;
        [_safeLevelSelectView show];
        
        _isSafeLevelSelect=YES;
    }
    else{
        _arrowImg.image=[UIImage imageNamed:@"home_search_down"];
        
        [_safeLevelSelectView hiddenActionSheet];
        
        _isSafeLevelSelect=NO;
    }
}

-(void)actionsheetDisappear:(DDSafeLevelSelectView *)actionSheet andLevel:(NSString *)level andStatus:(NSString *)status{
//    if ([level isEqualToString:@"全部"]) {
//        _certType=@"";
//    }
//    else{
//        _certType=level;
//    }
//
//    _majorLab.text=level;
    
    
    _certType=level;
    _status=status;
    
    _hud=[DDUtils showHUDCustom:@""];
    [self requestData];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:KRefreshUI object:nil];
}

@end
