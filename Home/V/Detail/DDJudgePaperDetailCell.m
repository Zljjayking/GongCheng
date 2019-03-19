//
//  DDJudgePaperDetailCell.m
//  GongChengDD
//
//  Created by xzx on 2018/8/8.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDJudgePaperDetailCell.h"

@implementation DDJudgePaperDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.textView.scrollEnabled=NO;
    self.textView.userInteractionEnabled=NO;
    self.textView.textContainerInset = UIEdgeInsetsZero;
    self.textView.textContainer.lineFragmentPadding = 0;
    
    self.tipLab.text=@"内容";
    self.tipLab.textColor=KColorGreySubTitle;
    self.tipLab.font=kFontSize30;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
