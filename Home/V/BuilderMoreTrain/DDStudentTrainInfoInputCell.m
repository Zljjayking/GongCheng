//
//  DDStudentTrainInfoInputCell.m
//  GongChengDD
//
//  Created by xzx on 2018/7/6.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDStudentTrainInfoInputCell.h"

@implementation DDStudentTrainInfoInputCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleLab.textColor=KColorBlackTitle;
    self.titleLab.font=kFontSize32;
    
    self.detailLab.textColor=KColorBidApprovalingWait;
    self.detailLab.font=kFontSize30;
    
    self.imgView.image=[UIImage imageNamed:@"home_com_more"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
