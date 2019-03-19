//
//  DDAllTypesEditCell.m
//  GongChengDD
//
//  Created by xzx on 2018/5/26.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDAllTypesEditCell.h"

@implementation DDAllTypesEditCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleLab.textColor=KColorBlackTitle;
    self.titleLab.font=kFontSize26;
    
    self.indicatorImg.layer.cornerRadius=7.5;
    self.indicatorImg.clipsToBounds=YES;
}

@end
