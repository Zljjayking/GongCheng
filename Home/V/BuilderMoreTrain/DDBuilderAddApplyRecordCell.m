//
//  DDBuilderAddApplyRecordCell.m
//  GongChengDD
//
//  Created by xzx on 2018/7/20.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDBuilderAddApplyRecordCell.h"

@implementation DDBuilderAddApplyRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.companyLab.text=@"南京和远建筑工程有限公司";
    self.companyLab.textColor=KColorGreySubTitle;
    self.companyLab.font=kFontSize30;
    
    self.majorLab.text=@"报名截图已上传";
    self.majorLab.textColor=KColorGreySubTitle;
    self.majorLab.font=kFontSize30;
    
    self.peopleLab.text=@"张三";
    self.peopleLab.textColor=KColorBlackTitle;
    self.peopleLab.font=kFontSize30;
//    [self.peopleLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self).offset(12);
//
//    }];
    self.numberLab.text=@"(211322182746722738)";
    self.numberLab.textColor=KColorGreySubTitle;
    self.numberLab.font=kFontSize30;
//    [self.numberLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self).offset(-12);
//        make.left.equalTo(self.peopleLab.mas_right).offset(5);
//    }];
    self.arrowImg.image=[UIImage imageNamed:@"home_com_more"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
