//
//  DDSevereIllegalAndAbnormal2Cell.m
//  GongChengDD
//
//  Created by xzx on 2018/10/26.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDSevereIllegalAndAbnormal2Cell.h"

@implementation DDSevereIllegalAndAbnormal2Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.tipLab.text=@"移除经营异常名录原因";
    self.tipLab.textColor=KColorGreySubTitle;
    self.tipLab.font=kFontSize30;
    
    //self.titleLab.text=@"内容";
    self.titleLab.textColor=KColorBlackTitle;
    self.titleLab.font=kFontSize32;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
