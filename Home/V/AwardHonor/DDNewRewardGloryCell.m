//
//  DDNewRewardGloryCell.m
//  GongChengDD
//
//  Created by hou qiangqiang on 2019/1/23.
//  Copyright © 2019 Koncendy. All rights reserved.
//

#import "DDNewRewardGloryCell.h"

@implementation DDNewRewardGloryCell
-(void)loadDataWithModel:(DDSearchRewardGloryListModel *)model{
    if (![DDUtils isEmptyString:model.enterprise_name]) {
        NSString *titleStr=[NSString stringWithFormat:@"<font color='#222222'>%@</font>",model.enterprise_name];
        NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithData:[titleStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        
        self.nameLab.attributedText = attributeStr;
        self.nameLab.font=kFontSize34;
    }
    self.rewardLab2.text=model.reward_type;
    self.deptLab2.text=model.executor_defendant;
    self.timeLab2.text=model.reward_issue_time;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = kColorWhite;
        [self.contentView addSubview:self.nameLab];
        [self.contentView addSubview:self.rewardLab1];
        [self.contentView addSubview:self.rewardLab2];
        [self.contentView addSubview:self.deptLab1];
        [self.contentView addSubview:self.deptLab2];
        [self.contentView addSubview:self.timeLab1];
        [self.contentView addSubview:self.timeLab2];
        [self.contentView addSubview:self.arrowImgV];
        kWeakSelf
        [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView).offset(WidthByiPhone6(12));
            make.top.equalTo(weakSelf.contentView).offset(WidthByiPhone6(20));
            make.right.equalTo(weakSelf.contentView).offset(WidthByiPhone6(-12));
        }];
        [self.rewardLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.nameLab);
            make.top.equalTo(weakSelf.nameLab.mas_bottom).offset(WidthByiPhone6(20));
        }];
        [self.rewardLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView).offset(WidthByiPhone6(78));
            make.top.equalTo(weakSelf.rewardLab1);
            make.right.equalTo(weakSelf.contentView).offset(WidthByiPhone6(-37));
        }];
        [self.arrowImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.contentView).offset(WidthByiPhone6(-12));
            make.centerY.equalTo(weakSelf.contentView);
        }];
        [self.deptLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.nameLab);
            make.top.equalTo(weakSelf.rewardLab2.mas_bottom).offset(WidthByiPhone6(15));
            
        }];
        [self.deptLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView).offset(WidthByiPhone6(78));
            make.top.equalTo(weakSelf.deptLab1);
            make.right.equalTo(weakSelf.contentView).offset(WidthByiPhone6(-37));
        }];
        [self.timeLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.nameLab);
            make.top.equalTo(weakSelf.deptLab2.mas_bottom).offset(WidthByiPhone6(15));
        }];
        [self.timeLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView).offset(WidthByiPhone6(78));
            make.top.equalTo(weakSelf.timeLab1);
            make.right.equalTo(weakSelf.contentView).offset(WidthByiPhone6(-12));
        }];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark -- 懒加载
-(UILabel *)nameLab{
    if (!_nameLab) {
        _nameLab = [UILabel labelWithFont:kFontSize34 textColor:KColorBlackTitle textAlignment:NSTextAlignmentLeft numberOfLines:0];
    }
    return _nameLab;
}
-(UILabel *)rewardLab1{
    if (!_rewardLab1) {
        _rewardLab1 = [UILabel labelWithFont:kFontSize28 textColor:KColorGreySubTitle textAlignment:NSTextAlignmentLeft numberOfLines:1];
        _rewardLab1.text = @"获得奖项：";
    }
    return _rewardLab1;
}
-(UILabel *)rewardLab2{
    if (!_rewardLab2) {
        _rewardLab2 = [UILabel labelWithFont:kFontSize28 textColor:KColorGreySubTitle textAlignment:NSTextAlignmentLeft numberOfLines:0];
    }
    return _rewardLab2;
}
-(UILabel *)deptLab1{
    if (!_deptLab1) {
        _deptLab1 = [UILabel labelWithFont:kFontSize28 textColor:KColorGreySubTitle textAlignment:NSTextAlignmentLeft numberOfLines:1];
        _deptLab1.text = @"实施部门：";
    }
    return _deptLab1;
}
-(UILabel *)deptLab2{
    if (!_deptLab2) {
        _deptLab2 = [UILabel labelWithFont:kFontSize28 textColor:KColorGreySubTitle textAlignment:NSTextAlignmentLeft numberOfLines:0];
    }
    return _deptLab2;
}
-(UILabel *)timeLab1{
    if (!_timeLab1) {
        _timeLab1 = [UILabel labelWithFont:kFontSize28 textColor:KColorGreySubTitle textAlignment:NSTextAlignmentLeft numberOfLines:1];
        _timeLab1.text = @"发布时间：";
    }
    return _timeLab1;
}
-(UILabel *)timeLab2{
    if (!_timeLab2) {
        _timeLab2 = [UILabel labelWithFont:kFontSize28 textColor:KColorGreySubTitle textAlignment:NSTextAlignmentLeft numberOfLines:1];
    }
    return _timeLab2;
}
-(UIImageView *)arrowImgV{
    if(!_arrowImgV){
        _arrowImgV = [[UIImageView alloc]initWithImage:DDIMAGE(@"arrow_right")];
    }
    return _arrowImgV;
}
@end
