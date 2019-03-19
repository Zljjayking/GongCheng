//
//  DDFireEngineerExperienceCell.m
//  GongChengDD
//
//  Created by xzx on 2018/9/26.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDFireEngineerExperienceCell.h"

@implementation DDFireEngineerExperienceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.titleLab.textColor=KColorCompanyTitleBalck;
    self.titleLab.font=kFontSize34;
    
    self.dutyLab1.text=@"担任职责：";
    self.dutyLab1.textColor=KColorGreySubTitle;
    self.dutyLab1.font=kFontSize28;
    
    self.dutyLab2.textColor=KColorBlackSubTitle;
    self.dutyLab2.font=kFontSize28;
    
    self.dateLab1.text=@"日期：";
    self.dateLab1.textColor=KColorGreySubTitle;
    self.dateLab1.font=kFontSize28;
    
    self.dateLab2.textColor=KColorBlackSubTitle;
    self.dateLab2.font=kFontSize28;
}

-(void)loadDataWithModel:(DDFireEngineerExperienceModel *)model{
    self.titleLab.text=model.title;
    self.dutyLab2.text=model.duty;
    if (![DDUtils isEmptyString:model.time]) {
        self.dateLab2.text=model.time;
    }
    else{
        self.dateLab2.text=@"";
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
