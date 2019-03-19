//
//  DDLoseCreditDetailCell.m
//  GongChengDD
//
//  Created by xzx on 2018/8/7.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDLoseCreditDetailCell.h"

@implementation DDLoseCreditDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleLab.textColor=KColorGreySubTitle;
    self.titleLab.font=kFontSize30;
    
    self.detailLab.textColor=KColorBlackTitle;
    self.detailLab.font=kFontSize30;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
