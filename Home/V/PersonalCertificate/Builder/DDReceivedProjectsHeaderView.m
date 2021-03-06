//
//  DDReceivedProjectsHeaderView.m
//  GongChengDD
//
//  Created by xzx on 2018/9/28.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDReceivedProjectsHeaderView.h"

@implementation DDReceivedProjectsHeaderView



- (void)awakeFromNib{
    [super awakeFromNib];
    
     self.backgroundColor=kColorWhite;

    self.majorLab1.text=@"专业：";
    self.majorLab1.textColor=KColorGreySubTitle;
    self.majorLab1.font=kFontSize28;

    //self.majorLab2.text=@"市政公用工程";
    self.majorLab2.textColor=KColorBlackSubTitle;
    self.majorLab2.font=kFontSize28;

    self.numberLab1.text=@"证书编号：";
    self.numberLab1.textColor=KColorGreySubTitle;
    self.numberLab1.font=kFontSize28;

    //self.numberLab2.text=@"苏232111218946";
    self.numberLab2.textColor=KColorBlackSubTitle;
    self.numberLab2.font=kFontSize28;

    self.registerLab1.text=@"注册编号：";
    self.registerLab1.textColor=KColorGreySubTitle;
    self.registerLab1.font=kFontSize28;

    //self.registerLab2.text=@"苏232111218946";
    self.registerLab2.textColor=KColorBlackSubTitle;
    self.registerLab2.font=kFontSize28;

    self.hasBLab1.text=@"B类证情况：";
    self.hasBLab1.textColor=KColorGreySubTitle;
    self.hasBLab1.font=kFontSize28;

    //self.hasBLab2.text=@"有";
    self.hasBLab2.textColor=KColorBlackSubTitle;
    self.hasBLab2.font=kFontSize28;

    self.validLab1.text=@"有效期：";
    self.validLab1.textColor=KColorGreySubTitle;
    self.validLab1.font=kFontSize28;

    //self.validLab2.text=@"2018-09-10";
    self.validLab2.font=kFontSize28;

    self.checkBtn.layer.cornerRadius=3;
    self.checkBtn.layer.masksToBounds=YES;
}



-(void)loadDataWithModel:(DDPersonalDetailInfoModel *)model{
    self.majorLab2.text=model.specialitySource;
    self.numberLab2.text=model.certNo;
    self.registerLab2.text=model.registeredNo;
    
    if ([model.hasBCertificate isEqualToString:@"1"]) {
        self.hasBLab2.text=@"有";
    }
    else{
        self.hasBLab2.text=@"无";
    }
   
    
    
    if (![DDUtils isEmptyString:model.validityPeriodEnd]) {
         self.validLab2.text=model.validityPeriodEnd;
        //一建正式
        if([model.certLevel integerValue] == 1 && [model.formal integerValue] == 1){
            self.validLab2.textColor=KColorBlackSubTitle;
        }else{
            NSString *resultStr = [DDUtils newCompareTimeSpaceIn90:model.validityPeriodEnd];
            if ([resultStr isEqualToString:@"2"]) {
                self.validLab2.textColor=kColorBlue;
            }else if ([resultStr isEqualToString:@"1"]){
                self.validLab2.textColor=KColorTextOrange;
            } else{
                self.validLab2.textColor=kColorRed;
            }
        }
    }
    else{
        self.validLab2.text = @"-";
    }
    
    if ([DDUtils isEmptyString:model.userId]) {
        if ([[DDUserManager sharedInstance].staffClaim integerValue]== 0) {//未认领
            [self.checkBtn setTitleColor:kColorBlue forState:UIControlStateNormal];
            [self.checkBtn setTitle:@"认领" forState:UIControlStateNormal];
            self.checkBtn.layer.borderWidth=1;
            self.checkBtn.backgroundColor=kColorWhite;
            self.checkBtn.layer.borderColor=kColorBlue.CGColor;
            self.checkBtn.userInteractionEnabled=YES;
            [self.checkBtn addTarget:self action:@selector(checkClick) forControlEvents:UIControlEventTouchUpInside];
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

-(void)checkClick{
    if ([_delegate respondsToSelector:@selector(checkBtnClick)]) {
        [_delegate checkBtnClick];
    }
}


@end
