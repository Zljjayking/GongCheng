//
//  DDOtherAptitudeCerFootSecondView.m
//  GongChengDD
//
//  Created by csq on 2018/8/29.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDOtherAptitudeCerFootSecondView.h"

@implementation DDOtherAptitudeCerFootSecondView
- (void)awakeFromNib{
    [super awakeFromNib];
    _topTitleLab.textColor = KColorGreySubTitle;
    _topTitleLab.font = kFontSize28;
    
    _topContentLab.textColor = KColorBlackTitle;
    _topContentLab.font = kFontSize32;
    
    _centerTitleLab.textColor = KColorGreySubTitle;
    _centerTitleLab.font = kFontSize28;
    
    _centerContentLab.textColor = KColorBlackTitle;
    _centerContentLab.font = kFontSize32;
    
    _bottomTitleLab.textColor = KColorGreySubTitle;
    _bottomTitleLab.font = kFontSize28;
    
    _bottomContentLab.textColor = KColorBlackTitle;
    _bottomContentLab.font = kFontSize32;
    
    _timeLab.textColor = kColorBlue;
    _timeLab.font = kFontSize32;
    
    _line.backgroundColor = KColorTableSeparator;
    
    [_actionButton setTitleColor:kColorBlue forState:UIControlStateNormal];
    _actionButton.titleLabel.font = kFontSize30;
}

+(CGFloat)height{
    return 281;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
