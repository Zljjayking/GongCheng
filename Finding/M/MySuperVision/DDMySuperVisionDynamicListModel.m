//
//  DDMySuperVisionDynamicListModel.m
//  GongChengDD
//
//  Created by xzx on 2018/12/1.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDMySuperVisionDynamicListModel.h"

@implementation LineSplitedModel

@end

@implementation RedirectParamMapModel

@end

@implementation DDMySuperVisionDynamicListModel

-(void)handleModel{
    
    if (![DDUtils isEmptyString:_lineC]) {
        NSString *titleStr=[NSString stringWithFormat:@"<font color='#444444'>%@</font>",_lineC];
        NSAttributedString *title = [[NSAttributedString alloc] initWithData:[titleStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        _lineCString=title;
    }
    
    if (![DDUtils isEmptyString:_lineB]) {
        NSString *titleStr=[NSString stringWithFormat:@"<font color='#444444'>%@</font>",_lineB];
        NSAttributedString *title = [[NSAttributedString alloc] initWithData:[titleStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        _lineBString=title;
    }
    
}

@end
