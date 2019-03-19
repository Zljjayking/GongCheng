//
//  DDContractCopyInfo1Cell.m
//  GongChengDD
//
//  Created by xzx on 2018/6/7.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDContractCopyInfo1Cell.h"

@implementation DDContractCopyInfo1Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleLab.textColor=KColorCompanyTitleBalck;
    self.titleLab.font=KFontSize38Bold;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
