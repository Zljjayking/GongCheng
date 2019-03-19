//
//  DDFindingCondition2Cell.m
//  GongChengDD
//
//  Created by xzx on 2018/11/26.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDFindingCondition2Cell.h"

@implementation DDFindingCondition2Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.textLab.text=@"项目名称";
    self.textLab.font = kFontSize32;
    self.textLab.textColor=KColorBlackTitle;
    
    self.inputField.placeholder=@"请输入业绩标题关键词";
    self.inputField.font=kFontSize30;
    self.inputField.textColor=KColorBlackTitle;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
