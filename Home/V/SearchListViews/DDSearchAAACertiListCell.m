//
//  DDSearchAAACertiListCell.m
//  GongChengDD
//
//  Created by xzx on 2018/9/21.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDSearchAAACertiListCell.h"

@implementation DDSearchAAACertiListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleLab.textColor=KColorBlackTitle;
    self.titleLab.font=kFontSize34;
    
    self.gradeLab1.text=@"信用等级：";
    self.gradeLab1.textColor=KColorGreySubTitle;
    self.gradeLab1.font=kFontSize28;
    
    self.gradeLab2.textColor=KColorBlackTitle;
    self.gradeLab2.font=kFontSize28;
    
    self.dateLab1.text=@"有效期：";
    self.dateLab1.textColor=KColorGreySubTitle;
    self.dateLab1.font=kFontSize28;
    
    //self.dateLab2.textColor=KColorGreySubTitle;
    self.dateLab2.font=kFontSize28;
}

-(void)loadDataWithModel:(DDSearchAAACertiListModel *)model{
    self.titleLab.attributedText = model.enterpriseNameAttrStr;
    self.titleLab.font=kFontSize34;
    
    self.gradeLab2.text=model.level;
    
    if (![DDUtils isEmptyString:model.publishDate]) {
        self.dateLab2.text=model.publishDate;
        
        NSString *tempStr=[NSString stringWithFormat:@"%@ 00:00:00",model.publishDate];
        
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
