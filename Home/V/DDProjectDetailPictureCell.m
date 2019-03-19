//
//  DDProjectDetailPictureCell.m
//  GongChengDD
//
//  Created by xzx on 2018/5/23.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDProjectDetailPictureCell.h"
#import "DDLabelUtil.h"

@implementation DDProjectDetailPictureCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.headLab.text=@"原文快照";
    self.headLab.textColor=KColorBlackTitle;
    self.headLab.font=kFontSize30;
    
    
    self.descLab.textColor=KColorBidApprovalingWait;
    self.descLab.font=KFontSize22;
}

//加载数据
-(void)loadDataWithContent:(NSString *)content andPic:(NSString *)picture{
    if (![DDUtils isEmptyString:content]) {
        [DDLabelUtil setLabelSpace:self.descLab withValue:content withFont:KFontSize22];;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
