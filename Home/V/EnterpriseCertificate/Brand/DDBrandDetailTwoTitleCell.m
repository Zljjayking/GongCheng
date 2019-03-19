//
//  DDBrandDetailTwoTitleCell.m
//  GongChengDD
//
//  Created by csq on 2018/9/25.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDBrandDetailTwoTitleCell.h"

@implementation DDBrandDetailTwoTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _topLine.backgroundColor = KColorTableSeparator;
    
    _titleLab.font = kFontSize30;
    _titleLab.textColor = KColorGreySubTitle;
    _titleLab.textAlignment = NSTextAlignmentLeft;
    
    _contentLab.font = kFontSize32;
    _contentLab.textColor = KColorBlackTitle;
    _contentLab.textAlignment = NSTextAlignmentLeft;
    _contentLab.numberOfLines = 0;
    
    _arrow.image = [UIImage imageNamed:@"arrow_right"];
}
- (void)loadWithTitle:(NSString*)title content:(NSString*)content{
    _titleLab.text = title;
    _contentLab.text = content;
    
    [self layoutIfNeeded];
}
- (CGFloat)height{
    CGFloat contentBottom = BOTTOM(_contentLab);
    return contentBottom+17;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
