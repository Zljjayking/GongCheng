//
//  DDFireEngineerDetail1Cell.m
//  GongChengDD
//
//  Created by xzx on 2018/9/25.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDFireEngineerDetail1Cell.h"

@implementation DDFireEngineerDetail1Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.numberLab1.text=@"注册编号";
    self.numberLab1.textColor=KColorGreySubTitle;
    self.numberLab1.font=kFontSize30;
    
    self.numberLab2.textColor=KColorBlackTitle;
    self.numberLab2.font=kFontSize32;
    
    self.lineLab.backgroundColor=KColorTableSeparator;
    
    self.levelLab1.text=@"注册级别";
    self.levelLab1.textColor=KColorGreySubTitle;
    self.levelLab1.font=kFontSize30;
    
    self.levelLab2.textColor=KColorBlackTitle;
    self.levelLab2.font=kFontSize32;
    
    self.validLab1.text=@"注册有效期";
    self.validLab1.textColor=KColorGreySubTitle;
    self.validLab1.font=kFontSize30;
    
    self.validLab2.textColor=KColorBlackTitle;
    self.validLab2.font=kFontSize32;
    
    self.departLab1.text=@"资格证书颁发单位";
    self.departLab1.textColor=KColorGreySubTitle;
    self.departLab1.font=kFontSize30;
    
    self.departLab2.textColor=KColorBlackTitle;
    self.departLab2.font=kFontSize32;
    
    self.nameLab1.text=@"聘用单位名称";
    self.nameLab1.textColor=KColorGreySubTitle;
    self.nameLab1.font=kFontSize30;
    
    self.nameLab2.textColor=KColorBlackTitle;
    self.nameLab2.font=kFontSize32;
    
    self.addressLab1.text=@"聘用单位地址";
    self.addressLab1.textColor=KColorGreySubTitle;
    self.addressLab1.font=kFontSize30;
    
    self.addressLab2.textColor=KColorBlackTitle;
    self.addressLab2.font=kFontSize32;
    
    self.makeBtn.layer.cornerRadius=3;
    self.makeBtn.layer.masksToBounds = YES;
}

-(void)loadDataWithModel:(DDFireEngineerDetailModel *)model{
    self.numberLab2.text=model.registeredNo;
    
    self.levelLab2.text=model.certLevel;
    
    self.validLab2.text=[NSString stringWithFormat:@"%@至%@",[DDUtils getSecDateChineseByStandardTime:model.validityPeriodStart],[DDUtils getSecDateChineseByStandardTime:model.validityPeriodEnd]];
    
    self.departLab2.text=model.unit;
    
    self.nameLab2.text=model.entName;
    
    self.addressLab2.text=model.address;
    
    if ([DDUtils isEmptyString:model.userId]) {
        if ([[DDUserManager sharedInstance].staffClaim integerValue]== 0) {//未认领
            [_makeBtn setTitleColor:kColorBlue forState:UIControlStateNormal];
            [_makeBtn setTitle:@"认领" forState:UIControlStateNormal];
            _makeBtn.layer.borderWidth=1;
            _makeBtn.layer.borderColor=kColorBlue.CGColor;
            _makeBtn.backgroundColor=kColorWhite;
            _makeBtn.userInteractionEnabled=YES;
        }
        else{//已经认领
            _makeBtn.layer.borderColor=KColorBgBlue.CGColor;
            _makeBtn.backgroundColor=KColorBgBlue;
            [_makeBtn setTitleColor:kColorBlue forState:UIControlStateNormal];
            [_makeBtn setTitle:@"未认领" forState:UIControlStateNormal];
            _makeBtn.userInteractionEnabled=NO;
        }
    }else{
        _makeBtn.layer.borderColor=KColorCellBgOrange.CGColor;
        [_makeBtn setTitleColor:KColorTextOrange forState:UIControlStateNormal];
        _makeBtn.backgroundColor = KColorCellBgOrange;
        [_makeBtn setTitle:@"已认领" forState:UIControlStateNormal];
        _makeBtn.userInteractionEnabled=NO;
    }
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
