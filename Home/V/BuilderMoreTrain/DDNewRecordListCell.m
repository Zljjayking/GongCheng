//
//  DDNewRecordListCell.m
//  GongChengDD
//
//  Created by hou qiangqiang on 2019/3/4.
//  Copyright © 2019 Koncendy. All rights reserved.
//

#import "DDNewRecordListCell.h"

@implementation DDNewRecordListCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = kColorWhite;
        [self.contentView addSubview:self.companyLab];
        [self.contentView addSubview:self.arrowImg];
        [self.contentView addSubview:self.majorLab];
        [self.contentView addSubview:self.peopleLab];
        [self.contentView addSubview:self.statusLab];
        [self.contentView addSubview:self.numberLab];
       
        kWeakSelf
        [self.companyLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView).offset(WidthByiPhone6(12));
            make.top.equalTo(weakSelf.contentView).offset(WidthByiPhone6(12));
            make.width.mas_equalTo(WidthByiPhone6(210));
        }];
        [self.arrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.contentView);
            make.right.equalTo(weakSelf.contentView).offset(WidthByiPhone6(-12));
            make.width.mas_equalTo(WidthByiPhone6(8));
            make.height.mas_equalTo(WidthByiPhone6(14));
        }];
        [self.majorLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.companyLab);
            make.right.equalTo(weakSelf.arrowImg.mas_left).offset(WidthByiPhone6(-5));
            make.width.mas_equalTo(WidthByiPhone6(120));
        }];
        [self.peopleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.companyLab);
            make.top.equalTo(weakSelf.companyLab.mas_bottom).offset(WidthByiPhone6(15));
        }];
        [self.statusLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.arrowImg.mas_left).offset(WidthByiPhone6(-5));
            make.centerY.equalTo(weakSelf.peopleLab);
        }];
        [self.numberLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.peopleLab);
            make.left.equalTo(weakSelf.peopleLab.mas_right);
            make.right.equalTo(weakSelf.statusLab.mas_left).offset(-WidthByiPhone6(10));
        }];
        
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark -- lazyload
-(UILabel *)companyLab{
    if (!_companyLab) {
        _companyLab = [UILabel labelWithFont:kFontSize30 textColor:KColorGreySubTitle textAlignment:NSTextAlignmentLeft numberOfLines:1];
    }
    return _companyLab;
}
-(UILabel *)peopleLab{
    if (!_peopleLab) {
        _peopleLab = [UILabel labelWithFont:kFontSize30 textColor:KColorBlackTitle textAlignment:NSTextAlignmentLeft numberOfLines:1];
    }
    return _peopleLab;
}
-(UILabel *)majorLab{
    if (!_majorLab) {
        _majorLab = [UILabel labelWithFont:kFontSize30 textColor:KColorGreySubTitle textAlignment:NSTextAlignmentRight numberOfLines:1];
    }
    return _majorLab;
}
-(UILabel *)statusLab{
    if (!_statusLab) {
        _statusLab = [UILabel labelWithFont:kFontSize30 textColor:kColorBlue textAlignment:NSTextAlignmentRight numberOfLines:1];
    }
    return _statusLab;
}
-(UILabel *)numberLab{
    if (!_numberLab) {
        _numberLab = [UILabel labelWithFont:kFontSize30 textColor:KColorGreySubTitle textAlignment:NSTextAlignmentLeft numberOfLines:1];
    }
    return _numberLab;
}
-(UIImageView *)arrowImg{
    if (!_arrowImg) {
        _arrowImg = [[UIImageView alloc]initWithImage:DDIMAGE(@"home_com_more")];
    }
    return _arrowImg;
}
@end
