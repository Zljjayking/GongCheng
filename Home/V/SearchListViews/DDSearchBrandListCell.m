//
//  DDSearchBrandListCell.m
//  GongChengDD
//
//  Created by xzx on 2018/9/25.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDSearchBrandListCell.h"

@implementation DDSearchBrandListCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
    self.brandTitleLab.textColor=KColorBlackTitle;
    self.brandTitleLab.font=kFontSize34;
    
    self.tipLab.textColor=kColorBlue;
    self.tipLab.font=kFontSize26;
    self.tipLab.layer.borderColor=kColorBlue.CGColor;
    self.tipLab.layer.borderWidth=0.5;
    self.tipLab.layer.cornerRadius=3;
    
    self.numberLab1.text=@"注册编号：";
    self.numberLab1.textColor=KColorGreySubTitle;
    self.numberLab1.font=kFontSize28;
    
    self.numberLab2.textColor=KColorGreySubTitle;
    self.numberLab2.font=kFontSize28;
    
    self.timeLab1.text=@"申请时间：";
    self.timeLab1.textColor=KColorGreySubTitle;
    self.timeLab1.font=kFontSize28;
    
    self.timeLab2.textColor=KColorGreySubTitle;
    self.timeLab2.font=kFontSize28;
    
    self.typeLab1.text=@"商标类型：";
    self.typeLab1.textColor=KColorGreySubTitle;
    self.typeLab1.font=kFontSize28;
    
    self.typeLab2.textColor=KColorGreySubTitle;
    self.typeLab2.font=kFontSize28;
    
    //加圆角
//    _brandImg.layer.cornerRadius = 3;
//    _brandImg.clipsToBounds = YES;
    //加边框
    _brandImg.layer.borderColor = KColorTableSeparator.CGColor;
    _brandImg.layer.borderWidth = 0.5;
    
    _brandImg.contentMode = UIViewContentModeScaleAspectFit;
    
    _brandImg.backgroundColor = [UIColor whiteColor];
    
}

-(void)loadDataWithModel:(DDSearchBrandListModel *)model{
    
    [self.brandImg sd_setImageWithURL:[NSURL URLWithString:model.brandImg] placeholderImage:[UIImage imageNamed:@"home_type_loading"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            self.brandImg.image= image;
        }
    }];
    
    self.brandTitleLab.attributedText = model.titleAttrStr;
    self.brandTitleLab.font=kFontSize34;
    
    if ([DDUtils isEmptyString:model.brandStatus] || [model.brandStatus isEqualToString:@"-"]) {//没有商标状态
        self.tipLab.hidden=YES;
        self.distanceUp.constant=12;
    }
    else{//有商标状态
        self.tipLab.text=[NSString stringWithFormat:@" %@ ",model.brandStatus];
        self.distanceUp.constant=48;
    }
    
    self.numberLab2.attributedText=model.registerIdAttrStr;
    self.numberLab2.font=kFontSize28;
    
    self.timeLab2.text=model.applicationDate;
    
    self.typeLab2.text=model.brandType;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
