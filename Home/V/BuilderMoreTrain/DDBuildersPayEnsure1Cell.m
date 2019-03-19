//
//  DDBuildersPayEnsure1Cell.m
//  GongChengDD
//
//  Created by xzx on 2018/6/28.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDBuildersPayEnsure1Cell.h"

@implementation DDBuildersPayEnsure1Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleLab1.text=@"订单名称";
    self.titleLab1.textColor=KColorGreySubTitle;
    self.titleLab1.font=kFontSize30;
    
    self.titleLab2.text=@"二级建造师继续教育";
    self.titleLab2.textColor=KColorBlackTitle;
    self.titleLab2.font=kFontSize30;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
