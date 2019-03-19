//
//  DDBrandCell.m
//  GongChengDD
//
//  Created by csq on 2018/9/20.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDBrandCell.h"
#import "UIImageView+WebCache.h"

@implementation DDBrandCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _nameLab.numberOfLines = 0;
    _nameLab.textColor = KColorBlackTitle;
    _nameLab.font = kFontSize34;
    
    _statesLab.textColor = kColorBlue;
    _statesLab.font = kFontSize26;
    _statesLab.textAlignment = NSTextAlignmentCenter;
    //加圆角
    _statesLab.layer.cornerRadius = 3;
    _statesLab.clipsToBounds = YES;
    //加边框
    _statesLab.layer.borderColor = kColorBlue.CGColor;
    _statesLab.layer.borderWidth = 0.5;
//    _statesLab.backgroundColor = [UIColor redColor];
    
    
    _registerNumLab.textColor = KColorGreySubTitle;
    _registerNumLab.font = kFontSize28;
    
    _applyDateLab.textColor = KColorGreySubTitle;
    _applyDateLab.font = kFontSize28;
    
    _typeLab.textColor = KColorGreySubTitle;
    _typeLab.font = kFontSize28;
    
    _arrow.image = [UIImage imageNamed:@"arrow_right"];
    
    //加圆角
//    _logoImageView.layer.cornerRadius = 3;
//    _logoImageView.clipsToBounds = YES;
    //加边框
    _logoImageView.layer.borderColor = KColorTableSeparator.CGColor;
    _logoImageView.layer.borderWidth = 0.5;
    
    _logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    
     _logoImageView.backgroundColor = [UIColor whiteColor];

}
- (void)loadWithModel:(DDBrandListModel*)model{
    //加载图片
//    NSString * urlString = [NSString stringWithFormat:@"%@%@",DD_Http_Image_Server,headImageURL];
    
    [_logoImageView sd_setImageWithURL:[NSURL URLWithString: model.brand_img] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (image) {
            _logoImageView.image = image;
        }
    }];
    
    _nameLab.text = model.brand_name;
    
    //如果有状态,显示
   // 如果没状态,隐藏
    if ([DDUtils isEmptyString:model.brand_status] || [model.brand_status isEqualToString:@"-"]) {
        _statesLab.text = @"";
        _statesLab.hidden = YES;
        _statesLabHeight.constant = 0;
    }else{
        CGFloat statesWidth = [DDUtils widthForText:model.brand_status withTextHeigh:20 withFont:kFontSize26];
        _statesLab.text = model.brand_status;
        _statesLab.hidden = NO;
      
        _statesLabWidth.constant = statesWidth+5;
        _statesLabHeight.constant = 20;
    }
    
    _registerNumLab.text = [NSString stringWithFormat:@"注册编号:%@",model.register_id];
    _applyDateLab.text = [NSString stringWithFormat:@"申请时间:%@",model.application_date];
    _typeLab.text = [NSString stringWithFormat:@"商标类型:%@",model.brand_type];
    
    [self layoutIfNeeded];
}
- (CGFloat)height{
    CGFloat typeLabBottom = BOTTOM(_typeLab);
    return typeLabBottom+15;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
