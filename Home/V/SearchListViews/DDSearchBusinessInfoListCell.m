//
//  DDSearchBusinessInfoListCell.m
//  GongChengDD
//
//  Created by xzx on 2018/9/19.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDSearchBusinessInfoListCell.h"

@implementation DDSearchBusinessInfoListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    //self.titleLab.text=@"南京和远建筑工程有限公司";
    self.titleLab.textColor=KColorCompanyTitleBalck;
    self.titleLab.font=kFontSize34;
    
    self.peopleLab1.text=@"法定代表人：";
    self.peopleLab1.textColor=KColorGreySubTitle;
    self.peopleLab1.font=kFontSize28;
    
    //self.peopleLab2.text=@"方久和";
    self.peopleLab2.textColor=kColorBlue;
    self.peopleLab2.font=kFontSize28;
    
    self.dateLab1.text=@"成立日期：";
    self.dateLab1.textColor=KColorGreySubTitle;
    self.dateLab1.font=kFontSize28;
    
    //self.dateLab2.text=@"2015-11-13";
    self.dateLab2.textColor=KColorGreySubTitle;
    self.dateLab2.font=kFontSize28;
    
    //self.statusLab.text=@"在业";
    self.statusLab.textColor=kColorBlue;
    self.statusLab.font=kFontSize26;
    self.statusLab.layer.cornerRadius=3;
    self.statusLab.layer.borderColor=kColorBlue.CGColor;
    self.statusLab.layer.borderWidth=0.5;
    self.statusLab.textAlignment=NSTextAlignmentCenter;
}

-(void)loadDataWithModel:(DDSearchBusinessInfoListModel *)model{
    
    self.titleLab.attributedText = model.unitNameAttriStr;
    self.titleLab.font=kFontSize34;
    //self.titleLab.lineBreakMode = NSLineBreakByTruncatingTail;
    
    self.peopleLab2.attributedText = model.peopleAttriString;
    self.peopleLab2.font=kFontSize28;
    self.peopleLab2.lineBreakMode = NSLineBreakByTruncatingTail;
    //[self.peopleBtn setAttributedTitle:model.peopleAttriString forState:UIControlStateNormal];
    
    self.dateLab2.text = model.establishedDate;
    
    self.statusLab.text=model.status;
    if ([model.status isEqualToString:@"注销"]) {
        self.statusLab.textColor=kColorRed;
        self.statusLab.layer.borderColor=kColorRed.CGColor;
    }
    else{
        self.statusLab.textColor=kColorBlue;
        self.statusLab.layer.borderColor=kColorBlue.CGColor;
    }
}
    
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
