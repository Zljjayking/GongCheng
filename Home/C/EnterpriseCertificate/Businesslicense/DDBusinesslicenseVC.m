//
//  DDBusinesslicenseVC.m
//  GongChengDD
//
//  Created by csq on 2017/11/28.
//  Copyright © 2017年 Koncendy. All rights reserved.
//

#import "DDBusinesslicenseVC.h"
#import "DataLoadingView.h"
#import "DDBusinesslicenseModel.h"
#import "DDDateUtil.h"
#import "DDBusinessLicenseChangeRecordVC.h"
#import "DDBusinesslicenseTitleCell.h"//1个标题的cell
#import "DDBusinesslicenseTwoTitleCell.h"//2个标题的cell
#import "DDManageRangeCell.h"//经营范围cell
#import "DDNoResult2View.h"
#import "DDBranchInfoCell.h"
#import "DDServiceWebViewVC.h"
@interface DDBusinesslicenseVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) DDNoResult2View *noResultView;
@property (nonatomic,strong)DataLoadingView * loadingView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong)DDBusinesslicenseModel * model;
@property (nonatomic,strong)UIButton * backTopButton;
@end

@implementation DDBusinesslicenseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kColorBackGroundColor;
    self.navigationItem.title = @"营业执照";
    self.navigationItem.leftBarButtonItem = [DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
//    self.navigationItem.rightBarButtonItem = [DDUtils rightbuttonItemWithTitle:@"工商社保" target:self action:@selector(rightButtonClick)];
    
    [self setupTableView];
    [self setupDataLoadingView];
    [self requestData];
    
    [self setupBackTopButton];
}
- (void)setupBackTopButton{
    _backTopButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _backTopButton.frame = CGRectMake(Screen_Width-70,(Screen_Height-KNavigationBarHeight-KHomeIndicatorHeight-50-30), 50, 50);
    [_backTopButton setImage:[UIImage imageNamed:@"home_backTop"] forState:UIControlStateNormal];
    [_backTopButton setImage:[UIImage imageNamed:@"home_backTop"] forState:UIControlStateHighlighted];
    
    [_backTopButton addTarget:self action:@selector(backToTopClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backTopButton];
    _backTopButton.hidden = YES;
}
- (void)backToTopClick{
    //返回顶部
    [self.tableView  scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
}
#pragma mark 工商社保
//- (void)rightButtonClick{
//    DDServiceWebViewVC *checkVC = [DDServiceWebViewVC new];
//    checkVC.hostUrl = @"http://gcdd.koncendy.com/apphs/enterprise_service/pages/handle_list.html?groupId=7";
//    [self.navigationController pushViewController:checkVC animated:YES];
//}
- (void)setupTableView{
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,0, Screen_Width, Screen_Height-KNavigationBarHeight) style:UITableViewStyleGrouped];
    
    self.tableView.backgroundColor=[UIColor clearColor];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [self.tableView setSeparatorColor:KColorTableSeparator];
    self.tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width,KTableViewFooterViewHeight)];
    [self.view addSubview:self.tableView];
}
- (void)setupDataLoadingView{
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
    
    [[DDHttpManager sharedInstance] sendPostRequest:KHttpRequest_ecbusinesslicenseInfo params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
//        NSLog(@"营业执照 %@",responseObject);
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            [_loadingView hiddenLoadingView];
            
            if (response.isEmpty == NO) {
                [_noResultView hide];
                _model = [[DDBusinesslicenseModel alloc] initWithDictionary:response.data error:nil];
                [_model handleData];
            }else{
                 [_noResultView showWithTitle:@"暂无营业执照相关信息" subTitle:nil image:@"noResult_content"];
            }
            
        }else{
            [_loadingView failureLoadingView];
            [DDUtils showToastWithMessage:response.message];
        }
        [_tableView reloadData];
    } failure:^(NSURLSessionDataTask *operation, id responseObject) {
        [_loadingView failureLoadingView];
        [DDUtils showToastWithMessage:kRequestFailed];
       
    }];
}

#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 6;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
     BOOL showRegisterInfo = [_model.showRegisterInfo boolValue];
    
    if (section == 0) {
        if (showRegisterInfo == YES) {
             return 7;
        }else{
            return 0;
        }
    }
    
    
    if (section == 1) {
        if (showRegisterInfo == YES) {
             return 2;
        }
        return 0;
    }
    
    
    if (section == 2) {
        if (showRegisterInfo == YES) {
            return 1;
        }
        return 0;
    }
    
    
    if (section == 3) {
        if (showRegisterInfo == YES) {
              return 3;
        }
        return 0;
    }
    
    
    if (section == 5) {
        BOOL showBranch =   [_model.showBranch boolValue];
        if (showBranch == YES) {
             return _model.branch.count;
        }else{
            return 0;
        }
      
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
    
    //2个标题的cell
    static NSString * twoTitleCellID = @"DDBusinesslicenseTwoTitleCell";
    DDBusinesslicenseTwoTitleCell * twoTitleCell = (DDBusinesslicenseTwoTitleCell*)[tableView dequeueReusableCellWithIdentifier:twoTitleCellID];
    if (twoTitleCell == nil) {
        twoTitleCell = [[[NSBundle mainBundle]loadNibNamed:twoTitleCellID owner:self options:nil] firstObject];
    }
    twoTitleCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        titleCell.titleLab.text = @"名称";
        titleCell.contentLab.text = _model.unitName;
        titleCell.topLine.hidden = YES;
        titleCell.bottomLine.hidden = YES;
        return titleCell;
    }
    
    if (indexPath.section == 0 && indexPath.row == 1) {
        titleCell.titleLab.text = @"法定代表人";
        titleCell.contentLab.text = _model.legalRepresentative;
        titleCell.topLine.hidden = YES;
        titleCell.bottomLine.hidden = YES;
        return titleCell;
    }
    
    if (indexPath.section == 0 && indexPath.row == 2) {
        twoTitleCell.leftTitleLab.text = @"成立日期";
        twoTitleCell.leftContentLab.text = [DDUtils getDateLineByStandardTime:_model.establishedDate];
        twoTitleCell.rightLab.text = @"经营状态";
        twoTitleCell.rightContentLab.text = _model.status;
//        twoTitleCell.rightContentLab.text = @"明月几时有,把酒问青天,不知天上宫阙,今夕是何年";
//        twoTitleCell.rightContentLab.backgroundColor = [UIColor redColor];
        [twoTitleCell layoutIfNeeded];
        return twoTitleCell;
    }
    
    if (indexPath.section == 0 && indexPath.row == 3) {
        titleCell.titleLab.text = @"注册资本";
        //后台返回的是元,转化成万元
        if(![DDUtils isEmptyString:_model.registerCapital]){
            double newRegisterCapital = [_model.registerCapital doubleValue]/10000;
            NSString * str1 = [NSString stringWithFormat:@"%.4f",newRegisterCapital];
            NSString * rsult1 = [DDUtils removeFloatAllZero:str1];//去掉末尾多余的0
            
            //注册资本,有2种:人民币,美元
            if ([_model.registerCapitalCurrency isEqualToString:@"0"]) {
                titleCell.contentLab.text = [NSString stringWithFormat:@"%@万人民币",rsult1];
            }else{
                titleCell.contentLab.text = [NSString stringWithFormat:@"%@万美元",rsult1];
            }
        }else{
            titleCell.contentLab.text = @"-";
        }
        
        titleCell.topLine.hidden = YES;
        titleCell.bottomLine.hidden = YES;
        return titleCell;
    }
    
    if (indexPath.section == 0 && indexPath.row == 4) {
        titleCell.titleLab.text = @"统一社会信用代码";
        titleCell.contentLab.text  = _model.socialCreditCode;
        titleCell.topLine.hidden = NO;
        titleCell.bottomLine.hidden = YES;
        return titleCell;
    }
    
    if (indexPath.section == 0 && indexPath.row == 5) {
        titleCell.titleLab.text = @"企业类型";
        titleCell.contentLab.text  = _model.economicTypeSource;
        titleCell.topLine.hidden = NO;
        titleCell.bottomLine.hidden = YES;
        return titleCell;
    }
    
    if (indexPath.section == 0 && indexPath.row == 6) {
        titleCell.titleLab.text = @"公司地址";
        titleCell.contentLab.text  = _model.registerAddressSource;
        titleCell.topLine.hidden = NO;
        titleCell.bottomLine.hidden = YES;
        return titleCell;
    }
    if (indexPath.section == 1 && indexPath.row == 0) {
        titleCell.titleLab.text = @"曾用名";
        if ([DDUtils isEmptyString:_model.usedNames]) {
            titleCell.contentLab.text = @"-";
        }else{
            titleCell.contentLab.text = _model.usedNames;
        }
        titleCell.topLine.hidden = YES;
        titleCell.bottomLine.hidden = YES;
        return titleCell;
    }
    if (indexPath.section == 1 && indexPath.row == 1) {
        titleCell.titleLab.text = @"所属行业";
        titleCell.contentLab.text = _model.industry;
        titleCell.topLine.hidden = NO;
        titleCell.bottomLine.hidden = YES;
        return titleCell;
    }
    
    if (indexPath.section == 2) {
        static NSString * manageRangeCellID = @"DDManageRangeCell";
        DDManageRangeCell * manageRangeCell = (DDManageRangeCell*)[tableView dequeueReusableCellWithIdentifier:manageRangeCellID];
        if (manageRangeCell == nil) {
            manageRangeCell = [[[NSBundle mainBundle] loadNibNamed:manageRangeCellID owner:self options:nil] firstObject];
        }
        manageRangeCell.selectionStyle = UITableViewCellSelectionStyleNone;
        manageRangeCell.titleLab.text = @"经营范围";
//        BOOL showAllMangerRange = [_model.showAllMangerRange boolValue];
        [manageRangeCell loadWithContent:_model.businessScope showAll:YES];
        return manageRangeCell;
        
    }
    
    if (indexPath.section == 3 && indexPath.row == 0) {
        titleCell.titleLab.text = @"营业期限";
        titleCell.contentLab.text = _model.businessDate;
        titleCell.topLine.hidden = YES;
        titleCell.bottomLine.hidden = YES;
        return titleCell;
    }
    if (indexPath.section == 3 && indexPath.row == 1) {
        titleCell.titleLab.text = @"核准日期";
        titleCell.contentLab.text = [DDUtils getDateLineByStandardTime:_model.checkDate];
        titleCell.topLine.hidden = NO;
        titleCell.bottomLine.hidden = YES;
        return titleCell;
    }
    
    if (indexPath.section == 3 && indexPath.row == 2) {
        titleCell.titleLab.text = @"登记机关";
        titleCell.contentLab.text = _model.checkInDeptSource;
        titleCell.topLine.hidden = NO;
        titleCell.bottomLine.hidden = YES;
        return titleCell;
    }
    if (indexPath.section == 5) {
        //分支机构
        static NSString * branchInfoCellID = @"DDBranchInfoCell";
        DDBranchInfoCell * branchInfoCell = (DDBranchInfoCell*)[tableView dequeueReusableCellWithIdentifier:branchInfoCellID];
        if (branchInfoCell == nil) {
            branchInfoCell = [[[NSBundle mainBundle] loadNibNamed:branchInfoCellID owner:self options:nil] firstObject];
        }
        branchInfoCell.selectionStyle = UITableViewCellSelectionStyleNone;
        DDBusinesslicenseBranchModel * branchModel = _model.branch[indexPath.row];
        [branchInfoCell loadWithTitle:branchModel.branchName];
        return branchInfoCell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //2个标题的cell
    static NSString * twoTitleCellID = @"DDBusinesslicenseTwoTitleCell";
    DDBusinesslicenseTwoTitleCell * twoTitleCell = (DDBusinesslicenseTwoTitleCell*)[tableView dequeueReusableCellWithIdentifier:twoTitleCellID];
    if (twoTitleCell == nil) {
        twoTitleCell = [[[NSBundle mainBundle]loadNibNamed:twoTitleCellID owner:self options:nil] firstObject];
    }
    twoTitleCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        return [DDBusinesslicenseTitleCell heightWithContent:nil];
    }
    if (indexPath.section == 0 && indexPath.row == 1) {
        return [DDBusinesslicenseTitleCell heightWithContent:nil];
    }
    if (indexPath.section == 0 && indexPath.row == 2) {
//        return [DDBusinesslicenseTwoTitleCell height];
        twoTitleCell.leftTitleLab.text = @"成立日期";
        twoTitleCell.leftContentLab.text = [DDUtils getDateLineByStandardTime:_model.establishedDate];
        twoTitleCell.rightLab.text = @"经营状态";
        twoTitleCell.rightContentLab.text = _model.status;
//        twoTitleCell.rightContentLab.text = @"明月几时有,把酒问青天,不知天上宫阙,今夕是何年";
        [twoTitleCell layoutIfNeeded];
        return [twoTitleCell height];
    }
    if (indexPath.section == 0 && indexPath.row == 3) {
       return [DDBusinesslicenseTitleCell heightWithContent:nil];
    }
    
    if (indexPath.section == 0 && indexPath.row == 4){
       return [DDBusinesslicenseTitleCell heightWithContent:nil];
    }
    if (indexPath.section == 0 && indexPath.row == 5){
        return [DDBusinesslicenseTitleCell heightWithContent:_model.economicTypeSource];
    }
    
    if (indexPath.section == 0 && indexPath.row == 6) {
         return [DDBusinesslicenseTitleCell heightWithContent:_model.registerAddressSource];
    }
    
    if (indexPath.section == 1 && indexPath.row == 0) {
       return [DDBusinesslicenseTitleCell heightWithContent:_model.usedNames];
    }
    
    if (indexPath.section == 1 && indexPath.row == 1) {
       return [DDBusinesslicenseTitleCell heightWithContent:nil];
    }
    
    if (indexPath.section == 2) {
        //经营范围
        BOOL showAllMangerRange = YES;
        DDManageRangeCell * cell = [_tableView dequeueReusableCellWithIdentifier:@"DDManageRangeCell"];
        if (cell == nil) {
             cell = [[[NSBundle mainBundle] loadNibNamed:@"DDManageRangeCell" owner:self options:nil] firstObject];
        }

        return [cell heightWithContent:_model.businessScope showAll:showAllMangerRange];
    }
    
    if (indexPath.section == 3) {
        return [DDBusinesslicenseTitleCell heightWithContent:nil];
    }
    if (indexPath.section == 5) {
        //分支机构
        DDBusinesslicenseBranchModel * branchModel = _model.branch[indexPath.row];
        if(![DDUtils isEmptyString:branchModel.branchName]){
            CGSize labelSize = [[NSString stringWithFormat:@"%@",branchModel.branchName] boundingRectWithSize:CGSizeMake(Screen_Width-24, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:kFontSize32} context:nil].size;
            return labelSize.height+24;
        }
        return 30;
    }
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0 || section == 4 ||section == 5) {
        return 15+50;
    }
     BOOL showRegisterInfo = [_model.showRegisterInfo boolValue];
    if (showRegisterInfo == YES) {
        return 15;
    }else{
        return 0.01;
    }
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //section有标题
    
    UIView * header = [[UIView alloc] init];
    header.frame = CGRectMake(0, 0, Screen_Width, (15+50));
    header.backgroundColor = [UIColor clearColor];
    
    //白色背景
    UIView * whiteView  = [[UIView alloc] init];
    whiteView.frame = CGRectMake(0, 15, Screen_Width, 50);
    whiteView.backgroundColor = [UIColor whiteColor];
    [header addSubview:whiteView];
    
    //左边的lab
    UILabel * lab = [[UILabel alloc] init];
    lab.frame = CGRectMake(12,0,100, 50);
//    lab.text = cerModel.certTypeName;
    lab.font = KfontSize32Bold;
    lab.textColor = KColorBlackTitle;
    [whiteView addSubview:lab];
    
    
    //底部线条
    UIView * line = [[UIView alloc] init];
    line.frame = CGRectMake(0, 49.5, Screen_Width, 0.5);
    line.backgroundColor = KColorTableSeparator;
    [whiteView addSubview:line];
    
    if (section == 0) {
        lab.text = @"登记信息";

        UIButton * arrow = [UIButton buttonWithType:UIButtonTypeCustom];
        arrow.frame = CGRectMake((Screen_Width-12-30), 10, 30, 30);
         BOOL showRegisterInfo = [_model.showRegisterInfo boolValue];
        if (showRegisterInfo == YES) {
           [arrow setImage:[UIImage imageNamed:@"ec_arrow_up"] forState:UIControlStateNormal];
        }else{
            [arrow setImage:[UIImage imageNamed:@"ec_arrow_down"] forState:UIControlStateNormal];
        }
        
        [arrow addTarget:self action:@selector(arrowClick:) forControlEvents:UIControlEventTouchUpInside];
        arrow.tag = section;
        [whiteView addSubview:arrow];
        
        return header;
    }else if (section == 4){
        lab.text = @"变更记录";
        if ([_model.hasChange isEqualToString:@"0"]) {
            //没有变更记录
            UILabel * changeRecord = [[UILabel alloc] init];
            changeRecord.frame = CGRectMake((Screen_Width-40), 10, 40, 30);
            changeRecord.text = @"暂无";
            changeRecord.textColor = KColorGreySubTitle;
            changeRecord.font = kFontSize28;
            [whiteView addSubview:changeRecord];
        }else{
            //有变更记录
            whiteView.userInteractionEnabled = YES;
            UITapGestureRecognizer * tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showChangeRecordArrowClick:)];
            [whiteView addGestureRecognizer:tapGes];
            
            UIButton * arrow = [UIButton buttonWithType:UIButtonTypeCustom];
            arrow.frame = CGRectMake((Screen_Width-40), 10, 40, 30);
            [arrow setImage:[UIImage imageNamed:@"arrow_right"] forState:UIControlStateNormal];
            //[arrow addTarget:self action:@selector(showChangeRecordArrowClick:) forControlEvents:UIControlEventTouchUpInside];
            [whiteView addSubview:arrow];
            
            UILabel * numLab = [[UILabel alloc] init];
            numLab.frame = CGRectMake(Screen_Width-80, 10, 40, 30);
            numLab.textColor = KColorGreySubTitle;
            numLab.font = kFontSize28;
            numLab.textAlignment = NSTextAlignmentRight;
            numLab.text = _model.hasChange;
            [whiteView addSubview:numLab];
        }
        return header;
        
    }else if (section == 5){
        lab.text = @"分支机构";
        
        if (_model.branch.count >0) {
            //有分支机构
            UIButton * arrow = [UIButton buttonWithType:UIButtonTypeCustom];
            arrow.frame = CGRectMake((Screen_Width-40), 10, 40, 30);
            BOOL showBranch = [_model.showBranch boolValue];
            if (showBranch == YES) {
                [arrow setImage:[UIImage imageNamed:@"ec_arrow_up"] forState:UIControlStateNormal];
            }else{
                [arrow setImage:[UIImage imageNamed:@"ec_arrow_down"] forState:UIControlStateNormal];
            }
            [arrow addTarget:self action:@selector(arrowClick:) forControlEvents:UIControlEventTouchUpInside];
            arrow.tag = section;
            [whiteView addSubview:arrow];
            
            UILabel * numLab = [[UILabel alloc] init];
            numLab.frame = CGRectMake(Screen_Width-80, 10, 40, 30);
            numLab.textColor = KColorGreySubTitle;
            numLab.font = kFontSize28;
            numLab.textAlignment = NSTextAlignmentRight;
            numLab.text = [NSString stringWithFormat:@"%lu",(unsigned long)_model.branch.count];
            [whiteView addSubview:numLab];
        } else {
            //没有分支机构
            //没有变更记录
            UILabel * noBranch = [[UILabel alloc] init];
            noBranch.frame = CGRectMake((Screen_Width-40), 10, 40, 30);
            noBranch.text = @"暂无";
            noBranch.textColor = KColorGreySubTitle;
            noBranch.font = kFontSize28;
            [whiteView addSubview:noBranch];
        }
        
        return header;
       
        
    }
    else{
        return nil;
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 2) {
        BOOL showRegisterInfo = [_model.showRegisterInfo boolValue];
        if (showRegisterInfo == YES) {
            //显示登记信息
            BOOL showMoreButton =  [_model.showMoreButton boolValue];
            if (NO == showMoreButton){
                //不需要显示
                return nil;
            }else{
                return nil;
//                BOOL showAllMangerRange = [_model.showAllMangerRange boolValue];
//                //如果有更多按钮
//                UIView * footView = [[UIView alloc] init];
//                footView.frame= CGRectMake(0, 0, Screen_Width, 40);
//                footView.backgroundColor = kColorWhite;
//
//                //线
//                UIView * line = [[UIView alloc] init];
//                line.frame = CGRectMake(12,0, Screen_Width-12, 0.5);
//                line.backgroundColor = KColorTableSeparator;
//                [footView addSubview:line];
//
//                UIButton * moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
//                moreButton.frame = CGRectMake(((Screen_Width/2)-30), 1, 60,40);
//                [moreButton setTitleColor:kColorBlue forState:UIControlStateNormal];
//                moreButton.titleLabel.font = kFontSize28;
//                [moreButton addTarget:self action:@selector(moreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//                moreButton.tag = section;//把区号当做tag
//                [footView addSubview:moreButton];
//
//                //判断按钮的名称
//                if (NO == showAllMangerRange) {
//                    [moreButton setTitle:@"查看更多" forState:UIControlStateNormal];
//                }else{
//                    [moreButton setTitle:@"收起更多" forState:UIControlStateNormal];
//                }
//                return footView;
            }
        }else{
            return nil;
        }
    }else{
        return nil;
    }
}

#pragma mark 滑动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat y = scrollView.contentOffset.y;
    
//    NSLog(@"+++++   %f",y);
    
    if (y>0) {
        //显示按钮
        _backTopButton.hidden = NO;
    }else{
        //隐藏按钮
        _backTopButton.hidden = YES;
    }
}
#pragma mark   更多,收起
//- (void)moreButtonClick:(UIButton *)button{
//    BOOL showAllMangerRange = [_model.showAllMangerRange boolValue];
//    showAllMangerRange = !showAllMangerRange;
//
//    //改变模型
//    NSNumber * resultshowAllMangerRange = [NSNumber numberWithBool:showAllMangerRange];
//    _model.showAllMangerRange = resultshowAllMangerRange;
//    //刷新表
//    [_tableView reloadData];
//}
#pragma mark arrowClick
- (void)arrowClick:(id)sender{
    UIButton * button = (UIButton*)sender;
    NSInteger tag = button.tag;
    if (tag == 0) {
        //登记信息
        BOOL showRegisterInfo = [_model.showRegisterInfo boolValue];
        showRegisterInfo = !showRegisterInfo;
        _model.showRegisterInfo = [NSNumber numberWithBool:showRegisterInfo];
    }
    if (tag == 5) {
        //分支机构
       BOOL showBranch =  [_model.showBranch boolValue];
       showBranch = !showBranch;
       _model.showBranch = [NSNumber numberWithBool:showBranch];
    }
    [_tableView reloadData];
}
#pragma mark 变更记录点击
- (void)showChangeRecordArrowClick:(id)sender{
    DDBusinessLicenseChangeRecordVC * vc = [[DDBusinessLicenseChangeRecordVC alloc] init];
    vc.enterpriseId = _enterpriseId;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark 返回上一页
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
