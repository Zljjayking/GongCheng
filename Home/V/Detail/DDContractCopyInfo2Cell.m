//
//  DDContractCopyInfo2Cell.m
//  GongChengDD
//
//  Created by xzx on 2018/6/7.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDContractCopyInfo2Cell.h"

@implementation DDContractCopyInfo2Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.leftLab1.textColor=KColorGreySubTitle;
    self.leftLab1.font=kFontSize28;
    
    self.leftLab2.textColor=KColorGreySubTitle;
    self.leftLab2.font=kFontSize28;
    
    self.rightLab1.textColor=KColorBlackSubTitle;
    self.rightLab1.font=kFontSize30;
    
    self.rightLab2.textColor=KColorBlackSubTitle;
    self.rightLab2.font=kFontSize30;
    
    self.attachLab.textColor=KColorBlackSubTitle;
    self.attachLab.font=kFontSize30;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
