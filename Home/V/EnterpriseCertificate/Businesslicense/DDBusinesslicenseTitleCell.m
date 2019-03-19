//
//  DDBusinesslicenseTitleCell.m
//  GongChengDD
//
//  Created by csq on 2018/8/10.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDBusinesslicenseTitleCell.h"

@implementation DDBusinesslicenseTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleLab.textColor = KColorGreySubTitle;
    self.titleLab.font = kFontSize30;
//    self.titleLab.backgroundColor = [UIColor redColor];
    self.titleLab.numberOfLines = 0;
    
    self.contentLab.textColor = KColorBlackTitle;
    self.contentLab.font =  kFontSize32;
    self.contentLab.numberOfLines = 0;
//    self.contentLab.backgroundColor = [UIColor blueColor];
    
    self.topLine.backgroundColor = KColorTableSeparator;
    self.topLine.hidden = YES;//默认隐藏
    
    self.bottomLine.backgroundColor = KColorTableSeparator;
    self.bottomLine.hidden = YES;//默认隐藏
}
- (void)loadWithContent:(NSString*)content{
    if ([DDUtils isEmptyString:content]) {
        _contentLab.text = @"-";
    }else{
        _contentLab.text = content;
    }
    [self layoutIfNeeded];
}
+ (CGFloat)heightWithContent:(NSString*)content{
    if ([DDUtils isEmptyString:content]) {
        return 88;
    }else{
        CGFloat contentHeight = [DDUtils heightForText:content withTextWidth:Screen_Width-24 withFont:kFontSize32];
        return contentHeight + 68;
    }
}
- (CGFloat)height{

    CGFloat contentLabBoottom = BOTTOM(_contentLab);
    return contentLabBoottom +18;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
