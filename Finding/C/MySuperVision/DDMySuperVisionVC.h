//
//  DDMySuperVisionVC.h
//  GongChengDD
//
//  Created by xzx on 2018/11/22.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^refreshMyInfoNoticeItemBlock)(void);
@interface DDMySuperVisionVC : UIViewController
@property (nonatomic, copy) refreshMyInfoNoticeItemBlock refreshNoticeItemBlock;
@end

NS_ASSUME_NONNULL_END
