//
//  DDBuilderChangeRecordVC.h
//  GongChengDD
//
//  Created by xzx on 2018/9/28.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDBuilderChangeRecordVC : UIViewController

// 人员id
@property (nonatomic,copy) NSString *staffId;
 //1一级建造师 2二级建造师
@property (nonatomic,copy) NSString *type;
@property (weak,nonatomic)UIViewController * mainViewContoller;

@end

NS_ASSUME_NONNULL_END
