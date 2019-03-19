//
//  DDTrainInputPersonalInfoCell.m
//  GongChengDD
//
//  Created by xzx on 2018/7/9.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDTrainInputPersonalInfoCell.h"

@implementation DDTrainInputPersonalInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleLab.textColor=KColorBlackTitle;
    self.titleLab.font=kFontSize32;
    
    self.textField.borderStyle=UITextBorderStyleNone;
    self.textField.clearButtonMode=UITextFieldViewModeAlways;
    
    [self.textField setValue:KColorBidApprovalingWait forKeyPath:@"_placeholderLabel.textColor"];
    [self.textField setValue:kFontSize30 forKeyPath:@"_placeholderLabel.font"];
    self.textField.font=kFontSize30;
    self.textField.textColor=KColorBlackSubTitle;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
