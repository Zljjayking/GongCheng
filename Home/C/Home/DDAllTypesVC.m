//
//  DDAllTypesVC.m
//  GongChengDD
//
//  Created by xzx on 2018/5/9.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDAllTypesVC.h"
#import "DataLoadingView.h"
#import "DDAllTypesEditCell.h"//集合视图的cell
#import "DDAllTypesModel.h"//我的类型model
#import "DDEditAllTypesModel.h"//全部类型model
#import "DDPublicTypesModel.h"//自己定制的存放整合后的数据的model
#import "DDTypesHeaderView.h"//定制组头视图

#import "DDAllSearchVC.h"//公共搜索页面
#import "DDCompanyFocusVC.h"//公司关注页面
#import "DDSearchBuyCompanyListVC.h"//买公司搜索页面

#import "DDExamineTrainingVC.h"//考试培训页面

#import "DDNearCompanyVC.h"//附近公司

@interface DDAllTypesVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

{
    NSMutableArray *_dataSource;
    NSMutableArray *_myTypesArr;//存我的应用数据
    NSMutableArray *_allTypesArr;//存全部应用数据
    
    BOOL _isEdit;//记录是否在编辑状态
}
@property (nonatomic,strong) UICollectionView *collectionView;
@property (strong,nonatomic) DataLoadingView *loadingView;

@end

@implementation DDAllTypesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataSource=[[NSMutableArray alloc]init];
    _myTypesArr=[[NSMutableArray alloc]init];
    _allTypesArr=[[NSMutableArray alloc]init];
    _isEdit=NO;//初始化不在编辑状态
    [self editNavItem];
    [self createCollectionView];
    [self setupDataLoadingView];
    [self requestMyApplication];
}

-(void)editNavItem{
    self.view.backgroundColor=kColorBackGroundColor;
    self.title=@"全部分类";
    self.navigationItem.leftBarButtonItem = [DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
    self.navigationItem.rightBarButtonItem=[DDUtils rightbuttonItemWithTitle:@"管理" target:self action:@selector(editClick)];
}

#pragma mark --返回上一页
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:NO];
}

//编辑
-(void)editClick{
    _isEdit=YES;
    self.navigationItem.rightBarButtonItem=[DDUtils rightbuttonItemWithTitle:@"完成" target:self action:@selector(finishClick)];
    [_collectionView reloadData];
}

//完成,返回首页
-(void)finishClick{
    NSMutableArray *array=[[NSMutableArray alloc]init];
    for (DDPublicTypesModel *model in _dataSource[0][@"subInfo"]) {
        [array addObject:model.menuId];
    }
    if (array.count<15) {
        [DDUtils showToastWithMessage:@"至少保留15个分类！"];
        return;
    }
    NSString *menuIds=[array componentsJoinedByString:@","];
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:menuIds forKey:@"menuIds"];
    
    [[DDHttpManager sharedInstance]sendPostRequest:KHttpRequest_typesManager params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"**********定制我的应用结果***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {//请求成功
            self.refreshTypesBlock();
            //[self.navigationController popViewControllerAnimated:NO];
            self.navigationItem.rightBarButtonItem=[DDUtils rightbuttonItemWithTitle:@"管理" target:self action:@selector(editClick)];
            _isEdit=NO;
            [_collectionView reloadData];
        }
        else{//显示异常
            [DDUtils showToastWithMessage:response.message];
        }
        
    } failure:^(NSURLSessionDataTask *operation, id responseObject) {
        [DDUtils showToastWithMessage:kRequestFailed];
    }];
}

- (void)setupDataLoadingView{
    __weak __typeof(self) weakSelf=self;
    _loadingView = [[DataLoadingView alloc] initWithController:self];
    _loadingView.loadingTitle = KLoading;
    _loadingView.failureTitle = KLoadingFailure;
    _loadingView.reloadHandle = ^(void){
        [weakSelf requestMyApplication];
    };
    [_loadingView showLoadingView];
}

#pragma mark 查询我的应用
-(void)requestMyApplication{
    [[DDHttpManager sharedInstance]sendPostRequest:KHttpRequest_myApplication params:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"**********类别我的应用数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {//请求成功
            [_loadingView hiddenLoadingView];
            [_myTypesArr removeAllObjects];
            NSArray *listArr= responseObject[KData];
            for (NSDictionary *dic in listArr) {
                DDAllTypesModel *model=[[DDAllTypesModel alloc]initWithDictionary:dic error:nil];
                [_myTypesArr addObject:model];
            }
            
            [self requestAllApplication];
        }
        else{//显示异常
            [DDUtils showToastWithMessage:response.message];
            [_loadingView failureLoadingView];
        }
        
    } failure:^(NSURLSessionDataTask *operation, id responseObject) {
        [DDUtils showToastWithMessage:kRequestFailed];
        [_loadingView failureLoadingView];
    }];
}

#pragma mark 查询全部应用
-(void)requestAllApplication{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:@"1002" forKey:@"menuType"];
    
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_allApplication params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"***********类别全部应用数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {//请求成功
            [_allTypesArr removeAllObjects];
            NSArray *listArr= responseObject[KData];
            for (NSDictionary *dic in listArr) {
                DDEditAllTypesModel *model=[[DDEditAllTypesModel alloc]initWithDictionary:dic error:nil];
                [_allTypesArr addObject:model];
            }
        }
        else{//显示异常
            [DDUtils showToastWithMessage:response.message];
        }

        [self handleData];
        
    } failure:^(NSURLSessionDataTask *operation, id responseObject) {
        [DDUtils showToastWithMessage:kRequestFailed];
    }];
}

//处理一下数据问题,整合成一个数据源
-(void)handleData{
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    dic[@"name"]=@"我的应用";
    NSMutableArray *subInfo=[[NSMutableArray alloc]init];
    for (DDAllTypesModel *tempModel in _myTypesArr) {
        DDPublicTypesModel *mod=[[DDPublicTypesModel alloc]init];
        mod.menuId=tempModel.menuId;
        mod.name=tempModel.name;
        mod.iconFileId=tempModel.iconFileId;
        mod.type=@"1";
        [subInfo addObject:mod];
    }
    dic[@"subInfo"]=subInfo;
    [_dataSource addObject:dic];
    
    
    for (DDEditAllTypesModel *tempModel in _allTypesArr) {
        NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
        dic[@"name"]=tempModel.name;
        NSMutableArray *subInfo=[[NSMutableArray alloc]init];
        for (DDSubItemModel *tModel in tempModel.subItem) {
            DDPublicTypesModel *mod=[[DDPublicTypesModel alloc]init];
            mod.menuId=tModel.menuId;
            mod.name=tModel.name;
            mod.iconFileId=tModel.iconFileId;
            mod.type=@"0";
            [subInfo addObject:mod];
        }
        dic[@"subInfo"]=subInfo;
        [_dataSource addObject:dic];
    }
    
    for (int i=1; i<_dataSource.count; i++) {
        for (DDPublicTypesModel *model1 in _dataSource[i][@"subInfo"]) {
            int num=0;
            for (DDPublicTypesModel *model2 in _dataSource[0][@"subInfo"]) {
                if ([model1.menuId isEqual:model2.menuId]) {
                    num=num+1;
                    break;
                }
            }
            if (num==0) {
                model1.type=@"2";
            }
            else{
                model1.type=@"0";
            }
        }
    }
    
    [_collectionView reloadData];
}

//创建collectionView
-(void)createCollectionView{
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc]init];
    _collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width,Screen_Height-KNavigationBarHeight) collectionViewLayout:flowLayout];
    _collectionView.backgroundColor=kColorWhite;
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    _collectionView.scrollEnabled=YES;
    _collectionView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:_collectionView];
    
    //注册集合视图cell
    [_collectionView registerNib:[UINib nibWithNibName:@"DDAllTypesEditCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"DDAllTypesEditCell"];
    
   
    [_collectionView registerNib:[UINib nibWithNibName:@"DDTypesHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"DDTypesHeaderView"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FOOT"];
}

#pragma mark collectionView代理方法
//设置组数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return _dataSource.count;
}

//设置每个分区的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_dataSource[section][@"subInfo"] count];
}

//设置返回每个item的属性必须实现）
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DDPublicTypesModel *model=_dataSource[indexPath.section][@"subInfo"][indexPath.row];
    
    DDAllTypesEditCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"DDAllTypesEditCell" forIndexPath:indexPath];
    
    cell.titleLab.text=model.name;
    [cell.iconImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",DD_Http_Image_Server,model.iconFileId]] placeholderImage:[UIImage imageNamed:@"home_type_loading"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            cell.iconImg.image = image;
        }
    }];
    
    if (_isEdit==NO) {//不在编辑的状态
        cell.indicatorImg.hidden=YES;
    }
    else{//在编辑的状态
        cell.indicatorImg.hidden=NO;
        
        if ([model.type isEqualToString:@"1"]) {
            cell.indicatorImg.image=[UIImage imageNamed:@"home_type_minus"];
        }
        else if([model.type isEqualToString:@"0"]){
            cell.indicatorImg.image=nil;
        }
        else if([model.type isEqualToString:@"2"]){
            cell.indicatorImg.image=[UIImage imageNamed:@"home_type_add"];
        }
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    DDPublicTypesModel *model=_dataSource[indexPath.section][@"subInfo"][indexPath.row];
    
    if (_isEdit==YES) {//要在编辑状态才可以点击,每点一个都要刷新一下
        if (indexPath.section==0) {//第一组只减
            if ([_dataSource[0][@"subInfo"] count]==0) {
                [DDUtils showToastWithMessage:@"不能再少啦！"];
            }
            else{
                [_dataSource[0][@"subInfo"] removeObjectAtIndex:indexPath.row];
                [self filterDataSource];
                [_collectionView reloadData];
            }
        }
        else{//其他组都往第一组加
            if([model.type isEqualToString:@"0"]){//无图标
                //不处理
            }
            else if([model.type isEqualToString:@"2"]){//加号
                DDPublicTypesModel *mod=[[DDPublicTypesModel alloc]init];
                mod.name=model.name;
                mod.menuId=model.menuId;
                mod.iconFileId=model.iconFileId;
                mod.type=@"1";
                [_dataSource[0][@"subInfo"] addObject:mod];
                [self filterDataSource];
                [_collectionView reloadData];
            }
        }
    }
    else{
        if ([model.menuId isEqualToString:@"6"]) {//找企业
            DDAllSearchVC *allSearch=[[DDAllSearchVC alloc]init];
            allSearch.type=@"2";
            allSearch.menuId=model.menuId;
            allSearch.placeholderText=@"请输入企业名称、法定代表人";
            [self.navigationController pushViewController:allSearch animated:YES];
            
//            self.tabBarController.selectedIndex=1;
//            [self.navigationController popToRootViewControllerAnimated:NO];
        }
        else if ([model.menuId isEqualToString:@"18"]){//建造师
            DDAllSearchVC *allSearch=[[DDAllSearchVC alloc]init];
            allSearch.type=@"2";
            allSearch.menuId=model.menuId;
            allSearch.placeholderText=@"请输入建造师姓名";
            [self.navigationController pushViewController:allSearch animated:YES];
        }
        else if ([model.menuId isEqualToString:@"23"]){//项目经理
            DDAllSearchVC *allSearch=[[DDAllSearchVC alloc]init];
            allSearch.type=@"2";
            allSearch.menuId=model.menuId;
            allSearch.placeholderText=@"请输入项目经理姓名";
            [self.navigationController pushViewController:allSearch animated:YES];
        }
        else if ([model.menuId isEqualToString:@"7"]){//找老板
            DDAllSearchVC *allSearch=[[DDAllSearchVC alloc]init];
            allSearch.type=@"2";
            allSearch.menuId=model.menuId;
            allSearch.placeholderText=@"请输入姓名";
            [self.navigationController pushViewController:allSearch animated:YES];
        }
        else if ([model.menuId isEqualToString:@"19"]){//安全员
            DDAllSearchVC *allSearch=[[DDAllSearchVC alloc]init];
            allSearch.type=@"2";
            allSearch.menuId=model.menuId;
            allSearch.placeholderText=@"请输入三类人员姓名";
            [self.navigationController pushViewController:allSearch animated:YES];
        }
        else if ([model.menuId isEqualToString:@"22"]){//查中标
            DDAllSearchVC *allSearch=[[DDAllSearchVC alloc]init];
            allSearch.type=@"2";
            allSearch.menuId=model.menuId;
            allSearch.placeholderText=@"企业名称、项目名称、项目经理";
            [self.navigationController pushViewController:allSearch animated:YES];
            
//            self.tabBarController.selectedIndex=2;
//            [self.navigationController popToRootViewControllerAnimated:NO];
        }
        else if ([model.menuId isEqualToString:@"147"]){//PPP项目
            DDAllSearchVC *allSearch=[[DDAllSearchVC alloc]init];
            allSearch.type=@"2";
            allSearch.menuId=model.menuId;
            allSearch.placeholderText=@"企业名称、项目名称、项目经理";
            [self.navigationController pushViewController:allSearch animated:YES];
        }
        else if ([model.menuId isEqualToString:@"24"]){//行政处罚
            DDAllSearchVC *allSearch=[[DDAllSearchVC alloc]init];
            allSearch.type=@"2";
            allSearch.menuId=model.menuId;
            allSearch.placeholderText=@"请输入公司名称";
            [self.navigationController pushViewController:allSearch animated:YES];
        }
        else if ([model.menuId isEqualToString:@"25"]){//事故情况
            DDAllSearchVC *allSearch=[[DDAllSearchVC alloc]init];
            allSearch.type=@"2";
            allSearch.menuId=model.menuId;
            allSearch.placeholderText=@"请输入公司名称";
            [self.navigationController pushViewController:allSearch animated:YES];
        }
        else if ([model.menuId isEqualToString:@"27"]){//获奖荣誉
            DDAllSearchVC *allSearch=[[DDAllSearchVC alloc]init];
            allSearch.type=@"2";
            allSearch.menuId=model.menuId;
            allSearch.placeholderText=@"请输入公司名称";
            [self.navigationController pushViewController:allSearch animated:YES];
        }
        else if ([model.menuId isEqualToString:@"88"]){//法院公告
            DDAllSearchVC *allSearch=[[DDAllSearchVC alloc]init];
            allSearch.type=@"2";
            allSearch.menuId=model.menuId;
            allSearch.placeholderText=@"请输入公司名称";
            [self.navigationController pushViewController:allSearch animated:YES];
        }
        else if ([model.menuId isEqualToString:@"89"]){//裁判文书
            DDAllSearchVC *allSearch=[[DDAllSearchVC alloc]init];
            allSearch.type=@"2";
            allSearch.menuId=model.menuId;
            allSearch.placeholderText=@"请输入公司名称";
            [self.navigationController pushViewController:allSearch animated:YES];
        }
        else if ([model.menuId isEqualToString:@"16"]){//找资质
            DDAllSearchVC *allSearch=[[DDAllSearchVC alloc]init];
            allSearch.type=@"2";
            allSearch.menuId=model.menuId;
            allSearch.placeholderText=@"资质类别、企业名称、法人";
            [self.navigationController pushViewController:allSearch animated:YES];
            
//            self.tabBarController.selectedIndex=1;
//            [self.navigationController popToRootViewControllerAnimated:NO];
        }
        else if ([model.menuId isEqualToString:@"17"]){//安许证
            DDAllSearchVC *allSearch=[[DDAllSearchVC alloc]init];
            allSearch.type=@"2";
            allSearch.menuId=model.menuId;
            allSearch.placeholderText=@"单位名称、主要负责人";
            [self.navigationController pushViewController:allSearch animated:YES];
        }
        else if ([model.menuId isEqualToString:@"87"]){//被执行人
            DDAllSearchVC *allSearch=[[DDAllSearchVC alloc]init];
            allSearch.type=@"2";
            allSearch.menuId=model.menuId;
            allSearch.placeholderText=@"请输入公司名称";
            [self.navigationController pushViewController:allSearch animated:YES];
        }
        else if ([model.menuId isEqualToString:@"86"]){//失信信息
            DDAllSearchVC *allSearch=[[DDAllSearchVC alloc]init];
            allSearch.type=@"2";
            allSearch.menuId=model.menuId;
            allSearch.placeholderText=@"请输入公司名称";
            [self.navigationController pushViewController:allSearch animated:YES];
        }
        else if ([model.menuId isEqualToString:@"9"]){//买公司
//            DDAllSearchVC *allSearch=[[DDAllSearchVC alloc]init];
//            allSearch.type=@"2";
//            allSearch.menuId=model.menuId;
//            [self.navigationController pushViewController:allSearch animated:YES];
            
            DDSearchBuyCompanyListVC *buyCompanyList=[[DDSearchBuyCompanyListVC alloc]init];
            //buyCompanyList.searchText=model.title;
            buyCompanyList.menuId=model.menuId;
            [self.navigationController pushViewController:buyCompanyList animated:NO];
        }
        else if ([model.menuId isEqualToString:@"20"]){//考试通知
            DDExamineTrainingVC *examineTraining=[[DDExamineTrainingVC alloc]init];
            examineTraining.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:examineTraining animated:NO];
        }
//        else if ([model.menuId isEqualToString:@"10"]){//公关注
//            DDCompanyFocusVC * vc = [[DDCompanyFocusVC alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
//        }
        else if ([model.menuId isEqualToString:@"8"]){//找电话
            DDAllSearchVC *allSearch=[[DDAllSearchVC alloc]init];
            allSearch.type=@"2";
            allSearch.menuId=model.menuId;
            allSearch.placeholderText=@"请输入企业名称、法人姓名";
            [self.navigationController pushViewController:allSearch animated:NO];
        }
        else if ([model.menuId isEqualToString:@"122"]){//合同备案
            DDAllSearchVC *allSearch=[[DDAllSearchVC alloc]init];
            allSearch.type=@"2";
            allSearch.menuId=model.menuId;
            allSearch.placeholderText=@"请输入公司名称";
            [self.navigationController pushViewController:allSearch animated:NO];
        }
        else if ([model.menuId isEqualToString:@"123"]){//查工商
            DDAllSearchVC *allSearch=[[DDAllSearchVC alloc]init];
            allSearch.type=@"2";
            allSearch.menuId=model.menuId;
            allSearch.placeholderText=@"单位名称、法定代表人";
            [self.navigationController pushViewController:allSearch animated:NO];
        }
        else if ([model.menuId isEqualToString:@"129"]){//信用评分
            DDAllSearchVC *allSearch=[[DDAllSearchVC alloc]init];
            allSearch.type=@"2";
            allSearch.menuId=model.menuId;
            allSearch.placeholderText=@"请输入公司名称";
            [self.navigationController pushViewController:allSearch animated:NO];
        }
        else if ([model.menuId isEqualToString:@"193"]){//附近公司
            DDNearCompanyVC * vc= [[DDNearCompanyVC alloc] init];
            vc.type = @"0";
            DDUserManager * userManger = [DDUserManager sharedInstance];
            vc.position = [NSString stringWithFormat:@"%@ %@",userManger.longitude,userManger.latitude];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if ([model.menuId isEqualToString:@"149"]){//文明工地
            DDAllSearchVC *allSearch=[[DDAllSearchVC alloc]init];
            allSearch.type=@"2";
            allSearch.menuId=model.menuId;
            allSearch.placeholderText=@"请输入单位名称";
            [self.navigationController pushViewController:allSearch animated:NO];
        }
        else if ([model.menuId isEqualToString:@"150"]){//绿色工地
            DDAllSearchVC *allSearch=[[DDAllSearchVC alloc]init];
            allSearch.type=@"2";
            allSearch.menuId=model.menuId;
            allSearch.placeholderText=@"请输入公司名称";
            [self.navigationController pushViewController:allSearch animated:NO];
        }
        else if ([model.menuId isEqualToString:@"128"]){//施工工法
            DDAllSearchVC *allSearch=[[DDAllSearchVC alloc]init];
            allSearch.type=@"2";
            allSearch.menuId=model.menuId;
            allSearch.placeholderText=@"请输入工法名称、单位名称、工法编号";
            [self.navigationController pushViewController:allSearch animated:NO];
        }
        else if ([model.menuId isEqualToString:@"127"]){//守合同重信用
            DDAllSearchVC *allSearch=[[DDAllSearchVC alloc]init];
            allSearch.type=@"2";
            allSearch.menuId=model.menuId;
            allSearch.placeholderText=@"请输入单位名称";
            [self.navigationController pushViewController:allSearch animated:NO];
        }
        else if ([model.menuId isEqualToString:@"126"]){//AAA证书
            DDAllSearchVC *allSearch=[[DDAllSearchVC alloc]init];
            allSearch.type=@"2";
            allSearch.menuId=model.menuId;
            allSearch.placeholderText=@"请输入单位名称";
            [self.navigationController pushViewController:allSearch animated:NO];
        }
        else if ([model.menuId isEqualToString:@"125"]){//管理体系
            DDAllSearchVC *allSearch=[[DDAllSearchVC alloc]init];
            allSearch.type=@"2";
            allSearch.menuId=model.menuId;
            allSearch.placeholderText=@"请输入单位名称、产品类别";
            [self.navigationController pushViewController:allSearch animated:NO];
        }
        else if ([model.menuId isEqualToString:@"124"]){//查商标
            DDAllSearchVC *allSearch=[[DDAllSearchVC alloc]init];
            allSearch.type=@"2";
            allSearch.menuId=model.menuId;
            allSearch.placeholderText=@"请输入单位名称、注册号、商标名称";
            [self.navigationController pushViewController:allSearch animated:NO];
        }
        else if ([model.menuId isEqualToString:@"138"]){//建筑师
            DDAllSearchVC *allSearch=[[DDAllSearchVC alloc]init];
            allSearch.type=@"2";
            allSearch.menuId=model.menuId;
            allSearch.placeholderText=@"请输入建筑师姓名";
            [self.navigationController pushViewController:allSearch animated:NO];
        }
        else if ([model.menuId isEqualToString:@"139"]){//结构师
            DDAllSearchVC *allSearch=[[DDAllSearchVC alloc]init];
            allSearch.type=@"2";
            allSearch.menuId=model.menuId;
            allSearch.placeholderText=@"请输入结构师姓名";
            [self.navigationController pushViewController:allSearch animated:NO];
        }
        else if ([model.menuId isEqualToString:@"140"]){//土木工程师
            DDAllSearchVC *allSearch=[[DDAllSearchVC alloc]init];
            allSearch.type=@"2";
            allSearch.menuId=model.menuId;
            allSearch.placeholderText=@"请输入土木工程师姓名";
            [self.navigationController pushViewController:allSearch animated:NO];
        }
        else if ([model.menuId isEqualToString:@"141"]){//公用设备师
            DDAllSearchVC *allSearch=[[DDAllSearchVC alloc]init];
            allSearch.type=@"2";
            allSearch.menuId=model.menuId;
            allSearch.placeholderText=@"请输入公用设备师姓名";
            [self.navigationController pushViewController:allSearch animated:NO];
        }
        else if ([model.menuId isEqualToString:@"142"]){//电气工程师
            DDAllSearchVC *allSearch=[[DDAllSearchVC alloc]init];
            allSearch.type=@"2";
            allSearch.menuId=model.menuId;
            allSearch.placeholderText=@"请输入电气工程师姓名";
            [self.navigationController pushViewController:allSearch animated:NO];
        }
        else if ([model.menuId isEqualToString:@"143"]){//化工工程师
            DDAllSearchVC *allSearch=[[DDAllSearchVC alloc]init];
            allSearch.type=@"2";
            allSearch.menuId=model.menuId;
            allSearch.placeholderText=@"请输入化工工程师姓名";
            [self.navigationController pushViewController:allSearch animated:NO];
        }
        else if ([model.menuId isEqualToString:@"144"]){//监理工程师
            DDAllSearchVC *allSearch=[[DDAllSearchVC alloc]init];
            allSearch.type=@"2";
            allSearch.menuId=model.menuId;
            allSearch.placeholderText=@"请输入监理工程师姓名";
            [self.navigationController pushViewController:allSearch animated:NO];
        }
        else if ([model.menuId isEqualToString:@"145"]){//造价工程师
            DDAllSearchVC *allSearch=[[DDAllSearchVC alloc]init];
            allSearch.type=@"2";
            allSearch.menuId=model.menuId;
            allSearch.placeholderText=@"请输入造价工程师姓名";
            [self.navigationController pushViewController:allSearch animated:NO];
        }
        else if ([model.menuId isEqualToString:@"146"]){//消防工程师
            DDAllSearchVC *allSearch=[[DDAllSearchVC alloc]init];
            allSearch.type=@"2";
            allSearch.menuId=model.menuId;
            allSearch.placeholderText=@"请输入消防工程师姓名";
            [self.navigationController pushViewController:allSearch animated:NO];
        }
    }
}

//过滤数据源
-(void)filterDataSource{
    for (int i=1; i<_dataSource.count; i++) {
        for (DDPublicTypesModel *model1 in _dataSource[i][@"subInfo"]) {
            int num=0;
            for (DDPublicTypesModel *model2 in _dataSource[0][@"subInfo"]) {
                if ([model1.menuId isEqual:model2.menuId]) {
                    num=num+1;
                    break;
                }
            }
            if (num==0) {
                model1.type=@"2";
            }
            else{
                model1.type=@"0";
            }
        }
    }
}

#pragma mark flowLayout协议方法
//定制cell的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(Screen_Width/4, 101);
}

//定制最小行间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

//定制最小列间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

//制定补充视图组头大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(Screen_Width, 40);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(Screen_Width, 15);
}

//调上左下右偏置
//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//    return UIEdgeInsetsMake(15, 15, 15, 15);
//}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if (kind==UICollectionElementKindSectionHeader) {
        DDTypesHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"DDTypesHeaderView"forIndexPath:indexPath];
        
        header.headLab.text=_dataSource[indexPath.section][@"name"];
        
        return header;
    }
    else if (kind==UICollectionElementKindSectionFooter) {
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FOOT"forIndexPath:indexPath];
        
        header.backgroundColor=kColorBackGroundColor;
        
        return header;
    }
    return nil;
}



@end
