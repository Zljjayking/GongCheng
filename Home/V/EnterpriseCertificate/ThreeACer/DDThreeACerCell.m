//
//  DDThreeACerCell.m
//  GongChengDD
//
//  Created by csq on 2018/9/19.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDThreeACerCell.h"
#import "DDDateUtil.h"

@implementation DDThreeACerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _enterpriseNameLab.font = kFontSize32;
    _enterpriseNameLab.textColor = KColorBlackTitle;
    
    _levelMarkLab.text = @"信用等级:";
    _levelMarkLab.font = kFontSize28;
    _levelMarkLab.textColor = KColorGreySubTitle;
    
    _levelLab.font =kFontSize28;
    _levelLab.textColor = KColorGreySubTitle;

    _validityPeriodEndMarkLab.text = @"有效期:";
    _validityPeriodEndMarkLab.font = kFontSize28;
    _validityPeriodEndMarkLab.textColor = KColorGreySubTitle;
    
    _validityPeriodEndLab.font = kFontSize28;
    _validityPeriodEndLab.textColor = KColorGreySubTitle;
}
- (void)loadWithModel:(DDThreeACerListModel*)model{
    _enterpriseNameLab.text = model.enterpriseName;
    _levelLab.text = model.level;
    _validityPeriodEndLab.text = [DDUtils getDateLineByStandardTime:model.validityPeriodEnd];
    
    //AAA证书有效期：半年以上标蓝、半年内标黄、3个月内到期标红
    //过滤掉异常时间
    NSString * resultDateString = [DDDateUtil replaceUnNormalDateString:model.validityPeriodEnd];
    if (![DDUtils isEmptyString:resultDateString]){
        _validityPeriodEndLab.textColor = [DDUtils enterpriseCertificateColorByDateString:resultDateString];
    }
    [self layoutIfNeeded];
}
- (CGFloat)height{
    CGFloat certEndDateLabBottom = BOTTOM(_validityPeriodEndLab);
    return certEndDateLabBottom + 15;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
