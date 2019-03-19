//
//  DDMySuperVisionDynamicListVC.h
//  GongChengDD
//
//  Created by xzx on 2018/11/22.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^refreshNoticeRedSignBlock)(void);
@interface DDMySuperVisionDynamicListVC : UIViewController
@property (weak,nonatomic)UIViewController * mainViewContoller;
@property (nonatomic, copy) refreshNoticeRedSignBlock refreshNoticeBlock;
@end

NS_ASSUME_NONNULL_END
