//
//  DDAptitudeCertiDetailVC.m
//  GongChengDD
//
//  Created by xzx on 2018/12/11.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDAptitudeCertiDetailVC.h"
#import "DDLabelUtil.h"
#import "DDLoseCreditDetailCell.h"//cell1
#import "DDAptitudeCertificateDetailWebVC.h"
#import "DDAptitudeCertificateDetai2WebVC.h"
#import "DDWebViewController.h"

@interface DDAptitudeCertiDetailVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation DDAptitudeCertiDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent=NO;
    [self editNavItem];
    [self createTableView];
}

//定制导航条
-(void)editNavItem{
    self.title=self.name;
    self.view.backgroundColor=kColorBackGroundColor;
    self.navigationItem.leftBarButtonItem=[DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
    self.navigationItem.rightBarButtonItem=[DDUtils rightbuttonItemWithTitle:@"资质标准" target:self action:@selector(certiStdClick)];
    
}

//返回上一页
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 资质标准点击事件
-(void)certiStdClick{
    //资质详情分为:
    if ([self.majorCategory isEqualToString:@"2"]) {
        DDAptitudeCertificateDetai2WebVC * vc = [[DDAptitudeCertificateDetai2WebVC alloc]init];
        vc.certTypeId = self.certTypeId;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    else{
        //其他资质详情:标准解读,标准原文,承揽范围
        DDAptitudeCertificateDetailWebVC * vc = [[DDAptitudeCertificateDetailWebVC alloc] init];
        vc.certTypeId = self.certTypeId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//创建tableView
-(void)createTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-KNavigationBarHeight) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.backgroundColor=kColorBackGroundColor;
    _tableView.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.separatorColor=KColorTableSeparator;
    _tableView.estimatedRowHeight=44;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, KTableViewFooterViewHeight)];
}

#pragma mark tableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (![DDUtils isEmptyString:self.issuedDate] && ![DDUtils isEmptyString:self.validityPeriodEnd]) {
        return 4;
    }else if([DDUtils isEmptyString:self.issuedDate] && [DDUtils isEmptyString:self.validityPeriodEnd]){
        return 2;
    }
    else{
        return 3;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellID = @"DDLoseCreditDetailCell";
    DDLoseCreditDetailCell * cell = (DDLoseCreditDetailCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
    }
    
    if (![DDUtils isEmptyString:self.issuedDate] &&![DDUtils isEmptyString:self.validityPeriodEnd]) {
        if (indexPath.row==0) {
            cell.titleLab.textColor=KColorGreySubTitle;
            cell.titleLab.font=kFontSize30;
            cell.detailLab.textColor=KColorBlackTitle;
            cell.detailLab.font=kFontSize32;
            
            if ([self.type isEqualToString:@"1"]) {
                cell.titleLab.text=@"许可证号";
            }else{
                cell.titleLab.text=@"证书编号";
            }
            if (![DDUtils isEmptyString:self.certNo]) {
                cell.detailLab.text=self.certNo;
            }
            else{
                cell.detailLab.text=@"-";
            }
        }
        else if(indexPath.row==1){
            cell.titleLab.textColor=KColorGreySubTitle;
            cell.titleLab.font=kFontSize30;
            cell.detailLab.textColor=KColorBlackTitle;
            cell.detailLab.font=kFontSize32;
            cell.titleLab.text=@"发证日期";
            cell.detailLab.text=[DDUtils getSecDateChineseByStandardTime:self.issuedDate];
        }
        else if(indexPath.row==2){
            cell.titleLab.textColor=KColorGreySubTitle;
            cell.titleLab.font=kFontSize30;
            cell.detailLab.textColor=KColorBlackTitle;
            cell.detailLab.font=kFontSize32;
            cell.titleLab.text=@"有效期至";
           
            cell.detailLab.text=[DDUtils getSecDateChineseByStandardTime:self.validityPeriodEnd];
            NSString *resultStr = [DDUtils newCompareTimeSpaceIn180:self.validityPeriodEnd];
            if ([resultStr isEqualToString:@"2"]) {
                cell.detailLab.textColor = KColorFindingPeopleBlue;
            }
            else if([resultStr isEqualToString:@"1"]){
                cell.detailLab.textColor = KColorTextOrange;
            }
            else{
                cell.detailLab.textColor = kColorRed;
            }
        }
        else if(indexPath.row==3){
            cell.titleLab.textColor=KColorGreySubTitle;
            cell.titleLab.font=kFontSize30;
            cell.detailLab.textColor=KColorBlackTitle;
            cell.detailLab.font=kFontSize32;
            cell.titleLab.text=@"发证机关";
            if (![DDUtils isEmptyString:self.issuedDeptSource]) {
                cell.detailLab.text=self.issuedDeptSource;
            }
            else{
                cell.detailLab.text=@"-";
            }
        }
    }else if ([DDUtils isEmptyString:self.issuedDate] &&[DDUtils isEmptyString:self.validityPeriodEnd]) {
        if (indexPath.row==0) {
            cell.titleLab.textColor=KColorGreySubTitle;
            cell.titleLab.font=kFontSize30;
            cell.detailLab.textColor=KColorBlackTitle;
            cell.detailLab.font=kFontSize32;
            
            if ([self.type isEqualToString:@"1"]) {
                cell.titleLab.text=@"许可证号";
            }else{
                cell.titleLab.text=@"证书编号";
            }
            if (![DDUtils isEmptyString:self.certNo]) {
                cell.detailLab.text=self.certNo;
            }
            else{
                cell.detailLab.text=@"-";
            }
        }else{
            cell.titleLab.textColor=KColorGreySubTitle;
            cell.titleLab.font=kFontSize30;
            cell.detailLab.textColor=KColorBlackTitle;
            cell.detailLab.font=kFontSize32;
            cell.titleLab.text=@"发证机关";
            if (![DDUtils isEmptyString:self.issuedDeptSource]) {
                cell.detailLab.text=self.issuedDeptSource;
            }
            else{
                cell.detailLab.text=@"-";
            }
        }
    }
    else{
        if (indexPath.row==0) {
            cell.titleLab.textColor=KColorGreySubTitle;
            cell.titleLab.font=kFontSize30;
            cell.detailLab.textColor=KColorBlackTitle;
            cell.detailLab.font=kFontSize32;
            
            if ([self.type isEqualToString:@"1"]) {
                cell.titleLab.text=@"许可证号";
            }else{
                cell.titleLab.text=@"证书编号";
            }
            if (![DDUtils isEmptyString:self.certNo]) {
                cell.detailLab.text=self.certNo;
            }
            else{
                cell.detailLab.text=@"-";
            }
        }
        else if(indexPath.row==1){
            if (![DDUtils isEmptyString:self.issuedDate]){
                cell.titleLab.textColor=KColorGreySubTitle;
                cell.titleLab.font=kFontSize30;
                cell.detailLab.textColor=KColorBlackTitle;
                cell.detailLab.font=kFontSize32;
                cell.titleLab.text=@"发证日期";
                cell.detailLab.text=[DDUtils getSecDateChineseByStandardTime:self.issuedDate];
            }else{
                cell.titleLab.textColor=KColorGreySubTitle;
                cell.titleLab.font=kFontSize30;
                cell.detailLab.textColor=KColorBlackTitle;
                cell.detailLab.font=kFontSize32;
                cell.titleLab.text=@"有效期至";
                
                cell.detailLab.text=[DDUtils getSecDateChineseByStandardTime:self.validityPeriodEnd];
                NSString *resultStr = [DDUtils newCompareTimeSpaceIn180:self.validityPeriodEnd];
                if ([resultStr isEqualToString:@"2"]) {
                    cell.detailLab.textColor = KColorFindingPeopleBlue;
                }
                else if([resultStr isEqualToString:@"1"]){
                    cell.detailLab.textColor = KColorTextOrange;
                }
                else{
                    cell.detailLab.textColor = kColorRed;
                }
            }
        }
        else if(indexPath.row==2){
            cell.titleLab.textColor=KColorGreySubTitle;
            cell.titleLab.font=kFontSize30;
            cell.detailLab.textColor=KColorBlackTitle;
            cell.detailLab.font=kFontSize32;
            cell.titleLab.text=@"发证机关";
            if (![DDUtils isEmptyString:self.issuedDeptSource]) {
                cell.detailLab.text=self.issuedDeptSource;
            }
            else{
                cell.detailLab.text=@"-";
            }
        }
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 15;
}




@end
