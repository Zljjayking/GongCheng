//
//  DDCivilEngineerCell.m
//  GongChengDD
//
//  Created by xzx on 2018/9/26.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDCivilEngineerCell.h"

@implementation DDCivilEngineerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.nameLab.textColor=KColorBlackTitle;
    self.nameLab.font=kFontSize32;
    
    
    self.scoreLab1.text=@"个人业绩:";
    self.scoreLab1.textColor=KColorGreySubTitle;
    self.scoreLab1.font=kFontSize28;
    
    self.scoreLab2.textColor=kColorRed;
    self.scoreLab2.font=kFontSize28;
    
    self.majorLab1.text=@"专业:";
    self.majorLab1.textColor=KColorGreySubTitle;
    self.majorLab1.font=kFontSize28;
    
    self.majorLab2.textColor=KColorBlackSubTitle;
    self.majorLab2.font=kFontSize28;
    
    self.numberLab1.text=@"证书编号:";
    self.numberLab1.textColor=KColorGreySubTitle;
    self.numberLab1.font=kFontSize28;
    
    self.numberLab2.textColor=KColorBlackSubTitle;
    self.numberLab2.font=kFontSize28;
    
    
    self.registerLab1.text=@"注册编号:";
    self.registerLab1.textColor=KColorGreySubTitle;
    self.registerLab1.font=kFontSize28;
    
    self.registerLab2.textColor=KColorBlackSubTitle;
    self.registerLab2.font=kFontSize28;
    
    self.validLab1.text=@"有效期:";
    self.validLab1.textColor=KColorGreySubTitle;
    self.validLab1.font=kFontSize28;
    
    self.validLab2.font=kFontSize28;
    
    self.checkBtn.layer.borderWidth=1;
    self.checkBtn.layer.cornerRadius=3;
}

- (void)loadDataWithModel:(DDCivilEngineerModel *)model andIndex:(NSInteger)index{
    if ([DDUtils isEmptyString:model.name]) {
        self.nameLab.text=[NSString stringWithFormat:@"%ld.",index];
    }
    else{
        self.nameLab.text=[NSString stringWithFormat:@"%ld.%@",index,model.name];
    }
    
    if ([DDUtils isEmptyString:model.project_count] || [model.project_count isEqualToString:@"0"]) {
        self.scoreLab2.text=@"0";
        self.scoreLab2.textColor=KColorGreySubTitle;
    }
    else{
        self.scoreLab2.text=model.project_count;
        self.scoreLab2.textColor=kColorBlue;
    }
    
    
    self.majorLab2.text=model.speciality;
    
    self.numberLab2.text=model.cert_no;
    
    self.registerLab2.text=model.registered_no;
    
    if (![DDUtils isEmptyString:model.validity_period_end]) {
        self.validLab2.text=model.validity_period_end;
        //timestr与当前时间相比,返回三种时间间隔的代号(0,1,2),0表示已过期，1表示90日之内，2表示超过90日
        NSString *resultStr = [DDUtils newCompareTimeSpaceIn90:model.validity_period_end];
        if ([resultStr isEqualToString:@"2"]) {
            self.validLab2.textColor=kColorBlue;
        }else if ([resultStr isEqualToString:@"1"]){
            self.validLab2.textColor=KColorTextOrange;
        } else{
            self.validLab2.textColor=kColorRed;
        }
    }
    else{
        self.validLab2.text = @"-";
    }
    
    if ([DDUtils isEmptyString:model.user_id]) {
        if ([[DDUserManager sharedInstance].staffClaim integerValue]== 0) {//未认领
            [self.checkBtn setTitleColor:kColorBlue forState:UIControlStateNormal];
            self.checkBtn.backgroundColor=kColorWhite;
            [self.checkBtn setTitle:@"认领" forState:UIControlStateNormal];
            self.checkBtn.layer.borderWidth=1;
            
            self.checkBtn.layer.borderColor=kColorBlue.CGColor;
            self.checkBtn.userInteractionEnabled=YES;
        }
        else{//已经认领
            self.checkBtn.layer.borderColor=KColorBgBlue.CGColor;
            self.checkBtn.backgroundColor=KColorBgBlue;
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
