//
//  DDThreeACerDetailVC.m
//  GongChengDD
//
//  Created by csq on 2018/9/19.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDThreeACerDetailVC.h"
#import "DataLoadingView.h"
#import "DDManageDetailSingleTitleCell.h"//只有1个标题的cell
#import "DDBusinesslicenseTitleCell.h"//1个标题的cell,有内容
#import "DDBusinesslicenseTwoTitleCell.h"//2个标题的cell,有内容
#import "DDThreeACerDetailModel.h"
#import "DDWebViewController.h"
#import "DDDateUtil.h"
#import "ShowFullImageView.h"



@interface DDThreeACerDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)DataLoadingView * loadingView;
@property (nonatomic,strong)DDThreeACerDetailModel * model;
@end

@implementation DDThreeACerDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kColorBackGroundColor;
    self.navigationItem.title = @"AAA证书详情";
    self.navigationItem.leftBarButtonItem = [DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
    
    [self setupTableView];
    [self setupDataLoadingView];
    [self requestData];
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
    
    //    __weak __typeof(self) weakSelf = self;
    //    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    //        [weakSelf requestData];
    //    }];
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
    
    [[DDHttpManager sharedInstance] sendGetRequest:KHttpRequest_scenterpriseinfoaaaInfo params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"**********AAA证书详情数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            [_loadingView hiddenLoadingView];
            
            if ([response.data isKindOfClass:[NSDictionary class]]) {
                _model = [[DDThreeACerDetailModel alloc] initWithDictionary:response.data error:nil];
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
        return 5;
    }
    if (section == 1) {
        return 1;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
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
        titleCell.titleLab.text = @"企业名称";
        titleCell.contentLab.text = _model.enterpriseName;
        titleCell.topLine.hidden = YES;
        titleCell.bottomLine.hidden = NO;
        return titleCell;
    }
    if (indexPath.section == 0 && indexPath.row == 1) {
        titleCell.titleLab.text = @"发证单位";
        titleCell.contentLab.text = _model.unitName;
        titleCell.topLine.hidden = YES;
        titleCell.bottomLine.hidden = NO;
        return titleCell;
    }
    if (indexPath.section == 0 && indexPath.row == 2) {
        twoTitleCell.leftTitleLab.text = @"信用等级";
        twoTitleCell.leftContentLab.text = _model.level;
        twoTitleCell.rightLab.text = @"有效期";
        twoTitleCell.rightContentLab.text =  [DDUtils getDateLineByStandardTime:_model.validityPeriodEnd];
       
        //AAA证书有效期：
        //过滤掉异常时间
        NSString * resultDateString = [DDDateUtil replaceUnNormalDateString:_model.validityPeriodEnd];
        if (![DDUtils isEmptyString:resultDateString]){
            twoTitleCell.rightContentLab.textColor = [DDUtils enterpriseCertificateColorByDateString:resultDateString];
        }
        return twoTitleCell;
    }
    if (indexPath.section == 0 && indexPath.row == 3) {
        twoTitleCell.leftTitleLab.text = @"评级展望";
        twoTitleCell.leftContentLab.text = _model.ratingOutlook;
        twoTitleCell.rightLab.text = @"公告日期";
        twoTitleCell.rightContentLab.text = [DDUtils getDateLineByStandardTime: _model.noticeDate];

        return twoTitleCell;
    }
    if (indexPath.section == 0 && indexPath.row == 4) {
        titleCell.titleLab.text = @"评级级别";
        titleCell.contentLab.text = _model.type;
        titleCell.topLine.hidden = YES;
        titleCell.bottomLine.hidden = NO;
        return titleCell;
    }
    if (indexPath.section == 1 ) {
        titleCell.titleLab.text = @"附件";
        titleCell.contentLab.text = _model.enclosure;
        titleCell.contentLab.textColor = kColorBlue;
        titleCell.topLine.hidden = YES;
        titleCell.bottomLine.hidden = NO;
        return titleCell;
    }
    
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return [DDBusinesslicenseTitleCell heightWithContent:nil];
    }
    if (indexPath.section == 0 && indexPath.row == 1) {
        return [DDBusinesslicenseTitleCell heightWithContent:nil];
    }
    if (indexPath.section == 0 && indexPath.row == 2) {
        return [DDBusinesslicenseTwoTitleCell height];
    }
    if (indexPath.section == 0 && indexPath.row == 3){
        return [DDBusinesslicenseTwoTitleCell height];
    }
    if (indexPath.section == 0 && indexPath.row == 4){
        return [DDBusinesslicenseTitleCell heightWithContent:nil];
    }
    
    if (indexPath.section == 1 && indexPath.row == 0){
      return [DDBusinesslicenseTitleCell heightWithContent:nil];
    }
   
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * header = [[UIView alloc] init];
    header.frame = CGRectMake(0, 0, Screen_Width, 15);
    return header;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if ([_model.enclosure hasSuffix:@"pdf"]) {
            //加载pdf
            DDWebViewController * webView = [[DDWebViewController alloc] init];
            webView.URLString = _model.enclosureUrl;
            [self.navigationController pushViewController:webView animated:YES];
        }else{
            //加载图片
            NSMutableArray * urlArray = [[NSMutableArray alloc] initWithCapacity:1];
            [urlArray addObject:_model.enclosureUrl];
            
            ShowFullImageView *vc = [[ShowFullImageView alloc] initWithImageUrlArray:urlArray];
            vc.showIndex = 0;
            vc.pageTmpColor = kColorBlue;
            [vc show];
        }
    
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
