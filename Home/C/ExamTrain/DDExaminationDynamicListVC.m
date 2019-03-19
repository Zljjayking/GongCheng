//
//  DDExaminationDynamicListVC.m
//  GongChengDD
//
//  Created by xzx on 2018/9/20.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDExaminationDynamicListVC.h"
#import "DataLoadingView.h"//加载页面
#import "DDNoResultView.h"//无数据视图
#import "DDExamCitySelectView.h"//市的选择View
#import "DDExaminationDynamicListModel.h"//model
#import "DDExaminationDynamicListCell.h"//cell
#import "DDExaminationDynamicDetailVC.h"

@interface DDExaminationDynamicListVC ()<UITableViewDelegate,UITableViewDataSource,DDExamCitySelectViewDelegate>

{
    NSMutableArray *_dataSourceArr;
    NSString *_regionId;
    NSString *_region;
    NSString *_isCitySelected;//判断是否点开了城市选择视图
    UILabel *_label;//放城市选择文字
}
@property (nonatomic,strong) UIImageView *imgView;//放城市选择小箭头
@property (nonatomic,strong) DDExamCitySelectView *townSelectTableView;//区域筛选视图
@property (nonatomic,strong) DataLoadingView *loadingView;//加载视图
@property (nonatomic,strong) DDNoResultView *noResultView;//无数据视图
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation DDExaminationDynamicListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _regionId=@"320100";//表示南京
    _region=@"南京市";
    _isCitySelected=@"0";
    self.title=self.titleName;
    self.view.backgroundColor=kColorBackGroundColor;
    _dataSourceArr=[[NSMutableArray alloc]init];
    self.navigationItem.leftBarButtonItem=[DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
    [self createCitySelectView];
    [self createTableView];
    [self createLoadView];
    [self requestData];
}

//返回上一页
- (void)leftButtonClick{
    [_townSelectTableView hiddenActionSheet];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidDisappear:(BOOL)animated{
    if (self.navigationController==NULL) {
        [_townSelectTableView hiddenActionSheet];
    }
}

#pragma mark 创建加载视图
-(void)createLoadView{
    __weak __typeof(self) weakSelf=self;
    _noResultView=[[DDNoResultView alloc]initWithFrame:CGRectMake(0, 44+15, Screen_Width, Screen_Height-KNavigationBarHeight-44-15)];
    [self.view addSubview:_noResultView];
    
    _loadingView = [[DataLoadingView alloc] initWithController:self];
    _loadingView.loadingTitle = KLoading;
    _loadingView.failureTitle = KLoadingFailure;
    _loadingView.reloadHandle = ^(void){
        [weakSelf requestData];
    };
    [_loadingView showLoadingView];
}

#pragma mark 城市选择
-(void)createCitySelectView{
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 44)];
    bgView.backgroundColor=kColorWhite;
    [self.view addSubview:bgView];
    //地区选择按钮
    UIButton *areaSelectBtn=[[UIButton alloc]initWithFrame:CGRectMake(50, 0, Screen_Width-100, 44)];
    [areaSelectBtn setBackgroundColor:kColorWhite];
    
    _label=[[UILabel alloc]init];
    _label.text=_region;
    _label.textColor=KColorBlackTitle;
    _label.font=kFontSize30;
    [areaSelectBtn addSubview:_label];
    
    _imgView=[[UIImageView alloc]init];
    _imgView.contentMode = UIViewContentModeScaleAspectFit;
    _imgView.image=[UIImage imageNamed:@"home_search_down"];
    [areaSelectBtn addSubview:_imgView];
    [areaSelectBtn addTarget:self action:@selector(areaSelectClick) forControlEvents:UIControlEventTouchUpInside];
    CGRect leftTextFrame = [_region boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
    CGFloat leftWidth=leftTextFrame.size.width+4+15;
    if (leftWidth>=(Screen_Width-100)) {
        _label.frame=CGRectMake(20, 12+2.5, (Screen_Width-100)-4-15, 15);
        _imgView.frame=CGRectMake(CGRectGetMaxX(_label.frame)+4, 12+2.5, 15, 15);
    }
    else{
        _label.frame=CGRectMake(((Screen_Width-100)-leftWidth)/2, 12+2.5, leftWidth-4-15, 15);
        _imgView.frame=CGRectMake(CGRectGetMaxX(_label.frame)+4, 12+2.5, 15, 15);
    }
    
    [bgView addSubview:areaSelectBtn];
    
    
    
    
    
    _townSelectTableView=[[DDExamCitySelectView alloc]initWithFrame:CGRectMake(0, 39, Screen_Width, Screen_Height-KNavigationBarHeight-39)];
    __weak __typeof(self) weakSelf=self;
    _townSelectTableView.attachHeight=@"5";
    DDUserManager *manager=[DDUserManager sharedInstance];
    if (![DDUtils isEmptyString:manager.city]) {
        _townSelectTableView.type=@"1";
    }
    _townSelectTableView.hiddenBlock = ^{
        weakSelf.imgView.image=[UIImage imageNamed:@"home_search_down"];
        
        //[weakSelf.townSelectTableView hiddenActionSheet];
        [weakSelf.townSelectTableView hidden];
        
        _isCitySelected=@"0";
    };
    _townSelectTableView.delegate=self;
    [_townSelectTableView show];
}

#pragma mark 创建tableView
-(void)createTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 44+15, Screen_Width, Screen_Height-KNavigationBarHeight-44-15) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.estimatedRowHeight=44;
    _tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
}

#pragma mark 请求网络数据
- (void)requestData{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:_regionId forKey:@"regionId"];
    [params setValue:self.certType forKey:@"examCertType"];
    
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_examDynamicList params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"**********考试动态列表结果数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        __weak __typeof(self) weakSelf = self;
        if (response.isSuccess) {
            [_dataSourceArr removeAllObjects];
            [_loadingView hiddenLoadingView];
            NSDictionary *dict = responseObject[KData];
            NSArray *listArr=dict[@"records"];

            if (listArr.count!=0) {
                [_noResultView hiddenNoDataView];
                for (NSDictionary *dic in listArr) {
                    DDExaminationDynamicListModel *model = [[DDExaminationDynamicListModel alloc]initWithDictionary:dic error:nil];

                    [_dataSourceArr addObject:model];
                }

            }
            else{
                [_noResultView showNoResultViewWithTitle:@"考试动态信息" andImage:@"noResult_info"];
            }

        }
        else{

            [_loadingView failureLoadingView];
        }

        [weakSelf.tableView reloadData];
        
    }  failure:^(NSURLSessionDataTask *operation, id responseObject)  {
        [DDUtils showToastWithMessage:kRequestFailed];
        [_loadingView failureLoadingView];
    }];
}

#pragma mark tableView代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSourceArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DDExaminationDynamicListModel *model=_dataSourceArr[indexPath.row];
    
    static NSString * cellID = @"DDExaminationDynamicListCell";
    DDExaminationDynamicListCell * cell = (DDExaminationDynamicListCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
    }
    
    cell.titleLab.text=model.title;
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DDExaminationDynamicListModel *model=_dataSourceArr[indexPath.row];
    
    DDExaminationDynamicDetailVC *examinationDynamicDetail=[[DDExaminationDynamicDetailVC alloc]init];
    examinationDynamicDetail.noticeId=model.noticeId;
    [self.navigationController pushViewController:examinationDynamicDetail animated:YES];
}

#pragma mark 点击城市选择
-(void)areaSelectClick{
    if ([_isCitySelected isEqualToString:@"0"]) {
        
        _imgView.image=[UIImage imageNamed:@"home_search_up"];
        
        [_townSelectTableView noHidden];
        
        _isCitySelected=@"1";
    }
    else{
        _imgView.image=[UIImage imageNamed:@"home_search_down"];
        [_townSelectTableView hidden];
        _isCitySelected=@"0";
    }
}

#pragma mark CitySelectPickerView代理回调
-(void)actionsheetDisappear:(DDExamCitySelectView *)actionSheet andAreaInfo:(NSString *)area andRegionId:(NSString *)regionId{
    _region=area;
    _regionId=regionId;
    
    [self requestData];//重新请求数据
    
    CGRect leftTextFrame = [_region boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
    CGFloat leftWidth=leftTextFrame.size.width+4+15;
    if (leftWidth>=(Screen_Width-100)) {
        _label.frame=CGRectMake(20, 12+2.5, (Screen_Width-100)-4-15, 15);
        _imgView.frame=CGRectMake(CGRectGetMaxX(_label.frame)+4, 12+2.5, 15, 15);
    }
    else{
        _label.frame=CGRectMake(((Screen_Width-100)-leftWidth)/2, 12+2.5, leftWidth-4-15, 15);
        _imgView.frame=CGRectMake(CGRectGetMaxX(_label.frame)+4, 12+2.5, 15, 15);
    }
    
    _label.text=_region;
}




@end
