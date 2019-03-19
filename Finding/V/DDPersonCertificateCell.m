//
//  DDPersonCertificateCell.m
//  GongChengDD
//
//  Created by csq on 2018/11/6.
//  Copyright © 2018 Koncendy. All rights reserved.
//

#import "DDPersonCertificateCell.h"

@implementation DDPersonCertificateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _titleLab.font = kFontSize32;
    _titleLab.textColor = KColorBlackTitle;
    
    _arrow.image = [UIImage imageNamed:@"find_select"];
    
    _line.backgroundColor = KColorTableSeparator;
}
- (void)loadWithTltle:(NSString*)title myRow:(NSInteger)myRow  pointRow:(NSInteger)pointRow{
    _titleLab.text = title;
    
    if (myRow == pointRow) {
        _titleLab.textColor = kColorBlue;
        _arrow.hidden = NO;
    }else{
        _titleLab.textColor = KColorBlackTitle;
        _arrow.hidden = YES;
    }
}
+(CGFloat)height{
    return 45.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
