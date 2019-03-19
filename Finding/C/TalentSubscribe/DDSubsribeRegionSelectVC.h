//
//  DDSubsribeRegionSelectVC.h
//  GongChengDD
//
//  Created by xzx on 2018/11/26.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDSubsribeRegionSelectVC : UIViewController

@property (nonatomic,copy) void(^regionSelectBlock)(NSString *regionStr,NSString *regionId);

@end

NS_ASSUME_NONNULL_END
