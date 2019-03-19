//
//  DDBranchInfoCell.m
//  GongChengDD
//
//  Created by csq on 2018/10/23.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDBranchInfoCell.h"

@implementation DDBranchInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _titleLab.textColor = KColorBlackTitle;
    _titleLab.font =  kFontSize32;
    _titleLab.numberOfLines = 0;
    
   
}
- (void)loadWithTitle:(NSString*)title{
    
    _titleLab.text = title;
    
     [self layoutIfNeeded];
}

-(CGFloat)height{
    CGFloat titleBottom = BOTTOM(_titleLab);
    return titleBottom+12;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
