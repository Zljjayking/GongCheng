//
//  DDAllSearchVC.m
//  GongChengDD
//
//  Created by xzx on 2018/5/10.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDAllSearchVC.h"
#import "DDNavigationUtil.h"
#import "DDLoginVC.h"//登录注册页面
#import "DDAllSearchCell.h"//浏览历史和热门搜索cell
#import "DDAllSearchRecentCell.h"//最近搜索cell（阵列Button）
#import "DDHotSearchModel.h"//热门搜索model
#import "DDGlobalListVC.h"//全局搜索列表页面
#import "DDSearchHistoryDAOAndDB.h"//搜索历史数据库操作类
#import "DDSearchRecordModel.h"//数据库专用model
#import "DDCompanyDetailVC.h"//公司详情页面
#import "DDProjectDetailVC.h"//项目详情页面
#import "DDPeopleDetailVC.h"//人员详情页面
#import "DDSearchCompanyListVC.h"//公司搜索列表页（非全局搜索）(查资质共用页面)
#import "DDSearchBuilderAndManagerListVC.h"//建造师和项目经理搜索列表页（非全局搜索）(建造师和项目经理共用页面)
#import "DDSearchBossAndSafemanListVC.h"//找老板和安全员搜索列表页（非全局搜索）(找老板和安全员共用页面)
#import "DDSearchBiddingListVC.h"//查中标搜索列表页（非全局搜索）
#import "DDSearchAdminPunishListVC.h"//行政处罚搜索列表页（非全局搜索）
#import "DDSearchAccidentSituationListVC.h"//事故情况搜索列表页（非全局搜索）
#import "DDSearchRewardGloryListVC.h"//获奖荣誉搜索列表页（非全局搜索）
#import "DDSearchCourtNoticeListVC.h"//法院公告搜索列表页（非全局搜索）
#import "DDSearchJudgePaperListVC.h"//裁判文书搜索列表页（非全局搜索）
#import "DDSearchBuyCompanyListVC.h"//买公司搜索列表页面（非全局搜索）
#import "DDSearchTelephoneListVC.h"//找电话搜索列表页面（非全局搜索）
#import "DDSearchExcutedPeopleListVC.h"//被执行人和失信信息搜索列表页面（非全局搜索）
#import "DDSearchContractCopyVC.h"//合同备案搜索列表页面（非全局搜索）
#import "DDSearchSafeCertiListVC.h"//搜索安许证列表页（非全局搜索）
#import "DDBuyCompanyDetailVC.h"//买公司详情页面
#import "DDAdminPunishDetailVC.h"//行政处罚详情页面
#import "DDAccidentSituationDetailVC.h"//事故情况详情页面
#import "DDRewardGloryDetailVC.h"//获奖荣誉详情页面
#import "DDCourtNoticeDetailVC.h"//法院公告详情页面
#import "DDJudgePaperDetailVC.h"//裁判文书详情页面
#import "DDGainBiddingDetailVC.h"//中标详情页面

@interface DDAllSearchVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,DDAllSearchRecentCellDelegate>

{
    UIView *_topBgView;
    NSMutableArray *_recentSearch;//存放最近搜索词条
    NSMutableArray *_dataSource;//存放浏览历史词条或者热门搜索词条
    
    BOOL _isFromDB;
    
    NSInteger _index;//存储DDGlobalListVC页面反传过来的segment位置索引号
}
@property (nonatomic,strong) UITextField *textField;
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation DDAllSearchVC

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar addSubview:_topBgView];
    [_recentSearch removeAllObjects];
    [_dataSource removeAllObjects];
    //[self createTableView];
    [self getDataFromDB];
    if ([self.audioType isEqualToString:@"1"]) {//特例：从语音搜索跳过来的
        _textField.text=self.audioSingleText;
        self.audioSingleText=@"";
    }
    else{
        _textField.text=@"";
    }
    
    //导航底部线条设为透明
    [DDNavigationUtil setNavigationBottomLineClearColor:self.navigationController];
}

-(void)viewDidAppear:(BOOL)animated{
    [_textField becomeFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated{
    [_topBgView removeFromSuperview];
    
    //还原导航底部线条颜色
    [DDNavigationUtil setNavigationBottomLineNomalColor:self.navigationController];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _index=0;
    [self editNavItem];
    [self createTableView];
    [self getDataFromDB];
    //[_textField becomeFirstResponder];
}

//从数据库取最近搜索和浏览历史数据
-(void)getDataFromDB{
    if ([self.type isEqualToString:@"1"]) {//表示从首页公共搜索进入
        NSMutableArray *array1=[NSMutableArray arrayWithArray:[DDSearchHistoryDAOAndDB queryRecentSearchByTypeId:@"9909"]];
        _recentSearch=[NSMutableArray arrayWithArray:[[array1 reverseObjectEnumerator] allObjects]];
        
        NSMutableArray *array2=[NSMutableArray arrayWithArray:[DDSearchHistoryDAOAndDB queryHistorySearchByTypeId:@"9909"]];
        _dataSource=[NSMutableArray arrayWithArray:[[array2 reverseObjectEnumerator] allObjects]];
    }
    else{
        NSMutableArray *array1=[NSMutableArray arrayWithArray:[DDSearchHistoryDAOAndDB queryRecentSearchByTypeId:self.menuId]];
        _recentSearch=[NSMutableArray arrayWithArray:[[array1 reverseObjectEnumerator] allObjects]];
        
        NSMutableArray *array2=[NSMutableArray arrayWithArray:[DDSearchHistoryDAOAndDB queryHistorySearchByTypeId:self.menuId]];
        _dataSource=[NSMutableArray arrayWithArray:[[array2 reverseObjectEnumerator] allObjects]];
    }
    
    if (_dataSource.count>0) {//表明此处数据库中能取到数据的
        _isFromDB=YES;
        [_tableView reloadData];
    }
    else{//表明此处需要调接口拿数据了
        _isFromDB=NO;
        
        [self requestData];
    }
}

//定制导航条
-(void)editNavItem{
    self.navigationItem.hidesBackButton = YES;
    self.view.backgroundColor=kColorBackGroundColor;
    
    _topBgView=[[UIView alloc]initWithFrame:CGRectMake(15, 4.5, Screen_Width-30, 35)];
    [self.navigationController.navigationBar addSubview:_topBgView];
    
    UIView *leftBgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width-30-60, 35)];
    leftBgView.layer.cornerRadius=5;
    leftBgView.clipsToBounds=YES;
    leftBgView.backgroundColor=KColorSearchTextFieldGrey;
    [_topBgView addSubview:leftBgView];
    
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 15, 15)];
    imageView.image=[UIImage imageNamed:@"cm_Search_icon"];
    [leftBgView addSubview:imageView];
    
    _textField=[[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+10, 0, Screen_Width-30-60-20-20, 35)];
    _textField.delegate=self;
    //_textField.placeholder=@"请输入企业名称、老板、资质等";
    _textField.placeholder=self.placeholderText;
    [_textField setValue:KColorGreyLight forKeyPath:@"_placeholderLabel.textColor"];
    [_textField setValue:kFontSize30 forKeyPath:@"_placeholderLabel.font"];
    _textField.clearButtonMode=UITextFieldViewModeAlways;
    [leftBgView addSubview:_textField];
    _textField.returnKeyType = UIReturnKeySearch;
    //添加监听文本框文字的改变
    [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    UIButton *cancelBtn=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(leftBgView.frame), 0, 60, 35)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font=kFontSize34;
    cancelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    cancelBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
    [cancelBtn addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitleColor:kColorBlue forState:UIControlStateNormal];
    [_topBgView addSubview:cancelBtn];
}

//返回上一页
- (void)goback{
    [self.navigationController popViewControllerAnimated:NO];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.text.length<2) {
        //[DDUtils showToastWithMessage:@"请输入2个或2个以上关键字"];
    }
    else{
        if ([self.type isEqualToString:@"1"]) {//表示从首页公共搜索进入
            DDGlobalListVC *globalListVC=[[DDGlobalListVC alloc]init];
            globalListVC.index=_index;
            globalListVC.indexBlock = ^(NSInteger index) {
                _index=index;
            };
            globalListVC.searchText=textField.text;
            [self.navigationController pushViewController:globalListVC animated:NO];
        }
        else{
            if ([self.menuId isEqualToString:@"6"]) {//公司列表
                DDSearchCompanyListVC *searchCompanyListVC=[[DDSearchCompanyListVC alloc]init];
                searchCompanyListVC.searchText=textField.text;
                searchCompanyListVC.menuId=self.menuId;
                [self.navigationController pushViewController:searchCompanyListVC animated:NO];
            }
            else if ([self.menuId isEqualToString:@"18"]) {//建造师
                DDSearchBuilderAndManagerListVC *builderAndManager=[[DDSearchBuilderAndManagerListVC alloc]init];
                builderAndManager.searchText=textField.text;
                builderAndManager.menuId=self.menuId;
                [self.navigationController pushViewController:builderAndManager animated:NO];
            }
            else if ([self.menuId isEqualToString:@"23"]) {//项目经理
                DDSearchBuilderAndManagerListVC *builderAndManager=[[DDSearchBuilderAndManagerListVC alloc]init];
                builderAndManager.searchText=textField.text;
                builderAndManager.menuId=self.menuId;
                [self.navigationController pushViewController:builderAndManager animated:NO];
            }
            else if ([self.menuId isEqualToString:@"7"]) {//找老板
                DDSearchBossAndSafemanListVC *bossAndSafeman=[[DDSearchBossAndSafemanListVC alloc]init];
                bossAndSafeman.searchText=textField.text;
                bossAndSafeman.menuId=self.menuId;
                [self.navigationController pushViewController:bossAndSafeman animated:NO];
            }
            else if ([self.menuId isEqualToString:@"19"]) {//安全员
                DDSearchBossAndSafemanListVC *bossAndSafeman=[[DDSearchBossAndSafemanListVC alloc]init];
                bossAndSafeman.searchText=textField.text;
                bossAndSafeman.menuId=self.menuId;
                [self.navigationController pushViewController:bossAndSafeman animated:NO];
            }
            else if ([self.menuId isEqualToString:@"22"]) {//查中标
                DDSearchBiddingListVC *searchBidding=[[DDSearchBiddingListVC alloc]init];
                searchBidding.searchText=textField.text;
                searchBidding.menuId=self.menuId;
                [self.navigationController pushViewController:searchBidding animated:NO];
            }
            else if ([self.menuId isEqualToString:@"24"]) {//行政处罚
                DDSearchAdminPunishListVC *searchAdminPunish=[[DDSearchAdminPunishListVC alloc]init];
                searchAdminPunish.searchText=textField.text;
                searchAdminPunish.menuId=self.menuId;
                [self.navigationController pushViewController:searchAdminPunish animated:NO];
            }
            else if ([self.menuId isEqualToString:@"25"]) {//事故情况
                DDSearchAccidentSituationListVC *searchAccidentSituation=[[DDSearchAccidentSituationListVC alloc]init];
                searchAccidentSituation.searchText=textField.text;
                searchAccidentSituation.menuId=self.menuId;
                [self.navigationController pushViewController:searchAccidentSituation animated:NO];
            }
            else if ([self.menuId isEqualToString:@"27"]) {//获奖荣誉
                DDSearchRewardGloryListVC *searchRewardGlory=[[DDSearchRewardGloryListVC alloc]init];
                searchRewardGlory.searchText=textField.text;
                searchRewardGlory.menuId=self.menuId;
                [self.navigationController pushViewController:searchRewardGlory animated:NO];
            }
            else if ([self.menuId isEqualToString:@"88"]) {//法院公告
                DDSearchCourtNoticeListVC *searchCourtNotice=[[DDSearchCourtNoticeListVC alloc]init];
                searchCourtNotice.searchText=textField.text;
                searchCourtNotice.menuId=self.menuId;
                [self.navigationController pushViewController:searchCourtNotice animated:NO];
            }
            else if ([self.menuId isEqualToString:@"89"]) {//裁判文书
                DDSearchJudgePaperListVC *searchJudgePaper=[[DDSearchJudgePaperListVC alloc]init];
                searchJudgePaper.searchText=textField.text;
                searchJudgePaper.menuId=self.menuId;
                [self.navigationController pushViewController:searchJudgePaper animated:NO];
            }
            else if ([self.menuId isEqualToString:@"16"]) {//找资质（就是找企业）
                DDSearchCompanyListVC *searchCompanyListVC=[[DDSearchCompanyListVC alloc]init];
                searchCompanyListVC.searchText=textField.text;
                searchCompanyListVC.menuId=self.menuId;
                [self.navigationController pushViewController:searchCompanyListVC animated:NO];
            }
            else if ([self.menuId isEqualToString:@"17"]) {//安许证（就是找企业）
                DDSearchSafeCertiListVC *searchCompanyListVC=[[DDSearchSafeCertiListVC alloc]init];
                searchCompanyListVC.searchText=textField.text;
                searchCompanyListVC.menuId=self.menuId;
                [self.navigationController pushViewController:searchCompanyListVC animated:NO];
            }
            else if ([self.menuId isEqualToString:@"9"]) {//买公司
                DDSearchBuyCompanyListVC *buyCompanyList=[[DDSearchBuyCompanyListVC alloc]init];
                buyCompanyList.menuId=self.menuId;
                buyCompanyList.searchText=textField.text;
                [self.navigationController pushViewController:buyCompanyList animated:NO];
            }
            else if ([self.menuId isEqualToString:@"8"]) {//找电话
                DDSearchTelephoneListVC *telephoneList=[[DDSearchTelephoneListVC alloc]init];
                telephoneList.menuId=self.menuId;
                telephoneList.searchText=textField.text;
                [self.navigationController pushViewController:telephoneList animated:NO];
            }
            else if ([self.menuId isEqualToString:@"87"]) {//被执行人
                DDSearchExcutedPeopleListVC *executedList=[[DDSearchExcutedPeopleListVC alloc]init];
                executedList.menuId=self.menuId;
                executedList.nameText=textField.text;
                [self.navigationController pushViewController:executedList animated:NO];
            }
            else if ([self.menuId isEqualToString:@"86"]) {//失信信息
                DDSearchExcutedPeopleListVC *executedList=[[DDSearchExcutedPeopleListVC alloc]init];
                executedList.menuId=self.menuId;
                executedList.nameText=textField.text;
                [self.navigationController pushViewController:executedList animated:NO];
            }
            else  if ([self.menuId isEqualToString:@"122"]) {//合同备案
                DDSearchContractCopyVC *contractCopyList=[[DDSearchContractCopyVC alloc]init];
                contractCopyList.menuId=self.menuId;
                contractCopyList.searchText=textField.text;
                [self.navigationController pushViewController:contractCopyList animated:NO];
            }
        }
    }
    
    [_textField resignFirstResponder];
    return YES;
}

//有文字输入了
- (void)textFieldDidChange:(UITextField *)textField{
    UITextRange *rang = textField.markedTextRange;//获取非=选中状态文字范围
    if (rang == nil) {//没有非选中状态文字.就是确定的文字输入
        if ([textField.text isEqual:@""]) {
            //不处理
        }
        else{//跳转到相应的搜索列表页面
            if (textField.text.length<2) {
                //[DDUtils showToastWithMessage:@"请输入2个或2个以上关键字"];
            }
            else{
                if ([self.type isEqualToString:@"1"]) {//表示从首页公共搜索进入
                    DDGlobalListVC *globalListVC=[[DDGlobalListVC alloc]init];
                    globalListVC.index=_index;
                    globalListVC.indexBlock = ^(NSInteger index) {
                        _index=index;
                    };
                    globalListVC.searchText=textField.text;
                    [self.navigationController pushViewController:globalListVC animated:NO];
                }
                else{
                    if ([self.menuId isEqualToString:@"6"]) {//公司列表
                        DDSearchCompanyListVC *searchCompanyListVC=[[DDSearchCompanyListVC alloc]init];
                        searchCompanyListVC.searchText=textField.text;
                        searchCompanyListVC.menuId=self.menuId;
                        [self.navigationController pushViewController:searchCompanyListVC animated:NO];
                    }
                    else if ([self.menuId isEqualToString:@"18"]) {//建造师
                        DDSearchBuilderAndManagerListVC *builderAndManager=[[DDSearchBuilderAndManagerListVC alloc]init];
                        builderAndManager.searchText=textField.text;
                        builderAndManager.menuId=self.menuId;
                        [self.navigationController pushViewController:builderAndManager animated:NO];
                    }
                    else if ([self.menuId isEqualToString:@"23"]) {//项目经理
                        DDSearchBuilderAndManagerListVC *builderAndManager=[[DDSearchBuilderAndManagerListVC alloc]init];
                        builderAndManager.searchText=textField.text;
                        builderAndManager.menuId=self.menuId;
                        [self.navigationController pushViewController:builderAndManager animated:NO];
                    }
                    else if ([self.menuId isEqualToString:@"7"]) {//找老板
                        DDSearchBossAndSafemanListVC *bossAndSafeman=[[DDSearchBossAndSafemanListVC alloc]init];
                        bossAndSafeman.searchText=textField.text;
                        bossAndSafeman.menuId=self.menuId;
                        [self.navigationController pushViewController:bossAndSafeman animated:NO];
                    }
                    else if ([self.menuId isEqualToString:@"19"]) {//安全员
                        DDSearchBossAndSafemanListVC *bossAndSafeman=[[DDSearchBossAndSafemanListVC alloc]init];
                        bossAndSafeman.searchText=textField.text;
                        bossAndSafeman.menuId=self.menuId;
                        [self.navigationController pushViewController:bossAndSafeman animated:NO];
                    }
                    else if ([self.menuId isEqualToString:@"22"]) {//查中标
                        DDSearchBiddingListVC *searchBidding=[[DDSearchBiddingListVC alloc]init];
                        searchBidding.searchText=textField.text;
                        searchBidding.menuId=self.menuId;
                        [self.navigationController pushViewController:searchBidding animated:NO];
                    }
                    else if ([self.menuId isEqualToString:@"24"]) {//行政处罚
                        DDSearchAdminPunishListVC *searchAdminPunish=[[DDSearchAdminPunishListVC alloc]init];
                        searchAdminPunish.searchText=textField.text;
                        searchAdminPunish.menuId=self.menuId;
                        [self.navigationController pushViewController:searchAdminPunish animated:NO];
                    }
                    else if ([self.menuId isEqualToString:@"25"]) {//事故情况
                        DDSearchAccidentSituationListVC *searchAccidentSituation=[[DDSearchAccidentSituationListVC alloc]init];
                        searchAccidentSituation.searchText=textField.text;
                        searchAccidentSituation.menuId=self.menuId;
                        [self.navigationController pushViewController:searchAccidentSituation animated:NO];
                    }
                    else if ([self.menuId isEqualToString:@"27"]) {//获奖荣誉
                        DDSearchRewardGloryListVC *searchRewardGlory=[[DDSearchRewardGloryListVC alloc]init];
                        searchRewardGlory.searchText=textField.text;
                        searchRewardGlory.menuId=self.menuId;
                        [self.navigationController pushViewController:searchRewardGlory animated:NO];
                    }
                    else if ([self.menuId isEqualToString:@"88"]) {//法院公告
                        DDSearchCourtNoticeListVC *searchCourtNotice=[[DDSearchCourtNoticeListVC alloc]init];
                        searchCourtNotice.searchText=textField.text;
                        searchCourtNotice.menuId=self.menuId;
                        [self.navigationController pushViewController:searchCourtNotice animated:NO];
                    }
                    else if ([self.menuId isEqualToString:@"89"]) {//裁判文书
                        DDSearchJudgePaperListVC *searchJudgePaper=[[DDSearchJudgePaperListVC alloc]init];
                        searchJudgePaper.searchText=textField.text;
                        searchJudgePaper.menuId=self.menuId;
                        [self.navigationController pushViewController:searchJudgePaper animated:NO];
                    }
                    else if ([self.menuId isEqualToString:@"16"]) {//找资质（就是找企业）
                        DDSearchCompanyListVC *searchCompanyListVC=[[DDSearchCompanyListVC alloc]init];
                        searchCompanyListVC.searchText=textField.text;
                        searchCompanyListVC.menuId=self.menuId;
                        [self.navigationController pushViewController:searchCompanyListVC animated:NO];
                    }
                    else if ([self.menuId isEqualToString:@"17"]) {//安许证（就是找企业）
                        DDSearchSafeCertiListVC *searchCompanyListVC=[[DDSearchSafeCertiListVC alloc]init];
                        searchCompanyListVC.searchText=textField.text;
                        searchCompanyListVC.menuId=self.menuId;
                        [self.navigationController pushViewController:searchCompanyListVC animated:NO];
                    }
                    else if ([self.menuId isEqualToString:@"9"]) {//买公司
                        DDSearchBuyCompanyListVC *buyCompanyList=[[DDSearchBuyCompanyListVC alloc]init];
                        buyCompanyList.menuId=self.menuId;
                        buyCompanyList.searchText=textField.text;
                        [self.navigationController pushViewController:buyCompanyList animated:NO];
                    }
                    else if ([self.menuId isEqualToString:@"8"]) {//找电话
                        DDSearchTelephoneListVC *telephoneList=[[DDSearchTelephoneListVC alloc]init];
                        telephoneList.menuId=self.menuId;
                        telephoneList.searchText=textField.text;
                        [self.navigationController pushViewController:telephoneList animated:NO];
                    }
                    else if ([self.menuId isEqualToString:@"87"]) {//被执行人
                        DDSearchExcutedPeopleListVC *executedList=[[DDSearchExcutedPeopleListVC alloc]init];
                        executedList.menuId=self.menuId;
                        executedList.nameText=textField.text;
                        [self.navigationController pushViewController:executedList animated:NO];
                    }
                    else if ([self.menuId isEqualToString:@"86"]) {//失信信息
                        DDSearchExcutedPeopleListVC *executedList=[[DDSearchExcutedPeopleListVC alloc]init];
                        executedList.menuId=self.menuId;
                        executedList.nameText=textField.text;
                        [self.navigationController pushViewController:executedList animated:NO];
                    }
                    else  if ([self.menuId isEqualToString:@"122"]) {//合同备案
                        DDSearchContractCopyVC *contractCopyList=[[DDSearchContractCopyVC alloc]init];
                        contractCopyList.menuId=self.menuId;
                        contractCopyList.searchText=textField.text;
                        [self.navigationController pushViewController:contractCopyList animated:NO];
                    }
                }
            }
        }
    }
}

//请求热门搜索数据
-(void)requestData{
    NSMutableDictionary *param=[[NSMutableDictionary alloc]init];
    if ([self.type isEqualToString:@"1"]) {//全局搜索
        param[@"searchType"]=@"-1";
    }
    else{
        param[@"searchType"]=self.menuId;
    }
    
    MBProgressHUD *hud=[DDUtils showHUDCustom:@""];
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_listHotCompany params:param success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"***********热门搜索请求数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {//请求成功
            [_dataSource removeAllObjects];
            NSArray *listArr= responseObject[KData];
            for (NSDictionary *dic in listArr) {
                DDHotSearchModel *model=[[DDHotSearchModel alloc]initWithDictionary:dic error:nil];
                [_dataSource addObject:model];
            }
        }
        else{//显示异常
            [DDUtils showToastWithMessage:response.message];
        }
        [hud hide:YES];
        [_tableView reloadData];
        
    } failure:^(NSURLSessionDataTask *operation, id responseObject) {
        [hud hide:YES];
        [DDUtils showToastWithMessage:kRequestFailed];
    }];
}

//创建tableView
-(void)createTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-KNavigationBarHeight) style:UITableViewStylePlain];
    _tableView.backgroundColor=kColorBackGroundColor;
    [self.view addSubview:_tableView];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.separatorColor=KColorTableSeparator;
    _tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    
    [_tableView registerNib:[UINib nibWithNibName:@"DDAllSearchCell" bundle:nil] forCellReuseIdentifier:@"DDAllSearchCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"DDAllSearchRecentCell" bundle:nil] forCellReuseIdentifier:@"DDAllSearchRecentCell"];
}

#pragma mark tableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }
    else{
        return _dataSource.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        DDAllSearchRecentCell *cell=[tableView dequeueReusableCellWithIdentifier:@"DDAllSearchRecentCell" forIndexPath:indexPath];
        
        NSMutableArray  *strArray=[[NSMutableArray alloc]init];
        for (DDSearchRecordModel *model in _recentSearch) {
            [strArray addObject:model.title];
        }
        cell.delegate=self;
        [cell loadCellWithBtns:strArray];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    else{
        if (_isFromDB==YES) {//浏览历史
            DDAllSearchCell *cell=[tableView dequeueReusableCellWithIdentifier:@"DDAllSearchCell" forIndexPath:indexPath];
            
            DDSearchRecordModel *model=_dataSource[indexPath.row];
//            NSAttributedString *title = [[NSAttributedString alloc] initWithData:[model.title dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
//            cell.titleLab.attributedText = title;
            cell.titleLab.text = model.title;
            cell.titleLab.textColor=KColorBlackTitle;
            cell.titleLab.font=kFontSize30;
            cell.iconImg.image=[UIImage imageNamed:@"home_history"];
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
        else{//热门搜索
            DDAllSearchCell *cell=[tableView dequeueReusableCellWithIdentifier:@"DDAllSearchCell" forIndexPath:indexPath];
            
            DDHotSearchModel *model=_dataSource[indexPath.row];
            cell.titleLab.text=model.searchTitle;
            cell.iconImg.image=[UIImage imageNamed:@"home_hot"];
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1) {
        if (_isFromDB==YES) {//浏览历史（从数据库获取）（跳详情）
            
            if ([DDUtils isEmptyString:[DDUserManager sharedInstance].userid]) {
                [self presentLoginVCWithIndexPath:indexPath];
            }
            else{
                DDSearchRecordModel *model=_dataSource[indexPath.row];
                
                if ([self.type isEqualToString:@"1"]) {//全局搜索的三种情况
                    if ([model.globalType isEqualToString:@"0"]) {//公司详情
                        [DDSearchHistoryDAOAndDB insertHistorySearchByTypeId:@"9909" andSearchResult:model.title andGlobalType:@"0" andTransId:model.transId];
                        [self getDataFromDB];
                        
                        DDCompanyDetailVC *companyDetail=[[DDCompanyDetailVC alloc]init];
                        companyDetail.enterpriseId=model.transId;
                        [self.navigationController pushViewController:companyDetail animated:YES];
                    }
                    else if([model.globalType isEqualToString:@"1"]){//人员详情
                        [DDSearchHistoryDAOAndDB insertHistorySearchByTypeId:@"9909" andSearchResult:model.title andGlobalType:@"1" andTransId:model.transId];
                        [self getDataFromDB];
                        
                        DDPeopleDetailVC *peopleDetail=[[DDPeopleDetailVC alloc]init];
                        peopleDetail.staffInfoId=model.transId;
                        [self.navigationController pushViewController:peopleDetail animated:YES];
                    }
                    else if([model.globalType isEqualToString:@"2"]){//项目详情
                        [DDSearchHistoryDAOAndDB insertHistorySearchByTypeId:@"9909" andSearchResult:model.title andGlobalType:@"2" andTransId:model.transId];
                        [self getDataFromDB];
                        
                        DDProjectDetailVC *projectDetail=[[DDProjectDetailVC alloc]init];
                        projectDetail.winCaseId=model.transId;
                        [self.navigationController pushViewController:projectDetail animated:YES];
                    }
                }
                else {//分类搜索的情况
                    if ([self.menuId isEqualToString:@"6"]) {//公司详情页面
                        [DDSearchHistoryDAOAndDB insertHistorySearchByTypeId:self.menuId andSearchResult:model.title andGlobalType:nil andTransId:model.transId];
                        [self getDataFromDB];
                        
                        DDCompanyDetailVC *companyDetail=[[DDCompanyDetailVC alloc]init];
                        companyDetail.enterpriseId=model.transId;
                        [self.navigationController pushViewController:companyDetail animated:YES];
                    }
                    if ([self.menuId isEqualToString:@"18"]) {//建造师详情页面
                        [DDSearchHistoryDAOAndDB insertHistorySearchByTypeId:self.menuId andSearchResult:model.title andGlobalType:nil andTransId:model.transId];
                        [self getDataFromDB];
                        
                        DDPeopleDetailVC *peopleDetail=[[DDPeopleDetailVC alloc]init];
                        peopleDetail.staffInfoId=model.transId;
                        [self.navigationController pushViewController:peopleDetail animated:YES];
                    }
                    if ([self.menuId isEqualToString:@"23"]) {//项目经理详情页面
                        [DDSearchHistoryDAOAndDB insertHistorySearchByTypeId:self.menuId andSearchResult:model.title andGlobalType:nil andTransId:model.transId];
                        [self getDataFromDB];
                        
                        DDPeopleDetailVC *peopleDetail=[[DDPeopleDetailVC alloc]init];
                        peopleDetail.staffInfoId=model.transId;
                        [self.navigationController pushViewController:peopleDetail animated:YES];
                    }
                    if ([self.menuId isEqualToString:@"7"]) {//找老板详情页面
                        [DDSearchHistoryDAOAndDB insertHistorySearchByTypeId:self.menuId andSearchResult:model.title andGlobalType:nil andTransId:model.transId];
                        [self getDataFromDB];
                        
                        DDPeopleDetailVC *peopleDetail=[[DDPeopleDetailVC alloc]init];
                        peopleDetail.staffInfoId=model.transId;
                        [self.navigationController pushViewController:peopleDetail animated:YES];
                    }
                    if ([self.menuId isEqualToString:@"19"]) {//安全员详情页面
                        [DDSearchHistoryDAOAndDB insertHistorySearchByTypeId:self.menuId andSearchResult:model.title andGlobalType:nil andTransId:model.transId];
                        [self getDataFromDB];
                        
                        DDPeopleDetailVC *peopleDetail=[[DDPeopleDetailVC alloc]init];
                        peopleDetail.staffInfoId=model.transId;
                        [self.navigationController pushViewController:peopleDetail animated:YES];
                    }
                    if ([self.menuId isEqualToString:@"22"]) {//查中标详情页面（同项目详情页面）
                        [DDSearchHistoryDAOAndDB insertHistorySearchByTypeId:self.menuId andSearchResult:model.title andGlobalType:nil andTransId:model.transId];
                        [self getDataFromDB];
                        
                        DDGainBiddingDetailVC *winBiddingDetail=[[DDGainBiddingDetailVC alloc]init];
                        winBiddingDetail.winCaseId=model.transId;
                        [self.navigationController pushViewController:winBiddingDetail animated:YES];
                    }
                    //                if ([self.menuId isEqualToString:@"24"]) {//行政处罚详情页面
                    //                    DDAdminPunishDetailVC *adminPunishDetail=[[DDAdminPunishDetailVC alloc]init];
                    //                    adminPunishDetail.punish_id=model.transId;
                    //                    [self.navigationController pushViewController:adminPunishDetail animated:YES];
                    //                }
                    //                if ([self.menuId isEqualToString:@"25"]) {//事故情况详情页面
                    //                    DDAccidentSituationDetailVC *accidentSituationDetail=[[DDAccidentSituationDetailVC alloc]init];
                    //                    accidentSituationDetail.accident_id=model.transId;
                    //                    [self.navigationController pushViewController:accidentSituationDetail animated:YES];
                    //                }
                    //                if ([self.menuId isEqualToString:@"27"]) {//获奖荣誉详情页面
                    //                    DDRewardGloryDetailVC *rewardGloryDetail=[[DDRewardGloryDetailVC alloc]init];
                    //                    rewardGloryDetail.reward_id=model.transId;
                    //                    [self.navigationController pushViewController:rewardGloryDetail animated:YES];
                    //                }
                    //                if ([self.menuId isEqualToString:@"88"]) {//法院公告详情页面
                    //                    DDCourtNoticeDetailVC *courtNoticeDetail=[[DDCourtNoticeDetailVC alloc]init];
                    //                    courtNoticeDetail.notice_id=model.transId;
                    //                    [self.navigationController pushViewController:courtNoticeDetail animated:YES];
                    //                }
                    //                if ([self.menuId isEqualToString:@"89"]) {//裁判文书详情页面
                    //                    DDJudgePaperDetailVC *judgePaperDetail=[[DDJudgePaperDetailVC alloc]init];
                    //                    judgePaperDetail.judgment_id=model.transId;
                    //                    [self.navigationController pushViewController:judgePaperDetail animated:YES];
                    //                }
                    if ([self.menuId isEqualToString:@"16"]) {//找资质详情页面（同企业详情页面）
                        [DDSearchHistoryDAOAndDB insertHistorySearchByTypeId:self.menuId andSearchResult:model.title andGlobalType:nil andTransId:model.transId];
                        [self getDataFromDB];
                        
                        DDCompanyDetailVC *companyDetail=[[DDCompanyDetailVC alloc]init];
                        companyDetail.enterpriseId=model.transId;
                        [self.navigationController pushViewController:companyDetail animated:YES];
                    }
                    if ([self.menuId isEqualToString:@"17"]) {//安许证详情页面（同企业详情页面）
                        [DDSearchHistoryDAOAndDB insertHistorySearchByTypeId:self.menuId andSearchResult:model.title andGlobalType:nil andTransId:model.transId];
                        [self getDataFromDB];
                        
                        DDCompanyDetailVC *companyDetail=[[DDCompanyDetailVC alloc]init];
                        companyDetail.enterpriseId=model.transId;
                        [self.navigationController pushViewController:companyDetail animated:YES];
                    }
                    if ([self.menuId isEqualToString:@"9"]) {//买公司详情页面
                        [DDSearchHistoryDAOAndDB insertHistorySearchByTypeId:self.menuId andSearchResult:model.title andGlobalType:nil andTransId:model.transId];
                        [self getDataFromDB];
                        
                        DDBuyCompanyDetailVC *buyCompanyDetail=[[DDBuyCompanyDetailVC alloc]init];
                        buyCompanyDetail.enterpriseId=model.transId;
                        [self.navigationController pushViewController:buyCompanyDetail animated:YES];
                    }
                    if ([self.menuId isEqualToString:@"8"]) {//找电话详情页面
                        [DDSearchHistoryDAOAndDB insertHistorySearchByTypeId:self.menuId andSearchResult:model.title andGlobalType:nil andTransId:model.transId];
                        [self getDataFromDB];
                        
                        DDCompanyDetailVC *companyDetail=[[DDCompanyDetailVC alloc]init];
                        companyDetail.enterpriseId=model.transId;
                        [self.navigationController pushViewController:companyDetail animated:YES];
                    }
                }
            }

        }
        else{//热门搜索（从接口获取）（跳搜索列表）
            DDHotSearchModel *model=_dataSource[indexPath.row];

//            DDCompanyDetailVC *companyDetail=[[DDCompanyDetailVC alloc]init];
//            companyDetail.enterpriseId=model.enterpriseId;
//            [self.navigationController pushViewController:companyDetail animated:YES];
            

            
            if ([self.type isEqualToString:@"1"]) {//表示从首页公共搜索进入
                DDGlobalListVC *globalListVC=[[DDGlobalListVC alloc]init];
                globalListVC.index=_index;
                globalListVC.indexBlock = ^(NSInteger index) {
                    _index=index;
                };
                globalListVC.searchText=model.searchTitle;
                [self.navigationController pushViewController:globalListVC animated:NO];
            }
            else{
                if ([self.menuId isEqualToString:@"6"]) {//找企业列表
                    DDSearchCompanyListVC *searchCompanyListVC=[[DDSearchCompanyListVC alloc]init];
                    searchCompanyListVC.searchText=model.searchTitle;
                    searchCompanyListVC.menuId=self.menuId;
                    [self.navigationController pushViewController:searchCompanyListVC animated:NO];
                }
                if ([self.menuId isEqualToString:@"18"]) {//建造师列表
                    DDSearchBuilderAndManagerListVC *builderAndManager=[[DDSearchBuilderAndManagerListVC alloc]init];
                    builderAndManager.searchText=model.searchTitle;
                    builderAndManager.menuId=self.menuId;
                    [self.navigationController pushViewController:builderAndManager animated:NO];
                }
                if ([self.menuId isEqualToString:@"23"]) {//项目经理列表
                    DDSearchBuilderAndManagerListVC *builderAndManager=[[DDSearchBuilderAndManagerListVC alloc]init];
                    builderAndManager.searchText=model.searchTitle;
                    builderAndManager.menuId=self.menuId;
                    [self.navigationController pushViewController:builderAndManager animated:NO];
                }
                if ([self.menuId isEqualToString:@"7"]) {//找老板列表
                    DDSearchBossAndSafemanListVC *bossAndSafeman=[[DDSearchBossAndSafemanListVC alloc]init];
                    bossAndSafeman.searchText=model.searchTitle;
                    bossAndSafeman.menuId=self.menuId;
                    [self.navigationController pushViewController:bossAndSafeman animated:NO];
                }
                if ([self.menuId isEqualToString:@"19"]) {//安全员列表
                    DDSearchBossAndSafemanListVC *bossAndSafeman=[[DDSearchBossAndSafemanListVC alloc]init];
                    bossAndSafeman.searchText=model.searchTitle;
                    bossAndSafeman.menuId=self.menuId;
                    [self.navigationController pushViewController:bossAndSafeman animated:NO];
                }
                if ([self.menuId isEqualToString:@"22"]) {//查中标列表
                    DDSearchBiddingListVC *searchbidding=[[DDSearchBiddingListVC alloc]init];
                    searchbidding.searchText=model.searchTitle;
                    searchbidding.menuId=self.menuId;
                    [self.navigationController pushViewController:searchbidding animated:NO];
                }
                if ([self.menuId isEqualToString:@"24"]) {//行政处罚列表
                    DDSearchAdminPunishListVC *searchAdminPunish=[[DDSearchAdminPunishListVC alloc]init];
                    searchAdminPunish.searchText=model.searchTitle;
                    searchAdminPunish.menuId=self.menuId;
                    [self.navigationController pushViewController:searchAdminPunish animated:NO];
                }
                else if ([self.menuId isEqualToString:@"25"]) {//事故情况
                    DDSearchAccidentSituationListVC *searchAccidentSituation=[[DDSearchAccidentSituationListVC alloc]init];
                    searchAccidentSituation.searchText=model.searchTitle;
                    searchAccidentSituation.menuId=self.menuId;
                    [self.navigationController pushViewController:searchAccidentSituation animated:NO];
                }
                else if ([self.menuId isEqualToString:@"27"]) {//获奖荣誉
                    DDSearchRewardGloryListVC *searchRewardGlory=[[DDSearchRewardGloryListVC alloc]init];
                    searchRewardGlory.searchText=model.searchTitle;
                    searchRewardGlory.menuId=self.menuId;
                    [self.navigationController pushViewController:searchRewardGlory animated:NO];
                }
                else if ([self.menuId isEqualToString:@"88"]) {//法院公告
                    DDSearchCourtNoticeListVC *searchCourtNotice=[[DDSearchCourtNoticeListVC alloc]init];
                    searchCourtNotice.searchText=model.searchTitle;
                    searchCourtNotice.menuId=self.menuId;
                    [self.navigationController pushViewController:searchCourtNotice animated:NO];
                }
                else if ([self.menuId isEqualToString:@"89"]) {//裁判文书
                    DDSearchJudgePaperListVC *searchJudgePaper=[[DDSearchJudgePaperListVC alloc]init];
                    searchJudgePaper.searchText=model.searchTitle;
                    searchJudgePaper.menuId=self.menuId;
                    [self.navigationController pushViewController:searchJudgePaper animated:NO];
                }
                else if ([self.menuId isEqualToString:@"16"]) {//找资质（就是找企业）
                    DDSearchCompanyListVC *searchCompanyListVC=[[DDSearchCompanyListVC alloc]init];
                    searchCompanyListVC.searchText=model.searchTitle;
                    searchCompanyListVC.menuId=self.menuId;
                    [self.navigationController pushViewController:searchCompanyListVC animated:NO];
                }
                else if ([self.menuId isEqualToString:@"17"]) {//安许证（就是找企业）
                    DDSearchSafeCertiListVC *searchCompanyListVC=[[DDSearchSafeCertiListVC alloc]init];
                    searchCompanyListVC.searchText=model.searchTitle;
                    searchCompanyListVC.menuId=self.menuId;
                    [self.navigationController pushViewController:searchCompanyListVC animated:NO];
                }
                else if ([self.menuId isEqualToString:@"9"]) {//买公司
                    DDSearchBuyCompanyListVC *buyCompanyList=[[DDSearchBuyCompanyListVC alloc]init];
                    buyCompanyList.searchText=model.searchTitle;
                    buyCompanyList.menuId=self.menuId;
                    [self.navigationController pushViewController:buyCompanyList animated:NO];
                }
                else if ([self.menuId isEqualToString:@"8"]) {//找电话
                    DDSearchTelephoneListVC *telephoneList=[[DDSearchTelephoneListVC alloc]init];
                    telephoneList.menuId=self.menuId;
                    telephoneList.searchText=model.searchTitle;
                    [self.navigationController pushViewController:telephoneList animated:NO];
                }
                else if ([self.menuId isEqualToString:@"87"]) {//被执行人
                    DDSearchExcutedPeopleListVC *executedList=[[DDSearchExcutedPeopleListVC alloc]init];
                    executedList.menuId=self.menuId;
                    executedList.nameText=model.searchTitle;
                    [self.navigationController pushViewController:executedList animated:NO];
                }
                else if ([self.menuId isEqualToString:@"86"]) {//失信信息
                    DDSearchExcutedPeopleListVC *executedList=[[DDSearchExcutedPeopleListVC alloc]init];
                    executedList.menuId=self.menuId;
                    executedList.nameText=model.searchTitle;
                    [self.navigationController pushViewController:executedList animated:NO];
                }
                else if ([self.menuId isEqualToString:@"122"]) {//合同备案
                    DDSearchContractCopyVC *contractCopyList=[[DDSearchContractCopyVC alloc]init];
                    contractCopyList.menuId=self.menuId;
                    contractCopyList.searchText=model.searchTitle;
                    [self.navigationController pushViewController:contractCopyList animated:NO];
                }
            }

        }
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 40)];
    headerView.backgroundColor=kColorWhite;
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(14, 10, 100, 20)];
    label.textColor=KColorBlackSecondTitle;
    label.font=kFontSize26;
    [headerView addSubview:label];
    
    UIButton *cancelBtn=[[UIButton alloc]initWithFrame:CGRectMake(Screen_Width-14-20, 10, 20, 20)];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"home_search_clear"] forState:UIControlStateNormal];
    [headerView addSubview:cancelBtn];
    
    if (section==0) {
        label.text=@"最近搜索";
        if (_recentSearch.count==0) {
            cancelBtn.hidden=YES;
        }
        else{
            cancelBtn.hidden=NO;
        }
        [cancelBtn addTarget:self action:@selector(clearRecentSearch) forControlEvents:UIControlEventTouchUpInside];
    }
    else{
        if (_isFromDB==YES) {
            cancelBtn.hidden=NO;
            label.text=@"浏览历史";
            [cancelBtn addTarget:self action:@selector(clearHistorySearch) forControlEvents:UIControlEventTouchUpInside];
        }
        else{
            cancelBtn.hidden=YES;
            label.text=@"热门搜索";
        }
    }
    
    return headerView;
}

#pragma mark 清空最近搜索数据
-(void)clearRecentSearch{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"删除历史" message:@"确定要删除最近搜索？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:KMainOk style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([self.type isEqualToString:@"1"]) {//表示从首页公共搜索进入
            [DDSearchHistoryDAOAndDB deleteRecentSearchByTypeId:@"9909"];
            [self getDataFromDB];
        }
        else{
            [DDSearchHistoryDAOAndDB deleteRecentSearchByTypeId:self.menuId];
            [self getDataFromDB];
        }
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:KMainCancel style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:sure];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark 清空浏览历史数据
-(void)clearHistorySearch{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"删除历史" message:@"确定要删除最浏览历史？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:KMainOk style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([self.type isEqualToString:@"1"]) {//表示从首页公共搜索进入
            [DDSearchHistoryDAOAndDB deleteHistorySearchByTypeId:@"9909"];
            [self getDataFromDB];
        }
        else{
            [DDSearchHistoryDAOAndDB deleteHistorySearchByTypeId:self.menuId];
            [self getDataFromDB];
        }
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:KMainCancel style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:sure];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        if (_recentSearch.count==0) {
            return CGFLOAT_MIN;
        }
        else{
            NSMutableArray  *strArray=[[NSMutableArray alloc]init];
            for (DDSearchRecordModel *model in _recentSearch) {
                [strArray addObject:model.title];
            }
            return [DDAllSearchRecentCell heightWithBtns:strArray];
        }
    }
    else{
        return 55;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView  *footView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 15)];
    footView.backgroundColor=kColorBackGroundColor;
    return footView;
    //return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        if (_recentSearch.count==0) {
            return CGFLOAT_MIN;
        }
        else{
            return 40;
        }
    }
    else{
        return 40;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0) {
        return 15;
    }
    else if(section==1){
        return CGFLOAT_MIN;
    }
    return CGFLOAT_MIN;
}

#pragma mark 最近搜索点击回调，跳转到搜索列表页面
-(void)allSearchRecentCellSelectButton:(DDAllSearchRecentCell *)allSearchRecentCell buttonIndex:(NSInteger)index{
    DDSearchRecordModel *model=_recentSearch[index];
    
    if ([self.type isEqualToString:@"1"]) {//表示从首页公共搜索进入
        DDGlobalListVC *globalListVC=[[DDGlobalListVC alloc]init];
        globalListVC.index=_index;
        globalListVC.indexBlock = ^(NSInteger index) {
            _index=index;
        };
        globalListVC.searchText=model.title;
        [self.navigationController pushViewController:globalListVC animated:NO];
    }
    else{
        if ([self.menuId isEqualToString:@"6"]) {//找企业列表
            DDSearchCompanyListVC *searchCompanyListVC=[[DDSearchCompanyListVC alloc]init];
            searchCompanyListVC.searchText=model.title;
            searchCompanyListVC.menuId=self.menuId;
            [self.navigationController pushViewController:searchCompanyListVC animated:NO];
        }
        if ([self.menuId isEqualToString:@"18"]) {//建造师列表
            DDSearchBuilderAndManagerListVC *builderAndManager=[[DDSearchBuilderAndManagerListVC alloc]init];
            builderAndManager.searchText=model.title;
            builderAndManager.menuId=self.menuId;
            [self.navigationController pushViewController:builderAndManager animated:NO];
        }
        if ([self.menuId isEqualToString:@"23"]) {//项目经理列表
            DDSearchBuilderAndManagerListVC *builderAndManager=[[DDSearchBuilderAndManagerListVC alloc]init];
            builderAndManager.searchText=model.title;
            builderAndManager.menuId=self.menuId;
            [self.navigationController pushViewController:builderAndManager animated:NO];
        }
        if ([self.menuId isEqualToString:@"7"]) {//找老板列表
            DDSearchBossAndSafemanListVC *bossAndSafeman=[[DDSearchBossAndSafemanListVC alloc]init];
            bossAndSafeman.searchText=model.title;
            bossAndSafeman.menuId=self.menuId;
            [self.navigationController pushViewController:bossAndSafeman animated:NO];
        }
        if ([self.menuId isEqualToString:@"19"]) {//安全员列表
            DDSearchBossAndSafemanListVC *bossAndSafeman=[[DDSearchBossAndSafemanListVC alloc]init];
            bossAndSafeman.searchText=model.title;
            bossAndSafeman.menuId=self.menuId;
            [self.navigationController pushViewController:bossAndSafeman animated:NO];
        }
        if ([self.menuId isEqualToString:@"22"]) {//查中标列表
            DDSearchBiddingListVC *searchbidding=[[DDSearchBiddingListVC alloc]init];
            searchbidding.searchText=model.title;
            searchbidding.menuId=self.menuId;
            [self.navigationController pushViewController:searchbidding animated:NO];
        }
        if ([self.menuId isEqualToString:@"24"]) {//行政处罚列表
            DDSearchAdminPunishListVC *searchAdminPunish=[[DDSearchAdminPunishListVC alloc]init];
            searchAdminPunish.searchText=model.title;
            searchAdminPunish.menuId=self.menuId;
            [self.navigationController pushViewController:searchAdminPunish animated:NO];
        }
        else if ([self.menuId isEqualToString:@"25"]) {//事故情况
            DDSearchAccidentSituationListVC *searchAccidentSituation=[[DDSearchAccidentSituationListVC alloc]init];
            searchAccidentSituation.searchText=model.title;
            searchAccidentSituation.menuId=self.menuId;
            [self.navigationController pushViewController:searchAccidentSituation animated:NO];
        }
        else if ([self.menuId isEqualToString:@"27"]) {//获奖荣誉
            DDSearchRewardGloryListVC *searchRewardGlory=[[DDSearchRewardGloryListVC alloc]init];
            searchRewardGlory.searchText=model.title;
            searchRewardGlory.menuId=self.menuId;
            [self.navigationController pushViewController:searchRewardGlory animated:NO];
        }
        else if ([self.menuId isEqualToString:@"88"]) {//法院公告
            DDSearchCourtNoticeListVC *searchCourtNotice=[[DDSearchCourtNoticeListVC alloc]init];
            searchCourtNotice.searchText=model.title;
            searchCourtNotice.menuId=self.menuId;
            [self.navigationController pushViewController:searchCourtNotice animated:NO];
        }
        else if ([self.menuId isEqualToString:@"89"]) {//裁判文书
            DDSearchJudgePaperListVC *searchJudgePaper=[[DDSearchJudgePaperListVC alloc]init];
            searchJudgePaper.searchText=model.title;
            searchJudgePaper.menuId=self.menuId;
            [self.navigationController pushViewController:searchJudgePaper animated:NO];
        }
        else if ([self.menuId isEqualToString:@"16"]) {//找资质（就是找企业）
            DDSearchCompanyListVC *searchCompanyListVC=[[DDSearchCompanyListVC alloc]init];
            searchCompanyListVC.searchText=model.title;
            searchCompanyListVC.menuId=self.menuId;
            [self.navigationController pushViewController:searchCompanyListVC animated:NO];
        }
        else if ([self.menuId isEqualToString:@"17"]) {//安许证（就是找企业）
            DDSearchSafeCertiListVC *searchCompanyListVC=[[DDSearchSafeCertiListVC alloc]init];
            searchCompanyListVC.searchText=model.title;
            searchCompanyListVC.menuId=self.menuId;
            [self.navigationController pushViewController:searchCompanyListVC animated:NO];
        }
        else if ([self.menuId isEqualToString:@"9"]) {//买公司
            DDSearchBuyCompanyListVC *buyCompanyList=[[DDSearchBuyCompanyListVC alloc]init];
            buyCompanyList.searchText=model.title;
            buyCompanyList.menuId=self.menuId;
            [self.navigationController pushViewController:buyCompanyList animated:NO];
        }
        else if ([self.menuId isEqualToString:@"8"]) {//找电话
            DDSearchTelephoneListVC *telephoneList=[[DDSearchTelephoneListVC alloc]init];
            telephoneList.menuId=self.menuId;
            telephoneList.searchText=model.title;
            [self.navigationController pushViewController:telephoneList animated:NO];
        }
        else if ([self.menuId isEqualToString:@"87"]) {//被执行人
            DDSearchExcutedPeopleListVC *executedList=[[DDSearchExcutedPeopleListVC alloc]init];
            executedList.menuId=self.menuId;
            executedList.nameText=model.title;
            [self.navigationController pushViewController:executedList animated:NO];
        }
        else if ([self.menuId isEqualToString:@"86"]) {//失信信息
            DDSearchExcutedPeopleListVC *executedList=[[DDSearchExcutedPeopleListVC alloc]init];
            executedList.menuId=self.menuId;
            executedList.nameText=model.title;
            [self.navigationController pushViewController:executedList animated:NO];
        }
        else if ([self.menuId isEqualToString:@"122"]) {//合同备案
            DDSearchContractCopyVC *contractCopyList=[[DDSearchContractCopyVC alloc]init];
            contractCopyList.menuId=self.menuId;
            contractCopyList.searchText=model.title;
            [self.navigationController pushViewController:contractCopyList animated:NO];
        }
    }
}

#pragma mark 弹出登录注册页面
- (void)presentLoginVCWithIndexPath:(NSIndexPath *)indexPath{
    DDLoginVC * vc = [[DDLoginVC alloc] init];
    vc.loginSuccessBlock = ^{
        //__weak __typeof(self) weakSelf=self;
        //[weakSelf requestTypesData];
        
        //发出登录成功通知
        [[NSNotificationCenter defaultCenter] postNotificationName:KLoginSuccessNotification object:nil userInfo:nil];
        
        DDSearchRecordModel *model=_dataSource[indexPath.row];
        
        if ([self.type isEqualToString:@"1"]) {//全局搜索的三种情况
            if ([model.globalType isEqualToString:@"0"]) {//公司详情
                [DDSearchHistoryDAOAndDB insertHistorySearchByTypeId:@"9909" andSearchResult:model.title andGlobalType:@"0" andTransId:model.transId];
                [self getDataFromDB];
                
                DDCompanyDetailVC *companyDetail=[[DDCompanyDetailVC alloc]init];
                companyDetail.enterpriseId=model.transId;
                [self.navigationController pushViewController:companyDetail animated:YES];
            }
            else if([model.globalType isEqualToString:@"1"]){//人员详情
                [DDSearchHistoryDAOAndDB insertHistorySearchByTypeId:@"9909" andSearchResult:model.title andGlobalType:@"1" andTransId:model.transId];
                [self getDataFromDB];
                
                DDPeopleDetailVC *peopleDetail=[[DDPeopleDetailVC alloc]init];
                peopleDetail.staffInfoId=model.transId;
                [self.navigationController pushViewController:peopleDetail animated:YES];
            }
            else if([model.globalType isEqualToString:@"2"]){//项目详情
                [DDSearchHistoryDAOAndDB insertHistorySearchByTypeId:@"9909" andSearchResult:model.title andGlobalType:@"2" andTransId:model.transId];
                [self getDataFromDB];
                
                DDProjectDetailVC *projectDetail=[[DDProjectDetailVC alloc]init];
                projectDetail.winCaseId=model.transId;
                [self.navigationController pushViewController:projectDetail animated:YES];
            }
        }
        else {//分类搜索的情况
            if ([self.menuId isEqualToString:@"6"]) {//公司详情页面
                [DDSearchHistoryDAOAndDB insertHistorySearchByTypeId:self.menuId andSearchResult:model.title andGlobalType:nil andTransId:model.transId];
                [self getDataFromDB];
                
                DDCompanyDetailVC *companyDetail=[[DDCompanyDetailVC alloc]init];
                companyDetail.enterpriseId=model.transId;
                [self.navigationController pushViewController:companyDetail animated:YES];
            }
            if ([self.menuId isEqualToString:@"18"]) {//建造师详情页面
                [DDSearchHistoryDAOAndDB insertHistorySearchByTypeId:self.menuId andSearchResult:model.title andGlobalType:nil andTransId:model.transId];
                [self getDataFromDB];
                
                DDPeopleDetailVC *peopleDetail=[[DDPeopleDetailVC alloc]init];
                peopleDetail.staffInfoId=model.transId;
                [self.navigationController pushViewController:peopleDetail animated:YES];
            }
            if ([self.menuId isEqualToString:@"23"]) {//项目经理详情页面
                [DDSearchHistoryDAOAndDB insertHistorySearchByTypeId:self.menuId andSearchResult:model.title andGlobalType:nil andTransId:model.transId];
                [self getDataFromDB];
                
                DDPeopleDetailVC *peopleDetail=[[DDPeopleDetailVC alloc]init];
                peopleDetail.staffInfoId=model.transId;
                [self.navigationController pushViewController:peopleDetail animated:YES];
            }
            if ([self.menuId isEqualToString:@"7"]) {//找老板详情页面
                [DDSearchHistoryDAOAndDB insertHistorySearchByTypeId:self.menuId andSearchResult:model.title andGlobalType:nil andTransId:model.transId];
                [self getDataFromDB];
                
                DDPeopleDetailVC *peopleDetail=[[DDPeopleDetailVC alloc]init];
                peopleDetail.staffInfoId=model.transId;
                [self.navigationController pushViewController:peopleDetail animated:YES];
            }
            if ([self.menuId isEqualToString:@"19"]) {//安全员详情页面
                [DDSearchHistoryDAOAndDB insertHistorySearchByTypeId:self.menuId andSearchResult:model.title andGlobalType:nil andTransId:model.transId];
                [self getDataFromDB];
                
                DDPeopleDetailVC *peopleDetail=[[DDPeopleDetailVC alloc]init];
                peopleDetail.staffInfoId=model.transId;
                [self.navigationController pushViewController:peopleDetail animated:YES];
            }
            if ([self.menuId isEqualToString:@"22"]) {//查中标详情页面（同项目详情页面）
                [DDSearchHistoryDAOAndDB insertHistorySearchByTypeId:self.menuId andSearchResult:model.title andGlobalType:nil andTransId:model.transId];
                [self getDataFromDB];
                
                DDGainBiddingDetailVC *winBiddingDetail=[[DDGainBiddingDetailVC alloc]init];
                winBiddingDetail.winCaseId=model.transId;
                [self.navigationController pushViewController:winBiddingDetail animated:YES];
            }
            //                if ([self.menuId isEqualToString:@"24"]) {//行政处罚详情页面
            //                    DDAdminPunishDetailVC *adminPunishDetail=[[DDAdminPunishDetailVC alloc]init];
            //                    adminPunishDetail.punish_id=model.transId;
            //                    [self.navigationController pushViewController:adminPunishDetail animated:YES];
            //                }
            //                if ([self.menuId isEqualToString:@"25"]) {//事故情况详情页面
            //                    DDAccidentSituationDetailVC *accidentSituationDetail=[[DDAccidentSituationDetailVC alloc]init];
            //                    accidentSituationDetail.accident_id=model.transId;
            //                    [self.navigationController pushViewController:accidentSituationDetail animated:YES];
            //                }
            //                if ([self.menuId isEqualToString:@"27"]) {//获奖荣誉详情页面
            //                    DDRewardGloryDetailVC *rewardGloryDetail=[[DDRewardGloryDetailVC alloc]init];
            //                    rewardGloryDetail.reward_id=model.transId;
            //                    [self.navigationController pushViewController:rewardGloryDetail animated:YES];
            //                }
            //                if ([self.menuId isEqualToString:@"88"]) {//法院公告详情页面
            //                    DDCourtNoticeDetailVC *courtNoticeDetail=[[DDCourtNoticeDetailVC alloc]init];
            //                    courtNoticeDetail.notice_id=model.transId;
            //                    [self.navigationController pushViewController:courtNoticeDetail animated:YES];
            //                }
            //                if ([self.menuId isEqualToString:@"89"]) {//裁判文书详情页面
            //                    DDJudgePaperDetailVC *judgePaperDetail=[[DDJudgePaperDetailVC alloc]init];
            //                    judgePaperDetail.judgment_id=model.transId;
            //                    [self.navigationController pushViewController:judgePaperDetail animated:YES];
            //                }
            if ([self.menuId isEqualToString:@"16"]) {//找资质详情页面（同企业详情页面）
                [DDSearchHistoryDAOAndDB insertHistorySearchByTypeId:self.menuId andSearchResult:model.title andGlobalType:nil andTransId:model.transId];
                [self getDataFromDB];
                
                DDCompanyDetailVC *companyDetail=[[DDCompanyDetailVC alloc]init];
                companyDetail.enterpriseId=model.transId;
                [self.navigationController pushViewController:companyDetail animated:YES];
            }
            if ([self.menuId isEqualToString:@"17"]) {//安许证详情页面（同企业详情页面）
                [DDSearchHistoryDAOAndDB insertHistorySearchByTypeId:self.menuId andSearchResult:model.title andGlobalType:nil andTransId:model.transId];
                [self getDataFromDB];
                
                DDCompanyDetailVC *companyDetail=[[DDCompanyDetailVC alloc]init];
                companyDetail.enterpriseId=model.transId;
                [self.navigationController pushViewController:companyDetail animated:YES];
            }
            if ([self.menuId isEqualToString:@"9"]) {//买公司详情页面
                [DDSearchHistoryDAOAndDB insertHistorySearchByTypeId:self.menuId andSearchResult:model.title andGlobalType:nil andTransId:model.transId];
                [self getDataFromDB];
                
                DDBuyCompanyDetailVC *buyCompanyDetail=[[DDBuyCompanyDetailVC alloc]init];
                buyCompanyDetail.enterpriseId=model.transId;
                [self.navigationController pushViewController:buyCompanyDetail animated:YES];
            }
            if ([self.menuId isEqualToString:@"8"]) {//找电话详情页面
                [DDSearchHistoryDAOAndDB insertHistorySearchByTypeId:self.menuId andSearchResult:model.title andGlobalType:nil andTransId:model.transId];
                [self getDataFromDB];
                
                DDCompanyDetailVC *companyDetail=[[DDCompanyDetailVC alloc]init];
                companyDetail.enterpriseId=model.transId;
                [self.navigationController pushViewController:companyDetail animated:YES];
            }
        }
    };
    
    
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [DDNavigationUtil setNavigationBottomLineNomalColor:nav];
    
    [self presentViewController:nav animated:YES completion:nil];
}




@end
