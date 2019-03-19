//
//  DDNewsCell.m
//  GongChengDD
//
//  Created by hou qiangqiang on 2019/1/22.
//  Copyright © 2019 Koncendy. All rights reserved.
//

#import "DDNewsCell.h"

@implementation DDNewsCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = kColorWhite;
        [self.contentView addSubview:self.iconImgV];
        [self.contentView addSubview:self.numL];
        [self.contentView addSubview:self.titleL];
        [self.contentView addSubview:self.arrowImgV];
        [self.contentView addSubview:self.lineL];
        kWeakSelf
        [self.iconImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView).offset(WidthByiPhone6(12));
            make.centerY.equalTo(weakSelf.contentView);
            make.width.height.mas_equalTo(WidthByiPhone6(44));
        }];
        [self.numL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.iconImgV.mas_right).offset(-WidthByiPhone6(13));
            make.top.equalTo(weakSelf.iconImgV.mas_top).offset(-WidthByiPhone6(2));
            make.width.height.mas_equalTo(WidthByiPhone6(15));
        }];
        [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.iconImgV.mas_right).offset(WidthByiPhone6(17));
            make.centerY.equalTo(weakSelf.contentView);
        }];
        [self.arrowImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.contentView).offset(WidthByiPhone6(-15));
            make.centerY.equalTo(weakSelf.contentView);
        }];
        [self.lineL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView).offset(WidthByiPhone6(12));
            make.bottom.right.equalTo(weakSelf.contentView);
            make.height.mas_equalTo(0.5);
        }];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark -- 懒加载
-(UIImageView *)iconImgV{
    if (!_iconImgV) {
        _iconImgV = [[UIImageView alloc]init];
        _iconImgV.layer.cornerRadius = WidthByiPhone6(22);
        _iconImgV.layer.masksToBounds = YES;
    }
    return _iconImgV;
}
-(UIImageView *)arrowImgV{
    if (!_arrowImgV) {
        _arrowImgV = [[UIImageView alloc]initWithImage:DDIMAGE(@"home_people_arrow")];
    }
    return _arrowImgV;
}
-(UILabel *)numL{
    if (!_numL) {
        _numL = [UILabel labelWithFont:kFontSize20 textColor:kColorWhite textAlignment:NSTextAlignmentCenter numberOfLines:1];
        _numL.backgroundColor=kColorRed;
        _numL.layer.cornerRadius=WidthByiPhone6(7.5);
        _numL.layer.masksToBounds=YES;
        _numL.hidden=YES;
    }
    return _numL;
}
-(UILabel *)titleL{
    if (!_titleL) {
        _titleL = [UILabel labelWithFont:kFontSize30 textColor:KColorBlackTitle textAlignment:NSTextAlignmentLeft numberOfLines:1];
    }
    return _titleL;
}
-(UILabel *)lineL{
    if (!_lineL) {
        _lineL = [[UILabel alloc]init];
        _lineL.backgroundColor = KColorTableSeparator;
    }
    return _lineL;
}
@end
