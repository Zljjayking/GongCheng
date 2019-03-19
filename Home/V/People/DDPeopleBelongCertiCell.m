//
//  DDPeopleBelongCertiCell.m
//  GongChengDD
//
//  Created by xzx on 2018/5/25.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDPeopleBelongCertiCell.h"

@implementation DDPeopleBelongCertiCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
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
    
    
    _claimButton.layer.cornerRadius=3;
    _claimButton.layer.masksToBounds=YES;
    [_claimButton addTarget:self action:@selector(claimButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)claimButtonClick{
    if ([_delegate respondsToSelector:@selector(peopleBelongCertiCellClaimClick:)]) {
        [_delegate peopleBelongCertiCellClaimClick:self];
    }
}


-(void)loadDataWithModel:(DDPeopleBelongCertiModel *)model{
    if([model.data_type isEqualToString:@"2"]){//安全员
        self.nameLab.text=model.name;
        
        self.roleLab.text=model.cert_type_name;
        CGRect frame_W = [model.cert_type_name boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize24} context:nil];
        self.roleLab.textColor=KColorBlackSecondTitle;
        self.roleLab.layer.borderColor=KColorBlackSecondTitle.CGColor;
        self.roleLab.backgroundColor=KColorLinkBackViewColor;
        self.roleLabWidth.constant = frame_W.size.width+16;
        
        self.majorLab1.text=@"证书类别:";
        self.majorLab2.text=model.cert_type;
        
        self.numLab1.text=@"证书号:";
        self.numLab2.text=model.cert_no;
        
        self.isBLab1.text=@"状态:";
        self.isBLab2.text=model.cert_state;
        if ([model.cert_state isEqualToString:@"有效"]) {
            self.isBLab2.textColor=KColorBlackSubTitle;
        }
        else{
            self.isBLab2.textColor=kColorRed;
        }
        
        self.timeLab2.text=model.validity_period_end;
        
        NSString *resultStr = [DDUtils newCompareTimeSpaceIn90:model.validity_period_end];
        if ([resultStr isEqualToString:@"2"]) {
            self.timeLab2.textColor=kColorBlue;
        }else if ([resultStr isEqualToString:@"1"]){
            self.timeLab2.textColor=KColorTextOrange;
        } else{
            self.timeLab2.textColor=kColorRed;
        }
    }
    else{
        self.nameLab.text=model.name;
        
        self.roleLab.text=model.cert_type_name;
        CGRect frame_W = [model.cert_type_name boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize24} context:nil];
        //土木工程师8 公用设备师9 电气工程师10 监理工程师11 造价工程师12
        if([model.data_type isEqualToString:@"8"]){//土木工程师
            self.roleLab.textColor=KColorCivil;
            self.roleLab.layer.borderColor=KColorCivil.CGColor;
            self.roleLab.backgroundColor=KColorCivilBg;
        }
        else if([model.data_type isEqualToString:@"9"]){//公用设备师
            self.roleLab.textColor=KColorDevice;
            self.roleLab.layer.borderColor=KColorDevice.CGColor;
            self.roleLab.backgroundColor=KColorDeviceBg;
        }
        else if([model.data_type isEqualToString:@"10"]){//电气工程师
            self.roleLab.textColor=KColorElectric;
            self.roleLab.layer.borderColor=KColorElectric.CGColor;
            self.roleLab.backgroundColor=KColorElectricBg;
        }
        else if([model.data_type isEqualToString:@"11"]){//监理工程师
            self.roleLab.textColor=KColorSupervisor;
            self.roleLab.layer.borderColor=KColorSupervisor.CGColor;
            self.roleLab.backgroundColor=KColorSupervisorBg;
        }
        else if([model.data_type isEqualToString:@"12"]){//造价工程师
            self.roleLab.textColor=KColorCost;
            self.roleLab.layer.borderColor=KColorCost.CGColor;
            self.roleLab.backgroundColor=KColorCostBg;
        }
        self.roleLabWidth.constant = frame_W.size.width+16;
        
        self.majorLab1.text=@"专业:";
        self.majorLab2.text=model.speciality;
        
        self.numLab1.text=@"证书编号:";
        self.numLab2.text=model.cert_no;
        
        self.isBLab1.text=@"注册编号:";
        self.isBLab2.text=model.registered_no;
        
        self.timeLab2.text=model.validity_period_end;
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
    return 185;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
