//
//  DDECSummaryHeaderView.m
//  GongChengDD
//
//  Created by csq on 2018/6/5.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDECSummaryHeaderView.h"

@implementation DDECSummaryHeaderView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    _bottomView.backgroundColor = [UIColor whiteColor];
    
    _blueView.backgroundColor = kColorBlue;
    
    _titleLab.textColor = KColorBlackTitle;
    _titleLab.font = kFontSize34;
//    _titleLab.textAlignment = NSTextAlignmentCenter;
    
    _markLab.textColor = KColorGreySubTitle;
    _markLab.font = kFontSize24;
    _markLab.textAlignment = NSTextAlignmentCenter;
    
    _arraowImageView.image = [UIImage imageNamed:@"arrow_right"];
    
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer * gesTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gesTapClick)];
    [self addGestureRecognizer:gesTap];
}
- (void)loadWithTitle:(NSString*)title mark:(NSString*)mark section:(NSInteger)section{
    _titleLab.text = title;
    _markLab.text = mark;
    _section = section;
}
- (void)gesTapClick{
    if ([_delegate respondsToSelector:@selector(summaryHeaderViewClick:section:)]) {
        [_delegate summaryHeaderViewClick:self section:_section];
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
