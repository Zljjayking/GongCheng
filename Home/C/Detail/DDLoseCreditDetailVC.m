//
//  DDLoseCreditDetailVC.m
//  GongChengDD
//
//  Created by xzx on 2018/8/7.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDLoseCreditDetailVC.h"
#import "DDLabelUtil.h"
#import "DDLoseCreditDetailCell.h"//cell1
#import "DDProjectDetailPictureCell.h"//cell2
#import "DataLoadingView.h"//加载页面
#import "DDExcutedPeopleDetailModel.h"//model
#import "DDProjectCheckOriginWebVC.h"//查看原文页面
#import "DDExecutedAndLoseCreditRelativeCell.h"//cell
#import "DDExcutedPeopleDetailVC.h"//被执行人详情界面

@interface DDLoseCreditDetailVC ()<UITableViewDelegate,UITableViewDataSource>

{
    DDExcutedPeopleDetailModel *_model;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) DataLoadingView *loadingView;

@end

@implementation DDLoseCreditDetailVC

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
    self.title=@"失信详情";
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
    //projectCheckOriginWebVC.hostUrl=_model.executeOriginalImg;
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
    [params setValue:self.execute_id forKey:@"executeId"];
    
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_excutedDetailByID params:params success:^(NSURLSessionDataTask *operation, id responseObject){
        NSLog(@"**********失信信息详情数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            [_loadingView hiddenLoadingView];
            _model=[[DDExcutedPeopleDetailModel alloc]initWithDictionary:responseObject[KData] error:nil];
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
    _tableView.separatorColor=KColorTableSeparator;
    _tableView.estimatedRowHeight=44;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, KTableViewFooterViewHeight)];
}

#pragma mark tableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(_model.group){
        return 2;
    }
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(_model.group){
        if (section==0) {
            return 12;
        }
        else{
            return 1;
        }
    }
    return 12;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(_model.group){
        if (indexPath.section==0) {
            static NSString * cellID = @"DDLoseCreditDetailCell";
            DDLoseCreditDetailCell * cell = (DDLoseCreditDetailCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
            }
            
            if (indexPath.row==0) {
                cell.titleLab.text=@"失信被执行人";
                cell.detailLab.text=_model.executePerson;
            }
            else if(indexPath.row==1){
                cell.titleLab.text=@"法定代表人或负责人姓名";
                cell.detailLab.text=_model.legalRepresentative;
            }
            else if(indexPath.row==2){
                cell.titleLab.text=@"组织机构代码";
                cell.detailLab.text=_model.executePersonCode;
            }
            else if(indexPath.row==3){
                cell.titleLab.text=@"执行依据文号";
                cell.detailLab.text=_model.baseNumber;
            }
            else if(indexPath.row==4){
                cell.titleLab.text=@"案号";
                cell.detailLab.text=_model.executeCaseNumber;
            }
            else if(indexPath.row==5){
                cell.titleLab.text=@"做出执行依据单位";
                cell.detailLab.text=_model.baseCourt;
            }
            else if(indexPath.row==6){
                cell.titleLab.text=@"法律生效文书确定的义务";
                cell.detailLab.text=_model.duty;
            }
            else if(indexPath.row==7){
                cell.titleLab.text=@"被执行人的履行情况";
                cell.detailLab.text=_model.performance;
            }
            else if(indexPath.row==8){
                cell.titleLab.text=@"执行法院";
                cell.detailLab.text=_model.executeCourt;
            }
            else if(indexPath.row==9){
                cell.titleLab.text=@"省份";
                cell.detailLab.text=_model.province;
            }
            else if(indexPath.row==10){
                cell.titleLab.text=@"立案时间";
                cell.detailLab.text=_model.executeCreateDate;
            }
            else if(indexPath.row==11){
                cell.titleLab.text=@"发布时间";
                cell.detailLab.text=_model.executePublishDate;
            }
            
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
        else{
            static NSString * cellID = @"DDExecutedAndLoseCreditRelativeCell";
            DDExecutedAndLoseCreditRelativeCell * cell = (DDExecutedAndLoseCreditRelativeCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
            }
            
            cell.nameLab.text = _model.group.executeCaseNumber;
            
            cell.numLab2.text=_model.group.executeStandard;
            cell.courtLab2.text=_model.group.executeCourt;
            if (![DDUtils isEmptyString:_model.group.executeCreateDate]) {
                cell.timeLab2.text=[DDUtils getDateLineByStandardTime:_model.group.executeCreateDate];
            }
            else{
                cell.timeLab2.text=@"";
            }
            
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
    }else{
        static NSString * cellID = @"DDLoseCreditDetailCell";
        DDLoseCreditDetailCell * cell = (DDLoseCreditDetailCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
        }
        
        if (indexPath.row==0) {
            cell.titleLab.text=@"失信被执行人";
            cell.detailLab.text=_model.executePerson;
        }
        else if(indexPath.row==1){
            cell.titleLab.text=@"法定代表人或负责人姓名";
            cell.detailLab.text=_model.legalRepresentative;
        }
        else if(indexPath.row==2){
            cell.titleLab.text=@"组织机构代码";
            cell.detailLab.text=_model.executePersonCode;
        }
        else if(indexPath.row==3){
            cell.titleLab.text=@"执行依据文号";
            cell.detailLab.text=_model.baseNumber;
        }
        else if(indexPath.row==4){
            cell.titleLab.text=@"案号";
            cell.detailLab.text=_model.executeCaseNumber;
        }
        else if(indexPath.row==5){
            cell.titleLab.text=@"做出执行依据单位";
            cell.detailLab.text=_model.baseCourt;
        }
        else if(indexPath.row==6){
            cell.titleLab.text=@"法律生效文书确定的义务";
            cell.detailLab.text=_model.duty;
        }
        else if(indexPath.row==7){
            cell.titleLab.text=@"被执行人的履行情况";
            cell.detailLab.text=_model.performance;
        }
        else if(indexPath.row==8){
            cell.titleLab.text=@"执行法院";
            cell.detailLab.text=_model.executeCourt;
        }
        else if(indexPath.row==9){
            cell.titleLab.text=@"省份";
            cell.detailLab.text=_model.province;
        }
        else if(indexPath.row==10){
            cell.titleLab.text=@"立案时间";
            cell.detailLab.text=_model.executeCreateDate;
        }
        else if(indexPath.row==11){
            cell.titleLab.text=@"发布时间";
            cell.detailLab.text=_model.executePublishDate;
        }
        
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1) {
        DDExcutedPeopleDetailVC *detail=[[DDExcutedPeopleDetailVC alloc]init];
        detail.execute_id=_model.group.executeId;
        [self.navigationController pushViewController:detail animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return UITableViewAutomaticDimension;
    }
    else{
        //return [DDLabelUtil getSpaceLabelHeightWithString:@"工程点点数据共享与整合是基于对公开信息大数据分析后的结果仅供用户参考，实际中标情况请通过快照核实，以政府公布为准！" font:KFontSize22 width:(Screen_Width-24)]+335;
        return UITableViewAutomaticDimension;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==1) {
        UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 47)];
        headView.backgroundColor=kColorWhite;
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(12, 0, Screen_Width-24, 47)];
        label.text=@"关联被执行人信息";
        label.textColor=KColorBlackTitle;
        label.font=KfontSize32Bold;
        [headView addSubview:label];
        
        return headView;
    }
    else{
        return nil;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==1) {
        return 47;
    }
    else{
        return CGFLOAT_MIN;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 15;
}

@end
