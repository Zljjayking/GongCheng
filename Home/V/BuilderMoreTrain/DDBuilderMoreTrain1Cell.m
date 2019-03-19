//
//  DDBuilderMoreTrain1Cell.m
//  GongChengDD
//
//  Created by xzx on 2018/6/27.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDBuilderMoreTrain1Cell.h"

@implementation DDBuilderMoreTrain1Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    self.nameLab.text=@"1.周毅";
    self.nameLab.textColor=KColorBidApprovalingWait;
    self.nameLab.font=kFontSize34;
    
    
    self.tempLab.text=@"临时";
    self.tempLab.textColor=KColorBidApprovalingWait;
    self.tempLab.font=kFontSize24;
    self.tempLab.textAlignment=NSTextAlignmentCenter;
    self.tempLab.layer.borderColor=KColorBidApprovalingWait.CGColor;
    self.tempLab.layer.borderWidth=0.5;
    self.tempLab.layer.cornerRadius=3;
    self.tempLab.clipsToBounds=YES;
    
    
    self.bidLab.text=@"已中标项目:0个";
    self.bidLab.textColor=KColorBidApprovalingWait;
    self.bidLab.font=kFontSize26;
    
    
    self.majorLab1.text=@"专业:";
    self.majorLab1.textColor=KColorBidApprovalingWait;
    self.majorLab1.font=kFontSize28;
    
    self.majorLab2.text=@"市政公用工程";
    self.majorLab2.textColor=KColorBidApprovalingWait;
    self.majorLab2.font=kFontSize28;
    
    
    self.numberLab1.text=@"证书编号:";
    self.numberLab1.textColor=KColorBidApprovalingWait;
    self.numberLab1.font=kFontSize28;
    
    self.numberLab2.text=@"苏232111218946";
    self.numberLab2.textColor=KColorBidApprovalingWait;
    self.numberLab2.font=kFontSize28;
    
    
    self.haveBLab1.text=@"B类证情况:";
    self.haveBLab1.textColor=KColorBidApprovalingWait;
    self.haveBLab1.font=kFontSize28;
    
    self.haveBLab2.text=@"有";
    self.haveBLab2.textColor=KColorBidApprovalingWait;
    self.haveBLab2.font=kFontSize28;
    
    
    self.timeLab1.text=@"有效期:";
    self.timeLab1.textColor=KColorBidApprovalingWait;
    self.timeLab1.font=kFontSize28;
    
    self.timeLab2.text=@"2018-04-10";
//    self.timeLab2.textColor=KColorBidApprovalingWait;
    self.timeLab2.font=kFontSize28;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
