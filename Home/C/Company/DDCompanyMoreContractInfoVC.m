//
//  DDCompanyMoreContractInfoVC.m
//  GongChengDD
//
//  Created by xzx on 2018/6/13.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDCompanyMoreContractInfoVC.h"
#import "DDCompanyMoreContractInfoCell.h"//cell
#import "DDProjectCheckOriginWebVC.h"//借用的页面
#import "DDServiceWebViewVC.h"
@interface DDCompanyMoreContractInfoVC ()<UITableViewDelegate,UITableViewDataSource>

{
    NSArray *_phoneArray;
}
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation DDCompanyMoreContractInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self editNavItem];
    [self createTableView];
}

//定制导航条
-(void)editNavItem{
    self.title=self.enterpriseName;
    self.view.backgroundColor=kColorBackGroundColor;
    self.navigationItem.leftBarButtonItem=[DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
    
    if ([self.contactNumber containsString:@";"]) {
        _phoneArray=[self.contactNumber componentsSeparatedByString:@";"];
    }
}

//返回上一页
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

//创建tableView
-(void)createTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-KNavigationBarHeight) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.backgroundColor=kColorBackGroundColor;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.estimatedRowHeight=44;
    _tableView.separatorColor=KColorTableSeparator;
    
    [_tableView registerNib:[UINib nibWithNibName:@"DDCompanyMoreContractInfoCell" bundle:nil] forCellReuseIdentifier:@"DDCompanyMoreContractInfoCell"];
}

#pragma mark tableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_phoneArray.count>0) {
        return _phoneArray.count+3;
    }
    else{
        return 4;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DDCompanyMoreContractInfoCell *cell=[tableView dequeueReusableCellWithIdentifier:@"DDCompanyMoreContractInfoCell" forIndexPath:indexPath];
    
    if (_phoneArray.count>0) {

        for (int i=0; i<_phoneArray.count; i++) {
            if (indexPath.section==i) {
                cell.contentLab1.text=[NSString stringWithFormat:@"联系方式%d",i+1];
                if ([DDUtils isEmptyString:_phoneArray[i]]) {
                    cell.contentLab2.text=@"暂无";
                    cell.contentLab2.textColor=KColorGreySubTitle;
                }
                else{
                    cell.contentLab2.text=_phoneArray[i];
                    cell.contentLab2.textColor=kColorBlue;
                }
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            }
        }
        
        if (indexPath.section==_phoneArray.count) {
            cell.contentLab1.text=@"邮箱地址";
            if ([DDUtils isEmptyString:self.email]) {
                cell.contentLab2.text=@"暂无";
            }
            else{
                cell.contentLab2.text=self.email;
            }
            cell.contentLab2.textColor=KColorGreySubTitle;
            cell.accessoryType=UITableViewCellAccessoryNone;
        }
        else if(indexPath.section==_phoneArray.count+1){
            cell.contentLab1.text=@"官网地址";
            if ([DDUtils isEmptyString:self.offcialWebsite]) {
                cell.contentLab2.text=@"暂无";
                cell.contentLab2.textColor=KColorGreySubTitle;
            }
            else{
                cell.contentLab2.text=self.offcialWebsite;
                cell.contentLab2.textColor=kColorBlue;
            }
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
        else if(indexPath.section==_phoneArray.count+2){
            cell.contentLab1.text=@"公司地址";
            if ([DDUtils isEmptyString:self.address]) {
                cell.contentLab2.text=@"暂无";
            }
            else{
                cell.contentLab2.text=self.address;
            }
            cell.contentLab2.textColor=KColorGreySubTitle;
            cell.accessoryType=UITableViewCellAccessoryNone;
        }
        
    }
    else{
        if(indexPath.section==0){
            cell.contentLab1.text=@"联系方式";
            if ([DDUtils isEmptyString:self.contactNumber]) {
                cell.contentLab2.text=@"暂无";
                cell.contentLab2.textColor=KColorGreySubTitle;
            }
            else{
                cell.contentLab2.text=self.contactNumber;
                cell.contentLab2.textColor=kColorBlue;
            }
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
        else if(indexPath.section==1){
            cell.contentLab1.text=@"邮箱地址";
            if ([DDUtils isEmptyString:self.email]) {
                cell.contentLab2.text=@"暂无";
            }
            else{
                cell.contentLab2.text=self.email;
            }
            cell.contentLab2.textColor=KColorGreySubTitle;
            cell.accessoryType=UITableViewCellAccessoryNone;
        }
        else if(indexPath.section==2){
            cell.contentLab1.text=@"官网地址";
            if ([DDUtils isEmptyString:self.offcialWebsite]) {
                cell.contentLab2.text=@"暂无";
                cell.contentLab2.textColor=KColorGreySubTitle;
            }
            else{
                cell.contentLab2.text=self.offcialWebsite;
                cell.contentLab2.textColor=kColorBlue;
            }
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
        else if(indexPath.section==3){
            cell.contentLab1.text=@"公司地址";
            if ([DDUtils isEmptyString:self.address]) {
                cell.contentLab2.text=@"暂无";
            }
            else{
                cell.contentLab2.text=self.address;
            }
            cell.contentLab2.textColor=KColorGreySubTitle;
            cell.accessoryType=UITableViewCellAccessoryNone;
        }
    }

    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_phoneArray.count>0) {
        
        if (indexPath.section<_phoneArray.count){
            if ([DDUtils isEmptyString:_phoneArray[indexPath.section]]) {
                [DDUtils showToastWithMessage:@"暂无联系电话！"];
            }
            else{
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_phoneArray[indexPath.section]]]];
            }
        }
        else if (indexPath.section==_phoneArray.count+1) {
            if ([DDUtils isEmptyString:self.offcialWebsite]) {
                [DDUtils showToastWithMessage:@"暂无网址！"];
            }
            else{
                DDProjectCheckOriginWebVC *webView=[[DDProjectCheckOriginWebVC alloc]init];
                webView.hostUrl=self.offcialWebsite;
                webView.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:webView animated:YES];
            }
        }
        
    }
    else{
        if (indexPath.section==0) {
            if ([DDUtils isEmptyString:self.contactNumber]) {
                [DDUtils showToastWithMessage:@"暂无联系电话！"];
            }
            else{
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.contactNumber]]];
            }
        }
        else if(indexPath.section==2){
            if ([DDUtils isEmptyString:self.offcialWebsite]) {
                [DDUtils showToastWithMessage:@"暂无网址！"];
            }
            else{
                
                DDServiceWebViewVC *checkVC = [DDServiceWebViewVC new];
                checkVC.hostUrl = self.offcialWebsite;
                checkVC.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:checkVC animated:YES];
                
//                DDProjectCheckOriginWebVC *webView=[[DDProjectCheckOriginWebVC alloc]init];
//                webView.hostUrl=self.offcialWebsite;
//                webView.hidesBottomBarWhenPushed=YES;
//                [self.navigationController pushViewController:webView animated:YES];
            }
        }
    }
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
    return 15;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}



@end
