//
//  DDBrandDetailSeversCell.m
//  GongChengDD
//
//  Created by csq on 2018/9/25.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDBrandDetailSeversCell.h"

@implementation DDBrandDetailSeversCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _titleLab.textColor = KColorBlackTitle;
    _titleLab.font = kFontSize32;
}

- (void)loadWithTitle:(NSString*)title{
    _titleLab.text = title;
}
+ (CGFloat)height{
    return 49;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
