//
//  DDBuilderAddApplyRecordDetailVC.m
//  GongChengDD
//
//  Created by xzx on 2018/7/20.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDBuilderAddApplyRecordDetailVC.h"
#import "DDBuilderAddApplyRecordDetailCell.h"//cell

@interface DDBuilderAddApplyRecordDetailVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;

@end

@implementation DDBuilderAddApplyRecordDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=kColorBackGroundColor;
    self.title=self.agencyName;
    self.navigationItem.leftBarButtonItem=[DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
    [self createTableView];
}

//返回上一页
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

//创建tableView
-(void)createTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-KNavigationBarHeight) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.showsVerticalScrollIndicator=NO;
}

#pragma mark tableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 9;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellID = @"DDBuilderAddApplyRecordDetailCell";
    DDBuilderAddApplyRecordDetailCell * cell = (DDBuilderAddApplyRecordDetailCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
    }
    
    if (indexPath.section==0) {
        cell.titleLab.text=@"单位名称";
        if ([DDUtils isEmptyString:_companyName]) {
            cell.detailLab.text=@"";
        }
        else{
            cell.detailLab.text=_companyName;
        }
    }
    else if(indexPath.section==1){
        cell.titleLab.text=@"姓名";
        if ([DDUtils isEmptyString:_peopleName]) {
            cell.detailLab.text=@"";
        }
        else{
            cell.detailLab.text=_peopleName;
        }
    }
    else if(indexPath.section==2){
        cell.titleLab.text=@"身份证号";
        if ([DDUtils isEmptyString:_idCard]) {
            cell.detailLab.text=@"";
        }
        else{
            cell.detailLab.text=_idCard;
        }
    }
    else if(indexPath.section==3){
        cell.titleLab.text=@"证书编号";
        if ([DDUtils isEmptyString:_certiNo]) {
            cell.detailLab.text=@"";
        }
        else{
            cell.detailLab.text=_certiNo;
        }
    }
    else if(indexPath.section==4){
        cell.titleLab.text=@"报考专业";
        if ([DDUtils isEmptyString:_majorName]) {
            cell.detailLab.text=@"";
        }
        else{
            cell.detailLab.text=_majorName;
        }
    }else if(indexPath.section==5){
        cell.titleLab.text=@"所报专业类型";
        if ([DDUtils isEmptyString:_majorType]) {
            cell.detailLab.text=@"";
        }
        else{
            if ([_majorType integerValue] == 1) {
                cell.detailLab.text=@"主项";
            }else{
                cell.detailLab.text=@"增项";
            }
        }
    }
    else if(indexPath.section==6){
        cell.titleLab.text=@"是否持有B类证";
        if ([DDUtils isEmptyString:_hasB]) {
            cell.detailLab.text=@"";
        }
        else{
            if ([_hasB isEqualToString:@"0"]) {
                cell.detailLab.text=@"否";
            }
            else{
                cell.detailLab.text=@"是";
            }
        }
    }
    else if(indexPath.section==7){
        cell.titleLab.text=@"证书有效期";
        if ([DDUtils isEmptyString:_validTime]) {
            cell.detailLab.text=@"";
        }
        else{
            cell.detailLab.text=_validTime;
        }
    }
    else if(indexPath.section==8){
        cell.titleLab.text=@"本人手机号";
        if ([DDUtils isEmptyString:_tel]) {
            cell.detailLab.text=@"";
        }
        else{
            cell.detailLab.text=_tel;
        }
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 47;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}


@end
