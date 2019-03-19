//
//  DDFireEngineerDetail2Cell.m
//  GongChengDD
//
//  Created by xzx on 2018/9/25.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDFireEngineerDetail2Cell.h"

@implementation DDFireEngineerDetail2Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLab.textColor=KColorBlackTitle;
    self.titleLab.font=kFontSize32;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
