//
//  DDManageDetailSingleTitleCell.m
//  GongChengDD
//
//  Created by csq on 2018/9/19.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDManageDetailSingleTitleCell.h"

@implementation DDManageDetailSingleTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _nameLab.textColor = KColorGreySubTitle;
    _nameLab.font = kFontSize32;
    
    _nameLab.numberOfLines = 0;
    
   _bottomLine.backgroundColor = KColorTableSeparator;
}
- (void)loadWithName:(NSString*)name{
    if ([DDUtils isEmptyString:name]) {
        _nameLab.text = @"-";
    }else{
        _nameLab.text = name;
    }
    _nameLab.textColor = KColorGreySubTitle;
    _nameLab.font = kFontSize32;
    
    [self layoutIfNeeded];
}
//施工工法section == 0用
- (void)loadWithWorkLawDetailName:(NSString*)name{
    _nameLab.text = name;

    _nameLab.textColor = KColorBlackTitle;
    _nameLab.font = kFontSize34;
    
    [self layoutIfNeeded];
}


- (CGFloat)height{
    CGFloat nameBottom = BOTTOM(_nameLab);
    return nameBottom +28;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
