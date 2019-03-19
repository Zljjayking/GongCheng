//
//  DDFindingConditionQueryVC.m
//  GongChengDD
//
//  Created by xzx on 2018/11/2.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDFindingConditionQueryVC.h"
#import "DDFindingConditionCell.h"
#import "DDFindingConditionModel.h"
#import "DDFindingConditionActionCell.h"
#import "DDPersonCertificateVC.h"
#import "DDCertiTypeSelectVC.h"
#import "DDMajorSelectPickerView.h"
#import "DDBidMoneyCell.h"
#import "DDConditionQueryVC.h"
#import "DDFindingCitySelectPickerView.h"//所在地区选择视图
#import "DDFindingCondition2Cell.h"//项目名称输入cell

#define KCompanyAdressTag  10000
#define KProjectDateTag 20000
#define KProjectArea 30000
#define KMinMoneyTag 40000
#define KMaxMoneyTag 50000

@interface DDFindingConditionQueryVC ()<UITableViewDelegate,UITableViewDataSource,DDCertiTypeSelectDelegate,DDMajorSelectPickerViewDelegate,UITextFieldDelegate,DDFindingCitySelectPickerViewDelegate>

{
    NSString *_certTypeLevels;//资质筛选等级
    NSInteger _section;//组数，记录资质等级筛选
    NSInteger _rows;//行数，记录资质等级筛选
    NSInteger _timerow;//行数，记录时间筛选
    
    BOOL _isCitySelect;
    
    NSInteger _number;//记录添加了几项
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DDFindingConditionModel *model;
@property (nonatomic, strong) NSDictionary *pickerDic;//接收总的Json数据源
@property (nonatomic, strong) NSArray *provinceList;//省的数组
@property (nonatomic,strong) DDCertiAndLevelModel * selectCertiModel;//记录选择到的资质,用来传值让子页面高亮,
@property (nonatomic,strong) DDFindingCitySelectPickerView *regionPickerView;

@end

@implementation DDFindingConditionQueryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent=NO;
    _isCitySelect=NO;
    self.view.backgroundColor = kColorBackGroundColor;
    self.navigationItem.title = @"组合查找";
    self.navigationItem.leftBarButtonItem=[DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
    
    _model = [[DDFindingConditionModel alloc] init];
    _model.minMoney=@"";
    _model.maxMoney=@"";
    
    [self setupTableView];
}

#pragma mark 返回上一级
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,0, Screen_Width, Screen_Height-KNavigationBarHeight) style:UITableViewStyleGrouped];
    _tableView.backgroundColor= [UIColor clearColor];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
     _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, KTableViewFooterViewHeight)];
//    _tableView.separatorColor=KColorTableSeparator;
    [self.view addSubview:_tableView];
    
//    __weak __typeof(self) weakSelf=self;
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [weakSelf requestData];
//    }];
    
    _regionPickerView=[[DDFindingCitySelectPickerView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
    _regionPickerView.delegate=self;
    __weak __typeof(self) weakSelf=self;
    _regionPickerView.hiddenBlock = ^{
        [weakSelf.regionPickerView hidden];
        _isCitySelect=NO;
    };
    [_regionPickerView show];
}

#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 3) {
        return 3;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellID = @"DDFindingConditionCell";
    DDFindingConditionCell * cell = (DDFindingConditionCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
    }
    
    
    if (indexPath.section == 0) {
        [cell loadWithTitle:@"所在地区" subTitle:_model.regionName];
    }
    if (indexPath.section == 1) {
        [cell loadWithTitle:@"资质类别及等级" subTitle:_model.certTypeName];
    }
    if (indexPath.section == 2) {
        [cell loadWithTitle:@"注册人员类别及等级" subTitle:_model.certTypeCustomName];
    }
    if (indexPath.section == 3 && indexPath.row == 0) {//中标时间
        [cell loadWithTitle:@"中标时间" subTitle:_model.bidTimeName];
    }
    if (indexPath.section == 3 && indexPath.row == 1) {//中标金额
        static NSString * bidMoneyCellID = @"DDBidMoneyCell";
        DDBidMoneyCell * bidMoneyCell = (DDBidMoneyCell*)[tableView dequeueReusableCellWithIdentifier:bidMoneyCellID];
        if (bidMoneyCell == nil) {
            bidMoneyCell = [[[NSBundle mainBundle]loadNibNamed:bidMoneyCellID owner:self options:nil] firstObject];
        }
        bidMoneyCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [bidMoneyCell loadWithMinMoney:_model.minMoney maxMoney:_model.maxMoney];
        bidMoneyCell.minMoneyTextField.tag = KMinMoneyTag;
        bidMoneyCell.minMoneyTextField.delegate = self;
        bidMoneyCell.minMoneyTextField.keyboardType = UIKeyboardTypeNumberPad;
        [bidMoneyCell.minMoneyTextField addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
        bidMoneyCell.maxMoneyTextFileld.tag = KMaxMoneyTag;
        bidMoneyCell.maxMoneyTextFileld.delegate = self;
        bidMoneyCell.maxMoneyTextFileld.keyboardType = UIKeyboardTypeNumberPad;
        [bidMoneyCell.maxMoneyTextFileld addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
        return bidMoneyCell;
    }
    if (indexPath.section == 3 && indexPath.row == 2) {//项目名称
        
        static NSString * actionCellID = @"DDFindingCondition2Cell";
        DDFindingCondition2Cell * actionCell = (DDFindingCondition2Cell*)[tableView dequeueReusableCellWithIdentifier:actionCellID];
        if (actionCell == nil) {
            actionCell = [[[NSBundle mainBundle]loadNibNamed:actionCellID owner:self options:nil] firstObject];
        }
        
        actionCell.inputField.tag=101;
        actionCell.inputField.delegate=self;
        actionCell.inputField.text=_model.title;
        
        actionCell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *viewline = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 0.5)];
        viewline.backgroundColor = [UIColor colorWithWhite:230.0 / 255.0 alpha:1];
        [actionCell.contentView addSubview:viewline];
        return actionCell;
        //[cell loadWithTitle:@"项目名称" subTitle:_model.bidRegionName];
    }
    if (indexPath.section == 4) {//查找
        static NSString * actionCellID = @"DDFindingConditionActionCell";
        DDFindingConditionActionCell * actionCell = (DDFindingConditionActionCell*)[tableView dequeueReusableCellWithIdentifier:actionCellID];
        if (actionCell == nil) {
            actionCell = [[[NSBundle mainBundle]loadNibNamed:actionCellID owner:self options:nil] firstObject];
        }
        
        actionCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [actionCell loadWithModel:_model];
        [actionCell.actionButton addTarget:self action:@selector(actionButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        return actionCell;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3 && indexPath.row==1) {
        return 94;
    }
    else if (indexPath.section == 4) {
        return [DDFindingConditionActionCell height];
    }
    else{
         return [DDFindingConditionCell height];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        //所在地区点击
        [self showSelcetProviceView];
    }
    if (indexPath.section == 1) {
      //资质类别及等级点击
        [self certiTypeSelectClick];
    }
    if (indexPath.section == 2) {
        //注册人员类别及等级点击
        [self personCertificateClick];
    }
    if (indexPath.section == 3 && indexPath.row == 0) {
        //中标时间
        [self projectDateClick];
    }
    if (indexPath.section == 3 && indexPath.row == 2) {
        //项目名称点击
        //[self projectAreaClick];
    }
    
    [_tableView reloadData];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView * header = [[UIView alloc] init];
        header.frame = CGRectMake(0, 0, Screen_Width, 44);
        UILabel * lab = [[UILabel alloc] init];
        lab.frame = CGRectMake(10, 0, 150, 44);
        lab.text = @"至少选择3项";
        lab.textColor = KColorGreySubTitle;
        lab.font = kFontSize28;
        [header addSubview:lab];
        return header;
    }
    else{
        UIView * header = [[UIView alloc] init];
        header.frame = CGRectMake(0, 0, Screen_Width, 15);
        return header;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 44;
    }
    else if (section == 4) {
        return 60;//查找按钮与上部间距
    }
    else{
        return 15;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

#pragma mark 所在地区点击
//#pragma mark 解析json数据,获取省的数据
//- (void)dataparsing{
//    self.provinceList = [[NSArray alloc]init];
//
//    NSBundle *bundle = [NSBundle mainBundle];
//    NSString *path = [bundle pathForResource:@"newCity2" ofType:@"json"];
//    NSData *data = [NSData dataWithContentsOfFile:path];
//    NSError *error;
//    NSDictionary *provinceLise = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
//    self.pickerDic = provinceLise;
//    self.provinceList = self.pickerDic[@"region"];
//}

- (void)showSelcetProviceView{
    if (_isCitySelect==NO) {
        [_regionPickerView noHidden];
        _isCitySelect=YES;
    }
    else{
        [_regionPickerView hidden];
        _isCitySelect=NO;
    }
}

#pragma mark DDFindingCitySelectPickerViewDelegate所在地区代理方法
-(void)actionsheetDisappear:(DDFindingCitySelectPickerView *)actionSheet andAreaInfoDict:(NSDictionary *)dict{
    if([dict[@"name"] isEqualToString:@"不限"]){
        if ([dict[@"mergerName"] isEqualToString:@"重庆市"]) {
            _model.regionName = @"重庆";
        }else{
            _model.regionName = [NSString stringWithFormat:@"%@",dict[@"mergerName"]];
        }
    }else{
        _model.regionName = [NSString stringWithFormat:@"%@",dict[@"name"]];
    }
    if([dict[@"name"] isEqualToString:@"北京市"]||[dict[@"name"] isEqualToString:@"天津市"]||[dict[@"name"] isEqualToString:@"上海市"]){
        _model.region = [NSString stringWithFormat:@"%@",dict[@"parentId"]];
    }else{
        _model.region = [NSString stringWithFormat:@"%@",dict[@"regionId"]];
    }
    
    
    [self handelActionButtonStates:YES];
    [_tableView reloadData];
}

#pragma  mark 资质类别及等级点击
- (void)certiTypeSelectClick{
    DDCertiTypeSelectVC *certiAndLevel= [[DDCertiTypeSelectVC alloc] init];
    certiAndLevel.delegate = self;
    certiAndLevel.certiType=_certTypeLevels;
    certiAndLevel.section=_section;
    certiAndLevel.rows=_rows;
    certiAndLevel.passValueModel = _selectCertiModel;
    certiAndLevel.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:certiAndLevel animated:YES];
}

#pragma mark DDCertiTypeSelectDelegate资质类别及等级代理回调
//选择了资质类别和等级(带模型)
-(void)certiAndLevelSelect:(DDCertiTypeSelectVC *)certiSelectVC andCertiStr:(NSString *)certiStr andSection:(NSInteger)section andRows:(NSInteger)rows certiAndLevelModel:(DDCertiAndLevelModel *)certiAndLevelModel codeModel:(DDCodeModel *)codeModel{
    NSLog(@"选择资质类别及等级 %@  %ld  %ld ",certiStr,section,rows);
    
    _certTypeLevels=certiStr;
    _section=section;
    _rows=rows;
    
    NSString *tempStr = certiStr;
    //建筑业资质  22 ；  电力承装承修  23；勘察资质  24；设计资质 25；监理资质  26；招标代理 27；造价咨询 28；
    if ([tempStr isEqualToString:@"22"]) {
        tempStr = @"建筑业资质";
    }
    else if([tempStr isEqualToString:@"23"]){
        tempStr = @"承装(修、试)电力设施许可证";
    }
    else if([tempStr isEqualToString:@"24"]){
        tempStr = @"勘察资质";
    }
    else if([tempStr isEqualToString:@"25"]){
        tempStr = @"设计资质";
    }
    else if([tempStr isEqualToString:@"26"]){
        tempStr = @"监理资质";
    }
    else if([tempStr isEqualToString:@"27"]){
        tempStr = @"招标代理机构";
    }
    else if([tempStr isEqualToString:@"28"]){
        tempStr = @"造价咨询企业";
    }
    else if([tempStr isEqualToString:@"29"]){
        tempStr = @"设计与施工一体化";
    }else if([tempStr isEqualToString:@"21"]){
        tempStr = @"消防技术服务机构";
    }else if([tempStr isEqualToString:@"51"]){
        tempStr = @"信息系统集成及服务资质";
    }else if([tempStr isEqualToString:@"52"]){
        tempStr = @"安防工程相关资质";
    }else if([tempStr isEqualToString:@"53"]){
        tempStr = @"信息通信建设服务能力资质";
    }else if([tempStr isEqualToString:@"54"]){
        tempStr = @"园林绿化资质";
    }
    else if([tempStr isEqualToString:@""]){
        tempStr = @"全部";
    }
    
    if (certiAndLevelModel == nil) {
        _model.certTypeId = certiStr;
        _model.certTypeLevel = @"";
    }
    else{
        _model.certTypeId = certiAndLevelModel.certTypeId;
        _model.certTypeLevel = codeModel.code;
    }
    
    _model.certTypeName = tempStr;
    
    _selectCertiModel = certiAndLevelModel;
    
    [self handelActionButtonStates:YES];
    NSLog(@"++++ %@ %@",certiAndLevelModel.certTypeId,codeModel.code);
    [_tableView reloadData];
}

#pragma mark 注册人员类别及等级点击
- (void)personCertificateClick{
    DDPersonCertificateVC * vc = [[DDPersonCertificateVC alloc] init];
    vc.pointRow = _model.pointRow;
    __weak __typeof(self) weakSelf=self;
    
    vc.personCertificatSelectSuccessBlock = ^(NSString * _Nonnull cerName, DDMajorSelectModel * _Nonnull majorModel, NSString * _Nonnull cerType, NSInteger pointRow) {
        NSLog(@"%@, %@, %@", cerName, majorModel.name, majorModel.cert_type_id);
        _model.certType = cerType;
        if (![DDUtils isEmptyString:majorModel.name]) {
            if ([majorModel.name isEqualToString:@"全部专业"]) {
                _model.certTypeCustomName = cerName;
            }else{
                _model.certTypeCustomName = majorModel.name;
            }
        }else{
            _model.certTypeCustomName = cerName;
        }
        _model.certCode = majorModel.cert_type_id;
        _model.pointRow = pointRow;
        [weakSelf handelActionButtonStates:YES];
        [_tableView reloadData];
    };
  
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 中标时间点击
- (void)projectDateClick{
    NSArray * tempArray = [[NSArray alloc] initWithObjects:@"不限",@"近一个月",@"近半年",@"近一年",@"近二年",@"近三年", nil];
    DDMajorSelectPickerView * majorSelectPickerView = [[DDMajorSelectPickerView alloc] init];
    majorSelectPickerView.firstComponentSelectRow =  _timerow;
    [majorSelectPickerView loadWithTitle:@"请选择时间" dataArray:tempArray];
    majorSelectPickerView.delegate = self;
    majorSelectPickerView.tag = KProjectDateTag;
    [majorSelectPickerView show];
}

#pragma mark DDMajorSelectPickerViewDelegate代理方法
//选中了某一行
- (void)majorSelectPickerViewClickFinsh:(DDMajorSelectPickerView*)majorSelectPickerView row:(NSInteger)row{
    if (majorSelectPickerView.tag == KProjectDateTag) {
        _model.bidTime = [NSString stringWithFormat:@"%ld",(long)row];
        _timerow = row;
        NSArray * tempArray = [[NSArray alloc] initWithObjects:@"不限",@"近一个月",@"近半年",@"近一年",@"近二年",@"近三年", nil];
        _model.bidTimeName = tempArray[row];
        [self handelActionButtonStates:YES];
        [_tableView reloadData];
    }
}

#pragma mark UITextField输入处理
- (void)textFieldEditChanged:(UITextField *)textField{
    if (textField.tag==101) {
        _model.title=textField.text;
    }
    else{
        BOOL result =  [DDUtils isPureInt:textField.text];
        if (NO == result) {
//            [DDUtils showToastCoverKeyboard:@"请输入纯整数"];
            textField.text = nil;
            return;
        }
        if (textField.text.length>7) {
            textField.text = [textField.text substringToIndex:7];
            return;
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag==101) {
        _model.title=textField.text;
        [self handelActionButtonStates:YES];
    }
    else{
        if (KMinMoneyTag == textField.tag) {
            _model.minMoney = textField.text;//给最小值赋值
        }
        if (KMaxMoneyTag == textField.tag) {
            _model.maxMoney = textField.text;//给最大值赋值
        }
        
        NSString  *tempMin = _model.minMoney;//临时存下最小值
        NSString  *tempMax = _model.maxMoney;//临时存下最大值
        
        if (![DDUtils isEmptyString:_model.minMoney] && ![DDUtils isEmptyString:_model.maxMoney]) {
            //最小值如果大于最大值,调换
            if ([tempMin integerValue] > [tempMax integerValue]) {
                _model.minMoney = tempMax;
                _model.maxMoney = tempMin;
            }
            
            //如果相等,只传最大值
            if ([_model.minMoney integerValue] == [_model.maxMoney integerValue]) {
//                _model.minMoney = @"";
                _model.maxMoney = tempMax;
            }
        }
        else if([DDUtils isEmptyString:_model.minMoney] && ![DDUtils isEmptyString:_model.maxMoney]){
            _model.minMoney = @"";
            _model.maxMoney = tempMax;
        }
        else if(![DDUtils isEmptyString:_model.minMoney] && [DDUtils isEmptyString:_model.maxMoney]){
            _model.minMoney = tempMin;
            _model.maxMoney = @"";
        }
        else if([DDUtils isEmptyString:_model.minMoney] && [DDUtils isEmptyString:_model.maxMoney]){
            _model.minMoney = @"";
            _model.maxMoney = @"";
        }
        
        [self handelActionButtonStates:YES];
    } 
   
    [_tableView reloadData];
}

#pragma mark 处理"查找"按钮的状态（至少选择3项才让点）
- (void)handelActionButtonStates:(BOOL)states{
    //所在地区---资质类别及等级---注册人员类别及等级---中标时间---中标金额---项目名称
    _number = 0;
    if (![DDUtils isEmptyString:_model.region]) {
        _number=_number+1;
    }
    if (![DDUtils isEmptyString:_model.certTypeName]) {
        _number=_number+1;
    }
    if (![DDUtils isEmptyString:_model.certTypeCustomName]) {
        _number=_number+1;
    }
    if (![DDUtils isEmptyString:_model.bidTimeName]) {
        _number=_number+1;
    }
    if (![DDUtils isEmptyString:_model.minMoney] && ![DDUtils isEmptyString:_model.maxMoney]) {
        _number=_number+1;
    }
    if (![DDUtils isEmptyString:_model.title]) {
        _number=_number+1;
    }
    
    if (_number<3) {
        _model.canAction = [NSNumber numberWithBool:NO];
    }
    else{
        _model.canAction = [NSNumber numberWithBool:YES];
    }
    
    [_tableView reloadData];
}

#pragma mark 查找点击事件，页面跳转
- (void)actionButtonClick{
    DDConditionQueryVC * vc = [[DDConditionQueryVC alloc] init];
    //如果中标金额,最大值,最小值相等,只传最大值,最小值传空,
    if ([_model.minMoney integerValue] == [_model.maxMoney integerValue]) {
        _model.minMoney =@"";
    }
    vc.passValueModel = _model;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
