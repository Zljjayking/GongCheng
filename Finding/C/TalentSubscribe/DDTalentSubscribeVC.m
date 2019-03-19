//
//  DDTalentSubscribeVC.m
//  GongChengDD
//
//  Created by xzx on 2018/11/24.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDTalentSubscribeVC.h"
#import "DDTalentSubscribeModel.h"//model
#import "DDProvinceSelectCell.h"//cell

@interface DDTalentSubscribeVC ()<UICollectionViewDelegate,UICollectionViewDataSource>

{
    NSArray *_certStrArr;
    NSArray *_certCodeArr;
    NSArray *_dateStrArr;
    NSArray *_dateCodeArr;
    
    NSMutableArray *_dataSource1;
    NSMutableArray *_dataSource2;
    NSMutableArray *_dataSource3;
    
    NSMutableArray *_regionIds;
    NSMutableArray *_certiTypes;
    NSString *_date;
    
    UIView *_bottomView;
}
@property (nonatomic,strong) UIScrollView *scrollView;//主滑动视图
@property (nonatomic,strong) UICollectionView *regionCollection;//监控区域
@property (nonatomic,strong) UICollectionView *certiCollection;//证书类型
@property (nonatomic,strong) UICollectionView *dateCollection;//有效期

@end

@implementation DDTalentSubscribeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent=NO;
    _regionIds=[[NSMutableArray alloc]init];
    if ([self.type isEqualToString:@"1"]) {
        for (NSString *code in self.passRegionIds) {
            [_regionIds addObject:code];
        }
    }
    else{
        [_regionIds addObject:@"0"];
    }
    _certiTypes=[[NSMutableArray alloc]init];
    if ([self.type isEqualToString:@"1"]) {
        for (NSString *code in self.passCertiTypes) {
            [_certiTypes addObject:code];
        }
    }
    else{
        [_certiTypes addObject:@"0"];
    }
    if ([self.type isEqualToString:@"1"]) {
        _date=self.passDate;
    }
    else{
        _date=@"0";
    }
    
    _dataSource1=[[NSMutableArray alloc]init];
    _dataSource2=[[NSMutableArray alloc]init];
    _dataSource3=[[NSMutableArray alloc]init];
    _certStrArr=[NSArray arrayWithObjects:@"不限",@"一级建造师",@"二级建造师",@"安全员A",@"安全员B",@"安全员C",@"一级建筑师",@"二级建筑师",@"一级结构师",@"二级结构师",@"土木工程师",@"公用设备师",@"造价工程师",@"电气工程师",@"化工工程师",@"监理工程师",@"消防工程师", nil];
    _certCodeArr=[NSArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16", nil];
    for (int i=0; i<_certStrArr.count; i++) {
        DDTalentSubscribeModel *model=[[DDTalentSubscribeModel alloc]init];
        model.str=_certStrArr[i];
        model.code=_certCodeArr[i];
        [_dataSource2 addObject:model];
    }
    _dateStrArr=[NSArray arrayWithObjects:@"不限",@"三年内到期",@"二年内到期",@"一年内到期",@"半年内到期",@"三个月内到期", nil];
    _dateCodeArr=[NSArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5", nil];
    for (int i=0; i<_dateStrArr.count; i++) {
        DDTalentSubscribeModel *model=[[DDTalentSubscribeModel alloc]init];
        model.str=_dateStrArr[i];
        model.code=_dateCodeArr[i];
        [_dataSource3 addObject:model];
    }
    
    [self Dataparsing];
    self.view.backgroundColor=kColorBackGroundColor;
    self.title=@"人才订阅";
    self.navigationItem.leftBarButtonItem=[DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
//    if ([self.type isEqualToString:@"1"]) {
//        self.navigationItem.rightBarButtonItem=[DDUtils rightbuttonItemWithTitle:@"修改" target:self action:@selector(modifyClick)];
//    }
//    else{
//        self.navigationItem.rightBarButtonItem=nil;
//    }
    [self createUI];
    [self createMainUI];
}

#pragma mark 返回上一级
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 修改点击事件
//-(void)modifyClick{
//    _regionCollection.userInteractionEnabled=YES;
//    _certiCollection.userInteractionEnabled=YES;
//    _dateCollection.userInteractionEnabled=YES;
//
//    _bottomView.hidden=YES;
//    _scrollView.frame=CGRectMake(0, 61, Screen_Width, Screen_Height-KNavigationBarHeight-61);
//
//    self.navigationItem.rightBarButtonItem=[DDUtils rightbuttonItemWithTitle:@"完成" target:self action:@selector(finishClick)];
//}

#pragma mark 完成修改点击事件
-(void)finishClick{
    [self submitClickModify];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 取消点击事件
-(void)cancelClick{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"取消后您的监控记录将被全部清除" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction * actionReStart = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
        [params setValue:@"1" forKey:@"monitorType"];
        [params setValue:@"2" forKey:@"type"];
        [params setValue:[_regionIds componentsJoinedByString:@","] forKey:@"regionId"];
        [params setValue:[_certiTypes componentsJoinedByString:@","] forKey:@"projectCertType"];
        [params setValue:_date forKey:@"validityType"];
        
        MBProgressHUD * hud = [DDUtils showHUDCustom:@""];
        [[DDHttpManager sharedInstance]sendPostRequest:KHttpRequest_modifyMonitorInfo params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
            NSLog(@"***********取消订阅请求数据***************%@",responseObject);
            
            DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
            if (response.isSuccess) {
                
                hud.mode = MBProgressHUDModeCustomView;
                hud.customView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"myinfo_saveSuccess"]];
                //            hud.labelText=@"监控成功";
                hud.detailsLabelText = @"取消成功";
                
                //            //关注成功后,改变数据源,改变底部图标
                //            if ([response.data isKindOfClass:[NSDictionary class]]) {
                //                DDAttentionSuccessModel * attentionSuccessModel = [[DDAttentionSuccessModel alloc] initWithDictionary:response.data error:nil];
                //
                //                _companyInfoModel.attention = attentionSuccessModel.attentionType;
                //
                //                [self changeAttentionImageAndText];
                //            }
                //
                //            //发个通知
                //            [[NSNotificationCenter defaultCenter] postNotificationName:KAddOrCancelAttention object:nil];
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }else if (response.code == 150){//150表示在其他端已经收藏
                hud.labelText = @"你已经监控过";
                //            //关注成功后,改变数据源,改变底部图标
                //            if ([response.data isKindOfClass:[NSDictionary class]]) {
                //                DDAttentionSuccessModel * attentionSuccessModel = [[DDAttentionSuccessModel alloc] initWithDictionary:response.data error:nil];
                //
                //                _companyInfoModel.attention = attentionSuccessModel.attentionType;
                //
                //                [self changeAttentionImageAndText];
                //            }
                //
                //            //发个通知
                //            [[NSNotificationCenter defaultCenter] postNotificationName:KAddOrCancelAttention object:nil];
            }
            else{
                hud.labelText = response.message;
            }
            
            [hud hide:YES afterDelay:KHudShowTimeSecound];
        } failure:^(NSURLSessionDataTask *operation, id responseObject) {
            hud.labelText = kRequestFailed;
            [hud hide:YES afterDelay:KHudShowTimeSecound];
        }];
        
    }];
    
    [alertController addAction:actionCancel];
    [alertController addAction:actionReStart];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark 创建UI布局
-(void)createUI{
    UIView *tipBgView=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 61)];
    tipBgView.backgroundColor=kColorWhite;
    UILabel *tipLab=[[UILabel alloc]initWithFrame:CGRectMake(12, 0, Screen_Width-24, 61)];
    tipLab.text=@"批量监控人才电话公开情况，可同时监控多省份及多证书类别";
    tipLab.textColor=kColorBlack;
    tipLab.font=kFontSize28;
    tipLab.numberOfLines=2;
    [tipBgView addSubview:tipLab];
    [self.view addSubview:tipBgView];
    
    _bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, Screen_Height-KNavigationBarHeight-57.5, Screen_Width, 57.5)];
    _bottomView.backgroundColor=kColorWhite;
    if ([self.type isEqualToString:@"1"]) {
        UIButton *setBtn=[[UIButton alloc]initWithFrame:CGRectMake(12, 17.5/2, Screen_Width/2-18, 40)];
        [setBtn setBackgroundColor:KColorCompanyTransfetGray];
        setBtn.titleLabel.font=kFontSize32;
        [setBtn setTitleColor:KColorBlackTitle forState:UIControlStateNormal];
        setBtn.layer.cornerRadius=3;
        [setBtn setTitle:@"取消订阅" forState:UIControlStateNormal];
        [setBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:setBtn];
        
        UIButton *sureBtn=[[UIButton alloc]initWithFrame:CGRectMake(Screen_Width/2+6, 17.5/2, Screen_Width/2-18, 40)];
        [sureBtn setBackgroundColor:KColorFindingPeopleBlue];
        sureBtn.titleLabel.font=kFontSize32;
        [sureBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
        sureBtn.layer.cornerRadius=3;
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [sureBtn addTarget:self action:@selector(finishClick) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:sureBtn];
    }
    else{
        UIButton *setBtn=[[UIButton alloc]initWithFrame:CGRectMake(15, 17.5/2, Screen_Width-30, 40)];
        [setBtn setBackgroundColor:KColorFindingPeopleBlue];
        setBtn.titleLabel.font=kFontSize32;
        [setBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
        setBtn.layer.cornerRadius=3;
        [setBtn setTitle:@"确定" forState:UIControlStateNormal];
        [setBtn addTarget:self action:@selector(submitClickSave) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:setBtn];
    }
    
    [self.view addSubview:_bottomView];
}

#pragma mark 创建主体内容
-(void)createMainUI{
    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 61, Screen_Width, Screen_Height-KNavigationBarHeight-57.5-61)];
    _scrollView.backgroundColor=kColorBackGroundColor;
    _scrollView.showsVerticalScrollIndicator=NO;
    _scrollView.contentSize=CGSizeMake(Screen_Width, 59.5+339+59.5+295+59.5+119+15);
    [self.view addSubview:_scrollView];
    
    UIView  *bgView1=[[UIView alloc]initWithFrame:CGRectMake(0, 15, Screen_Width, 44)];
    bgView1.backgroundColor=kColorWhite;
    UILabel *lab1_1=[[UILabel alloc]initWithFrame:CGRectMake(12, 12, 70, 20)];
    lab1_1.text=@"监控区域";
    lab1_1.textColor=KColorCompanyTitleBalck;
    lab1_1.font=KfontSize32Bold;
    [bgView1 addSubview:lab1_1];
    UILabel *lab1_2=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lab1_1.frame), 12, 75, 20)];
    lab1_2.text=@"（可多选）";
    lab1_2.textColor=KColorBidApprovalingWait;
    lab1_2.font=kFontSize28;
    [bgView1 addSubview:lab1_2];
    [_scrollView addSubview:bgView1];
    
    UIView *bgView2=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(bgView1.frame)+0.5, Screen_Width, 339)];
    bgView2.backgroundColor=kColorWhite;
    UICollectionViewFlowLayout *flowLayout1=[[UICollectionViewFlowLayout alloc]init];
    _regionCollection=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width,339) collectionViewLayout:flowLayout1];
    _regionCollection.backgroundColor=kColorWhite;
    _regionCollection.delegate=self;
    _regionCollection.dataSource=self;
//    if ([self.type isEqualToString:@"1"]) {
//        _regionCollection.userInteractionEnabled=NO;
//    }
//    else{
//        _regionCollection.userInteractionEnabled=YES;
//    }
    [_regionCollection registerNib:[UINib nibWithNibName:@"DDProvinceSelectCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"DDProvinceSelectCell"];
    [bgView2 addSubview:_regionCollection];
    [_scrollView addSubview:bgView2];
    
    
    
    
    
    UIView  *bgView3=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(bgView2.frame)+15, Screen_Width, 44)];
    bgView3.backgroundColor=kColorWhite;
    UILabel *lab2_1=[[UILabel alloc]initWithFrame:CGRectMake(12, 12, 70, 20)];
    lab2_1.text=@"证书类型";
    lab2_1.textColor=KColorCompanyTitleBalck;
    lab2_1.font=KfontSize32Bold;
    [bgView3 addSubview:lab2_1];
    UILabel *lab2_2=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lab2_1.frame), 12, 75, 20)];
    lab2_2.text=@"（可多选）";
    lab2_2.textColor=KColorBidApprovalingWait;
    lab2_2.font=kFontSize28;
    [bgView3 addSubview:lab2_2];
    [_scrollView addSubview:bgView3];
    
    UIView *bgView4=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(bgView3.frame)+0.5, Screen_Width, 295)];
    bgView4.backgroundColor=kColorWhite;
    UICollectionViewFlowLayout *flowLayout2=[[UICollectionViewFlowLayout alloc]init];
    _certiCollection=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width,295) collectionViewLayout:flowLayout2];
    _certiCollection.backgroundColor=kColorWhite;
    _certiCollection.delegate=self;
    _certiCollection.dataSource=self;
//    if ([self.type isEqualToString:@"1"]) {
//        _certiCollection.userInteractionEnabled=NO;
//    }
//    else{
//        _certiCollection.userInteractionEnabled=YES;
//    }
    [_certiCollection registerNib:[UINib nibWithNibName:@"DDProvinceSelectCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"DDProvinceSelectCell"];
    [bgView4 addSubview:_certiCollection];
    [_scrollView addSubview:bgView4];
    
    
    
    
    
    UIView  *bgView5=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(bgView4.frame)+15, Screen_Width, 44)];
    bgView5.backgroundColor=kColorWhite;
    UILabel *lab3=[[UILabel alloc]initWithFrame:CGRectMake(12, 12, 70, 20)];
    lab3.text=@"有效期";
    lab3.textColor=KColorCompanyTitleBalck;
    lab3.font=KfontSize32Bold;
    [bgView5 addSubview:lab3];
    [_scrollView addSubview:bgView5];
    
    UIView *bgView6=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(bgView5.frame)+0.5, Screen_Width, 119)];
    bgView6.backgroundColor=kColorWhite;
    UICollectionViewFlowLayout *flowLayout3=[[UICollectionViewFlowLayout alloc]init];
    _dateCollection=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width,119) collectionViewLayout:flowLayout3];
    _dateCollection.backgroundColor=kColorWhite;
    _dateCollection.delegate=self;
    _dateCollection.dataSource=self;
//    if ([self.type isEqualToString:@"1"]) {
//        _dateCollection.userInteractionEnabled=NO;
//    }
//    else{
//        _dateCollection.userInteractionEnabled=YES;
//    }
    [_dateCollection registerNib:[UINib nibWithNibName:@"DDProvinceSelectCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"DDProvinceSelectCell"];
    [bgView6 addSubview:_dateCollection];
    [_scrollView addSubview:bgView6];
}

#pragma mark collectionView代理方法
//设置分区数（必须实现）
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

//设置每个分区的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView==_regionCollection) {
        return 32;
    }
    else if(collectionView==_certiCollection){
        return 17;
    }
    else{
        return 6;
    }
}

//设置返回每个item的属性必须实现）
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DDProvinceSelectCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"DDProvinceSelectCell" forIndexPath:indexPath];
    
    cell.provinceLab.font=kFontSize28;
    
    if (collectionView==_regionCollection) {
        DDTalentSubscribeModel *model=_dataSource1[indexPath.row];
        cell.provinceLab.text=model.str;
        NSString *isHave=@"0";
        for (NSString *code in _regionIds) {
            if ([model.code isEqualToString:code]) {
                isHave=@"1";
                break;
            }
            else{
                isHave=@"0";
            }
        }
        if ([isHave isEqualToString:@"1"]) {
            cell.provinceLab.textColor=kcolorCompanyTransTitleBlue;
            cell.provinceLab.backgroundColor=KColorUsedNameBg1;
        }
        else{
            cell.provinceLab.textColor=KColorGreySubTitle;
            cell.provinceLab.backgroundColor=KColorCompanyTransfetGray;
        }
    }
    else if (collectionView==_certiCollection) {
        DDTalentSubscribeModel *model=_dataSource2[indexPath.row];
        cell.provinceLab.text=model.str;
        NSString *isHave=@"0";
        for (NSString *code in _certiTypes) {
            if ([model.code isEqualToString:code]) {
                isHave=@"1";
                break;
            }
            else{
                isHave=@"0";
            }
        }
        if ([isHave isEqualToString:@"1"]) {
            cell.provinceLab.textColor=kcolorCompanyTransTitleBlue;
            cell.provinceLab.backgroundColor=KColorUsedNameBg1;
        }
        else{
            cell.provinceLab.textColor=KColorGreySubTitle;
            cell.provinceLab.backgroundColor=KColorCompanyTransfetGray;
        }
    }
    else if(collectionView==_dateCollection){
        DDTalentSubscribeModel *model=_dataSource3[indexPath.row];
        cell.provinceLab.text=model.str;
        if ([model.code isEqualToString:_date]) {
            cell.provinceLab.textColor=kcolorCompanyTransTitleBlue;
            cell.provinceLab.backgroundColor=KColorUsedNameBg1;
        }
        else{
            cell.provinceLab.textColor=KColorGreySubTitle;
            cell.provinceLab.backgroundColor=KColorCompanyTransfetGray;
        }
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView==_regionCollection) {
        if (indexPath.row==0) {
            [_regionIds removeAllObjects];
            [_regionIds addObject:@"0"];
        }
        else{
            DDTalentSubscribeModel *model=_dataSource1[indexPath.row];
            if ([_regionIds containsObject:@"0"]) {
                [_regionIds removeObject:@"0"];
                [_regionIds addObject:model.code];
            }
            else{
                NSString *isHave=@"0";
                for (NSString *code in _regionIds) {
                    if ([code isEqualToString:model.code]) {
                        isHave=@"1";
                        break;
                    }
                    else{
                        isHave=@"0";
                    }
                }
                if ([isHave isEqualToString:@"0"]) {
                    [_regionIds addObject:model.code];
                }
                else{
                    if (_regionIds.count==1) {
                        [DDUtils showToastWithMessage:@"请至少选择一个监控区域"];
                    }
                    else{
                        [_regionIds removeObject:model.code];
                    }
                }
            }
        }
        [_regionCollection reloadData];
    }
    else if(collectionView==_certiCollection){
        if (indexPath.row==0) {
            [_certiTypes removeAllObjects];
            [_certiTypes addObject:@"0"];
        }
        else{
            DDTalentSubscribeModel *model=_dataSource2[indexPath.row];
            if ([_certiTypes containsObject:@"0"]) {
                [_certiTypes removeObject:@"0"];
                [_certiTypes addObject:model.code];
            }
            else{
                NSString *isHave=@"0";
                for (NSString *code in _certiTypes) {
                    if ([code isEqualToString:model.code]) {
                        isHave=@"1";
                        break;
                    }
                    else{
                        isHave=@"0";
                    }
                }
                if ([isHave isEqualToString:@"0"]) {
                    [_certiTypes addObject:model.code];
                }
                else{
                    if (_certiTypes.count==1) {
                        [DDUtils showToastWithMessage:@"请至少选择一个证书类型"];
                    }
                    else{
                        [_certiTypes removeObject:model.code];
                    }
                }
            }
        }
        [_certiCollection reloadData];
    }
    else{
        DDTalentSubscribeModel *model=_dataSource3[indexPath.row];
        _date=model.code;
        [_dateCollection reloadData];
    }
}

#pragma mark flowLayout协议方法
//定制cell的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView==_regionCollection) {
        return CGSizeMake((Screen_Width-24-9*4)/5, 35);
    }
    else if(collectionView==_certiCollection){
        return CGSizeMake((Screen_Width-24-9*2)/3, 35);
    }
    else{
        return CGSizeMake((Screen_Width-24-9*2)/3, 35);
    }
}

//定制最小行间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 9;
}

//定制最小列间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 9;
}

////制定补充视图组头大小
//-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
//    return CGSizeMake(Screen_Width, 100);
//}

//调上左下右偏置
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(20, 12, 20, 12);
}

#pragma mark 解析json数据,获取省的数据
- (void)Dataparsing{
    NSArray *provinceList = [[NSArray alloc]init];
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"city" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSError *error;
    NSDictionary *provinceLise = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    //self.pickerDic = provinceLise;
    provinceList = provinceLise[@"region"];
    
    DDTalentSubscribeModel *model=[[DDTalentSubscribeModel alloc]init];
    model.str=@"全国";
    model.code=@"0";
    [_dataSource1 addObject:model];
    
    for (NSDictionary *dic in provinceList) {
        DDTalentSubscribeModel *model=[[DDTalentSubscribeModel alloc]init];
        model.str=dic[@"name"];
        model.code=[NSString stringWithFormat:@"%@",dic[@"regionId"]];
        [_dataSource1 addObject:model];
    }
}

#pragma mark 提交点击事件(保存)
-(void)submitClickSave{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:@"1" forKey:@"monitorType"];
    [params setValue:[_regionIds componentsJoinedByString:@","] forKey:@"regionId"];
    [params setValue:[_certiTypes componentsJoinedByString:@","] forKey:@"projectCertType"];
    [params setValue:_date forKey:@"validityType"];
    
    MBProgressHUD * hud = [DDUtils showHUDCustom:@""];
    [[DDHttpManager sharedInstance]sendPostRequest:KHttpRequest_saveMonitorInfo params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"***********添加订阅请求数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            
            hud.mode = MBProgressHUDModeCustomView;
            hud.customView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"myinfo_saveSuccess"]];
            //            hud.labelText=@"监控成功";
            hud.detailsLabelText = @"订阅成功";
            
//            //关注成功后,改变数据源,改变底部图标
//            if ([response.data isKindOfClass:[NSDictionary class]]) {
//                DDAttentionSuccessModel * attentionSuccessModel = [[DDAttentionSuccessModel alloc] initWithDictionary:response.data error:nil];
//
//                _companyInfoModel.attention = attentionSuccessModel.attentionType;
//
//                [self changeAttentionImageAndText];
//            }
//
//            //发个通知
//            [[NSNotificationCenter defaultCenter] postNotificationName:KAddOrCancelAttention object:nil];
            
            int index = (int)[[self.navigationController viewControllers]indexOfObject:self];
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(index -2)] animated:YES];
            
        }else if (response.code == 150){//150表示在其他端已经收藏
            hud.labelText = @"你已经监控过";
//            //关注成功后,改变数据源,改变底部图标
//            if ([response.data isKindOfClass:[NSDictionary class]]) {
//                DDAttentionSuccessModel * attentionSuccessModel = [[DDAttentionSuccessModel alloc] initWithDictionary:response.data error:nil];
//
//                _companyInfoModel.attention = attentionSuccessModel.attentionType;
//
//                [self changeAttentionImageAndText];
//            }
//
//            //发个通知
//            [[NSNotificationCenter defaultCenter] postNotificationName:KAddOrCancelAttention object:nil];
        }
        else{
            hud.labelText = response.message;
        }
        
        [hud hide:YES afterDelay:KHudShowTimeSecound];
    } failure:^(NSURLSessionDataTask *operation, id responseObject) {
        hud.labelText = kRequestFailed;
        [hud hide:YES afterDelay:KHudShowTimeSecound];
    }];
}

#pragma mark 提交点击事件(修改)
-(void)submitClickModify{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:@"1" forKey:@"monitorType"];
    [params setValue:@"1" forKey:@"type"];
    [params setValue:[_regionIds componentsJoinedByString:@","] forKey:@"regionId"];
    [params setValue:[_certiTypes componentsJoinedByString:@","] forKey:@"projectCertType"];
    [params setValue:_date forKey:@"validityType"];
    
    MBProgressHUD * hud = [DDUtils showHUDCustom:@""];
    [[DDHttpManager sharedInstance]sendPostRequest:KHttpRequest_modifyMonitorInfo params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"***********修改订阅请求数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            
            hud.mode = MBProgressHUDModeCustomView;
            hud.customView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"myinfo_saveSuccess"]];
            //            hud.labelText=@"监控成功";
            hud.detailsLabelText = @"修改成功";
            
            //            //关注成功后,改变数据源,改变底部图标
            //            if ([response.data isKindOfClass:[NSDictionary class]]) {
            //                DDAttentionSuccessModel * attentionSuccessModel = [[DDAttentionSuccessModel alloc] initWithDictionary:response.data error:nil];
            //
            //                _companyInfoModel.attention = attentionSuccessModel.attentionType;
            //
            //                [self changeAttentionImageAndText];
            //            }
            //
            //            //发个通知
            //            [[NSNotificationCenter defaultCenter] postNotificationName:KAddOrCancelAttention object:nil];
        }else if (response.code == 150){//150表示在其他端已经收藏
            hud.labelText = @"你已经监控过";
            //            //关注成功后,改变数据源,改变底部图标
            //            if ([response.data isKindOfClass:[NSDictionary class]]) {
            //                DDAttentionSuccessModel * attentionSuccessModel = [[DDAttentionSuccessModel alloc] initWithDictionary:response.data error:nil];
            //
            //                _companyInfoModel.attention = attentionSuccessModel.attentionType;
            //
            //                [self changeAttentionImageAndText];
            //            }
            //
            //            //发个通知
            //            [[NSNotificationCenter defaultCenter] postNotificationName:KAddOrCancelAttention object:nil];
        }
        else{
            hud.labelText = response.message;
        }
        
        [hud hide:YES afterDelay:KHudShowTimeSecound];
    } failure:^(NSURLSessionDataTask *operation, id responseObject) {
        hud.labelText = kRequestFailed;
        [hud hide:YES afterDelay:KHudShowTimeSecound];
    }];
}



@end
