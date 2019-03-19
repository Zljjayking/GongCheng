//
//  DDPersonalCheckSuccessVC.h
//  GongChengDD
//
//  Created by xzx on 2018/9/28.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDPersonalCheckSuccessVC : UIViewController

@property (nonatomic,strong) NSString *type;//1表示是从申诉流程跳过来的
@property (nonatomic,copy) void(^popbackBlock)(void);

@end

NS_ASSUME_NONNULL_END
