//
//  DDOpenContactWayVC.m
//  GongChengDD
//
//  Created by xzx on 2018/11/29.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDOpenContactWayVC.h"
#import "DDFindingPeopleDateSelectCell.h"//cell
#import "DDOpenContactWayCell.h"//cell
#import "DDChangeTelAlertView.h"//修改手机号View
#import "DDMyCertificateVC.h"//我的证书页面
@interface DDOpenContactWayVC ()<UITableViewDelegate,UITableViewDataSource,DDChangeTelAlertViewDelegate>

{
    NSString *_phoneNum;//手机号码
    NSString *_open;//1表示公开，2表示不公开
}
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation DDOpenContactWayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([DDUtils isEmptyString:_phoneStr]) {
        _phoneNum = [DDUserManager sharedInstance].mobileNumber;
    }else{
        _phoneNum = _phoneStr;
    }
    _open=@"1";
    self.view.backgroundColor=kColorBackGroundColor;
    self.title=@"公开联系方式设置";
    self.navigationItem.leftBarButtonItem=[DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
    [self createTableView];
}

#pragma mark 返回上上级
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 创建tableView
-(void)createTableView{
    if (_openContactWayType == OpenContactWayTypeOther) {
        UIView *bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, Screen_Height-KNavigationBarHeight-57.5, Screen_Width, 57.5)];
        bottomView.backgroundColor=kColorWhite;
        UIButton *setBtn=[[UIButton alloc]initWithFrame:CGRectMake(15, 17.5/2, Screen_Width-30, 40)];
        [setBtn setBackgroundColor:KColorFindingPeopleBlue];
        setBtn.titleLabel.font=kFontSize32;
        [setBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
        setBtn.layer.cornerRadius=3;
        [setBtn setTitle:@"确定" forState:UIControlStateNormal];
        [setBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:setBtn];
        [self.view addSubview:bottomView];
        
        
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-KNavigationBarHeight-57.5) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.showsVerticalScrollIndicator=NO;
        _tableView.separatorColor=KColorTableSeparator;
        _tableView.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
        [self.view addSubview:_tableView];
    }else{
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 37)];
    bgView.backgroundColor=KColorFDF5E9;
    
    UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake((Screen_Width-20-6-65)/2, 11, 20, 15)];
    imgView.image=[UIImage imageNamed:@"finding_openTel"];
    [bgView addSubview:imgView];
    
    UILabel *successLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imgView.frame)+6, 11, 65, 15)];
    successLab.text=@"认领成功";
    successLab.textColor=KColorOrangeSubTitle;
    successLab.font=kFontSize30;
    [bgView addSubview:successLab];
    
    [self.view addSubview:bgView];
    
    UIView *bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, Screen_Height-KNavigationBarHeight-57.5, Screen_Width, 57.5)];
    bottomView.backgroundColor=kColorWhite;
    UIButton *setBtn=[[UIButton alloc]initWithFrame:CGRectMake(15, 17.5/2, Screen_Width-30, 40)];
    [setBtn setBackgroundColor:KColorFindingPeopleBlue];
    setBtn.titleLabel.font=kFontSize32;
    [setBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
    setBtn.layer.cornerRadius=3;
    [setBtn setTitle:@"确定" forState:UIControlStateNormal];
    [setBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:setBtn];
    [self.view addSubview:bottomView];
    
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 37, Screen_Width, Screen_Height-KNavigationBarHeight-37-57.5) style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.separatorColor=KColorTableSeparator;
    _tableView.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
    }
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
        return 2;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        static NSString * cellID = @"DDOpenContactWayCell";
        DDOpenContactWayCell * cell = (DDOpenContactWayCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
        }
        
        cell.lab2.text=_phoneNum;
        [cell.changeBtn addTarget:self action:@selector(changeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    else{
        static NSString * cellID = @"DDFindingPeopleDateSelectCell";
        DDFindingPeopleDateSelectCell * cell = (DDFindingPeopleDateSelectCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
        }
        
        cell.leftLab.textColor=KColorBlackTitle;
        cell.leftLab.font=kFontSize32;
        
        if (indexPath.row==0) {
            cell.leftLab.text=@"公开";
            if ([_open isEqualToString:@"1"]) {
                cell.rightImgView.hidden=NO;
                cell.rightImgView.image=[UIImage imageNamed:@"find_select"];
            }
            else{
                cell.rightImgView.hidden=YES;
            }
        }
        else{
            cell.leftLab.text=@"不公开";
            if ([_open isEqualToString:@"1"]) {
                cell.rightImgView.hidden=YES;
            }
            else{
                cell.rightImgView.hidden=NO;
                cell.rightImgView.image=[UIImage imageNamed:@"find_select"];
            }
        }
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1) {
        if (indexPath.row==0) {
            _open=@"1";
            [_tableView reloadData];
        }
        else{
            _open=@"2";
            [_tableView reloadData];
        }
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 51)];
    
    if (section==0) {
        headerView.backgroundColor=kColorBackGroundColor;
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(12, 0, Screen_Width-24, 51)];
        label.text=@"*用人单位可直接联系到你，大量优质企业供你选择，全职或兼职任你选";
        label.font=kFontSize26;
        label.numberOfLines=2;
        label.textColor=KColorGreySubTitle;
        [headerView addSubview:label];
    }
    else{
        headerView.backgroundColor=kColorWhite;
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(12, 0, Screen_Width-24, 51)];
        label.text=@"公开个人联系电话";
        label.font=KfontSize32Bold;
        label.textColor=KColorBlackTitle;
        [headerView addSubview:label];
    }
    
    return headerView;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 51;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 51;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0) {
        return 15;
    }
    else{
        return CGFLOAT_MIN;
    }
}

#pragma mark 修改点击事件
-(void)changeBtnClick{
    //修改手机号
    DDChangeTelAlertView * telView = [[DDChangeTelAlertView alloc] init];
    telView.delegate = self;
    [telView show];
}

#pragma mark  修改手机号成功 DDChangeTelAlertViewDelegate代理回调
//修改手机号成功
- (void)changeTelSuccess:(DDChangeTelAlertView*)telAlertView tel:(NSString*)tel{
    _phoneNum = tel;
    [_tableView reloadData];
}

#pragma mark 确定点击事件
-(void)sureBtnClick{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:self.staffInfoId forKey:@"staffInfoId"];
    [params setValue:_phoneNum forKey:@"tel"];
    [params setValue:_open forKey:@"isopen"];
    
    MBProgressHUD * hud = [DDUtils showHUDCustom:@""];
    [[DDHttpManager sharedInstance]sendPostRequest:KHttpRequest_changeStaffTel params:params success:^(NSURLSessionDataTask *operation, id responseObject){
        NSLog(@"***********公开联系方式设置请求数据***************%@",responseObject);
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            if ([_open isEqualToString:@"1"]) {
                hud.mode = MBProgressHUDModeCustomView;
                hud.customView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"myinfo_saveSuccess"]];
                hud.detailsLabelText = @"已公开";
            }
            [hud hide:YES];
            if (_openContactWayType == OpenContactWayTypeOther) {
                int index = (int)[[self.navigationController viewControllers]indexOfObject:self];
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(index -2)] animated:YES];
            }else{
                NSMutableArray *array = self.navigationController.viewControllers.mutableCopy;
                NSMutableArray *detaiArray = [NSMutableArray array];
                for (UIViewController *vc in array) {
                    if ([vc isKindOfClass:[self class]]) {
                        [detaiArray addObject:vc];
                    }
                }
                if (detaiArray.count >= 1) {
                    [array removeObject:detaiArray.firstObject];
                }
                DDMyCertificateVC *vc=[[DDMyCertificateVC alloc]init];
                [array addObject:vc];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController setViewControllers:array animated:YES];
//                DDMyCertificateVC *vc=[[DDMyCertificateVC alloc]init];
//                [self.navigationController pushViewController:vc animated:YES];
            }
           
        }
        else{
            hud.labelText = response.message;
            [hud hide:YES afterDelay:KHudShowTimeSecound];
        }
    } failure:^(NSURLSessionDataTask *operation, id responseObject) {
        hud.labelText = kRequestFailed;
        [hud hide:YES afterDelay:KHudShowTimeSecound];
    }];
}



@end
