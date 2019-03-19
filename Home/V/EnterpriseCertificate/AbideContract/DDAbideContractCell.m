//
//  DDAbideContractCell.m
//  GongChengDD
//
//  Created by csq on 2018/9/19.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDAbideContractCell.h"

@implementation DDAbideContractCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _enterpriseNameLab.font = kFontSize32;
    _enterpriseNameLab.textColor = KColorBlackTitle;
    _enterpriseNameLab.numberOfLines = 0;
     
    _publishDateLab.font =kFontSize28;
    _publishDateLab.textColor = KColorGreySubTitle;
    
    _publisherLab.font = kFontSize28;
    _publisherLab.textColor = KColorGreySubTitle;
}
- (void)loadWithModel:(DDDAbideContractModel*)model{

    _enterpriseNameLab.text=model.title;

    NSString * date = [DDUtils getDateLineByStandardTime:model.publishDate];
    _publishDateLab.text = [NSString stringWithFormat:@"发布时间：%@",date];
    
    _publisherLab.text = [NSString stringWithFormat:@"发布机构：%@",model.publisher];
    
    [self layoutIfNeeded];
}
- (CGFloat)height{
    CGFloat certEndDateLabBottom = BOTTOM(_publisherLab);
    return certEndDateLabBottom + 20;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
