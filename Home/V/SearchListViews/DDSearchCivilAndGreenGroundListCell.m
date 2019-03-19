//
//  DDSearchCivilAndGreenGroundListCell.m
//  GongChengDD
//
//  Created by xzx on 2018/9/21.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDSearchCivilAndGreenGroundListCell.h"

@implementation DDSearchCivilAndGreenGroundListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleLab.textColor=KColorBlackTitle;
    self.titleLab.font=kFontSize34;
    
    self.managerLab1.text=@"项目经理：";
    self.managerLab1.textColor=KColorGreySubTitle;
    self.managerLab1.font=kFontSize28;
    
    self.managerLab2.textColor=KColorGreySubTitle;
    self.managerLab2.font=kFontSize28;
    
    self.agencyLab1.text=@"发布机构：";
    self.agencyLab1.textColor=KColorGreySubTitle;
    self.agencyLab1.font=kFontSize28;
    
    self.agencyLab2.textColor=KColorGreySubTitle;
    self.agencyLab2.font=kFontSize28;
    
    self.timeLab1.text=@"发布时间：";
    self.timeLab1.textColor=KColorGreySubTitle;
    self.timeLab1.font=kFontSize28;
    
    self.timeLab2.textColor=KColorGreySubTitle;
    self.timeLab2.font=kFontSize28;
}

-(void)loadDataWithModel:(DDSearchCivilAndGreenGroundListModel *)model{
    self.titleLab.attributedText = model.titleAttrStr;
    self.titleLab.font=kFontSize34;
    
    self.managerLab2.text = model.staffName;
    
    self.agencyLab2.text=model.executorDefendant;
    
    self.timeLab2.text=model.rewardIssueTime;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
