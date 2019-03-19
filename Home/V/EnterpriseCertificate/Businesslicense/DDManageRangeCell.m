//
//  DDManageRangeCell.m
//  GongChengDD
//
//  Created by csq on 2018/8/10.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDManageRangeCell.h"
#import "DDLabelUtil.h"


@implementation DDManageRangeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleLab.textColor = KColorGreySubTitle;
    self.titleLab.font = kFontSize30;
    
    self.contentLab.textColor = KColorBlackTitle;
    self.contentLab.font =  kFontSize32;
    
}
- (void)loadWithContent:(NSString*)content showAll:(BOOL)showAll{
    if (YES == showAll) {
        //如果完全显示
        self.contentLab.numberOfLines = 0;
        //self.contentLab.text = content;
        if (NO == [DDUtils isEmptyString:content]) {
            [DDLabelUtil setLabelSpaceWithLabel:_contentLab string:content font:kFontSize32];
        }
        [self.contentLab sizeToFit];
    }else{
        //如果只显示2行
        self.contentLab.numberOfLines = 2;
        //self.contentLab.text = content;
        if (NO == [DDUtils isEmptyString:content]) {
            [DDLabelUtil setLabelSpaceWithLabel:self.contentLab string:(NSString *)content font:kFontSize32];
        }
    }
}
- (CGFloat)heightWithContent:(NSString*)content showAll:(BOOL)showAll{
    
    if (YES == showAll) {
        //如果完全显示
        CGFloat contentHeight = [DDLabelUtil getSpaceLabelHeightWithString:content font:kFontSize32 width:(Screen_Width-24)];
        return contentHeight + 72;
    }
    else{
        //如果只显示2行
        return 40 +72;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
