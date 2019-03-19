//
//  DDRewardGloryDetailVC.m
//  GongChengDD
//
//  Created by xzx on 2018/6/4.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDRewardGloryDetailVC.h"
#import "DDLabelUtil.h"
#import "DDJudgePaperDetailCell.h"//cell1
#import "DDLoseCreditDetailCell.h"//cell2
#import "DDProjectDetailPictureCell.h"//cell3
#import "DataLoadingView.h"//加载页面
#import "DDRewardDetailModel.h"//model
#import "DDProjectCheckOriginWebVC.h"//查看原文页面

@interface DDRewardGloryDetailVC ()<UITableViewDelegate,UITableViewDataSource>

{
    DDRewardDetailModel *_model;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) DataLoadingView *loadingView;

@end

@implementation DDRewardGloryDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self editNavItem];
    [self createTableView];
    //[self createBottomBtn];
    [self createLoadView];
    [self requestData];
}

//定制导航条
-(void)editNavItem{
    if ([self.reward_group isEqualToString:@"1"]) {
        self.title=@"技术创新奖详情";
    }
    else if([self.reward_group isEqualToString:@"2"]){
        self.title=@"QC奖详情";
    }
    else{
        self.title=@"获奖荣誉详情";
    }
    self.view.backgroundColor=kColorBackGroundColor;
    self.navigationItem.leftBarButtonItem=[DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
}

//返回上一页
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

//创建查看原文按钮
-(void)createBottomBtn{
    UIView *bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, Screen_Height-KNavigationBarHeight-49, Screen_Width, 49)];
    bottomView.backgroundColor=kColorWhite;
    [self.view addSubview:bottomView];
    
    UIButton *checkPaperBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 49)];
    [bottomView addSubview:checkPaperBtn];
    
    [checkPaperBtn setTitle:@"查看原文>>" forState:UIControlStateNormal];
    checkPaperBtn.titleLabel.font=kFontSize30;
    [checkPaperBtn setTitleColor:kColorBlue forState:UIControlStateNormal];
    [checkPaperBtn addTarget:self action:@selector(checkPaperClick) forControlEvents:UIControlEventTouchUpInside];
}

//查看原文
-(void)checkPaperClick{
    DDProjectCheckOriginWebVC *projectCheckOriginWebVC=[[DDProjectCheckOriginWebVC alloc]init];
    projectCheckOriginWebVC.hostUrl=_model.reward_original_href;
    [self.navigationController pushViewController:projectCheckOriginWebVC animated:YES];
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
-(void)requestData{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:self.reward_id forKey:@"rewardId"];
    
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_rewardDetailByID params:params success:^(NSURLSessionDataTask *operation, id responseObject){
        if ([self.reward_group isEqualToString:@"1"]) {
            NSLog(@"**********技术创新奖详情数据***************%@",responseObject);
        }
        else if([self.reward_group isEqualToString:@"2"]){
            NSLog(@"**********QC奖详情数据***************%@",responseObject);
        }
        else{
            NSLog(@"**********获奖荣誉详情数据***************%@",responseObject);
        }
        
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            [_loadingView hiddenLoadingView];
            _model=[[DDRewardDetailModel alloc]initWithDictionary:responseObject[KData] error:nil];
        }
        else{
           
            [_loadingView failureLoadingView];
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
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.backgroundColor=kColorBackGroundColor;
    _tableView.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.estimatedRowHeight=44;
    _tableView.separatorColor=KColorTableSeparator;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, KTableViewFooterViewHeight)];
}

#pragma mark tableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //return 2;
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        static NSString * cellID = @"DDLoseCreditDetailCell";
        DDLoseCreditDetailCell * cell = (DDLoseCreditDetailCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
        }
        
        if (indexPath.row==0) {
            cell.titleLab.text=@"获得奖项";
            cell.detailLab.text=_model.reward_type;
        }
        else if (indexPath.row==1) {
            cell.titleLab.text=@"获奖单位";
            cell.detailLab.text=_model.enterprise_name;
        }
        else if (indexPath.row==2) {
            cell.titleLab.text=@"主要参与人员";
            if (![DDUtils isEmptyString:_model.staff_name]) {
                cell.detailLab.text=_model.staff_name;
            }
            else{
                cell.detailLab.text=@"-";
            }
        }
        else if (indexPath.row==3){
            if ([self.reward_group isEqualToString:@"1"]) {
                cell.titleLab.text=@"技术创新成果名称";
            }
            else if([self.reward_group isEqualToString:@"2"]){
                cell.titleLab.text=@"课题名称";
            }
            else{
                cell.titleLab.text=@"工程名称";
            }
            
            if (![DDUtils isEmptyString:_model.reward_explain]) {
                cell.detailLab.text=_model.reward_explain;
            }
            else{
                cell.detailLab.text=@"-";
            }
        }
        else if (indexPath.row==4){
            cell.titleLab.text=@"实施部门";
            cell.detailLab.text=_model.executor_defendant;
        }
        else{
            cell.titleLab.text=@"发布时间";
            cell.detailLab.text=_model.reward_issue_time;
        }
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    else{
        static NSString * cellID = @"DDProjectDetailPictureCell";
        DDProjectDetailPictureCell * cell = (DDProjectDetailPictureCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
        }
        
        [cell loadDataWithContent:@"工程点点数据共享与整合是基于对公开信息大数据分析后的结果仅供用户参考，实际中标情况请通过快照核实，以政府公布为准！" andPic:@""];
        
        [cell.pictureImg sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"home_detail_scanPic"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                cell.pictureImg.image = image;
            }
        }];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        //return 200;
        return UITableViewAutomaticDimension;
    }
    else{
        return [DDLabelUtil getSpaceLabelHeightWithString:@"工程点点数据共享与整合是基于对公开信息大数据分析后的结果仅供用户参考，实际中标情况请通过快照核实，以政府公布为准！" font:KFontSize22 width:(Screen_Width-24)]+335;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 15;
}



@end
