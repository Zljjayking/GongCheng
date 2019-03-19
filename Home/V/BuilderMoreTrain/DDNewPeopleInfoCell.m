//
//  DDNewPeopleInfoCell.m
//  GongChengDD
//
//  Created by hou qiangqiang on 2019/2/27.
//  Copyright © 2019 Koncendy. All rights reserved.
//

#import "DDNewPeopleInfoCell.h"

@interface DDNewPeopleInfoCell()

@end

@implementation DDNewPeopleInfoCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = kColorWhite;
        [self.contentView addSubview:self.nameLab];
        [self.contentView addSubview:self.arrowImgV];
        [self.contentView addSubview:self.uploadBtn];
        [self.contentView addSubview:self.uploadImgV];
        [self.contentView addSubview:self.imgSizeLab];
        [self.contentView addSubview:self.majorLab1];
        [self.contentView addSubview:self.majorLab2];
        [self.contentView addSubview:self.numberLab1];
        [self.contentView addSubview:self.numberLab2];
        [self.contentView addSubview:self.haveBLab1];
        [self.contentView addSubview:self.haveBLab2];
        [self.contentView addSubview:self.timeLab2];
        [self.contentView addSubview:self.timeLab1];
        kWeakSelf
        [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView).offset(WidthByiPhone6(12));
            make.top.equalTo(weakSelf.contentView).offset(WidthByiPhone6(20));
        }];
        [self.arrowImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.nameLab);
            make.right.equalTo(weakSelf.contentView).offset(WidthByiPhone6(-12));
            make.width.mas_equalTo(WidthByiPhone6(8));
            make.height.mas_equalTo(WidthByiPhone6(14));
        }];
        [self.uploadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.nameLab);
            make.right.equalTo(weakSelf.arrowImgV.mas_left).offset(WidthByiPhone6(-5));
        }];
        [self.uploadImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.nameLab);
            make.right.equalTo(weakSelf.arrowImgV.mas_left).offset(WidthByiPhone6(-5));
            make.width.mas_equalTo(WidthByiPhone6(60));
            make.height.mas_equalTo(WidthByiPhone6(37));
        }];
        [self.imgSizeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.uploadImgV);
            make.right.equalTo(weakSelf.uploadImgV.mas_left).offset(WidthByiPhone6(-5));
        }];
        [self.majorLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.nameLab);
            make.top.equalTo(weakSelf.nameLab.mas_bottom).offset(WidthByiPhone6(20));
        }];
        [self.majorLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.majorLab1.mas_right);
            make.centerY.equalTo(weakSelf.majorLab1);
        }];
        [self.numberLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.nameLab);
            make.top.equalTo(weakSelf.majorLab1.mas_bottom).offset(WidthByiPhone6(15));
        }];
        [self.numberLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.numberLab1.mas_right);
            make.centerY.equalTo(weakSelf.numberLab1);
        }];
        [self.haveBLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.nameLab);
            make.top.equalTo(weakSelf.numberLab1.mas_bottom).offset(WidthByiPhone6(15));
        }];
        [self.haveBLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.haveBLab1.mas_right);
            make.centerY.equalTo(weakSelf.haveBLab1);
        }];
        [self.timeLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.contentView).offset(-WidthByiPhone6(12));
            make.centerY.equalTo(weakSelf.haveBLab1);
        }];
        [self.timeLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.timeLab2.mas_left);
            make.centerY.equalTo(weakSelf.timeLab2);
        }];
        
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark -- lazyload
-(UILabel *)nameLab{
    if (!_nameLab) {
        _nameLab = [UILabel labelWithFont:kFontSize32 textColor:KColorBlackTitle textAlignment:NSTextAlignmentLeft numberOfLines:1];
    }
    return _nameLab;
}

-(UILabel *)majorLab1{
    if (!_majorLab1) {
        _majorLab1 = [UILabel labelWithFont:kFontSize26 textColor:KColorGreySubTitle textAlignment:NSTextAlignmentLeft numberOfLines:1];
    }
    return _majorLab1;
}
-(UILabel *)majorLab2{
    if (!_majorLab2) {
        _majorLab2 = [UILabel labelWithFont:kFontSize26 textColor:KColorBlackSubTitle textAlignment:NSTextAlignmentLeft numberOfLines:1];
    }
    return _majorLab2;
}
-(UILabel *)numberLab1{
    if (!_numberLab1) {
        _numberLab1 = [UILabel labelWithFont:kFontSize26 textColor:KColorGreySubTitle textAlignment:NSTextAlignmentLeft numberOfLines:1];
    }
    return _numberLab1;
}
-(UILabel *)numberLab2{
    if (!_numberLab2) {
        _numberLab2 = [UILabel labelWithFont:kFontSize26 textColor:KColorBlackSubTitle textAlignment:NSTextAlignmentLeft numberOfLines:1];
    }
    return _numberLab2;
}
-(UILabel *)haveBLab1{
    if (!_haveBLab1) {
        _haveBLab1 = [UILabel labelWithFont:kFontSize26 textColor:KColorGreySubTitle textAlignment:NSTextAlignmentLeft numberOfLines:1];
    }
    return _haveBLab1;
}
-(UILabel *)haveBLab2{
    if (!_haveBLab2) {
        _haveBLab2 = [UILabel labelWithFont:kFontSize26 textColor:kColorRed textAlignment:NSTextAlignmentLeft numberOfLines:1];
    }
    return _haveBLab2;
}
-(UILabel *)timeLab1{
    if (!_timeLab1) {
        _timeLab1 = [UILabel labelWithFont:kFontSize26 textColor:KColorGreySubTitle textAlignment:NSTextAlignmentLeft numberOfLines:1];
    }
    return _timeLab1;
}
-(UILabel *)timeLab2{
    if (!_timeLab2) {
        _timeLab2 = [UILabel labelWithFont:kFontSize26 textColor:kColorRed textAlignment:NSTextAlignmentLeft numberOfLines:1];
    }
    return _timeLab2;
}

-(UIButton *)uploadBtn{
    if (!_uploadBtn) {
        _uploadBtn = [UIButton buttonWithbtnTitle:@"上传报名截图" textColor:kColorBlue textFont:kFontSize28 backGroundColor:kColorWhite];
    }
    return _uploadBtn;
}
-(UIImageView *)arrowImgV{
    if (!_arrowImgV) {
        _arrowImgV = [[UIImageView alloc]initWithImage:DDIMAGE(@"arrow_right")];
    }
    return _arrowImgV;
}
-(UIImageView *)uploadImgV{
    if (!_uploadImgV) {
        _uploadImgV = [[UIImageView alloc]init];
        _uploadImgV.contentMode = UIViewContentModeScaleToFill;
        _uploadImgV.userInteractionEnabled = YES;
    }
    return _uploadImgV;
}

-(UILabel *)imgSizeLab{
    if (!_imgSizeLab) {
        _imgSizeLab = [UILabel labelWithFont:kFontSize26 textColor:[UIColor hexStringToColor:@"#25A5FE"] textAlignment:NSTextAlignmentRight numberOfLines:1];
    }
    return _imgSizeLab;
}

@end
