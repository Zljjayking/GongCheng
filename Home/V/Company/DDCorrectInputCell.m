//
//  DDCorrectInputCell.m
//  GongChengDD
//
//  Created by csq on 2018/5/29.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDCorrectInputCell.h"

@implementation DDCorrectInputCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _inputTextView.delegate = self;
    
    _line.backgroundColor = kColorBackGroundColor;
    
    _placeholderLab.textColor = KColorBidApprovalingWait;
    _placeholderLab.font = kFontSize28;
    _placeholderLab.text = @"感谢您帮我们发现了不足之处,请留下宝贵意见";
    
    _numLab.text = @"0/200";
    _numLab.textColor = KColorBidApprovalingWait;
    _numLab.font = kFontSize26;
    _numLab.textAlignment = NSTextAlignmentRight;
}
#pragma mark UITextViewDelegate
//- (void)textViewDidEndEditing:(UITextView *)textView{
////    NSLog(@"结束输入++");
//    if ([_delegate respondsToSelector:@selector(correctInputCellEndEditing:text:)]) {
//        [_delegate correctInputCellEndEditing:self text:textView.text];
//    }
//}
- (void)textViewDidChange:(UITextView *)textView{
    NSInteger kMaxLength = 200;//最大输入字数
    NSString *toBeString = textView.text;
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage;
    
    
    if ([lang isEqualToString:@"zh-Hans"]) { //中文输入
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        
        if (!position) {// 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            
            if (toBeString.length > kMaxLength) {
                textView.text = [toBeString substringToIndex:kMaxLength];
                
            }
        }else{//有高亮选择的字符串，则暂不对文字进行统计和限制
            
        }
    }else{//中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        
        if (toBeString.length > kMaxLength) {
            textView.text = [toBeString substringToIndex:kMaxLength];
        }
    }
    
    _summary = textView.text;
    
    [self changeNumLabelAndPlaceLab];
    [self delegateAction];
}
- (void)changeNumLabelAndPlaceLab{
    _numLab.text = [NSString stringWithFormat:@"%ld/200",(unsigned long)_summary.length];
    
    if (_summary.length>0) {
        _placeholderLab.hidden = YES;
    }else{
        _placeholderLab.hidden = NO;
    }
}
- (void)delegateAction{
    //代理
    if ([_delegate respondsToSelector:@selector(correctInputCellDidChange:text:)]) {
        [_delegate correctInputCellDidChange:self text:_summary];
    }
}

+(CGFloat)height{
    return 90;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
