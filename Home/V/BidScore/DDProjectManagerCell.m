//
//  DDProjectManagerCell.m
//  GongChengDD
//
//  Created by csq on 2018/5/30.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDProjectManagerCell.h"

@implementation DDProjectManagerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _projectManagerLab.textColor = KColorCompanyTitleBalck;
    _projectManagerLab.font = kFontSize34;
    
    _certificateLab.textColor = KColorGreySubTitle;
    _certificateLab.font = kFontSize28;
    _certificateLab.text = @"证书";
    
    _projectLab.textColor = KColorGreySubTitle;
    _projectLab.font = kFontSize28;
    _projectLab.text = @"个人业绩";
    
    _punishLab.textColor = KColorGreySubTitle;
    _punishLab.font = kFontSize28;
    _punishLab.text = @"行政处罚";
    
    _rewardLab.textColor = KColorGreySubTitle;
    _rewardLab.font = kFontSize28;
    _rewardLab.text = @"获奖荣誉";
    
    _certificateNumLab.font = kFontSize28;
    _certificateNumLab.textColor = KColorGreySubTitle;
    
    _projectNumLab.font = kFontSize28;
    _projectNumLab.textColor = KColorGreySubTitle;
    
    _punishNumLab.font = kFontSize28;
    _punishNumLab.textColor = KColorGreySubTitle;
    
    _rewardNumLab.font = kFontSize28;
    _rewardNumLab.textColor = KColorGreySubTitle;
}
- (void)loadWithModel:(DDProjectManagerModel*)model{
    _projectManagerLab.text = model.project_manager;
    
    NSInteger totalCer = [model.cert_count integerValue];
    _certificateNumLab.text = [NSString stringWithFormat:@"%ld",(long)totalCer];
    if (totalCer>0) {  //大于0时的颜色
        _certificateNumLab.textColor = kColorBlue;
    }
    else{
        _certificateNumLab.textColor = KColorGreySubTitle;
    }
    
    _projectNumLab.text =  model.project_count;
    if ( [model.project_count integerValue]>0) {//大于0时的颜色
        _projectNumLab.textColor = kColorBlue;
    }else{
        _projectNumLab.textColor = KColorGreySubTitle;
    }
    
    _punishNumLab.text =  model.punish_count;
    if ([model.punish_count integerValue]>0) {//大于0时的颜色
        _punishNumLab.textColor = kColorBlue;
    }else{
        _punishNumLab.textColor = KColorGreySubTitle;
    }
    
    _rewardNumLab.text = model.reward_count;
    if ([model.reward_count integerValue]>0) { //大于0时的颜色
        _rewardNumLab.textColor = kColorBlue;
    }else{
        _rewardNumLab.textColor = KColorGreySubTitle;
    }
}

+ (CGFloat)height{
    return 90;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
