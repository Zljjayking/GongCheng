//
//  DDCompanyDetailCreditScoreCell.m
//  GongChengDD
//
//  Created by xzx on 2018/9/19.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDCompanyDetailCreditScoreCell.h"

@implementation DDCompanyDetailCreditScoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.lab1.text=@"信用分";
    self.lab1.textColor=KColorBlackTitle;
    self.lab1.font=kFontSize30;
    
    self.lab2.text=@"(共";
    self.lab2.textColor=KColorBlackTitle;
    self.lab2.font=kFontSize28;
    
    self.numLab.text=@"3";
    self.numLab.textColor=kColorBlue;
    self.numLab.font=kFontSize28;
    
    self.lab3.text=@"个主管部门评价)";
    self.lab3.textColor=KColorBlackTitle;
    self.lab3.font=kFontSize28;
    
    self.scoreLab.text=@"97分";
    self.scoreLab.textColor=kColorBlue;
    self.scoreLab.font=kFontSize30;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
