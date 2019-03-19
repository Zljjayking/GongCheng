//
//  DDBusinesslicenseTwoTitleCell.m
//  GongChengDD
//
//  Created by csq on 2018/8/10.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDBusinesslicenseTwoTitleCell.h"

@implementation DDBusinesslicenseTwoTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _ceterLine.backgroundColor = KColorTableSeparator;
    
    _leftTitleLab.textColor = KColorGreySubTitle;
    _leftTitleLab.font = kFontSize30;
    
    _leftContentLab.textColor = KColorBlackTitle;
    _leftContentLab.font =  kFontSize32;

    
    _rightLab.textColor = KColorGreySubTitle;
    _rightLab.font = kFontSize30;
    
    _rightContentLab.textColor = KColorBlackTitle;
    _rightContentLab.font =  kFontSize32;
    _rightContentLab.numberOfLines = 0;
//    _rightContentLab.textAlignment = NSTextAlignmentRight;
}
+ (CGFloat)height{
    return 82;
}
- (CGFloat)height{
    CGFloat rightContentLabBottom = BOTTOM(_rightContentLab);
    return  rightContentLabBottom + 15;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
