//
//  DDProjectDetailInfoCell.m
//  GongChengDD
//
//  Created by xzx on 2018/5/23.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDProjectDetailInfoCell.h"

@implementation DDProjectDetailInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.titleLab.text=@"栖霞区石阜桥片区保障性住房项目";
    self.titleLab.textColor=KColorCompanyTitleBalck;;
    self.titleLab.font=KFontSize38;
    
    
    self.managerLab1.text=@"项目经理:";
    self.managerLab1.textColor=KColorGreySubTitle;
    self.managerLab1.font=kFontSize30;
    
    self.managerLab2.text=@"周毅";
    self.managerLab2.textColor=KColorBlackSubTitle;;
    self.managerLab2.font=kFontSize30;
    
    
    self.biddingPriceLab1.text=@"中标价:";
    self.biddingPriceLab1.textColor=KColorGreySubTitle;
    self.biddingPriceLab1.font=kFontSize30;
    
    self.biddingPriceLab2.text=@"87.73";
    self.biddingPriceLab2.textColor=KColorBlackSubTitle;;
    self.biddingPriceLab2.font=kFontSize30;
    
    
    self.biddingTimeLab1.text=@"中标时间:";
    self.biddingTimeLab1.textColor=KColorGreySubTitle;
    self.biddingTimeLab1.font=kFontSize30;
    
    self.biddingTimeLab2.text=@"2018-04-08";
    self.biddingTimeLab2.textColor=KColorBlackSubTitle;;
    self.biddingTimeLab2.font=kFontSize30;
}
+(CGFloat)height{
    return 170;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
