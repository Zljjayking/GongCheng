//
//  DDTrainInputPersonalInfoVC.m
//  GongChengDD
//
//  Created by xzx on 2018/7/9.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDTrainInputPersonalInfoVC.h"
#import "DDTrainInputPersonalInfoCell.h"//cell

@interface DDTrainInputPersonalInfoVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

{
    NSString *_inputInfo;
}
@property(nonatomic,strong) UITableView *tableView;

@end

@implementation DDTrainInputPersonalInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _inputInfo = _contentStr;
    [self editNavItem];
    [self createTableView];
}

-(void)editNavItem{
    self.view.backgroundColor=kColorBackGroundColor;
    
    if ([self.type isEqualToString:@"1"]) {
        self.title=@"填写姓名";
    }
    else if ([self.type isEqualToString:@"2"]) {
        self.title=@"填写身份证号";
    }
    else if ([self.type isEqualToString:@"3"]) {
        self.title=@"填写注册编号";
    }
    
    self.navigationItem.leftBarButtonItem=[DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
    self.navigationItem.rightBarButtonItem=[DDUtils rightbuttonItemWithTitle:@"完成" target:self action:@selector(finishClick)];
}

//返回上一页
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

//点击完成
-(void)finishClick{
    if ([self.type isEqualToString:@"1"]) {
        if (_inputInfo.length<1) {
            [DDUtils showToastWithMessage:@"请输入姓名"];
            return;
        }
        else{
            [self.view endEditing:YES];
            self.inputInfoBlock(_inputInfo);
        }
    }else if ([self.type isEqualToString:@"2"]) {
        if (_inputInfo.length<18) {
            [DDUtils showToastWithMessage:@"请输入正确身份证号"];
            return;
        }
        else{
            [self.view endEditing:YES];
            self.inputInfoBlock(_inputInfo);
        }
    }else if ([self.type isEqualToString:@"3"]) {
        if (_inputInfo.length<1) {
            [DDUtils showToastWithMessage:@"请输入注册证书编号"];
            return;
        }
        else{
            [self.view endEditing:YES];
            self.inputInfoBlock(_inputInfo);
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

//创建tableView
-(void)createTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-KNavigationBarHeight) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=kColorBackGroundColor;
    _tableView.showsVerticalScrollIndicator=YES;
    _tableView.separatorColor=KColorTableSeparator;
}

#pragma mark tableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellID = @"DDTrainInputPersonalInfoCell";
    DDTrainInputPersonalInfoCell * cell = (DDTrainInputPersonalInfoCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
    }
    
    cell.textField.delegate=self;
    [cell.textField addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
    if ([self.type isEqualToString:@"1"]) {
        cell.titleLab.text=@"姓名";
        cell.textField.placeholder=@"请输入姓名";
    }
    else if ([self.type isEqualToString:@"2"]) {
        cell.titleLab.text=@"身份证号";
        cell.textField.placeholder=@"请输入身份证号";
    }
    else if ([self.type isEqualToString:@"3"]) {
        cell.titleLab.text=@"证书编号";
        cell.textField.placeholder=@"请输入证书编号";
    }
    cell.textField.text = _contentStr;
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

-(void)textChanged:(UITextField *)textField{
    
    UITextRange *selectedRange = textField.markedTextRange;
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    if (position) {
        // 有高亮选择的字 不做任何操作
        return;
    }
    
    if ([self.type isEqualToString:@"1"]) {
        if (textField.text.length>8) {
            textField.text = [textField.text substringToIndex:8];
        }
    }
    if ([self.type isEqualToString:@"2"]) {
        if (textField.text.length>18) {
            textField.text = [textField.text substringToIndex:18];
        }
    }
    _inputInfo=textField.text;
}

@end
