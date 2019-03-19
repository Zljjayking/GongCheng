//
//  DDBuilderAddTelInputVC.m
//  GongChengDD
//
//  Created by xzx on 2018/7/18.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDBuilderAddTelInputVC.h"

@interface DDBuilderAddTelInputVC ()<UITextFieldDelegate>

@property (nonatomic,strong) UITextField *telTextField;

@end

@implementation DDBuilderAddTelInputVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=kColorBackGroundColor;
    self.title=@"本人手机号录入";
    self.navigationItem.leftBarButtonItem=[DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
    self.navigationItem.rightBarButtonItem=[DDUtils rightbuttonItemWithTitle:@"完成" target:self action:@selector(finishBtnClick)];
    [self createSubView];
}

//返回上一页
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

//创建视图
-(void)createSubView{
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 15, Screen_Width, Screen_Height-KNavigationBarHeight-15)];
    bgView.backgroundColor=kColorWhite;
    [self.view addSubview:bgView];
    
    UILabel *lab1=[[UILabel alloc]initWithFrame:CGRectMake(12, 45, 55, 20)];
    lab1.text=@"手机号";
    lab1.textColor=KColorBlackTitle;
    lab1.font=kFontSize32;
    [bgView addSubview:lab1];
    
    _telTextField=[[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lab1.frame)+20, 45, Screen_Width-24-55-20, 20)];
    _telTextField.placeholder=@"请输入手机号";
    _telTextField.clearButtonMode=UITextFieldViewModeAlways;
    [_telTextField setValue:KColorBidApprovalingWait forKeyPath:@"_placeholderLabel.textColor"];
    [_telTextField setValue:kFontSize32 forKeyPath:@"_placeholderLabel.font"];
    _telTextField.font=kFontSize32;
    _telTextField.delegate = self;
    _telTextField.textColor=KColorBlackTitle;
    [bgView addSubview:_telTextField];
    
    UILabel *line1=[[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(lab1.frame)+17, Screen_Width-12, 1)];
    line1.backgroundColor=KColorTableSeparator;
    [bgView addSubview:line1];
    
    //tipView
    UIView *tipView=[[UIView alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(line1.frame)+20, Screen_Width-24, 15)];
    UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 15, 15)];
    label1.text=@"*";
    label1.textColor=kColorRed;
    label1.font=kFontSize28;
    [tipView addSubview:label1];
    UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, Screen_Width-24-15, 15)];
    label2.text=@"报名考试的通知会及时发送给考生本人";
    label2.textColor=KColorGreySubTitle;
    label2.font=kFontSize28;
    [tipView addSubview:label2];
    [bgView addSubview:tipView];
}


#pragma mark 完成点击事件
-(void)finishBtnClick{
    if (![DDUtils isValidMobilePhone:_telTextField.text]) {
        [DDUtils showToastWithMessage:@"请输入正确的手机号"];
        return;
    }
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:_telTextField.text forKey:@"mobile"];
    kWeakSelf
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_registerPhoneNumber params:params success:^(NSURLSessionDataTask *operation, id responseObject){
        NSLog(@"**********获取人员的userId数据***************%@",responseObject);
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            weakSelf.userIdBlock(responseObject[KData],_telTextField.text);
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        else{
            [DDUtils showToastWithMessage:response.message];
        }
    }  failure:^(NSURLSessionDataTask *operation, id responseObject)  {
        [DDUtils showToastWithMessage:kRequestFailed];
    }];
}

#pragma mark UITextFieldDelegate代理方法
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //编辑过程中随时检测
    if (string.length == 0) {
        if (textField.text.length == 0) {
            return NO;
        }
        textField.text = [textField.text substringToIndex:textField.text.length-1];
    } else {
        textField.text = [textField.text stringByAppendingString:string];
        if (textField == _telTextField) {
            if (textField.text.length > 11) {
                textField.text = [textField.text substringToIndex:11];
            }
        }
    }
    return NO;
}


@end
