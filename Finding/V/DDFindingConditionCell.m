//
//  DDFindingConditionCell.m
//  GongChengDD
//
//  Created by csq on 2018/11/6.
//  Copyright © 2018 Koncendy. All rights reserved.
//

#import "DDFindingConditionCell.h"

@implementation DDFindingConditionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _titleLab.textColor = KColorBlackTitle;
    _titleLab.font = kFontSize32;
    
//    _subTitleLab.textColor = KColorBlackTitle;
    _subTitleLab.font = kFontSize30;
    _subTitleLab.textAlignment = NSTextAlignmentRight;
    
    _arrow.image = [UIImage imageNamed:@"arrow_right"];
    
    _line.backgroundColor = KColorTableSeparator;
}
- (void)loadWithTitle:(NSString*)title subTitle:(nullable NSString*)subTitle{
    _titleLab.text = title;
    
    if (NO == [DDUtils isEmptyString:subTitle]) {
        _subTitleLab.text = subTitle;
        _subTitleLab.textColor = KColorBlackTitle;
    }else{
        _subTitleLab.text = @"请选择";
        _subTitleLab.textColor = KColorBidApprovalingWait;
    }
}
+ (CGFloat)height{
    return 47.5;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
