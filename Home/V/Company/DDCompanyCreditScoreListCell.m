//
//  DDCompanyCreditScoreListCell.m
//  GongChengDD
//
//  Created by xzx on 2018/9/19.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDCompanyCreditScoreListCell.h"

@implementation DDCompanyCreditScoreListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.nameLab1.text=@"企业名称";
    self.nameLab1.textColor=KColorGreySubTitle;
    self.nameLab1.font=kFontSize30;
    
    self.nameLab2.text=@"南京和远建筑工程有限公司";
    self.nameLab2.textColor=KColorBlackTitle;
    self.nameLab2.font=kFontSize32;
    
    self.cityLab1.text=@"评分城市";
    self.cityLab1.textColor=KColorGreySubTitle;
    self.cityLab1.font=kFontSize30;
    
    self.cityLab2.text=@"南京市";
    self.cityLab2.textColor=KColorBlackTitle;
    self.cityLab2.font=kFontSize32;
    
    self.line1.backgroundColor=KColorTableSeparator;
    
    self.timeLab1.text=@"评分时间";
    self.timeLab1.textColor=KColorGreySubTitle;
    self.timeLab1.font=kFontSize30;
    
    //self.timeLab2.text=@"2018-08-23";
    self.timeLab2.textColor=KColorBlackTitle;
    self.timeLab2.font=kFontSize32;
    
    self.line2.backgroundColor=KColorTableSeparator;
    
    self.majorLab1.text=@"信用主项";
    self.majorLab1.textColor=KColorGreySubTitle;
    self.majorLab1.font=kFontSize30;
    
    self.majorLab2.text=@"建筑工程";
    self.majorLab2.textColor=KColorBlackTitle;
    self.majorLab2.font=kFontSize32;
    
    self.line3.backgroundColor=KColorTableSeparator;
    
    self.scoreLab1.text=@"信用得分";
    self.scoreLab1.textColor=KColorGreySubTitle;
    self.scoreLab1.font=kFontSize30;
    
    self.scoreLab2.text=@"96分";
    self.scoreLab2.textColor=KColorBlackTitle;
    self.scoreLab2.font=kFontSize32;
    
    self.countName.text=@"评分机构";
    self.countName.textColor=KColorGreySubTitle;
    self.countName.font=kFontSize30;
    
    self.countNum.text=@"-";
    self.countNum.textColor=KColorBlackTitle;
    self.countNum.font=kFontSize32;
    
}

-(void)loadDataWithModel:(DDCompanyCreditScoreListModel *)model{
    self.nameLab2.text=model.enterpriseName;
    self.cityLab2.text=model.scoreCity;
    if (![DDUtils isEmptyString:model.scoreDate]) {
        self.timeLab2.text=[DDUtils getDateLineByStandardTime:model.scoreDate];
    }else{
        self.timeLab2.text=@"-";
    }
    
//    if ([model.scoreDateType isEqualToString:@"1"]) {//评分时间类型  1年月日   2年月   3没有时间   显示-
//        self.timeLab2.text=[DDUtils getDateLineByStandardTime:model.scoreDate];
//    }
//    else if ([model.scoreDateType isEqualToString:@"2"]) {
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//        NSDate * date = [dateFormatter dateFromString:model.scoreDate];
//
//        [dateFormatter setDateFormat:@"yyyy-MM"];
//        NSString *result = [dateFormatter stringFromDate:date];
//        self.timeLab2.text=result;
//    }
//    else{
//        self.timeLab2.text=@"-";
//    }
    
    self.majorLab2.text=model.creditItem;
    self.scoreLab2.text=model.score;
    self.countNum.text = model.department;
    
}
    
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
