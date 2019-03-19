//
//  DDAddCompanyAttentionCell.m
//  GongChengDD
//
//  Created by csq on 2018/5/25.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDAddCompanyAttentionCell.h"

@implementation DDAddCompanyAttentionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _titleLab.font = kFontSize30;
    _titleLab.textColor = KColorBlackSubTitle;
}

- (void)loadWithTitle:(NSString*)title isSelected:(BOOL)isSelected{
    _titleLab.text = title;
    
    if (YES == isSelected) {
        _selectImageView.image = [UIImage imageNamed:@"myinfo_select"];
        
    }else{
        _selectImageView.image = [UIImage imageNamed:@"myinfo_unselect"];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
