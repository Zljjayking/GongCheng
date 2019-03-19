//
//  DDBuilderCell.m
//  GongChengDD
//
//  Created by xzx on 2018/5/17.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDBuilderCell.h"

@implementation DDBuilderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.nameLab.text=@"1.周毅";
    self.nameLab.textColor=KColorBlackTitle;
    self.nameLab.font=kFontSize32;
    
    self.roleLab.text=@"临时";
    self.roleLab.textColor=KColorBlackSecondTitle;
    self.roleLab.font=kFontSize24;
    self.roleLab.layer.cornerRadius=3;
    self.roleLab.clipsToBounds=YES;
    self.roleLab.layer.borderColor=KColorBlackSecondTitle.CGColor;
    self.roleLab.layer.borderWidth=0.5;
    
    self.leftLab.text=@"已中标项目:";
    self.leftLab.textColor=KColorGreySubTitle;
    self.leftLab.font=kFontSize28;
    
    self.bidNumLab.text=@"4";
    self.bidNumLab.textColor=kColorRed;
    self.bidNumLab.font=kFontSize28;
    
    self.majorLab1.text=@"专业:";
    self.majorLab1.textColor=KColorGreySubTitle;
    self.majorLab1.font=kFontSize28;
    
    self.majorLab2.text=@"是政公用工程";
    self.majorLab2.textColor=KColorBlackSubTitle;
    self.majorLab2.font=kFontSize28;
    
    self.numLab1.text=@"证书编号:";
    self.numLab1.textColor=KColorGreySubTitle;
    self.numLab1.font=kFontSize28;
    
    self.numLab2.text=@"苏232111218946";
    self.numLab2.textColor=KColorBlackSubTitle;
    self.numLab2.font=kFontSize28;
    
    self.registerLab1.text=@"注册编号:";
    self.registerLab1.textColor=KColorGreySubTitle;
    self.registerLab1.font=kFontSize28;
    
    self.registerLab2.text=@"苏232111218946";
    self.registerLab2.textColor=KColorBlackSubTitle;
    self.registerLab2.font=kFontSize28;
    
    self.isBLab1.text=@"B类证情况:";
    self.isBLab1.textColor=KColorGreySubTitle;
    self.isBLab1.font=kFontSize28;
    
    self.isBLab2.text=@"有";
    self.isBLab2.textColor=KColorBlackSubTitle;
    self.isBLab2.font=kFontSize28;
    
    self.timeLab1.text=@"有效期:";
    self.timeLab1.textColor=KColorGreySubTitle;
    self.timeLab1.font=kFontSize28;
    
    self.timeLab2.text=@"2018-09-10";
    self.timeLab2.font=kFontSize28;
    
    self.checkBtn.layer.cornerRadius=3;
    self.checkBtn.layer.masksToBounds = YES;
}

-(void)loadDataWithModel:(DDCompanyBuilderModel *)model andIndex:(NSInteger)index{
    
    if ([DDUtils isEmptyString:model.name]) {
        self.nameLab.text=[NSString stringWithFormat:@"%ld.",index];
    }
    else{
        self.nameLab.text=[NSString stringWithFormat:@"%ld.%@",index,model.name];
    }
    
    //self.roleLab.text=model.cert_level;
    self.majorLab2.text=model.speciality;
    self.numLab2.text=model.cert_no;
    self.registerLab2.text=model.registered_no;
    
    if ([model.has_b_certificate isEqualToString:@"1"]) {
        self.isBLab2.text=@"有";
    }
    else{
        self.isBLab2.text=@"无";
    }
    
    if ([DDUtils isEmptyString:model.project_count] || [model.project_count isEqualToString:@"0"]) {
        self.bidNumLab.text=@"0";
        self.bidNumLab.textColor=KColorGreySubTitle;
    }
    else{
        self.bidNumLab.text=model.project_count;
        self.bidNumLab.textColor=kColorBlue;
    }
    
    self.timeLab2.text=model.validity_period_end;
    
    if ([model.cert_level isEqualToString:@"一级建造师"] && [model.formal integerValue]==1) {
         self.timeLab2.textColor=kColorBlack;
    }else{
        NSString *resultStr = [DDUtils newCompareTimeSpaceIn90:model.validity_period_end];
        if ([resultStr isEqualToString:@"2"]) {
            self.timeLab2.textColor=kColorBlue;
        }else if ([resultStr isEqualToString:@"1"]){
            self.timeLab2.textColor=KColorTextOrange;
        } else{
            self.timeLab2.textColor=kColorRed;
        }
    }
    
    if ([DDUtils isEmptyString:model.user_id]) {
        if ([[DDUserManager sharedInstance].staffClaim integerValue]== 0) {//未认领
            self.checkBtn.layer.borderColor = kColorBlue.CGColor;
            self.checkBtn.layer.borderWidth=1;
            self.checkBtn.backgroundColor=kColorWhite;
            [self.checkBtn setTitleColor:kColorBlue forState:UIControlStateNormal];
            [self.checkBtn setTitle:@"认领" forState:UIControlStateNormal];
            self.checkBtn.userInteractionEnabled=YES;
        }
        else{//已经认领
            self.checkBtn.layer.borderColor=KColorBtnBgBlue.CGColor;
            self.checkBtn.backgroundColor=KColorBtnBgBlue;
            [self.checkBtn setTitleColor:kColorBlue forState:UIControlStateNormal];
            [self.checkBtn setTitle:@"未认领" forState:UIControlStateNormal];
            self.checkBtn.userInteractionEnabled=NO;
        }
    }else{
        self.checkBtn.layer.borderColor=KColorCellBgOrange.CGColor;
        [self.checkBtn setTitleColor:KColorTextOrange forState:UIControlStateNormal];
        self.checkBtn.backgroundColor = KColorCellBgOrange;
        [self.checkBtn setTitle:@"已认领" forState:UIControlStateNormal];
        self.checkBtn.userInteractionEnabled=NO;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
