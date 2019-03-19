//
//  DDFindingConditionActionCell.m
//  GongChengDD
//
//  Created by csq on 2018/11/6.
//  Copyright © 2018 Koncendy. All rights reserved.
//

#import "DDFindingConditionActionCell.h"

@implementation DDFindingConditionActionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    //加圆角
    _actionButton.layer.cornerRadius = 3;
    _actionButton.clipsToBounds = YES;
    [_actionButton setTitle:@"查找" forState:UIControlStateNormal];
    [_actionButton setTitle:@"查找" forState:UIControlStateHighlighted];
    [_actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    //加边框
//    _actionButton.layer.borderColor = KColorTableSeparator.CGColor;
//    _actionButton.layer.borderWidth = 0.5;
}
- (void)loadWithModel:(DDFindingConditionModel*)model{
    BOOL canAction = [model.canAction boolValue];
    if (canAction == YES) {
        _actionButton.userInteractionEnabled = YES;
        [_actionButton setBackgroundImage:[UIImage imageNamed:@"login_button_blue"] forState:UIControlStateNormal];
        [_actionButton setBackgroundImage:[UIImage imageNamed:@"UIControlStateNormal"] forState:UIControlStateHighlighted];
    }else{
        _actionButton.userInteractionEnabled = NO;
        [_actionButton setBackgroundImage:[UIImage imageNamed:@"login_button_bluewhite"] forState:UIControlStateNormal];
        [_actionButton setBackgroundImage:[UIImage imageNamed:@"login_button_bluewhite"] forState:UIControlStateHighlighted];
    }
}
+(CGFloat)height{
    return 44;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
