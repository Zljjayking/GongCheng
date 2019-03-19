//
//  DDBuyCompanyDetail3Cell.m
//  GongChengDD
//
//  Created by xzx on 2018/5/30.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDBuyCompanyDetail3Cell.h"

@implementation DDBuyCompanyDetail3Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.codeLab1.text=@"工商信用代码";
    self.codeLab1.textColor=KColorBlackSubTitle;
    self.codeLab1.font=kFontSize28;
    
    self.codeLab2.text=@"914*************";
    self.codeLab2.textColor=KColorBlackSubTitle;
    self.codeLab2.font=kFontSize28;
    
    
    self.addressLab1.text=@"所在区域";
    self.addressLab1.textColor=KColorBlackSubTitle;
    self.addressLab1.font=kFontSize28;
    
    self.addressLab2.text=@"江苏-南京-浦口区";
    self.addressLab2.textColor=KColorBlackSubTitle;
    self.addressLab2.font=kFontSize28;
    
    
    self.typeLab1.text=@"企业类型";
    self.typeLab1.textColor=KColorBlackSubTitle;
    self.typeLab1.font=kFontSize28;
    
    self.typeLab2.text=@"有限责任公司";
    self.typeLab2.textColor=KColorBlackSubTitle;
    self.typeLab2.font=kFontSize28;
    
    
    self.debtLab1.text=@"债权债务";
    self.debtLab1.textColor=KColorBlackSubTitle;
    self.debtLab1.font=kFontSize28;
    
    self.debtLab2.text=@"无";
    self.debtLab2.textColor=KColorBlackSubTitle;
    self.debtLab2.font=kFontSize28;
    
    
    self.lawLab1.text=@"法律纠纷";
    self.lawLab1.textColor=KColorBlackSubTitle;
    self.lawLab1.font=kFontSize28;
    
    self.lawLab2.text=@"无";
    self.lawLab2.textColor=KColorBlackSubTitle;
    self.lawLab2.font=kFontSize28;
    
    
    
    self.loanLab1.text=@"贷款问题";
    self.loanLab1.textColor=KColorBlackSubTitle;
    self.loanLab1.font=kFontSize28;
    
    self.loanLab2.text=@"有";
    self.loanLab2.textColor=KColorBlackSubTitle;
    self.loanLab2.font=kFontSize28;
    
    
    
    self.projectLab1.text=@"在建项目";
    self.projectLab1.textColor=KColorBlackSubTitle;
    self.projectLab1.font=kFontSize28;
    
    self.projectLab2.text=@"有";
    self.projectLab2.textColor=KColorBlackSubTitle;
    self.projectLab2.font=kFontSize28;
    
    
    
    self.assureLab1.text=@"担保";
    self.assureLab1.textColor=KColorBlackSubTitle;
    self.assureLab1.font=kFontSize28;
    
    self.assureLab2.text=@"有";
    self.assureLab2.textColor=KColorBlackSubTitle;
    self.assureLab2.font=kFontSize28;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
