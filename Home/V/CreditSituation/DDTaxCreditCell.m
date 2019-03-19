//
//  DDTaxCreditCell.m
//  GongChengDD
//
//  Created by xzx on 2018/10/27.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDTaxCreditCell.h"

@implementation DDTaxCreditCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.lineLab1.backgroundColor=KColorTableSeparator;
    self.lineLab2.backgroundColor=KColorTableSeparator;
    
    self.nameLab1.text=@"纳税人名称";
    self.nameLab1.textColor=KColorGreySubTitle;
    self.nameLab1.font=kFontSize30;
    self.nameLab2.text=@"南京和远建筑工程有限公司";
    self.nameLab2.textColor=KColorBlackTitle;
    self.nameLab2.font=kFontSize32;
    
    self.numberLab1.text=@"纳税人识别号";
    self.numberLab1.textColor=KColorGreySubTitle;
    self.numberLab1.font=kFontSize30;
    self.numberLab2.text=@"370104780770419";
    self.numberLab2.textColor=KColorBlackTitle;
    self.numberLab2.font=kFontSize32;
    
    self.yearLab1.text=@"评价年度";
    self.yearLab1.textColor=KColorGreySubTitle;
    self.yearLab1.font=kFontSize30;
    self.yearLab2.text=@"2017";
    self.yearLab2.textColor=KColorBlackTitle;
    self.yearLab2.font=kFontSize32;
    
    self.gradeLab1.text=@"纳税信用级别";
    self.gradeLab1.textColor=KColorGreySubTitle;
    self.gradeLab1.font=kFontSize30;
    self.gradeLab2.text=@"A级";
    self.gradeLab2.textColor=KColorBlackTitle;
    self.gradeLab2.font=kFontSize32;
}

-(void)loadDataWithModel:(DDTaxCreditModel *)model{
    if (![DDUtils isEmptyString:model.taxpayer]) {
        self.nameLab2.text=model.taxpayer;
    }
    else{
        self.nameLab2.text=@"-";
    }
    
    if (![DDUtils isEmptyString:model.taxpayerNum]) {
        self.numberLab2.text=model.taxpayerNum;
    }
    else{
        self.numberLab2.text=@"-";
    }
    
    if (![DDUtils isEmptyString:model.year]) {
        self.yearLab2.text=model.year;
    }
    else{
        self.yearLab2.text=@"-";
    }
    
    if (![DDUtils isEmptyString:model.score]) {
        self.gradeLab2.text=[NSString stringWithFormat:@"%@级",model.score];
    }
    else{
        self.gradeLab2.text=@"-";
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
