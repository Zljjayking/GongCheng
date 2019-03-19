//
//  DDMyCollectionReusableHeadView.m
//  GongChengDD
//
//  Created by Koncendy on 2017/12/4.
//  Copyright © 2017年 Koncendy. All rights reserved.
//

#import "DDMyCollectionReusableHeadView.h"

@implementation DDMyCollectionReusableHeadView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _currentCityWidth.constant=(Screen_Width-50)/4;
    self.currentCityBtn.backgroundColor=KColorCompanyTransfetGray;
    self.currentCityBtn.layer.cornerRadius=5;
    self.currentCityBtn.layer.masksToBounds=YES;
    self.currentCityBtn.titleLabel.font=kFontSize28;
    self.seperateLine.backgroundColor=KColor30AlphaBlack;
    [self.currentCityBtn setTitleColor:KColorBlackTitle forState:UIControlStateNormal];
}

@end
