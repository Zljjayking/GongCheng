//
//  DDCompanyList2Cell.m
//  GongChengDD
//
//  Created by xzx on 2018/8/15.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDCompanyList2Cell.h"

@implementation DDCompanyList2Cell

- (void)awakeFromNib {
    [super awakeFromNib];

    //self.titleLab.text=@"南京和远建筑工程有限公司";
    self.titleLab.textColor=KColorCompanyTitleBalck;
    self.titleLab.font=kFontSize34;
    
    //self.areaLab.text=@"南京市六合区/方久和";
    self.areaLab.textColor=KColorGreySubTitle;
    self.areaLab.font=kFontSize28;
    
    self.statusLab.font=kFontSize26;
    self.statusLab.layer.borderWidth=0.5;
    self.statusLab.layer.cornerRadius=3;
    self.statusLab.clipsToBounds=YES;
    
    _zzCountLab.textColor = KColorGreySubTitle;
    _zzCountLab.font = kFontSize28;
    
    _ryzsCountLab.textColor = KColorGreySubTitle;
    _ryzsCountLab.font = kFontSize28;
    
    _zbCountLab.textColor = KColorGreySubTitle;
    _zbCountLab.font = kFontSize28;
    
    _fxxxCountLab.textColor = KColorGreySubTitle;
    _fxxxCountLab.font = kFontSize28;
    
    _hjryCountLab.textColor = KColorGreySubTitle;
    _hjryCountLab.font = kFontSize28;
    
    _xyqkCountLab.textColor = KColorGreySubTitle;
    _xyqkCountLab.font = kFontSize28;
}
-(void)loadDataWithModel3:(DDSearchCompanyListModel *)model{
    self.titleLab.text = model.unitName;
    self.titleLab.font=kFontSize34;
    self.titleLab.lineBreakMode = NSLineBreakByTruncatingTail;
    
    self.areaLab.text=model.areaStr;
    
    //[self.peopleBtn setAttributedTitle:model.peopleAttriString forState:UIControlStateNormal];
    [self.peopleBtn setTitle:model.legalRepresentative forState:UIControlStateNormal];
    self.peopleBtn.userInteractionEnabled=NO;
    [self.peopleBtn setTitleColor:KColorGreySubTitle forState:UIControlStateNormal];
    
    if ([DDUtils isEmptyString:model.status]) {
        self.statusLab.hidden=YES;
    }
    else{
        if ([model.flagstatus isEqualToString:@"1"]) {
            self.statusLab.textColor=kColorRed;
            self.statusLab.layer.borderColor=kColorRed.CGColor;
        }
        else{
            self.statusLab.textColor=kColorBlue;
            self.statusLab.layer.borderColor=kColorBlue.CGColor;
        }
        self.statusLab.hidden=NO;
        self.statusLab.text=model.status;
    }
    
    
    NSString * zzTotal = [NSString stringWithFormat:@"资质 %@",model.zzCount];
    _zzCountLab.attributedText =  [DDUtils adjustTextColor:zzTotal rangeText:model.zzCount color:KColorBlackTitle];
    
    
    NSString * ryzsTotal = [NSString stringWithFormat:@"人员证书 %@",model.ryzsCount];
    _ryzsCountLab.attributedText = [DDUtils adjustTextColor:ryzsTotal rangeText:model.ryzsCount color:KColorBlackTitle];
    
    NSString * zbTotal = [NSString stringWithFormat:@"中标 %@",model.zbCount];
    _zbCountLab.attributedText = [DDUtils adjustTextColor:zbTotal rangeText:model.zbCount color:KColorBlackTitle];
    
    NSString * fxxxTotal = [NSString stringWithFormat:@"风险信息 %@",model.fxxxCount];
    _fxxxCountLab.attributedText = [DDUtils adjustTextColor:fxxxTotal rangeText:model.fxxxCount color:KColorBlackTitle];
    
    NSString * hjryTotal = [NSString stringWithFormat:@"获奖荣誉 %@",model.hjryCount];
    _hjryCountLab.attributedText = [DDUtils adjustTextColor:hjryTotal rangeText:model.hjryCount color:KColorBlackTitle];
    
    NSString * xyqkTotal = [NSString stringWithFormat:@"信用情况 %@",model.xyqkCount];
    _xyqkCountLab.attributedText = [DDUtils adjustTextColor:xyqkTotal rangeText:model.xyqkCount color:KColorBlackTitle];
}
-(void)loadDataWithModel:(DDSearchCompanyListModel *)model{    
    
    self.titleLab.attributedText = model.unitNameAttriStr;
    self.titleLab.font=kFontSize34;
    self.titleLab.lineBreakMode = NSLineBreakByTruncatingTail;

    self.areaLab.text=model.areaStr;
    
    //[self.peopleBtn setAttributedTitle:model.peopleAttriString forState:UIControlStateNormal];
    [self.peopleBtn setTitle:model.legalRepresentative forState:UIControlStateNormal];
    self.peopleBtn.userInteractionEnabled=NO;
    [self.peopleBtn setTitleColor:KColorGreySubTitle forState:UIControlStateNormal];
 
    if ([DDUtils isEmptyString:model.status]) {
        self.statusLab.hidden=YES;
    }
    else{
        if ([model.flagstatus isEqualToString:@"1"]) {
            self.statusLab.textColor=kColorRed;
            self.statusLab.layer.borderColor=kColorRed.CGColor;
        }
        else{
            self.statusLab.textColor=kColorBlue;
            self.statusLab.layer.borderColor=kColorBlue.CGColor;
        }
        self.statusLab.hidden=NO;
        self.statusLab.text=model.status;
    }
    
    
    NSString * zzTotal = [NSString stringWithFormat:@"资质 %@",model.zzCount];
    _zzCountLab.attributedText =  [DDUtils adjustTextColor:zzTotal rangeText:model.zzCount color:KColorBlackTitle];
    
    
    NSString * ryzsTotal = [NSString stringWithFormat:@"人员证书 %@",model.ryzsCount];
    _ryzsCountLab.attributedText = [DDUtils adjustTextColor:ryzsTotal rangeText:model.ryzsCount color:KColorBlackTitle];
    
    NSString * zbTotal = [NSString stringWithFormat:@"中标 %@",model.zbCount];
    _zbCountLab.attributedText = [DDUtils adjustTextColor:zbTotal rangeText:model.zbCount color:KColorBlackTitle];
    
    NSString * fxxxTotal = [NSString stringWithFormat:@"风险信息 %@",model.fxxxCount];
    _fxxxCountLab.attributedText = [DDUtils adjustTextColor:fxxxTotal rangeText:model.fxxxCount color:KColorBlackTitle];
    
    NSString * hjryTotal = [NSString stringWithFormat:@"获奖荣誉 %@",model.hjryCount];
    _hjryCountLab.attributedText = [DDUtils adjustTextColor:hjryTotal rangeText:model.hjryCount color:KColorBlackTitle];
    
    NSString * xyqkTotal = [NSString stringWithFormat:@"信用情况 %@",model.xyqkCount];
    _xyqkCountLab.attributedText = [DDUtils adjustTextColor:xyqkTotal rangeText:model.xyqkCount color:KColorBlackTitle];
}

+(CGFloat)height{
    
    return 162;
}

-(void)loadDataWithModel2:(DDMyCollectModel *)model{
    self.titleLab.text = model.unitName;
    self.titleLab.font=kFontSize34;
    self.titleLab.lineBreakMode = NSLineBreakByTruncatingTail;
    
    NSMutableString *areaStr=[[NSMutableString alloc]initWithString:@""];
    if ([model.mergerName containsString:@","]) {
        NSArray *array=[model.mergerName componentsSeparatedByString:@","];
        if (array.count>1) {
            for (int i=0; i<array.count; i++) {
                [areaStr appendString:array[i]];
            }
        }
    }
    else{
        if (![DDUtils isEmptyString:model.mergerName]) {
            [areaStr appendString:model.mergerName];
        }
    }
    [areaStr appendString:@"/"];
    self.areaLab.text=areaStr;
    
    [self.peopleBtn setTitleColor:KColorGreySubTitle forState:UIControlStateNormal];
    [self.peopleBtn setTitle:model.legalRepresentative forState:UIControlStateNormal];
    
    if ([DDUtils isEmptyString:model.STATUS]) {
        self.statusLab.hidden=YES;
    }
    else{
        self.statusLab.hidden=NO;
        self.statusLab.text=model.STATUS;
        if ([model.STATUS isEqualToString:@"注销"] || [model.STATUS isEqualToString:@"吊销"] || [model.STATUS isEqualToString:@"撤销"] || [model.STATUS isEqualToString:@"停业"] || [model.STATUS isEqualToString:@"清算"]) {
            self.statusLab.textColor=kColorRed;
            self.statusLab.layer.borderColor=kColorRed.CGColor;
        }
        else{
            self.statusLab.textColor=kColorBlue;
            self.statusLab.layer.borderColor=kColorBlue.CGColor;
        }
    }
    
    NSString * zzTotal = [NSString stringWithFormat:@"资质 %@",model.zzCount];
    self.zzCountLab.attributedText =  [DDUtils adjustTextColor:zzTotal rangeText:model.zzCount color:KColorBlackTitle];
    
    NSString * ryzsTotal = [NSString stringWithFormat:@"人员证书 %@",model.ryzsCount];
    self.ryzsCountLab.attributedText = [DDUtils adjustTextColor:ryzsTotal rangeText:model.ryzsCount color:KColorBlackTitle];
    
    NSString * zbTotal = [NSString stringWithFormat:@"中标 %@",model.zbCount];
    self.zbCountLab.attributedText = [DDUtils adjustTextColor:zbTotal rangeText:model.zbCount color:KColorBlackTitle];
    
    NSString * fxxxTotal = [NSString stringWithFormat:@"风险信息 %@",model.fxxxCount];
    self.fxxxCountLab.attributedText = [DDUtils adjustTextColor:fxxxTotal rangeText:model.fxxxCount color:KColorBlackTitle];
    
    NSString * hjryTotal = [NSString stringWithFormat:@"获奖荣誉 %@",model.hjryCount];
    self.hjryCountLab.attributedText = [DDUtils adjustTextColor:hjryTotal rangeText:model.hjryCount color:KColorBlackTitle];
    
    NSString * xyqkTotal = [NSString stringWithFormat:@"信用情况 %@",model.xyqkCount];
    self.xyqkCountLab.attributedText = [DDUtils adjustTextColor:xyqkTotal rangeText:model.xyqkCount color:KColorBlackTitle];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
