//
//  DDPeopleBelongCerti2Cell.m
//  GongChengDD
//
//  Created by xzx on 2018/10/10.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDPeopleBelongCerti2Cell.h"

@implementation DDPeopleBelongCerti2Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    //self.nameLab.text=@"方久和";
    self.nameLab.textColor=KColorCompanyTitleBalck;
    self.nameLab.font=kFontSize34;
    
    self.roleLab.text=@"一级建造师";
    CGRect frame_W = [@"一级建造师" boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize24} context:nil];
    self.roleLab.textAlignment=NSTextAlignmentCenter;
    self.roleLab.layer.cornerRadius=3;
    self.roleLab.clipsToBounds=YES;
    self.roleLab.layer.borderWidth=0.5;
    self.roleLab.layer.borderColor=KColorBlackSecondTitle.CGColor;
    self.roleLab.backgroundColor=KColorLinkBackViewColor;
    self.roleLabWidth.constant = frame_W.size.width+16;
    self.roleLab.textColor=KColorBlackSecondTitle;
    self.roleLab.font=kFontSize24;
    
    self.tempLab.text=@"临时";
    self.tempLab.textColor=KColorBlackSecondTitle;
    self.tempLab.font=kFontSize24;
    self.tempLab.textAlignment=NSTextAlignmentCenter;
    self.tempLab.layer.cornerRadius=3;
    self.tempLab.clipsToBounds=YES;
    self.tempLab.layer.borderWidth=0.5;
    self.tempLab.layer.borderColor=KColorBlackSecondTitle.CGColor;
    
    self.majorLab1.text=@"专业:";
    self.majorLab1.textColor=KColorGreySubTitle;
    self.majorLab1.font=kFontSize28;
    
    self.majorLab2.text=@"市政公用工程";
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
    
    self.timeLab2.text=@"2010-04-10";
    self.timeLab2.textColor=KColorTextOrange;
    self.timeLab2.font=kFontSize28;
    
    self.arrow.image = [UIImage imageNamed:@"arrow_right"];
    _claimButton.layer.cornerRadius = 3;
    _claimButton.layer.masksToBounds = YES;
    [_claimButton addTarget:self action:@selector(claimButtonClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)claimButtonClick{
    if ([_delegate respondsToSelector:@selector(peopleBelongCerti2CellClaimClick:)]) {
        [_delegate peopleBelongCerti2CellClaimClick:self];
    }
}
#pragma mark --
-(void)loadDataWithModel:(DDPeopleBelongCertiModel *)model{
    self.tempLab.hidden=YES;
    
    self.nameLab.text=model.name;
    
    self.roleLab.text=model.cert_type_name;
    CGRect frame_W = [model.cert_type_name boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize24} context:nil];
    self.roleLab.textColor=KColorTextGreen;
    self.roleLab.layer.borderColor=KColorTextGreen.CGColor;
    self.roleLab.backgroundColor=KColorBGGreen;
    self.roleLabWidth.constant = frame_W.size.width+16;
    
    if ([model.formal isEqualToString:@"0"]) {
        self.tempLab.hidden=NO;
    }
    else{
        self.tempLab.hidden=YES;
    }
    
    self.majorLab2.text=model.speciality;
    
    self.numLab2.text=model.cert_no;
    
    self.registerLab2.text=model.registered_no;
    
    if ([model.has_b_certificate isEqualToString:@"0"]) {
        self.isBLab2.text=@"无";
    }
    else{
        self.isBLab2.text=@"有";
    }
    self.timeLab2.text = model.validity_period_end;
    if ([model.cert_level integerValue] == 1 && [model.formal integerValue] == 1) {
        self.timeLab2.textColor=KColorBlackSubTitle;
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
            [self.claimButton setTitleColor:kColorBlue forState:UIControlStateNormal];
            self.claimButton.backgroundColor=kColorWhite;
            [self.claimButton setTitle:@"认领" forState:UIControlStateNormal];
            self.claimButton.layer.borderWidth=1;
            
            self.claimButton.layer.borderColor=kColorBlue.CGColor;
            self.claimButton.userInteractionEnabled=YES;
        }
        else{//已经认领
            self.claimButton.layer.borderColor=KColorBgBlue.CGColor;
            self.claimButton.backgroundColor=KColorBgBlue;
            [self.claimButton setTitleColor:kColorBlue forState:UIControlStateNormal];
            [self.claimButton setTitle:@"未认领" forState:UIControlStateNormal];
            self.claimButton.userInteractionEnabled=NO;
        }
    }else{
        self.claimButton.layer.borderColor=KColorCellBgOrange.CGColor;
        [self.claimButton setTitleColor:KColorTextOrange forState:UIControlStateNormal];
        self.claimButton.backgroundColor = KColorCellBgOrange;
        [self.claimButton setTitle:@"已认领" forState:UIControlStateNormal];
        self.claimButton.userInteractionEnabled=NO;
    }
}
+(CGFloat)height{
    return 215;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
