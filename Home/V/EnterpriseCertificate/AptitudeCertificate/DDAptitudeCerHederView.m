//
//  DDAptitudeCerHederView.m
//  GongChengDD
//
//  Created by csq on 2018/5/25.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDAptitudeCerHederView.h"
#import "DDDateUtil.h"

@implementation DDAptitudeCerHederView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    _topView.backgroundColor = kColorBackGroundColor;
    
    _blueLine.backgroundColor = kColorBlue;
    
    _titleLab.font = kFontSize34;
    _titleLab.textColor = KColorBlackTitle;
    
    _subTitleLab.font = kFontSize28;
    _subTitleLab.textColor = KColorGreySubTitle;
    
    _bottomLine.backgroundColor = KColorTableSeparator;
    
    _timeLab.font = kFontSize26;
    
}
- (void)loadWithModel:(DDAptitudeCerModel*)model{
    _titleLab.text = model.certNo;
    _subTitleLab.text = model.issuedDeptSource;
    
    NSString * time = [DDUtils getDateLineByStandardTime:model.validityPeriodEnd];
    _timeLab.text = [NSString stringWithFormat:@"%@到期",time];
    
    //资质证书有效期:一年以上标蓝、一年内标黄、3个月内到期标红
    //资质证书有效期:一年以上标蓝(0x25a5fe)、一年内标黄(0xff873f)、3个月内到期标红(0xff2020)
    NSInteger mouth = [DDDateUtil monthByEndString:model.validityPeriodEnd];
    if (mouth >=3 && mouth<12){
        _timeLab.textColor = kColorGiveUpBidOrange;
    }else if (mouth >= 12){
        _timeLab.textColor = kColorBlue;
    }else{
        _timeLab.textColor =kColorRed;
    }
}
+(CGFloat)height{
    return 85;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
