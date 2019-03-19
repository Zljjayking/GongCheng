//
//  DDArchitectListVC.m
//  GongChengDD
//
//  Created by xzx on 2018/9/25.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDArchitectListVC.h"
#import "DataLoadingView.h"
#import "DDNoResult2View.h"//无数据视图
#import "MJRefresh.h"
#import "DDArchitectModel.h"//model
#import "DDArchitectCell.h"//cell
#import "DDArchitectReceivedProjectsVC.h"//工程业绩列表页
#import "DDPersonalClaimBenefitVC.h"//认领页面
#import "DDArchitectDetailInfoVC.h"//建筑师等人员详情页面

@interface DDArchitectListVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

{
    NSInteger currentPage;
    NSInteger pageCount;
    NSMutableArray *_dataSourceArr;
    NSMutableDictionary *_dict;
    
    NSString *_staffName;
    
    UILabel *_leftLab;//"共"字的label
    UILabel *_numLabel;//总计数量label
    UILabel *_rightLab;//"个公司"三个字的label
    
    MBProgressHUD *_hud;
}
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) DataLoadingView *loadingView;
@property (nonatomic,strong) DDNoResult2View *noResultView;//无数据视图

@end

@implementation DDArchitectListVC


- (void)viewDidLoad {
    [super viewDidLoad];
    _staffName=@"";
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
        self.title=@"一级结构师";
    }
    else if ([self.type isEqualToString:@"2"]) {
        self.title=@"二级结构师";
    }
    else if ([self.type isEqualToString:@"3"]) {
        self.title=@"化工工程师";
    }
    else if ([self.type isEqualToString:@"4"]) {
        self.title=@"一级建筑师";
    }
    else if ([self.type isEqualToString:@"5"]) {
        self.title=@"二级建筑师";
    }
    self.view.backgroundColor=kColorBackGroundColor;
    self.navigationItem.leftBarButtonItem=[DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
}

//返回上一页面
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

//筛选按钮
-(void)createChooseBtns{
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 45)];
    bgView.backgroundColor=kColorWhite;
    [self.view addSubview:bgView];
    
    
    UIView *leftView=[[UIView alloc]initWithFrame:CGRectMake(12, 7.5, Screen_Width-24, 30)];
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
        _rightLab.text=@"个一级结构师证书";
    }
    else if ([self.type isEqualToString:@"2"]) {
        _rightLab.text=@"个二级结构师证书";
    }
    else if ([self.type isEqualToString:@"3"]) {
        _rightLab.text=@"个化工工程师证书";
    }
    else if ([self.type isEqualToString:@"4"]) {
        _rightLab.text=@"个一级建筑师证书";
    }
    else if ([self.type isEqualToString:@"5"]) {
        _rightLab.text=@"个二级建筑师证书";
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
    [params setValue:[NSString stringWithFormat:@"%ld",currentPage] forKey:@"current"];
    [params setValue:@"10" forKey:@"size"];
    
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_companyArchitectList params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"**********1一级结构师 2二级结构师 3化工工程师 4一级建筑师 5二级建筑师结果数据***************%@",responseObject);
        
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
                    DDArchitectModel *model = [[DDArchitectModel alloc]initWithDictionary:dic error:nil];
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
                    [_noResultView showWithTitle:@"暂无相关一级结构师的信息" subTitle:@"去其他地方看看~" image:@"noResult_person"];
                }
                else if ([self.type isEqualToString:@"2"]) {
                    [_noResultView showWithTitle:@"暂无相关二级结构师的信息" subTitle:@"去其他地方看看~" image:@"noResult_person"];
                }
                else if ([self.type isEqualToString:@"3"]) {
                    [_noResultView showWithTitle:@"暂无相关化工工程师的信息" subTitle:@"去其他地方看看~" image:@"noResult_person"];
                }
                else if ([self.type isEqualToString:@"4"]) {
                    [_noResultView showWithTitle:@"暂无相关一级建筑师的信息" subTitle:@"去其他地方看看~" image:@"noResult_person"];
                }
                else if ([self.type isEqualToString:@"5"]) {
                    [_noResultView showWithTitle:@"暂无相关二级建筑师的信息" subTitle:@"去其他地方看看~" image:@"noResult_person"];
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
    [params setValue:[NSString stringWithFormat:@"%ld",currentPage] forKey:@"current"];
    [params setValue:@"10" forKey:@"size"];
    
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_companyArchitectList params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"**********1一级结构师 2二级结构师 3化工工程师 4一级建筑师 5二级建筑师结果数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        __weak __typeof(self) weakSelf = self;
        if (response.isSuccess) {
            
            _dict = responseObject[KData];
            NSArray *listArr = _dict[@"list"];
            for (NSDictionary *dic in listArr) {
                DDArchitectModel *model = [[DDArchitectModel alloc]initWithDictionary:dic error:nil];
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
    DDArchitectModel *model=_dataSourceArr[indexPath.section];
    
    static NSString * cellID = @"DDArchitectCell";
    DDArchitectCell * cell = (DDArchitectCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
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
    DDArchitectModel *model=_dataSourceArr[sender.tag-200];
    DDPersonalClaimBenefitVC *vc=[[DDPersonalClaimBenefitVC alloc]init];
    vc.claimBenefitType = DDClaimBenefitTypeDefault;
    vc.peopleName = model.name;
    vc.peopleId = model.staff_info_id;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DDArchitectModel *model=_dataSourceArr[indexPath.section];

    DDArchitectDetailInfoVC *vc=[[DDArchitectDetailInfoVC alloc]init];
    vc.staffInfoId=model.staff_info_id;
    //1一级结构师 2二级结构师 3化工工程师列表 4一级建筑师 5二级建筑师
    if ([self.type isEqualToString:@"1"]) {
        vc.type=@"3";
        vc.nameStr=@"nomajor1";
    }
    else if ([self.type isEqualToString:@"2"]) {
        vc.type=@"4";
        vc.nameStr=@"nomajor2";
    }
    else if ([self.type isEqualToString:@"3"]) {
        vc.type=@"5";
        vc.nameStr=@"nomajor3";
    }
    else if ([self.type isEqualToString:@"4"]) {
        vc.type=@"6";
        vc.nameStr=@"nomajor4";
    }
    else if ([self.type isEqualToString:@"5"]) {
        vc.type=@"7";
        vc.nameStr=@"nomajor5";
    }
    vc.specialCodeStr=model.cert_no;
    vc.certiId=model.certId;
    vc.titleStr = [NSString stringWithFormat:@"%@%@的证书",self.title,model.name];
    [self.navigationController pushViewController:vc animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 155;
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

-(void)textFieldDidEndEditing:(UITextField *)textField{
    _staffName=textField.text;
    [self requestData];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:KRefreshUI object:nil];
}

@end
