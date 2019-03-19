//
//  DDDoubleTitleView.m
//  GongChengDD
//
//  Created by csq on 2017/11/30.
//  Copyright © 2017年 Koncendy. All rights reserved.
//

#import "DDDoubleTitleView.h"

@implementation DDDoubleTitleView
{
    UILabel * _titleLabel;
    UILabel * _subTitleLabel;
}

-(instancetype)init{
    self = [super init];
    
    if(self){
        self.frame = CGRectMake(0, 0, Screen_Width-140, 44);
        self.backgroundColor = [UIColor clearColor];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self), 21)];
        _titleLabel.font = kFontSize36Bold;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = UIColorFromRGB(0x111111);
        [self addSubview:_titleLabel];
        
        _subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, BOTTOM(_titleLabel), WIDTH(self), 21)];
        _subTitleLabel.font = kFontSize24;
        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _subTitleLabel.textColor = UIColorFromRGB(0x111111);
        [self addSubview:_subTitleLabel];
        
    }
    return self;
}

-(void)setTitle:(NSString *)title subTitle:(NSString*)subTitle{
    _titleLabel.text = title;
    _subTitleLabel.text = subTitle;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
