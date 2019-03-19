//
//  DDAdminPunishDetail1Cell.m
//  GongChengDD
//
//  Created by xzx on 2018/10/22.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDAdminPunishDetail1Cell.h"

@implementation DDAdminPunishDetail1Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleLab.textColor=KColorCompanyTitleBalck;
    self.titleLab.font=kFontSize30Bold;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
