//
//  DDSimpleCancelVC.m
//  GongChengDD
//
//  Created by xzx on 2018/10/22.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDSimpleCancelVC.h"
#import "DDLabelUtil.h"
#import "MJRefresh.h"
#import "DDNavigationUtil.h"
#import "DataLoadingView.h"//加载页面
#import "DDTaxIllegalDetail1Cell.h"//cell
#import "DDTaxIllegalDetail2Cell.h"//cell
#import "DDSimpleCancelModel.h"//model
#import "DDAdminPunishDetailVC.h"//行政处罚详情页面
#import "DDProjectCheckOriginWebVC.h"//查看详情页面

@interface DDSimpleCancelVC ()<UITableViewDelegate,UITableViewDataSource>

{
    NSInteger _number1;
    NSInteger _number2;
    NSInteger _number3;
    BOOL _objectInfo;
}
@property (nonatomic,strong) DataLoadingView *loadingView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) DDSimpleCancelModel *model;

@end

@implementation DDSimpleCancelVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _number1=5;
    _number2=3;
    _number3=1;
    _objectInfo=YES;
    [self editNavItem];
    [self createTableView];
    [self createLoadView];
    [self requestData];
}

-(void)editNavItem{
    self.title=@"简易注销公告详情";
    self.view.backgroundColor=kColorBackGroundColor;
    self.navigationItem.leftBarButtonItem=[DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
}

//返回上一页面
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 创建加载视图
-(void)createLoadView{
    __weak __typeof(self) weakSelf=self;
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
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:self.enterpriseId forKey:@"enterpriseId"];
    //[params setValue:self.toAction forKey:@"toAction"];
    
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_simpleCancelNotice params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"**********简易注销公告详情结果数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            [_loadingView hiddenLoadingView];
            
            if ([response.data isKindOfClass:[NSDictionary class]]) {
                _model = [[DDSimpleCancelModel alloc] initWithDictionary:response.data error:nil];
                if ([DDUtils isEmptyString:_model.notice.objectionName] && [DDUtils isEmptyString:_model.notice.objectionTime] && [DDUtils isEmptyString:_model.notice.objectionContent]) {//三个都为空时异议信息不展开
                    _objectInfo=NO;
                }
            }
            
        }else{
            [_loadingView failureLoadingView];
            [DDUtils showToastWithMessage:response.message];
        }
        [_tableView reloadData];
        
    }  failure:^(NSURLSessionDataTask *operation, id responseObject)  {
        [DDUtils showToastWithMessage:kRequestFailed];
        [_loadingView failureLoadingView];
    }];
}

//创建tableView
-(void)createTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-KNavigationBarHeight) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=kColorBackGroundColor;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.estimatedRowHeight = 44;
    _tableView.separatorColor=KColorTableSeparator;
    
//    __weak __typeof(self) weakSelf=self;
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [weakSelf requestData];
//    }];
}

#pragma mark tableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return _number1;
    }
    else if(section==1){
        if (_objectInfo==YES) {
            return _number2;
        }
        else{
            return 0;
        }
    }
    else{
        return _number3;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        static NSString * cellID = @"DDTaxIllegalDetail1Cell";
        DDTaxIllegalDetail1Cell * cell = (DDTaxIllegalDetail1Cell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
        }
        
        if (indexPath.row==0) {
            cell.firstLab.text=@"企业名称";
            if (![DDUtils isEmptyString:_model.entName]) {
                cell.secondLab.text=_model.entName;
            }
            else{
                cell.secondLab.text=@"-";
            }
        }
        else if (indexPath.row==1) {
            cell.firstLab.text=@"统一社会信用代码/注册号";
            if (![DDUtils isEmptyString:_model.code]) {
                cell.secondLab.text=_model.code;
            }
            else{
                cell.secondLab.text=@"-";
            }
        }
        else if (indexPath.row==2) {
            cell.firstLab.text=@"登记机关";
            if (![DDUtils isEmptyString:_model.dept]) {
                cell.secondLab.text=_model.dept;
            }
            else{
                cell.secondLab.text=@"-";
            }
        }
        else if (indexPath.row==3) {
            cell.firstLab.text=@"公告期";
            if (![DDUtils isEmptyString:_model.notice.publishTime]) {
                cell.secondLab.text=_model.notice.publishTime;
            }
            else{
                cell.secondLab.text=@"-";
            }
        }
        else if (indexPath.row==4) {
            cell.firstLab.text=@"全体投资人承诺书";
            //cell.secondLab.text=@"查看详情";
            UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(cell.firstLab.frame)+12, 70, 15)];
            [btn setTitle:@"查看详情" forState:UIControlStateNormal];
            [btn setTitleColor:kColorBlue forState:UIControlStateNormal];
            btn.titleLabel.font=kFontSize32;
            [btn addTarget:self action:@selector(checkDetailClick) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:btn];
        }
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if(indexPath.section==1){
        static NSString * cellID = @"DDTaxIllegalDetail1Cell";
        DDTaxIllegalDetail1Cell * cell = (DDTaxIllegalDetail1Cell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
        }
        
        if (indexPath.row==0) {
            cell.firstLab.text=@"异议申请人";
            if (![DDUtils isEmptyString:_model.notice.objectionName]) {
                cell.secondLab.text=_model.notice.objectionName;
            }
            else{
                cell.secondLab.text=@"-";
            }
        }
        else if (indexPath.row==1) {
            cell.firstLab.text=@"异议时间";
            if (![DDUtils isEmptyString:_model.notice.objectionTime]) {
                cell.secondLab.text=_model.notice.objectionTime;
            }
            else{
                cell.secondLab.text=@"-";
            }
        }
        else if (indexPath.row==2) {
            cell.firstLab.text=@"异议内容";
            if (![DDUtils isEmptyString:_model.notice.objectionContent]) {
                cell.secondLab.text=_model.notice.objectionContent;
            }
            else{
                cell.secondLab.text=@"-";
            }
        }
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    else{
        static NSString * cellID = @"DDTaxIllegalDetail2Cell";
        DDTaxIllegalDetail2Cell * cell = (DDTaxIllegalDetail2Cell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
        }
        
        cell.leftFirstLab.text=@"简易注销结果";
        if (![DDUtils isEmptyString:_model.notice.cancelResult]) {
            cell.leftSecondLab.text=_model.notice.cancelResult;
        }
        else{
            cell.leftSecondLab.text=@"-";
        }
        cell.rightFirstLab.text=@"公告申请日期";
        if (![DDUtils isEmptyString:_model.notice.cancelTime]) {
            cell.rightSecondLab.text=_model.notice.cancelTime;
        }
        else{
            cell.rightSecondLab.text=@"-";
        }
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 82;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 47)];
    headView.backgroundColor=kColorWhite;
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(12, 0, Screen_Width/2, 47)];
    if (section==0) {
        label.text=@"企业公告信息";
    }
    else if(section==1){
        label.text=@"异议信息";
    }
    else{
        label.text=@"企业公告信息";
    }
    label.textColor=KColorBlackTitle;
    label.font=KfontSize32Bold;
    [headView addSubview:label];
    
    UIImageView *arrowImg=[[UIImageView alloc]initWithFrame:CGRectMake(Screen_Width-12-15, 16, 15, 15)];
    if (section==0) {
        if (_number1==0) {
            arrowImg.image=[UIImage imageNamed:@"home_simpleCancel_down"];
        }
        else{
            arrowImg.image=[UIImage imageNamed:@"home_simpleCancel_up"];
        }
        UIButton *btn1=[[UIButton alloc]initWithFrame:CGRectMake(Screen_Width-12-47, 0, 47, 47)];
        [btn1 addTarget:self action:@selector(section1Click) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:btn1];
    }
    else if(section==1){
        if (_objectInfo==YES) {
            if (_number2==0) {
                arrowImg.image=[UIImage imageNamed:@"home_simpleCancel_down"];
            }
            else{
                arrowImg.image=[UIImage imageNamed:@"home_simpleCancel_up"];
            }
            UIButton *btn2=[[UIButton alloc]initWithFrame:CGRectMake(Screen_Width-12-47, 0, 47, 47)];
            [btn2 addTarget:self action:@selector(section2Click) forControlEvents:UIControlEventTouchUpInside];
            [headView addSubview:btn2];
        }
        else{
            arrowImg.hidden=YES;
            UILabel *tip=[[UILabel alloc]initWithFrame:CGRectMake(Screen_Width-12-20, 13.5, 20, 20)];
            tip.text=@"无";
            tip.textColor=KColorGreySubTitle;
            tip.font=kFontSize30;
            tip.textAlignment=NSTextAlignmentCenter;
            [headView addSubview:tip];
        }
    }
    else{
        if (_number3==0) {
            arrowImg.image=[UIImage imageNamed:@"home_simpleCancel_down"];
        }
        else{
            arrowImg.image=[UIImage imageNamed:@"home_simpleCancel_up"];
        }
        UIButton *btn3=[[UIButton alloc]initWithFrame:CGRectMake(Screen_Width-12-47, 0, 47, 47)];
        [btn3 addTarget:self action:@selector(section3Click) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:btn3];
    }
    [headView addSubview:arrowImg];
    
    
    return headView;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 47;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 15;
}

-(void)section1Click{
    if (_number1==0) {
        _number1=5;
    }
    else{
        _number1=0;
    }
    [_tableView reloadData];
}

-(void)section2Click{
    if (_number2==0) {
        _number2=3;
    }
    else{
        _number2=0;
    }
    [_tableView reloadData];
}

-(void)section3Click{
    if (_number3==0) {
        _number3=1;
    }
    else{
        _number3=0;
    }
    [_tableView reloadData];
}

-(void)checkDetailClick{
    DDProjectCheckOriginWebVC *checkDetail=[[DDProjectCheckOriginWebVC alloc]init];
    checkDetail.hostUrl=_model.notice.url;
    [self.navigationController pushViewController:checkDetail animated:YES];
}


@end
