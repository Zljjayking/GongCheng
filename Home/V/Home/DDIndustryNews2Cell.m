//
//  DDIndustryNews2Cell.m
//  GongChengDD
//
//  Created by xzx on 2018/5/10.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDIndustryNews2Cell.h"

@implementation DDIndustryNews2Cell

- (void)awakeFromNib {
    [super awakeFromNib];
 
    self.titleLab.text=@"关于政府的行业新闻";
    self.titleLab.textColor=KColorBlackTitle;
    self.titleLab.font=KfontSize34Bold;
    
    self.attachLab1.text=@"住建部官网";
    self.attachLab1.textColor=kColorGrey;
    self.attachLab1.font=kFontSize24;
    
    self.attachLab2.text=@"5.6万阅读";
    self.attachLab2.textColor=kColorGrey;
    self.attachLab2.font=kFontSize24;
    
    self.attachLab3.text=@"2分钟前";
    self.attachLab3.textColor=kColorGrey;
    self.attachLab3.font=kFontSize24;
    
    self.linkView.backgroundColor=KColorLinkBackViewColor;
    
    self.linkLab.textColor=KColorLinkLabTextColor;
    self.linkLab.font=kFontSize26;
    NSMutableParagraphStyle  *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle  setLineSpacing:6];
    NSString  *testString = @"改革开放以来特别是近几年，我国的工程建设和建筑业发展都非常快。";
    NSMutableAttributedString  *setString = [[NSMutableAttributedString alloc] initWithString:testString];
    [setString  addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [testString length])];
    [self.linkLab  setAttributedText:setString];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
