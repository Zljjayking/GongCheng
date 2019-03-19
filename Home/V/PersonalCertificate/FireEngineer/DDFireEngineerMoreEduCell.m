//
//  DDFireEngineerMoreEduCell.m
//  GongChengDD
//
//  Created by xzx on 2018/9/26.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDFireEngineerMoreEduCell.h"

@implementation DDFireEngineerMoreEduCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.yearLab1.text=@"教育年份";
    self.yearLab1.textColor=KColorGreySubTitle;
    self.yearLab1.font=kFontSize30;
    
    self.yearLab2.textColor=KColorBlackTitle;
    self.yearLab2.font=kFontSize32;
    
    self.lineLab.backgroundColor=KColorTableSeparator;
    
    self.dateLab1.text=@"完成日期";
    self.dateLab1.textColor=KColorGreySubTitle;
    self.dateLab1.font=kFontSize30;
    
    self.dateLab2.textColor=KColorBlackTitle;
    self.dateLab2.font=kFontSize32;
    
    self.statusLab1.text=@"完成情况";
    self.statusLab1.textColor=KColorGreySubTitle;
    self.statusLab1.font=kFontSize30;
    
    self.statusLab2.textColor=KColorBlackTitle;
    self.statusLab2.font=kFontSize32;
}

-(void)loadDataWithModel:(DDFireEngineerMoreEduModel *)model{
    self.yearLab2.text=model.year;
    if (![DDUtils isEmptyString:model.endTime]) {
        self.dateLab2.text=model.endTime;
    }
    else{
        self.dateLab2.text=@"";
    }
    
    self.statusLab2.text=model.remark;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
