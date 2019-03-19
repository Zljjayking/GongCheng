//
//  DDSearchCompanyListModel.m
//  GongChengDD
//
//  Created by xzx on 2018/5/18.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDSearchCompanyListModel.h"

@implementation DDSearchCompanyListModel

- (void)handle{
    if (![DDUtils isEmptyString:_unitName]) {
        if ([_unitName containsString:@"font color"]) {
            NSString *titleStr=[NSString stringWithFormat:@"<font color='#111111'>%@</font>",_unitName];
            NSAttributedString *unitName = [[NSAttributedString alloc] initWithData:[titleStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
            _unitNameAttriStr=unitName;
        }else{
            _unitNameAttriStr = [[NSMutableAttributedString alloc]initWithString:_unitName];
        }
    }
    
    if (![DDUtils isEmptyString:_usedNames]) {
        NSString *titleStr=[NSString stringWithFormat:@"<font color='#888888'>曾用名：%@</font>",_usedNames];
        NSAttributedString *unitName = [[NSAttributedString alloc] initWithData:[titleStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        _usedNamesAttriString=unitName;
    }
    
    
    if (![DDUtils isEmptyString:_legalRepresentative]) {
        NSString *nameStr=[NSString stringWithFormat:@"<font color='#3196fc' size='4'>%@</font>",_legalRepresentative];
        NSAttributedString *peopleString = [[NSAttributedString alloc] initWithData:[nameStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        _peopleAttriString=peopleString;
    }
    
    if (![DDUtils isEmptyString:_cert]) {
        NSString *descStr=[NSString stringWithFormat:@"<font color='#888888'>%@</font>",_cert];
        NSMutableAttributedString *certString = [[NSMutableAttributedString alloc] initWithData:[descStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        _certAttriString=certString;
    }
    
    NSMutableString *areaStr=[[NSMutableString alloc]initWithString:@""];
    if ([_mergerName containsString:@","]) {
        NSArray *array=[_mergerName componentsSeparatedByString:@","];
        if (array.count>1) {
            for (int i=0; i<array.count; i++) {
                [areaStr appendString:array[i]];
            }
        }
    }
    else{
        if (![DDUtils isEmptyString:_mergerName]) {
            [areaStr appendString:_mergerName];
        }
    }
    if (![DDUtils isEmptyString:_mergerName]) {
        [areaStr appendString:@"/"];
    }
    _areaStr=areaStr;
}
@end
