//
//  DDBusinesslicenseModel.m
//  GongChengDD
//
//  Created by csq on 2017/11/30.
//  Copyright © 2017年 Koncendy. All rights reserved.
//

#import "DDBusinesslicenseModel.h"

@implementation DDBusinesslicenseBranchModel

@end

@implementation DDBusinesslicenseModel

- (void)handleData{
    //显示登记信息
    self.showRegisterInfo = [NSNumber numberWithBool:YES];
    //显示分支机构
    self.showBranch = [NSNumber numberWithBool:YES];
   
    
    CGFloat businessScopeHeight = [DDUtils heightForText:self.businessScope withTextWidth:Screen_Width-24 withFont:kFontSize32];
    if (businessScopeHeight >40) {
        //不完全显示"经营范围"
        self.showAllMangerRange = [NSNumber numberWithBool:NO];
        //需要"查看更多"按钮
        self.showMoreButton = [NSNumber numberWithBool:YES];
    }else{
        //完全显示"经营范围"
        self.showAllMangerRange = [NSNumber numberWithBool:YES];
        //不需要"查看更多"按钮
        self.showMoreButton = [NSNumber numberWithBool:NO];
    }
}
@end
