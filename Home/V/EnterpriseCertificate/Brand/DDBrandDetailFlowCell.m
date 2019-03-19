//
//  DDBrandDetailFlowCell.m
//  GongChengDD
//
//  Created by csq on 2018/9/25.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDBrandDetailFlowCell.h"

@implementation DDBrandDetailFlowCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _topLine.backgroundColor = KColorTableSeparator;
    
    _bottomLine.backgroundColor = KColorTableSeparator;
    
    _timeLab.textColor = kColorBlue;
    _timeLab.font = kFontSize28;
    
    _stateLab.textColor = KColorBlackTitle;
    _stateLab.font = kFontSize30;
}
- (void)loadWithModel:(DDBrandDetailFlowsModel*)model indexPath:(NSIndexPath *)indexPath{
    _timeLab.text = model.time;
    _stateLab.text = model.content;
    
    if (indexPath.row == 0) {
        _topLine.hidden = YES;//隐藏顶部线
        _markImageView.image = [UIImage imageNamed:@"ec_bluePoint"];
        _timeLab.textColor = kColorBlue;
        _stateLab.textColor = kColorBlue;
    }else{
        _topLine.hidden = NO;//显示顶部线
        _markImageView.image = [UIImage imageNamed:@"ec_grayPoint"];
        _timeLab.textColor = KColorGreySubTitle;
        _stateLab.textColor = KColorBlackTitle;
    }
}
+ (CGFloat)height{
    return 85;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
