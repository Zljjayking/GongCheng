//
//  DDPeopleSummaryCell.m
//  GongChengDD
//
//  Created by Koncendy on 2017/12/4.
//  Copyright © 2017年 Koncendy. All rights reserved.
//

#import "DDPeopleSummaryCell.h"
#import "DDDateUtil.h"

@implementation DDPeopleSummaryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = kColorBackGroundColor;
    self.bgView.backgroundColor = [UIColor whiteColor];
    
    _nameLab.textColor = KColorBlackTitle;
    _nameLab.font = kFontSize34;
    
    [_makeBtn setTitle:@"办理" forState:UIControlStateNormal];
    [_makeBtn setTitleColor:KColorFindingPeopleBlue forState:UIControlStateNormal];
    _makeBtn.titleLabel.font=kFontSize28;
    _makeBtn.layer.borderColor=KColorFindingPeopleBlue.CGColor;
    _makeBtn.layer.borderWidth=0.5;
    _makeBtn.layer.cornerRadius=2;
    _makeBtn.hidden=YES;
    
    _typeNameLab.textColor = KColorBlackSubTitle;
    _typeNameLab.font = kFontSize28;
    
    _specialityNameMarkLab.textColor = KColorGreySubTitle;
    _specialityNameMarkLab.font = kFontSize28;
//    _specialityNameMarkLab.text = @"专业:";
    
    _specialityNameLab.textColor = KColorBlackSubTitle;
    _specialityNameLab.font = kFontSize28;
    
    _staffInfoMarkLab.textColor = KColorGreySubTitle;
    _staffInfoMarkLab.font = kFontSize28;
    //_staffInfoMarkLab.text = @"证书编号:";
    
    _staffInfoLab.textColor = KColorBlackSubTitle;
    _staffInfoLab.font = kFontSize28;
    
    _hasBCertificateMarkLab.textColor = KColorGreySubTitle;
    _hasBCertificateMarkLab.font = kFontSize28;
    //_hasBCertificateMarkLab.text = @"B类证情况:";
    
    _hasBCertificateLab.textColor = KColorBlackSubTitle;
    _hasBCertificateLab.font = kFontSize28;
    
    
    _validityPeriodEndMarkLab.text = @"有效期:";
    _validityPeriodEndMarkLab.textColor = KColorGreySubTitle;
    _validityPeriodEndMarkLab.font = kFontSize28;
    
    _validityPeriodEndLab.font = kFontSize28;
}
- (void)loadOtherManWithModel:(DDPeopleSummaryModel *)model indexPath:(NSIndexPath *)indexPath{
    
    _specialityNameMarkLab.text = @"专业:";
    _staffInfoMarkLab.text = @"证书编号:";
    _hasBCertificateMarkLab.text = @"注册编号:";
    
    NSInteger  newIndex = indexPath.section +1;
    _nameLab.text = [NSString stringWithFormat:@"%ld.%@",newIndex,model.name];
    
    _typeNameLab.text = [NSString stringWithFormat:@"(%@)",model.typeName];
    
    _specialityNameLab.text = model.specialityName;
    
    _staffInfoLab.text = model.certNo;
    
    _hasBCertificateLab.text = model.registeredNo;
    
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


//安全员
- (void)loadSafeManWithModel:(DDPeopleSummaryModel *)model indexPath:(NSIndexPath *)indexPath{
    
    _specialityNameMarkLab.text = @"证书类别:";
    _staffInfoMarkLab.text = @"证书号:";
    _hasBCertificateMarkLab.text = @"状态:";
    
    NSInteger  newIndex = indexPath.section +1;
    _nameLab.text = [NSString stringWithFormat:@"%ld.%@",newIndex,model.name];
    
    if ([model.type integerValue] == 3) {
        _typeNameLab.text = [NSString stringWithFormat:@"(安全员%@类)",model.typeName];
    }else{
        _typeNameLab.text = [NSString stringWithFormat:@"(%@)",model.typeName];
    }
    
    _specialityNameLab.text = model.typeName;
    
    _staffInfoLab.text = model.certNo;
    
    if ([model.hasBCertificate isEqualToString:@"0"]) {
        _hasBCertificateLab.text = @"有效";
    }else{
        _hasBCertificateLab.text = @"无效";
    }
    
    if([model.type integerValue] == 2||[model.type integerValue] == 3) {//二建 //三类
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
    if ([DDUtils isEmptyString:model.validityPeriodEnd]) {
        _validityPeriodEndLab.text = @"-";
        _hasBCertificateLab.text = @"-";
    }else{
        _validityPeriodEndLab.text = model.validityPeriodEnd;
        //已过期:红色  90内过期:橙黄  超过90日:蓝色
        NSString *resultStr = [DDUtils newCompareTimeSpaceIn90:model.validityPeriodEnd];
        if ([resultStr isEqualToString:@"2"]) {
            _validityPeriodEndLab.textColor = kColorBlue;
            _hasBCertificateLab.text = @"有效";
            _hasBCertificateLab.textColor = KColorBlackSubTitle;
        }else if ([resultStr isEqualToString:@"1"]){
            _validityPeriodEndLab.textColor = kColorGiveUpBidOrange;
            _hasBCertificateLab.text = @"有效";
            _hasBCertificateLab.textColor = KColorBlackSubTitle;
        } else{
            _validityPeriodEndLab.textColor = kColorRed;
            _hasBCertificateLab.text = @"过期";
            _hasBCertificateLab.textColor = kColorRed;
        }
    }
}

+ (CGFloat)height{
    return 165;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
