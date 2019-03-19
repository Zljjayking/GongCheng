//
//  DDMySencondBuilderHeaderView.m
//  GongChengDD
//
//  Created by csq on 2018/7/31.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDMySencondBuilderHeaderView.h"

@implementation DDMySencondBuilderHeaderView
- (void)awakeFromNib{
    [super awakeFromNib];
    
    _specialityMarkLab.textColor = KColorGreySubTitle;
//    _specialityMarkLab.backgroundColor = kColorBlue;
    _certNoMarkLab.textColor = KColorGreySubTitle;
    _hasBCerMarkLab.textColor = KColorGreySubTitle;
    _validityMarkLab.textColor = KColorGreySubTitle;
    
    _specialityLab.textColor = KColorBlackSubTitle;
    _certNoLab.textColor = KColorBlackSubTitle;
    _hasBCerLab.textColor = KColorBlackSubTitle;
//    _validityLab.textColor = KColorBlackSubTitle;
    
    _signUpLab.textColor = KColorGreySubTitle;
    _signUpLab.hidden = YES;
    
    _signUpButton.hidden = YES;

    //加圆角
    _signUpButton.layer.cornerRadius = 2;
    _signUpButton.clipsToBounds = YES;
    //加边框
    _signUpButton.layer.borderColor = kColorBlue.CGColor;
    _signUpButton.layer.borderWidth = 0.5;
    [_signUpButton addTarget:self action:@selector(signUpButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_signUpButton setTitleColor:kColorBlue forState:UIControlStateNormal];
    
    _residueBgImageView.image = [UIImage imageNamed:@"myinfo_reside"];
    _residueMarkLab.textColor = KColorOrangeSubTitle;
    _residueMarkLab.textAlignment = NSTextAlignmentCenter;
    
    _residueDayLab.textColor = KColorOrangeSubTitle;
    _residueDayLab.font = kFontSize28;
    _residueDayLab.textAlignment = NSTextAlignmentCenter;
}

- (void)signUpButtonClick:(UIButton*)sender{
   // 在线报名
    if ([_delegate respondsToSelector:@selector(mySencondBuilderHeaderViewClickReSignup:)]) {
        [_delegate mySencondBuilderHeaderViewClickReSignup:self];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
