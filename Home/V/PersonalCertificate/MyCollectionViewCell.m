//
//  MyCollectionViewCell.m
//  weiXinQianBao
//
//  Created by w on 16/6/3.
//  Copyright © 2016年 xzx. All rights reserved.
//

#import "MyCollectionViewCell.h"

@implementation MyCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
    self.label.backgroundColor=KColorCompanyTransfetGray;
    self.label.layer.cornerRadius=5;
    self.label.layer.masksToBounds=YES;
    self.label.font=kFontSize28;
    self.label.textColor=KColorBlackTitle;
}

@end
