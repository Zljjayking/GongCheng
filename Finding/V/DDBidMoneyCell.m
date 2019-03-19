//
//  DDBidMoneyCell.m
//  GongChengDD
//
//  Created by csq on 2018/11/6.
//  Copyright © 2018 Koncendy. All rights reserved.
//

#import "DDBidMoneyCell.h"

@implementation DDBidMoneyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _titleLab.textColor = KColorBlackTitle;
    _titleLab.font = kFontSize32;
    _titleLab.text = @"中标金额";
    
    _greaterThanLab.textColor = KColorBlackTitle;
    _greaterThanLab.font = kFontSize30;
    _greaterThanLab.text = @"至";
    
    _unitLab.textColor = KColorGreySubTitle;
    _unitLab.font = kFontSize30;
    _unitLab.text = @"万元";
    
    _unit2Lab.textColor = KColorGreySubTitle;
    _unit2Lab.font = kFontSize30;
    _unit2Lab.text = @"万元";
    
    _minMoneyTextField.font = kFontSize30;
    _minMoneyTextField.textColor = KColorBlackTitle;
    _minMoneyTextField.layer.borderColor = KColorTableSeparator.CGColor;
    _minMoneyTextField.layer.borderWidth = 0.5;
    
    _maxMoneyTextFileld.font = kFontSize30;
    _maxMoneyTextFileld.textColor = KColorBlackTitle;
    _maxMoneyTextFileld.layer.borderWidth = 0.5;
    _maxMoneyTextFileld.layer.borderColor = KColorTableSeparator.CGColor;
}
- (void)loadWithMinMoney:(NSString*)minMoney maxMoney:(NSString*)maxMoney{
    _minMoneyTextField.text = minMoney;
    _maxMoneyTextFileld.text = maxMoney;
}
+(CGFloat)height{
    return 44;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
