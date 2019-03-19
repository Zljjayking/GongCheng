//
//  DDPeopleBelongCerti3Cell.m
//  GongChengDD
//
//  Created by xzx on 2018/10/10.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDPeopleBelongCerti3Cell.h"

@implementation DDPeopleBelongCerti3Cell

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
    
    
    
    self.timeLab1.text=@"有效期:";
    self.timeLab1.textColor=KColorGreySubTitle;
    self.timeLab1.font=kFontSize28;
    
    self.timeLab2.text=@"2010-04-10";
    self.timeLab2.textColor=KColorTextOrange;
    self.timeLab2.font=kFontSize28;
    
    self.arrow.image = [UIImage imageNamed:@"arrow_right"];
    
    _claimButton.layer.cornerRadius = 3;
    _claimButton.clipsToBounds = YES;
    [_claimButton addTarget:self action:@selector(claimButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)claimButtonClick{
    if ([_delegate respondsToSelector:@selector(peopleBelongCerti3CellClaimClick:)]) {
        [_delegate peopleBelongCerti3CellClaimClick:self];
    }
}

-(void)loadDataWithModel:(DDPeopleBelongCertiModel *)model{
    self.nameLab.text=model.name;
    
    self.roleLab.text=model.cert_type_name;
    CGRect frame_W = [model.cert_type_name boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize24} context:nil];
    //一级结构师3  二级结构师4  化工工程师5 一级建筑师6  二级建筑师7
    if([model.data_type isEqualToString:@"6"] || [model.data_type isEqualToString:@"7"]){//建筑师
        self.roleLab.textColor=KColorArchitect;
        self.roleLab.layer.borderColor=KColorArchitect.CGColor;
        self.roleLab.backgroundColor=KColorArchitectBg;
    }
    else if([model.data_type isEqualToString:@"3"] || [model.data_type isEqualToString:@"4"]){//结构师
        self.roleLab.textColor=KColorConstruct;
        self.roleLab.layer.borderColor=KColorConstruct.CGColor;
        self.roleLab.backgroundColor=KColorConstructBg;
    }
    else if([model.data_type isEqualToString:@"5"]){//化工工程师
        self.roleLab.textColor=KColorChemical;
        self.roleLab.layer.borderColor=KColorChemical.CGColor;
        self.roleLab.backgroundColor=KColorChemicalBg;
    }
    self.roleLabWidth.constant = frame_W.size.width+16;
    
    self.numLab2.text=model.cert_no;
    
    self.registerLab2.text=model.registered_no;
    
    self.timeLab2.text=model.validity_period_end;
    
    NSString *resultStr = [DDUtils newCompareTimeSpaceIn90:model.validity_period_end];
    if ([resultStr isEqualToString:@"2"]) {
        self.timeLab2.textColor=kColorBlue;
    }else if ([resultStr isEqualToString:@"1"]){
        self.timeLab2.textColor=KColorTextOrange;
    } else{
        self.timeLab2.textColor=kColorRed;
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
    return 155;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
