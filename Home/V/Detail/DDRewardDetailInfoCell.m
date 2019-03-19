//
//  DDRewardDetailInfoCell.m
//  GongChengDD
//
//  Created by xzx on 2018/6/6.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDRewardDetailInfoCell.h"

@implementation DDRewardDetailInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleLab.text=@"栖霞区石阜桥片区保障性住房项目";
    self.titleLab.textColor=KColorCompanyTitleBalck;;
    self.titleLab.font=KFontSize38;
    
    
    self.peopleLab1.text=@"获奖人:";
    self.peopleLab1.textColor=KColorGreySubTitle;
    self.peopleLab1.font=kFontSize30;
    
    self.peopleLab2.text=@"张三";
    self.peopleLab2.textColor=KColorBlackSubTitle;;
    self.peopleLab2.font=kFontSize30;
    
    
    self.rewardLab1.text=@"获得奖项:";
    self.rewardLab1.textColor=KColorGreySubTitle;
    self.rewardLab1.font=kFontSize30;
    
    self.rewardLab2.text=@"金陵杯";
    self.rewardLab2.textColor=KColorBlackSubTitle;;
    self.rewardLab2.font=kFontSize30;
    
    
    self.deptLab1.text=@"实施部门:";
    self.deptLab1.textColor=KColorGreySubTitle;
    self.deptLab1.font=kFontSize30;
    
    self.deptLab2.text=@"浙江省建筑业管理局";
    self.deptLab2.textColor=KColorBlackSubTitle;;
    self.deptLab2.font=kFontSize30;
    
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
