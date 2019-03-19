//
//  DDSaveInvoiceTitleView.m
//  GongChengDD
//
//  Created by csq on 2018/10/25.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDSaveInvoiceTitleView.h"

@implementation DDSaveInvoiceTitleView

-(id)init
{
    self = [super init];
    if(self)
    {
        self.frame = CGRectMake(0, 0, Screen_Width, Screen_Height);
        self.backgroundColor = KColor30AlphaBlack;
//        self.backgroundColor = [UIColor clearColor];
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidden)];
//        [self addGestureRecognizer:tap];
        
    }
    return self;
}

-(void)loadWithInvoiceTitleModel:(DDInvoiceTitleModel*)invoiceTitleModel{
    //白色背景View
    UIView * whiteBgView = [[UIView alloc] init];
    whiteBgView.frame = CGRectMake(15, ((Screen_Height-410)/2), (Screen_Width-30), 430);
    whiteBgView.backgroundColor = [UIColor whiteColor];
    //加圆角
    whiteBgView.layer.cornerRadius = 8;
    whiteBgView.clipsToBounds = YES;
    //加边框
//    cancelButton.layer.borderColor = kColorBlue.CGColor;
//    cancelButton.layer.borderWidth = 0.5;
    [self addSubview:whiteBgView];
    
    
    //标题
    UILabel * titleLab = [[UILabel alloc] init];
    titleLab.frame = CGRectMake(0, 0, WIDTH(whiteBgView), 44);
    titleLab.text = @"发票抬头";
    titleLab.textColor = KColorBlackTitle;
    titleLab.font = KfontSize34Bold;
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.backgroundColor = kColorNavBarGray;
    //部分圆角
    UIBezierPath * fieldPath = [UIBezierPath bezierPathWithRoundedRect:titleLab.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(8, 8)];
    CAShapeLayer * fieldLayer = [[CAShapeLayer alloc] init];
    fieldLayer.frame = titleLab.bounds;
    fieldLayer.path = fieldPath.CGPath;
    titleLab.layer.mask = fieldLayer;
    [whiteBgView addSubview:titleLab];
    
    
    UILabel * companyNameMarklab = [[UILabel alloc] init];
    companyNameMarklab.frame = CGRectMake(15, BOTTOM(titleLab)+18,70,20);
    companyNameMarklab.text = @"公司名称:";
    companyNameMarklab.textColor = KColorInvoiceCompanyGray;
    companyNameMarklab.font = kFontSize30;
    [whiteBgView addSubview:companyNameMarklab];
    
    UILabel * companyNameLab = [[UILabel alloc] init];
    companyNameLab.frame = CGRectMake((RIGHT(companyNameMarklab)+5), Y(companyNameMarklab), (WIDTH(whiteBgView)-15-15-10-WIDTH(companyNameMarklab)), 20);
    companyNameLab.textColor = KColorBlackTitle;
    companyNameLab.font = kFontSize30;
    companyNameLab.text = invoiceTitleModel.entName;
    [whiteBgView addSubview:companyNameLab];
    
    
    UILabel * taxNumMarklab = [[UILabel alloc] init];
    taxNumMarklab.frame = CGRectMake(15, BOTTOM(companyNameMarklab)+18,WIDTH(companyNameMarklab),20);
    taxNumMarklab.text = @"税   号:";
    taxNumMarklab.textColor = KColorInvoiceCompanyGray;
    taxNumMarklab.font = kFontSize30;
    [whiteBgView addSubview:taxNumMarklab];
    
    UILabel * taxNumLab = [[UILabel alloc] init];
    taxNumLab.frame = CGRectMake((RIGHT(taxNumMarklab)+5), Y(taxNumMarklab),WIDTH(companyNameLab), 20);
    taxNumLab.textColor = KColorBlackTitle;
    taxNumLab.font = kFontSize30;
    taxNumLab.text = invoiceTitleModel.taxNum;
    [whiteBgView addSubview:taxNumLab];
    
    
    UILabel * telMarklab = [[UILabel alloc] init];
    telMarklab.frame = CGRectMake(15, BOTTOM(taxNumMarklab)+18,WIDTH(companyNameMarklab),20);
    telMarklab.text = @"电话号码:";
    telMarklab.textColor = KColorInvoiceCompanyGray;
    telMarklab.font = kFontSize30;
    [whiteBgView addSubview:telMarklab];
    
    UILabel * telLab = [[UILabel alloc] init];
    telLab.frame = CGRectMake((RIGHT(taxNumMarklab)+5), Y(telMarklab),WIDTH(companyNameLab), 20);
    telLab.textColor = KColorBlackTitle;
    telLab.font = kFontSize30;
    if (![DDUtils isEmptyString:invoiceTitleModel.tel]) {
       telLab.text = invoiceTitleModel.tel;
    }else{
        telLab.text = @"暂无信息";
    }
    [whiteBgView addSubview:telLab];
    
    
    UILabel * addressMarklab = [[UILabel alloc] init];
    addressMarklab.frame = CGRectMake(15, BOTTOM(telLab)+18,WIDTH(companyNameMarklab),20);
    addressMarklab.text = @"单位地址:";
    addressMarklab.textColor = KColorInvoiceCompanyGray;
    addressMarklab.font = kFontSize30;
    [whiteBgView addSubview:addressMarklab];
    
    UILabel * addressLab = [[UILabel alloc] init];
    addressLab.frame = CGRectMake((RIGHT(taxNumMarklab)+5), Y(addressMarklab),WIDTH(companyNameLab), 20);
    addressLab.textColor = KColorBlackTitle;
    addressLab.font = kFontSize30;
    addressLab.text = invoiceTitleModel.address;
    addressLab.numberOfLines = 0;
    [addressLab sizeToFit];
    [whiteBgView addSubview:addressLab];
    
    
    UILabel * depositBankMarklab = [[UILabel alloc] init];
    depositBankMarklab.frame = CGRectMake(15, BOTTOM(addressLab)+18,WIDTH(companyNameMarklab),20);
    depositBankMarklab.text = @"开户银行:";
    depositBankMarklab.textColor = KColorInvoiceCompanyGray;
    depositBankMarklab.font = kFontSize30;
    [whiteBgView addSubview:depositBankMarklab];
    
    UILabel * depositBankLab = [[UILabel alloc] init];
    depositBankLab.frame = CGRectMake((RIGHT(taxNumMarklab)+5), Y(depositBankMarklab),WIDTH(companyNameLab), 20);
    depositBankLab.textColor = KColorBlackTitle;
    depositBankLab.font = kFontSize30;
    if (![DDUtils isEmptyString:invoiceTitleModel.depositBank]) {
         depositBankLab.text = invoiceTitleModel.depositBank;
    }else{
        depositBankLab.text = @"暂无信息";
    }
    depositBankLab.numberOfLines = 0;
    [depositBankLab sizeToFit];
    [whiteBgView addSubview:depositBankLab];
    
    
    UILabel * bankAccountMarklab = [[UILabel alloc] init];
    bankAccountMarklab.frame = CGRectMake(15, BOTTOM(depositBankLab)+18,WIDTH(companyNameMarklab),20);
    bankAccountMarklab.text = @"银行账户:";
    bankAccountMarklab.textColor = KColorInvoiceCompanyGray;
    bankAccountMarklab.font = kFontSize30;
    [whiteBgView addSubview:bankAccountMarklab];
    
    UILabel * bankAccountLab = [[UILabel alloc] init];
    bankAccountLab.frame = CGRectMake((RIGHT(taxNumMarklab)+5), Y(bankAccountMarklab),WIDTH(companyNameLab), 20);
    bankAccountLab.textColor = KColorBlackTitle;
    bankAccountLab.font = kFontSize30;
    if (![DDUtils isEmptyString:invoiceTitleModel.bankAccount]) {
        bankAccountLab.text = invoiceTitleModel.bankAccount;
    }else{
        bankAccountLab.text = @"暂无信息";
    }
    bankAccountLab.numberOfLines = 0;
    [bankAccountLab sizeToFit];
    [whiteBgView addSubview:bankAccountLab];
    
    
    //线条
    UIView * line = [[UIView alloc] init];
    line.frame = CGRectMake(15,(BOTTOM(bankAccountLab)+18), (Screen_Width-30), 0.5);
    line.backgroundColor = KColorTableSeparator;
    [whiteBgView addSubview:line];
    
    UILabel * summaryLab = [[UILabel alloc] init];
    summaryLab.frame = CGRectMake(0,(BOTTOM(line)+12), WIDTH(whiteBgView), 20);
    summaryLab.text = @"您可以在开票时出示上述信息，也可以保存发票抬头";
    summaryLab.textColor = KColorBidApprovalingWait;
    summaryLab.font = kFontSize26;
    summaryLab.textAlignment = NSTextAlignmentCenter;
    [whiteBgView addSubview:summaryLab];
    
    
    UIButton * cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(25,(Y(summaryLab)+35), 102, 40);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitle:@"取消" forState:UIControlStateHighlighted];
    [cancelButton setTitleColor:kColorBlue forState:UIControlStateNormal];
    [cancelButton setTitleColor:kColorBlue forState:UIControlStateHighlighted];
    [cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    //加圆角
    cancelButton.layer.cornerRadius = 3;
    cancelButton.clipsToBounds = YES;
    //加边框
    cancelButton.layer.borderColor = kColorBlue.CGColor;
    cancelButton.layer.borderWidth = 0.5;
    [whiteBgView addSubview:cancelButton];
    
    
    UIButton * sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sureButton.frame = CGRectMake((Screen_Width-30-25-175), Y(cancelButton), 175, 40);
    [sureButton setTitle:@"保存至[发票抬头]" forState:UIControlStateNormal];
    [sureButton setTitle:@"保存至[发票抬头]" forState:UIControlStateHighlighted];
    [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [sureButton addTarget:self action:@selector(sureButtonclick) forControlEvents:UIControlEventTouchUpInside];
    sureButton.backgroundColor = kColorBlue;
    //加圆角
    sureButton.layer.cornerRadius = 3;
    sureButton.clipsToBounds = YES;
    //加边框
//    cancelButton.layer.borderColor = kColorBlue.CGColor;
//    cancelButton.layer.borderWidth = 0.5;
    [whiteBgView addSubview:cancelButton];
    [whiteBgView addSubview:sureButton];
    [whiteBgView setFrameHeight:Y(cancelButton)+60];
}

- (void)cancelButtonClick{
    [self hide];
}
- (void)sureButtonclick{
    if ([_delegate respondsToSelector:@selector(saveInvoiceTitleViewClickSure:)]) {
        [_delegate saveInvoiceTitleViewClickSure:self];
    }
}
-(void)show{
    NSArray *windows = [UIApplication sharedApplication].windows;
    UIWindow *mainWin = windows[0];
    UIWindow *winodw = mainWin;
    for (NSInteger  i = windows.count-1; i >= 0; i--) {
        UIWindow *win = windows[i];
        if (CGRectEqualToRect(win.bounds, mainWin.bounds) && (win.windowLevel == UIWindowLevelNormal)) {
            winodw = win;
            break;
        }
    }
    [winodw addSubview:self];
}
- (void)hide{
    [self removeFromSuperview];
}

@end
