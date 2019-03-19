//
//  DDCompanyExcutedCell.m
//  GongChengDD
//
//  Created by xzx on 2018/6/5.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDCompanyExcutedCell.h"

@implementation DDCompanyExcutedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.numLab.text=@"(2018)粤0306执4964号";
    self.numLab.textColor=KColorBlackTitle;
    self.numLab.font=kFontSize34;
    
    self.aimLab1.text=@"执行标的:";
    self.aimLab1.textColor=KColorGreySubTitle;
    self.aimLab1.font=kFontSize28;
    
    self.aimLab2.text=@"2303568";
    self.aimLab2.textColor=KColorGreySubTitle;
    self.aimLab2.font=kFontSize28;
    
    self.courtLab1.text=@"执行法院:";
    self.courtLab1.textColor=KColorGreySubTitle;
    self.courtLab1.font=kFontSize28;
    
    self.courtLab2.text=@"深圳市宝安区人民法院";
    self.courtLab2.textColor=KColorGreySubTitle;
    self.courtLab2.font=kFontSize28;
    
    self.createTimeLab1.text=@"立案时间:";
    self.createTimeLab1.textColor=KColorGreySubTitle;
    self.createTimeLab1.font=kFontSize28;
    
    self.createTimeLab2.text=@"2018-03-09";
    self.createTimeLab2.textColor=KColorGreySubTitle;
    self.createTimeLab2.font=kFontSize28;
    
    self.publishTimeLab1.text=@"发布时间:";
    self.publishTimeLab1.textColor=KColorGreySubTitle;
    self.publishTimeLab1.font=kFontSize28;
    
    self.publishTimeLab2.text=@"2018-03-09";
    self.publishTimeLab2.textColor=KColorGreySubTitle;
    self.publishTimeLab2.font=kFontSize28;
}

-(void)loadDataWithModel:(DDCompanyExcutedModel *)model{
    self.numLab.text=model.execute_case_number;
    self.aimLab2.text=model.execute_standard;
    self.courtLab2.text=model.execute_court;
    
    if ([DDUtils isEmptyString:model.execute_create_date]) {
        self.createTimeLab2.text=@"-";
    }else{
        self.createTimeLab2.text=model.execute_create_date;
    }
    if ([DDUtils isEmptyString:model.execute_publish_date]) {
        self.publishTimeLab2.text=@"-";
    }else{
        self.publishTimeLab2.text=model.execute_publish_date;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
