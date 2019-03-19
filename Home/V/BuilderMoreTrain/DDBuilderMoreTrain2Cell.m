//
//  DDBuilderMoreTrain2Cell.m
//  GongChengDD
//
//  Created by xzx on 2018/6/27.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDBuilderMoreTrain2Cell.h"

@implementation DDBuilderMoreTrain2Cell

- (void)awakeFromNib {
    [super awakeFromNib];
        
    self.nameLab.text=@"1.周毅";
    self.nameLab.textColor=KColorBlackTitle;
    self.nameLab.font=kFontSize34;
    
    
    self.tempLab.text=@"临时";
    self.tempLab.textColor=KColorBlackSecondTitle;
    self.tempLab.font=kFontSize24;
    self.tempLab.textAlignment=NSTextAlignmentCenter;
    self.tempLab.layer.borderColor=KColorBlackSecondTitle.CGColor;
    self.tempLab.layer.borderWidth=0.5;
    self.tempLab.layer.cornerRadius=3;
    self.tempLab.clipsToBounds=YES;
    
    
    [self.telBtn setTitle:@"在线报名" forState:UIControlStateNormal];
    [self.telBtn setTitleColor:kColorBlue forState:UIControlStateNormal];
    [self.telBtn setBackgroundColor:kColorWhite];
    self.telBtn.titleLabel.font=kFontSize28;
    self.telBtn.layer.borderColor=kColorBlue.CGColor;
    self.telBtn.layer.borderWidth=1;
    self.telBtn.layer.cornerRadius=3;
    self.telBtn.clipsToBounds=YES;
    
    
    self.telLab.textColor=KColorBlackSubTitle;
    self.telLab.font=kFontSize28;
    
    
    self.majorLab1.text=@"专业:";
    self.majorLab1.textColor=KColorGreySubTitle;
    self.majorLab1.font=kFontSize28;
    
    self.majorLab2.text=@"市政公用工程";
    self.majorLab2.textColor=KColorBlackSubTitle;
    self.majorLab2.font=kFontSize28;
    
    
    self.numberLab1.text=@"证书编号:";
    self.numberLab1.textColor=KColorGreySubTitle;
    self.numberLab1.font=kFontSize28;
    
    self.numberLab2.text=@"苏232111218946";
    self.numberLab2.textColor=KColorBlackSubTitle;
    self.numberLab2.font=kFontSize28;
    
    
    self.haveBLab1.text=@"B类证情况:";
    self.haveBLab1.textColor=KColorGreySubTitle;
    self.haveBLab1.font=kFontSize28;
    
    self.haveBLab2.text=@"有";
    self.haveBLab2.textColor=KColorBlackSubTitle;
    self.haveBLab2.font=kFontSize28;
    
    
    self.timeLab1.text=@"有效期:";
    self.timeLab1.textColor=KColorGreySubTitle;
    self.timeLab1.font=kFontSize28;
    
    self.timeLab2.text=@"2018-04-10";
    self.timeLab2.textColor=KColorBlackSubTitle;
    self.timeLab2.font=kFontSize28;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
