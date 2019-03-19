//
//  DDBuildersPayEnsure2Cell.m
//  GongChengDD
//
//  Created by xzx on 2018/6/28.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDBuildersPayEnsure2Cell.h"

@implementation DDBuildersPayEnsure2Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleLab1.text=@"教材领取方式-邮寄";
    self.titleLab1.textColor=KColorBlackTitle;
    self.titleLab1.font=kFontSize32;
    
    self.titleLab2.text=@"快递费";
    self.titleLab2.textColor=KColorGreySubTitle;
    self.titleLab2.font=kFontSize26;
    
    self.moneyLab.text=@"¥15";
    self.moneyLab.textColor=kColorBlue;
    self.moneyLab.font=kFontSize32;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
