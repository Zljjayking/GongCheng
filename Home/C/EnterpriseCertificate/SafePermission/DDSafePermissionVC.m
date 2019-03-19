//
//  DDSafePermissionVC.m
//  GongChengDD
//
//  Created by csq on 2017/12/1.
//  Copyright © 2017年 Koncendy. All rights reserved.
//

#import "DDSafePermissionVC.h"
#import "DataLoadingView.h"
#import "DDSafePermissionModel.h"
#import "DDDateUtil.h"
#import "DDBusinesslicenseTitleCell.h"//1个标题的cell
#import "DDNoResult2View.h"
#import "DDServiceWebViewVC.h"
@interface DDSafePermissionVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)DataLoadingView * loadingView;
@property (nonatomic,strong) DDNoResult2View *noResultView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong)DDSafePermissionModel * model;
@end

@implementation DDSafePermissionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kColorBackGroundColor;
    
    self.navigationItem.title = @"安全生产许可证";
    self.navigationItem.leftBarButtonItem = [DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
//    self.navigationItem.rightBarButtonItem=[DDUtils rightbuttonItemWithTitle:@"安许证办理" target:self action:@selector(certiHandleClick)];
    
    [self setupTableView];
    [self setupLoadingView];
    [self requestData];
}
#pragma mark 安许证办理点击事件
//-(void)certiHandleClick{
//    DDServiceWebViewVC *checkVC = [DDServiceWebViewVC new];
//    checkVC.hostUrl = @"http://gcdd.koncendy.com/apphs/enterprise_service/pages/handle_list.html?groupId=2";
//    [self.navigationController pushViewController:checkVC animated:YES];
//}
- (void)setupTableView{
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,0, Screen_Width, Screen_Height-KNavigationBarHeight) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor=[UIColor clearColor];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
//    [self.tableView setSeparatorColor:KColorTableSeparator];
    self.tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width,KTableViewFooterViewHeight)];
    [self.view addSubview:self.tableView];
}
- (void)setupLoadingView{
    __weak __typeof(self) weakSelf = self;
    
    _noResultView=[[DDNoResult2View alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-KNavigationBarHeight)];
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
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:_enterpriseId forKey:@"enterpriseId"];
    
    [[DDHttpManager sharedInstance] sendPostRequest:KHttpRequest_getSafetyLicenceDetails params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            [_loadingView hiddenLoadingView];
            
            if (response.isEmpty == NO) {
                [_noResultView hide];
                _model = [[DDSafePermissionModel alloc] initWithDictionary:response.data error:nil];
            }else{
                //空数据
                 [_noResultView showWithTitle:@"暂无安许证相关信息" subTitle:nil image:@"noResult_content"];
            }
            
        }else{
            [_loadingView failureLoadingView];
            [DDUtils showToastWithMessage:response.message];
        }
        [_tableView reloadData];
    } failure:^(NSURLSessionDataTask *operation, id responseObject) {
        [DDUtils showToastWithMessage:kRequestFailed];
        [_loadingView failureLoadingView];
    }];
    
}
#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 4;
    }else if (section == 1){
        return 4;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //1个标题的cell
    static NSString * titleCellID = @"DDBusinesslicenseTitleCell";
    DDBusinesslicenseTitleCell * titleCell = (DDBusinesslicenseTitleCell*)[tableView dequeueReusableCellWithIdentifier:titleCellID];
    if (titleCell == nil) {
        titleCell = [[[NSBundle mainBundle]loadNibNamed:titleCellID owner:self options:nil] firstObject];
    }
    titleCell.selectionStyle = UITableViewCellSelectionStyleNone;
//    titleCell.bottomLine.hidden = YES;
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        titleCell.titleLab.text = @"证书编号";
        titleCell.contentLab.text = _model.certificateNo;;
    }
    if (indexPath.section == 0 && indexPath.row == 1) {
        titleCell.titleLab.text = @"单位名称";
        titleCell.contentLab.text = _model.enterpriseNameSource;
    }
    if (indexPath.section == 0 && indexPath.row == 2) {
        titleCell.titleLab.text = @"主要负责人";
        titleCell.contentLab.text = _model.mainHead;
    }
    if (indexPath.section == 0 && indexPath.row == 3) {
        titleCell.titleLab.text = @"单位地址";
        titleCell.contentLab.text = _model.unitAddressSource;
    }
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        titleCell.titleLab.text = @"经济类型";
        titleCell.contentLab.text = _model.economicTypeSource;
    }
    if (indexPath.section == 1 && indexPath.row == 1) {
        titleCell.titleLab.text = @"许可范围";
        titleCell.contentLab.text = _model.licenseRange;
    }
    if (indexPath.section == 1 && indexPath.row == 2) {
        titleCell.titleLab.text = @"证书有效期";
        //过滤掉异常时间
        NSString * resultDateString = [DDDateUtil replaceUnNormalDateString:_model.validityPeriodEnd];
        if (![DDUtils isEmptyString:resultDateString]){
            titleCell.contentLab.text= [DDUtils getDateLineByStandardTime:resultDateString];
            //0表示已过期，1表示180日之内，2表示超过180日
            if (![DDUtils isEmptyString:_model.validityPeriodEnd]) {
                if (_model.validityPeriodEnd.length>=10) {
                    NSString *timeStr = [NSString stringWithFormat:@"%@",[_model.validityPeriodEnd substringToIndex:10]];
                    NSString *resultStr = [DDUtils newCompareTimeSpaceIn180:timeStr];
                    if ([resultStr isEqualToString:@"2"]) {
                        titleCell.contentLab.textColor = KColorFindingPeopleBlue;
                    }
                    else if([resultStr isEqualToString:@"1"]){
                        titleCell.contentLab.textColor = KColorTextOrange;
                    }
                    else{
                        titleCell.contentLab.textColor = kColorRed;
                    }
                }
            }
        }
    }
    if (indexPath.section == 1 && indexPath.row == 3) {
        titleCell.titleLab.text =@"发证机关";
        titleCell.contentLab.text = _model.issuedDeptSource;
    }
    
    return titleCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 3) {
      
        return [DDBusinesslicenseTitleCell heightWithContent:_model.unitAddressSource];
    }else{
        return [DDBusinesslicenseTitleCell heightWithContent:nil];
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

#pragma mark 返回上一页
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
