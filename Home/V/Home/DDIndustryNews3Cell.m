//
//  DDIndustryNews3Cell.m
//  GongChengDD
//
//  Created by xzx on 2018/5/10.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDIndustryNews3Cell.h"
#import "DDLabelUtil.h"

@implementation DDIndustryNews3Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    //home_type_loading
    self.serveContentLab.font=kFontSize34;
    self.serveContentLab.textColor=KColorBlackTitle;
    
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
    
    self.img1.layer.borderWidth=0.5;
    self.img1.layer.borderColor=KColorTableSeparator.CGColor;
    
    self.img2.layer.borderWidth=0.5;
    self.img2.layer.borderColor=KColorTableSeparator.CGColor;
    
    self.img3.layer.borderWidth=0.5;
    self.img3.layer.borderColor=KColorTableSeparator.CGColor;
}

//加载数据
-(void)loadDataWithContent:(NSString *)content{
    if (![DDUtils isEmptyString:content]) {
        [DDLabelUtil setLabelSpaceWithLabel:self.serveContentLab string:content font:kFontSize34];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
