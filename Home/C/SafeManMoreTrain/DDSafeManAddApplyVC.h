//
//  DDSafeManAddApplyVC.h
//  GongChengDD
//
//  Created by xzx on 2018/7/18.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDBuilderAddApplyRecordModel.h"//model
@interface DDSafeManAddApplyVC : UIViewController

@property (nonatomic,strong) NSString *certType;// 2 安全员新培 3安全员继续教育（手动添加）
@property (nonatomic,strong) NSString *agencyName;//培训机构名称
@property (nonatomic,strong) NSString *agencyId;//培训机构ID
@property (nonatomic,strong) DDBuilderAddApplyRecordModel *model;

/// isFromeAddApply = 1 表明是从“添加报名”按钮点进来的   0 表明是从“在线报名”按钮点进来的
@property (nonatomic, strong) NSString *isFromeAddApply;
@end
