//
//  DDSearchProjectListModel.m
//  GongChengDD
//
//  Created by xzx on 2018/5/23.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDSearchProjectListModel.h"

@implementation DDSearchProjectListModel

- (void)handle{
    if (![DDUtils isEmptyString:_title]) {
        if ([DDUtils isEmptyString:_type]) {
            NSString *titleStr=[NSString stringWithFormat:@"<font color='#111111'>%@</font>",_title];
            NSAttributedString *title = [[NSAttributedString alloc] initWithData:[titleStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
            _titleString=title;
        }
        else{
            NSString *titleStr=[NSString stringWithFormat:@"<font color='#111111'>[%@]%@</font>",_type,_title];
            NSAttributedString *title = [[NSAttributedString alloc] initWithData:[titleStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
            _titleString=title;
        }
    }
    
    if (![DDUtils isEmptyString:_winBidOrg]) {
        NSString *winBidStr=[NSString stringWithFormat:@"<font color='#3196fc'>%@</font>",_winBidOrg];
        NSAttributedString *winBid = [[NSAttributedString alloc] initWithData:[winBidStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        _winBidString=winBid;
    }
    
    if (![DDUtils isEmptyString:_projectManager]) {
        NSString *nameStr=[NSString stringWithFormat:@"<div style='text-align:center;'><font color='#3196fc'>%@</font></div>",_projectManager];
        NSAttributedString *peopleString = [[NSAttributedString alloc] initWithData:[nameStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        _peopleString=peopleString;
    }
    else{
        NSString *nameStr=@"<div style='text-align:center;'><font color='#3196fc'>-</font></div>";
        NSAttributedString *peopleString = [[NSAttributedString alloc] initWithData:[nameStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        _peopleString=peopleString;
    }
    
    if (![DDUtils isEmptyString:_amount]) {
        if([_amount integerValue]<100){
            _moneyString=@"-";
        }
        else{
            //_moneyString=[self removeFloatAllZero:[NSString stringWithFormat:@"%.2f万",_amount.floatValue/10000]];
            if (_amount.doubleValue>100000000 || _amount.doubleValue==100000000) {
                _moneyString=[NSString stringWithFormat:@"%@亿",[self handleAmount2:_amount]];
            }
            else{
                _moneyString=[NSString stringWithFormat:@"%@万",[self handleAmount:_amount]];
            }
        }
    }
    else{
        _moneyString=@"-";
    }
    
    _timeString=[DDUtils getDateLineByStandardTime:_publishDate];
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


@end


