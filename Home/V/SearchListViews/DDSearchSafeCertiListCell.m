//
//  DDSearchSafeCertiListCell.m
//  GongChengDD
//
//  Created by xzx on 2018/9/19.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDSearchSafeCertiListCell.h"

@implementation DDSearchSafeCertiListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    //self.titleLab.text=@"南京和远建筑工程有限公司";
    self.titleLab.textColor=KColorCompanyTitleBalck;
    self.titleLab.font=kFontSize34;
    
    self.peopleLab1.text=@"主要负责人：";
    self.peopleLab1.textColor=KColorGreySubTitle;
    self.peopleLab1.font=kFontSize28;
    
    //self.peopleLab2.text=@"方久和";
    self.peopleLab2.textColor=kColorBlue;
    self.peopleLab2.font=kFontSize28;
    
    self.dateLab1.text=@"证书有效期：";
    self.dateLab1.textColor=KColorGreySubTitle;
    self.dateLab1.font=kFontSize28;
    
    //self.dateLab2.text=@"2015-11-13";
    self.dateLab2.textColor=KColorGreySubTitle;
    self.dateLab2.font=kFontSize28;
    
}

-(void)loadDataWithModel:(DDSearchSafeCertiListModel *)model{
    
    self.titleLab.attributedText = model.unitNameAttriStr;
    self.titleLab.font=kFontSize34;
    //self.titleLab.lineBreakMode = NSLineBreakByTruncatingTail;
    
    self.peopleLab2.attributedText = model.peopleAttriString;
    self.peopleLab2.font=kFontSize28;
    self.peopleLab2.lineBreakMode = NSLineBreakByTruncatingTail;
    //[self.peopleBtn setAttributedTitle:model.peopleAttriString forState:UIControlStateNormal];
    

    if (![DDUtils isEmptyString:model.validityPeriodEnd]) {
        self.dateLab2.text = model.validityPeriodEnd;
        
        NSString *tempStr=[NSString stringWithFormat:@"%@ 00:00:00",model.validityPeriodEnd];
        
        //timestr与当前时间相比,返回三种时间间隔的代号(0,1,2，3),0表示已过期，1表示90日之内，2表示超过90日，180日之内，3表示超过180日
        if ([[DDUtils compareTimeSpaceIn90DaysAndHalfYear:tempStr] isEqualToString:@"3"]) {
            self.dateLab2.textColor=kColorBlue;
        }
        else if([[DDUtils compareTimeSpaceIn90DaysAndHalfYear:tempStr] isEqualToString:@"2"]){
            self.dateLab2.textColor=KColorTextOrange;
        }
        else{
            self.dateLab2.textColor=kColorRed;
        }
    }
    else{
        self.dateLab2.text = @"-";
    }
    
}
    
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
