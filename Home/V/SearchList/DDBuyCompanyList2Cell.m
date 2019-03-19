//
//  DDBuyCompanyList2Cell.m
//  GongChengDD
//
//  Created by xzx on 2018/5/30.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDBuyCompanyList2Cell.h"

@implementation DDBuyCompanyList2Cell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.nameLab.text=@"南京建筑工程有限公司";
    self.nameLab.textColor=KColorBidApprovalingWait;
    self.nameLab.font=kFontSize34;
    
    self.descLab.text=@"城市及道路照明工程专业承包特级、建筑施工总承包";
    self.descLab.textColor=KColorBidApprovalingWait;
    self.descLab.font=kFontSize28;
    
    self.addressLab.text=@"江苏省南京市浦口区";
    self.addressLab.textColor=KColorBidApprovalingWait;
    self.addressLab.font=kFontSize28;
    
    self.unitLab.text=@"万元";
    self.unitLab.textColor=KColorBidApprovalingWait;
    self.unitLab.font=kFontSize30;
    
    self.moneyLab.text=@"500";
    self.moneyLab.textColor=KColorBidApprovalingWait;
    self.moneyLab.font=KFontSize42Bold;
    
    self.dealLab.text=@"成交价:";
    self.dealLab.textColor=KColorBidApprovalingWait;
    self.dealLab.font=kFontSize30;
    
    self.timeLab.text=@"2018年06月10日发布";
    self.timeLab.textColor=KColorBidApprovalingWait;
    self.timeLab.font=kFontSize28;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
