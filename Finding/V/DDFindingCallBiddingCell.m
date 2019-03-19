//
//  DDFindingCallBiddingCell.m
//  GongChengDD
//
//  Created by xzx on 2018/11/23.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDFindingCallBiddingCell.h"

@implementation DDFindingCallBiddingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleLab.textColor=KColorCompanyTitleBalck;
    self.titleLab.font=kFontSize34;
    
    self.detailLab.textColor=KColorGreySubTitle;
    self.detailLab.font=kFontSize28;
    
    self.moneyLab.textColor=KColorBlackTitle;
    self.moneyLab.font=kFontSize36;
    
    self.unitLab.text=@"";
    self.unitLab.textColor=KColorGreySubTitle;
    self.unitLab.font=kFontSize26;
    
    self.timeLab.textColor=KColorGreySubTitle;
    self.timeLab.font=kFontSize26;
    
    [self.buyBtn setTitle:@"买投标险" forState:UIControlStateNormal];
    [self.buyBtn setBackgroundColor:kColorWhite];
    self.buyBtn.titleLabel.font=kFontSize26;
    [self.buyBtn setTitleColor:KColorFindingPeopleBlue forState:UIControlStateNormal];
    self.buyBtn.layer.cornerRadius=3;
    self.buyBtn.layer.borderColor=KColorFindingPeopleBlue.CGColor;
    self.buyBtn.layer.borderWidth=0.5;
}

-(void)loadDataWithModel:(DDFindingCallBiddingModel *)model{
    self.titleLab.text=model.name;
    self.detailLab.text=model.title;
    if (![DDUtils isEmptyString:model.money_type]){
        if ([model.money_type integerValue] == 0) {
            
            if ([model.invite_amount integerValue] <100) {
                self.moneyLab.text=@"-";
            }else if (model.invite_amount.doubleValue>100000000 || model.invite_amount.doubleValue==100000000) {
                self.moneyLab.text=[self handleAmount2:model.invite_amount];
                self.unitLab.text=@"亿元";
            }
            else{
                self.moneyLab.text=[self handleAmount:model.invite_amount];
                self.unitLab.text=@"万元";
            }
        }else{
            self.moneyLab.text=model.invite_text;
            [self.moneyLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(WidthByiPhone6(270));
            }];
        }
    }else{
        self.moneyLab.text=@"-";
    }
    //self.moneyLab.text=model.invite_amount;
    if (model.updated_time.length>=10) {
        self.timeLab.text=[model.updated_time substringToIndex:10];
    }else{
        self.timeLab.text=model.updated_time;
    }
    
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

//#pragma mark 去除小数点后多余的0
//-(NSString *)removeFloatAllZero:(NSString *)string{
//    NSString * testNumber = string;
//    NSString * outNumber = [NSString stringWithFormat:@"%@",@(testNumber.floatValue)];
//    //价格格式化显示
//    NSNumberFormatter * formatter = [[NSNumberFormatter alloc]init];
//    formatter.numberStyle = kCFNumberFormatterNoStyle;
//    NSString * formatterString = [formatter stringFromNumber:[NSNumber numberWithFloat:[outNumber doubleValue]]];
//    //获取要截取的字符串位置
//    NSRange range = [formatterString rangeOfString:@"."];
//    if (range.length >0 ) {
//        NSString * result = [formatterString substringFromIndex:range.location];
//        if (result.length >= 4) {
//            formatterString = [formatterString substringToIndex:formatterString.length - 1];
//        }
//    }
//
//    return formatterString;
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
