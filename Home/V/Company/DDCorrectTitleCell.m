//
//  DDCorrectTitleCell.m
//  GongChengDD
//
//  Created by csq on 2018/5/29.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDCorrectTitleCell.h"

@implementation DDCorrectTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _titleLab.font = kFontSize32;
    _titleLab.textColor = KColorBlackTitle;
    
    _subTitleLab.font = kFontSize28;
    _subTitleLab.textColor = KColorBlackTitle;
    
}
- (void)loadWithTitle:(NSString*)title subTitle:(NSString*)subTitle{
    _titleLab.text = title;
    _subTitleLab.text = subTitle;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
