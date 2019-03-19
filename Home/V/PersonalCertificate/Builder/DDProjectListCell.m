//
//  DDProjectListCell.m
//  GongChengDD
//
//  Created by xzx on 2018/5/23.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDProjectListCell.h"

@implementation DDProjectListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.titleLab.font=kFontSize34;
    
    self.winLab.text=@"中标人:";
    self.winLab.textColor=KColorGreySubTitle;
    self.winLab.font=kFontSize28;
    
    self.winBiddingLab.textColor=kColorBlue;
    self.winBiddingLab.font=kFontSize28;
    
    self.managerLab.text=@"项目经理";
    self.managerLab.textColor=KColorGreySubTitle;
    self.managerLab.font=kFontSize28;
    
    self.nameLab.textColor=kColorBlue;
    self.nameLab.font=kFontSize28;
    

    self.biddingPriceLab.text=@"中标价";
    self.biddingPriceLab.textColor=KColorGreySubTitle;
    self.biddingPriceLab.font=kFontSize28;
    
    self.moneyLab.textColor=KColorBlackTitle;
    self.moneyLab.font=kFontSize28;

    
    self.launchLab.text=@"中标时间";
    self.launchLab.textColor=KColorGreySubTitle;
    self.launchLab.font=kFontSize28;
    
    self.timeLab.textColor=KColorBlackTitle;
    self.timeLab.font=kFontSize28;
    
    self.line1.backgroundColor=KColorTableSeparator;
    
    self.line2.backgroundColor=KColorTableSeparator;
}

-(void)loadDataWithModel:(DDSearchProjectListModel *)model{
    self.titleLab.attributedText = model.titleString;
    self.titleLab.font=kFontSize34;
    
    self.winBiddingLab.attributedText = model.winBidString;
    self.winBiddingLab.font=kFontSize28;
    self.winBiddingLab.lineBreakMode = NSLineBreakByTruncatingTail;
    
    self.nameLab.attributedText = model.peopleString;
    self.nameLab.font=kFontSize28;
    
    self.moneyLab.text=model.moneyString;
    
    self.timeLab.text=model.timeString;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
