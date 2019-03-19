//
//  DDBuilderAddApplyVC.h
//  GongChengDD
//
//  Created by xzx on 2018/7/17.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDBuilderAddApplyVC : UIViewController
@property (nonatomic,strong) NSString *agencyName;//培训机构名称
@property (nonatomic,strong) NSString *agencyId;//培训机构ID
/// isFromeAddApply = 1 表明是从“添加报名”按钮点进来的   0 表明是从“在线报名”按钮点进来的
@property (nonatomic, strong) NSString *isFromeAddApply;
@end
