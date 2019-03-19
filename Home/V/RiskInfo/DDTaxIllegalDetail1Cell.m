//
//  DDTaxIllegalDetail1Cell.m
//  GongChengDD
//
//  Created by xzx on 2018/10/26.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDTaxIllegalDetail1Cell.h"

@implementation DDTaxIllegalDetail1Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.firstLab.textColor=KColorGreySubTitle;
    self.firstLab.font=kFontSize30;
    
    self.secondLab.textColor=KColorBlackTitle;
    self.secondLab.font=kFontSize32;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
