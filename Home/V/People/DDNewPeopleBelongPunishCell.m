//
//  DDNewPeopleBelongPunishCell.m
//  GongChengDD
//
//  Created by hou qiangqiang on 2019/1/22.
//  Copyright © 2019 Koncendy. All rights reserved.
//

#import "DDNewPeopleBelongPunishCell.h"

@implementation DDNewPeopleBelongPunishCell

-(void)loadDataWithModel:(DDPeopleBelongPunishModel *)model{
    self.titleLab.text=model.punish_name;
    self.relativeLab2.text=model.project_ref;
    self.fireLab2.text=model.punish_case;
    self.kindLab2.text=model.punish_type;
    self.deptLab2.text=model.bulletin_department;
    self.timeLab2.text=model.punish_time;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = kColorWhite;
        [self.contentView  addSubview:self.titleLab];
        [self.contentView  addSubview:self.relativeLab1];
        [self.contentView  addSubview:self.relativeLab2];
        [self.contentView  addSubview:self.fireLab1];
        [self.contentView  addSubview:self.fireLab2];
        [self.contentView  addSubview:self.kindLab1];
        [self.contentView  addSubview:self.kindLab2];
        [self.contentView  addSubview:self.deptLab1];
        [self.contentView  addSubview:self.deptLab2];
        [self.contentView  addSubview:self.timeLab1];
        [self.contentView  addSubview:self.timeLab2];
        kWeakSelf
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.contentView).offset(WidthByiPhone6(20));
            make.left.equalTo(weakSelf.contentView).offset(WidthByiPhone6(12));
            make.right.equalTo(weakSelf.contentView).offset(WidthByiPhone6(-12));
        }];
        [self.relativeLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.titleLab.mas_bottom).offset(WidthByiPhone6(20));
            make.left.equalTo(weakSelf.titleLab);
        }];
        [self.relativeLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.relativeLab1);
            make.left.equalTo(weakSelf.contentView).offset(WidthByiPhone6(78));
            make.right.equalTo(weakSelf.contentView).offset(WidthByiPhone6(-12));
        }];
        [self.fireLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.relativeLab2.mas_bottom).offset(WidthByiPhone6(15));
            make.left.equalTo(weakSelf.relativeLab1);
        }];
        [self.fireLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.fireLab1);
            make.left.equalTo(weakSelf.contentView).offset(WidthByiPhone6(78));
            make.right.equalTo(weakSelf.contentView).offset(WidthByiPhone6(-12));
        }];
        [self.kindLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.fireLab2.mas_bottom).offset(WidthByiPhone6(15));
            make.left.equalTo(weakSelf.relativeLab1);
        }];
        [self.kindLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.kindLab1);
            make.left.equalTo(weakSelf.contentView).offset(WidthByiPhone6(78));
            make.right.equalTo(weakSelf.contentView).offset(WidthByiPhone6(-12));
        }];
        [self.deptLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.kindLab2.mas_bottom).offset(WidthByiPhone6(15));
            make.left.equalTo(weakSelf.relativeLab1);
        }];
        [self.deptLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.deptLab1);
            make.left.equalTo(weakSelf.contentView).offset(WidthByiPhone6(78));
            make.right.equalTo(weakSelf.contentView).offset(WidthByiPhone6(-12));
        }];
        [self.timeLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.deptLab2.mas_bottom).offset(WidthByiPhone6(15));
            make.left.equalTo(weakSelf.titleLab);
        }];
        [self.timeLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.timeLab1);
            make.left.equalTo(weakSelf.contentView).offset(WidthByiPhone6(78));
        }];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
#pragma mark -- 懒加载
-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [UILabel labelWithFont:kFontSize34 textColor:KColorBlackTitle textAlignment:NSTextAlignmentLeft numberOfLines:0];
    }
    return _titleLab;
}
-(UILabel *)relativeLab1{
    if (!_relativeLab1) {
        _relativeLab1 = [UILabel labelWithFont:kFontSize28 textColor:KColorGreySubTitle textAlignment:NSTextAlignmentLeft numberOfLines:1];
        _relativeLab1.text = @"关联项目:";
    }
    return _relativeLab1;
}
-(UILabel *)relativeLab2{
    if (!_relativeLab2) {
        _relativeLab2 = [UILabel labelWithFont:kFontSize28 textColor:KColorBlackTitle textAlignment:NSTextAlignmentLeft numberOfLines:0];
    }
    return _relativeLab2;
}
-(UILabel *)fireLab1{
    if (!_fireLab1) {
        _fireLab1 = [UILabel labelWithFont:kFontSize28 textColor:KColorGreySubTitle textAlignment:NSTextAlignmentLeft numberOfLines:1];
        _fireLab1.text = @"火灾处罚:";
    }
    return _fireLab1;
}
-(UILabel *)fireLab2{
    if (!_fireLab2) {
        _fireLab2 = [UILabel labelWithFont:kFontSize28 textColor:KColorBlackTitle textAlignment:NSTextAlignmentLeft numberOfLines:0];
    }
    return _fireLab2;
}
-(UILabel *)kindLab1{
    if (!_kindLab1) {
        _kindLab1 = [UILabel labelWithFont:kFontSize28 textColor:KColorGreySubTitle textAlignment:NSTextAlignmentLeft numberOfLines:1];
        _kindLab1.text = @"处罚种类:";
    }
    return _kindLab1;
}
-(UILabel *)kindLab2{
    if (!_kindLab2) {
        _kindLab2 = [UILabel labelWithFont:kFontSize28 textColor:KColorBlackTitle textAlignment:NSTextAlignmentLeft numberOfLines:0];
    }
    return _kindLab2;
}
-(UILabel *)deptLab1{
    if (!_deptLab1) {
        _deptLab1 = [UILabel labelWithFont:kFontSize28 textColor:KColorGreySubTitle textAlignment:NSTextAlignmentLeft numberOfLines:1];
        _deptLab1.text = @"承办单位:";
    }
    return _deptLab1;
}
-(UILabel *)deptLab2{
    if (!_deptLab2) {
        _deptLab2 = [UILabel labelWithFont:kFontSize28 textColor:KColorBlackTitle textAlignment:NSTextAlignmentLeft numberOfLines:0];
    }
    return _deptLab2;
}
-(UILabel *)timeLab1{
    if (!_timeLab1) {
        _timeLab1 = [UILabel labelWithFont:kFontSize28 textColor:KColorGreySubTitle textAlignment:NSTextAlignmentLeft numberOfLines:1];
        _timeLab1.text = @"处罚日期:";
    }
    return _timeLab1;
}
-(UILabel *)timeLab2{
    if (!_timeLab2) {
        _timeLab2 = [UILabel labelWithFont:kFontSize28 textColor:KColorBlackTitle textAlignment:NSTextAlignmentLeft numberOfLines:1];
    }
    return _timeLab2;
}


@end
