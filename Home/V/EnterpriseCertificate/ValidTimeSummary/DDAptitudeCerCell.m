//
//  DDAptitudeCerCell.m
//  GongChengDD
//
//  Created by csq on 2018/8/23.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDAptitudeCerCell.h"
#import "DDDateUtil.h"

@implementation DDAptitudeCerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _cerNumLab.textColor = KColorBlackTitle;
    _cerNumLab.font = kFontSize32;
    
    _timeLab.textColor = KColorGreySubTitle;
    _timeLab.font = kFontSize28;
    
    _daysLab.textColor = UIColorFromRGB(0xff9801);
    _daysLab.font = kFontSize54;
    _daysLab.textAlignment = NSTextAlignmentCenter;
    
    _subDaysLab.textColor = UIColorFromRGB(0xff9801);
    _subDaysLab.font = kFontSize18;

    
    
    _markLab.textColor = kColorBlue;
    _markLab.font = kFontSize24;
    _markLab.textAlignment = NSTextAlignmentCenter;
    //加圆角
    _markLab.layer.cornerRadius = 2;
    _markLab.clipsToBounds = YES;
    //加边框
    _markLab.layer.borderColor = kColorBlue.CGColor;
    _markLab.layer.borderWidth = 0.5;
    
}
//资质证书有效期
- (void)loadCellWithQualificationValidityModel:(QualificationValidityModel *)model{
    
    _cerNumLab.text = model.certNo;
    
    //过滤掉异常时间
    NSString * resultDateString = [DDDateUtil replaceUnNormalDateString:model.validityPeriodEnd];
    if (![DDUtils isEmptyString:resultDateString]){
        _timeLab.text = [DDUtils getDateLineByStandardTime:resultDateString];
    }
    
    _markLab.text = @"到期";
    
    _subDaysLab.text = @"天";
    
    //计算到期时间和现在的间隔
    NSInteger days =  [DDUtils getDaysByEndTime:model.validityPeriodEnd];
    _daysLab.text = [NSString stringWithFormat:@"%ld",days];
    
    //如果天数是负数,_daysLab和_subDaysLab改成灰色
    if (days<0) {
        _daysLab.textColor = kColorRed;
        _subDaysLab.textColor = kColorRed;
    }else{
        _daysLab.textColor = UIColorFromRGB(0xff9801);
        _subDaysLab.textColor = UIColorFromRGB(0xff9801);
    }
}
+(CGFloat)height{
    return 89;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
