//
//  DDFireEngineerDetailVC.m
//  GongChengDD
//
//  Created by xzx on 2018/9/25.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDFireEngineerDetailVC.h"
#import "DataLoadingView.h"
#import "DDNoResult2View.h"//无数据视图
#import "MJRefresh.h"
#import "DDFireEngineerDetail1Cell.h"//cell
#import "DDFireEngineerDetail2Cell.h"//cell
#import "DDFireEngineerDetailModel.h"//model
#import "DDFireEngineerMoreEduDetailVC.h"//继续教育情况
#import "DDFireEngineerExperienceDetailVC.h"//执业经历情况
#import "DDFireEngineerPunishDetailVC.h"//处罚情况
#import "DDFireEngineerChangeDetailVC.h"//变更记录
#import "DDPersonalClaimBenefitVC.h"//认领页面
#import "DDCertiExplainVC.h"//申述页面

#import "DDNavigationUtil.h"
#import "DDLoginCheckVC.h"//登录页面
#import <UShareUI/UShareUI.h>//友盟分享
#import <MessageUI/MessageUI.h>
@interface DDFireEngineerDetailVC ()<UITableViewDelegate,UITableViewDataSource,MFMessageComposeViewControllerDelegate>

{
    DDFireEngineerDetailModel *_model;
    
    UIView *_titleView;
}
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) DataLoadingView *loadingView;
@property (nonatomic,strong) DDNoResult2View *noResultView;//无数据视图
@property (strong,nonatomic)MFMessageComposeViewController *messageController;
@end

@implementation DDFireEngineerDetailVC

-(void)viewWillDisappear:(BOOL)animated{
    [_titleView removeFromSuperview];
}

-(void)viewWillAppear:(BOOL)animated{
    //[self requestData];
    [self.navigationController.navigationBar addSubview:_titleView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kColorBackGroundColor;
    self.navigationItem.leftBarButtonItem = [DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
    self.navigationItem.rightBarButtonItem=[DDUtils rightbuttonItemWithImage:@"right_share" highlightedImage:@"right_share" target:self action:@selector(shareClick)];
    [self setupTableView];
    [self setupDataLoadingView];
    [self requestData];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshData) name:KRefreshUI object:nil];//接收收到刷新页面的通知
}

-(void)refreshData{
    [self.tableView reloadData];
}
//分享
-(void)shareClick{
    if ([DDUtils isEmptyString:[DDUserManager sharedInstance].userid]) {//未登录
        DDLoginCheckVC * vc = [[DDLoginCheckVC alloc] init];
        vc.loginSuccessBlock = ^{
            //发出登录成功通知
        };
        
        UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
        [DDNavigationUtil setNavigationAndBottomLineWhiteColor:nav];
        [self showViewController:nav sender:nil];
    }
    else{//已登录
        [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine ),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Sms)]];
        //配置上面需求的参数
        [UMSocialShareUIConfig shareInstance].shareTitleViewConfig.isShow = NO;
        [UMSocialShareUIConfig shareInstance].shareCancelControlConfig.shareCancelControlText = @"取消";
        //显示分享面板
        [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
            // 根据获取的platformType确定所选平台进行下一步操作
            if (platformType == UMSocialPlatformType_Sms) {
                _messageController= [[MFMessageComposeViewController alloc] init];
                UINavigationItem * navigationItem = [[[_messageController viewControllers] lastObject] navigationItem];
                [navigationItem setTitle:@"新信息"];
                UIButton * cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
                [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
                [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
                [cancelButton addTarget:self action:@selector(cancelSendSMSClick) forControlEvents:UIControlEventTouchUpInside];
                navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:cancelButton];
                
                // 设置短信内容
                _messageController.body = [NSString stringWithFormat:@"下载工程点点,查看人员证书信息、变更记录及个人工程业绩。http://m.koncendy.com/pages/FireDetail/main?name=fireman&id=%@",self.id];
                // 设置代理
                _messageController.messageComposeDelegate = self;
                // 显示控制器
                [self presentViewController:_messageController animated:YES completion:nil];
            } else {
                UMShareWebpageObject * shareObject = [UMShareWebpageObject shareObjectWithTitle:[NSString stringWithFormat:@"消防工程师%@的证书",_model.staffName] descr:@"下载工程点点,查看人员证书信息、变更记录及个人工程业绩。" thumImage:[UIImage imageNamed:@"share_logo"]];
                //设置网页地址
                shareObject.webpageUrl =[NSString stringWithFormat:@"http://m.koncendy.com/pages/FireDetail/main?name=fireman&id=%@",self.id];
                
                //创建分享消息对象
                UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
                //分享消息对象设置分享内容对象
                messageObject.shareObject = shareObject;
                
                //调用分享接口
                [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
                    if (error) {
                        UMSocialLogInfo(@"************分享返回的结果：%@*********",error);
                    }
                    else{
                        if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                            UMSocialShareResponse *resp = data;
                            //分享结果消息
                            UMSocialLogInfo(@"response message is %@",resp.message);
                            //第三方原始返回的数据
                            UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                            
                        }else{
                            UMSocialLogInfo(@"response data is %@",data);
                        }
                    }
                }];
            }
        }];
    }
}
- (void)cancelSendSMSClick{
    [_messageController dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark 返回上一页
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupTableView{
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,0, Screen_Width, Screen_Height-KNavigationBarHeight) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor=[UIColor clearColor];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    _tableView.backgroundColor=kColorBackGroundColor;
    [self.tableView setSeparatorColor:KColorTableSeparator];
    self.tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width,KTableViewFooterViewHeight)];
    [self.view addSubview:self.tableView];
    _tableView.estimatedRowHeight = 44;
}

- (void)setupDataLoadingView{
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

#pragma mark 请求数据
- (void)requestData{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:self.id forKey:@"id"];
    
    __weak typeof(self) weakSelf=self;
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_fireEngineerDetail params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"**********消防工程师详情数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        //__weak __typeof(self) weakSelf = self;
        if (response.isSuccess) {
            [_loadingView hiddenLoadingView];
            
            if (responseObject[KData]!=[NSNull null]) {//有数据
                [_noResultView hide];
                NSDictionary *dict = responseObject[KData];
                _model = [[DDFireEngineerDetailModel alloc]initWithDictionary:dict error:nil];
                
                //标题
                CGRect frame1 = [_model.staffName boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:KfontSize34Bold} context:nil];
                CGRect frame2 = [@"消防工程师" boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
                _titleView=[[UIView alloc]initWithFrame:CGRectMake((Screen_Width-(frame1.size.width+5+frame2.size.width))/2, 12, frame1.size.width+5+frame2.size.width, 20)];
                
                UILabel *lab1=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame1.size.width, 20)];
                lab1.text=_model.staffName;
                lab1.textColor=KColorCompanyTitleBalck;
                lab1.font=KfontSize34Bold;
                [_titleView addSubview:lab1];
                
                UILabel *lab2=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lab1.frame)+5, 0, frame2.size.width, 20)];
                lab2.text=@"消防工程师";
                lab2.textColor=KColorGreySubTitle;
                lab2.font=kFontSize30;
                [_titleView addSubview:lab2];
                
                [weakSelf.navigationController.navigationBar addSubview:_titleView];
            }
            else{//数据为空
                [_noResultView showWithTitle:@"暂无相关消防工程师信息" subTitle:@"去其他地方看看~" image:@"noResult_content"];
            }
        }
        else{
            
            [_loadingView failureLoadingView];
        }
        
        [weakSelf.tableView.mj_header endRefreshing];
        [_tableView reloadData];
        
    }  failure:^(NSURLSessionDataTask *operation, id responseObject)  {
        [DDUtils showToastWithMessage:kRequestFailed];
        [_loadingView failureLoadingView];
    }];
}


#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }
    else{
        return 4;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        static NSString * cellID = @"DDFireEngineerDetail1Cell";
        DDFireEngineerDetail1Cell * cell = (DDFireEngineerDetail1Cell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell loadDataWithModel:_model];
        [cell.makeBtn addTarget:self action:@selector(checkBtnClick) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    else{
        static NSString * cellID = @"DDFireEngineerDetail2Cell";
        DDFireEngineerDetail2Cell * cell = (DDFireEngineerDetail2Cell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
        }
        
        if (indexPath.row==0) {
            cell.titleLab.text=@"继续教育情况";
        }
        else if(indexPath.row==1){
            cell.titleLab.text=@"变更记录";
        }
        else if(indexPath.row==2){
            cell.titleLab.text=@"执业经历";
        }
        else if(indexPath.row==3){
            cell.titleLab.text=@"处罚信息";
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section==1) {
        if (indexPath.row==0) {
            DDFireEngineerMoreEduDetailVC *moreEdu=[[DDFireEngineerMoreEduDetailVC alloc]init];
            moreEdu.staffId=self.id;
            [self.navigationController pushViewController:moreEdu animated:YES];
        }
        else if (indexPath.row==1) {
            DDFireEngineerChangeDetailVC *change=[[DDFireEngineerChangeDetailVC alloc]init];
            change.staffId=self.staffInfoId;
            [self.navigationController pushViewController:change animated:YES];
        }
        else if (indexPath.row==2) {
            DDFireEngineerExperienceDetailVC *experience=[[DDFireEngineerExperienceDetailVC alloc]init];
            experience.staffId=self.id;
            [self.navigationController pushViewController:experience animated:YES];
        }
        else if (indexPath.row==3) {
            DDFireEngineerPunishDetailVC *punish=[[DDFireEngineerPunishDetailVC alloc]init];
            punish.staffId=self.id;
            [self.navigationController pushViewController:punish animated:YES];
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return UITableViewAutomaticDimension;
    }
    else{
        return 47;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGFLOAT_MIN;
    }
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(void)checkBtnClick{//认领
    DDPersonalClaimBenefitVC *vc=[[DDPersonalClaimBenefitVC alloc]init];
    vc.claimBenefitType = DDClaimBenefitTypeDefault;
    vc.peopleName = _model.staffName;
    vc.peopleId = _model.staffId;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:KRefreshUI object:nil];
}
@end
