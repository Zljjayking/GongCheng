//
//  DDBuyCompanyList1Cell.m
//  GongChengDD
//
//  Created by xzx on 2018/5/30.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDBuyCompanyList1Cell.h"

@implementation DDBuyCompanyList1Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.nameLab.text=@"南京建筑工程有限公司";
    self.nameLab.textColor=KColorCompanyTitleBalck;
    self.nameLab.font=kFontSize34;
    
    self.descLab.text=@"城市及道路照明工程专业承包特级、建筑施工总承包";
    self.descLab.textColor=KColorGreySubTitle;
    self.descLab.font=kFontSize28;
    
    self.addressLab.text=@"江苏省南京市浦口区";
    self.addressLab.textColor=KColorGreySubTitle;
    self.addressLab.font=kFontSize28;
    
    self.unitLab.text=@"万元";
    self.unitLab.textColor=KColorCompanyTitleBalck;
    self.unitLab.font=kFontSize30;
    
    self.moneyLab.text=@"500";
    self.moneyLab.textColor=kColorBlue;
    self.moneyLab.font=KFontSize42Bold;
    
    self.timeLab.text=@"2018年06月10日发布";
    self.timeLab.textColor=KColorGreySubTitle;
    self.timeLab.font=kFontSize28;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
