//
//  DDIndustryNews4Cell.m
//  GongChengDD
//
//  Created by xzx on 2018/5/10.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDIndustryNews4Cell.h"
#import "DDLabelUtil.h"
@implementation DDIndustryNews4Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleLab.text=@"李克强:创新体制机制，更大释放科技人员创新创造力";
    self.titleLab.font=kFontSize34;
    self.titleLab.textColor=KColorBlackTitle;
    
    self.attachLab1.text=@"中国政府网";
    self.attachLab1.textColor=kColorGrey;
    self.attachLab1.font=kFontSize24;
    
    self.attachLab2.text=@"5.6万阅读";
    self.attachLab2.textColor=kColorGrey;
    self.attachLab2.font=kFontSize24;
    
    self.attachLab3.text=@"1分钟前";
    self.attachLab3.textColor=kColorGrey;
    self.attachLab3.font=kFontSize24;
    
    self.tipLab.text=@"置顶";
    self.tipLab.textColor=kColorRed;
    self.tipLab.font=kFontSize24;
    self.tipLab.textAlignment=NSTextAlignmentCenter;
    self.tipLab.layer.cornerRadius=2;
    self.tipLab.layer.borderColor=kColorRed.CGColor;
    self.tipLab.layer.borderWidth=0.5;
    
    self.imgView.layer.borderWidth=0.5;
    self.imgView.layer.borderColor=KColorTableSeparator.CGColor;
}
- (void)setTitleStr:(NSString *)titleStr {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 7;  //设置行间距
    paragraphStyle.lineBreakMode = self.titleLab.lineBreakMode;
    paragraphStyle.alignment = self.titleLab.textAlignment;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:titleStr];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [titleStr length])];
    self.titleLab.attributedText = attributedString;
    
//    [DDLabelUtil setLabelSpaceWithLabel:self.titleLab string:titleStr font:kFontSize34];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
