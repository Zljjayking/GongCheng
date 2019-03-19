//
//  DDPeopleSummaryType2Cell.m
//  GongChengDD
//
//  Created by csq on 2018/10/26.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDPeopleSummaryType2Cell.h"

@implementation DDPeopleSummaryType2Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    
    _nameLab.textColor = KColorBlackTitle;
    _nameLab.font = kFontSize34;
    
    _typeNameLab.textColor = KColorBlackSubTitle;
    _typeNameLab.font = kFontSize28;
    
    
    _cerNumMarkLab.textColor = KColorGreySubTitle;
    _cerNumMarkLab.font = kFontSize28;
//    _cerNumMarkLab.text = @"证书编号:";
    
    _cerNumLab.textColor = KColorBlackSubTitle;
    _cerNumLab.font = kFontSize28;
    
    
    _registerNumMarkLab.textColor = KColorGreySubTitle;
    _registerNumMarkLab.font = kFontSize28;
//    _registerNumMarkLab.text = @"注册编号:";
    
    _registerNumLab.textColor = KColorBlackSubTitle;
    _registerNumLab.font = kFontSize28;
    
    
    _validityPeriodEndMarkLab.text = @"有效期:";
    _validityPeriodEndMarkLab.textColor = KColorGreySubTitle;
    _validityPeriodEndMarkLab.font = kFontSize28;
}
-(void)loadWithModel:(DDPeopleSummaryModel *)model indexPath:(NSIndexPath *)indexPath{
    
    _cerNumMarkLab.text = @"证书编号:";
    
    _registerNumMarkLab.text = @"注册编号:";
    
    NSInteger  newIndex = indexPath.section +1;
    _nameLab.text = [NSString stringWithFormat:@"%ld.%@",newIndex,model.name];
    
    _typeNameLab.text = [NSString stringWithFormat:@"(%@)",model.typeName];
    
    _cerNumLab.text = model.certNo;
    
    _registerNumLab.text = model.registeredNo;
    
    _validityPeriodEndLab.text = model.validityPeriodEnd;
    //已过期:红色  90内过期:橙黄  超过90日:蓝色
    
    NSString *resultStr = [DDUtils newCompareTimeSpaceIn90:model.validityPeriodEnd];
    if ([resultStr isEqualToString:@"2"]) {
        _validityPeriodEndLab.textColor=kColorBlue;
    }else if ([resultStr isEqualToString:@"1"]){
        _validityPeriodEndLab.textColor=KColorTextOrange;
    } else{
        _validityPeriodEndLab.textColor=kColorRed;
    }
}
//消防
- (void)loadFireControlWithModel:(DDPeopleSummaryModel *)model indexPath:(NSIndexPath *)indexPath{
    _cerNumMarkLab.text = @"注册编号:";
    
    _registerNumMarkLab.text = @"注册级别:";
    
    NSInteger  newIndex = indexPath.section +1;
    _nameLab.text = [NSString stringWithFormat:@"%ld.%@",newIndex,model.name];
    
    _typeNameLab.text = [NSString stringWithFormat:@"(%@)",model.typeName];
    
    _cerNumLab.text = model.registeredNo;
    
    _registerNumLab.text = model.cert_level;
    
    _validityPeriodEndLab.text = model.validityPeriodEnd;
    //已过期:红色  90内过期:橙黄  超过90日:蓝色
    NSString *resultStr = [DDUtils newCompareTimeSpaceIn90:model.validityPeriodEnd];
    if ([resultStr isEqualToString:@"2"]) {
        _validityPeriodEndLab.textColor=kColorBlue;
    }else if ([resultStr isEqualToString:@"1"]){
        _validityPeriodEndLab.textColor=KColorTextOrange;
    } else{
        _validityPeriodEndLab.textColor=kColorRed;
    }
}
+ (CGFloat)height{
    return 125;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
