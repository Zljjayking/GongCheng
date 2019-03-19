//
//  DDCompanyListCell.m
//  GongChengDD
//
//  Created by xzx on 2018/5/15.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDCompanyListCell.h"

@implementation DDCompanyListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    //self.titleLab.text=@"南京和远建筑工程有限公司";
    self.titleLab.textColor=KColorCompanyTitleBalck;
    self.titleLab.font=kFontSize34;
    
    //self.areaLab.text=@"南京市六合区/方久和";
    self.areaLab.textColor=KColorGreySubTitle;
    self.areaLab.font=kFontSize28;
    
    //self.descLab.text=@"市政工程施工总承包，输变电工程专业承包，建工程施工总承包";
    self.descLab.textColor=KColorGreySubTitle;
    self.descLab.font=kFontSize28;
    
    
    self.statusLab.font=kFontSize26;
    self.statusLab.layer.borderWidth=0.5;
    self.statusLab.layer.cornerRadius=3;
    self.statusLab.clipsToBounds=YES;
}

-(void)loadDataWithModel:(DDSearchCompanyListModel *)model{
    
    self.titleLab.attributedText = model.unitNameAttriStr;
    self.titleLab.font=kFontSize34;
    self.titleLab.lineBreakMode = NSLineBreakByTruncatingTail;
    

    self.areaLab.text=model.areaStr;
    
    
    [self.peopleBtn setAttributedTitle:model.peopleAttriString forState:UIControlStateNormal];
    
    self.descLab.attributedText = model.certAttriString;
    self.descLab.font=kFontSize28;
    self.descLab.lineBreakMode = NSLineBreakByTruncatingTail;
    
    if ([DDUtils isEmptyString:model.status]) {
        self.statusLab.hidden=YES;
    }
    else{
        if ([model.flagstatus isEqualToString:@"1"]) {
            self.statusLab.textColor=kColorRed;
            self.statusLab.layer.borderColor=kColorRed.CGColor;
        }
        else{
            self.statusLab.textColor=kColorBlue;
            self.statusLab.layer.borderColor=kColorBlue.CGColor;
        }
        self.statusLab.hidden=NO;
        self.statusLab.text=model.status;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
