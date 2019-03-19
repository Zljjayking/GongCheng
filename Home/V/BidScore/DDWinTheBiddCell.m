//
//  DDWinTheBiddCell.m
//  GongChengDD
//
//  Created by csq on 2018/5/30.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDWinTheBiddCell.h"

@implementation DDWinTheBiddCell

- (void)awakeFromNib {
    [super awakeFromNib];

    _titleLab.font = kFontSize34;
    _titleLab.textColor = KColorBlackTitle;
    
    _winBidOrgLab.textColor = KColorGreySubTitle;
    _winBidOrgLab.font = kFontSize28;
    
    _winBidOrgLab2.textColor = KColorBlackTitle;
    _winBidOrgLab2.font = kFontSize28;
    
    _projectMangerMark.textColor = KColorGreySubTitle;
    _projectMangerMark.font = kFontSize28;
    _projectMangerMark.text = @"项目经理";
    
    _projectManagerLab.textColor = kColorBlue;
    _projectManagerLab.font = kFontSize28;
    
    
    _winBidAmountMark.textColor = KColorGreySubTitle;
    _winBidAmountMark.font = kFontSize28;
    _winBidAmountMark.text = @"中标价";
    
    _winBidAmountLab.textColor =  KColorBlackTitle;
    _winBidAmountLab.font = kFontSize28;
    
    
    _publishDateMark.textColor = KColorGreySubTitle;
    _publishDateMark.font = kFontSize28;
    _publishDateMark.text = @"中标时间";
    
    _publishDateLab.textColor = KColorBlackTitle;
    _publishDateLab.font = kFontSize28;
    
    
    _centerLine1.backgroundColor = KColorTableSeparator;
    _centerLine2.backgroundColor = KColorTableSeparator;
    
}

- (void)loadWithModel:(DDWinTheBiddModel*)model{
    _titleLab.text = model.title;
    
    if ([model.type isEqualToString:@"1"] || [model.type isEqualToString:@"3"]) {//中标人
        _winBidOrgLab.text = @"中标人:";
    }
    else{//第一候选人
        _winBidOrgLab.text =@"第一候选人:";
    }
    
    _winBidOrgLab2.text = model.win_bid_org;
    
    if ([model.type isEqualToString:@"1"] || [model.type isEqualToString:@"3"]) {//中标价
        self.winBidAmountMark.text=@"中标价";
    }
    else{//第一候选人
        self.winBidAmountMark.text=@"投标报价";
    }
    
    if ([model.type isEqualToString:@"1"] || [model.type isEqualToString:@"3"]) {//中标时间
        _publishDateMark.text = @"中标时间";
    }
    else{//中标时间
        _publishDateMark.text = @"中标时间";
    }
    
    if (![DDUtils isEmptyString:model.project_manager]) {
        _projectManagerLab.text = model.project_manager;
    }
    else{
        _projectManagerLab.text = @"-";
    }
    
    //中标金额,有可能是金额或文本
    if ([model.money_type isEqualToString:@"0"]) {
        //数值
        if (![DDUtils isEmptyString:model.win_bid_amount]) {
            if([model.win_bid_amount isEqualToString:@"0.00"]){
                _winBidAmountLab.text=@"-";
            }
            else if([model.win_bid_amount isEqualToString:@"0"]){
                _winBidAmountLab.text=@"-";
            }
            else{
                CGFloat  winBidAmountFloat = [model.win_bid_amount floatValue];
                CGFloat newWinBidAmountFloat = winBidAmountFloat/10000;
                _winBidAmountLab.text = [NSString stringWithFormat:@"%.2f万",newWinBidAmountFloat];
            }
        }
        else{
            _winBidAmountLab.text=@"-";
        }
    }else{
        //文本
        if (![DDUtils isEmptyString:model.win_bid_text]) {
            _winBidAmountLab.text = model.win_bid_text;
        }
        else{
            _winBidAmountLab.text=@"-";
        }
    }
    
    
    
    if (![DDUtils isEmptyString:model.publish_date]) {
        _publishDateLab.text = model.publish_date;
    }
    else{
        _publishDateLab.text = @"-";
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
