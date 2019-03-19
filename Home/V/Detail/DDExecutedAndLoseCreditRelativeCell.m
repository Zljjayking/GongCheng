//
//  DDExecutedAndLoseCreditRelativeCell.m
//  GongChengDD
//
//  Created by xzx on 2018/10/31.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDExecutedAndLoseCreditRelativeCell.h"

@implementation DDExecutedAndLoseCreditRelativeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    //self.nameLab.text=@"李和远";
    self.nameLab.textColor=KColorBlackTitle;
    self.nameLab.font=kFontSize34;
    
    
    
    self.numLab1.text=@"执行标的:";
    self.numLab1.textColor=KColorGreySubTitle;
    self.numLab1.font=kFontSize28;
    //self.numLab2.text=@"(2018)粤0306执4964号";
    self.numLab2.textColor=KColorGreySubTitle;
    self.numLab2.font=kFontSize28;
    
    self.courtLab1.text=@"执行法院:";
    self.courtLab1.textColor=KColorGreySubTitle;
    self.courtLab1.font=kFontSize28;
    //self.courtLab2.text=@"深圳市宝安区人民法院";
    self.courtLab2.textColor=KColorGreySubTitle;
    self.courtLab2.font=kFontSize28;
    
    self.timeLab1.text=@"立案时间:";
    self.timeLab1.textColor=KColorGreySubTitle;
    self.timeLab1.font=kFontSize28;
    //self.timeLab2.text=@"2018-03-29";
    self.timeLab2.textColor=KColorGreySubTitle;
    self.timeLab2.font=kFontSize28;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
