//
//  DDCompanyCourtNoticeCell.m
//  GongChengDD
//
//  Created by xzx on 2018/6/5.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDCompanyCourtNoticeCell.h"

@implementation DDCompanyCourtNoticeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleLab.text=@"七里河区润微手机通讯店";
    self.titleLab.textColor=KColorBlackTitle;
    self.titleLab.font=kFontSize34;
    
    self.typeLab1.text=@"公告类型:";
    self.typeLab1.textColor=KColorGreySubTitle;
    self.typeLab1.font=kFontSize28;
    
    self.typeLab2.text=@"起诉状副本及开庭传票";
    self.typeLab2.textColor=KColorGreySubTitle;
    self.typeLab2.font=kFontSize28;
    
    self.peopleLab1.text=@"公告人:";
    self.peopleLab1.textColor=KColorGreySubTitle;
    self.peopleLab1.font=kFontSize28;
    
    self.peopleLab2.text=@"[甘肃]兰城市城关区人民法院票";
    self.peopleLab2.textColor=KColorGreySubTitle;
    self.peopleLab2.font=kFontSize28;
    
    self.publishTimeLab1.text=@"发布时间:";
    self.publishTimeLab1.textColor=KColorGreySubTitle;
    self.publishTimeLab1.font=kFontSize28;
    
    self.publishTimeLab2.text=@"2018-03-29";
    self.publishTimeLab2.textColor=KColorGreySubTitle;
    self.publishTimeLab2.font=kFontSize28;
}

-(void)loadDataWithModel:(DDCompanyCourtNoticeModel *)model{
    
    self.titleLab.text=model.enterprise_name;
    //self.titleLab.text=model.notice_title;
    self.typeLab2.text=model.notice_type;
    self.peopleLab2.text=model.notice_publisher;
    self.publishTimeLab2.text=model.notice_publish_date;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
