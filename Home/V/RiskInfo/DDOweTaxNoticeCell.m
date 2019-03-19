//
//  DDOweTaxNoticeCell.m
//  GongChengDD
//
//  Created by xzx on 2018/10/26.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDOweTaxNoticeCell.h"

@implementation DDOweTaxNoticeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.line1.backgroundColor=KColorTableSeparator;
    self.line2.backgroundColor=KColorTableSeparator;
    
    self.numberLab1.text=@"纳税人识别号";
    self.numberLab1.textColor=KColorGreySubTitle;
    self.numberLab1.font=kFontSize30;
    
    self.numberLab2.text=@"370104780770419";
    self.numberLab2.textColor=KColorBlackTitle;
    self.numberLab2.font=kFontSize32;
    
    self.timeLab1.text=@"发布时间";
    self.timeLab1.textColor=KColorGreySubTitle;
    self.timeLab1.font=kFontSize30;
    
    self.timeLab2.text=@"2016-10-01";
    self.timeLab2.textColor=KColorBlackTitle;
    self.timeLab2.font=kFontSize32;
    
    self.kindLab1.text=@"欠税税种";
    self.kindLab1.textColor=KColorGreySubTitle;
    self.kindLab1.font=kFontSize30;
    
    self.kindLab2.text=@"企业所得税";
    self.kindLab2.textColor=KColorBlackTitle;
    self.kindLab2.font=kFontSize32;
    
    self.moneyLab1.text=@"欠税余额";
    self.moneyLab1.textColor=KColorGreySubTitle;
    self.moneyLab1.font=kFontSize30;
    
    self.moneyLab2.text=@"-";
    self.moneyLab2.textColor=KColorBlackTitle;
    self.moneyLab2.font=kFontSize32;
    
    self.deptLab1.text=@"税务机关";
    self.deptLab1.textColor=KColorGreySubTitle;
    self.deptLab1.font=kFontSize30;
    
    self.deptLab2.text=@"青岛市地方税务局市北分局";
    self.deptLab2.textColor=KColorBlackTitle;
    self.deptLab2.font=kFontSize32;
}

-(void)loadDataWithModel:(DDOweTaxNoticeModel *)model{
    self.numberLab2.text=model.taxpayerNum;
    self.numberLab2.adjustsFontSizeToFitWidth=YES;
    self.numberLab2.minimumScaleFactor=0.5;
    
    self.timeLab2.text=model.publishTime;
    self.kindLab2.text=model.type;
    self.moneyLab2.text=model.balance;
    self.deptLab2.text=model.department;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
