//
//  DDPersonalCheckIntroduceVC.m
//  GongChengDD
//
//  Created by xzx on 2018/9/29.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDPersonalCheckIntroduceVC.h"
#import "DDPersonalCheckIntroduceCell.h"//cell

@interface DDPersonalCheckIntroduceVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,assign) CGFloat offset;

@end

@implementation DDPersonalCheckIntroduceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"认领介绍";
    self.view.backgroundColor=kColorBackGroundColor;
    self.navigationItem.leftBarButtonItem = [DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
    [self createTableView];
}

#pragma mark 返回
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-KNavigationBarHeight) style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.showsVerticalScrollIndicator=NO;
     _tableView.separatorStyle = NO;
    _tableView.contentInset=UIEdgeInsetsMake(170, 0, 0, 0);
    self.offset = _tableView.contentOffset.y;//tableView的偏移量
    [self.view addSubview:_tableView];
    
    
    _imgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 170)];
    _imgView.image=[UIImage imageNamed:@"home_company_introduce"];
    [self.view addSubview:_imgView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 6;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
//    if (!cell) {
//        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
//    }
//
//    UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake((Screen_Width-334)/2, 17, 334, 108)];
//
//    if (indexPath.section==0) {
//        imgView.image=[UIImage imageNamed:@"home_company_check1"];
//    }
//    else if(indexPath.section==1){
//        imgView.image=[UIImage imageNamed:@"home_company_check2"];
//    }
//    else if(indexPath.section==2){
//        imgView.image=[UIImage imageNamed:@"home_company_check3"];
//    }
//    else if(indexPath.section==3){
//        imgView.image=[UIImage imageNamed:@"home_company_check4"];
//    }
//    else if(indexPath.section==4){
//        imgView.image=[UIImage imageNamed:@"home_company_check5"];
//    }
//    else if(indexPath.section==5){
//        imgView.image=[UIImage imageNamed:@"home_company_check6"];
//    }
//
//
//    [cell.contentView addSubview:imgView];
//
//    cell.selectionStyle=UITableViewCellSelectionStyleNone;
//    return cell;
    
    
    static NSString * cellID = @"DDPersonalCheckIntroduceCell";
    DDPersonalCheckIntroduceCell * cell = (DDPersonalCheckIntroduceCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
    }
    
    if (indexPath.section==0) {
        cell.imgView.image=[UIImage imageNamed:@"home_company_check1"];
    }
    else if(indexPath.section==1){
        cell.imgView.image=[UIImage imageNamed:@"home_company_check2"];
    }
    else if(indexPath.section==2){
        cell.imgView.image=[UIImage imageNamed:@"home_company_check3"];
    }
    else if(indexPath.section==3){
        cell.imgView.image=[UIImage imageNamed:@"home_company_check4"];
    }
    else if(indexPath.section==4){
        cell.imgView.image=[UIImage imageNamed:@"home_company_check5"];
    }
    else if(indexPath.section==5){
        cell.imgView.image=[UIImage imageNamed:@"home_company_check6"];
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 165;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0) {
        UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 90)];
        bgView.backgroundColor=kColorWhite;
        
        UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(0, 15, Screen_Width, 20)];
        label1.text=@"    认领证书，掌控证书最新动态";
        label1.textColor=KColorCompanyTitleBalck;
        label1.font=KFontSize40Bold;
        [bgView addSubview:label1];
        
        UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(label1.frame)+35, Screen_Width, 20)];
        label2.text=@"    1.证书所在工作单位和证书不存在（注销）通知；";
        label2.textColor=KColorBlackTitle;
        label2.font=kFontSize30;
        [bgView addSubview:label2];
        
        return bgView;
    }
    else{
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 20)];
        label.backgroundColor=kColorWhite;
        
        if (section==1) {
            label.text=@"    2.人员证书（如建造师）中标，消息通知；";
        }
        else if(section==2){
            label.text=@"    3.人员（如建造师）合同备案，消息通知；";
        }
        else if(section==3){
            label.text=@"    4.行政处罚、事故和获奖消息提醒；";
        }
        else if(section==4){
            label.text=@"    5.建造师等人员变更挂靠单位，消息通知；";
        }
        else if(section==5){
            label.text=@"    6.建造师等人员变更挂靠单位，消息通知；";
        }
        
        label.textColor=KColorBlackTitle;
        label.font=kFontSize30;
        return label;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 90;
    }
    else{
        return 20;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat y = scrollView.contentOffset.y;
    //NSLog(@"%f******%f",y,self.offset);
    CGRect frame = _imgView.frame;
    
    if (y > self.offset) {//向上拉
        _imgView.frame=CGRectMake(0, 0, Screen_Width, 170);
        CGRect frame = _imgView.frame;

        if (y>0 || y==0) {
            frame.origin.y = self.offset;
            _imgView.frame = frame;
        }
        else{
            frame.origin.y = self.offset-y;
            _imgView.frame = frame;
        }
    }
    else if (self.offset == 0){//tableView设置偏移时不能立马获取他的偏移量，所以一开始获取的offset值为0
        return;
    }
    else {//向下拉
        CGFloat x = self.offset - y;
        frame = CGRectMake(-x/2, -x/2, Screen_Width + x, 170+x);
        _imgView.frame = frame;
    }
}


@end
