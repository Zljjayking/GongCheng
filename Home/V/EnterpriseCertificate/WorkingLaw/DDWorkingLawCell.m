//
//  DDWorkingLawCell.m
//  GongChengDD
//
//  Created by csq on 2018/9/20.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDWorkingLawCell.h"

@implementation DDWorkingLawCell


//@property (weak, nonatomic) IBOutlet UILabel *titleLab;
//@property (weak, nonatomic) IBOutlet UILabel *numberMarkLab;
//@property (weak, nonatomic) IBOutlet UILabel *numberLab;
//@property (weak, nonatomic) IBOutlet UILabel *awardYearMarkLab;
//@property (weak, nonatomic) IBOutlet UILabel *awardYearLab;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _titleLab.font = kFontSize32;
    _titleLab.textColor = KColorBlackTitle;
    _titleLab.numberOfLines = 0;
    
    _numberMarkLab.text = @"工法编号:";
    _numberMarkLab.font = kFontSize28;
    _numberMarkLab.textColor = KColorGreySubTitle;
    
    _numberLab.font =kFontSize28;
    _numberLab.textColor = KColorGreySubTitle;
    
    _awardYearMarkLab.text = @"授予年度:";
    _awardYearMarkLab.font = kFontSize28;
    _awardYearMarkLab.textColor = KColorGreySubTitle;
    
    _awardYearLab.font = kFontSize28;
    _awardYearLab.textColor = KColorGreySubTitle;
    
}

- (void)loadWithModel:(DDWorkingLawModel*)model{
    _titleLab.text = model.title;
    if([DDUtils isEmptyString:model.number]){
        _numberLab.text = @"-";
    }else{
        _numberLab.text = model.number;
    }
    _awardYearLab.text = model.awardYear;
    [self layoutIfNeeded];
}
- (CGFloat)height{
    CGFloat certEndDateLabBottom = BOTTOM(_awardYearLab);
    return certEndDateLabBottom + 15;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
