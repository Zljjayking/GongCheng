//
//  DDShareholderInfoCell.m
//  GongChengDD
//
//  Created by csq on 2018/10/19.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDShareholderInfoCell.h"

@implementation DDShareholderInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _holderNameLab.font = kFontSize34;
    _holderNameLab.textColor = KColorCompanyTitleBalck;
    
    
    _line1.backgroundColor = KColorTableSeparator;
    _line2.backgroundColor = KColorTableSeparator;
    
    _paidPercentMarkLab.text = @"持股比例";
    _paidPercentMarkLab.textColor = KColorGreySubTitle;
    _paidPercentMarkLab.font = kFontSize30;
//    _paidPercentMarkLab.textAlignment = NSTextAlignmentCenter;
    
    _paidPercentLab.font = kFontSize32;
    _paidPercentLab.textColor = KColorBlackTitle;

    
    _holderTypeMarkLab.text = @"股东类型";
    _holderTypeMarkLab.textColor = KColorGreySubTitle;
    _holderTypeMarkLab.font = kFontSize30;

    
    _holderTypeLab.font = kFontSize32;
    _holderTypeLab.textColor = KColorBlackTitle;
    
    
    _amountMrakLab.text = @"认缴出资额(万元)";
    _amountMrakLab.textColor = KColorGreySubTitle;
    _amountMrakLab.font = kFontSize30;

    
    _amountLab.font = kFontSize32;
    _amountLab.textColor = KColorBlackTitle;

    
    _dateMarkLab.text = @"认缴出资日期";
    _dateMarkLab.textColor = KColorGreySubTitle;
    _dateMarkLab.font = kFontSize30;


    _dateLab.font = kFontSize32;
    _dateLab.textColor = KColorBlackTitle;

}

- (void)loadWithModel:(DDDDShareholderInfoModel*)model indexPath:(NSIndexPath*)indexPath{
    //第一个是大股东
    NSString *nameStr = [NSString stringWithFormat:@"%@  ",model.holderName];
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc]initWithString:nameStr];
    
    NSTextAttachment *attach = [[NSTextAttachment alloc]init];
    if (indexPath.section == 0) {
        attach.image = DDIMAGE(@"home_holder");
        attach.bounds = CGRectMake(0, -1, WidthByiPhone6(38), WidthByiPhone6(15));
        NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attach];
        [mutableAttributedString insertAttributedString:string atIndex:nameStr.length];
        _holderNameLab.attributedText = mutableAttributedString;
    }else{
        _holderNameLab.text = model.holderName;
    }

    _paidPercentLab.text = [NSString stringWithFormat:@"%@%@",model.paidPercent,@"%"];
    _holderTypeLab.text = model.holderType;
    if ([model.shareAmount hasSuffix:@"万元"]) {
        model.shareAmount = [model.shareAmount substringToIndex:(model.shareAmount.length-2)];
    }
    _amountLab.text = model.shareAmount;
    
    if ([DDUtils isEmptyString:model.paidDate]) {
        _dateLab.text = @"-";
    }else{
        _dateLab.text = model.paidDate;
    }
    
    
    [self layoutIfNeeded];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
