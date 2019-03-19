//
//  DDAddressManageCell.m
//  GongChengDD
//
//  Created by xzx on 2018/7/3.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDAddressManageCell.h"

@implementation DDAddressManageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.nameLab.text=@"王明凯";
    self.nameLab.textColor=KColorBlackTitle;
    self.nameLab.font=kFontSize32;
    
    self.telLab.text=@"15295412414";
    self.telLab.textColor=KColorBlackTitle;
    self.telLab.font=kFontSize32;
    
    self.addressLab.text=@"江苏省南京市雨花台区云密城K栋13层";
    self.addressLab.textColor=KColorGreySubTitle;
    self.addressLab.font=kFontSize30;
    
    self.seperateLine.backgroundColor=KColorTableSeparator;
    
    
    self.defaultLab.text=@"默认地址";
    self.defaultLab.textColor=KColorBlackTitle;
    self.defaultLab.font=kFontSize30;
    
    
    self.editImg.image=[UIImage imageNamed:@"home_address_edit"];
    
    self.editLab.text=@"编辑";
    self.editLab.textColor=KColorBlackTitle;
    self.editLab.font=kFontSize30;
    
    
    self.deleteImg.image=[UIImage imageNamed:@"home_address_delete"];
    
    self.deleteLab.text=@"删除";
    self.deleteLab.textColor=KColorBlackTitle;
    self.deleteLab.font=kFontSize30;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
