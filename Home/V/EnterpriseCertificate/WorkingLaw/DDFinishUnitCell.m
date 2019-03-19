//
//  DDFinishUnitCell.m
//  GongChengDD
//
//  Created by csq on 2018/9/20.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDFinishUnitCell.h"

@implementation DDFinishUnitCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _contentLab.textColor = KColorBlackTitle;
    _contentLab.font = kFontSize32;
}
- (void)loadWithContent:(NSString*)content{
    _contentLab.text = content;
    [self layoutIfNeeded];
}

- (CGFloat)height{
    CGFloat contentLabBottom = BOTTOM(_contentLab);
    return contentLabBottom + 7.5;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
