//
//  DDAgencySelect1Cell.m
//  GongChengDD
//
//  Created by xzx on 2018/6/28.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDAgencySelect1Cell.h"

@implementation DDAgencySelect1Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleLab.text=@"江苏建设集团培训中心";
    self.titleLab.textColor=KColorBlackTitle;
    self.titleLab.font=kFontSize34;
    
    self.unitLab.text=@"元";
    self.unitLab.textColor=KColorGreySubTitle;
    self.unitLab.font=kFontSize26;
    
    self.moneyLab.text=@"800";
    self.moneyLab.textColor=kColorBlue;
    self.moneyLab.font=KFontSize42Bold;
    
    
    self.addressImg.image=[UIImage imageNamed:@"home_select_address"];
    
    self.addressLab.text=@"南京市玄武区龙蟠路63号";
    self.addressLab.textColor=KColorGreySubTitle;
    self.addressLab.font=kFontSize28;
    
    [self.assignBtn setTitle:@"在线报名" forState:UIControlStateNormal];
    [self.assignBtn setTitleColor:kColorBlue forState:UIControlStateNormal];
    self.assignBtn.titleLabel.font=kFontSize28;
    self.assignBtn.layer.borderColor=kColorBlue.CGColor;
    self.assignBtn.layer.borderWidth=1.2;
    self.assignBtn.layer.cornerRadius=3;
    self.assignBtn.clipsToBounds=YES;
    
    self.arrowImg.image=[UIImage imageNamed:@"home_select_down"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
