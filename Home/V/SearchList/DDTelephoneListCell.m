//
//  DDTelephoneListCell.m
//  GongChengDD
//
//  Created by xzx on 2018/6/13.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDTelephoneListCell.h"

@implementation DDTelephoneListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.nameLab.textColor=KColorCompanyTitleBalck;
    self.nameLab.font=kFontSize34;
    
    self.peopleLab1.text=@"法定代表人:";
    self.peopleLab1.textColor=KColorGreySubTitle;
    self.peopleLab1.font=kFontSize28;
    
    //self.peopleLab2.text=@"吴春军";
    self.peopleLab2.textColor=KColorBlackTitle;
    self.peopleLab2.font=kFontSize28;
    
    self.telLab1.text=@"电话:";
    self.telLab1.textColor=KColorGreySubTitle;
    self.telLab1.font=kFontSize28;
    
    self.telLab2.text=@"010-88405079";
    self.telLab2.textColor=kColorBlue;
    self.telLab2.font=kFontSize28;
}

-(void)loadDataWithModel:(DDSearchTelephoneListModel *)model{
//    if (![DDUtils isEmptyString:model.unitName]) {
//        NSString *titleStr=[NSString stringWithFormat:@"<font color='#111111'>%@</font>",model.unitName];
//        NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithData:[titleStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
//
//        self.nameLab.attributedText = attributeStr;
//        self.nameLab.font=kFontSize34;
//    }
    self.nameLab.attributedText = model.enterpriseNameStr;
    self.nameLab.font=kFontSize34;
    
//    if (![DDUtils isEmptyString:model.legalRepresentative]) {
//        NSString *titleStr=[NSString stringWithFormat:@"<font color='#222222'>%@</font>",model.legalRepresentative];
//        NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithData:[titleStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
//
//        self.peopleLab2.attributedText = attributeStr;
//        self.peopleLab2.font=kFontSize28;
//    }
    self.peopleLab2.attributedText = model.peopleNameStr;
    self.peopleLab2.font=kFontSize28;
    
    if ([DDUtils isEmptyString:model.phone]) {
        self.telLab2.text=@"暂无";
        self.telLab2.textColor=KColorGreySubTitle;
    }
    else{
        self.telLab2.text=model.phone;
        self.telLab2.textColor=kColorBlue;
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
