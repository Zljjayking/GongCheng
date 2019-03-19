//
//  DDDownloadReportVC.m
//  GongChengDD
//
//  Created by xzx on 2018/11/27.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDDownloadReportVC.h"
#import "DDDownloadReportCell.h"//cell
#import "DDFindingCondition2Cell.h"//cell
#import "DDReportSubmitSuccessVC.h"//提交成功

@interface DDDownloadReportVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

{
    NSString *_myEmail;
}
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation DDDownloadReportVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _myEmail=self.email;
    
    if (![DDUtils isEmptyString:[DDUserManager sharedInstance].email]){
        _myEmail = [DDUserManager sharedInstance].email;
    }
    else if([[NSUserDefaults standardUserDefaults]objectForKey:[DDUserManager sharedInstance].mobileNumber]){
        _myEmail = [[NSUserDefaults standardUserDefaults]objectForKey:[DDUserManager sharedInstance].mobileNumber];
    }
    
    self.view.backgroundColor=kColorBackGroundColor;
    self.title=@"下载报告";
    self.navigationItem.leftBarButtonItem=[DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
    [self createTableView];
}

#pragma mark 返回上一级
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 创建tableView
-(void)createTableView{
    
    UIView *bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, Screen_Height-KNavigationBarHeight-57.5, Screen_Width, 57.5)];
    bottomView.backgroundColor=kColorWhite;
    UIButton *setBtn=[[UIButton alloc]initWithFrame:CGRectMake(15, 17.5/2, Screen_Width-30, 40)];
    [setBtn setBackgroundColor:KColorFindingPeopleBlue];
    setBtn.titleLabel.font=kFontSize32;
    [setBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
    setBtn.layer.cornerRadius=3;
    [setBtn setTitle:@"确认下载" forState:UIControlStateNormal];
    [setBtn addTarget:self action:@selector(downloadClick) forControlEvents:UIControlEventTouchUpInside];
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
}

#pragma mark 确认下载
-(void)downloadClick{
    if ([DDUtils isEmptyString:_myEmail]) {
        [DDUtils showToastWithMessage:@"请填写邮箱！"];
        return;
    }if (![DDUtils isValidEmail:_myEmail]) {
        [DDUtils showToastWithMessage:@"请输入有效的邮箱地址"];
        return;
    }
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:self.enterpriseId forKey:@"entId"];
    [params setValue:_myEmail forKey:@"email"];
    [params setValue:self.enterpriseName forKey:@"entName"];
        
    MBProgressHUD * hud = [DDUtils showHUDCustom:@""];
    [[DDHttpManager sharedInstance]sendPostRequest:KHttpRequest_uacredireportSave params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
            NSLog(@"***********确认下载请求数据***************%@",responseObject);
            
            DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
            if (response.isSuccess) {
                //hud.mode = MBProgressHUDModeCustomView;
                //hud.customView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"myinfo_saveSuccess"]];
                //hud.detailsLabelText = @"下载成功";
            [hud hide:YES];
            DDReportSubmitSuccessVC *vc=[[DDReportSubmitSuccessVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
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

#pragma mark tableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==3) {
        static NSString * actionCellID = @"DDFindingCondition2Cell";
        DDFindingCondition2Cell *cell = (DDFindingCondition2Cell*)[tableView dequeueReusableCellWithIdentifier:actionCellID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:actionCellID owner:self options:nil] firstObject];
        }
        
        cell.textLab.text=@"接收邮箱";
        cell.textLab.textColor=KColorGreySubTitle;
        cell.textLab.font=kFontSize30;
        
        cell.inputField.delegate=self;
        cell.tag = 12333;
//        cell.inputField.textAlignment=NSTextAlignmentRight;
        cell.inputField.placeholder=@"请输入您的邮箱地址";
        cell.inputField.text = _myEmail;
        [cell.inputField addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
//        cell.inputField.clearButtonMode=UITextFieldViewModeAlways;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else{
        static NSString * actionCellID = @"DDDownloadReportCell";
        DDDownloadReportCell *cell = (DDDownloadReportCell*)[tableView dequeueReusableCellWithIdentifier:actionCellID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:actionCellID owner:self options:nil] firstObject];
        }
        
        if (indexPath.row==0) {
            cell.textLab.text=@"企业信用报告";
            cell.textLab.textColor=KColorBlackTitle;
            cell.textLab.font=kFontSize34;
            
            cell.imgView.hidden=YES;
            cell.detailTextLab.hidden=YES;
        }
        else if(indexPath.row==1){
            cell.textLab.text=@"报告目标";
            cell.textLab.textColor=KColorGreySubTitle;
            cell.textLab.font=kFontSize30;
            
            cell.imgView.hidden=YES;
            cell.detailTextLab.hidden=NO;
            
            cell.detailTextLab.text=self.enterpriseName;
            cell.detailTextLab.textColor=KColorBlackTitle;
            cell.detailTextLab.font=kFontSize30;
        }
        else if(indexPath.row==2){
            cell.textLab.text=@"报告格式";
            cell.textLab.textColor=KColorGreySubTitle;
            cell.textLab.font=kFontSize30;
            
            cell.imgView.hidden=NO;
            cell.detailTextLab.hidden=NO;
            
            cell.detailTextLab.text=@"PDF";
            cell.detailTextLab.textColor=KColorBlackTitle;
            cell.detailTextLab.font=kFontSize30;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
-(void)textChanged:(UITextField *)textField{
    if (textField.text.length>63) {
        textField.text = [textField.text substringToIndex:64];
    }
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

-(void)textFieldDidEndEditing:(UITextField *)textField{
    _myEmail=textField.text;
    [[NSUserDefaults standardUserDefaults]setObject:_myEmail forKey:[DDUserManager sharedInstance].mobileNumber];
}

@end
