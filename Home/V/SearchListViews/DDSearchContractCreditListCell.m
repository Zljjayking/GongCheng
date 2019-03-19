//
//  DDSearchContractCreditListCell.m
//  GongChengDD
//
//  Created by xzx on 2018/9/20.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDSearchContractCreditListCell.h"

@implementation DDSearchContractCreditListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleLab.textColor=KColorBlackTitle;
    self.titleLab.font=kFontSize34;
    
    self.numberLab1.text=@"发布时间：";
    self.numberLab1.textColor=KColorGreySubTitle;
    self.numberLab1.font=kFontSize28;
    
    self.numberLab2.textColor=KColorGreySubTitle;
    self.numberLab2.font=kFontSize28;
    
    self.yearLab1.text=@"发布机构：";
    self.yearLab1.textColor=KColorGreySubTitle;
    self.yearLab1.font=kFontSize28;
    
    self.yearLab2.textColor=KColorGreySubTitle;
    self.yearLab2.font=kFontSize28;
}

-(void)loadDataWithModel:(DDSearchContractCreditListModel *)model{
    self.titleLab.attributedText = model.titleAttrStr;
    self.titleLab.font=kFontSize34;
    
    self.numberLab2.text=model.publishDate;
    
    self.yearLab2.text=model.publisher;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
