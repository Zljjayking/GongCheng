//
//  DDExcutedPropleCell.m
//  GongChengDD
//
//  Created by xzx on 2018/5/17.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDExcutedPropleCell.h"

@implementation DDExcutedPropleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    //self.nameLab.text=@"李和远";
    self.nameLab.textColor=KColorBlackTitle;
    self.nameLab.font=kFontSize34;
    
    self.numLab1.text=@"判决案号:";
    self.numLab1.textColor=KColorGreySubTitle;
    self.numLab1.font=kFontSize28;
    
    //self.numLab2.text=@"(2018)粤0306执4964号";
    self.numLab2.textColor=KColorGreySubTitle;
    self.numLab2.font=kFontSize28;

    self.aimLab1.text=@"执行标的:";
    self.aimLab1.textColor=KColorGreySubTitle;
    self.aimLab1.font=kFontSize28;
    
    self.aimLab2.text=@"23043082";
    self.aimLab2.textColor=KColorGreySubTitle;
    self.aimLab2.font=kFontSize28;
    
    self.courtLab1.text=@"执行法院:";
    self.courtLab1.textColor=KColorGreySubTitle;
    self.courtLab1.font=kFontSize28;
    
    self.courtLab2.text=@"深圳市宝安区人民法院";
    self.courtLab2.textColor=KColorGreySubTitle;
    self.courtLab2.font=kFontSize28;
    
    self.timeLab1.text=@"立案时间:";
    self.timeLab1.textColor=KColorGreySubTitle;
    self.timeLab1.font=kFontSize28;
    
    self.timeLab2.text=@"2018-03-29";
    self.timeLab2.textColor=KColorGreySubTitle;
    self.timeLab2.font=kFontSize28;
}

-(void)loadDataWithModel:(DDSerarchExcutedPeopleListModel *)model{
    if (![DDUtils isEmptyString:model.execute_person]) {
        NSString *titleStr=[NSString stringWithFormat:@"<font color='#222222'>%@</font>",model.execute_person];
        NSAttributedString *title = [[NSAttributedString alloc] initWithData:[titleStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        self.nameLab.attributedText = title;
        self.nameLab.font=kFontSize34;
    }
    
//    if (![DDUtils isEmptyString:model.execute_case_number]) {
//        NSString *titleStr=[NSString stringWithFormat:@"<font color='#888888'>%@</font>",model.execute_case_number];
//        NSAttributedString *title = [[NSAttributedString alloc] initWithData:[titleStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
//        self.numLab2.attributedText = title;
//        self.numLab2.font=kFontSize28;
//    }
    
    self.numLab2.text=model.execute_case_number;
    self.aimLab2.text=model.execute_standard;
    self.courtLab2.text=model.execute_court;
    //self.timeLab2.text=model.execute_create_date;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
