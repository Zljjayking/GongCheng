//
//  DDAccidentSituationInfoCell.m
//  GongChengDD
//
//  Created by xzx on 2018/6/6.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDAccidentSituationInfoCell.h"
#import "DDLabelUtil.h"

@implementation DDAccidentSituationInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleLab.text=@"栖霞区石阜桥片区保障性住房项目";
    self.titleLab.textColor=KColorCompanyTitleBalck;;
    self.titleLab.font=KFontSize38;
    
    
    self.managerLab1.text=@"项目经理:";
    self.managerLab1.textColor=KColorGreySubTitle;
    self.managerLab1.font=kFontSize30;
    
    self.managerLab2.text=@"杨亚萍";
    self.managerLab2.textColor=KColorBlackSubTitle;;
    self.managerLab2.font=kFontSize30;
    
    
    self.timeLab1.text=@"发布时间:";
    self.timeLab1.textColor=KColorGreySubTitle;
    self.timeLab1.font=kFontSize30;
    
    self.timeLab2.text=@"2018-03-29";
    self.timeLab2.textColor=KColorBlackSubTitle;;
    self.timeLab2.font=kFontSize30;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
