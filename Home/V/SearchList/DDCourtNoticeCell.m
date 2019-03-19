//
//  DDCourtNoticeCell.m
//  GongChengDD
//
//  Created by xzx on 2018/5/17.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDCourtNoticeCell.h"

@implementation DDCourtNoticeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    //self.titleLab.text=@"七里河区润微手机通讯店";
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
    
    self.timeLab1.text=@"发布时间:";
    self.timeLab1.textColor=KColorGreySubTitle;
    self.timeLab1.font=kFontSize28;
    
    self.timeLab2.text=@"2018-03-29";
    self.timeLab2.textColor=KColorGreySubTitle;
    self.timeLab2.font=kFontSize28;
}

-(void)loadDataWithModel:(DDSearchCourtNoticeListModel *)model{
    if (![DDUtils isEmptyString:model.enterprise_name]) {
        NSString *titleStr=[NSString stringWithFormat:@"<font color='#222222'>%@</font>",model.enterprise_name];
        NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithData:[titleStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        
        self.titleLab.attributedText = attributeStr;
        self.titleLab.font=kFontSize34;
    }
    
    //self.titleLab.text=model.notice_title;
    self.typeLab2.text=model.notice_type;
    self.peopleLab2.text=model.notice_publisher;
    self.timeLab2.text=model.notice_publish_date;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
