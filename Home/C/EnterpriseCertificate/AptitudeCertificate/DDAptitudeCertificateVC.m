//
//  DDAptitudeCertificateVC.m
//  GongChengDD
//
//  Created by csq on 2018/5/25.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDAptitudeCertificateVC.h"
#import "DDDateUtil.h"
#import "DDNoResult2View.h"
#import "DataLoadingView.h"
#import "DDAptitudeCertiListModel.h"//model
#import "DDAptitudeCertiListCell.h"//cell
#import "DDAptitudeCertiDetailVC.h"//资质证书详情页
#import "DDServiceWebViewVC.h"
//#import "DDAptitudeCerHederView.h"
//#import "DDAptitudeCerContentCell.h"
//#import "DDAptitudeCertificateDetailWebVC.h"
//#import "DDAptitudeCerFootFirstView.h"//不带"查看更多"按钮
//#import "DDAptitudeCerFootSecondView.h"// 带"查看更多"按钮
//#import "DDAptitudeCerModel.h"
//#import "DDWebViewController.h"
//#import "DDElectricAptitudeContentCell.h"
//#import "DDOtherAptitudeCerFootFirstView.h"
//#import "DDOtherAptitudeCerFootSecondView.h"
//#import "DDAptitudeCertificateDetai2WebVC.h"

@interface DDAptitudeCertificateVC ()<UITableViewDelegate,UITableViewDataSource>

{
    UILabel *_nameLab;//公司名的label
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) DataLoadingView *loadingView;
@property (nonatomic,strong) DDNoResult2View *noResultView;
@property (nonatomic,strong) DDAptitudeCertiListModel *model;

@end

@implementation DDAptitudeCertificateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArray = [[NSMutableArray alloc] init];
    self.view.backgroundColor = kColorBackGroundColor;
    self.navigationItem.title = @"资质证书";
    self.navigationItem.leftBarButtonItem = [DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
//    self.navigationItem.rightBarButtonItem=[DDUtils rightbuttonItemWithTitle:@"资质办理" target:self action:@selector(certiHandleClick)];
    [self createChooseBtns];
    [self setupTableView];
    [self setupLoadingView];
    [self requestData];
}

#pragma mark 返回上一页
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 资质办理点击事件
//-(void)certiHandleClick{
//    DDServiceWebViewVC *checkVC = [DDServiceWebViewVC new];
//    checkVC.hostUrl = [NSString stringWithFormat:@"%@enterprise_service/pages/handle_list.html?groupId=1",DD_baseService_Server];
//    [self.navigationController pushViewController:checkVC animated:YES];
//}

#pragma mark 创建筛选按钮
-(void)createChooseBtns{
    //搜索结果统计
    UIView *summaryView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 42)];
    summaryView.backgroundColor=kColorBackGroundColor;
    [self.view addSubview:summaryView];
    
    _nameLab = [UILabel labelWithFont:kFontSize28 textColor:KColorBlackTitle textAlignment:NSTextAlignmentLeft numberOfLines:2];
    _nameLab.frame = CGRectMake(12,0, Screen_Width-24, 42);
    [summaryView addSubview:_nameLab];
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

- (void)setupTableView{
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,42, Screen_Width, Screen_Height-KNavigationBarHeight-42) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor=[UIColor clearColor];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.tableView setSeparatorColor:KColorTableSeparator];
    self.tableView.estimatedRowHeight = 44;
    self.tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width,KTableViewFooterViewHeight)];
    [self.view addSubview:self.tableView];
}

#pragma mark 请求数据
- (void)requestData{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:_enterpriseId forKey:@"enterpriseId"];
    [[DDHttpManager sharedInstance] sendPostRequest:KHttpRquest_ecqualificationListQualiPageByEnterprise params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"资质证书数据%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            [_loadingView hiddenLoadingView];
            if (response.isEmpty == NO) {
                [_noResultView hide];
                if ([response.data isKindOfClass:[NSDictionary class]]) {
                    _model = [[DDAptitudeCertiListModel alloc]initWithDictionary:responseObject[KData] error:nil];
                    _nameLab.text=[NSString stringWithFormat:@"%@共有%@项资质",_model.enterpriseName,_model.subitemCount];
                    
                    NSMutableAttributedString *labelAttStr=[[NSMutableAttributedString alloc] initWithString:_nameLab.text];
                    NSRange btnRange=NSMakeRange(_model.enterpriseName.length,2);//灰色
                    NSRange btnR=NSMakeRange(_nameLab.text.length-3,3); //灰色
                    [labelAttStr addAttribute:NSForegroundColorAttributeName value:KColorGreySubTitle range:btnRange];
                    [labelAttStr addAttribute:NSForegroundColorAttributeName value:KColorGreySubTitle range:btnR];
                    _nameLab.attributedText = labelAttStr;
                    
                }
                else{
                    //空数据
                    [_noResultView showWithTitle:@"暂无资质证书相关信息" subTitle:nil image:@"noResult_content"];
                }
            }
            else{
                //空数据
                 [_noResultView showWithTitle:@"暂无资质证书相关信息" subTitle:nil image:@"noResult_content"];
            }
           
        }
        else{
            [_loadingView failureLoadingView];
            [DDUtils showToastWithMessage:response.message];
        }
        
        [_tableView reloadData];
    } failure:^(NSURLSessionDataTask *operation, id responseObject) {
        [_loadingView failureLoadingView];
        [DDUtils showToastWithMessage:kRequestFailed];
    }];
}

#pragma mark UITableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _model.list.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    DDAptitudeList *model = _model.list[section];

    return model.content.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DDAptitudeList *mod = _model.list[indexPath.section];
    DDAptitudeContent *model=mod.content[indexPath.row];
    
    static NSString * electricAptitudeContentCellID = @"DDAptitudeCertiListCell";
    DDAptitudeCertiListCell * cell = (DDAptitudeCertiListCell*)[tableView dequeueReusableCellWithIdentifier:electricAptitudeContentCellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:electricAptitudeContentCellID owner:self options:nil] firstObject];
    }
    
    [cell loadDataWithModel:model];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    DDAptitudeList *mod = _model.list[indexPath.section];
    DDAptitudeContent *model=mod.content[indexPath.row];
    
    if ([DDUtils isEmptyString:model.issuedDate] && [DDUtils isEmptyString:model.validityPeriodEnd]) {
        return WidthByiPhone6(55);
    }
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DDAptitudeList *mod = _model.list[indexPath.section];
    DDAptitudeContent *model=mod.content[indexPath.row];
    
    DDAptitudeCertiDetailVC *vc=[[DDAptitudeCertiDetailVC alloc]init];
    vc.name=model.name;
    vc.certNo=model.certNo;
    vc.issuedDate=model.issuedDate;
    vc.validityPeriodEnd=model.validityPeriodEnd;
    vc.issuedDeptSource=model.issuedDeptSource;
    vc.type=model.type;
    vc.certTypeId=model.certTypeId;
    vc.majorCategory = model.majorCategory;
    [self.navigationController pushViewController:vc animated:YES];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    DDAptitudeList *model = _model.list[section];
    
    UIView * header = [[UIView alloc] init];
    header.frame = CGRectMake(0, 0, Screen_Width, 40);
    header.backgroundColor = kColorWhite;
    
    UILabel * lab1 = [[UILabel alloc] init];
    lab1.frame = CGRectMake(12,12,3, 16);
    lab1.backgroundColor = KColorFindingPeopleBlue;
    [header addSubview:lab1];
    
    UILabel * lab2 = [[UILabel alloc] init];
    lab2.frame = CGRectMake(CGRectGetMaxX(lab1.frame)+8,0,Screen_Width-24-3-8, 40);
    lab2.text = model.certName;
    lab2.font = kFontSize30Bold;
    lab2.textColor = KColorBlackTitle;
    [header addSubview:lab2];

    return header;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 15;
}





@end
