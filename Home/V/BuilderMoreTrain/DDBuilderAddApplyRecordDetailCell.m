//
//  DDBuilderAddApplyRecordDetailCell.m
//  GongChengDD
//
//  Created by xzx on 2018/7/20.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDBuilderAddApplyRecordDetailCell.h"

@implementation DDBuilderAddApplyRecordDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.titleLab.textColor=KColorBlackTitle;
    self.titleLab.font=kFontSize32;
    
    self.detailLab.textColor=KColorBidApprovalingWait;
    self.detailLab.font=kFontSize30;
    [self.detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLab.mas_right).offset(12);
        make.right.equalTo(self.mas_right).offset(-12);
        make.centerY.equalTo(self.titleLab);
        make.height.mas_equalTo(30);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
