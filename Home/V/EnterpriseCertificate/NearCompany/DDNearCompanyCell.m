//
//  DDNearCompanyCell.m
//  GongChengDD
//
//  Created by csq on 2018/10/19.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDNearCompanyCell.h"

@implementation DDNearCompanyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _companyName.textColor = KColorBlackTitle;
    _companyName.font = kFontSize34;
    
    _statesLab.font = kFontSize28;
    
    _redisterCaptalLab.textColor = KColorGreySubTitle;
    _redisterCaptalLab.font = kFontSize28;
    
    _certLab.textColor = KColorGreySubTitle;
    _certLab.font = kFontSize28;
    
    _distanceLab.textColor = KColorBlackSubTitle;
    _distanceLab.font = kFontSize28;
    
    _bottomLine.backgroundColor = KColorTableSeparator;
    
    _adressBgView.userInteractionEnabled = YES;
    UITapGestureRecognizer * tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(adressClick)];
    [_adressBgView addGestureRecognizer:tapGes];
    
    _adressImageView.image = [UIImage imageNamed:@"home_select_address"];
    
    _adressLab.font = kFontSize28;
    _adressLab.textColor = KColorBlackSubTitle;
    
    _arrow.image = [UIImage imageNamed:@"arrow_right"];
    
    //加圆角
    _statesBgView.layer.cornerRadius = 3;
    _statesBgView.clipsToBounds = YES;
    //加边框
    _statesBgView.layer.borderColor = kColorBlue.CGColor;
    _statesBgView.layer.borderWidth = 0.5;
    
}
- (void)loadWithModel:(DDNearCompanyResultModel*)model{
    
    _companyName.text = model.enterpriseName;
    
     _statesLab.text = model.status;
    
    if ([model.flagstatus isEqualToString:@"1"]) {
       _statesLab.textColor = kColorRed;
        _statesBgView.layer.borderColor = kColorRed.CGColor;
    }else{
        _statesLab.textColor = kColorBlue;
        _statesLab.layer.borderColor = kColorBlue.CGColor;
    }
    //如果状态为空,隐藏状态视图
    if (YES == [DDUtils isEmptyString:model.status]) {
        _statesLab.hidden = YES;
        _statesBgView.hidden = YES;
    }
   
    
    
    //距离
    //double newDist =  [model.dist doubleValue]*1000;
    //_distanceLab.text = [NSString stringWithFormat:@"%.0f米",newDist];
    _distanceLab.text=[NSString stringWithFormat:@"%@m",model.dist];
    
    if (![DDUtils isEmptyString:model.cert]) {
        _certLab.text = model.cert;
    }else{
        _certLab.text = @"-";
    }
    
    _adressLab.text = model.registerAddressSource;
    
    
    //后台返回的是元,转化成万元
    double newRegisterCapital = [model.registerCapital doubleValue]/10000;
    NSString * str1 = [NSString stringWithFormat:@"%.4f",newRegisterCapital];
    NSString * rsult1 = [DDUtils removeFloatAllZero:str1];//去掉末尾多余的0
    
    if ([model.registerCapitalCurrency isEqualToString:@"0"]) {//人民币
        if (![DDUtils isEmptyString:model.registerCapital]) {
            
            _redisterCaptalLab.text=[NSString stringWithFormat:@"注册资本:%@万人民币",rsult1];
            
        }
        else{
            _redisterCaptalLab.text=@"-";
        }
    }
    else{//美元
        if (![DDUtils isEmptyString:model.registerCapital]) {
        
            _redisterCaptalLab.text=[NSString stringWithFormat:@"注册资本:%@万美元",rsult1];
            
        }
        else{
             _redisterCaptalLab.text=@"-";
        }
    }
    
    [self layoutIfNeeded];
}
- (void)adressClick{
    if ([_delegate respondsToSelector:@selector(adressLabClick:)]) {
        [_delegate adressLabClick:self];
    }
}
+(CGFloat)height{
    return 172;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
