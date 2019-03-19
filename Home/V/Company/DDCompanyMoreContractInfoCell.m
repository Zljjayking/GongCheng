//
//  DDCompanyMoreContractInfoCell.m
//  GongChengDD
//
//  Created by xzx on 2018/6/14.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDCompanyMoreContractInfoCell.h"

@implementation DDCompanyMoreContractInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.contentLab1.textColor=KColorBlackTitle;
    self.contentLab1.font=kFontSize34;
    
    self.contentLab2.font=kFontSize28;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
