//
//  DDAptitudeCerContentCell.m
//  GongChengDD
//
//  Created by csq on 2018/5/25.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDAptitudeCerContentCell.h"

@implementation DDAptitudeCerContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _titleLab.font = kFontSize32;
    _titleLab.textColor = KColorBlackTitle;
    
//    _subTitleLab.font = kFontSize28;
//    _subTitleLab.textColor = KColorGreySubTitle;
    
}
- (void)loadWithModel:(DDSubitemModel*)model{

    //不拼接,直接使用certTypeSource
    _titleLab.text = model.certTypeSource;
    
//    //certTypeId如果是2204开头,是电力资质
//    //区分电力资质和其它资质
//    BOOL  isElectric = [model.certTypeId hasPrefix:@"2204"];
//    if (isElectric == YES) {
//        //电力资质
//        if ([DDUtils isEmptyString:model.status]) {
//            _subTitleLab.text = @"许可状态: -";
//        }else if ([model.status isEqualToString:@"有效"]) {
//            NSString * totalString = @"许可状态 有效";
//            NSString * rangeString = @"有效";
//            NSMutableAttributedString * attributedString = [DDUtils adjustTextColor:totalString rangeText:rangeString color:KColorBlackTitle];
//            _subTitleLab.attributedText = attributedString;
//        }else if ([model.status isEqualToString:@"过期"]){
//            NSString * totalString = @"许可状态 过期";
//            NSString * rangeString = @"过期";
//            NSMutableAttributedString * attributedString = [DDUtils adjustTextColor:totalString rangeText:rangeString color:kColorRed];
//            _subTitleLab.attributedText = attributedString;
//        }else{
//            NSString * totalString = @"许可状态 注销";
//            NSString * rangeString = @"注销";
//            NSMutableAttributedString * attributedString = [DDUtils adjustTextColor:totalString rangeText:rangeString color:kColorRed];
//            _subTitleLab.attributedText = attributedString;
//        }
//
//    }else{
//        //其它资质
//        if (![DDUtils isEmptyString:model.approvalDate]) {
//            NSString * time = [DDUtils getDateChineseByStandardTime:model.approvalDate];
//            _subTitleLab.text = [NSString stringWithFormat:@"%@批准",time];
//        }else{
//            _subTitleLab.text = @"- 批准";
//        }
//    }
}
+(CGFloat)height{
    return 50;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
