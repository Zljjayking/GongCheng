//
//  DDBuildersAndAgencyVC.m
//  GongChengDD
//
//  Created by xzx on 2018/6/28.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDBuildersAndAgencyVC.h"
#import "DDBuilderMoreTrain2Cell.h"//cell
#import "DDBuildersPayEnsureVC.h"//确认订单页面
#import "UIView+WhenTappedBlocks.h"
#import "DDActionSheetView.h"
#import "DDNavigationManager.h"
@interface DDBuildersAndAgencyVC ()<UITableViewDelegate,UITableViewDataSource,DDActionSheetViewDelegate>

{
    UIView *_titleView;
    CGFloat addressLHeight;
    CGFloat agencyLHeight;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UILabel *priceL;
@property (nonatomic,strong) UILabel *selectTitle;
@property (nonatomic,strong) UIButton *leftBtn;
@property (nonatomic,strong) UIButton *rightBtn;
@property (nonatomic,strong) UILabel *companyL;
@property (nonatomic,strong) UIImageView *addressImgV;
@property (nonatomic,strong) UILabel *addressL;
@property (nonatomic,strong) UIView *greyV1;
@property (nonatomic,strong) UIView *greyV2;

@property (nonatomic,strong) UIButton *commitBtn;
/// 开始点
@property (nonatomic, assign) CLLocationCoordinate2D startCoordinate;
/// 结束点
@property (nonatomic, assign) CLLocationCoordinate2D endCoordinate;
/// 导航软件
@property (nonatomic, strong) NSMutableArray *mapApps;
@end

@implementation DDBuildersAndAgencyVC

-(void)viewWillDisappear:(BOOL)animated{
    [_titleView removeFromSuperview];
    //还原导航底部线条颜色
    //[DDNavigationUtil setNavigationBottomLineNomalColor:self.navigationController];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar addSubview:_titleView];
    //[self.navigationController.navigationBar addSubview:_titleView];
    //导航底部线条设为透明
    //[DDNavigationUtil setNavigationBottomLineClearColor:self.navigationController];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self editNavItem];
    [self createBottomBtns];
    [self createTableView];
}

-(void)leftAction:(UIButton *)sender{
    if (sender.selected==YES) {
        return;
    }
    _priceL.text = [NSString stringWithFormat:@"¥ %d",[self.majorPrice integerValue]];
    sender.selected = YES;
    _rightBtn.selected = NO;
    _commitBtn.userInteractionEnabled = YES;
    [_commitBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
    [_commitBtn setBackgroundColor:kColorBlue];
}

-(void)rightAction:(UIButton *)sender{
    if (sender.selected==YES) {
        return;
    }
    _priceL.text = [NSString stringWithFormat:@"¥ %d",[self.price integerValue]];
    sender.selected = YES;
    _leftBtn.selected = NO;
    _commitBtn.userInteractionEnabled = YES;
    [_commitBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
    [_commitBtn setBackgroundColor:kColorBlue];
}

-(void)editNavItem{
    self.view.backgroundColor=kColorBackGroundColor;
    _titleView=[[UIView alloc]initWithFrame:CGRectMake(70, 4.5, Screen_Width-140, 35)];
    
    UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, Screen_Width-140, 20)];
    label1.text=@"二级建造师继续教育";
    label1.textColor=KColorCompanyTitleBalck;
    label1.font=kFontSize36Bold;
    label1.textAlignment=NSTextAlignmentCenter;
    [_titleView addSubview:label1];
    
    UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(0, 20, Screen_Width-140, 15)];
    label2.text=self.agencyName;
    label2.textColor=KColorGreySubTitle;
    label2.font=kFontSize24;
    label2.textAlignment=NSTextAlignmentCenter;
    [_titleView addSubview:label2];
    
    [self.navigationController.navigationBar addSubview:_titleView];
    self.navigationItem.leftBarButtonItem=[DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
}

//返回上一页
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

//创建底部四个按钮
-(void)createBottomBtns{

   CGFloat  distanceToTop =  Screen_Height-KNavigationBarHeight-KTabbarAndHomeIndicatorHeight;
    
    UIView *leftView=[[UIView alloc]initWithFrame:CGRectMake(0, distanceToTop, Screen_Width-130, KTabbarHeight)];
    leftView.backgroundColor=kColorWhite;
    
    CGRect textFrame1= [@"考试培训费" boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize28} context:nil];
    UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(WidthByiPhone6(12), 0, textFrame1.size.width, KTabbarHeight)];
    label1.text=@"考试培训费";
    label1.textColor=kColorGrey;
    label1.font=kFontSize28;
    [leftView addSubview:label1];
    
    _priceL = [UILabel labelWithFont:KFontSize38Bold textColor:kColorBlue textAlignment:NSTextAlignmentLeft numberOfLines:1];
    _priceL.text = @"¥ 0";
    _priceL.frame = CGRectMake(WidthByiPhone6(20)+textFrame1.size.width, 0, Screen_Width-WidthByiPhone6(160)-textFrame1.size.width, KTabbarHeight);
    [leftView addSubview:_priceL];
    [self.view addSubview:leftView];
    
    _commitBtn=[[UIButton alloc]initWithFrame:CGRectMake(Screen_Width-WidthByiPhone6(130), distanceToTop, WidthByiPhone6(130), KTabbarHeight)];
    [_commitBtn setTitle:@"提交报名" forState:UIControlStateNormal];
    [_commitBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
    [_commitBtn setBackgroundColor:KColorBidApprovalingWait];
    _commitBtn.userInteractionEnabled = NO;
    _commitBtn.titleLabel.font=kFontSize32;
    [_commitBtn addTarget:self action:@selector(sendAccountClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_commitBtn];
}

//创建tableView
-(void)createTableView{

     _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-KNavigationBarHeight-KTabbarAndHomeIndicatorHeight) style:UITableViewStyleGrouped];
    
    [self.view addSubview:_tableView];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.showsVerticalScrollIndicator=YES;
    _tableView.estimatedRowHeight=44;
}

#pragma mark tableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellID = @"DDBuilderMoreTrain2Cell";
    DDBuilderMoreTrain2Cell * cell = (DDBuilderMoreTrain2Cell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
    }
    
    if ([self.formal isEqualToString:@"0"]) {//临时
        cell.tempLab.hidden=NO;
        cell.tempLab.textColor=KColorBlackSecondTitle;
        cell.tempLab.layer.borderColor=KColorBlackSecondTitle.CGColor;
    }
    else{
        cell.tempLab.hidden=YES;
    }
    
    cell.nameLab.text=self.peopleName;
    cell.nameLab.textColor=KColorBlackTitle;
    cell.numberLab1.text=@"注册编号:";
    cell.telBtn.hidden=YES;
    
    cell.telLab.hidden=YES;
    
    cell.majorLab1.textColor=KColorGreySubTitle;
    
    cell.majorLab2.text=self.majorName;
    cell.majorLab2.textColor=KColorBlackSubTitle;
    
    cell.numberLab1.textColor=KColorGreySubTitle;
    
    cell.numberLab2.text=self.certiNo;
    cell.numberLab2.textColor=KColorBlackSubTitle;
    
    cell.haveBLab1.textColor=KColorGreySubTitle;
    
    if ([self.haveB isEqualToString:@"0"]) {
        cell.haveBLab2.text=@"无";
    }
    else{
        cell.haveBLab2.text=@"有";
    }
    cell.haveBLab2.textColor=KColorBlackSubTitle;
    
    cell.timeLab1.textColor=KColorGreySubTitle;
    
    cell.timeLab2.text=self.endTime;
    cell.timeLab2.textColor = kColorBlue;
    
    NSString *resultStr = [DDUtils newCompareTimeSpaceIn90:self.endTime];
    if ([resultStr isEqualToString:@"2"]) {
        cell.timeLab2.textColor=kColorBlue;
    }else if ([resultStr isEqualToString:@"1"]){
        cell.timeLab2.textColor=KColorTextOrange;
    } else{
        cell.timeLab2.textColor=kColorRed;
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   return 155;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, WidthByiPhone6(140)+addressLHeight+agencyLHeight)];
    footView.backgroundColor = kColorWhite;
    [footView addSubview:self.greyV1];
    [footView addSubview:self.selectTitle];
    [footView addSubview:self.rightBtn];
    [footView addSubview:self.leftBtn];
    [footView addSubview:self.greyV2];
    [footView addSubview:self.companyL];
    [footView addSubview:self.addressL];
    [footView addSubview:self.addressImgV];
    [self.greyV1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(footView);
        make.height.mas_equalTo(WidthByiPhone6(15));
    }];
    [self.selectTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footView).offset(WidthByiPhone6(12));
        make.top.equalTo(_greyV1.mas_bottom).offset(WidthByiPhone6(20));
    }];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_selectTitle);
        make.right.equalTo(_greyV1);
        make.width.mas_equalTo(WidthByiPhone6(75));
    }];
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_selectTitle);
        make.right.equalTo(_rightBtn.mas_left).offset(WidthByiPhone6(-12));
        make.width.mas_equalTo(WidthByiPhone6(75));
    }];
    [self.greyV2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(footView);
        make.top.equalTo(_selectTitle.mas_bottom).offset(20);
        make.height.mas_equalTo(WidthByiPhone6(15));
    }];
    [self.companyL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_selectTitle);
        make.right.equalTo(footView).offset(WidthByiPhone6(-12));
        make.top.equalTo(_greyV2.mas_bottom).offset(WidthByiPhone6(20));
    }];
    [self.addressL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_companyL.mas_bottom).offset(WidthByiPhone6(15));
        make.right.equalTo(footView).offset(WidthByiPhone6(-12));
        make.width.mas_equalTo(Screen_Width-WidthByiPhone6(44));
    }];
    [self.addressImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_addressL);
        make.left.equalTo(_companyL);
        make.width.height.mas_equalTo(WidthByiPhone6(15));
    }];
    _companyL.text = self.agencyName;
    _addressL.text = self.address;
    [_addressL whenTapped:^{
        DDActionSheetView *sheetView = [[DDActionSheetView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
        self.mapApps = [NSMutableArray array];
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://map/"]]){
            [self.mapApps addObject:charBaiDuMapNav];
        }
        
        if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
            
            [self.mapApps addObject:charGaoDeMapNav];
        }
        
        [self.mapApps addObject:charAppleMapNav];
        
        [sheetView setTitle:self.mapApps cancelTitle:KMainCancel];
        sheetView.delegate = self;
        [sheetView show];
    }];
    return footView;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return WidthByiPhone6(15);
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    addressLHeight = [DDUtils  heightForText:self.address withTextWidth:Screen_Width-WidthByiPhone6(44) withFont:kFontSize28];
    agencyLHeight = [DDUtils  heightForText:self.agencyName withTextWidth:Screen_Width-WidthByiPhone6(24) withFont:kFontSize34];
    return WidthByiPhone6(140)+addressLHeight+agencyLHeight;
}


#pragma mark -- DDActionSheetViewDelegate
-(void)actionsheetSelectButton:(DDActionSheetView *)actionSheet buttonIndex:(NSInteger)index{
    DDNavigationManager * navManger = [DDNavigationManager sharedInstance];
    navManger.endName = self.address;
    NSString *mapString = self.mapApps[index - 1];
    if ([mapString isEqualToString:charAppleMapNav]) {
        [navManger openAppleMapNavigation];
        
    }else if ([mapString isEqualToString:charBaiDuMapNav]){
        [navManger openBaiDuMapNavigation];
        
    }else if ([mapString isEqualToString:charGaoDeMapNav]){
        [navManger openGaoDeMapNavigation];
    }
}

#pragma mark 提交订单点击事件
-(void)sendAccountClick{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:self.companyId forKey:@"enterpriseId"];
    [params setValue:self.companyName forKey:@"enterpriseName"];
    [params setValue:_peopleName forKey:@"name"];
    [params setValue:_certiNo forKey:@"certNo"];
    [params setValue:_certiTypeId forKey:@"certTypeId"];
    [params setValue:_haveB forKey:@"hasBCertificate"];
    [params setValue:_endTime forKey:@"validityPeriodEnd"];
    [params setValue:_tel forKey:@"tel"];
    [params setValue:_trainId forKey:@"agencyId"];
    [params setValue:self.idCard forKey:@"card"];
    [params setValue:@"1" forKey:@"certType"];
    [params setValue:self.staffId forKey:@"staffId"];
    if (_leftBtn.selected == YES) {
        [params setValue:@"1" forKey:@"major_type"];
    }else{
        [params setValue:@"2" forKey:@"major_type"];
    }
    MBProgressHUD * hud = [DDUtils showHUDCustom:@""];
    [[DDHttpManager sharedInstance]sendPostRequest:KHttpRequest_builderAddApply params:params success:^(NSURLSessionDataTask *operation, id responseObject){
        NSLog(@"**********建造师添加报名之提交报名数据,获取certiId***************%@",responseObject);
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            [hud hide:NO];
            //获取certiId,跳转至支付确认页面
            DDBuildersPayEnsureVC *builderPayEnsure=[[DDBuildersPayEnsureVC alloc]init];
            builderPayEnsure.userId=self.userId;
            builderPayEnsure.goodsId=self.goodsId;
            builderPayEnsure.trainId=self.trainId;
            
            builderPayEnsure.certiTypeId=self.certiTypeId;
            builderPayEnsure.certiId=[NSString stringWithFormat:@"%@",responseObject[KData]];
            
            builderPayEnsure.peopleName=self.peopleName;
            builderPayEnsure.majorName=self.majorName;
            builderPayEnsure.agencyName=self.agencyName;
            builderPayEnsure.companyName = self.companyName;
            builderPayEnsure.isFromeAddApply = _isFromeAddApply;
            if (_leftBtn.selected == YES) {
                builderPayEnsure.majorPrice=self.majorPrice;
                builderPayEnsure.buildType = @"主项";
            }else{
                builderPayEnsure.majorPrice=self.price;
                builderPayEnsure.buildType = @"增项";
            }
            
            [self.navigationController pushViewController:builderPayEnsure animated:YES];
            
        }
        else{
            hud.labelText = response.message;
            [hud hide:YES afterDelay:KHudShowTimeSecound];
        }
    }  failure:^(NSURLSessionDataTask *operation, id responseObject)  {
        hud.labelText = kRequestFailed;
        [hud hide:YES afterDelay:KHudShowTimeSecound];
    }];
}
#pragma mark -- lazyload
-(UILabel *)companyL{
    if(!_companyL){
        _companyL = [UILabel labelWithFont:kFontSize34 textColor:KColorBlackTitle textAlignment:NSTextAlignmentLeft numberOfLines:0];
    }
    return _companyL;
}
-(UILabel *)addressL{
    if(!_addressL){
        _addressL = [UILabel labelWithFont:kFontSize28 textColor:kColorBlue textAlignment:NSTextAlignmentLeft numberOfLines:0];
    }
    return _addressL;
}
-(UIImageView *)addressImgV{
    if(!_addressImgV){
        _addressImgV = [[UIImageView alloc]initWithImage:DDIMAGE(@"home_select_address")];
    }
    return _addressImgV;
}
-(UIView *)greyV1{
    if(!_greyV1){
        _greyV1 = [[UIView alloc]init];
        _greyV1.backgroundColor = kColorBackGroundColor;
    }
    return _greyV1;
}
-(UIView *)greyV2{
    if(!_greyV2){
        _greyV2 = [[UIView alloc]init];
        _greyV2.backgroundColor = kColorBackGroundColor;
    }
    return _greyV2;
}
-(UILabel *)selectTitle{
    if(!_selectTitle){
        _selectTitle = [UILabel labelWithFont:kFontSize30 textString:@"请选择所报专业的类型" textColor:KColorGreySubTitle textAlignment:NSTextAlignmentLeft numberOfLines:1];
    }
    return _selectTitle;
}
-(UIButton *)leftBtn{
    if(!_leftBtn){
        _leftBtn = [UIButton buttonWithbtnTitle:@"主项" textColor:kColorBlack textFont:kFontSize30 backGroundColor:kColorWhite];
        [_leftBtn setImage:DDIMAGE(@"project_unselect") forState:UIControlStateNormal];
        [_leftBtn setImage:DDIMAGE(@"project_selected") forState:UIControlStateSelected];
        [_leftBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, WidthByiPhone6(10), 0, 0)];
//        [_leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0,WidthByiPhone6(5),0,-WidthByiPhone6(55))];
        [_leftBtn addTarget:self action:@selector(leftAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}
-(UIButton *)rightBtn{
    if(!_rightBtn){
        _rightBtn = [UIButton buttonWithbtnTitle:@"增项" textColor:kColorBlack textFont:kFontSize30 backGroundColor:kColorWhite];
        [_rightBtn setImage:DDIMAGE(@"project_unselect") forState:UIControlStateNormal];
        [_rightBtn setImage:DDIMAGE(@"project_selected") forState:UIControlStateSelected];
        [_rightBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, WidthByiPhone6(10), 0, 0)];
//        [_rightBtn setImageEdgeInsets:UIEdgeInsetsMake(0,WidthByiPhone6(5),0,-WidthByiPhone6(55))];
        [_rightBtn addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}
@end
