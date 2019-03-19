//
//  DDSuperVisionReportListCell.m
//  GongChengDD
//
//  Created by xzx on 2018/11/26.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDSuperVisionReportListCell.h"

@implementation DDSuperVisionReportListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _titleLab.textColor = KColorBlackTitle;
    _titleLab.font = kFontSize34;
    
    _numberLab.textColor = KColor000000;
    _numberLab.font = kFontSize30;
    
    _unitLab.text=@"条公开";
    _unitLab.textColor = KColorGreySubTitle;
    _unitLab.font = kFontSize30;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
