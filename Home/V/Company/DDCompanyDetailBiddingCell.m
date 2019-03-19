//
//  DDCompanyDetailBiddingCell.m
//  GongChengDD
//
//  Created by xzx on 2018/5/14.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDCompanyDetailBiddingCell.h"

@implementation DDCompanyDetailBiddingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor=kColorWhite;
    
    self.deadTimeLab.text=@"截止2018-05-23";
    self.deadTimeLab.textColor=KColorGreySubTitle;
    self.deadTimeLab.font=kFontSize26;
    
    self.biddingLab.text=@"共计中标5个    总金额3126.23万元";
    self.biddingLab.textColor=KColorBlackTitle;
    self.biddingLab.font=kFontSize30;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
