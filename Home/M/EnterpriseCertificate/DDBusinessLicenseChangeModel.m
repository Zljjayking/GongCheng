//
//  DDBusinessLicenseChangeModel.m
//  GongChengDD
//
//  Created by csq on 2018/8/6.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDBusinessLicenseChangeModel.h"

@implementation DDBusinessLicenseChangeModel

- (void)handelData{
     //取变更前,变更后,长度较长的那个
    NSString * htmlString = @"";
    if (self.beforeHtmlValue.length > self.afterHtmlValue.length) {
        htmlString = self.beforeHtmlValue;
    }else{
        htmlString = self.afterValue;
    }
    
//    NSMutableAttributedString *  attributedString = [[NSMutableAttributedString alloc] initWithString:@"123"];
     NSMutableAttributedString *  attributedString  =  [[NSMutableAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    
    NSString * ponintStr =  [DDUtils transformAttributedText:attributedString];
    CGFloat pointStringHeight = [DDUtils heightForText:ponintStr withTextWidth:((Screen_Width/2)-30) withFont:kFontSize30];
    
    //缓存高度
    _longHTMLHeight = [NSNumber numberWithFloat:pointStringHeight];
    //NSLog(@"缓存的高度:%@",_longHTMLHeight);
    
    if (pointStringHeight > (11*20)) {//11行的高度
        //隐藏部分"变更记录"
        self.showAllContent = [NSNumber numberWithBool:NO];
        //显示"更多"按钮
        self.showMoreButton = [NSNumber numberWithBool:YES];
        
    }else{
        //完全显示"变更记录"
        self.showAllContent = [NSNumber numberWithBool:YES];
        //隐藏"更多"按钮
        self.showMoreButton = [NSNumber numberWithBool:NO];
        
    }
  
}
@end
