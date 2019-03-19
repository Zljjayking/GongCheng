//
//  DDTaxIllegalCell.m
//  GongChengDD
//
//  Created by xzx on 2018/10/26.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDTaxIllegalCell.h"

@implementation DDTaxIllegalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.propertyLab1.text=@"案件性质：";
    self.propertyLab1.textColor=KColorGreySubTitle;
    self.propertyLab1.font=kFontSize28;
    
    self.propertyLab2.text=@"其他";
    self.propertyLab2.textColor=KColorGreySubTitle;
    self.propertyLab2.font=kFontSize28;
    
    self.timeLab1.text=@"发布时间：";
    self.timeLab1.textColor=KColorGreySubTitle;
    self.timeLab1.font=kFontSize28;
    
    self.timeLab2.text=@"2017-10-29";
    self.timeLab2.textColor=KColorGreySubTitle;
    self.timeLab2.font=kFontSize28;
    
    self.deptLab1.text=@"所属机关：";
    self.deptLab1.textColor=KColorGreySubTitle;
    self.deptLab1.font=kFontSize28;
    
    self.deptLab2.text=@"-";
    self.deptLab2.textColor=KColorGreySubTitle;
    self.deptLab2.font=kFontSize28;
}

-(void)loadDataWithModel:(DDTaxIllegalModel *)model{
    if (![DDUtils isEmptyString:model.type]) {
        self.propertyLab2.text=model.type;
    }
    else{
        self.propertyLab2.text=@"-";
    }
    
    if (![DDUtils isEmptyString:model.publishTime]) {
        self.timeLab2.text=model.publishTime;
    }
    else{
        self.timeLab2.text=@"-";
    }
    
    if (![DDUtils isEmptyString:model.department]) {
        self.deptLab2.text=model.department;
    }
    else{
        self.deptLab2.text=@"-";
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
