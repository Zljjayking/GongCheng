//
//  DDSafeManCell.m
//  GongChengDD
//
//  Created by xzx on 2018/9/26.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDSafeManCell.h"

@implementation DDSafeManCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.nameLab.text=@"1.周毅";
    self.nameLab.textColor=KColorBlackTitle;
    self.nameLab.font=kFontSize32;
    
    
    self.typeLab1.text=@"证书类别:";
    self.typeLab1.textColor=KColorGreySubTitle;
    self.typeLab1.font=kFontSize28;
    
    self.typeLab2.textColor=KColorBlackSubTitle;
    self.typeLab2.font=kFontSize28;
    
    
    self.numberLab1.text=@"证书号:";
    self.numberLab1.textColor=KColorGreySubTitle;
    self.numberLab1.font=kFontSize28;
    
    self.numberLab2.textColor=KColorBlackSubTitle;
    self.numberLab2.font=kFontSize28;
    
    
    self.statusLab1.text=@"状态:";
    self.statusLab1.textColor=KColorGreySubTitle;
    self.statusLab1.font=kFontSize28;
    
    self.statusLab2.textColor=KColorBlackSubTitle;
    self.statusLab2.font=kFontSize28;
    
    self.validLab1.text=@"有效期:";
    self.validLab1.textColor=KColorGreySubTitle;
    self.validLab1.font=kFontSize28;
    
    self.validLab2.font=kFontSize28;
    self.validLab2.textColor=KColorBlackSubTitle;
    
    self.checkBtn.layer.borderWidth=1;
    self.checkBtn.layer.cornerRadius=3;
}

-(void)loadDataWithModel:(DDCompanySafemanModel *)model andIndex:(NSInteger)index{
    if ([DDUtils isEmptyString:model.name]) {
        self.nameLab.text=[NSString stringWithFormat:@"%ld.",index+1];
    }
    else{
        self.nameLab.text=[NSString stringWithFormat:@"%ld.%@",index+1,model.name];
    }
    
    self.typeLab2.text=model.cert_type;
    
    self.numberLab2.text=model.cert_no;
    
    self.statusLab2.text=model.cert_state_source;
    if ([model.cert_state_source isEqualToString:@"有效"]) {
        self.statusLab2.textColor=KColorBlackSubTitle;
    }
    else{
        self.statusLab2.textColor=kColorRed;
    }
    
    
    if ([DDUtils isEmptyString:model.validity_period_end]) {
        self.validLab2.text=@"-";
    }else{
        self.validLab2.text=model.validity_period_end;
        NSString *resultStr = [DDUtils newCompareTimeSpaceIn90:model.validity_period_end];
        if ([resultStr isEqualToString:@"2"]) {
            self.validLab2.textColor=kColorBlue;
        }else if ([resultStr isEqualToString:@"1"]){
            self.validLab2.textColor=KColorTextOrange;
        } else{
            self.validLab2.textColor=kColorRed;
        }
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
