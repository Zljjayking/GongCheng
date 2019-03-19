//
//  DDSevereIllegalAndAbnormal1Cell.m
//  GongChengDD
//
//  Created by xzx on 2018/10/26.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDSevereIllegalAndAbnormal1Cell.h"

@implementation DDSevereIllegalAndAbnormal1Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.tipLab.text=@"移除经营异常名录原因";
    self.tipLab.textColor=KColorGreySubTitle;
    self.tipLab.font=kFontSize30;
    
    self.timeLab.text=@"2017-07-12";
    self.timeLab.textColor=KColorGreySubTitle;
    self.timeLab.font=kFontSize30;
    
    self.statusLab.text=@"移出";
    self.statusLab.textColor=kColorBlue;
    self.statusLab.font=kFontSize24;
    self.statusLab.layer.cornerRadius=3;
    self.statusLab.layer.borderColor=kColorBlue.CGColor;
    self.statusLab.layer.borderWidth=0.5;
    self.statusLab.textAlignment=NSTextAlignmentCenter;
    
    //self.titleLab.text=@"内容";
    self.titleLab.textColor=KColorBlackTitle;
    self.titleLab.font=kFontSize32;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
