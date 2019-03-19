//
//  DDSearchCreditScoreListCell.m
//  GongChengDD
//
//  Created by xzx on 2018/9/21.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDSearchCreditScoreListCell.h"

@implementation DDSearchCreditScoreListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleLab.textColor=KColorBlackTitle;
    self.titleLab.font=kFontSize34;
    
    self.majorLab1.text=@"信用主项：";
    self.majorLab1.textColor=KColorGreySubTitle;
    self.majorLab1.font=kFontSize28;
    
    self.majorLab2.textColor=KColorGreySubTitle;
    self.majorLab2.font=kFontSize28;
    
    self.scoreLab1.text=@"信用分：";
    self.scoreLab1.textColor=KColorGreySubTitle;
    self.scoreLab1.font=kFontSize28;
    
    self.scoreLab2.textColor=KColorGreySubTitle;
    self.scoreLab2.font=kFontSize28;
}

-(void)loadDataWithModel:(DDSearchCreditScoreListModel *)model{
    self.titleLab.attributedText = model.enterpriseNameAttrStr;
    
    self.titleLab.font=kFontSize34;
    
    self.majorLab2.text=model.creditItem;
    
    self.scoreLab2.text=model.score;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
