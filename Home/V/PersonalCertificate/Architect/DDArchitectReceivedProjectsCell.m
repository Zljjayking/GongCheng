//
//  DDArchitectReceivedProjectsCell.m
//  GongChengDD
//
//  Created by xzx on 2018/9/29.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDArchitectReceivedProjectsCell.h"

@implementation DDArchitectReceivedProjectsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.tilteLab.textColor=KColorBlackTitle;
    self.tilteLab.font=kFontSize32;
    
    self.codeLab1.text=@"项目编码：";
    self.codeLab1.textColor=KColorGreySubTitle;
    self.codeLab1.font=kFontSize28;
    
    self.codeLab2.textColor=KColorBlackSubTitle;
    self.codeLab2.font=kFontSize28;
    
    self.typeLab1.text=@"项目类别：";
    self.typeLab1.textColor=KColorGreySubTitle;
    self.typeLab1.font=kFontSize28;
    
    self.typeLab2.textColor=KColorBlackSubTitle;
    self.typeLab2.font=kFontSize28;
    
    self.regionLab1.text=@"项目属地：";
    self.regionLab1.textColor=KColorGreySubTitle;
    self.regionLab1.font=kFontSize28;
    
    self.regionLab2.textColor=KColorBlackSubTitle;
    self.regionLab2.font=kFontSize28;
    
    self.deptLab1.text=@"建设单位：";
    self.deptLab1.textColor=KColorGreySubTitle;
    self.deptLab1.font=kFontSize28;
    
    self.deptLab2.textColor=KColorBlackSubTitle;
    self.deptLab2.font=kFontSize28;
}

-(void)loadDataWithModel:(DDArchitectReceivedProjectsModel *)model{
    self.tilteLab.text=model.title;
    
    self.codeLab2.text=model.achCode;
    
    self.typeLab2.text=model.type;
    
    self.regionLab2.text=model.address;
    
    self.deptLab2.text=model.enterprise_name;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
