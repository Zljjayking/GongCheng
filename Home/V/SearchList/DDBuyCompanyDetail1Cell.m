//
//  DDBuyCompanyDetail1Cell.m
//  GongChengDD
//
//  Created by xzx on 2018/5/30.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDBuyCompanyDetail1Cell.h"

@implementation DDBuyCompanyDetail1Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.nameLab.text=@"南京建筑有限公司";
    self.nameLab.textColor=KColorCompanyTitleBalck;
    self.nameLab.font=KFontSize42;
    
    self.addressLab1.text=@"所在区域:";
    self.addressLab1.textColor=KColorGreySubTitle;
    self.addressLab1.font=kFontSize30;
    
    self.addressLab2.text=@"江苏-南京-浦口区";
    self.addressLab2.textColor=KColorBlackSubTitle;
    self.addressLab2.font=kFontSize30;
    
    self.timeLab1.text=@"发布时间:";
    self.timeLab1.textColor=KColorGreySubTitle;
    self.timeLab1.font=kFontSize30;
    
    self.timeLab2.text=@"2018-8-8";
    self.timeLab2.textColor=KColorBlackSubTitle;
    self.timeLab2.font=kFontSize30;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
