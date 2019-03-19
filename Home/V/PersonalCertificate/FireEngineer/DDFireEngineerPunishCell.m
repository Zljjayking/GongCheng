//
//  DDFireEngineerPunishCell.m
//  GongChengDD
//
//  Created by xzx on 2018/9/26.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDFireEngineerPunishCell.h"

@implementation DDFireEngineerPunishCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.dateLab1.text=@"处罚日期";
    self.dateLab1.textColor=KColorGreySubTitle;
    self.dateLab1.font=kFontSize30;
    
    self.dateLab2.textColor=KColorBlackTitle;
    self.dateLab2.font=kFontSize30;
    
    self.lineLab1.backgroundColor=KColorTableSeparator;
    
    self.typeLab1.text=@"处罚种类";
    self.typeLab1.textColor=KColorGreySubTitle;
    self.typeLab1.font=kFontSize30;
    
    self.typeLab2.textColor=KColorBlackTitle;
    self.typeLab2.font=kFontSize30;
    
    
    self.deptLab1.text=@"承办单位";
    self.deptLab1.textColor=KColorGreySubTitle;
    self.deptLab1.font=kFontSize30;
    
    self.deptLab2.textColor=KColorBlackTitle;
    self.deptLab2.font=kFontSize30;
    
    self.lineLab2.backgroundColor=KColorTableSeparator;
    
    self.punishLab1.text=@"火灾处罚";
    self.punishLab1.textColor=KColorGreySubTitle;
    self.punishLab1.font=kFontSize30;
    
    self.punishLab2.textColor=KColorBlackTitle;
    self.punishLab2.font=kFontSize30;
    
    
    self.causeLab1.text=@"案由";
    self.causeLab1.textColor=KColorGreySubTitle;
    self.causeLab1.font=kFontSize30;
    
    self.causeLab2.textColor=KColorBlackTitle;
    self.causeLab2.font=kFontSize30;
    
    self.lineLab3.backgroundColor=KColorTableSeparator;
    
    self.projectLab1.text=@"关联项目";
    self.projectLab1.textColor=KColorGreySubTitle;
    self.projectLab1.font=kFontSize30;
    
    self.projectLab2.textColor=KColorBlackTitle;
    self.projectLab2.font=kFontSize30;
}

-(void)loadDataWithModel:(DDFireEngineerPunishModel *)model{
    if (![DDUtils isEmptyString:model.punishTime]) {
        self.dateLab2.text=[DDUtils getDateLineByStandardTime:model.punishTime];
    }
    else{
        self.dateLab2.text=@"";
    }
    
    self.typeLab2.text=model.punishType;
    
    self.deptLab2.text=model.unit;
    
    self.punishLab2.text=model.firePunish;
    
    self.causeLab2.text=model.punishCase;
    
    self.projectLab2.text=model.projectRef;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
