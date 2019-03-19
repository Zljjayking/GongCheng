//
//  DDRewardGloryCell.m
//  GongChengDD
//
//  Created by xzx on 2018/6/4.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDRewardGloryCell.h"

@implementation DDRewardGloryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    //self.nameLab.text=@"李和远";
    self.nameLab.textColor=KColorBlackTitle;
    self.nameLab.font=kFontSize34;
    
    self.rewardLab1.text=@"获得奖项:";
    self.rewardLab1.textColor=KColorGreySubTitle;
    self.rewardLab1.font=kFontSize28;
    
    self.rewardLab2.text=@"金陵杯";
    self.rewardLab2.textColor=KColorGreySubTitle;
    self.rewardLab2.font=kFontSize28;
    
    self.deptLab1.text=@"实施部门:";
    self.deptLab1.textColor=KColorGreySubTitle;
    self.deptLab1.font=kFontSize28;
    
    self.deptLab2.text=@"浙江省建筑业管理局";
    self.deptLab2.textColor=KColorGreySubTitle;
    self.deptLab2.font=kFontSize28;
    
    self.timeLab1.text=@"发布时间:";
    self.timeLab1.textColor=KColorGreySubTitle;
    self.timeLab1.font=kFontSize28;
    
    self.timeLab2.text=@"2018-03-29";
    self.timeLab2.textColor=KColorGreySubTitle;
    self.timeLab2.font=kFontSize28;
}
//获奖荣誉使用
-(void)loadDataWithModel:(DDSearchRewardGloryListModel *)model{
//    if (![DDUtils isEmptyString:model.staff_name]) {
//        NSString *titleStr=[NSString stringWithFormat:@"<font color='#222222'>%@</font>",model.staff_name];
//        NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithData:[titleStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
//
//        self.nameLab.attributedText = attributeStr;
//        self.nameLab.font=kFontSize34;
//    }
//    else{
//        if (![DDUtils isEmptyString:model.enterprise_name]) {
//            NSString *titleStr=[NSString stringWithFormat:@"<font color='#222222'>%@</font>",model.enterprise_name];
//            NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithData:[titleStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
//
//            self.nameLab.attributedText = attributeStr;
//            self.nameLab.font=kFontSize34;
//        }
//    }
    
    if (![DDUtils isEmptyString:model.enterprise_name]) {
        NSString *titleStr=[NSString stringWithFormat:@"<font color='#222222'>%@</font>",model.enterprise_name];
        NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithData:[titleStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        
        self.nameLab.attributedText = attributeStr;
        self.nameLab.font=kFontSize34;
    }
    
    //self.nameLab.text=model.reward_explain;
    self.rewardLab2.text=model.reward_type;
    self.deptLab2.text=model.executor_defendant;
    self.timeLab2.text=model.reward_issue_time;
}
//文明公司,绿色工地,使用
- (void)loadWithCultureWorkSiteModel:(DDCultureWorkSiteModel*)model{
    _nameLab.text = model.title;
    
    _rewardLab1.text = @"项目经理:";
    _rewardLab2.text = model.staffName;
    
    _deptLab1.text = @"发布机构:";
    _deptLab2.text = model.executorDefendant;
    
    _timeLab1.text = @"发布时间:";
    _timeLab2.text = model.rewardIssueTime;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
