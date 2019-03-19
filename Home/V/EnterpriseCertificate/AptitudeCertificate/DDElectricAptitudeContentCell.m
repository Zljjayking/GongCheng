//
//  DDElectricAptitudeContentCell.m
//  GongChengDD
//
//  Created by csq on 2018/8/24.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDElectricAptitudeContentCell.h"

@implementation DDElectricAptitudeContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _titleLab.font = kFontSize32;
    _titleLab.textColor = KColorBlackTitle;
}
- (void)loadWithModel:(DDSubitemModel*)model{
    //不拼接,直接使用certTypeSource
    _titleLab.text = model.certTypeSource;
}
+ (CGFloat)height{
    return 50;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
