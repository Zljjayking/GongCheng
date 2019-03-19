//
//  DDManageListCell.m
//  GongChengDD
//
//  Created by csq on 2018/9/19.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDManageListCell.h"
#import "DDDateUtil.h"

@implementation DDManageListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    
    _authProjectLab.font = kFontSize32;
    _authProjectLab.textColor = KColorBlackTitle;
    
    _cerNumMarkLab.text = @"证书编号:";
    _cerNumMarkLab.font = kFontSize28;
    _cerNumMarkLab.textColor = KColorGreySubTitle;
//    _cerNumMarkLab.backgroundColor = [UIColor blueColor];
    
    _cerNumLab.font =kFontSize28;
    _cerNumLab.textColor = KColorGreySubTitle;
    
    _postCertDateMarkLab.text = @"发证日期:";
    _postCertDateMarkLab.font = kFontSize28;
    _postCertDateMarkLab.textColor = KColorGreySubTitle;
    
    _postCertDateLab.font =kFontSize28;
    _postCertDateLab.textColor = KColorGreySubTitle;
    
    _certEndDateMarkLab.text = @"有效期:";
    _certEndDateMarkLab.font = kFontSize28;
    _certEndDateMarkLab.textColor = KColorGreySubTitle;
    
    _certEndDateLab.font =kFontSize28;
    _certEndDateLab.textColor = KColorGreySubTitle;
}
- (void)loadWithModel:(DDManageListModel*)model{
    _authProjectLab.text = model.authProject;
    _cerNumLab.text = model.certNum;
    _postCertDateLab.text = model.postCertDate;
    _certEndDateLab.text = model.certEndDate;
    
    //如果后台返回的时间,不是标准时间,处理下
    NSString * tempDateString =[NSString stringWithFormat:@"%@",model.certEndDate]; ;
    if (![DDUtils isEmptyString:tempDateString]){
        NSString *resultStr = [DDUtils newCompareTimeSpaceIn180:tempDateString];
        if ([resultStr isEqualToString:@"2"]) {
            _certEndDateLab.textColor = KColorFindingPeopleBlue;
        }
        else if([resultStr isEqualToString:@"1"]){
            _certEndDateLab.textColor = KColorTextOrange;
        }
        else{
            _certEndDateLab.textColor = kColorRed;
        }
    }
    
    
    [self layoutIfNeeded];
}
- (CGFloat)height{
    CGFloat certEndDateLabBottom = BOTTOM(_certEndDateLab);
    return certEndDateLabBottom + 15;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
