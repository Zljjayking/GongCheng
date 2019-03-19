//
//  DDAdminPunishDetail2Cell.m
//  GongChengDD
//
//  Created by xzx on 2018/10/22.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDAdminPunishDetail2Cell.h"

@implementation DDAdminPunishDetail2Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.headLab.text=@"截图";
    self.headLab.textColor=KColorBlackTitle;
    self.headLab.font=kFontSize30;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
