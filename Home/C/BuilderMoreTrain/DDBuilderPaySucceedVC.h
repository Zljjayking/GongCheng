//
//  DDBuilderPaySucceedVC.h
//  GongChengDD
//
//  Created by xzx on 2018/12/29.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDBuilderPaySucceedVC : UIViewController
@property (nonatomic,strong) NSString *vcName;
@property (nonatomic,strong) NSString *orderId;
/// 发票类型
@property (nonatomic, assign) DDReceiptType receiptType;
/// isFromeAddApply = 1 表明是从添加报名按钮点进来的
@property (nonatomic, copy) NSString *isFromeAddApply;

/// isFromeExam = 1 表明是从培训报名进来的
@property (nonatomic, copy) NSString *isFromeExam;

@end

NS_ASSUME_NONNULL_END
