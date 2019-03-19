//
//  DDAptitudeCertiListCell.m
//  GongChengDD
//
//  Created by xzx on 2018/12/11.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDAptitudeCertiListCell.h"

@implementation DDAptitudeCertiListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _titleLab.font = kFontSize32;
    _titleLab.textColor = KColorBlackTitle;
    
    _dateLab1.text=@"发证日期";
    _dateLab1.font = kFontSize28;
    _dateLab1.textColor = KColorGreySubTitle;
    
    _dateLab2.font = kFontSize28;
    _dateLab2.textColor = KColorBlackTitle;
    
    _validLab1.text=@"有效期至";
    _validLab1.font = kFontSize28;
    _validLab1.textColor = KColorGreySubTitle;
    
    _validLab2.font = kFontSize28;
    _validLab2.textColor = KColorBlackTitle;
}

-(void)loadDataWithModel:(DDAptitudeContent *)model{
    _titleLab.text=model.name;
    if (![DDUtils isEmptyString:model.issuedDate]) {
        _dateLab1.hidden = NO;
        _dateLab2.hidden = NO;
        _dateLab2.text=[DDUtils getSecDateChineseByStandardTime:model.issuedDate];
    }
    else{
        _dateLab1.hidden = YES;
        _dateLab2.hidden = YES;
        [_validLab1 mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(23);
        }];
        [_validLab2 mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(23);
        }];
    }
    if (![DDUtils isEmptyString:model.validityPeriodEnd]) {
        _validLab2.hidden = NO;
        _validLab1.hidden = NO;
        _validLab2.text= [DDUtils getSecDateChineseByStandardTime:model.validityPeriodEnd];
       
        NSString *resultStr = [DDUtils newCompareTimeSpaceIn180:model.validityPeriodEnd];
         //0表示已过期，1表示180日之内，2表示超过180日
        if ([resultStr isEqualToString:@"2"]) {
            _validLab2.textColor = KColorFindingPeopleBlue;
        }
        else if([resultStr isEqualToString:@"1"]){
            _validLab2.textColor = KColorTextOrange;
        }
        else{
            _validLab2.textColor = kColorRed;
        }
    }
    else{
        _validLab2.hidden = YES;
        _validLab1.hidden = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
