//
//  DDAptitudeCerModel.m
//  GongChengDD
//
//  Created by csq on 2018/5/25.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDAptitudeCerModel.h"


@implementation DDSubitemModel

@end

@implementation DDAptitudeCerModel
//处理数据
- (void)handleData{
    if (self.subitem.count>3) {
        //隐藏全部条目
        self.showAllItems = [NSNumber numberWithBool:NO];
        //显示"查看更多"
        self.showMoreButton = [NSNumber numberWithBool:YES];
    }else{
        //显示全部条目
        self.showAllItems = [NSNumber numberWithBool:YES];
        //不显示"查看更多"
        self.showMoreButton = [NSNumber numberWithBool:NO];
    }
}
@end
