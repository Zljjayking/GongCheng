//
//  DDPeopleSummaryType1Cell.m
//  GongChengDD
//
//  Created by csq on 2018/10/26.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDPeopleSummaryType1Cell.h"

@implementation DDPeopleSummaryType1Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    
    _nameLab.textColor = KColorBlackTitle;
    _nameLab.font = kFontSize34;
    
    _typeNameLab.textColor = KColorBlackSubTitle;
    _typeNameLab.font = kFontSize28;
    
    
    _roleLabel.text=@"临时";
    _roleLabel.textColor=KColorBlackSecondTitle;
    _roleLabel.font=kFontSize24;
    _roleLabel.layer.cornerRadius=3;
    _roleLabel.clipsToBounds=YES;
    _roleLabel.layer.borderColor=KColorBlackSecondTitle.CGColor;
    _roleLabel.layer.borderWidth=0.5;
    
    [_makeBtn setTitle:@"办理" forState:UIControlStateNormal];
    [_makeBtn setTitleColor:KColorFindingPeopleBlue forState:UIControlStateNormal];
    _makeBtn.titleLabel.font=kFontSize28;
    _makeBtn.layer.borderColor=KColorFindingPeopleBlue.CGColor;
    _makeBtn.layer.borderWidth=0.5;
    _makeBtn.layer.cornerRadius=2;
    _makeBtn.hidden=YES;
    
    _specialityNameMarkLab.textColor = KColorGreySubTitle;
    _specialityNameMarkLab.font = kFontSize28;
   _specialityNameMarkLab.text = @"专业:";
    
    _specialityNameLab.textColor = KColorBlackSubTitle;
    _specialityNameLab.font = kFontSize28;
    
    _cerNumMarkLab.textColor = KColorGreySubTitle;
    _cerNumMarkLab.font = kFontSize28;
    _cerNumMarkLab.text = @"证书编号:";
    
    _cerNumLab.textColor = KColorBlackSubTitle;
    _cerNumLab.font = kFontSize28;
    
    
    _registerNumMarkLab.textColor = KColorGreySubTitle;
    _registerNumMarkLab.font = kFontSize28;
    _registerNumMarkLab.text = @"注册编号:";
    
    _registerNumLab.textColor = KColorBlackSubTitle;
    _registerNumLab.font = kFontSize28;
    
    
    _hasBCertificateMarkLab.textColor = KColorGreySubTitle;
    _hasBCertificateMarkLab.font = kFontSize28;
    _hasBCertificateMarkLab.text = @"B类证情况:";
    
    _hasBCertificateLab.textColor = KColorBlackSubTitle;
    _hasBCertificateLab.font = kFontSize28;
    
    
    _validityPeriodEndMarkLab.text = @"有效期:";
    _validityPeriodEndMarkLab.textColor = KColorGreySubTitle;
    _validityPeriodEndMarkLab.font = kFontSize28;
    
}

-(void)loadCellWithModel:(DDPeopleSummaryModel *)model indexPath:(NSIndexPath *)indexPath{
    
    NSInteger  newIndex = indexPath.section +1;
    _nameLab.text = [NSString stringWithFormat:@"%ld.%@",newIndex,model.name];
    
    _typeNameLab.text = [NSString stringWithFormat:@"(%@)",model.typeName];
    
    _specialityNameLab.text = model.specialityName;
    
    _cerNumLab.text = model.certNo;
    
    _registerNumLab.text = model.registeredNo;
    
    if ([model.hasBCertificate isEqualToString:@"0"]) {
        _hasBCertificateLab.text = @"无";
    }else{
        _hasBCertificateLab.text = @"有";
    }
    
    if ([model.type integerValue]==1 || [model.type integerValue]==2) {
      //formal 0临时 1正式
        if ([model.formal integerValue] != 1) {
            _roleLabel.hidden=NO;
        }else{
            _roleLabel.hidden=YES;
        }
    }else{
        _roleLabel.hidden=YES;
    }
    
    if([model.type integerValue] == 2) {//二建
        NSString  *region_id = @"";
        if ([DDUtils isEmptyString:model.regionId]) {
            region_id = @"";
        }else{
            region_id = [NSString stringWithFormat:@"%@",model.regionId];
        }
        if (region_id.length>2) {
            if([[region_id substringToIndex:2]isEqualToString:@"32"]){//江苏的加办理按钮
                self.makeBtn.hidden=NO;
            }else{
                self.makeBtn.hidden=YES;
            }
        }else{
            self.makeBtn.hidden=YES;
        }
    }else{
        self.makeBtn.hidden=YES;
    }
    
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
    return 191;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
