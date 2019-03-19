//
//  DDBusinessLicenseChangeSectionView.m
//  GongChengDD
//
//  Created by csq on 2018/8/6.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDBusinessLicenseChangeSectionView.h"

@implementation DDBusinessLicenseChangeSectionView

- (void)awakeFromNib{
    [super awakeFromNib];
    _titleLab.textColor =  KColorBlackSubTitle;
    _titleLab.font = kFontSize36;
    _titleLab.textAlignment = NSTextAlignmentCenter;
    _titleLab.backgroundColor = kColorBackGroundColor;
    _titleLab.layer.cornerRadius = 3;
    _titleLab.clipsToBounds = YES;
    
    _subTitleLab.textColor = KColorBlackSubTitle;
    _subTitleLab.font = kFontSize30;
    _subTitleLab.numberOfLines = 0;
    
    _dateLab.textColor = KColorGreySubTitle;
    _dateLab.font = kFontSize28;
    
}
- (void)loadWithModel:(DDBusinessLicenseChangeModel*)model section:(NSInteger)section{
    _titleLab.text  = [NSString stringWithFormat:@"%ld",(section+1)];
    
    _subTitleLab.text = [NSString stringWithFormat:@"%@",model.changeItem];
    _dateLab.hidden = NO;
    _dateLab.text = [NSString stringWithFormat:@"%@",[model.changeTime substringToIndex:10]];
    [self layoutIfNeeded];
}
- (void)loadWithModel2:(DDBusinessLicenseChangeModel*)model section:(NSInteger)section{
    _titleLab.text  = [NSString stringWithFormat:@"%ld",(section+1)];
    
    _subTitleLab.text = model.changeTime;
    _subTitleLab.textColor = KColorGreySubTitle;
    _subTitleLab.font = kFontSize28;
    _dateLab.hidden = YES;
    
    [self layoutIfNeeded];
}
+ (CGFloat)height{
    return 60;
}

- (CGFloat)height{
    CGFloat subTitleLabBottom = BOTTOM(_subTitleLab);
    return subTitleLabBottom+20;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
