//
//  DDTaxIllegalDetail2Cell.m
//  GongChengDD
//
//  Created by xzx on 2018/10/26.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDTaxIllegalDetail2Cell.h"

@implementation DDTaxIllegalDetail2Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.leftFirstLab.textColor=KColorGreySubTitle;
    self.leftFirstLab.font=kFontSize30;
    
    self.leftSecondLab.textColor=KColorBlackTitle;
    self.leftSecondLab.font=kFontSize32;

    self.rightFirstLab.textColor=KColorGreySubTitle;
    self.rightFirstLab.font=kFontSize30;
    
    self.rightSecondLab.textColor=KColorBlackTitle;
    self.rightSecondLab.font=kFontSize32;
    
    self.lineLab.backgroundColor=KColorTableSeparator;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
