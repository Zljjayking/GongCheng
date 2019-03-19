//
//  DDSafeManNewAddApplyVC.h
//  GongChengDD
//
//  Created by xzx on 2018/7/23.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDBuilderAddApplyRecordModel.h"
@interface DDSafeManNewAddApplyVC : UIViewController

@property (nonatomic,strong) NSString *agencyName;//培训机构名称
@property (nonatomic,strong) NSString *agencyId;//培训机构ID
@property (nonatomic,strong) DDBuilderAddApplyRecordModel *model;
/// isFromeAddApply = 1 表明是从添加报名按钮点进来的
@property (nonatomic, copy) NSString *isFromeAddApply;
@end
