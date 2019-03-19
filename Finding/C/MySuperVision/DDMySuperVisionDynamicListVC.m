//
//  DDMySuperVisionDynamicListVC.m
//  GongChengDD
//
//  Created by xzx on 2018/11/22.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDMySuperVisionDynamicListVC.h"
#import "MJRefresh.h"
#import "DataLoadingView.h"//加载页面
#import "DDNoResult2View.h"//无数据视图
#import "DDMySuperVisionDynamicListModel.h"//model
#import "DDMySuperVisionDynamicList1Cell.h"//cell
#import "DDMySuperVisionDynamicList2Cell.h"//cell
#import "DDProjectCheckOriginWebVC.h"//查看报告页面
#import "DDNewsJumpManager.h"//消息和监控跳转控制类
#import "DDServiceWebViewVC.h"
#import "DDExamineTrainingVC.h"
@interface DDMySuperVisionDynamicListVC ()<UITableViewDelegate,UITableViewDataSource>

{
    NSInteger currentPage;
    NSInteger pageCount;
    NSMutableArray *_dataSourceArr;
    NSMutableDictionary *_dict;
}
@property (nonatomic,strong) DataLoadingView *loadingView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) DDNoResult2View *noResultView;//无数据视图

@end

@implementation DDMySuperVisionDynamicListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataSourceArr=[[NSMutableArray alloc]init];
    self.view.backgroundColor=kColorBackGroundColor;
    
    //接收收到监控消息的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveMyVisionAction) name:KMyVisionRedPointNotification object:nil];
    
    [self createTableView];
    [self createLoadView];
    [self requestData];
}

#pragma mark 收到监控消息通知
-(void)receiveMyVisionAction{
    [self requestData];
}

#pragma mark 创建加载视图
-(void)createLoadView{
    __weak __typeof(self) weakSelf=self;
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

#pragma mark 创建tableView
-(void)createTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-KNavigationBarHeight-45) style:UITableViewStyleGrouped];
    _tableView.showsVerticalScrollIndicator=YES;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorColor=KColorTableSeparator;
    _tableView.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.estimatedRowHeight=44;
    [self.view addSubview:_tableView];
    
    __weak __typeof(self) weakSelf=self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestData];
    }];
}

#pragma mark 请求数据
- (void)requestData{
    currentPage = 1;
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:[NSString stringWithFormat:@"%ld",currentPage] forKey:@"current"];
    [params setValue:@"10" forKey:@"size"];
    
    [[DDHttpManager sharedInstance]sendPostRequest:KHttpRequest_myMonitorList params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"**********我的监控动态列表数据***************%@",responseObject);
        
        //1-公司证书，2-人员证书, 3-认领公司，4-关注公司，5-本人证书，6-半日报
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        __weak __typeof(self) weakSelf = self;
        [_loadingView hiddenLoadingView];
        if (response.isSuccess) {
            if (![response isEmpty]) {
                [_dataSourceArr removeAllObjects];
                [_loadingView hiddenLoadingView];
                _dict = responseObject[KData];
                pageCount = [_dict[@"totalCount"] integerValue];
                NSArray *listArr=_dict[@"list"];
                
                if (listArr.count!=0) {
                    [_noResultView hide];
                    
                    [_dataSourceArr removeAllObjects];
                    for (NSDictionary *dic in listArr) {
                        DDMySuperVisionDynamicListModel *model = [[DDMySuperVisionDynamicListModel alloc]initWithDictionary:dic error:nil];
                        [model handleModel];
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
                    [_noResultView showWithTitle:@"暂无监控动态信息~" subTitle:nil image:@"noResult_content"];
                }
            }
            else{
                [_noResultView showWithTitle:@"暂无监控动态信息~" subTitle:nil image:@"noResult_content"];
            }
        }
        else{
            [_noResultView showWithTitle:@"暂无监控动态信息~" subTitle:nil image:@"noResult_content"];
        }
        
        [self.tableView.mj_header endRefreshing];
        
        if (_dataSourceArr.count>0) {
            [_tableView reloadData];
        }
        
    }  failure:^(NSURLSessionDataTask *operation, id responseObject)  {
        [DDUtils showToastWithMessage:kRequestFailed];
        [_loadingView failureLoadingView];
    }];
}

- (void)addData{
    currentPage++;
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [params setValue:[NSString stringWithFormat:@"%ld",currentPage] forKey:@"current"];
    [params setValue:@"10" forKey:@"size"];
    
    [[DDHttpManager sharedInstance]sendPostRequest:KHttpRequest_myMonitorList params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"**********我的监控动态列表数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        __weak __typeof(self) weakSelf = self;
        if (response.isSuccess) {
            if (![response isEmpty]) {
                _dict = responseObject[KData];
                NSArray *listArr = _dict[@"list"];
                
                for (NSDictionary *dic in listArr) {
                    DDMySuperVisionDynamicListModel *model = [[DDMySuperVisionDynamicListModel alloc]initWithDictionary:dic error:nil];
                    [model handleModel];
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

#pragma mark tableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataSourceArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DDMySuperVisionDynamicListModel *model=_dataSourceArr[indexPath.section];
    
    //main_type:1-公司证书，2-人员证书, 3-认领公司，4-关注公司，5-本人证书，6-半日报
    //sub_type:1-到期监控，2-中标监控，3-变更单位，4-公司名称变更，5-行政处罚，6-事故通知，7-人员电话公开，8-招标监控
    model.mainType = [NSString stringWithFormat:@"%@",model.mainType];
    if ([model.mainType isEqualToString:@"6"]) {//半日报
        static NSString * cellID = @"DDMySuperVisionDynamicList2Cell";
        DDMySuperVisionDynamicList2Cell * cell = (DDMySuperVisionDynamicList2Cell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
        }
        
        [cell loadDataWithModel:model];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else{//其余类型
        static NSString * cellID = @"DDMySuperVisionDynamicList1Cell";
        DDMySuperVisionDynamicList1Cell * cell = (DDMySuperVisionDynamicList1Cell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
        }
        [cell loadDataWithModel:model];
        cell.makeBtn.tag = 1000+indexPath.section;
        [cell.makeBtn addTarget:self action:@selector(hasClickMakeAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DDMySuperVisionDynamicListModel *model=_dataSourceArr[indexPath.section];
    if (![model.isReaded isEqualToString:@"1"]) {
        [self readOneItem:indexPath];
    }
    
    //处理跳转（我的监控的跳转）
    DDNewsJumpManager * newsJumpManager = [[DDNewsJumpManager alloc] init];
    newsJumpManager.mainViewContoller = self.mainViewContoller;
    newsJumpManager.model2 = model;
    [newsJumpManager handleJump];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    DDMySuperVisionDynamicListModel *model=_dataSourceArr[indexPath.section];
    model.mainType = [NSString stringWithFormat:@"%@",model.mainType];
    if ([model.mainType isEqualToString:@"6"]) {//半日报
        if(model.lineSplited.count>3){
            return 12+24+12+4*25+12;
        }
        return 12+24+12+model.lineSplited.count*25+12;
    }
    else{
        CGFloat infoH = 0;
        if([model.typeCode isEqualToString:@"SCE_001"]){
            infoH = 20;
        }else {
            infoH = 0;
        }
        
        if ([model.subType integerValue] == 2) {
            if ([model.mainType integerValue] == 5) {
                
                if(![DDUtils isEmptyString:model.lineB]){
                    NSString *nameStr = model.lineB;
                    if ([model.lineBString.string hasPrefix:@"中标:"]) {
                        nameStr = [NSString stringWithFormat:@"中标:%@",nameStr];
                    }
                    
                    CGSize labelSize = [[NSString stringWithFormat:@"%@",nameStr] boundingRectWithSize:CGSizeMake(Screen_Width-20, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:kFontSize28} context:nil].size;
                    return labelSize.height+125+infoH;
                }else{
                    if(![DDUtils isEmptyString:model.lineC]){
                        CGSize labelSize = [[NSString stringWithFormat:@"%@",model.lineC] boundingRectWithSize:CGSizeMake(Screen_Width-20, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:kFontSize28} context:nil].size;
                        return labelSize.height+105+infoH;
                    }
                }
            }else{
                if ([DDUtils isEmptyString:model.lineB]) {
                    if(![DDUtils isEmptyString:[NSString stringWithFormat:@"%@",model.lineC]]){
                        CGSize labelSize = [[NSString stringWithFormat:@"%@",model.lineC] boundingRectWithSize:CGSizeMake(Screen_Width-160, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:kFontSize28} context:nil].size;
                        return labelSize.height+120+infoH;
                    }
                }else{
                    if(![DDUtils isEmptyString:model.lineB]){
                        NSString *nameStr = model.lineB;
                        if ([model.lineBString.string hasPrefix:@"中标:"]) {
                            nameStr = [NSString stringWithFormat:@"中标:%@",nameStr];
                        }
                        
                        
                        CGSize labelSize = [[NSString stringWithFormat:@"%@",nameStr] boundingRectWithSize:CGSizeMake(Screen_Width-20, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:kFontSize28} context:nil].size;
                        return labelSize.height+125+infoH;
                    }
                }
            }
        }else{
            CGFloat labelH = 0;
            if(![DDUtils isEmptyString:model.lineB]){
                NSString *nameStr = model.lineB;
                if ([model.lineBString.string hasPrefix:@"中标:"]) {
                    nameStr = [NSString stringWithFormat:@"中标:%@",nameStr];
                }
                CGSize labelSize = [[NSString stringWithFormat:@"%@",nameStr] boundingRectWithSize:CGSizeMake(Screen_Width-20, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:kFontSize28} context:nil].size;
                labelH = labelSize.height;
            }
            if(![DDUtils isEmptyString:model.lineC]){
                CGSize labelSize = [[NSString stringWithFormat:@"%@",model.lineC] boundingRectWithSize:CGSizeMake(Screen_Width-20, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:kFontSize28} context:nil].size;
                return labelSize.height+105+infoH+labelH;
            }
        }
        return 110+infoH;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

-(void)hasClickMakeAction:(UIButton *)sender{
    DDMySuperVisionDynamicListModel *model=_dataSourceArr[sender.tag-1000];
    if ([sender.titleLabel.text isEqualToString:@"办理"]) {
        if ([model.typeCode isEqualToString:@"ECE_005"]) {
            DDServiceWebViewVC * checkVC = [DDServiceWebViewVC new];
            checkVC.hostUrl = @"http://gcdd.koncendy.com/apphs/enterprise_service/pages/handle_list.html?groupId=10&typeId=48&_t=1545135570014";
            [self.mainViewContoller.navigationController pushViewController:checkVC animated:YES];
            return;
        }
        //工商社保
        if ([model.typeCode isEqualToString:@"ECE_001"] ||[model.typeCode isEqualToString:@"ECE_002"] ){
            DDServiceWebViewVC *checkVC = [DDServiceWebViewVC new];
            checkVC.hostUrl = @"http://gcdd.koncendy.com/apphs/enterprise_service/pages/handle_list.html?groupId=7";
            [self.mainViewContoller.navigationController pushViewController:checkVC animated:YES];
            return;
        }
        //资质办理
        if ([model.typeCode isEqualToString:@"ECE_003"]){
            DDServiceWebViewVC *checkVC = [DDServiceWebViewVC new];
            checkVC.hostUrl = @"http://gcdd.koncendy.com/apphs/enterprise_service/pages/handle_list.html?groupId=1";
            [self.mainViewContoller.navigationController pushViewController:checkVC animated:YES];
            return;
        }
        //管理体系
        if ([model.typeCode isEqualToString:@"ECE_006"] || [model.typeCode isEqualToString:@"ECE_007"]) {
            DDServiceWebViewVC *checkVC = [DDServiceWebViewVC new];
            checkVC.hostUrl = @"http://gcdd.koncendy.com/apphs/enterprise_service/pages/handle_list.html?groupId=10";
            
            [self.mainViewContoller.navigationController pushViewController:checkVC animated:YES];
            return;
        }
        //施工工法
        if ([model.typeCode isEqualToString:@"ECE_008"]){
            DDServiceWebViewVC *checkVC = [DDServiceWebViewVC new];
            checkVC.hostUrl = @"http://gcdd.koncendy.com/apphs/enterprise_service/pages/handle_list.html?groupId=10";
            [self.mainViewContoller.navigationController pushViewController:checkVC animated:YES];
            return;
        }
        //安许证办理
        if ([model.typeCode isEqualToString:@"ECE_004"]){
            DDServiceWebViewVC *checkVC = [DDServiceWebViewVC new];
            checkVC.hostUrl = @"http://gcdd.koncendy.com/apphs/enterprise_service/pages/handle_list.html?groupId=2";
            [self.mainViewContoller.navigationController pushViewController:checkVC animated:YES];
            return;
        }
        if([model.typeCode isEqualToString:@"SCE_002"]||[model.typeCode isEqualToString:@"SCE_003"]) {//二建 //三类
            DDExamineTrainingVC *trainVC = [DDExamineTrainingVC new];
            trainVC.hidesBottomBarWhenPushed=YES;
            [self.mainViewContoller.navigationController pushViewController:trainVC animated:YES];
            return;
        }
        return;
    }
    
    if([model.subType isEqualToString:@"2"]){
        //        if ([model.in3Month integerValue] == 1) {
        //            //买履约保证险
        //            NSLog(@"买履约保证险");
        //        } else {
        //            //买质量保证险
        //            NSLog(@"买质量保证险");
        //        }
        DDServiceWebViewVC * checkVC = [DDServiceWebViewVC new];
        checkVC.hostUrl = @"http://gcdd.koncendy.com/apphs/insuranceAndCompanyTrading/#/insuranceList";
//        checkVC.hidesBottomBarWhenPushed=YES;
        checkVC.serviceWebViewType = DDServiceWebViewTypeOther;
        [self.mainViewContoller.navigationController pushViewController:checkVC animated:YES];
    }
}
#pragma mark 阅读单条记录
-(void)readOneItem:(NSIndexPath *)indexPath{
    DDMySuperVisionDynamicListModel *model=_dataSourceArr[indexPath.section];
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:1];
    [params setValue:model.id forKey:@"id"];
    
    [[DDHttpManager sharedInstance]sendPostRequest:KHttpRequest_monitorReadOne params:params success:^(NSURLSessionDataTask *operation, id responseObject){
        NSLog(@"阅读单条监控消息数据:%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
 
            model.isReaded=@"1";
            if (self.refreshNoticeBlock) {
                self.refreshNoticeBlock();
            }
            [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            
        }
        else{
            NSLog(@"阅读单条监控消息异常");
        }
        
    } failure:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"阅读单条监控消息失败");
    }];
}

#pragma mark dealloc取消通知建观察者
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:KMyVisionRedPointNotification object:nil];
}




@end
