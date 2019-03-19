//
//  DDMyMonitorLoopsListModel.m
//  GongChengDD
//
//  Created by xzx on 2018/12/4.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDMyMonitorLoopsListModel.h"

@implementation LoopsLineSplitedModel

@end

@implementation LoopsRedirectParamMapModel

@end

@implementation DDMyMonitorLoopsListModel

-(void)handleModel{
    
    if (![DDUtils isEmptyString:_loopLineA]) {
        NSString *titleStr=[NSString stringWithFormat:@"<font color='#222222'>%@</font>",_loopLineA];
        NSAttributedString *title = [[NSAttributedString alloc] initWithData:[titleStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        _loopLineAString=title;
    }
    
    if (![DDUtils isEmptyString:_loopLineB]) {
        NSString *titleStr=[NSString stringWithFormat:@"<font color='#222222'>%@</font>",_loopLineB];
        NSAttributedString *title = [[NSAttributedString alloc] initWithData:[titleStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        _loopLineBString=title;
    }
    
}

@end
