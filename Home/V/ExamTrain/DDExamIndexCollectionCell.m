//
//  DDExamIndexCollectionCell.m
//  GongChengDD
//
//  Created by hou qiangqiang on 2019/2/21.
//  Copyright © 2019 Koncendy. All rights reserved.
//

#import "DDExamIndexCollectionCell.h"

@implementation DDExamIndexCollectionCell
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = kColorWhite;
        [self.contentView addSubview:self.iconImgV];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.typeLabel];
        kWeakSelf
        [self.iconImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.contentView);
            make.top.equalTo(weakSelf.contentView).offset(WidthByiPhone6(8.5));
            make.width.height.mas_equalTo(WidthByiPhone6(25));
        }];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.iconImgV.mas_bottom).offset(WidthByiPhone6(12));
            make.height.mas_equalTo(WidthByiPhone6(15));
            make.left.right.equalTo(weakSelf.contentView);
        }];
        [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.nameLabel.mas_bottom).offset(WidthByiPhone6(6));
            make.height.mas_equalTo(WidthByiPhone6(15));
            make.left.right.equalTo(weakSelf.contentView);
        }];
    }
    return self;
}

-(UIImageView *)iconImgV{
    if (!_iconImgV) {
        _iconImgV = [[UIImageView alloc]init];
    }
    return _iconImgV;
}
-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [UILabel labelWithFont:kFontSize28Bold textColor:KColorCompanyTitleBalck textAlignment:NSTextAlignmentCenter numberOfLines:1];
    }
    return _nameLabel;
}
-(UILabel *)typeLabel{
    if (!_typeLabel) {
        _typeLabel = [UILabel labelWithFont:kFontSize24 textColor:kColorGrey textAlignment:NSTextAlignmentCenter numberOfLines:1];
    }
    return _typeLabel;
}


@end
