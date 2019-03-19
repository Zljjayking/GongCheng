//
//  DDWorkingLawDetailVC.m
//  GongChengDD
//
//  Created by csq on 2018/9/20.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDWorkingLawDetailVC.h"
#import "DataLoadingView.h"
#import "DDManageDetailSingleTitleCell.h"//只有1个标题的cell
#import "DDBusinesslicenseTitleCell.h"//1个标题的cell,有内容
#import "DDBusinesslicenseTwoTitleCell.h"//2个标题的cell,有内容
#import "DDWorkingLawDetailModel.h"
#import "DDFinishUnitCell.h"
#import "DDDateUtil.h"
#import "DDServiceWebViewVC.h"

@interface DDWorkingLawDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)DataLoadingView * loadingView;
@property (nonatomic,strong)DDWorkingLawDetailModel * model;
@end

@implementation DDWorkingLawDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kColorBackGroundColor;
    self.navigationItem.title = @"施工工法详情";
    self.navigationItem.leftBarButtonItem = [DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
    self.navigationItem.rightBarButtonItem=[DDUtils rightbuttonItemWithTitle:@"辅助证书" target:self action:@selector(supportClick)];
    [self setupTableView];
    [self setupDataLoadingView];
    [self requestData];
}
-(void)supportClick{
    DDServiceWebViewVC *checkVC = [DDServiceWebViewVC new];
    checkVC.hostUrl = @"http://gcdd.koncendy.com/apphs/enterprise_service/pages/handle_list.html?groupId=10";
    [self.navigationController pushViewController:checkVC animated:YES];
}
#pragma mark 设置tableView
-(void)setupTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,0, Screen_Width, Screen_Height-KNavigationBarHeight) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.separatorColor = KColorTableSeparator;
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width,KTableViewFooterViewHeight)];
    [self.view addSubview:_tableView];
}
- (void)setupDataLoadingView{
    __weak __typeof(self) weakSelf = self;
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
    [params setValue:_passValueID forKey:@"id"];
    
    [[DDHttpManager sharedInstance] sendGetRequest:KHttpRequest_constructionMethodInfo params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"**********施工工法详情数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            [_loadingView hiddenLoadingView];
            
            if ([response.data isKindOfClass:[NSDictionary class]]) {
                _model = [[DDWorkingLawDetailModel alloc] initWithDictionary:response.data error:nil];
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
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 4;
    }
    if (section == 1) {
        return (_model.completionEnt.count+1);
    }
    if (section == 2) {
        return 1;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //只有1个标题的cell
    static NSString * singleTitleCellID = @"DDManageDetailSingleTitleCell";
    DDManageDetailSingleTitleCell * singleTitleCell = (DDManageDetailSingleTitleCell*)[tableView dequeueReusableCellWithIdentifier:singleTitleCellID];
    if (singleTitleCell == nil) {
        singleTitleCell = [[[NSBundle mainBundle] loadNibNamed:singleTitleCellID owner:self options:nil] firstObject];
    }
    singleTitleCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //1个标题的cell 有内容
    static NSString * titleCellID = @"DDBusinesslicenseTitleCell";
    DDBusinesslicenseTitleCell * titleCell = (DDBusinesslicenseTitleCell*)[tableView dequeueReusableCellWithIdentifier:titleCellID];
    if (titleCell == nil) {
        titleCell = [[[NSBundle mainBundle]loadNibNamed:titleCellID owner:self options:nil] firstObject];
    }
    titleCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //2个标题的cell 有内容
    static NSString * twoTitleCellID = @"DDBusinesslicenseTwoTitleCell";
    DDBusinesslicenseTwoTitleCell * twoTitleCell = (DDBusinesslicenseTwoTitleCell*)[tableView dequeueReusableCellWithIdentifier:twoTitleCellID];
    if (twoTitleCell == nil) {
        twoTitleCell = [[[NSBundle mainBundle]loadNibNamed:twoTitleCellID owner:self options:nil] firstObject];
    }
    twoTitleCell.selectionStyle = UITableViewCellSelectionStyleNone;
   
    
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        [singleTitleCell loadWithWorkLawDetailName:_model.title];
        return singleTitleCell;
    }
    if (indexPath.section == 0 && indexPath.row == 1) {
        twoTitleCell.leftTitleLab.text = @"工法编号";
        if([DDUtils isEmptyString:_model.number]){
             twoTitleCell.leftContentLab.text = @"-";
        }else{
            twoTitleCell.leftContentLab.text = _model.number;
        }
        
       
        twoTitleCell.rightLab.text = @"工法级别";
        twoTitleCell.rightContentLab.textColor=KColorBlackTitle;
        twoTitleCell.rightContentLab.text = _model.awardYear;
        return twoTitleCell;
    }
    if (indexPath.section == 0 && indexPath.row == 2) {
        titleCell.titleLab.text = @"授予部门";
        titleCell.contentLab.text = _model.department;
        titleCell.topLine.hidden = YES;
        titleCell.bottomLine.hidden = YES;
        return titleCell;
    }
    if (indexPath.section == 0 && indexPath.row == 3){
        titleCell.titleLab.text = @"发布日期";
        titleCell.contentLab.text = _model.publishDate;
        titleCell.topLine.hidden = NO;
        titleCell.bottomLine.hidden = NO;
        return titleCell;
    }
    if (indexPath.section == 1 && indexPath.row == 0) {
        [singleTitleCell loadWithName:@"完成单位"];
        singleTitleCell.bottomLine.hidden = YES;
        return singleTitleCell;
    }
    if (indexPath.section == 1 && indexPath.row >0) {
        static NSString * finishUnitCellID = @"DDFinishUnitCell";
        DDFinishUnitCell * finishUnitCell = (DDFinishUnitCell*)[tableView dequeueReusableCellWithIdentifier:finishUnitCellID];
        if (finishUnitCell == nil) {
            finishUnitCell = [[[NSBundle mainBundle] loadNibNamed:finishUnitCellID owner:self options:nil] firstObject];
        }
        finishUnitCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        DDCompletionEntModel * entModel = _model.completionEnt[indexPath.row-1];
        [finishUnitCell loadWithContent:entModel.entName];
        return finishUnitCell;
    }
    if (indexPath.section == 2) {
        titleCell.titleLab.text = @"完成人";
        titleCell.contentLab.text = _model.completionPerson;
        titleCell.topLine.hidden = NO;
        titleCell.bottomLine.hidden = NO;
        return titleCell;
    }
    
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //只有1个标题的cell
    static NSString * singleTitleCellID = @"DDManageDetailSingleTitleCell";
    DDManageDetailSingleTitleCell * singleTitleCell = (DDManageDetailSingleTitleCell*)[tableView dequeueReusableCellWithIdentifier:singleTitleCellID];
    if (singleTitleCell == nil) {
        singleTitleCell = [[[NSBundle mainBundle] loadNibNamed:singleTitleCellID owner:self options:nil] firstObject];
    }
    singleTitleCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        [singleTitleCell loadWithWorkLawDetailName:_model.title];
        return [singleTitleCell height];
    }
    if (indexPath.section == 0 && indexPath.row == 1) {
         return [DDBusinesslicenseTwoTitleCell height];
    }
    if (indexPath.section == 0 && indexPath.row == 2) {
        return [DDBusinesslicenseTitleCell heightWithContent:nil];
    }
    if (indexPath.section == 0 && indexPath.row == 3){
        return [DDBusinesslicenseTitleCell heightWithContent:nil];
    }
    if (indexPath.section == 1 && indexPath.row == 0){
        [singleTitleCell loadWithName:@"完成单位"];
        return [singleTitleCell height];
    }
    if (indexPath.section == 1 && indexPath.row >0) {
        static NSString * finishUnitCellID = @"DDFinishUnitCell";
        DDFinishUnitCell * finishUnitCell = (DDFinishUnitCell*)[tableView dequeueReusableCellWithIdentifier:finishUnitCellID];
        if (finishUnitCell == nil) {
            finishUnitCell = [[[NSBundle mainBundle] loadNibNamed:finishUnitCellID owner:self options:nil] firstObject];
        }
        finishUnitCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        DDCompletionEntModel * entModel = _model.completionEnt[indexPath.row-1];
        [finishUnitCell loadWithContent:entModel.entName];
        return [finishUnitCell height];
    }
 
    if (indexPath.section == 2) {
        return [DDBusinesslicenseTitleCell heightWithContent:_model.completionPerson];
    }
  
    
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 15;
    }else{
        return 0.01;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView * header = [[UIView alloc] init];
        header.frame = CGRectMake(0, 0, Screen_Width, 15);
        return header;
    }else{
        return nil;
    }
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
//        //打开附件
//        DDWebViewController * webView = [[DDWebViewController alloc] init];
//        webView.URLString = _model.enclosureUrl;
//        [self.navigationController pushViewController:webView animated:YES];
    }
}
#pragma mark 返回上一页
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
