//
//  DDProjectDetailInfoCell.m
//  GongChengDD
//
//  Created by xzx on 2018/5/23.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDProjectDetailInfoCell.h"
#import "DDLabelUtil.h"

@implementation DDProjectDetailInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.titleLab.text=@"栖霞区石阜桥片区保障性住房项目";
    self.titleLab.textColor=KColorCompanyTitleBalck;;
    self.titleLab.font=KFontSize38;
    
    
    self.managerLab1.text=@"项目经理:";
    self.managerLab1.textColor=KColorGreySubTitle;
    self.managerLab1.font=kFontSize30;
    
    self.managerLab2.text=@"周毅";
    self.managerLab2.textColor=KColorBlackSubTitle;;
    self.managerLab2.font=kFontSize30;
    
    
    self.biddingPriceLab1.text=@"中标价:";
    self.biddingPriceLab1.textColor=KColorGreySubTitle;
    self.biddingPriceLab1.font=kFontSize30;
    
    self.biddingPriceLab2.text=@"87.73";
    self.biddingPriceLab2.textColor=KColorBlackSubTitle;;
    self.biddingPriceLab2.font=kFontSize30;
    
    
    self.biddingTimeLab1.text=@"中标时间:";
    self.biddingTimeLab1.textColor=KColorGreySubTitle;
    self.biddingTimeLab1.font=kFontSize30;
    
    self.biddingTimeLab2.text=@"2018-04-08";
    self.biddingTimeLab2.textColor=KColorBlackSubTitle;;
    self.biddingTimeLab2.font=kFontSize30;
}

- (void)loadWithModel:(DDGainBiddingDetailModel*)model{
    if (![DDUtils isEmptyString:model.title]) {
        [DDLabelUtil setLabelSpaceWithLabel:_titleLab string:model.title font:KFontSize38];
    }
    else{
        _titleLab.text=@"";
    }
    
    if (![DDUtils isEmptyString:model.project_manager]) {
        _managerLab2.text=model.project_manager;
    }
    else{
        _managerLab2.text=@"-";
    }
    
    
    //中标金额,可能是文本或数值
    if ([model.money_type isEqualToString:@"0"]) {
        //数值
        if (![DDUtils isEmptyString:model.amount]) {
            if([model.amount isEqualToString:@"0.00"]){
                _biddingPriceLab2.text=@"-";
            }
            else if([model.amount isEqualToString:@"0"]){
                _biddingPriceLab2.text=@"-";
            }
            else{
                //NSString * tempAmout = [self removeFloatAllZeroByString:[NSString stringWithFormat:@"%f",model.amount.doubleValue/10000]];
                _biddingPriceLab2.text = [NSString stringWithFormat:@"%@万",[NSString stringWithFormat:@"%f",model.amount.doubleValue/10000]];
            }
        }
        else{
            _biddingPriceLab2.text=@"-";
        }
    }else{
        //文本
        if (![DDUtils isEmptyString:model.win_bid_text]) {
            _biddingPriceLab2.text=model.win_bid_text;
        }
        else{
          _biddingPriceLab2.text=@"-";
        }
    }
    if (![DDUtils isEmptyString:model.publish_date]) {
        _biddingTimeLab2.text=model.publish_date;
    }
    else{
        _biddingTimeLab2.text=@"-";
    }
    
}
+ (CGFloat)heightWithModel:(DDGainBiddingDetailModel*)model{
    return [DDLabelUtil getSpaceLabelHeightWithString:model.title font:KFontSize38 width:(Screen_Width-24)]+140;
}

#pragma mark 去除小数点后多余的0
- (NSString*)removeFloatAllZeroByString:(NSString *)testNumber{
    NSString * outNumber = [NSString stringWithFormat:@"%@",@(testNumber.doubleValue)];
    return outNumber;
}

#pragma mark --
//其它详情
- (void)loadWithProjectDetailModel:(DDProjectDetailModel*)model{
    if (![DDUtils isEmptyString:model.title]) {
        if (![DDUtils isEmptyString:model.projectTypeName]) {
            [DDLabelUtil setLabelSpaceWithLabel:_titleLab string:[NSString stringWithFormat:@"[%@]%@",model.projectTypeName,model.title] font:KFontSize38];
        }
        else{
            [DDLabelUtil setLabelSpaceWithLabel:_titleLab string:model.title font:KFontSize38];
        }
    }
    else{
        _titleLab.text=@"";
    }
    
    if (![DDUtils isEmptyString:model.project_manager]) {
        _managerLab2.text=model.project_manager;
    }
    else{
        _managerLab2.text=@"-";
    }
    
    if (![DDUtils isEmptyString:model.money_type]) {
        if ([model.money_type integerValue] == 0) {
            if (![DDUtils isEmptyString:model.amount]) {
                if([model.amount isEqualToString:@"0.00"]){
                    _biddingPriceLab2.text=@"-";
                }
                else if([model.amount isEqualToString:@"0"]){
                    _biddingPriceLab2.text=@"-";
                }
                else{
                    _biddingPriceLab2.text = [NSString stringWithFormat:@"%@万",[self handleAmount:model.amount]];
                }
            }
            else{
                _biddingPriceLab2.text=@"-";
            }
        }else{
            _biddingPriceLab2.text=model.win_bid_text;
        }
    }else{
        _biddingPriceLab2.text=@"-";
    }
    
    if (![DDUtils isEmptyString:model.publish_date]) {
        _biddingTimeLab2.text= model.publish_date;
    }
    else{
        _biddingTimeLab2.text=@"-";
    }
}

+ (CGFloat)heightWithProjectDetailModel:(DDProjectDetailModel*)model{
    NSString *titleStr = model.title;
    if (![DDUtils isEmptyString:model.projectTypeName]) {
        titleStr = [NSString stringWithFormat:@"[%@]%@",model.projectTypeName,model.title];
        
    }
    return [DDLabelUtil getSpaceLabelHeightWithString:titleStr font:KFontSize38 width:(Screen_Width-24)]+135;
}

-(NSString *)handleAmount:(NSString *)amount{
    //需要参与运算的两个数
    NSDecimalNumber *num = [NSDecimalNumber decimalNumberWithString:amount];
    NSDecimalNumber *w = [NSDecimalNumber decimalNumberWithString:@"10000"];
    
    //运算结果处理：小数精确到后2位，其余位无条件舍弃
    NSDecimalNumberHandler *handler = [NSDecimalNumberHandler
                                       decimalNumberHandlerWithRoundingMode:NSRoundDown//要使用的舍入模式
                                       scale:8            //结果保留几位小数
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
-(NSString *)removeFloatAllZero:(NSString *)string{
    NSString * testNumber = string;
    NSString * outNumber = [NSString stringWithFormat:@"%@",@(testNumber.floatValue)];
    //价格格式化显示
    NSNumberFormatter * formatter = [[NSNumberFormatter alloc]init];
    formatter.numberStyle = kCFNumberFormatterNoStyle;
    NSString * formatterString = [formatter stringFromNumber:[NSNumber numberWithFloat:[outNumber doubleValue]]];
    //获取要截取的字符串位置
    NSRange range = [formatterString rangeOfString:@"."];
    if (range.length >0 ) {
        NSString * result = [formatterString substringFromIndex:range.location];
        if (result.length >= 4) {
            formatterString = [formatterString substringToIndex:formatterString.length - 1];
        }
    }

    return formatterString;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
