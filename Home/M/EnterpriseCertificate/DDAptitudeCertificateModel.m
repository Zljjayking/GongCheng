//
//  DDAptitudeCertificateModel.m
//  GongChengDD
//
//  Created by csq on 2017/11/30.
//  Copyright © 2017年 Koncendy. All rights reserved.
//

#import "DDAptitudeCertificateModel.h"

@implementation DDAptitudeCertificateModel
- (NSString*)tranformLevel{
    if ([_issueDeptLevel isEqualToString:@"0"] || [_issueDeptLevel isEqualToString:@"1"]) {
        return @"部级";
    }else if ([_issueDeptLevel isEqualToString:@"2"]){
        return @"省级";
    }else if ([_issueDeptLevel isEqualToString:@"3"]){
        return @"市级";
    }else{
        return nil;
    }
}
@end
