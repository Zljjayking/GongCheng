//
//  DDNewFindingWinBiddingProjectCell.m
//  GongChengDD
//
//  Created by hou qiangqiang on 2019/1/21.
//  Copyright © 2019 Koncendy. All rights reserved.
//

#import "DDNewFindingWinBiddingProjectCell.h"

@implementation DDNewFindingWinBiddingProjectCell

-(void)loadDataWithModel4:(DDNewInviteListModel *)model{
    if (![DDUtils isEmptyString:model.name]) {
        self.titleLab.text = [NSString stringWithFormat:@"[%@]%@",model.name,model.title];
    }else{
        self.titleLab.text = model.title;
    }
    
    self.winBiddingLab.text = model.win_bid_org;
    self.winBiddingLab.lineBreakMode = NSLineBreakByTruncatingTail;
    if (![DDUtils isEmptyString:model.money_type]) {
        if ([model.money_type integerValue] == 0) {
            self.priceLab2.text=[NSString stringWithFormat:@"%.2f万",model.win_bid_amount.floatValue/10000];
        }else{
            self.priceLab2.text=model.win_bid_text;
        }
    }else{
        self.priceLab2.text=@"-";
    }
    self.timeLab2.text=model.publish_date;
}
-(void)loadDataWithModel3:(DDSearchProjectListModel *)model{
    self.titleLab.attributedText = model.titleString;
    self.titleLab.font=kFontSize34;
    
    self.winBiddingLab.attributedText = model.winBidString;
    self.winBiddingLab.font=kFontSize28;
    
    if (![DDUtils isEmptyString:model.moneyType]) {
        if ([model.moneyType integerValue] == 0) {
            self.priceLab2.text=model.moneyString;
        }else{
            self.priceLab2.text=model.winBidText;
        }
    }else{
        self.priceLab2.text=@"-";
    }
    
    self.timeLab2.text=model.timeString;
}

-(void)loadDataWithModel5:(DDSearchProjectListModel *)model{
    
    if ([DDUtils isEmptyString:model.name]) {
        self.titleLab.text=model.title;
    }else{
        self.titleLab.text=[NSString stringWithFormat:@"[%@]%@",model.name,model.title];
    }
    
    self.winBiddingLab.text = model.win_bid_org;
    self.winBiddingLab.font=kFontSize28;
    self.winBiddingLab.textColor = KColorGreySubTitle;

    if (![DDUtils isEmptyString:model.money_type]) {
        if ([model.money_type integerValue] == 0) {
            if (![DDUtils isEmptyString:model.win_bid_amount]) {
                if([model.win_bid_amount integerValue]<100){
                    self.priceLab2.text=@"-";
                }
                else{
                    if (model.win_bid_amount.doubleValue>100000000 || model.win_bid_amount.doubleValue==100000000) {
                        self.priceLab2.text=[NSString stringWithFormat:@"%@亿",[self handleAmount2:model.win_bid_amount]];
                    }
                    else{
                        self.priceLab2.text=[NSString stringWithFormat:@"%@万",[self handleAmount:model.win_bid_amount]];
                    }
                }
            }
            else{
                self.priceLab2.text=@"-";
            }
            
        }else{
            self.priceLab2.text=model.win_bid_text;
        }
    }else{
        self.priceLab2.text=@"-";
    }
    self.timeLab2.text=model.publish_date;
}

-(void)loadDataWithModel:(DDSearchProjectListModel *)model{
    //self.titleLab.attributedText = model.titleString;
    if (![DDUtils isEmptyString:model.type]) {
        self.titleLab.text=[NSString stringWithFormat:@"[%@]%@",model.type,model.title];
    }else{
        self.titleLab.text=model.title;
    }
    self.winBiddingLab.attributedText = model.winBidString;
    self.winBiddingLab.font=kFontSize28;
    if (![DDUtils isEmptyString:model.moneyType]) {
        if ([model.moneyType integerValue] == 0) {
            self.priceLab2.text=model.moneyString;
        }else{
            self.priceLab2.text=model.winBidText;
        }
    }else{
        self.priceLab2.text=@"-";
    }
    
    self.timeLab2.text=model.timeString;
}



-(void)loadDataWithModel2:(DDMyCollectModel *)model{
    self.titleLab.text = model.title;
    self.titleLab.font=kFontSize34;
    
    self.winBiddingLab.text = model.winBidOrg;
    self.winBiddingLab.font=kFontSize28;
    self.winBiddingLab.lineBreakMode = NSLineBreakByTruncatingTail;
    
    NSString *moneyString;
    if (![DDUtils isEmptyString:model.winBidAmout]) {
        if([model.winBidAmout isEqualToString:@"0.00"]){
            moneyString=@"-";
        }
        else if([model.winBidAmout isEqualToString:@"0"]){
            moneyString=@"-";
        }
        else{
            moneyString=[NSString stringWithFormat:@"%.2f万",model.winBidAmout.floatValue/10000];
        }
    }
    else{
        moneyString=@"-";
    }
    self.priceLab2.text=moneyString;
    
    self.timeLab2.text=model.publishDate;
}

-(void)loadDataWithModel6:(DDMyCollectModel *)model{
    if ([DDUtils isEmptyString:model.name]) {
        self.titleLab.text=model.title;
    }else{
        self.titleLab.text=[NSString stringWithFormat:@"[%@]%@",model.name,model.title];
    }
    
    self.winBiddingLab.text = model.winBidOrg;
    self.winBiddingLab.font=kFontSize28;
    self.winBiddingLab.lineBreakMode = NSLineBreakByTruncatingTail;
    
    if (![DDUtils isEmptyString:model.money_type]) {
        if ([model.money_type integerValue] == 0) {
            if (![DDUtils isEmptyString:model.winBidAmout]) {
                if([model.winBidAmout integerValue]<100){
                    self.priceLab2.text=@"-";
                }
                else{
                    if (model.winBidAmout.doubleValue>100000000 || model.winBidAmout.doubleValue==100000000) {
                        self.priceLab2.text=[NSString stringWithFormat:@"%@亿",[self handleAmount2:model.winBidAmout]];
                    }
                    else{
                        self.priceLab2.text=[NSString stringWithFormat:@"%@万",[self handleAmount:model.winBidAmout]];
                    }
                }
            }
            else{
                self.priceLab2.text=@"-";
            }
            
        }else{
            self.priceLab2.text=model.win_bid_text;
        }
    }else{
        self.priceLab2.text=@"-";
    }
    
    self.timeLab2.text=model.publishDate;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = kColorWhite;
        [self.contentView  addSubview:self.titleLab];
        [self.contentView  addSubview:self.winLab];
        [self.contentView  addSubview:self.winBiddingLab];
        [self.contentView  addSubview:self.winBiddingBtn];
        [self.contentView  addSubview:self.priceLab2];
        [self.contentView  addSubview:self.priceLab1];
        [self.contentView  addSubview:self.timeLab1];
        [self.contentView  addSubview:self.timeLab2];
        kWeakSelf
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.contentView).offset(WidthByiPhone6(20));
            make.left.equalTo(weakSelf.contentView).offset(WidthByiPhone6(12));
            make.right.equalTo(weakSelf.contentView).offset(WidthByiPhone6(-12));
        }];
        [self.winLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.titleLab.mas_bottom).offset(WidthByiPhone6(20));
            make.left.equalTo(weakSelf.titleLab);
        }];
        [self.winBiddingLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.winLab);
            make.left.equalTo(weakSelf.winLab.mas_right).offset(WidthByiPhone6(5));
            make.width.mas_equalTo(Screen_Width-WidthByiPhone6(24)-70);
        }];
        [self.winBiddingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.winLab);
            make.left.equalTo(weakSelf.winLab.mas_right).offset(WidthByiPhone6(5));
            make.right.equalTo(weakSelf.titleLab);
        }];
        [self.priceLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.winBiddingLab.mas_bottom).offset(WidthByiPhone6(15));
            make.left.equalTo(weakSelf.winBiddingLab);
            make.right.equalTo(weakSelf.contentView).offset(WidthByiPhone6(-5));
        }];
        [self.priceLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.priceLab2);
            make.left.right.equalTo(weakSelf.winLab);
        }];
        [self.timeLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.priceLab2.mas_bottom).offset(WidthByiPhone6(15));
            make.left.equalTo(weakSelf.titleLab);
        }];
        [self.timeLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.timeLab1);
            make.left.equalTo(weakSelf.timeLab1.mas_right).offset(WidthByiPhone6(5));
            make.right.equalTo(weakSelf.titleLab);
        }];
        
    }
    return self;
}


-(NSString *)handleAmount:(NSString *)amount{
    //需要参与运算的两个数
    NSDecimalNumber *num = [NSDecimalNumber decimalNumberWithString:amount];
    NSDecimalNumber *w = [NSDecimalNumber decimalNumberWithString:@"10000"];
    
    //运算结果处理：小数精确到后2位，其余位无条件舍弃
    NSDecimalNumberHandler *handler = [NSDecimalNumberHandler
                                       decimalNumberHandlerWithRoundingMode:NSRoundDown//要使用的舍入模式
                                       scale:2             //结果保留几位小数
                                       raiseOnExactness:NO //发生精确错误时是否抛出异常，一般为NO
                                       raiseOnOverflow:NO  //发生溢出错误时是否抛出异常，一般为NO
                                       raiseOnUnderflow:NO //发生不足错误时是否抛出异常，一般为NO
                                       raiseOnDivideByZero:YES];//被0除时是否抛出异常，一般为YES
    
    //将两个数进行除法运算，并对结果加以处理(handler)
    num = [num decimalNumberByDividingBy:w withBehavior:handler];
    NSString *ret = [NSString stringWithFormat:@"%@", num];
    
    return ret;
    //return [self removeFloatAllZero:ret];
}

-(NSString *)handleAmount2:(NSString *)amount{
    //需要参与运算的两个数
    NSDecimalNumber *num = [NSDecimalNumber decimalNumberWithString:amount];
    NSDecimalNumber *w = [NSDecimalNumber decimalNumberWithString:@"100000000"];
    
    //运算结果处理：小数精确到后2位，其余位无条件舍弃
    NSDecimalNumberHandler *handler = [NSDecimalNumberHandler
                                       decimalNumberHandlerWithRoundingMode:NSRoundDown//要使用的舍入模式
                                       scale:2             //结果保留几位小数
                                       raiseOnExactness:NO //发生精确错误时是否抛出异常，一般为NO
                                       raiseOnOverflow:NO  //发生溢出错误时是否抛出异常，一般为NO
                                       raiseOnUnderflow:NO //发生不足错误时是否抛出异常，一般为NO
                                       raiseOnDivideByZero:YES];//被0除时是否抛出异常，一般为YES
    
    //将两个数进行除法运算，并对结果加以处理(handler)
    num = [num decimalNumberByDividingBy:w withBehavior:handler];
    NSString *ret = [NSString stringWithFormat:@"%@", num];
    
    return ret;
    //return [self removeFloatAllZero:ret];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark -- 懒加载
-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [UILabel labelWithFont:kFontSize34 textColor:KColorCompanyTitleBalck textAlignment:NSTextAlignmentLeft numberOfLines:0];
    }
    return _titleLab;
}
-(UILabel *)winLab{
    if (!_winLab) {
        _winLab = [UILabel labelWithFont:kFontSize28 textColor:KColorGreySubTitle textAlignment:NSTextAlignmentLeft numberOfLines:1];
        _winLab.text = @"中标人:";
    }
    return _winLab;
}
-(UILabel *)winBiddingLab{
    if (!_winBiddingLab) {
        _winBiddingLab = [UILabel labelWithFont:kFontSize28 textColor:kColorBlue textAlignment:NSTextAlignmentLeft numberOfLines:1];
    }
    return _winBiddingLab;
}
-(UIButton *)winBiddingBtn{
    if (!_winBiddingBtn) {
        _winBiddingBtn = [UIButton buttonWithbtnTitle:@"" textColor:kColorBlue textFont:kFontSize28 backGroundColor:kClearColor];
    }
    return _winBiddingBtn;
}
-(UILabel *)priceLab1{
    if (!_priceLab1) {
        _priceLab1 = [UILabel labelWithFont:kFontSize28 textColor:KColorGreySubTitle textAlignment:NSTextAlignmentLeft numberOfLines:1];
        _priceLab1.text = @"中标价:";
    }
    return _priceLab1;
}
-(UILabel *)priceLab2{
    if (!_priceLab2) {
        _priceLab2 = [UILabel labelWithFont:kFontSize28 textColor:KColorGreySubTitle textAlignment:NSTextAlignmentLeft numberOfLines:0];
    }
    return _priceLab2;
}
-(UILabel *)timeLab1{
    if (!_timeLab1) {
        _timeLab1 = [UILabel labelWithFont:kFontSize28 textColor:KColorGreySubTitle textAlignment:NSTextAlignmentLeft numberOfLines:1];
        _timeLab1.text=@"中标时间:";
    }
    return _timeLab1;
}
-(UILabel *)timeLab2{
    if (!_timeLab2) {
        _timeLab2 = [UILabel labelWithFont:kFontSize28 textColor:KColorGreySubTitle textAlignment:NSTextAlignmentLeft numberOfLines:1];
    }
    return _timeLab2;
}
@end
