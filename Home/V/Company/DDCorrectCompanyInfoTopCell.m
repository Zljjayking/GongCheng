//
//  DDCorrectCompanyInfoTopCell.m
//  GongChengDD
//
//  Created by csq on 2018/5/29.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDCorrectCompanyInfoTopCell.h"

@implementation DDCorrectCompanyInfoTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    _titleLab.textColor = KColorGreySubTitle;
    _titleLab.font = kFontSize26;
    _titleLab.text = @"认领公司,得到更精准的服务";

    _actionButton.backgroundColor = [UIColor clearColor];
    [_actionButton setTitle:@"去认领" forState:UIControlStateNormal];
    [_actionButton setTitleColor:kColorBlue forState:UIControlStateNormal];
    [_actionButton setImage:[UIImage imageNamed:@"home_ error _arrow"] forState:UIControlStateNormal];
    [_actionButton layoutButtonWithEdgeInsetsStyle:YFButtonInsetsStyleRight imageTitleSpace:0];
    [_actionButton addTarget:self action:@selector(actionButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
    _actionButton.titleLabel.font = kFontSize26;
    
    _line.backgroundColor = KColorTableSeparator;
}

- (void)actionButtonOnClick{
    if ([_delegate respondsToSelector:@selector(actionButtonClick:)]) {
        [_delegate actionButtonClick:self];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
