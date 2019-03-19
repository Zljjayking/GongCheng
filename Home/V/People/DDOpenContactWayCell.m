//
//  DDOpenContactWayCell.m
//  GongChengDD
//
//  Created by xzx on 2018/11/29.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDOpenContactWayCell.h"

@implementation DDOpenContactWayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.lab1.text=@"手机号码";
    self.lab1.textColor=KColorBlackTitle;
    self.lab1.font=kFontSize32;
    
    self.lab2.textColor=KColorBlackTitle;
    self.lab2.font=kFontSize30;
    
    [self.changeBtn setTitle:@"修改" forState:UIControlStateNormal];
    [self.changeBtn setTitleColor:kColorBlue forState:UIControlStateNormal];
    self.changeBtn.titleLabel.font=kFontSize30;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
