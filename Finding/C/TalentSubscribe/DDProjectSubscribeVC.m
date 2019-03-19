//
//  DDProjectSubscribeVC.m
//  GongChengDD
//
//  Created by xzx on 2018/11/26.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDProjectSubscribeVC.h"
#import "DDMajorSelectModel.h"//工程类别数据model
#import "DDTalentSubscribeModel.h"//model
#import "DDProvinceSelectCell.h"//cell
#import "DDNewProvinceSelectCell.h"//新cell
#import "DDSubsribeRegionSelectVC.h"//监控区域选择页面
#import "DDNavigationUtil.h"
@interface DDProjectSubscribeVC ()<UICollectionViewDelegate,UICollectionViewDataSource>

{
    NSMutableArray *_dataSource1;
    NSMutableArray *_dataSource2;
    
    NSMutableArray *_projectTypes;
    
    UIView *_bgView1;
    UIView *_bgView2;
    UIView *_bgView3;
    UIView *_bgView4;
    
    UIView *_bottomView;
    UIButton *_selectBtn;
    
//    BOOL _isHidden;
}
@property (nonatomic,strong) UIScrollView *scrollView;//主滑动视图
@property (nonatomic,strong) UICollectionView *regionCollection;//监控区域
@property (nonatomic,strong) UICollectionView *typeCollection;//证书类型

@end

@implementation DDProjectSubscribeVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    _isHidden = YES;
    self.navigationController.navigationBar.translucent=NO;
    _dataSource1=[[NSMutableArray alloc]init];
    _dataSource2=[[NSMutableArray alloc]init];
    [DDNavigationUtil setNavigationBottomLineNomalColor:self.navigationController];
    if ([self.type isEqualToString:@"1"]) {
        for (int i=0;i<self.passRegionIds.count;i++) {
            DDTalentSubscribeModel *model=[[DDTalentSubscribeModel alloc]init];
            model.str=self.passRegionStrs[i];
            model.code=self.passRegionIds[i];
            [_dataSource1 addObject:model];
        }
    }
    else{
        DDTalentSubscribeModel *model=[[DDTalentSubscribeModel alloc]init];
        model.str=@"全国";
        model.code=@"0";
        [_dataSource1 addObject:model];
    }
    
    _projectTypes=[[NSMutableArray alloc]init];
    if ([self.type isEqualToString:@"1"]) {
        for (NSString *code in self.passProjectTypes) {
            [_projectTypes addObject:code];
        }
    }
    else{
        [_projectTypes addObject:@"0"];
    }
    
    [self requestProjectType];
    
    self.view.backgroundColor=kColorBackGroundColor;
    if ([self.isCallBidding isEqualToString:@"1"]) {
        self.title=@"招标监控";
    }
    else{
        self.title=@"中标监控";
    }
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
//    _isHidden = NO;
//    [_regionCollection reloadData];
//    _regionCollection.userInteractionEnabled=YES;
//    _typeCollection.userInteractionEnabled=YES;
//    _selectBtn.userInteractionEnabled=YES;
//
//    _bottomView.hidden=YES;
//    _scrollView.frame=CGRectMake(0, 61, Screen_Width, Screen_Height-KNavigationBarHeight-61);
//
//    self.navigationItem.rightBarButtonItem=[DDUtils rightbuttonItemWithTitle:@"完成" target:self action:@selector(finishClick)];
//}

#pragma mark 完成修改点击事件
-(void)finishClick{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    if ([self.isCallBidding isEqualToString:@"1"]) {
        [params setValue:@"3" forKey:@"monitorType"];
    }
    else{
        [params setValue:@"2" forKey:@"monitorType"];
    }
    [params setValue:@"1" forKey:@"type"];
    NSMutableArray *regionIds=[[NSMutableArray alloc]init];
    for (DDTalentSubscribeModel *model in _dataSource1) {
        [regionIds addObject:model.code];
    }
    [params setValue:[regionIds componentsJoinedByString:@","] forKey:@"regionId"];
    [params setValue:[_projectTypes componentsJoinedByString:@","] forKey:@"projectCertType"];
    
    MBProgressHUD * hud = [DDUtils showHUDCustom:@""];
    [[DDHttpManager sharedInstance]sendPostRequest:KHttpRequest_modifyMonitorInfo params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"***********修改监控请求数据***************%@",responseObject);
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            hud.mode = MBProgressHUDModeCustomView;
            hud.customView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"myinfo_saveSuccess"]];
            hud.detailsLabelText = @"监控修改成功";
        }else if (response.code == 150){//150表示在其他端已经收藏
            hud.labelText = @"你已经监控过";
        }
        else{
            hud.labelText = response.message;
        }
        [hud hide:YES afterDelay:KHudShowTimeSecound];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask *operation, id responseObject) {
        hud.labelText = kRequestFailed;
        [hud hide:YES afterDelay:KHudShowTimeSecound];
    }];
    
}

#pragma mark 取消点击事件
-(void)cancelClick{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"取消后您的监控记录将被全部清除" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction * actionReStart = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
        if ([self.isCallBidding isEqualToString:@"1"]) {
            [params setValue:@"3" forKey:@"monitorType"];
        }
        else{
            [params setValue:@"2" forKey:@"monitorType"];
        }
        [params setValue:@"2" forKey:@"type"];
        NSMutableArray *regionIds=[[NSMutableArray alloc]init];
        for (DDTalentSubscribeModel *model in _dataSource1) {
            [regionIds addObject:model.code];
        }
        [params setValue:[regionIds componentsJoinedByString:@","] forKey:@"regionId"];
        [params setValue:[_projectTypes componentsJoinedByString:@","] forKey:@"projectCertType"];
        
        MBProgressHUD * hud = [DDUtils showHUDCustom:@""];
        [[DDHttpManager sharedInstance]sendPostRequest:KHttpRequest_modifyMonitorInfo params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
            NSLog(@"***********取消监控请求数据***************%@",responseObject);
            
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

#pragma mark 调接口获取工程类别数据
-(void)requestProjectType{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:@"410000" forKey:@"certLevl"];
    
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_builderMajorList params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"***********工程类别请求数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {//请求成功
            [_dataSource2 removeAllObjects];
            NSArray *listArr= responseObject[KData];
            
            //手动增加"全部"模块
            DDTalentSubscribeModel *model=[[DDTalentSubscribeModel alloc]init];
            model.str=@"全部";
            model.code=@"0";
            [_dataSource2 addObject:model];
            
            for (NSDictionary *dic in listArr) {
                DDMajorSelectModel *mod=[[DDMajorSelectModel alloc]initWithDictionary:dic error:nil];
                DDTalentSubscribeModel *model=[[DDTalentSubscribeModel alloc]init];
                model.str=mod.name;
                model.code=mod.cert_type_id;
                [_dataSource2 addObject:model];
            }
            
            [_typeCollection reloadData];
        }
        else{//显示异常
            [DDUtils showToastWithMessage:response.message];
        }
        
        
    } failure:^(NSURLSessionDataTask *operation, id responseObject) {
        [DDUtils showToastWithMessage:kRequestFailed];
    }];
}

#pragma mark 创建UI布局
-(void)createUI{
    UIView *tipBgView=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 61)];
    tipBgView.backgroundColor=kColorWhite;
    
//    UILabel *lineL=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 0.5)];
//    lineL.backgroundColor = kColorNavBottomLineGray;
//    [tipBgView addSubview:lineL];
    
    UILabel *tipLab=[[UILabel alloc]initWithFrame:CGRectMake(12, 0, Screen_Width-24, 60)];
    if ([self.isCallBidding isEqualToString:@"1"]) {
        tipLab.text=@"平台覆盖全国所有地区和全部工程类别招标信息，可同时监控多区域及多类别";
    }
    else{
        tipLab.text=@"平台覆盖全国所有地区和全部工程类别中标信息，可同时监控多区域及多类别";
    }
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
        [setBtn setTitle:@"取消监控" forState:UIControlStateNormal];
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
        UIButton *setBtn=[[UIButton alloc]initWithFrame:CGRectMake(12, 17.5/2, Screen_Width-24, 40)];
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
    _scrollView.contentSize=CGSizeMake(Screen_Width, 59.5+75+59.5+383+15);
    [self.view addSubview:_scrollView];
    
    _bgView1=[[UIView alloc]initWithFrame:CGRectMake(0, 15, Screen_Width, 44)];
    _bgView1.backgroundColor=kColorWhite;
    UILabel *lab1_1=[[UILabel alloc]initWithFrame:CGRectMake(12, 12, 70, 20)];
    lab1_1.text=@"监控区域";
    lab1_1.textColor=KColorCompanyTitleBalck;
    lab1_1.font=KfontSize32Bold;
    [_bgView1 addSubview:lab1_1];
    UILabel *lab1_2=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lab1_1.frame), 12, 75, 20)];
    lab1_2.text=@"（可多选）";
    lab1_2.textColor=KColorBidApprovalingWait;
    lab1_2.font=kFontSize28;
    [_bgView1 addSubview:lab1_2];
    UIImageView *arrowImg=[[UIImageView alloc]initWithFrame:CGRectMake(Screen_Width-12-15, 14.5, 10, 15)];
    arrowImg.image=[UIImage imageNamed:@"work_arrow_right"];
    [_bgView1 addSubview:arrowImg];
    UILabel *selectLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(arrowImg.frame)-3-35, 14.5, 35, 15)];
    selectLab.text=@"选择";
    selectLab.textColor=KColorBidApprovalingWait;
    selectLab.font=kFontSize30;
    [_bgView1 addSubview:selectLab];
    _selectBtn=[[UIButton alloc]initWithFrame:CGRectMake(Screen_Width-12-10-3-40, 2, 40+3+10, 40)];
    [_selectBtn addTarget:self action:@selector(regionSelectClick) forControlEvents:UIControlEventTouchUpInside];
//    if ([self.type isEqualToString:@"1"]) {
//        _selectBtn.userInteractionEnabled=NO;
//    }
//    else{
//        _selectBtn.userInteractionEnabled=YES;
//    }
    [_bgView1 addSubview:_selectBtn];
    [_scrollView addSubview:_bgView1];
    
    _bgView2=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_bgView1.frame)+0.5, Screen_Width, 75)];
    _bgView2.backgroundColor=kColorWhite;
    UICollectionViewFlowLayout *flowLayout1=[[UICollectionViewFlowLayout alloc]init];
    _regionCollection=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width,75) collectionViewLayout:flowLayout1];
    _regionCollection.backgroundColor=kColorWhite;
    _regionCollection.delegate=self;
    _regionCollection.dataSource=self;
//    if ([self.type isEqualToString:@"1"]) {
//        _regionCollection.userInteractionEnabled=NO;
//    }
//    else{
//        _regionCollection.userInteractionEnabled=YES;
//    }
    [_regionCollection registerClass:[DDNewProvinceSelectCell class] forCellWithReuseIdentifier:@"DDNewProvinceSelectCell"];
    [_bgView2 addSubview:_regionCollection];
    [_scrollView addSubview:_bgView2];
    
    NSInteger lines=0;
    lines=_dataSource1.count/4;
    if (_dataSource1.count%4!=0 ) {
        lines=lines+1;
    }
    _scrollView.contentSize=CGSizeMake(Screen_Width, 59.5+(lines*(35+9)+(20+20-9))+59.5+383+15);
    _regionCollection.frame=CGRectMake(0, 0, Screen_Width,(lines*(35+9)+(20+20-9)));
    _bgView2.frame=CGRectMake(0, CGRectGetMaxY(_bgView1.frame)+0.5, Screen_Width, _regionCollection.frame.size.height);
    
    
    _bgView3=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_bgView2.frame)+15, Screen_Width, 44)];
    _bgView3.backgroundColor=kColorWhite;
    UILabel *lab2_1=[[UILabel alloc]initWithFrame:CGRectMake(12, 12, 70, 20)];
    lab2_1.text=@"工程类别";
    lab2_1.textColor=KColorCompanyTitleBalck;
    lab2_1.font=KfontSize32Bold;
    [_bgView3 addSubview:lab2_1];
    UILabel *lab2_2=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lab2_1.frame), 12, 75, 20)];
    lab2_2.text=@"（可多选）";
    lab2_2.textColor=KColorBidApprovalingWait;
    lab2_2.font=kFontSize28;
    [_bgView3 addSubview:lab2_2];
    [_scrollView addSubview:_bgView3];
    
    _bgView4=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_bgView3.frame)+0.5, Screen_Width, 383)];
    _bgView4.backgroundColor=kColorWhite;
    UICollectionViewFlowLayout *flowLayout2=[[UICollectionViewFlowLayout alloc]init];
    _typeCollection=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width,383) collectionViewLayout:flowLayout2];
    _typeCollection.backgroundColor=kColorWhite;
    _typeCollection.delegate=self;
    _typeCollection.dataSource=self;
//    if ([self.type isEqualToString:@"1"]) {
//        _typeCollection.userInteractionEnabled=NO;
//    }
//    else{
//        _typeCollection.userInteractionEnabled=YES;
//    }
    [_typeCollection registerNib:[UINib nibWithNibName:@"DDProvinceSelectCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"DDProvinceSelectCell"];
    [_bgView4 addSubview:_typeCollection];
    [_scrollView addSubview:_bgView4];
}

#pragma mark collectionView代理方法
//设置分区数（必须实现）
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

//设置每个分区的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView==_regionCollection) {
        return _dataSource1.count;
    }
    else{
        return _dataSource2.count;
    }
}

//设置返回每个item的属性必须实现）
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView==_regionCollection) {
        DDNewProvinceSelectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DDNewProvinceSelectCell" forIndexPath:indexPath];
        DDTalentSubscribeModel *model=_dataSource1[indexPath.row];
        cell.provinceLab.text=model.str;
//        if(_isHidden == YES){
//            cell.closeImgV.hidden = YES;
//            [cell.provinceLab mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.right.equalTo(cell.contentView).offset(WidthByiPhone6(-5));
//            }];
//        }else{
            cell.closeImgV.hidden = NO;
            [cell.provinceLab mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cell.contentView).offset(WidthByiPhone6(-20));
            }];
//        }
        return cell;
    }
    else if (collectionView==_typeCollection) {
        DDProvinceSelectCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"DDProvinceSelectCell" forIndexPath:indexPath];
        cell.provinceLab.font=kFontSize28;
        DDTalentSubscribeModel *model=_dataSource2[indexPath.row];
        cell.provinceLab.text=model.str;
        NSString *isHave=@"0";
        for (NSString *code in _projectTypes) {
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
         return cell;
    }else{
        return nil;
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView==_regionCollection) {
        if(_dataSource1.count==1){
            [DDUtils showToastWithMessage:@"请至少选择一个监控区域"];
            return;
        }
        DDTalentSubscribeModel *model=_dataSource1[indexPath.row];
        if (![model.code isEqualToString:@"0"]) {
            [_dataSource1 removeObject:model];
        }
        //计算行数
        NSInteger lines=0;
        lines=_dataSource1.count/4;
        if (_dataSource1.count%4!=0 ) {
            lines=lines+1;
        }
        _scrollView.contentSize=CGSizeMake(Screen_Width, 59.5+(lines*(35+9)+(20+20-9))+59.5+383+15);
        _bgView2.frame=CGRectMake(0, CGRectGetMaxY(_bgView1.frame)+0.5, Screen_Width, (lines*(35+9)+(20+20-9)));
        _bgView3.frame=CGRectMake(0, CGRectGetMaxY(_bgView2.frame)+15, Screen_Width, 44);
        _bgView4.frame=CGRectMake(0, CGRectGetMaxY(_bgView3.frame)+0.5, Screen_Width, 383);
        _regionCollection.frame=CGRectMake(0, 0, Screen_Width,(lines*(35+9)+(20+20-9)));
        [_regionCollection reloadData];
    }
    else if(collectionView==_typeCollection){
        if (indexPath.row==0) {
            [_projectTypes removeAllObjects];
            [_projectTypes addObject:@"0"];
            
//            [_dataSource1 removeAllObjects];
//            DDTalentSubscribeModel *model=[[DDTalentSubscribeModel alloc]init];
//            model.str=@"全国";
//            model.code=@"0";
//            [_dataSource1 addObject:model];
        }
        else{
            DDTalentSubscribeModel *model=_dataSource2[indexPath.row];
            if ([_projectTypes containsObject:@"0"]) {
                [_projectTypes removeObject:@"0"];
                [_projectTypes addObject:model.code];
            }
            else{
                NSString *isHave=@"0";
                for (NSString *code in _projectTypes) {
                    if ([code isEqualToString:model.code]) {
                        isHave=@"1";
                        break;
                    }
                    else{
                        isHave=@"0";
                    }
                }
                if ([isHave isEqualToString:@"0"]) {
                    [_projectTypes addObject:model.code];
                }
                else{
                    if (_projectTypes.count==1) {
                        [DDUtils showToastWithMessage:@"请至少选择一个工程类别"];
                    }
                    else{
                        [_projectTypes removeObject:model.code];
                    }
                }
            }
        }
        [_typeCollection reloadData];
    }
}

#pragma mark flowLayout协议方法
//定制cell的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView==_regionCollection) {
        return CGSizeMake((Screen_Width-24-9*3)/4, 35);
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

//调上左下右偏置
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(20, 12, 20, 12);
}

#pragma mark 提交点击事件(保存)
-(void)submitClickSave{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    if ([self.isCallBidding isEqualToString:@"1"]) {
        [params setValue:@"3" forKey:@"monitorType"];
    }
    else{
        [params setValue:@"2" forKey:@"monitorType"];
    }
    NSMutableArray *regionIds=[[NSMutableArray alloc]init];
    for (DDTalentSubscribeModel *model in _dataSource1) {
        [regionIds addObject:model.code];
    }
    [params setValue:[regionIds componentsJoinedByString:@","] forKey:@"regionId"];
    [params setValue:[_projectTypes componentsJoinedByString:@","] forKey:@"projectCertType"];
    
    MBProgressHUD * hud = [DDUtils showHUDCustom:@""];
    [[DDHttpManager sharedInstance]sendPostRequest:KHttpRequest_saveMonitorInfo params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"***********添加监控请求数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            
            hud.mode = MBProgressHUDModeCustomView;
            hud.customView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"myinfo_saveSuccess"]];
            hud.detailsLabelText = @"监控成功";
            
            int index = (int)[[self.navigationController viewControllers]indexOfObject:self];
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(index -2)] animated:YES];
            
        }else if (response.code == 150){//150表示在其他端已经收藏
            hud.labelText = @"你已经监控过";
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

#pragma mark 监控区域的选择
-(void)regionSelectClick{
//    if (_isHidden == YES) {
//         _isHidden = NO;
//    }
    DDSubsribeRegionSelectVC *regionSelect=[[DDSubsribeRegionSelectVC alloc]init];
    regionSelect.regionSelectBlock = ^(NSString * _Nonnull regionStr, NSString * _Nonnull regionId) {
        if ([regionId isEqualToString:@"0"]) {//表明选择了全国
            [_dataSource1 removeAllObjects];
            DDTalentSubscribeModel *model=[[DDTalentSubscribeModel alloc]init];
            model.str=@"全国";
            model.code=@"0";
            [_dataSource1 addObject:model];
        }
        else{
            //判断是否有包含全国的
            NSString *isAllCountry=@"0";
            for (DDTalentSubscribeModel *model in _dataSource1) {
                if ([model.code isEqualToString:@"0"]) {
                    isAllCountry=@"1";
                    break;
                }
                else{
                    isAllCountry=@"0";
                }
            }
            if ([isAllCountry isEqualToString:@"1"]) {
                [_dataSource1 removeAllObjects];
                DDTalentSubscribeModel *model=[[DDTalentSubscribeModel alloc]init];
                model.str=regionStr;
                model.code=regionId;
                [_dataSource1 addObject:model];
            }
            else{
                //判断是否有相同的
                NSString *isSame=@"0";
                for (DDTalentSubscribeModel *model in _dataSource1) {
                    if ([model.code isEqualToString:regionId]) {
                        isSame=@"1";
                        break;
                    }
                    else{
                        isSame=@"0";
                    }
                }
                if ([isSame isEqualToString:@"0"]) {
                    DDTalentSubscribeModel *model=[[DDTalentSubscribeModel alloc]init];
                    model.str=regionStr;
                    model.code=regionId;
                    [_dataSource1 addObject:model];
                }
                else{
                    [DDUtils showToastWithMessage:@"已添加过该城市"];
                }
            }
        }
        
        //计算行数
        NSInteger lines=0;
        lines=_dataSource1.count/4;
        if (_dataSource1.count%4!=0 ) {
            lines=lines+1;
        }
        _scrollView.contentSize=CGSizeMake(Screen_Width, 59.5+(lines*(35+9)+(20+20-9))+59.5+383+15);
        _bgView2.frame=CGRectMake(0, CGRectGetMaxY(_bgView1.frame)+0.5, Screen_Width, (lines*(35+9)+(20+20-9)));
        _bgView3.frame=CGRectMake(0, CGRectGetMaxY(_bgView2.frame)+15, Screen_Width, 44);
        _bgView4.frame=CGRectMake(0, CGRectGetMaxY(_bgView3.frame)+0.5, Screen_Width, 383);
        _regionCollection.frame=CGRectMake(0, 0, Screen_Width,(lines*(35+9)+(20+20-9)));
        [_regionCollection reloadData];
    };
    [self.navigationController pushViewController:regionSelect animated:YES];
}

@end
