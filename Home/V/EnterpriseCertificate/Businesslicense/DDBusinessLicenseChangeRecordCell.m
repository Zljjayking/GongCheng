//
//  DDBusinessLicenseChangeRecordCell.m
//  GongChengDD
//
//  Created by csq on 2018/7/3.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDBusinessLicenseChangeRecordCell.h"

@implementation DDBusinessLicenseChangeRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    _bgView.backgroundColor = kColorNavBarGray;
    _bgView.layer.cornerRadius = 5;
    _bgView.clipsToBounds = YES;
    
    
    _centreLine.backgroundColor = KColorTableSeparator;
    
    _beforeTitleLab.text = @"变更前";
    _beforeTitleLab.textColor = KColorGreySubTitle;
    _beforeTitleLab.font = kFontSize32;
    
    _afterTitleLab.text = @"变更后";
    _afterTitleLab.textColor = KColorGreySubTitle;
    _afterTitleLab.font = kFontSize32;
}

- (void)bgViewAddRoundedRect:(DDBusinessLicenseChangeModel*)model{
    BOOL showMoreButton = [model.showMoreButton boolValue];
    if (YES == showMoreButton) {
        //部分圆角
        UIBezierPath * fieldPath = [UIBezierPath bezierPathWithRoundedRect:_bgView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5 , 5)];
        CAShapeLayer * fieldLayer = [[CAShapeLayer alloc] init];
        fieldLayer.frame = _bgView.bounds;
        fieldLayer.path = fieldPath.CGPath;
        _bgView.layer.mask = fieldLayer;
    }else{
         //全部圆角
        _bgView.backgroundColor = kColorNavBarGray;
        _bgView.layer.cornerRadius = 5;
        _bgView.clipsToBounds = YES;
    }
  
}
- (void)loadWithModel:(DDBusinessLicenseChangeModel*)model{
    BOOL showAllContent = [model.showAllContent boolValue];
    
    if (YES == showAllContent) {
        //显示全部
        _beforeContentLab.numberOfLines = 0;
        _afterContentLab.numberOfLines = 0;
    }else{
        //隐藏部分 ,固定高度.11行的高度
        _beforeContentLab.numberOfLines = 11;
        _afterContentLab.numberOfLines = 11;
    }
    //加载HTML
    NSMutableAttributedString * before = [[NSMutableAttributedString alloc] initWithData:[model.beforeHtmlValue dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    //设置文本的字体大小
    [before addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0f] range:NSMakeRange(0, before.length)];
   _beforeContentLab.attributedText = before;
    
    //加载HTML
    NSMutableAttributedString * after = [[NSMutableAttributedString alloc] initWithData:[model.afterHtmlValue dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    //设置文本的字体大小
    [after addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0f] range:NSMakeRange(0, after.length)];
    _afterContentLab.attributedText = after;
}
+ (CGFloat)heightWithModel:(DDBusinessLicenseChangeModel*)model{
    BOOL showAllContent = [model.showAllContent boolValue];
    
    if (YES == showAllContent) {
        //显示全部
        //取变更前,变更后,长度较长的那个
        if (model.beforeHtmlValue.length > model.afterHtmlValue.length) {
            //加载HTML
          NSMutableAttributedString * attributedString= [[NSMutableAttributedString alloc] initWithData:[model.beforeHtmlValue dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
            
            NSString * ponintStr =  [DDUtils transformAttributedText:attributedString];
            CGFloat pointStringHeight = [DDUtils heightForText:ponintStr withTextWidth:((Screen_Width/2)-30) withFont:kFontSize30];
            return pointStringHeight +55;//变更内容+间隔,
        }else{
            //加载HTML
            NSMutableAttributedString * attributedString= [[NSMutableAttributedString alloc] initWithData:[model.afterHtmlValue dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
            
            NSString * ponintStr =  [DDUtils transformAttributedText:attributedString];
            CGFloat pointStringHeight = [DDUtils heightForText:ponintStr withTextWidth:((Screen_Width/2)-30) withFont:kFontSize30];
            return pointStringHeight +55;//变更内容+间隔,
        }
        
    }else{
        //隐藏部分 固定高度:11行的高度
        return (11*20) +55;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
