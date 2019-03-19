//
//  DDSearchManageSystemListCell.m
//  GongChengDD
//
//  Created by xzx on 2018/9/21.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDSearchManageSystemListCell.h"

@implementation DDSearchManageSystemListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleLab.textColor=KColorBlackTitle;
    self.titleLab.font=kFontSize34;
    
    self.numberLab1.text=@"证书编号：";
    self.numberLab1.textColor=KColorGreySubTitle;
    self.numberLab1.font=kFontSize28;
    
    self.numberLab2.textColor=KColorGreySubTitle;
    self.numberLab2.font=kFontSize28;
    
    self.dateLab1.text=@"发证日期：";
    self.dateLab1.textColor=KColorGreySubTitle;
    self.dateLab1.font=kFontSize28;
    
    self.dateLab2.textColor=KColorGreySubTitle;
    self.dateLab2.font=kFontSize28;
    
    self.validLab1.text=@"有效期：";
    self.validLab1.textColor=KColorGreySubTitle;
    self.validLab1.font=kFontSize28;
    
    //self.validLab2.textColor=KColorGreySubTitle;
    self.validLab2.font=kFontSize28;
}

-(void)loadDataWithModel:(DDSearchManageSystemListModel *)model{
    self.titleLab.attributedText = model.titleAttrStr;
    self.titleLab.font=kFontSize34;
    
    self.numberLab2.text=model.certNum;
    
    self.dateLab2.text=model.publishDate;
    
    if (![DDUtils isEmptyString:model.validityPeriodEnd]) {
        self.validLab2.text=model.validityPeriodEnd;
        NSString *resultStr = [DDUtils newCompareTimeSpaceIn90:model.validityPeriodEnd];
        if ([resultStr isEqualToString:@"2"]) {
            self.validLab2.textColor=kColorBlue;
        }else if ([resultStr isEqualToString:@"1"]){
            self.validLab2.textColor=KColorTextOrange;
        } else{
            self.validLab2.textColor=kColorRed;
        }
    }
    else{
        self.validLab2.text = @"-";
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
