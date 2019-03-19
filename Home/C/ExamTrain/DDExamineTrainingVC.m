//
//  DDExamineTrainingVC.m
//  GongChengDD
//
//  Created by xzx on 2018/6/27.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDExamineTrainingVC.h"
#import "MJRefresh.h"
#import "DDNavigationUtil.h"
#import "DDLabelUtil.h"
#import "SDCycleScrollView.h"//轮播图
#import "DDIndustryDynamicListModel.h"//行业动态model
#import "DDIndustryNews1Cell.h"//第一种tableView的cell
#import "DDIndustryNews2Cell.h"//第二种tableView的cell
#import "DDIndustryNews3Cell.h"//第三种tableView的cell
#import "DDIndustryNews4Cell.h"//第四种tableView的cell
#import "DDBuilderMoreTrainVC.h"//二级建造师继续教育页面
#import "DDSafeManMoreTrainVC.h"//安全员继续教育页面

#import "DDLiveManagerNewAgencySelectVC.h"//现场施工管理新培机构选择页面
#import "DDLiveManagerMoreAgencySelectVC.h"//现场施工管理继续教育机构选择页面
//#import "DDExaminationNoticeDetailVC.h"//考试通知页面
#import "DDLoginCheckVC.h"//登录页面
#import "DDAffirmEnterpriseVC.h"//认证企业页面
#import "DDCompanyClaimBenefitVC.h"

#import "DDIndustryDynamicDetailVC.h"//行业动态详情页面
#import "DDBannerPicturesModel.h"//首页Banner图model
#import "DDProjectCheckOriginWebVC.h"//借用webView页面，展示Banner图点击跳转的网页
#import "UIImageView+CircleStyle.h"
#import "DDUMengEventDefines.h"
#import "DDExaminationDynamicListVC.h"//考试动态列表页面

#import "DDServiceWebViewVC.h"

#import "DDExamIndexCell.h"
#import "DDExamNotifyCell.h"
#import "DDLiveManagerNewAddApplyVC.h"
#import "DDAgencySelectViewController.h" // 机构选择按钮
#import "DDMyEnterpriseVC.h"
@interface DDExamineTrainingVC ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,DDExamIndexCellDelegate,DDExamNotifyCellDelegate>
{
    NSInteger currentPage;
    NSInteger pageCount;
    NSMutableArray *_dataSourceArr;
    NSMutableDictionary *_dict;
    
    NSString *_region;
    
    NSMutableArray *_bannerPicturesArr;//存放请求到的banner图数据
    NSArray *_goonArr;
    NSArray *_examinArr;
    NSArray *_notifyArr;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIView *bigHeaderView;
@property (nonatomic,strong) SDCycleScrollView *topBannerView;
@end

@implementation DDExamineTrainingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [MobClick event:main_kaoshipeixun];
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status){
        //定位不能用
        _region=@"江苏省";
    }
    else{
        //定位功能可用
        DDUserManager * userManger = [DDUserManager sharedInstance];
        if (NO == [DDUtils isEmptyString:userManger.province]) {
            _region=userManger.province;
        }else{
            _region=@"江苏省";
        }
    }
    _bannerPicturesArr=[[NSMutableArray alloc]init];
    _dataSourceArr=[[NSMutableArray alloc]init];
    self.view.backgroundColor=kColorBackGroundColor;
    self.title=@"考试培训";
    self.navigationItem.leftBarButtonItem=[DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
//    self.navigationItem.rightBarButtonItem=[DDUtils rightbuttonItemWithTitle:@"机构入驻" target:self action:@selector(rigtBtnClick)];
    _goonArr = @[@{@"image":@"home_erjian",@"name":@"二级建造师",@"type":@"继续教育",},@{@"image":@"home_threeNew",@"name":@"三类人员",@"type":@"新培"},@{@"image":@"home_threeMore",@"name":@"三类人员",@"type":@"继续教育"}];
//    _examinArr = @[@{@"image":@"home_threeMore",@"name":@"三类人员",@"type":@"新培"},
//                   @{@"image":@"home_yijian",@"name":@"一级建造师",@"type":@"新培"},
//                   @{@"image":@"home_erjian",@"name":@"二级建造师",@"type":@"新培"},
//                   @{@"image":@"home_xiaofang",@"name":@"一级消防工程师",@"type":@"新培"},
//                   @{@"image":@"home_xiaofanger",@"name":@"二级消防工程师",@"type":@"新培"},
//                   @{@"image":@"home_jianli",@"name":@"监理工程师",@"type":@"新培"},
//                   @{@"image":@"home_zaojiayi",@"name":@"一级造价工程师",@"type":@"新培"},
//                   @{@"image":@"home_zaojiaer",@"name":@"二级造价工程师",@"type":@"新培"},
//                   @{@"image":@"home_anquan",@"name":@"安全工程师",@"type":@"新培"},
//                   @{@"image":@"home_bim",@"name":@"BIM考试",@"type":@"新培"},
//                   ];
    _notifyArr = @[@{@"image":@"home_erjian",@"name":@"一级建造师"},@{@"image":@"home_erjian",@"name":@"二级建造师"},@{@"image":@"home_threeMore",@"name":@"三类人员"}];
    [self createTableView];
    [self requestBannerData];
    [self requestDynamicData];
    //监听当前企业获取信息成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserMainCompanyInfoSuccess) name:KGetUserMainCompanyInfoSuccess object:nil];
    //公司认证通过
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveCompanyPassMessageAction) name:KReceiveCompanyPassNews object:nil];
}
#pragma mark 公司认证通过
- (void)receiveCompanyPassMessageAction{
    [[DDUserManager sharedInstance] getUserMainCompany];
}
#pragma mark 获取用户默认企业成功
- (void)getUserMainCompanyInfoSuccess{
    [_tableView reloadData];
}

//-(void)rigtBtnClick{
//    DDServiceWebViewVC *checkVC = [DDServiceWebViewVC new];
//    checkVC.hostUrl = @"";
//    [self.navigationController pushViewController:checkVC animated:YES];
//}
//返回上一页
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 请求banner图接口
-(void)requestBannerData{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [params setValue:@"2" forKey:@"moduleType"];
    
    [[DDHttpManager sharedInstance]sendPostRequest:KHttpRequest_bannerPictures params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"**********Banner图数据***************%@",responseObject);
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {//请求成功
            [_bannerPicturesArr removeAllObjects];
            NSArray *listArr= responseObject[KData];
            if (listArr.count>0) {
                NSMutableArray *imgArr = [[NSMutableArray alloc]init];
                for (int i=0; i<listArr.count; i++) {
                    NSDictionary *dict = listArr[i];
                    DDBannerPicturesModel *model=[[DDBannerPicturesModel alloc]initWithDictionary:dict error:nil];
                    [_bannerPicturesArr addObject:model];
                    NSString *urlStr = [NSString stringWithFormat:@"https://gcdd.koncendy.com/f/f/image/%@",dict[@"imgFileId"]];
                    [imgArr addObject:urlStr];
                }
                self.topBannerView.imageURLStringsGroup = imgArr;
            }
        }
        else{//显示异常
            [DDUtils showToastWithMessage:response.message];
        }
        
    } failure:^(NSURLSessionDataTask *operation, id responseObject) {
        [DDUtils showToastWithMessage:kRequestFailed];
    }];
}

#pragma mark 请求行业动态数据
-(void)requestDynamicData{
    currentPage = 1;
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [params setValue:_region forKey:@"region"];
    [params setValue:@"2" forKey:@"docType"];
    [params setValue:[NSString stringWithFormat:@"%ld",currentPage] forKey:@"current"];
    [params setValue:@"10" forKey:@"size"];
    
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_industryDynamic params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"**********考试通知数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        __weak __typeof(self) weakSelf = self;
        if (response.isSuccess) {
            [_dataSourceArr removeAllObjects];
            _dict = responseObject[KData];
            pageCount = [_dict[@"totalCount"] integerValue];
            NSArray *listArr=_dict[@"list"];
            
            
            if (listArr.count!=0) {//数量不等于0，后面有用
                for (NSDictionary *dic in listArr) {
                    DDIndustryDynamicListModel *model = [[DDIndustryDynamicListModel alloc]initWithDictionary:dic error:nil];
                    [_dataSourceArr addObject:model];
                }
                
                if (listArr.count<pageCount) {
                    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                        [weakSelf addData];
                    }];
                }else{
                   [_tableView.mj_footer removeFromSuperview];
                }
            }
            else{
                
                
            }
            
        }
        else{
            [DDUtils showToastWithMessage:response.message];
        }
        
        [_tableView.mj_header endRefreshing];
        [_tableView reloadData];
        
    }  failure:^(NSURLSessionDataTask *operation, id responseObject)  {
        [_tableView.mj_header endRefreshing];
        [DDUtils showToastWithMessage:kRequestFailed];
    }];
}

- (void)addData{
    currentPage++;
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [params setValue:_region forKey:@"region"];
    [params setValue:@"2" forKey:@"docType"];
    [params setValue:[NSString stringWithFormat:@"%ld",currentPage] forKey:@"current"];
    [params setValue:@"10" forKey:@"size"];
    
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_industryDynamic params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"**********考试通知数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        __weak __typeof(self) weakSelf = self;
        if (response.isSuccess) {
            
            _dict = responseObject[KData];
            NSArray *listArr = _dict[@"list"];
            for (NSDictionary *dic in listArr) {
                DDIndustryDynamicListModel *model = [[DDIndustryDynamicListModel alloc]initWithDictionary:dic error:nil];
                [_dataSourceArr addObject:model];
            }
            
            if (_dataSourceArr.count<pageCount) {
                _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                    [weakSelf addData];
                }];
            }
            else{
              [_tableView.mj_footer removeFromSuperview];
            }
        }
        else{
            [DDUtils showToastWithMessage:response.message];
        }
        
        //[_tableView.mj_footer endRefreshing];
        [_tableView reloadData];
        
    }  failure:^(NSURLSessionDataTask *operation, id responseObject)  {
        [_tableView.mj_footer endRefreshing];
        [DDUtils showToastWithMessage:kRequestFailed];
    }];
}

#pragma mark -- DDExamIndexCellDelegate
-(void)hasClickedWithSection:(NSInteger)secIndex andRow:(NSInteger)rowIndex{
    if ([DDUtils isEmptyString:[DDUserManager sharedInstance].userid]) {//未登录
        [self presentLoginVC];//先登录
    }
    else{//已登录
        DDCurrentCompanyModel * currentCompanyModel = [DDUserManager sharedInstance].currentCompanyModel;
        DDScAttestationEntityModel *  scAttestationEntityModel = currentCompanyModel.scAttestationEntity;
        
        __weak __typeof(self) weakSelf=self;
        if ([DDUtils isEmptyString:scAttestationEntityModel.entId]) {//没有认证的公司（没有主企业）
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"还没有认领成功的企业" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"去认领" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf verifyClick];
            }];
            [alertController addAction:cancelAction];
            [alertController addAction:sureAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        else{//有认证的公司(有主企业)
            //认证状态
            if ([scAttestationEntityModel.attestationStatus isEqualToString:@"1"]) {
                [self jumpToMoreTrainWithSecIndex:secIndex andRowIndex:rowIndex];
                /*
                 if (sender.tag==51) {//二建继续教育
                 DDBuilderMoreTrainVC *builderMoreTrain=[[DDBuilderMoreTrainVC alloc]init];
                 [self.navigationController pushViewController:builderMoreTrain animated:YES];
                 }
                 else if(sender.tag==52){//三类人员新培
                 DDSafeManNewAgencySelectVC *agencySelect=[[DDSafeManNewAgencySelectVC alloc]init];
                 [self.navigationController pushViewController:agencySelect animated:YES];
                 }
                 else if(sender.tag==53){//三类人员继续教育
                 DDSafeManMoreTrainVC *safeManMoreTrain=[[DDSafeManMoreTrainVC alloc]init];
                 [self.navigationController pushViewController:safeManMoreTrain animated:YES];
                 }
                 else if(sender.tag==54){//现场施工管理新培
                 DDLiveManagerNewAgencySelectVC *agencySelect=[[DDLiveManagerNewAgencySelectVC alloc]init];
                 [self.navigationController pushViewController:agencySelect animated:YES];
                 }
                 else if(sender.tag==55){//现场施工管理继续教育
                 DDLiveManagerMoreAgencySelectVC *agencySelect=[[DDLiveManagerMoreAgencySelectVC alloc]init];
                 [self.navigationController pushViewController:agencySelect animated:YES];
                 }
                 */
            }
            else{
                UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"还没有认领成功的企业" message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"去认领" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [weakSelf verifyClick];
                }];
                [alertController addAction:cancelAction];
                [alertController addAction:sureAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }
        }
    }
    
    
}
#pragma mark -- DDExamNotifyCellDelegate
-(void)hasClickedWithIndex:(NSInteger)rowIndex{
    [self jumpToExamNoticeWithIndex:rowIndex];
}

#pragma mark --- 考试通知
-(void)jumpToExamNoticeWithIndex:(NSInteger)index{
    DDExaminationDynamicListVC *examinationNotice=[[DDExaminationDynamicListVC alloc]init];
    if (index==0) {
        examinationNotice.titleName=@"一级建造师";
        examinationNotice.certType=@"110000";
    }
    if (index==1) {
        examinationNotice.titleName=@"二级建造师";
        examinationNotice.certType=@"120000";
    }
    if (index==2) {
        examinationNotice.titleName=@"安全员";
        examinationNotice.certType=@"170000";
    }
    [self.navigationController pushViewController:examinationNotice animated:YES];
}

#pragma mark 弹出登录注册页面
- (void)presentLoginVC{
    DDLoginCheckVC * vc = [[DDLoginCheckVC alloc] init];
    vc.loginSuccessBlock = ^{
        [_bigHeaderView removeFromSuperview];
        [_tableView reloadData];
    };
    
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [DDNavigationUtil setNavigationAndBottomLineWhiteColor:nav];
    [self showViewController:nav sender:nil];
}

#pragma mark -- 继续教育和资格考试培训跳转
-(void)jumpToMoreTrainWithSecIndex:(NSInteger)secIndex andRowIndex:(NSInteger)rowIndex{
    if (secIndex == 0) {
        //继续教育
        if (rowIndex == 0) {
            //二建继续教育
            DDCurrentCompanyModel *currentCompanyModel = [DDUserManager sharedInstance].currentCompanyModel;
            DDScAttestationEntityModel *  scAttestationEntityModel = currentCompanyModel.scAttestationEntity;
            
            DDBuilderMoreTrainVC *builderMoreTrain=[[DDBuilderMoreTrainVC alloc]init];
            builderMoreTrain.companyID = scAttestationEntityModel.entId;
            [self.navigationController pushViewController:builderMoreTrain animated:YES];
        }
        if (rowIndex == 1) {
            //三类人员新培
            DDAgencySelectViewController *agencySelectVC = [[DDAgencySelectViewController alloc] init];
            agencySelectVC.trainType = DDTrainTypeSafetyOfficerNew;
            agencySelectVC.isFromeAddApply = @"1";
            [self.navigationController pushViewController:agencySelectVC animated:YES];
        }
        if (rowIndex == 2) {
            //三类人员继续教育
            DDCurrentCompanyModel *currentCompanyModel = [DDUserManager sharedInstance].currentCompanyModel;
            DDScAttestationEntityModel *  scAttestationEntityModel = currentCompanyModel.scAttestationEntity;
            DDSafeManMoreTrainVC *safeManMoreTrain=[[DDSafeManMoreTrainVC alloc]init];
            safeManMoreTrain.companyID = scAttestationEntityModel.entId;
            [self.navigationController pushViewController:safeManMoreTrain animated:YES];
        }
    }
    if (secIndex == 1) {
        //资格考试培训
        
        DDAgencySelectViewController *agencySelectVC = [[DDAgencySelectViewController alloc] init];
        if (rowIndex == 0) {
            // 三类人员新培
            //            DDSafeManNewAgencySelectVC *agencySelect=[[DDSafeManNewAgencySelectVC alloc]init];
            //            [self.navigationController pushViewController:agencySelect animated:YES];
        }
        [self.navigationController pushViewController:agencySelectVC animated:YES];
    }
}

#pragma mark 去认证公司
-(void)verifyClick{
    DDCurrentCompanyModel * currentCompanyModel = [DDUserManager sharedInstance].currentCompanyModel;
    DDScAttestationEntityModel *  scAttestationEntityModel = currentCompanyModel.scAttestationEntity;
    if ([DDUtils isEmptyString:scAttestationEntityModel.entId]) {
        DDCompanyClaimBenefitVC *vc=[[DDCompanyClaimBenefitVC alloc]init];
        vc.hidesBottomBarWhenPushed=YES;
        vc.isFromMyInfo = NO;
        vc.companyClaimBenefitType = CompanyClaimBenefitTypeDefault;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
//        DDAffirmEnterpriseVC * vc = [[DDAffirmEnterpriseVC alloc] init];
//        vc.formMyInfoVC = NO;//从其他页面进入的
//        vc.allowChangeCompanyName = YES;//允许修改公司名
//        vc.affirmEnterpriseSuccessBlock = ^{
//            //认证成功后
//            [_bigHeaderView removeFromSuperview];
//            [self createHeaderView];
//            [_tableView reloadData];
//        };
//        [self.navigationController pushViewController:vc animated:YES];
        //如果已经认证了,去公司列表页
        DDMyEnterpriseVC * vc = [[DDMyEnterpriseVC alloc] init];
        vc.isFromMyInfo = YES;
        vc.myEnterpriseType = MyEnterpriseTypeDefault;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
}

#pragma mark 创建tableView
-(void)createTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-KNavigationBarHeight) style:UITableViewStyleGrouped];
    _tableView.backgroundColor=[UIColor clearColor];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.showsVerticalScrollIndicator=YES;
    _tableView.separatorColor=KColorTableSeparator;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, KTableViewFooterViewHeight)];
    [self.view addSubview:_tableView];
    [_tableView registerClass:[DDExamIndexCell class] forCellReuseIdentifier:@"DDExamIndexCell"];
    [_tableView registerClass:[DDExamNotifyCell class] forCellReuseIdentifier:@"DDExamNotifyCell"];
    
    __weak __typeof(self) weakSelf=self;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestDynamicData];
    }];
}

#pragma mark tableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 2) {
        return _dataSourceArr.count;
    }
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        DDExamIndexCell  *cell =[tableView  dequeueReusableCellWithIdentifier:@"DDExamIndexCell" forIndexPath:indexPath];
        cell.delegate = self;
        cell.sectionIndex = indexPath.section;
        cell.indexArr = _goonArr;
        cell.titleL.text = @"培训报名";
        return cell;
    }
//    if (indexPath.section == 1) {
//        DDExamIndexCell  *cell =[tableView  dequeueReusableCellWithIdentifier:@"DDExamIndexCell" forIndexPath:indexPath];
//        cell.indexArr = _examinArr;
//        cell.delegate = self;
//        cell.sectionIndex = indexPath.section;
//        cell.titleL.text = @"资格考试培训";
//        return cell;
//    }
    if (indexPath.section == 1) {
        DDExamNotifyCell  *cell =[tableView  dequeueReusableCellWithIdentifier:@"DDExamNotifyCell" forIndexPath:indexPath];
        cell.delegate = self;
        cell.indexArr = _notifyArr;
        cell.titleL.text = @"考试通知";
        return cell;
    }
    DDIndustryDynamicListModel *model=_dataSourceArr[indexPath.row];
    
//    if ([model.title_type isEqualToString:@"1"]) {//链接
//        static NSString * cellID = @"DDIndustryNews2Cell";
//        DDIndustryNews2Cell * cell = (DDIndustryNews2Cell *)[tableView dequeueReusableCellWithIdentifier:cellID];
//        if (cell == nil) {
//            cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
//        }
//
//        cell.titleLab.text=model.title;
//        cell.linkLab.text=model.share_title;
//        [cell.linkImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",DD_Http_Image_Server,model.attr_img]] placeholderImage:[UIImage imageNamed:@"home_type_loading"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            if (image) {
//                cell.linkImg.image = image;
//            }
//        }];
//        cell.attachLab1.text=model.dept_source;
//        if ([DDUtils isEmptyString:model.reading_quantity]) {
//            cell.attachLab2.text=@"";
//        }
//        else{
//            cell.attachLab2.text=[NSString stringWithFormat:@"%@阅读",model.reading_quantity];
//        }
//        cell.attachLab3.text=[DDUtils compareTime:model.publish_date_source];
//
//        cell.selectionStyle=UITableViewCellSelectionStyleNone;
//        return cell;
//    }
    if([model.title_type isEqualToString:@"2"]){//单张图片
        static NSString * cellID = @"DDIndustryNews4Cell";
        DDIndustryNews4Cell * cell = (DDIndustryNews4Cell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
        }
        
        cell.tipLab.hidden=YES;
        cell.leftDistance.constant=17;
        
        cell.titleLab.text=model.title;
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",DD_Http_Image_Server,model.attr_img]] placeholderImage:[UIImage imageNamed:@"home_pic_loading"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                cell.imgView.image = image;
            }
        }];
        cell.attachLab1.text=model.dept_source;
        if ([DDUtils isEmptyString:model.reading_quantity]) {
            cell.attachLab2.text=@"";
        }
        else{
            cell.attachLab2.text=[NSString stringWithFormat:@"%@阅读",model.reading_quantity];
        }
        cell.attachLab3.text=[DDUtils getDateLineByStandardTime:model.publish_date_source];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if([model.title_type isEqualToString:@"3"]){//多张图片
        static NSString * cellID = @"DDIndustryNews3Cell";
        DDIndustryNews3Cell * cell = (DDIndustryNews3Cell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
        }
        
        cell.tipLab.hidden=YES;
        cell.leftDistance.constant=17;
        
        [cell loadDataWithContent:model.title];
        
        cell.attachLab1.text=model.dept_source;
        if ([DDUtils isEmptyString:model.reading_quantity]) {
            cell.attachLab2.text=@"";
        }
        else{
            cell.attachLab2.text=[NSString stringWithFormat:@"%@阅读",model.reading_quantity];
        }
        cell.attachLab3.text=[DDUtils getDateLineByStandardTime:model.publish_date_source];
        
        NSArray *array;
        if ([model.attr_img containsString:@";"]) {
            array=[model.attr_img componentsSeparatedByString:@";"];
        }
        else{
            [cell.img1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",DD_Http_Image_Server,model.attr_img]] placeholderImage:[UIImage imageNamed:@"home_pic_loading"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (image) {
                    cell.img1.image = image;
                }
            }];
        }
        
        if (array.count>0) {
            [cell.img1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",DD_Http_Image_Server,array[0]]] placeholderImage:[UIImage imageNamed:@"home_pic_loading"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (image) {
                    cell.img1.image = image;
                }
            }];
        }
        
        if (array.count>1) {
            [cell.img2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",DD_Http_Image_Server,array[1]]] placeholderImage:[UIImage imageNamed:@"home_pic_loading"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (image) {
                    cell.img2.image = image;
                }
            }];
        }
        
        if (array.count>2) {
            [cell.img3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",DD_Http_Image_Server,array[2]]] placeholderImage:[UIImage imageNamed:@"home_pic_loading"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (image) {
                    cell.img3.image = image;
                }
            }];
        }
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    else{//纯文本
        static NSString * cellID = @"DDIndustryNews1Cell";
        DDIndustryNews1Cell * cell = (DDIndustryNews1Cell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
        }
        
        cell.tipLab.hidden=YES;
        cell.leftDistance.constant=17;
        
        [cell loadDataWithContent:model.title];
        
        cell.attachLab1.text=model.dept_source;
        if ([DDUtils isEmptyString:model.reading_quantity]) {
            cell.attachLab2.text=@"";
        }
        else{
            cell.attachLab2.text=[NSString stringWithFormat:@"%@阅读",model.reading_quantity];
        }
        cell.attachLab3.text=[DDUtils getDateLineByStandardTime:model.publish_date_source];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
}

#pragma mark 点击跳转到行业动态的详情页面
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        DDIndustryDynamicListModel *model=_dataSourceArr[indexPath.row];
        
        DDIndustryDynamicDetailVC *industryDynamicDetail=[[DDIndustryDynamicDetailVC alloc]init];
        industryDynamicDetail.docId=model.doc_id;
        industryDynamicDetail.titleStr=model.title;
        [self.navigationController pushViewController:industryDynamicDetail animated:NO];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if ([model.title_type isEqualToString:@"1"]) {//链接
//        return 180;
//    }
    if (indexPath.section == 0) {
        return WidthByiPhone6(164);
    }
//    if (indexPath.section == 1) {
//        return WidthByiPhone6(449);
//    }
    if (indexPath.section == 1) {
        return WidthByiPhone6(150);
    }
    DDIndustryDynamicListModel *model=_dataSourceArr[indexPath.row];
    if([model.title_type isEqualToString:@"2"]){//单张图片
        return 112+30-5-5;
    }
    else if([model.title_type isEqualToString:@"3"]){//多张图片
        return [DDLabelUtil getSpaceLabelHeightWithString:model.title font:kFontSize34 width:(Screen_Width-34)]+75+88;
    }
    else{//纯文本
        return [DDLabelUtil getSpaceLabelHeightWithString:model.title font:kFontSize34 width:(Screen_Width-34)]+75;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 0){
        _bigHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 175)];
        //_bigHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 150+1+50+1)];
        //_bigHeaderView.backgroundColor=kColorBackGroundColor;
        
        //******第一个View******
        UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 80)];
        view1.backgroundColor=kColorWhite;
        
        if ([DDUtils isEmptyString:[DDUserManager sharedInstance].userid]) {//未登录
            UIImageView *headIcon=[[UIImageView alloc]initWithFrame:CGRectMake(12, 18.5, 43, 43)];
            [headIcon styleWithCorner];
            headIcon.image=[UIImage imageNamed:@"default_head_gray"];
            [view1 addSubview:headIcon];
            
            UILabel *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(headIcon.frame)+10, 30, 100, 20)];
            nameLab.text=@"未登录";
            nameLab.textColor=KColorCompanyTitleBalck;
            nameLab.font=KfontSize34Bold;
            [view1 addSubview:nameLab];
            
            UIButton *logBtn=[[UIButton alloc]initWithFrame:CGRectMake(Screen_Width-12-90, 24, 90, 32)];
            [logBtn addTarget:self action:@selector(presentLoginVC) forControlEvents:UIControlEventTouchUpInside];
            [logBtn setBackgroundColor:kColorBlue];
            [logBtn setTitle:@"登录/注册" forState:UIControlStateNormal];
            [logBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
            logBtn.titleLabel.font=kFontSize28;
            logBtn.layer.cornerRadius=3;
            logBtn.clipsToBounds=YES;
            [view1 addSubview:logBtn];
        }
        else{//已登录
            DDUserManager * userManger = [DDUserManager sharedInstance];
            UIImageView *headIcon=[[UIImageView alloc]initWithFrame:CGRectMake(12, 18.5, 43, 43)];
            [headIcon styleWithCorner];
            NSString * urlString = [NSString stringWithFormat:@"%@%@",DD_Http_Image_Server,userManger.headImg];
            [headIcon sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"default_head_blue"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (image) {
                    headIcon.image = image;
                }
            }];
            [view1 addSubview:headIcon];
            
            UILabel *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(headIcon.frame)+10, 30, 100, 20)];
            //如果有用户名,优先显示用户名,如果没有用户名,显示昵称
            if (![DDUtils isEmptyString:userManger.realName]) {
                nameLab.text = userManger.realName;
            }else{
                nameLab.text = userManger.nickName;
            }
            nameLab.textColor=KColorCompanyTitleBalck;
            nameLab.font=KfontSize34Bold;
            [view1 addSubview:nameLab];
            
            DDCurrentCompanyModel * currentCompanyModel = [DDUserManager sharedInstance].currentCompanyModel;
            DDScAttestationEntityModel *  scAttestationEntityModel = currentCompanyModel.scAttestationEntity;
            
            if ([DDUtils isEmptyString:scAttestationEntityModel.entId]) {//没有认证的公司（没有主企业）
                UIImageView *arrowImg=[[UIImageView alloc]initWithFrame:CGRectMake(Screen_Width-12-15, 20.5, 15, 15)];
                arrowImg.image=[UIImage imageNamed:@"home_com_more"];
                [view1 addSubview:arrowImg];
                
                UILabel *verifyLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(arrowImg.frame)-5-50, 20.5, 50, 15)];
                verifyLab.text=@"去认领";
                verifyLab.textColor=kColorBlue;
                verifyLab.font=kFontSize30;
                [view1 addSubview:verifyLab];
                
                UILabel *detailLab=[[UILabel alloc]initWithFrame:CGRectMake(Screen_Width-150-15, CGRectGetMaxY(verifyLab.frame)+9, 150, 15)];
                detailLab.text=@"认领后人员自动匹配";
                detailLab.textColor=KColorCompanyAffirmGrey;
                detailLab.textAlignment=NSTextAlignmentRight;
                detailLab.font=kFontSize26;
                [view1 addSubview:detailLab];
                
                UIButton *verifyBtn=[[UIButton alloc]initWithFrame:CGRectMake(Screen_Width-12-15-5-50, 18, 50+5+15, 20)];
                [verifyBtn addTarget:self action:@selector(verifyClick) forControlEvents:UIControlEventTouchUpInside];
                [view1 addSubview:verifyBtn];
            }
            else{//有认证的公司(有主企业)
                
                //认证状态
                if ([scAttestationEntityModel.attestationStatus isEqualToString:@"1"]) {
                    UILabel *companyLab=[[UILabel alloc]initWithFrame:CGRectMake(Screen_Width-12-(Screen_Width/5*3), 20.5, Screen_Width/5*3, 15)];
                    companyLab.text=scAttestationEntityModel.entName;
                    companyLab.textColor=KColorBlackTitle;
                    companyLab.font=kFontSize30;
                    companyLab.textAlignment=NSTextAlignmentRight;
                    [view1 addSubview:companyLab];
                    
                    UILabel *statusLab=[[UILabel alloc]initWithFrame:CGRectMake(Screen_Width-150-15, CGRectGetMaxY(companyLab.frame)+9, 150, 15)];
                    statusLab.textColor=kColorBlue;
                    statusLab.textAlignment=NSTextAlignmentRight;
                    statusLab.font=kFontSize26;
                    statusLab.text =  @"已认领";
                    [view1 addSubview:statusLab];
                    
                }
                else if ([scAttestationEntityModel.attestationStatus isEqualToString:@"2"]){
                    UILabel *companyLab=[[UILabel alloc]initWithFrame:CGRectMake(Screen_Width-12-(Screen_Width/5*3), 20.5, Screen_Width/5*3, 15)];
                    companyLab.text=scAttestationEntityModel.entName;
                    companyLab.textColor=KColorBlackTitle;
                    companyLab.font=kFontSize30;
                    companyLab.textAlignment=NSTextAlignmentRight;
                    [view1 addSubview:companyLab];
                    
                    UILabel *statusLab=[[UILabel alloc]initWithFrame:CGRectMake(Screen_Width-150-15, CGRectGetMaxY(companyLab.frame)+9, 150, 15)];
                    statusLab.textColor=kColorBlue;
                    statusLab.textAlignment=NSTextAlignmentRight;
                    statusLab.font=kFontSize26;
                    statusLab.text =  @"认领中";
                    [view1 addSubview:statusLab];
                }
                else{
                    UIImageView *arrowImg=[[UIImageView alloc]initWithFrame:CGRectMake(Screen_Width-12-15, 20.5, 15, 15)];
                    arrowImg.image=[UIImage imageNamed:@"home_com_more"];
                    [view1 addSubview:arrowImg];
                    
                    UILabel *verifyLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(arrowImg.frame)-5-50, 20.5, 50, 15)];
                    verifyLab.text=@"去认领";
                    verifyLab.textColor=kColorBlue;
                    verifyLab.font=kFontSize30;
                    [view1 addSubview:verifyLab];
                    
                    UILabel *detailLab=[[UILabel alloc]initWithFrame:CGRectMake(Screen_Width-150-15, CGRectGetMaxY(verifyLab.frame)+9, 150, 15)];
                    detailLab.text=@"认领后人员自动匹配";
                    detailLab.textColor=KColorCompanyAffirmGrey;
                    detailLab.textAlignment=NSTextAlignmentRight;
                    detailLab.font=kFontSize26;
                    [view1 addSubview:detailLab];
                    
                    UIButton *verifyBtn=[[UIButton alloc]initWithFrame:CGRectMake(Screen_Width-12-15-5-50, 18, 50+5+15, 20)];
                    [verifyBtn addTarget:self action:@selector(verifyClick) forControlEvents:UIControlEventTouchUpInside];
                    [view1 addSubview:verifyBtn];
                }
            }
        }
        
        [_bigHeaderView addSubview:view1];
        
        //******第二个View******
        UIView *view2=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(view1.frame)+15, Screen_Width, 80)];
        view2.backgroundColor=kColorWhite;
        [view2 addSubview:self.topBannerView];
        [_bigHeaderView addSubview:view2];
        return _bigHeaderView;
    }
    if (section == 2) {
        UIView *headV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, WidthByiPhone6(50))];
        headV.backgroundColor = kColorWhite;
        UILabel *infoL = [UILabel labelWithFont:KfontSize34Bold textColor:KColorBlackTitle textAlignment:NSTextAlignmentLeft numberOfLines:1];
        infoL.frame = CGRectMake(WidthByiPhone6(12), 0, Screen_Width-WidthByiPhone6(20), WidthByiPhone6(50)-LineHeight);
        infoL.text = @"考试政策";
        [headV addSubview:infoL];
        
        UILabel *lineL = [[UILabel alloc]initWithFrame:CGRectMake(0, WidthByiPhone6(50)-LineHeight, Screen_Width, LineHeight)];
        lineL.backgroundColor = KColor10AlphaBlack;
        [headV addSubview:lineL];
        return headV;
    }
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return 175;
    }
    if(section == 2){
        return WidthByiPhone6(50);
    }
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return WidthByiPhone6(15);
}


#pragma mark 培训报名
-(void)trainClick:(UIButton *)sender{
    //[DDUtils showToastWithMessage:@"当前版本暂未发布此功能"];
    
    if ([DDUtils isEmptyString:[DDUserManager sharedInstance].userid]) {//未登录
        [self presentLoginVC];//先登录
    }
    else{//已登录
        DDCurrentCompanyModel * currentCompanyModel = [DDUserManager sharedInstance].currentCompanyModel;
        DDScAttestationEntityModel *  scAttestationEntityModel = currentCompanyModel.scAttestationEntity;

        __weak __typeof(self) weakSelf=self;
        if ([DDUtils isEmptyString:scAttestationEntityModel.entId]) {//没有认证的公司（没有主企业）
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"还没有认领成功的企业" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

            }];
            UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"去认领" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf verifyClick];
            }];
            [alertController addAction:cancelAction];
            [alertController addAction:sureAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        else{//有认证的公司(有主企业)
            //认证状态
            if ([scAttestationEntityModel.attestationStatus isEqualToString:@"1"]) {
                
                DDAgencySelectViewController *agencySelectVC = [[DDAgencySelectViewController alloc] init];
                [self.navigationController pushViewController:agencySelectVC animated:YES];
                
                /*
                if (sender.tag==51) {//二建继续教育
                    DDBuilderMoreTrainVC *builderMoreTrain=[[DDBuilderMoreTrainVC alloc]init];
                    [self.navigationController pushViewController:builderMoreTrain animated:YES];
                }
                else if(sender.tag==52){//三类人员新培
                    DDSafeManNewAgencySelectVC *agencySelect=[[DDSafeManNewAgencySelectVC alloc]init];
                    [self.navigationController pushViewController:agencySelect animated:YES];
                }
                else if(sender.tag==53){//三类人员继续教育
                    DDSafeManMoreTrainVC *safeManMoreTrain=[[DDSafeManMoreTrainVC alloc]init];
                    [self.navigationController pushViewController:safeManMoreTrain animated:YES];
                }
                else if(sender.tag==54){//现场施工管理新培
                    DDLiveManagerNewAgencySelectVC *agencySelect=[[DDLiveManagerNewAgencySelectVC alloc]init];
                    [self.navigationController pushViewController:agencySelect animated:YES];
                }
                else if(sender.tag==55){//现场施工管理继续教育
                    DDLiveManagerMoreAgencySelectVC *agencySelect=[[DDLiveManagerMoreAgencySelectVC alloc]init];
                    [self.navigationController pushViewController:agencySelect animated:YES];
                }
                 */
            }
            else{
                UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"还没有认领成功的企业" message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

                }];
                UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"去认领" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [weakSelf verifyClick];
                }];
                [alertController addAction:cancelAction];
                [alertController addAction:sureAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }
        }
    }
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:KGetUserMainCompanyInfoSuccess object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:KReceiveCompanyPassNews object:nil];
}

#pragma mark SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
//    NSLog(@"---点击了第%ld张图片", (long)index);
//    
//    DDBannerPicturesModel *model=_bannerPicturesArr[index];
//    
//    if ([model.toActive isEqualToString:@"2"]) {
//        DDProjectCheckOriginWebVC *webView=[[DDProjectCheckOriginWebVC alloc]init];
//        webView.hostUrl=model.url;
//        webView.hidesBottomBarWhenPushed=YES;
//        [self.navigationController pushViewController:webView animated:YES];
//    }
//    else if([model.toActive isEqualToString:@"3"]){//跳转后台编辑的URL
//        DDProjectCheckOriginWebVC *webView=[[DDProjectCheckOriginWebVC alloc]init];
//        
//        NSString *urlStr=[NSString stringWithFormat:@"%@/app/pagemodule/getContent/%@", DD_Http_Server,model.id];
//        
//        webView.hostUrl=urlStr;
//        webView.hidesBottomBarWhenPushed=YES;
//        [self.navigationController pushViewController:webView animated:YES];
//    }
}

- (SDCycleScrollView *)topBannerView{
    
    if (_topBannerView == nil) {
        _topBannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, Screen_Width, 80) delegate:self placeholderImage:nil];
        _topBannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _topBannerView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _topBannerView.autoScroll = YES;
        _topBannerView.delegate = self;
    }
    return _topBannerView;
}
@end
