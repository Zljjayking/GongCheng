//
//  DDUnInvoiceSucceedVC.h
//  GongChengDD
//
//  Created by hou qiangqiang on 2019/3/7.
//  Copyright © 2019 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDUnInvoiceSucceedVC : UIViewController
/// 发票类型
@property (nonatomic, assign) DDReceiptType type;
@property (nonatomic ,strong) NSString *isFromExam;//1考试培训
@end

NS_ASSUME_NONNULL_END
