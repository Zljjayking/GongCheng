//
//  DDSafeManAgencySelectVC.m
//  GongChengDD
//
//  Created by xzx on 2018/7/14.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDSafeManAgencySelectVC.h"
#import "MJRefresh.h"
#import "DDActionSheetView.h"
#import "DDNavigationManager.h"
#import "DDLocationManager.h"
#import "DDGeocoderManager.h"
#import "DataLoadingView.h"//加载页面
#import "DDNoResultView.h"//无数据视图
#import "DDAgencySelect1Cell.h"//cell
#import "DDAgencySelect2Cell.h"//cell
#import "DDAgencySelectModel.h"//model
#import "DDSafeManAndAgencyVC.h"//选中的人员和培训机构汇总页面
#import "DDSafeManAddApplyVC.h"//安全员添加报名页面
#import "DDSafeManAddApplyRecordVC.h"//安全员报名记录页面

@interface DDSafeManAgencySelectVC ()<UITableViewDelegate,UITableViewDataSource,DDActionSheetViewDelegate,DDLocationMangerDelegate,DDGeocoderMangerDelegate>

{
    CLLocationCoordinate2D _startCoordinate;
    CLLocationCoordinate2D _endCoordinate;
    NSString *_addressName;
    
    NSInteger currentPage;
    NSInteger pageCount;
    NSMutableArray *_dataSourceArr;
    NSMutableDictionary *_dict;
}
@property(nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) DataLoadingView *loadingView;
@property (nonatomic,strong) DDNoResultView *noResultView;//无数据视图
@property (nonatomic,assign)NSInteger navClickIndex;//选择的导航地图索引

@end

@implementation DDSafeManAgencySelectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataSourceArr=[[NSMutableArray alloc]init];
    self.view.backgroundColor=kColorBackGroundColor;
    self.title=@"机构选择";
    self.navigationItem.leftBarButtonItem=[DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
    [self createTableView];
    [self createLoadView];
    [self requestData];
}

//返回上一页
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 创建加载视图
-(void)createLoadView{
    __weak __typeof(self) weakSelf=self;
    _noResultView=[[DDNoResultView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-KNavigationBarHeight)];
    [self.view addSubview:_noResultView];
    
    _loadingView = [[DataLoadingView alloc] initWithController:self];
    _loadingView.loadingTitle = KLoading;
    _loadingView.failureTitle = KLoadingFailure;
    _loadingView.reloadHandle = ^(void){
        [weakSelf requestData];
    };
    [_loadingView showLoadingView];
}

//创建tableView
-(void)createTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-KNavigationBarHeight) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.showsVerticalScrollIndicator=YES;
    _tableView.estimatedRowHeight=44;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, KTableViewFooterViewHeight)];
    
    __weak __typeof(self) weakSelf=self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestData];
    }];
}

#pragma mark 请求数据
- (void)requestData{
    currentPage = 1;
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:@"3" forKey:@"trainType"];
    [params setValue:self.certType forKey:@"certType"];
    [params setValue:[NSString stringWithFormat:@"%ld",currentPage] forKey:@"current"];
    [params setValue:@"10" forKey:@"size"];
    
    
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_trainCenterList params:params success:^(NSURLSessionDataTask *operation, id responseObject){
        NSLog(@"**********机构选择列表数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        __weak __typeof(self) weakSelf = self;
        if (response.isSuccess) {
            [_dataSourceArr removeAllObjects];
            [_loadingView hiddenLoadingView];
            _dict = responseObject[KData];
            pageCount = [_dict[@"totalCount"] integerValue];
            NSArray *listArr=_dict[@"list"];
            
            
            if (listArr.count!=0) {
                [_noResultView hiddenNoDataView];
                
                for (NSDictionary *dic in listArr) {
                    DDAgencySelectModel *model = [[DDAgencySelectModel alloc]initWithDictionary:dic error:nil];
                    model.isClosed=@"1";
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
                [_noResultView showNoResultViewWithTitle:@"企业信息" andImage:@"noResult_company"];
            }
            
        }
        else{
            [_loadingView failureLoadingView];
        }
        
        [self.tableView.mj_header endRefreshing];
        [_tableView reloadData];
        
    }  failure:^(NSURLSessionDataTask *operation, id responseObject)  {
        [DDUtils showToastWithMessage:kRequestFailed];
        [_loadingView failureLoadingView];
    }];
}

- (void)addData{
    currentPage++;
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [params setValue:@"3" forKey:@"trainType"];
    [params setValue:self.certType forKey:@"certType"];
    [params setValue:[NSString stringWithFormat:@"%ld",currentPage] forKey:@"current"];
    [params setValue:@"10" forKey:@"size"];
    
    
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_trainCenterList params:params success:^(NSURLSessionDataTask *operation, id responseObject){
        NSLog(@"**********机构选择列表数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        __weak __typeof(self) weakSelf = self;
        if (response.isSuccess) {
            
            _dict = responseObject[KData];
            NSArray *listArr = _dict[@"list"];
            for (NSDictionary *dic in listArr) {
                DDAgencySelectModel *model = [[DDAgencySelectModel alloc]initWithDictionary:dic error:nil];
                model.isClosed=@"1";
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
    DDAgencySelectModel *model=_dataSourceArr[indexPath.section];
    
    if ([model.isClosed isEqualToString:@"1"]) {
        static NSString * cellID = @"DDAgencySelect1Cell";
        DDAgencySelect1Cell * cell = (DDAgencySelect1Cell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
        }
        
        cell.titleLab.text=model.name;
        cell.addressLab.text=[NSString stringWithFormat:@"%@%@%@%@",model.province,model.city,model.area,model.detail];
        cell.moneyLab.text=model.speciality_price;
        
        cell.assignBtn.tag=210+indexPath.section;
        [cell.assignBtn addTarget:self action:@selector(assignClick1:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.arrowImg.image=[UIImage imageNamed:@"home_select_down"];
        cell.extraBtn.tag=10+indexPath.section;
        [cell.extraBtn addTarget:self action:@selector(arrowBtnClick1:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.addressBtn.tag=150+indexPath.section;
        [cell.addressBtn addTarget:self action:@selector(mapNavigationClick1:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    else{
        static NSString * cellID = @"DDAgencySelect2Cell";
        DDAgencySelect2Cell * cell = (DDAgencySelect2Cell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
        }
        
        //        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        //        paragraphStyle.maximumLineHeight = lineHeight;
        //        paragraphStyle.minimumLineHeight = lineHeight;
        //        NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
        //        [attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
        //        label.attributedText = [[NSAttributedString alloc] initWithString:label.text attributes:attributes];
        model.price = @"";
        cell.titleLab.text=model.name;
        cell.addressLab.text=model.detail;
        cell.moneyLab.text=model.speciality_price;
        if ([DDUtils isEmptyString:model.train_recommend]) {
            cell.introduceLab.text=model.price;
        }
        else if([DDUtils isEmptyString:model.price]){
            cell.introduceLab.text=model.train_recommend;
        }
        else{
            cell.introduceLab.text=[NSString stringWithFormat:@"%@。%@",model.train_recommend,model.price];
        }
        cell.explainLab.text=model.train_explain;
        
        cell.assignBtn.tag=290+indexPath.section;
        [cell.assignBtn addTarget:self action:@selector(assignClick2:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.arrowImg.image=[UIImage imageNamed:@"home_select_up"];
        cell.extraBtn.tag=90+indexPath.section;
        [cell.extraBtn addTarget:self action:@selector(arrowBtnClick2:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.addressBtn.tag=350+indexPath.section;
        [cell.addressBtn addTarget:self action:@selector(mapNavigationClick2:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
}

#pragma mark 在线报名点击事件1
-(void)assignClick1:(UIButton *)sender{
    DDAgencySelectModel *model=_dataSourceArr[sender.tag-210];
    
    if ([self.isFromeAddApply isEqualToString:@"1"]) {
        [self judgeHasSignUp:model.train_agency_id andAgencyName:model.name];
    }
    else{
        DDSafeManAndAgencyVC *safeManAndAgency=[[DDSafeManAndAgencyVC alloc]init];
        
        safeManAndAgency.peopleName=self.peopleName;
        safeManAndAgency.majorName=self.majorName;
        safeManAndAgency.certiNo=self.certiNo;
        safeManAndAgency.certiState=self.certiState;
        safeManAndAgency.endTime=self.endTime;
        safeManAndAgency.endDays=self.endDays;
        safeManAndAgency.tel=self.tel;
        
        safeManAndAgency.agencyName=model.name;
        safeManAndAgency.address=model.detail;
        safeManAndAgency.majorPrice=model.speciality_price;
        safeManAndAgency.price=model.price;
        safeManAndAgency.introduce=model.train_recommend;
        safeManAndAgency.explain=model.train_explain;
        
        safeManAndAgency.userId=self.userId;
        safeManAndAgency.goodsId=model.agency_major_id;
        safeManAndAgency.trainId=model.train_agency_id;
        
        safeManAndAgency.certiTypeId=self.certiTypeId;
        
        safeManAndAgency.idCard=self.idCard;
        safeManAndAgency.companyName=self.companyName;
        safeManAndAgency.companyId=self.companyId;
        
        safeManAndAgency.staffId=self.staffId;
        
        [self.navigationController pushViewController:safeManAndAgency animated:YES];
    }
}

#pragma mark 在线报名点击事件2
-(void)assignClick2:(UIButton *)sender{
    DDAgencySelectModel *model=_dataSourceArr[sender.tag-290];
    
    if ([self.isFromeAddApply isEqualToString:@"1"]) {
        [self judgeHasSignUp:model.train_agency_id andAgencyName:model.name];
    }
    else{
        DDSafeManAndAgencyVC *safeManAndAgency=[[DDSafeManAndAgencyVC alloc]init];
        
        safeManAndAgency.peopleName=self.peopleName;
        safeManAndAgency.majorName=self.majorName;
        safeManAndAgency.certiNo=self.certiNo;
        safeManAndAgency.certiState=self.certiState;
        safeManAndAgency.endTime=self.endTime;
        safeManAndAgency.endDays=self.endDays;
        safeManAndAgency.tel=self.tel;
        
        safeManAndAgency.agencyName=model.name;
        safeManAndAgency.address=model.detail;
        safeManAndAgency.majorPrice=model.speciality_price;
        safeManAndAgency.price=model.price;
        safeManAndAgency.introduce=model.train_recommend;
        safeManAndAgency.explain=model.train_explain;
        
        safeManAndAgency.userId=self.userId;
        safeManAndAgency.goodsId=model.agency_major_id;
        safeManAndAgency.trainId=model.train_agency_id;
        
        safeManAndAgency.certiTypeId=self.certiTypeId;
        
        safeManAndAgency.idCard=self.idCard;
        safeManAndAgency.companyName=self.companyName;
        safeManAndAgency.companyId=self.companyId;
        
        safeManAndAgency.staffId=self.staffId;
        
        [self.navigationController pushViewController:safeManAndAgency animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
    //return 114;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return CGFLOAT_MIN;
    }
    else{
        return 15;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

#pragma mark 展开收起点击事件1
-(void)arrowBtnClick1:(UIButton *)sender{
    DDAgencySelectModel *model=_dataSourceArr[sender.tag-10];
    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:sender.tag-10];
    if ([model.isClosed isEqualToString:@"1"]) {
        model.isClosed=@"0";
        
        [_tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
        //        [_tableView reloadData];
    }
    else{
        model.isClosed=@"1";
        [_tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
        //        [_tableView reloadData];
    }
}

#pragma mark 展开收起点击事件2
-(void)arrowBtnClick2:(UIButton *)sender{
    DDAgencySelectModel *model=_dataSourceArr[sender.tag-90];
    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:sender.tag-90];
    if ([model.isClosed isEqualToString:@"1"]) {
        model.isClosed=@"0";
        [_tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
        //        [_tableView reloadData];
    }
    else{
        model.isClosed=@"1";
        [_tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
        //        [_tableView reloadData];
    }
}
#pragma mark 判断是否有之前添加的人员数据
-(void)judgeHasSignUp:(NSString *)agencyId andAgencyName:(NSString *)agencyName{
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:agencyId forKey:@"agencyId"];
    [params setValue:@"3" forKey:@"trainType"];
    
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_judgeHasSignUp params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"***********判断是否存在报名记录***************%@",responseObject);
        
        __weak __typeof(self) weakSelf=self;
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            
            if ([responseObject[KData] isEqual:@1]) {//跳转到之前添过的人的列表
                DDSafeManAddApplyRecordVC *safeManAddApplyRecord=[[DDSafeManAddApplyRecordVC alloc]init];
                safeManAddApplyRecord.agencyId=agencyId;
                safeManAddApplyRecord.agencyName=agencyName;
                [weakSelf.navigationController pushViewController:safeManAddApplyRecord animated:YES];
            }
            else{//跳转到填信息页面
                DDSafeManAddApplyVC *safeManAddApply=[[DDSafeManAddApplyVC alloc]init];
                safeManAddApply.agencyId=agencyId;
                safeManAddApply.agencyName=agencyName;
                safeManAddApply.isFromeAddApply=_isFromeAddApply;
                [weakSelf.navigationController pushViewController:safeManAddApply animated:YES];
            }
            
        }
        else{
            [DDUtils showToastWithMessage:response.message];
        }
        
    } failure:^(NSURLSessionDataTask *operation, id responseObject) {
        [DDUtils showToastWithMessage:kRequestFailed];
    }];
}

#pragma mark 地图导航
-(void)mapNavigationClick1:(UIButton *)sender{
    DDAgencySelectModel *model=_dataSourceArr[sender.tag-150];
    _addressName=model.detail;
    
    DDActionSheetView * sheetView = [[DDActionSheetView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
    NSArray * titles =[[NSArray alloc] initWithObjects:charAppleMapNav,charBaiDuMapNav,charGaoDeMapNav, nil];
    [sheetView setTitle:titles cancelTitle:KMainCancel];
    sheetView.delegate = self;
    [sheetView show];
}

-(void)mapNavigationClick2:(UIButton *)sender{
    DDAgencySelectModel *model=_dataSourceArr[sender.tag-350];
    _addressName=model.detail;
    
    DDActionSheetView * sheetView = [[DDActionSheetView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
    NSArray * titles =[[NSArray alloc] initWithObjects:charAppleMapNav,charBaiDuMapNav,charGaoDeMapNav, nil];
    [sheetView setTitle:titles cancelTitle:KMainCancel];
    sheetView.delegate = self;
    [sheetView show];
}

#pragma mark -- DDActionSheetViewDelegate
-(void)actionsheetSelectButton:(DDActionSheetView *)actionSheet buttonIndex:(NSInteger)index{
    _navClickIndex = index;
    //地理编码
    [self startGeocodeAddressString];
    //定位
    [self startLocation];
}

#pragma mark -- 地理编码
- (void)startGeocodeAddressString{
    DDGeocoderManager * manger = [DDGeocoderManager sharedInstance];
    [manger geocodeAddressString:_addressName];
    manger.delegate = self;
}

#pragma mark -- DDGeocoderMangerDelegate
- (void)geocodeResult:(DDGeocoderManager*)manger  location:(CLLocation*)location{
    if (location) {
        NSLog(@"地理编码成功--%f--%f",location.coordinate.longitude,location.coordinate.latitude);
        _endCoordinate.longitude =location.coordinate.longitude;
        _endCoordinate.latitude =location.coordinate.latitude;
        [self openMapApp];
    }
}

#pragma mark -- 定位
- (void)startLocation{
    DDLocationManager * locationManger = [DDLocationManager sharedInstance];
    locationManger.delegate = self;
    [locationManger startLocation];
}

#pragma mark -- DDLocationMangerDelegate
- (void)locationResult:(DDLocationManager*)manger  location:(CLLocation*)location isSuccess:(BOOL)success{
    if (YES == success) {
        NSLog(@"定位成功--%f--%f",location.coordinate.longitude,location.coordinate.latitude);
        _startCoordinate.longitude =location.coordinate.longitude;
        _startCoordinate.latitude =location.coordinate.latitude;
        [self openMapApp];
    }
}
#pragma mark 打开地图app导航
- (void)openMapApp{
    //参数检验
    if (_startCoordinate.longitude>0 && _endCoordinate.longitude>0) {
        DDNavigationManager * navManger = [DDNavigationManager sharedInstance];
        navManger.startCoordinate = _startCoordinate;
        navManger.endCoordinate = _endCoordinate;
        navManger.endName =_addressName;
        
        if (1 == _navClickIndex) {
            [navManger openAppleMapNavigation];
            
        }else if (2 == _navClickIndex){
            [navManger openBaiDuMapNavigation];
            
        }else if (3 == _navClickIndex){
            [navManger openGaoDeMapNavigation];
        }
    } else {
        NSLog(@"导航参数缺失");
    }
    
}

@end
